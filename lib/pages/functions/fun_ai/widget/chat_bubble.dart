import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.text,
    this.title,
    required this.send,
  }) : super(key: key);
  final String text; //要显示的文字
  final String? title; //要显示的文字
  final bool send; //左右对齐
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        !send ? 6.0 : 50.0,
        2,
        !send ? 50.0 : 6.0,
        2,
      ),
      child: Row(
        mainAxisAlignment:
            !send ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (send) _msg() else _head(),
          const Padding(
            padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          ),
          if (send) _head() else _msg(),
        ],
      ),
    );
  }

  Flexible _head() {
    return const Flexible(
      child: CircleAvatar(
        //图片圆形剪裁
        radius: 25, //圆形大小
        backgroundColor: Colors.white, //背景颜色设置为白色
        backgroundImage: null,
      ),
    );
  }

  Flexible _msg() {
    var child = <Widget>[];

    if (ObjectUtil.isEmptyString(title)) {
      child = [
        Text(
          text,
          style: const TextStyle(
            fontSize: 14, //字体大小
            color: Color.fromARGB(255, 48, 14, 43),
          ),
        )
      ];
    } else {
      child = [
        Text(
          title ?? '',
          style: const TextStyle(
            fontSize: 14, //字体大小
            color: Color.fromARGB(255, 48, 14, 43),
          ),
        ),
        const Text(
          '------------------------------------------------------',
          style: TextStyle(
            fontSize: 14, //字体大小
            color: Color.fromARGB(255, 48, 14, 43),
          ),
        ),
        SelectableText(
          text,
          style: const TextStyle(
            fontSize: 14, //字体大小
            color: Color.fromARGB(255, 48, 14, 43),
          ),
        ),
      ];
    }

    return Flexible(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: !send //背景颜色
              ? const Color.fromARGB(255, 164, 208, 238)
              : const Color.fromARGB(255, 153, 231, 169),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              SelectableText(
                text,
                style: const TextStyle(
                  fontSize: 14, //字体大小
                  color: Color.fromARGB(255, 48, 14, 43),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
