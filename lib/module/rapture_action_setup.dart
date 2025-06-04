import 'package:flutter/material.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/common/simple_dialog.dart';

class RaptureActionSetupDialog extends StatefulWidget {
  final int maxFrame;
  final int fps;

  const RaptureActionSetupDialog({super.key, required this.maxFrame, required this.fps});

  @override
  State<RaptureActionSetupDialog> createState() => _RaptureActionSetupDialogState();
}

class _RaptureActionSetupDialogState extends State<RaptureActionSetupDialog> {
  int get maxFrame => widget.maxFrame;
  String get maxSeconds => (maxFrame / fps).toStringAsFixed(3);
  int get fps => widget.fps;

  bool useFrame = true;
  int frame = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 3,
        mainAxisSize: MainAxisSize.min,
        children: [
          // timestamp
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Timestamp: '),
              Text(
                'Frame $frame,'
                ' Time: ${frameDataToNiceTimeString(frame, fps)}'
                ' (Elapsed time: ${frameDataToNiceTimeString(maxFrame - frame, fps)})',
              ),
              IconButton.filled(
                onPressed: () async {
                  final newTimeframe = await showDialog<int?>(
                    barrierDismissible: false,
                    context: context,
                    builder: (ctx) {
                      return TimeframeSetupDialog(maxFrame: maxFrame, fps: fps, defaultFrame: frame);
                    },
                  );
                  if (newTimeframe != null) {
                    frame = newTimeframe;
                    setState(() {});
                  }
                },
                icon: Icon(Icons.settings),
              ),
            ],
          ),
          // action
        ],
      ),
    );
  }
}
