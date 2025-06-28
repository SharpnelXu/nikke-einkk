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

Widget commonBottomNavigationBar(void Function() setState, {List<Widget> actions = const []}) {
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
        ...actions,
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

class InputCancelOkDialog extends StatefulWidget {
  final String? title;
  final String? initValue;
  final int? maxLines;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool Function(String s)? validate;
  final ValueChanged<String>? onSubmit;
  final TextInputType? keyboardType;
  final bool autofocus;
  final bool showNumButton;

  const InputCancelOkDialog({
    super.key,
    this.title,
    this.initValue,
    this.maxLines,
    this.hintText,
    this.helperText,
    this.errorText,
    this.validate,
    this.onSubmit,
    this.keyboardType,
    this.autofocus = true,
  }) : showNumButton = false;

  InputCancelOkDialog.number({
    super.key,
    this.title,
    int? initValue,
    this.maxLines,
    this.hintText,
    this.helperText,
    this.errorText,
    bool Function(int v)? validate,
    ValueChanged<int>? onSubmit,
    this.keyboardType = TextInputType.number,
    this.autofocus = true,
    this.showNumButton = true,
  }) : initValue = initValue?.toString(),
       validate = ((String s) {
         final v = int.parse(s);
         if (validate != null) return validate(v);
         return true;
       }),
       onSubmit = (onSubmit == null ? null : (String s) => onSubmit(int.parse(s)));

  @override
  State<StatefulWidget> createState() => _InputCancelOkDialogState();
}

class _InputCancelOkDialogState extends State<InputCancelOkDialog> {
  late TextEditingController _controller;
  bool validation = true;

  bool _validate(String v) {
    try {
      if (widget.validate != null) {
        return widget.validate!(v);
      }
    } catch (_) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    final text = widget.initValue ?? '';
    _controller = TextEditingController.fromValue(
      TextEditingValue(
        text: text,
        selection:
            text.isEmpty
                ? const TextSelection.collapsed(offset: -1)
                : TextSelection(baseOffset: 0, extentOffset: text.length),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    validation = _validate(_controller.text);
    Widget field = TextFormField(
      controller: _controller,
      autofocus: widget.autofocus,
      autocorrect: false,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines ?? 1,
      decoration: InputDecoration(
        hintText: widget.hintText,
        helperText: widget.helperText,
        errorText: validation || _controller.text.isEmpty ? null : 'Invalid input',
      ),
      onChanged: (v) {
        if (widget.validate != null) {
          setState(() {
            validation = _validate(v);
          });
        }
      },
      onFieldSubmitted: (v) {
        if (!_validate(v)) {
          return;
        }
        FocusScope.of(context).unfocus();
        Navigator.pop(context, v);
        if (widget.onSubmit != null) {
          widget.onSubmit!(v);
        }
      },
    );
    if (widget.showNumButton) {
      field = Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: field),
          Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  try {
                    _controller.text = (double.parse(_controller.text).floor() + 1).toString();
                  } catch (e) {
                    //do nothing
                  }
                  setState(() {});
                },
                child: Icon(Icons.add_circle_outline, size: 16),
              ),
              InkWell(
                onTap: () {
                  try {
                    _controller.text = (double.parse(_controller.text).ceil() - 1).toString();
                  } catch (e) {
                    //do nothing
                  }
                  setState(() {});
                },
                child: Icon(Icons.remove_circle_outline, size: 16),
              ),
            ],
          ),
        ],
      );
    }
    return AlertDialog(
      title: widget.title == null ? null : Text(widget.title!),
      content: field,
      actions: <Widget>[
        TextButton(child: Text('Cancel'), onPressed: () => Navigator.pop(context)),
        TextButton(
          onPressed:
              validation
                  ? () {
                    String value = _controller.text;
                    validation = _validate(value);
                    setState(() {
                      if (validation) {
                        Navigator.pop(context, value);
                        if (widget.onSubmit != null) {
                          widget.onSubmit!(value);
                        }
                      }
                    });
                  }
                  : null,
          child: Text('OK'),
        ),
      ],
    );
  }
}
