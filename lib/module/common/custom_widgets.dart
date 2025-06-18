import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nikke_einkk/model/db.dart';

class RangedNumberTextField extends StatefulWidget {
  final int defaultValue;
  final int? minValue;
  final int? maxValue;
  final void Function(int newValue)? onChangeFunction;

  const RangedNumberTextField({
    super.key,
    this.defaultValue = 1, // Default value when empty
    this.minValue,
    this.maxValue,
    this.onChangeFunction,
  });

  @override
  State<RangedNumberTextField> createState() => _RangedNumberTextFieldState();
}

class _RangedNumberTextFieldState extends State<RangedNumberTextField> {
  final TextEditingController controller = TextEditingController();
  int? get minLevel => widget.minValue;
  int? get maxLevel => widget.maxValue;
  int get defaultValue => widget.defaultValue;

  @override
  void initState() {
    super.initState();
    // Initialize with default value if empty
    if (controller.text.isEmpty) {
      controller.text = defaultValue.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _NumberRangeInputFormatter(min: minLevel, max: maxLevel, defaultValue: defaultValue),
      ],
      decoration: InputDecoration(border: const OutlineInputBorder()),
      onChanged: (value) {
        if (value.isEmpty) {
          // Immediately restore default value when empty
          controller.text = defaultValue.toString();
          controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
        }

        final numValue = int.tryParse(value);
        if (numValue != null &&
            (minLevel == null || numValue >= minLevel!) &&
            (maxLevel == null || numValue <= maxLevel!)) {
          if (widget.onChangeFunction != null) widget.onChangeFunction!(numValue);
          setState(() {});
        }
      },
    );
  }
}

class _NumberRangeInputFormatter extends TextInputFormatter {
  final int? min;
  final int? max;
  final int defaultValue;

  _NumberRangeInputFormatter({this.min, this.max, this.defaultValue = 1});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // If text is empty, return default value
    if (newValue.text.isEmpty) {
      return TextEditingValue(
        text: defaultValue.toString(),
        selection: TextSelection.collapsed(offset: defaultValue.toString().length),
      );
    }

    final number = int.tryParse(newValue.text);
    if (number == null) {
      return oldValue;
    }

    if (min != null && number < min!) {
      return TextEditingValue(text: min.toString(), selection: TextSelection.collapsed(offset: min.toString().length));
    } else if (max != null && number > max!) {
      return TextEditingValue(text: max.toString(), selection: TextSelection.collapsed(offset: max.toString().length));
    }

    return newValue;
  }
}

Widget commonBottomNavigationBar(void Function() setState) {
  final languageDropDown =
      Language.values
          .whereNot((lang) => lang == Language.unknown)
          .map((lang) => DropdownMenuEntry(value: lang, label: lang.name))
          .toList();

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 5,
      children: [
        Text('Language: '),
        DropdownMenu(
          initialSelection: locale.language,
          onSelected: (v) {
            locale.language = v!;
            setState();
          },
          dropdownMenuEntries: languageDropDown,
        ),
      ],
    ),
  );
}
