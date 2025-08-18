import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/buff.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/custom_table.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

class BuffEvent extends BattleEvent {
  final FunctionData data;
  final Source source;
  final int buffCount;
  final bool isAdd;

  BuffEvent._(super.activatorId, super.targetIds, this.data, this.source, this.buffCount, this.isAdd);

  factory BuffEvent.create(BattleBuff buff) {
    return BuffEvent._(buff.buffGiverId, [buff.buffReceiverId], buff.data, buff.source, buff.count, true);
  }

  factory BuffEvent.remove(BattleBuff buff) {
    return BuffEvent._(buff.buffGiverId, [buff.buffReceiverId], buff.data, buff.source, buff.count, false);
  }

  int get targetId => targetIds.first;

  @override
  Widget buildDisplayV2(BattleSimulation simulation) {
    final funcName = locale.getTranslation(data.nameLocalkey);
    return CustomTable(
      children: [
        CustomTableRow.fromTexts(
          texts: [isAdd ? 'Buff Applied' : 'Buff Removed', 'Source', 'Activator', 'Target'],
          defaults: battleHeaderData,
        ),
        CustomTableRow.fromTexts(
          texts: [
            data.functionType.name.pascal,
            '${source.name.pascal}${funcName != null ? ': $funcName' : ''}',
            '${simulation.getEntityName(activatorId)}',
            '${simulation.getEntityName(targetId)}',
          ],
        ),
      ],
    );
    // return Row(
    //   spacing: 5,
    //   children: [
    //     Text( 'Buff:', style: boldStyle),
    //     if (funcName != null)  Text( '$funcName /'),
    //     Text( data.functionType.name.pascal,),
    //     Text( 'Activator:', style: boldStyle),
    //     Text( '${simulation.getEntityName(activatorId)}',),
    //     Text( 'Target:', style: boldStyle),
    //     Text( '${simulation.getEntityName(targetId)}',),
    //     Text('Source:', style: boldStyle,),
    //     Text(source.name.pascal),
    //   ]
    // );
  }
}
