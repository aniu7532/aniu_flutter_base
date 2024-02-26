import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/base_page_mixin.dart';
import 'package:musico/common.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/pages/functions/fun_random_music/bean/music_info_bean.dart';
import 'package:musico/pages/functions/fun_random_music/function_random_music_model.dart';
import 'package:musico/pages/functions/fun_random_music/widget/music_seek.dart';
import 'package:musico/utils/image_utils.dart';

/// Ai功能模块
class FunctionRandomMusicPage extends BasePage {
  FunctionRandomMusicPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams) {}

  @override
  State<FunctionRandomMusicPage> createState() =>
      _FunctionRandomMusicPageState();
}

class _FunctionRandomMusicPageState
    extends BasePageState<FunctionRandomMusicPage>
    with BasePageMixin<FunctionRandomMusicPage, FunctionRandomMusicModel> {
  @override
  FunctionRandomMusicModel initModel() {
    return FunctionRandomMusicModel(requestParam: widget.requestParams);
  }

  @override
  Widget buildContentWidget() {
    return Stack(
      children: [
        ImageUtils.loadImage(
          model.musicInfoBean?.picurl ?? '',
          width: double.infinity,
          height: double.infinity,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15,
            sigmaY: 15,
            tileMode: TileMode.repeated,
          ),
          child: Container(
            color: Colors.black.withOpacity(0.3),
          ),
        ),
        StreamBuilder(
          stream: model.player.onDurationChanged,
          builder: (c, total) {
            if (total != null && total.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ImageUtils.loadImageWithRadius(
                          model.musicInfoBean?.picurl ?? '',
                          width: 300,
                          height: 280,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                            '${model.musicInfoBean?.name ?? '未知'} - ${model.musicInfoBean?.artistsname ?? '未知'}'),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 16),
                    child: MusicSeek(
                      player: model.player,
                      duration: total.data ?? Duration.zero,
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );

    /*  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageUtils.loadImageWithRadius(
                model.musicInfoBean?.picurl ?? '',
                width: 300,
                height: 280,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                  '${model.musicInfoBean?.name ?? '未知'} - ${model.musicInfoBean?.artistsname ?? '未知'}'),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
          child: MusicSeek(
            player: model.player,
          ),
        ),
      ],
    );*/
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
}
