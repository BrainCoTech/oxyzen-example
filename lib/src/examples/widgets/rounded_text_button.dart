import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';
import 'package:zenlite_sdk_example/src/examples/constants/constant.dart';
import 'package:zenlite_sdk_example/src/examples/ui.dart';

class RoundedTextButton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? borderColor;

  final double width;
  final double height;
  final VoidCallback? onPressed;

  const RoundedTextButton(
    this.text, {
    Key? key,
    this.width = 160,
    this.height = 52,
    this.textStyle,
    this.borderColor = Colors.transparent,
    this.backgroundColor,
    this.onPressed,
  }) : super(key: key);

  factory RoundedTextButton.primary(
    String text, {
    double width = 160,
    double height = 52,
    Color? backgroundColor,
    VoidCallback? onPressed,
  }) =>
      RoundedTextButton(
        text,
        width: width,
        height: height,
        onPressed: onPressed,
        textStyle: TextStyle(fontSize: 18.scale, color: Colors.white),
        backgroundColor: backgroundColor ?? Get.theme.primaryColor,
      );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        // foregroundColor: MaterialStateProperty.all(Colors.transparent),
        // overlayColor: MaterialStateProperty.all(Colors.transparent),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        fixedSize: MaterialStateProperty.all(
          Size(width.ratio, height.ratio),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: BorderSide(
                color: borderColor ?? backgroundColor ?? ColorExt.primaryColor),
            borderRadius: BorderRadius.circular(height.ratio * 0.5),
          ),
        ),
      ),
      onPressed: onPressed,
      onLongPress: null,
      child: Container(
        width: width.ratio,
        height: height.ratio,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(height.ratio * 0.5),
        ),
        child: Text(text, style: textStyle),
      ),
    );
  }
}
