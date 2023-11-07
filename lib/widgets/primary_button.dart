import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/widgets/time_circle_progressbar/time_circle_progressbar.dart';

///使用主题颜色的作为背景的 button
///文字是白色
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    Key? key,
    this.text = '确定',
    required this.onPressed,
    this.width = double.infinity,
    this.height = 44.0,
    this.fontSize = 16.0,
    this.padding = 10.0,
    this.fontWeight = FontWeight.normal,
    this.color = ColorName.themeColor,
    this.fontColor = Colors.white,
    this.borderRadius = 4,
    this.borderWidth = 1,
    this.borderColor = ColorName.bgColorFFF9F9F9,
    this.time,
    this.timeOverCallback,
  }) : super(key: key);

  const PrimaryButton.secondary({
    Key? key,
    this.text = '确定',
    required this.onPressed,
    this.width = double.infinity,
    this.height = 44.0,
    this.fontSize = 16.0,
    this.padding = 10.0,
    this.fontWeight = FontWeight.normal,
    this.color = ColorName.bgColorFFF9F9F9,
    this.fontColor = Colors.white,
    this.borderRadius = 0,
    this.borderWidth = 1,
    this.borderColor = ColorName.bgColorFFF9F9F9,
    this.time,
    this.timeOverCallback,
  }) : super(key: key);
  const PrimaryButton.withTime({
    Key? key,
    this.text = '确定',
    required this.onPressed,
    this.time = true,
    this.timeOverCallback,
    this.width = double.infinity,
    this.height = 44.0,
    this.fontSize = 16.0,
    this.padding = 0.0,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.white,
    this.fontColor = ColorName.themeColor,
    this.borderRadius = 4,
    this.borderWidth = 1,
    this.borderColor = ColorName.themeColor,
  }) : super(key: key);

  ///有边框的按钮
  const PrimaryButton.singleWithBorder({
    Key? key,
    this.text = '确定',
    required this.onPressed,
    this.width = double.infinity,
    this.height = 30.0,
    this.fontSize = 14.0,
    this.padding = 10,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.white,
    this.fontColor = ColorName.themeColor,
    this.borderRadius = 2,
    this.borderWidth = 1,
    this.borderColor = ColorName.themeColor,
    this.time,
    this.timeOverCallback,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double fontSize;
  final double padding;
  final FontWeight? fontWeight;
  final Color fontColor;
  final Color color;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final bool? time;

  ///结束回调
  final VoidCallback? timeOverCallback;
  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      //设置按钮是否自动获取焦点
      // autofocus: true,
      //定义一下文本样式
      style: ButtonStyle(
        //定义文本的样式 这里设置的颜色是不起作用的
        textStyle: MaterialStateProperty.all(
          TextStyle(
            fontSize: widget.fontSize,
            color: Colors.red,
            fontWeight: widget.fontWeight,
          ),
        ),
        //设置按钮上字体与图标的颜色
        //foregroundColor: MaterialStateProperty.all(Colors.deepPurple),
        //更优美的方式来设置
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.focused) &&
                !states.contains(MaterialState.pressed)) {
              //获取焦点时的颜色
              return widget.fontColor;
            } else if (states.contains(MaterialState.pressed)) {
              //按下时的颜色
              return widget.fontColor;
            }
            //默认状态使用灰色
            return widget.fontColor;
          },
        ),
        //背景颜色
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          //设置按下时的背景颜色
          if (states.contains(MaterialState.pressed)) {
            return ColorName.themeColor.withOpacity(0.8);
          }
          //默认不使用背景颜色
          return widget.color;
        }),
        //设置水波纹颜色
        overlayColor: MaterialStateProperty.all(
            ColorName.secondaryColor.withOpacity(0.1)),
        //设置阴影  不适用于这里的TextButton
        elevation: MaterialStateProperty.all(0),
        //设置按钮内边距
        padding: MaterialStateProperty.all(EdgeInsets.all(widget.padding)),
        //设置按钮的大小
        minimumSize:
            MaterialStateProperty.all(Size(widget.width, widget.height)),
        //设置边框
        side: MaterialStateProperty.all(
          BorderSide(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        //外边框装饰 会覆盖 side 配置的样式
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
      ),
      child: (widget.time ?? false) ? buildTime() : Text(widget.text),
    );
  }

  Widget buildTime() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.text,
            style:
                TextStyle(color: widget.fontColor, fontSize: widget.fontSize),
          ),
          const SizedBox(
            width: 12,
          ),
          TimeCircleProgressbar(
            size: widget.height - 20,
            fontSize: 14,
            strokeWidth: 3,
            timeOverCallback: () {
              widget.timeOverCallback?.call();
            },
          )
        ],
      ),
    );
  }
}
