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
    } else if (shopData.shopCategory == ShopCategory.stepUpPackageShop) {
      final stepUps =
          db.stepUpPackageGroupData[shopData.packageShopId]?.sorted((a, b) => a.step.compareTo(b.step)).toList() ?? [];
      children.addAll(stepUps.map(buildStepUp));
    } else if (shopData.shopCategory == ShopCategory.customPackageShop) {
      final customShopData =
          db.customPackageShopData[shopData.packageShopId]
              ?.sorted((a, b) => a.customOrder.compareTo(b.customOrder))
              .toList() ??
          [];
      children.addAll(customShopData.map(buildCustomPackage));
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

  Widget buildCustomPackage(CustomPackageShopData customPackage) {
    final packageGroups = db.packageGroupData[customPackage.packageGroupId] ?? [];
    final price = db.midasProductTable[customPackage.packageGroupId]?.cost ?? '?';
    final customPackageSlotsData = db.customPackageSlotData[customPackage.customGroupId] ?? [];
    final Map<int, List<CustomPackageSlotData>> slots = {};
    for (final customPackageSlot in customPackageSlotsData) {
      slots.putIfAbsent(customPackageSlot.slotNumber, () => []);
      slots[customPackageSlot.slotNumber]!.add(customPackageSlot);
    }

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
          Text(
            '${locale.getTranslation(customPackage.nameKey) ?? customPackage.nameKey} ($price)',
            style: TextStyle(fontSize: 18),
          ),
          DescriptionTextWidget(locale.getTranslation(customPackage.descriptionKey) ?? customPackage.descriptionKey),
          ...packageGroups.map((data) => buildProduct(data.productType, data.productId, data.productValue)),
          ...slots.keys.map((slot) => buildCustomPackageSlot(slot, slots[slot]!)),
        ],
      ),
    );
  }

  Widget buildCustomPackageSlot(int slotNum, List<CustomPackageSlotData> customPackageSlots) {
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
          Text('Slot $slotNum'),
          ...customPackageSlots.map((slotData) {
            return buildProduct(slotData.productType, slotData.productId, slotData.productValue);
          }),
        ],
      ),
    );
  }

  Widget buildStepUp(StepUpPackageData stepUp) {
    final packageGroups = db.packageGroupData[stepUp.packageGroupId] ?? [];
    final price = db.midasProductTable[stepUp.id]?.cost ?? '?';
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
          Text('${locale.getTranslation(stepUp.nameKey) ?? stepUp.nameKey} ($price)', style: TextStyle(fontSize: 18)),
          DescriptionTextWidget(locale.getTranslation(stepUp.descriptionKey) ?? stepUp.descriptionKey),
          Text('Step ${stepUp.step}'),
          ...packageGroups.map((data) => buildProduct(data.productType, data.productId, data.productValue)),
        ],
      ),
    );
  }

  Widget buildPackage(PackageListData package) {
    final packageGroups = db.packageGroupData[package.productId] ?? [];
    final price = db.midasProductTable[package.productId]?.cost ?? '?';
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
          Text('${locale.getTranslation(package.nameKey) ?? package.nameKey} ($price)', style: TextStyle(fontSize: 18)),
          DescriptionTextWidget(locale.getTranslation(package.descriptionKey) ?? package.descriptionKey),
          ...packageGroups.map((data) => buildProduct(data.productType, data.productId, data.productValue)),
        ],
      ),
    );
  }

  Widget buildProduct(ProductType productType, int productId, int productValue) {
    if (productType == ProductType.currency) {
      final currency = db.currencyTable[productId];
      return Tooltip(
        message: locale.getTranslation(currency?.descriptionKey) ?? 'Unknown Product',
        child: Text('${locale.getTranslation(currency?.nameKey) ?? currency?.nameKey} × $productValue'),
      );
    } else if (productType == ProductType.item) {
      final item = db.simplifiedItemTable[productId];
      return Tooltip(
        message: locale.getTranslation(item?.descriptionKey) ?? 'Unknown Product',
        child: Text('${locale.getTranslation(item?.nameKey) ?? item?.nameKey} × $productValue'),
      );
    } else {
      return Text('$productId (${productType.name}): $productValue');
    }
  }
}
