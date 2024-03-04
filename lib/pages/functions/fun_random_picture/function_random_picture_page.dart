import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/base_page_mixin.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/pages/functions/fun_random_picture/function_random_picture_model.dart';
import 'package:musico/pages/functions/fun_random_video/function_random_video_model.dart';
import 'package:musico/utils/image_utils.dart';
import 'package:musico/widgets/my_expansion.dart';
import 'package:video_player/video_player.dart';

/// video功能模块
class FunctionRandomPicturePage extends BasePage {
  FunctionRandomPicturePage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams) {}

  @override
  State<FunctionRandomPicturePage> createState() =>
      _FunctionRandomMusicPageState();
}

class _FunctionRandomMusicPageState
    extends BasePageState<FunctionRandomPicturePage>
    with BasePageMixin<FunctionRandomPicturePage, FunctionRandomPictureModel> {
  @override
  FunctionRandomPictureModel initModel() {
    return FunctionRandomPictureModel(requestParam: widget.requestParams);
  }

  @override
  Widget buildContentWidget() {
    return Center(
      child: Column(
        children: [
          Expanded(child: _buildPictureLauncher()),
          buildClassify(),
        ],
      ),
    );
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

  Widget _buildPictureLauncher() {
    return ImageUtils.loadMaxImage(model.imageUrl);
  }

  Widget buildClassify() {
    return MyExpansionTile(
      key: model.expandKey,
      leading: const Icon(
        Icons.sort_rounded,
        color: ColorName.primaryColor,
      ),
      title: const Text(
        '选择类型',
        style: TextStyle(color: ColorName.primaryColor),
      ),
      backgroundColor: Colors.white,
      onExpansionChanged: (value) {
        print('$value');
      },
      initiallyExpanded: false,
      children: [
        RadioListTile(
          title: const Text(
            '风景壁纸',
            style: TextStyle(color: ColorName.primaryColor),
          ),
          activeColor: ColorName.primaryColor,
          selected: model.classify == 0,
          value: model.classify,
          groupValue: 0,
          onChanged: (v) {
            model.setClassify(0);
          },
          secondary: Padding(
            padding: const EdgeInsets.only(right: 80),
            child: CircleAvatar(
              backgroundColor: ColorName.primaryColor,
              child: Assets.images.menuView.image(color: Colors.white),
            ),
          ),
        ),
        RadioListTile(
          title: const Text(
            'cat',
            style: TextStyle(color: ColorName.primaryColor),
          ),
          activeColor: ColorName.primaryColor,
          value: model.classify,
          selected: model.classify == 1,
          groupValue: 1,
          onChanged: (v) {
            model.setClassify(1);
          },
          secondary: Padding(
            padding: const EdgeInsets.only(right: 80),
            child: CircleAvatar(
              backgroundColor: ColorName.primaryColor,
              child: Assets.images.menuCat.image(color: Colors.white),
            ),
          ),
        ),
        RadioListTile(
          title: const Text(
            'dog',
            style: TextStyle(color: ColorName.primaryColor),
          ),
          secondary: Padding(
            padding: const EdgeInsets.only(right: 80),
            child: CircleAvatar(
              backgroundColor: ColorName.primaryColor,
              child: Assets.images.menuDog.image(color: Colors.white),
            ),
          ),
          activeColor: ColorName.primaryColor,
          value: model.classify,
          selected: model.classify == 2,
          groupValue: 2,
          onChanged: (v) {
            model.setClassify(2);
          },
        ),
        RadioListTile(
          title: const Text(
            'girl',
            style: TextStyle(color: ColorName.primaryColor),
          ),
          secondary: Padding(
            padding: const EdgeInsets.only(right: 80),
            child: CircleAvatar(
              backgroundColor: ColorName.primaryColor,
              child: Assets.images.menuGirl.image(color: Colors.white),
            ),
          ),
          activeColor: ColorName.primaryColor,
          value: model.classify,
          selected: model.classify == 3,
          groupValue: 2,
          onChanged: (v) {
            model.setClassify(3);
          },
        ),
      ],
    );
  }
}
