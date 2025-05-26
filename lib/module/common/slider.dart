import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

/// copied from Chaldea...
class SliderWithPrefix extends StatelessWidget {
  final bool titled;
  final String label;
  final String Function(int v)? valueFormatter;
  final int min;
  final int max;
  final int value;
  final ValueChanged<double> onChange;
  final ValueChanged<double>? onEdit;
  final int? division;
  final double leadingWidth;
  final EdgeInsetsGeometry? padding;

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
  });

  @override
  Widget build(BuildContext context) {
    Color? labelColor = Theme.of(context).colorScheme.primary;
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
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            label,
            maxLines: 1,
            minFontSize: 10,
            maxFontSize: 16,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: valueText.isEmpty ? labelColor : null),
          ),
          AutoSizeText(valueText, maxLines: 1, minFontSize: 9, maxFontSize: 9, style: TextStyle(color: labelColor)),
        ],
      );
    }

    Widget slider = SliderTheme(
      data: SliderTheme.of(context).copyWith(thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8)),
      child: Slider(
        min: min.toDouble(),
        max: max.toDouble(),
        divisions: max > min ? (division ?? max - min) : null,
        value: value.toDouble(),
        label: valueText,
        onChanged: (v) {
          onChange(v);
        },
      ),
    );
    slider = ConstrainedBox(constraints: const BoxConstraints(maxWidth: 320, maxHeight: 24), child: slider);

    Widget child;
    if (titled) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [header, slider],
      );
    } else {
      child = Row(children: [if (!titled) SizedBox(width: leadingWidth, child: header), Flexible(child: slider)]);
    }
    if (padding != null) {
      child = Padding(padding: padding!, child: child);
    }
    return child;
  }
}
