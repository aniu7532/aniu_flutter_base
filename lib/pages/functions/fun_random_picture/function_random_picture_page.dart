import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/base_page_mixin.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/generated/l10n.dart';
import 'package:musico/pages/functions/fun_random_picture/function_random_picture_model.dart';
import 'package:musico/widgets/text/animated_text.dart';
import 'package:musico/utils/image_utils.dart';
import 'package:musico/widgets/my_expansion.dart';
import 'package:photo_view/photo_view.dart';

/// picture功能模块
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
    return Hero(
      tag: widget.requestParams?['guid'],
      child: Center(
        child: Column(
          children: [
            Expanded(child: _buildPictureLauncher()),
            buildClassify(),
          ],
        ),
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
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: ColorName.primaryColor, shape: BoxShape.circle),
        child: const Icon(
          Icons.change_circle_outlined,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPictureLauncher() {
    return Stack(
      fit: StackFit.expand,
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        if (model.classify == 5)
          PhotoView(
            imageProvider: NetworkImage(model.imageUrl),
          )
        else
          ImageUtils.loadMaxImage(
            model.imageUrl,
            needSave: true,
            context: context,
          ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: Visibility(
            visible: !ObjectUtil.isEmptyString(model.description),
            child: Container(
              decoration: BoxDecoration(
                color: ColorName.primaryColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: MarqueeText(
                text: model.description,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
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
          title: Text(
            S.of(context).cat,
            style: const TextStyle(color: ColorName.primaryColor),
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
          title: Text(
            S.of(context).dog,
            style: const TextStyle(color: ColorName.primaryColor),
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
          title: Text(
            S.of(context).astronomy,
            style: const TextStyle(color: ColorName.primaryColor),
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
          groupValue: 3,
          onChanged: (v) {
            model.setClassify(3);
          },
        ),
        RadioListTile(
          title: Text(
            S.of(context).car,
            style: const TextStyle(color: ColorName.primaryColor),
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
          selected: model.classify == 4,
          groupValue: 4,
          onChanged: (v) {
            model.setClassify(4);
          },
        ),
        RadioListTile(
          title: Text(
            S.of(context).leg,
            style: const TextStyle(color: ColorName.primaryColor),
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
          selected: model.classify == 5,
          groupValue: 5,
          onChanged: (v) {
            model.setClassify(5);
          },
        ),
      ],
    );
  }
}
