import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/monster.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/monsters/rapture_display.dart';

class MonsterListPage extends StatefulWidget {
  const MonsterListPage({super.key});

  @override
  State<MonsterListPage> createState() => _MonsterListPageState();
}

class _MonsterListPageState extends State<MonsterListPage> {
  bool useGlobal = true;
  final filterData = MonsterFilterData();
  final searchController = TextEditingController();

  NikkeDatabaseV2 get db => useGlobal ? global : cn;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  void serverRadioChange(bool? v) {
    useGlobal = v ?? useGlobal;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final searchRow = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 8,
        children: [
          FilledButton(
            onPressed: () {
              if (searchController.text != (filterData.search ?? '')) {
                filterData.search = searchController.text;
                setState(() {});
              }
            },
            child: Text('Search ID or Name'),
          ),
          Expanded(child: TextField(controller: searchController)),
        ],
      ),
    );

    final elementsFilterRow = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 8,
        children: [
          Text('Element: '),
          ...List.generate(MonsterFilterData.defaultElements.length, (index) {
            final buttonEle = MonsterFilterData.defaultElements[index];
            final enabled = filterData.elements.contains(buttonEle);
            return FilledButton(
              style: FilledButton.styleFrom(
                foregroundColor: enabled ? Colors.white : Colors.black,
                backgroundColor: enabled ? buttonEle.color : Colors.white,
              ),
              onPressed: () {
                if (enabled) {
                  filterData.elements.remove(buttonEle);
                } else {
                  filterData.elements.add(buttonEle);
                }
                if (mounted) setState(() {});
              },
              child: Text(buttonEle.name.toUpperCase()),
            );
          }),
        ],
      ),
    );

    final raptures = db.raptureData.values.where((data) => filterData.shouldInclude(data)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            Text('Raptures'),
            Radio(value: true, groupValue: useGlobal, onChanged: serverRadioChange),
            Text('Global', style: TextStyle(fontWeight: useGlobal ? FontWeight.bold : null)),
            Radio(value: false, groupValue: useGlobal, onChanged: serverRadioChange),
            Text('CN', style: TextStyle(fontWeight: !useGlobal ? FontWeight.bold : null)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            searchRow,
            elementsFilterRow,
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, idx) {
                  final raptureData = raptures[idx];
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => RaptureDataDisplayPage(useGlobal: useGlobal, data: raptureData),
                            ),
                          );
                        },
                        child: Text('${locale.getTranslation(raptureData.nameKey)}, ID: ${raptureData.id}'),
                      ),
                    ),
                  );
                },
                itemCount: raptures.length,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: commonBottomNavigationBar(() => setState(() {})),
    );
  }
}

class MonsterFilterData {
  static List<NikkeElement> defaultElements = NikkeElement.values.where((ele) => ele != NikkeElement.unknown).toList();

  String? search;
  List<NikkeElement> elements = [];

  bool shouldInclude(MonsterData data) {
    final idMatch = search == null || '${data.id}'.contains(search!);
    final name = locale.getTranslation(data.nameKey) ?? data.nameKey;
    final nameMatch = search == null || name.contains(search!);
    final eleMatch = elements.isEmpty || data.elementIds.any((eleId) => elements.contains(NikkeElement.fromId(eleId)));

    return (idMatch || nameMatch) && eleMatch;
  }

  void reset() {
    elements.clear();
  }
}
