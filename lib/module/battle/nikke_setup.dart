import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/user_data.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/nikkes/nikke_list.dart';
import 'package:nikke_einkk/module/nikkes/nikke_setup_widgets.dart';
import 'package:nikke_einkk/module/nikkes/nikke_widgets.dart';

class NikkeSelectorPage extends StatefulWidget {
  final bool useGlobal;

  const NikkeSelectorPage({super.key, required this.useGlobal});

  @override
  State<NikkeSelectorPage> createState() => _NikkeSelectorPageState();
}

class _NikkeSelectorPageState extends State<NikkeSelectorPage> {
  bool get useGlobal => widget.useGlobal;
  NikkeDatabase get db => useGlobal ? global : cn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a Nikke')),
      bottomNavigationBar: commonBottomNavigationBar(() => setState(() {})),
      body: NikkeGrids(
        includeInvisible: true,
        onCall: (data) {
          Navigator.pop(context, data.resourceId);
        },
      ),
    );
  }
}

class NikkeEditorPage extends StatefulWidget {
  final bool useGlobal;
  final Map<int, int> cubeLvs;
  final NikkeOptions option;

  const NikkeEditorPage({super.key, required this.useGlobal, required this.option, required this.cubeLvs});

  @override
  State<NikkeEditorPage> createState() => _NikkeEditorPageState();
}

class _NikkeEditorPageState extends State<NikkeEditorPage> {
  bool get useGlobal => widget.useGlobal;
  NikkeDatabase get db => useGlobal ? global : cn;
  NikkeOptions get option => widget.option;

  @override
  Widget build(BuildContext context) {
    final characterData = db.characterResourceGardeTable[option.nikkeResourceId]?[option.coreLevel];
    final weapon = db.characterShotTable[characterData?.shotId];
    return Scaffold(
      appBar: AppBar(title: const Text('Nikke Setup')),
      bottomNavigationBar: commonBottomNavigationBar(() => setState(() {})),
      body: ListView(
        children: [
          Align(
            child: InkWell(
              onTap: () async {
                final int? result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => NikkeSelectorPage(useGlobal: useGlobal)),
                );

                if (result != null) {
                  option.nikkeResourceId = result;
                  final stored = useGlobal ? userDb.userData.globalNikkeOptions : userDb.userData.cnNikkeOptions;
                  if (stored.containsKey(option.nikkeResourceId)) {
                    option.copyFrom(stored[option.nikkeResourceId]!);
                  }
                  option.errorCorrection(db);

                  if (mounted) setState(() {});
                }
              },
              child: NikkeIcon(
                isSelected: true,
                characterData: characterData,
                weapon: weapon,
                defaultText: 'Tap to Select',
              ),
            ),
          ),
          if (characterData != null)
            Align(
              child: FilledButton.icon(
                onPressed: () {
                  option.nikkeResourceId = -1;
                  setState(() {});
                },
                label: Text('Remove'),
                icon: Icon(Icons.remove_circle),
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
              ),
            ),
          if (characterData != null)
            NikkeSetupColumn(option: option, cubeLvs: widget.cubeLvs, useGlobal: useGlobal, advancedOption: true),
        ],
      ),
    );
  }
}
