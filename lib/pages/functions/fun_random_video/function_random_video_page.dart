import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/base_page_mixin.dart';
import 'package:musico/pages/functions/fun_random_video/function_random_video_model.dart';
import 'package:video_player/video_player.dart';

/// video功能模块
class FunctionRandomVideoPage extends BasePage {
  FunctionRandomVideoPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams) {}

  @override
  State<FunctionRandomVideoPage> createState() =>
      _FunctionRandomMusicPageState();
}

class _FunctionRandomMusicPageState
    extends BasePageState<FunctionRandomVideoPage>
    with BasePageMixin<FunctionRandomVideoPage, FunctionRandomVideoModel> {
  @override
  FunctionRandomVideoModel initModel() {
    return FunctionRandomVideoModel(requestParam: widget.requestParams);
  }

  @override
  Widget buildContentWidget() {
    if (ObjectUtil.isEmptyString(
      model.videoInfoBean?.itemList?.first.data?.playUrl ?? '',
    )) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    } else {
      return Center(
        child: model.videoController.value.isInitialized
            ? _buildVideoPlayer()
            : const CupertinoActivityIndicator(),
      );
    }
  }

  @override
  Widget? buildAppBar() {
    return const SizedBox.shrink();
  }

  @override
  Widget? buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        model.initData();
      },
      child: const Icon(
        Icons.change_circle_outlined,
        color: Colors.white,
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return GestureDetector(
      onTap: () {
        if (model.videoController.value.isPlaying) {
          model.videoController.pause();
        } else {
          model.videoController.play();
        }
        setState(() {});
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: model.videoController.value.aspectRatio,
            child: VideoPlayer(model.videoController),
          ),
          if (!model.videoController.value.isPlaying)
            const Icon(
              Icons.play_arrow_outlined,
              size: 100,
              color: Colors.white,
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
