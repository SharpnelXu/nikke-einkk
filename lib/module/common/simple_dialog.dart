import 'package:flutter/material.dart';

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
