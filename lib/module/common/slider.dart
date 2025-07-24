import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';

/// copied from Chaldea...
class SliderWithPrefix extends StatelessWidget {
  final bool titled;
  final String label;
  final String Function(int v)? valueFormatter;
  final int min;
  final int max;
  final int value;
  final ValueChanged<double>? onChange;
  final ValueChanged<double>? onEdit;
  final int? division;
  final double leadingWidth;
  final EdgeInsetsGeometry? padding;
  final TextStyle? labelStyle;
  final bool? constraint;
  final bool enableInput;
  final Color? preferColor;
  final Color? preferLabelColor;

  const SliderWithPrefix({
    super.key,
    this.titled = false,
    required this.label,
    this.valueFormatter,
    required this.min,
    required this.max,
    required this.value,
    required this.onChange,
    this.onEdit,
    this.division,
    this.leadingWidth = 48,
    this.padding,
    this.labelStyle,
    this.constraint,
    this.enableInput = true,
    this.preferColor,
    this.preferLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    Color? labelColor = preferLabelColor ?? (enableInput ? Theme.of(context).colorScheme.primary : null);
    Widget header;
    final valueText = valueFormatter?.call(value) ?? value.toString();
    if (titled) {
      header = Text.rich(
        TextSpan(
          text: label,
          children: [const TextSpan(text: ': '), TextSpan(text: valueText, style: TextStyle(color: labelColor))],
        ),
      );
    } else {
      header = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            label,
            maxLines: 1,
            minFontSize: 10,
            maxFontSize: 16,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: labelColor),
          ),
          AutoSizeText(valueText, maxLines: 1, minFontSize: 8, maxFontSize: 14, style: TextStyle(color: labelColor)),
        ],
      );
    }
    if (enableInput) {
      header = InkWell(
        onTap: () {
          showDialog(context: context, useRootNavigator: false, builder: getInputDialog);
        },
        child: Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(color: preferColor ?? Theme.of(context).primaryColor, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: header,
        ),
      );
    }
    Widget slider = SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        activeTrackColor: preferColor,
        thumbColor: preferColor,
      ),
      child: Slider(
        min: min.toDouble(),
        max: max.toDouble(),
        divisions: max > min ? (division ?? max - min) : null,
        value: value.toDouble(),
        label: valueText,
        onChanged: onChange,
      ),
    );
    if (constraint != false) {
      slider = ConstrainedBox(constraints: const BoxConstraints(maxWidth: 320, maxHeight: 24), child: slider);
    }

    Widget child;
    if (titled) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [header, slider],
      );
    } else {
      child = Row(children: [SizedBox(width: leadingWidth, child: header), Flexible(child: slider)]);
    }
    if (padding != null) {
      child = Padding(padding: padding!, child: child);
    }
    return child;
  }

  Widget getInputDialog(BuildContext context) {
    String helperText = '$min~$max';
    return InputCancelOkDialog.number(
      title: label,
      initValue: value,
      helperText: helperText,
      keyboardType: const TextInputType.numberWithOptions(signed: true),
      validate: (v) => v >= min && v <= max,
      onSubmit: (v) {
        if (v >= min && v <= max) {
          if (onEdit != null) {
            onEdit!(v.toDouble());
          } else if (onChange != null) {
            onChange!(v.toDouble());
          }
        }
      },
    );
  }
}
