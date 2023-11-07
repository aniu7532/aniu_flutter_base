import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/toast_util.dart';

enum NumberStepperStyle {
  system,
  outlined,
  textField,
}

///自定义数值增减 Stepper
class NumberStepper extends StatefulWidget {
  NumberStepper({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.stepValue,
    this.iconWidth = 34,
    this.iconHeight = 34,
    required this.value,
    this.color = Colors.blue,
    this.style = NumberStepperStyle.system,
    this.radius = 5.0,
    this.wraps = true,
    required this.block,
  });

  final int minValue;
  final int maxValue;
  final int stepValue;
  final double iconWidth;
  final double iconHeight;
  int value;

  final bool wraps;

  final Color color;
  final NumberStepperStyle style;
  final double radius;
  void Function(int value) block;

  @override
  NumberStepperState createState() => NumberStepperState();
}

class NumberStepperState extends State<NumberStepper> {
  // 控制器
  final _textController = TextEditingController();
  // 焦点
  final focusNode1 = FocusNode();

  @override
  void initState() {
    _textController.text = '${widget.value}';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.style) {
      case NumberStepperStyle.outlined:
        return buildOutlinedStyle(context);
      case NumberStepperStyle.textField:
        return buildTextFieldStyle(context);
      case NumberStepperStyle.system:
        return buildSystemStyle(context);
    }
  }

  Widget buildSystemStyle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: widget.iconWidth,
          height: widget.iconHeight,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(color: widget.color), // 边色与边宽度
          ),
          child: IconButton(
            icon: Icon(Icons.remove, size: widget.iconWidth),
            // iconSize: widget.iconSize,
            padding: EdgeInsets.zero,
            color: Colors.white,
            onPressed: () {
              go(-widget.stepValue);
            },
          ),
        ),
        Container(
          width: widget.value.toString().length * 18 * widget.iconWidth / 30,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          // width: widget.iconSize + 20,
          child: Text(
            '${widget.value}',
            style:
                TextStyle(fontSize: widget.iconWidth * 0.8, color: Colors.blue),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: widget.iconWidth,
          height: widget.iconHeight,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(color: widget.color), // 边色与边宽度
          ),
          child: IconButton(
            icon: Icon(
              Icons.add,
              size: widget.iconWidth,
            ),
            // iconSize: widget.iconSize,
            padding: EdgeInsets.zero,
            color: Colors.white,
            onPressed: () {
              setState(() {
                go(widget.stepValue);
              });
            },
          ),
        ),
      ],
    );
  }

  bool get disableMin => widget.value <= widget.minValue;
  bool get disableMax => widget.value >= widget.maxValue;
  Widget buildOutlinedStyle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: widget.iconWidth,
          height: widget.iconHeight,
          // color: Theme.of(context).primaryColor,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(
              color: disableMin ? const Color(0xFFA9AFBC) : widget.color,
            ), // 边色与边宽度
          ),
          child: IconButton(
            icon: Icon(Icons.remove, size: widget.iconWidth - 20),
            // iconSize: widget.iconSize,
            padding: EdgeInsets.zero,
            color: disableMin ? const Color(0xFFA9AFBC) : widget.color,
            onPressed: () {
              if (!disableMin) {
                go(-widget.stepValue);
              }
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '${widget.value}',
            style: FSUtils.font_bold_20_colorFF111A34,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: widget.iconWidth,
          height: widget.iconHeight,
          // color: Theme.of(context).primaryColor,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(
              color: disableMax ? const Color(0xFFA9AFBC) : widget.color,
            ), // 边色与边宽度
          ),
          child: IconButton(
            icon: Icon(Icons.add, size: widget.iconWidth - 20),
            // iconSize: widget.iconSize,
            padding: EdgeInsets.zero,
            color: disableMax ? const Color(0xFFA9AFBC) : widget.color,
            onPressed: () {
              setState(() {
                if (!disableMax) {
                  go(widget.stepValue);
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildTextFieldStyle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            enableInteractiveSelection: false,
            controller: _textController,
            decoration: InputDecoration(
              // labelText: "请输入内容",//输入框内无文字时提示内容，有内容时会自动浮在内容上方
              // helperText: "随便输入文字或数字", //输入框底部辅助性说明文字
              prefixIcon: IconButton(
                icon: Icon(
                  Icons.remove,
                  size: widget.iconWidth,
                ),
                onPressed: () {
                  // go(-widget.stepValue);
                  setState(() {
                    go(-widget.stepValue);
                    _textController.text = '${widget.value}';
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4), //圆角大小
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.add,
                  size: widget.iconWidth,
                ),
                onPressed: () {
                  // go(widget.stepValue);
                  setState(() {
                    // FocusScope.of(context).requestFocus(FocusNode());
                    go(widget.stepValue);
                    _textController.text = '${widget.value}';
                  });
                },
              ),
              contentPadding: const EdgeInsets.only(bottom: 8),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  void go(int stepValue) {
    setState(() {
      if (stepValue < 0 &&
          (widget.value == widget.minValue ||
              widget.value + stepValue < widget.minValue)) {
        MyToast.showToast('最小值');
        if (widget.wraps) widget.value = widget.minValue;
        widget.block(widget.value);
        return;
      }
      if (stepValue > 0 &&
          (widget.value == widget.maxValue ||
              widget.value + stepValue > widget.maxValue)) {
        MyToast.showToast('最大值');
        if (widget.wraps) widget.value = widget.maxValue;
        widget.block(widget.value);
        return;
      }
      widget.value += stepValue;
    });
    widget.block(widget.value);
  }
}
