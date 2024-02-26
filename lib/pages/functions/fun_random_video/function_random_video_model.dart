import 'dart:math';
import 'package:musico/base/view_state_model.dart';
import 'package:musico/pages/functions/fun_random_video/bean/video_info_bean.dart';
import 'package:video_player/video_player.dart';

///  model
class FunctionRandomVideoModel extends ViewStateModel {
  FunctionRandomVideoModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {}

  VideoPlayerController? _controller;

  VideoPlayerController get videoController => _controller!;

  VideoFatherInfoBean? get videoInfoBean => _videoInfoBean;

  VideoFatherInfoBean? _videoInfoBean;

  @override
  Future<void> initData() async {
    return super.initData();
  }

  @override
  Future? loadData() async {
    if (_controller != null && (_controller?.value.isPlaying ?? false)) {
      await _controller!.dispose();
    }

    ///请求数据
    final apiResponse = await apiModel.pureGet(
      'http://baobab.kaiyanapp.com/api/v4/discovery/hot',
      params: {
        'start': Random.secure().nextInt(15),
        'num': 1,
      },
    );

    _videoInfoBean = VideoFatherInfoBean.fromJson(apiResponse.data);
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(videoInfoBean?.itemList?.first.data?.playUrl ?? ''),
    );
    await _controller!.initialize().then((_) {
      _controller!.play();
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}
