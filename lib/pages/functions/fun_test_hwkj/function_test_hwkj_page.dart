import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/base_page_mixin.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/pages/functions/fun_random_video/function_random_video_model.dart';
import 'package:musico/pages/functions/fun_test_hwkj/function_test_hwkj_model.dart';
import 'package:musico/widgets/zz_flow_widget.dart';
import 'package:video_player/video_player.dart';

/// hwkj 3.7.7  插件测试
class FunctionTestHwkjPage extends BasePage {
  FunctionTestHwkjPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<FunctionTestHwkjPage> createState() => _FunctionRandomMusicPageState();
}

class _FunctionRandomMusicPageState extends BasePageState<FunctionTestHwkjPage>
    with BasePageMixin<FunctionTestHwkjPage, FunctionTestHwkjModel> {
  @override
  FunctionTestHwkjModel initModel() {
    return FunctionTestHwkjModel(requestParam: widget.requestParams);
  }

  @override
  Widget buildContentWidget() {
    return Hero(
      tag: widget.requestParams?['guid'],
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(0),
                border: Border.all(color: ColorName.primaryColor, width: 4),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    model.content,
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: GridView.builder(
              itemCount: model.menus.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (c, i) {
                return InkWell(
                    onTap: () {
                      model.onTap(context, model.menus[i]);
                    },
                    child: Center(
                      child: Text(
                        model.menus[i],
                        style: const TextStyle(color: ColorName.normalTxtColor),
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
