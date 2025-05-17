import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/harmony_cube.dart';

import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/module/battle_timeline.dart';

import 'model/battle/battle_simulator.dart';
import 'model/battle/equipment.dart';
import 'model/battle/favorite_item.dart';
import 'model/battle/nikke.dart';
import 'model/battle/rapture.dart';
import 'model/common.dart';
import 'model/items.dart';

Future<void> main() async {
  await gameData.loadData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final BattlePlayerOptions playerOptions = BattlePlayerOptions(
      personalRecycleLevel: 420,
      corpRecycleLevels: {
        Corporation.pilgrim: 417,
        Corporation.missilis: 196,
        Corporation.abnormal: 155,
        Corporation.tetra: 224,
        Corporation.elysion: 197,
      },
      classRecycleLevels: {NikkeClass.attacker: 212, NikkeClass.supporter: 193, NikkeClass.defender: 184},
    );
    final BattleNikkeOptions scarletOption = BattleNikkeOptions(
      nikkeResourceId: 222,
      coreLevel: 11,
      syncLevel: 884,
      attractLevel: 40,
      skillLevels: [10, 10, 10],
      equips: [
        BattleEquipment(
          type: EquipType.head,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAmmo, 9), EquipLine(EquipLineType.increaseElementalDamage, 9)],
        ),
        BattleEquipment(
          type: EquipType.body,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [
            EquipLine(EquipLineType.statChargeTime, 2),
            EquipLine(EquipLineType.statAmmo, 5),
            EquipLine(EquipLineType.statDef, 9),
          ],
        ),
        BattleEquipment(
          type: EquipType.arm,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAtk, 10), EquipLine(EquipLineType.statAmmo, 3)],
        ),
        BattleEquipment(
          type: EquipType.leg,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [
            EquipLine(EquipLineType.statChargeDamage, 1),
            EquipLine(EquipLineType.statAtk, 14),
            EquipLine(EquipLineType.statAmmo, 5),
          ],
        ),
      ],
      favoriteItem: BattleFavoriteItem(gameData.getDollId(WeaponType.ar, Rarity.sr)!, 5),
      cube: null,
    );
    final BattleNikkeOptions aliceOption = BattleNikkeOptions(
      nikkeResourceId: 191,
      coreLevel: 11,
      syncLevel: 884,
      attractLevel: 30,
      skillLevels: [10, 6, 10],
      equips: [
        BattleEquipment(
          type: EquipType.head,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [
            EquipLine(EquipLineType.statAtk, 9),
            EquipLine(EquipLineType.statChargeTime, 7),
            EquipLine(EquipLineType.statAmmo, 13),
          ],
        ),
        BattleEquipment(
          type: EquipType.body,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAmmo, 11), EquipLine(EquipLineType.statAtk, 5)],
        ),
        BattleEquipment(
          type: EquipType.arm,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAtk, 11), EquipLine(EquipLineType.statChargeTime, 9)],
        ),
        BattleEquipment(
          type: EquipType.leg,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAtk, 11), EquipLine(EquipLineType.statAmmo, 7)],
        ),
      ],
      favoriteItem: BattleFavoriteItem(gameData.getDollId(WeaponType.sr, Rarity.sr)!, 15),
      cube: null,
    );
    final BattleNikkeOptions snowWhiteOption = BattleNikkeOptions(
      nikkeResourceId: 220,
      coreLevel: 11,
      syncLevel: 884,
      attractLevel: 40,
      skillLevels: [7, 10, 10],
      equips: [
        BattleEquipment(
          type: EquipType.head,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAtk, 5)],
        ),
        BattleEquipment(
          type: EquipType.body,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAtk, 8)],
        ),
        BattleEquipment(
          type: EquipType.arm,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAtk, 5)],
        ),
        BattleEquipment(
          type: EquipType.leg,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 1,
          equipLines: [EquipLine(EquipLineType.statAtk, 11)],
        ),
      ],
      favoriteItem: BattleFavoriteItem(gameData.getDollId(WeaponType.ar, Rarity.r)!, 0),
      cube: null,
    );

    final simulation = BattleSimulation(
      playerOptions: playerOptions,
      nikkeOptions: [
        BattleNikkeOptions(
          nikkeResourceId: 82,
          coreLevel: 11,
          syncLevel: 884,
          attractLevel: 30,
          skillLevels: [10, 10, 10],
        ),
        BattleNikkeOptions(
          nikkeResourceId: 80,
          coreLevel: 11,
          syncLevel: 884,
          attractLevel: 30,
          skillLevels: [10, 10, 10],
        ),
        BattleNikkeOptions(
          nikkeResourceId: 80,
          coreLevel: 11,
          syncLevel: 884,
          attractLevel: 30,
          skillLevels: [10, 10, 10],
        ),
        scarletOption.copy(),
        scarletOption.copy(),
      ],
    );

    final rapture =
        BattleRapture()
          ..uniqueId = 11
          ..distance = 30
          ..element = NikkeElement.electric
          ..defence = 140;

    simulation.raptures.add(rapture);
    simulation.maxSeconds = 90;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BattleTimeline(simulation: simulation),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
