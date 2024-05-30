import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musico/base/provider_widget.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/widgets/time_circle_progressbar/time_circle_model.dart';

///
/// 圆圈倒计时进度条
///
class TimeCircleProgressbar extends StatefulWidget {
  TimeCircleProgressbar({
    super.key,
    this.totalTimeNumber,
    this.currentTimeNumber,
    this.timeOverCallback,
    this.cancelCallback,
    this.size,
    this.fontSize,
    this.strokeWidth,
  }) {
    totalTimeNumber = 10000;
    currentTimeNumber = 10000;
  }

  double? size;
  double? fontSize;
  double? strokeWidth;

  ///倒计时6秒
  double? totalTimeNumber;

  ///当前的时间
  double? currentTimeNumber;

  ///结束回调
  VoidCallback? timeOverCallback;

  ///取消回调
  VoidCallback? cancelCallback;

  @override
  TimeCircleProgressbarState createState() => TimeCircleProgressbarState();
}

class TimeCircleProgressbarState extends State<TimeCircleProgressbar> {
  late TimeCircleModel model;

  ///计时器
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    model = TimeCircleModel(currentTimeNumber: widget.currentTimeNumber ?? 15);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ///当前页面绘制完第一帧后回调
      ///在这里开启定时器

      startTimer();
    });
  }

  @override
  void dispose() {
    super.dispose();

    ///关闭
    model.streamController?.close();
    _timer.cancel();
  }

  void startTimer() {
    ///间隔100毫秒执行时间
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      ///间隔100毫秒执行一次 每次减100
      model.currentTimeNumber -= 100;

      ///如果计完成取消定时
      if (model.currentTimeNumber <= 0) {
        _timer.cancel();
        model.currentTimeNumber = 0;
        widget.timeOverCallback?.call();
      }

      ///流数据更新
      model.streamController?.add(model.currentTimeNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildStreamBuilder();
  }

  /// 监听Stream，每次值改变的时候，更新Text中的内容
  Widget buildStreamBuilder() {
    return ProviderWidget(
      model: model,
      builder: (_, m, c) {
        return StreamBuilder<double>(
          ///绑定stream
          stream: model.streamController?.stream,

          ///默认的数据
          initialData: 0,

          ///构建绑定数据的UI
          builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
            //    print("data:${snapshot.data}");
            return Stack(
              ///子Widget 居中对齐
              alignment: Alignment.center,
              children: [
                ///中间显示的文本
                Text(
                  ((snapshot.data ?? 0) / 1000).toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: widget.fontSize ?? 20,
                    color: ColorName.themeColor,
                  ),
                ),

                ///圆圈进度
                SizedBox(
                  width: widget.size ?? 70.w,
                  height: widget.size ?? 70.w,
                  child: CircularProgressIndicator(
                    value: 1.0 -
                        (snapshot.data ?? 0) / (widget.totalTimeNumber ?? 15),
                    strokeWidth: widget.strokeWidth ?? 4,
                    color: ColorName.themeColor,
                    backgroundColor: ColorName.bgColor,
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
