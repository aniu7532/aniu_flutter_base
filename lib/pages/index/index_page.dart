import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as screen_utils;
import 'package:musico/base/base_page.dart';
import 'package:musico/base/base_page_mixin.dart';
import 'package:musico/const/app_const.dart';
import 'package:musico/pages/index/idnex_model.dart';
import 'package:musico/widgets/file_select/pick_image_video_widget.dart';

///
/// 首页
///

class IndexPage extends BasePage {
  IndexPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<IndexPage> createState() => _TabSettingPageState();
}

class _TabSettingPageState extends BasePageState<IndexPage>
    with BasePageMixin<IndexPage, IndexModel> {
  @override
  IndexModel initModel() {
    return IndexModel(requestParam: widget.requestParams);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildAppBar() {
    return const SizedBox.shrink();
  }

  @override
  Widget buildContentWidget() {
    screen_utils.ScreenUtil.init(
      context,
      designSize: const Size(
        AppConst.pageWidth,
        AppConst.pageHeight,
      ),
      minTextAdapt: true,
    );

    return Center(
      child: Column(
        children: [
          Row(
            children: [
              Text('多张照片选择：'),
              Container(
                  color: Colors.greenAccent,
                  width: 300,
                  height: 300,
                  child: PickImageVideoWidget.onlyImage())
            ],
          ),
          Row(
            children: [
              Text('单张照片选择：'),
              Container(
                  color: Colors.greenAccent,
                  width: 300,
                  height: 300,
                  child: PickImageVideoWidget.singleImage())
            ],
          ),
        ],
      ),
    );
  }
}
