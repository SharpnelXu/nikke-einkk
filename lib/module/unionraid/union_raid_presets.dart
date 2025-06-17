import 'package:flutter/material.dart';

class UnionRaidPresetPage extends StatefulWidget {
  const UnionRaidPresetPage({super.key});

  @override
  State<UnionRaidPresetPage> createState() => _UnionRaidPresetPageState();
}

class _UnionRaidPresetPageState extends State<UnionRaidPresetPage> {
  bool useGlobal = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Union Raid Data')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              spacing: 5,
              children: [
                Text('Server Select: '),
                Radio(value: true, groupValue: useGlobal, onChanged: serverRadioChange),
                Text('Global', style: TextStyle(fontWeight: useGlobal ? FontWeight.bold : null)),
                Radio(value: false, groupValue: useGlobal, onChanged: serverRadioChange),
                Text('CN', style: TextStyle(fontWeight: !useGlobal ? FontWeight.bold : null)),
              ],
            )
          ],
        ),
      ),
    );
  }

  void serverRadioChange(bool? v) {
    useGlobal = v ?? useGlobal;
    if (mounted) setState(() {});
  }
}