import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

/// copied from Chaldea
class SimpleConfirmDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final EdgeInsetsGeometry contentPadding;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onTapOk;
  final VoidCallback? onTapCancel;

  /// ignore if onTapCancel is not null
  final bool showOk;
  final bool showCancel;
  final List<Widget> actions;
  final bool scrollable;
  final bool wrapActionsInRow;
  final EdgeInsets insetPadding;

  const SimpleConfirmDialog({
    super.key,
    this.title,
    this.content,
    this.contentPadding = const EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 24.0),
    this.confirmText,
    this.cancelText,
    this.onTapOk,
    this.onTapCancel,
    this.showOk = true,
    this.showCancel = true,
    this.actions = const [],
    this.scrollable = false,
    this.wrapActionsInRow = false,
    this.insetPadding = const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[
      if (showCancel)
        TextButton(
          child: Text(cancelText ?? 'Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false);
            if (onTapCancel != null) {
              onTapCancel!();
            }
          },
        ),
      ...actions,
      if (showOk)
        TextButton(
          child: Text(confirmText ?? 'Confirm'),
          onPressed: () {
            Navigator.of(context).pop(true);
            if (onTapOk != null) {
              onTapOk!();
            }
          },
        ),
    ];
    if (wrapActionsInRow) {
      children = [
        FittedBox(fit: BoxFit.scaleDown, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: children)),
      ];
    }
    return AlertDialog(
      title: title,
      content: content,
      contentPadding: contentPadding,
      scrollable: scrollable,
      actions: children,
      insetPadding: insetPadding,
    );
  }
}

class TimeframeSetupDialog extends StatefulWidget {
  final int maxFrame;
  final int fps;
  final int? defaultFrame;
  final bool timestampMode;

  const TimeframeSetupDialog({
    super.key,
    required this.maxFrame,
    required this.fps,
    this.defaultFrame,
    this.timestampMode = true,
  });

  @override
  State<TimeframeSetupDialog> createState() => _TimeframeSetupDialogState();
}

class _TimeframeSetupDialogState extends State<TimeframeSetupDialog> {
  TextEditingController timeInputController = TextEditingController();
  int get maxFrame => widget.maxFrame;
  String get maxSeconds => (maxFrame / fps).toStringAsFixed(3);
  int get fps => widget.fps;
  bool get timestampMode => widget.timestampMode;

  bool useFrame = true;
  int frame = 0;
  String? errorText;

  @override
  void initState() {
    super.initState();
    if (widget.defaultFrame != null) {
      frame = widget.defaultFrame!;
    }
    timeInputController.text = frame.toString();
  }

  @override
  void dispose() {
    super.dispose();
    timeInputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [
      TextButton(
        child: Text('Cancel'),
        onPressed: () {
          Navigator.of(context).pop(null);
        },
      ),
      TextButton(
        child: Text('Confirm'),
        onPressed: () {
          final num = double.tryParse(timeInputController.text);
          if (num != null) {
            final nearestFrame = useFrame ? num.round() : (num * fps).round();
            if (nearestFrame > 0 && nearestFrame <= maxFrame || !timestampMode) {
              Navigator.of(context).pop(nearestFrame);
            } else {
              errorText = "Input outside valid range [${useFrame ? maxFrame : maxSeconds}, 0).";
              if (mounted) setState(() {});
            }
          }
        },
      ),
    ];

    return AlertDialog(
      title: Text('Select a timeframe'),
      content: Column(
        spacing: 3,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Input with frame data'),
              Switch(
                value: useFrame,
                onChanged: (v) {
                  useFrame = v;
                  timeInputController.text = useFrame ? frame.toString() : (frame / fps).toStringAsFixed(3);
                  if (mounted) setState(() {});
                },
              ),
            ],
          ),
          if (useFrame && timestampMode) Text('Frame starts at $maxFrame (inclusive) and ends at 0 (exclusive).'),
          if (!useFrame && timestampMode) Text('Time starts at $maxSeconds seconds and ends at 0 seconds.'),
          if (!useFrame && timestampMode) Text('Please input only seconds (E.g. 180 for 3:00)'),
          TextField(
            decoration: InputDecoration(border: const OutlineInputBorder()),
            controller: timeInputController,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'\d+.?\d*'))],
            onChanged: (v) {
              final num = double.tryParse(v);
              if (num != null) {
                final nearestFrame = useFrame ? num.round() : (num * fps).round();
                if (nearestFrame > 0 && nearestFrame <= maxFrame || !timestampMode) {
                  frame = nearestFrame;
                  errorText = null;
                } else {
                  errorText = "Input outside valid range [${useFrame ? maxFrame : maxSeconds}, 0).";
                }
              } else {
                errorText = "Input is not a valid number";
              }
              if (mounted) setState(() {});
            },
          ),
          if (errorText != null) Text(errorText!, style: TextStyle(color: Colors.red)),
          if (timestampMode)
            Text(
              'Current input: Frame $frame,'
              ' Time: ${frameDataToNiceTimeString(frame, fps)}'
              ' (Elapsed time: ${frameDataToNiceTimeString(maxFrame - frame, fps)})',
            ),
          if (!timestampMode) Text('Current duration: $frame frames, ${(frame / fps).toStringAsFixed(3)} seconds'),
        ],
      ),
      contentPadding: const EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 24.0),
      scrollable: false,
      actions: actions,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
    );
  }
}
