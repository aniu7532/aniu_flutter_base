import 'package:flutter/material.dart';
import 'package:musico/gen/colors.gen.dart';

///
/// 默认单行文本
/// 多行文本 带展开收起
///
class ExpandableText extends StatefulWidget {
  const ExpandableText(this.text, {Key? key, this.defaultMaxLines = 1})
      : super(key: key);
  final String text;
  final int defaultMaxLines;

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            firstChild: Text(
              widget.text,
              maxLines: widget.defaultMaxLines,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
            secondChild: Text(
              widget.text,
              softWrap: true,
              style: const TextStyle(color: Colors.white),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ),
        if (isTextExceedsOneLine(widget.text))
          TextButton(
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? '收起' : '展开',
              style: const TextStyle(color: ColorName.primaryColor),
            ),
          ),
      ],
    );
  }

  bool isTextExceedsOneLine(String text) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(color: Colors.white)),
      maxLines: widget.defaultMaxLines,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size.width > MediaQuery.of(context).size.width;
  }
}
