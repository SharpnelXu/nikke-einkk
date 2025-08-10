import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/module/api/data_downloader.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

class InAppShopPage extends StatefulWidget {
  const InAppShopPage({super.key});

  @override
  State<InAppShopPage> createState() => _InAppShopPageState();
}

class _InAppShopPageState extends State<InAppShopPage> {
  int? orderId;

  bool get useGlobal => userDb.useGlobal;
  NikkeDatabase get db => userDb.gameDb;

  @override
  Widget build(BuildContext context) {
    final shopCategories =
        db.inAppShopManager.keys
            .sorted((a, b) => a.compareTo(b))
            .map((id) => DropdownMenuEntry(value: id, label: 'Shop ${db.inAppShopManager[id]!.first.mainCategoryType}'))
            .toList();

    final shopCategory = db.inAppShopManager[orderId ?? 200];

    final List<Widget> children = [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5,
        children: [
          Text('Server Select: ', style: TextStyle(fontSize: 20)),
          Radio(value: true, groupValue: useGlobal, onChanged: serverRadioChange),
          Text('Global', style: TextStyle(fontWeight: useGlobal ? FontWeight.bold : null)),
          Radio(value: false, groupValue: useGlobal, onChanged: serverRadioChange),
          Text('CN', style: TextStyle(fontWeight: !useGlobal ? FontWeight.bold : null)),
          SizedBox(width: 15),
          Text('Select Shop: ', style: TextStyle(fontSize: 20)),
          DropdownMenu(
            width: 250,
            initialSelection: orderId ?? 200,
            onSelected: (v) {
              orderId = v;
              setState(() {});
            },
            dropdownMenuEntries: shopCategories,
          ),
        ],
      ),
      if (!db.initialized)
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white)),
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (ctx) => StaticDataDownloadPage()));
            setState(() {});
          },
          child: Text('Data not initialized! Click to download'),
        ),
      if (shopCategory != null) Align(child: ShopDisplay(shopCategory: shopCategory)),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('In App Shop Data')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (ctx, idx) => children[idx],
          separatorBuilder: (ctx, idx) => SizedBox(height: 10),
          itemCount: children.length,
        ),
      ),
      bottomNavigationBar: commonBottomNavigationBar(() => setState(() {})),
    );
  }

  void serverRadioChange(bool? v) {
    userDb.useGlobal = v ?? useGlobal;
    if (!db.coopRaidData.keys.contains(orderId)) {
      orderId = null;
    }
    if (mounted) setState(() {});
  }
}

class ShopDisplay extends StatefulWidget {
  final List<InAppShopData> shopCategory;
  const ShopDisplay({super.key, required this.shopCategory});

  @override
  State<ShopDisplay> createState() => _ShopDisplayState();
}

class _ShopDisplayState extends State<ShopDisplay> {
  int? shopId;
  NikkeDatabase get db => userDb.gameDb;

  @override
  Widget build(BuildContext context) {
    final Map<int, InAppShopData> shopMap = {};
    for (final data in widget.shopCategory) {
      shopMap[data.id] = data;
    }
    final shopIds =
        widget.shopCategory
            .sorted((a, b) => a.id.compareTo(b.id))
            .map(
              (shop) => DropdownMenuEntry(
                value: shop.id,
                label: 'Shop ${shop.id}: ${locale.getTranslation(shop.subCategoryNameKey)}',
              ),
            )
            .toList();

    final shopData = shopMap[shopId] ?? shopMap[shopIds.last.value]!;
    final List<Widget> children = [];
    if (shopData.shopCategory == ShopCategory.renewPackageShop ||
        shopData.shopCategory == ShopCategory.timeLimitPackageShop) {
      final packages =
          db.packageListData[shopData.packageShopId]
              ?.sorted((a, b) => a.packageOrder.compareTo(b.packageOrder))
              .toList() ??
          [];
      children.addAll(packages.map(buildPackage));
    } else {
      children.add(Text('Package Shop ID: ${shopData.packageShopId}'));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Text(widget.shopCategory.first.mainCategoryType, style: TextStyle(fontSize: 20)),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Select Shop', style: TextStyle(fontSize: 20)),
            DropdownMenu(
              width: 250,
              initialSelection: shopData.id,
              onSelected: (v) {
                shopId = v;
                setState(() {});
              },
              dropdownMenuEntries: shopIds,
            ),
          ],
        ),
        Text(
          locale.getTranslation(shopData.subCategoryNameKey) ?? shopData.subCategoryNameKey,
          style: TextStyle(fontSize: 20),
        ),
        Text(locale.getTranslation(shopData.nameKey) ?? shopData.nameKey, style: TextStyle(fontSize: 18)),
        Text(locale.getTranslation(shopData.descriptionKey) ?? shopData.descriptionKey),
        if (shopData.startDate != null || shopData.endDate != null)
          Wrap(
            spacing: 5,
            children: [
              if (shopData.startDate != null) Text('Start Date: ${shopData.startDate}'),
              if (shopData.endDate != null) Text('End Date: ${shopData.endDate}'),
            ],
          ),
        Wrap(spacing: 5, runSpacing: 5, children: children),
      ],
    );
  }

  Widget buildPackage(PackageListData package) {
    final packageGroups = db.packageGroupData[package.productId] ?? [];
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Text(locale.getTranslation(package.nameKey) ?? package.nameKey, style: TextStyle(fontSize: 18)),
          DescriptionTextWidget(locale.getTranslation(package.descriptionKey) ?? package.descriptionKey),
          Text('Group: ${package.productId}'),
          ...packageGroups.map(buildProduct),
        ],
      ),
    );
  }

  Widget buildProduct(PackageProductData data) {
    if (data.productType == ProductType.currency) {
      final currency = db.currencyTable[data.productId];
      return Tooltip(
        message: locale.getTranslation(currency?.descriptionKey) ?? 'Unknown Product',
        child: Text('${locale.getTranslation(currency?.nameKey) ?? currency?.nameKey} × ${data.productValue}'),
      );
    } else if (data.productType == ProductType.item) {
      final item = db.simplifiedItemTable[data.productId];
      return Tooltip(
        message: locale.getTranslation(item?.descriptionKey) ?? 'Unknown Product',
        child: Text('${locale.getTranslation(item?.nameKey) ?? item?.nameKey} × ${data.productValue}'),
      );
    } else {
      return Text('${data.productId} (${data.rawProductType}): ${data.productValue}');
    }
  }
}
