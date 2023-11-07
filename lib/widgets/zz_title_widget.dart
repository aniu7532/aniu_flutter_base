import 'package:flutter/material.dart';
import 'package:musico/utils/font_style_utils.dart';

///统一定义AppBar中使用的标题样式
class ZzTitle extends StatelessWidget {
  const ZzTitle(
    this.title, {
    Key? key,
    this.style,
  }) : super(key: key);

  final String title;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: style ?? FSUtils.font_bold_18_colorFF111111,
    );
  }
}
