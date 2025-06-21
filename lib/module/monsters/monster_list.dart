import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/rapture_display.dart';

class MonsterListPage extends StatefulWidget {
  const MonsterListPage({super.key});

  @override
  State<MonsterListPage> createState() => _MonsterListPageState();
}

class _MonsterListPageState extends State<MonsterListPage> {
  bool useGlobal = true;

  NikkeDatabaseV2 get db => useGlobal ? global : cn;

  void serverRadioChange(bool? v) {
    useGlobal = v ?? useGlobal;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final raptures = db.raptureData.keys.toList();
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
        child: ListView.builder(
          itemBuilder: (ctx, idx) {
            final raptureData = db.raptureData[raptures[idx]]!;
            return Align(
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
      bottomNavigationBar: commonBottomNavigationBar(() => setState(() {})),
    );
  }
}
