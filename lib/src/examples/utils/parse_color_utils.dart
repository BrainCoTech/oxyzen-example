import 'package:flutter/material.dart';

extension ParseColorUtils on String {
  /// 将String"0xFFFFFFFF" 转换成int 0xFFFFFFFF
  Color toColor({Color? defaultColor}) {
    try {
      return Color(int.parse(this));
    } catch (e) {
      return defaultColor ?? Colors.black;
    }
  }
}
