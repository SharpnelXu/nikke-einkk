import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<T> showEasyLoading<T>(Future<T> Function() computation, {bool mask = false}) async {
  final mounted = EasyLoading.instance.overlayEntry?.mounted == true;
  if (!mounted) return computation();
  Widget? widget;
  try {
    await EasyLoading.dismiss();
    EasyLoading.show(maskType: mask ? EasyLoadingMaskType.clear : null);
    widget = EasyLoading.instance.w;
    return await computation();
  } finally {
    final widget2 = EasyLoading.instance.w;
    if (widget == null || widget == widget2) {
      EasyLoading.dismiss();
    }
  }
}
