import 'dart:async';

import 'package:musico/base/view_state_model.dart';

class TimeCircleModel extends ViewStateModel {
  TimeCircleModel(
      {Map<String, dynamic>? requestParam, required this.currentTimeNumber})
      : super(requestParam: requestParam) {}

  ///单订阅流
  final StreamController<double>? streamController = StreamController();

  ///当前的时间
  double currentTimeNumber;
  @override
  initData() async {
    // setBusy(busy: true);
    return super.initData();
  }
}
