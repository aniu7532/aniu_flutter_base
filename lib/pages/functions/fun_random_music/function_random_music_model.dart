import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musico/base/view_state_model.dart';
import 'package:musico/http/app_exception.dart';
import 'package:musico/pages/functions/fun_random_music/bean/music_info_bean.dart';

/// palylist选择 model
class FunctionRandomMusicModel extends ViewStateModel {
  FunctionRandomMusicModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam);

  MusicInfoBean? musicInfoBean;
  final player = AudioPlayer();
  @override
  Future<void> initData() async {
    return super.initData();
  }

  @override
  Future? loadData() async {
    ///每次加载前，先释放播放器资源
    if (player.state == PlayerState.playing) {
      await player.release();
    }

    ///请求数据
    final apiResponse = await get(
      'https://api.uomg.com/api/rand.music',
      params: {
        'sort': '热歌榜',
        'mid': '',
        'format': 'json',
      },
    );

    await apiResponse.map(
      success: (success) async {
        ///获取到音频信息，展示
        musicInfoBean = MusicInfoBean.fromJson(success.value.data);
        notifyListeners();

        ///获取音频真实url
        final url = await apiModel.getRedirectedUrl(musicInfoBean?.url);
        debugPrint('getRedirectedUrl:$url');

        ///处理重定向失败
        if ((url ?? '').contains('/404')) {
          await initData();
        } else {
          await player.play(UrlSource(url ?? ''));
        }
      },
      error: (error) async {
        debugPrint('success:${json.encode(error.exception.errorBean)}');
      },
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
