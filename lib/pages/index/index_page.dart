import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as screen_utils;
import 'package:musico/base/base_page.dart';
import 'package:musico/base/base_page_mixin.dart';
import 'package:musico/const/app_const.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/pages/index/bean/tab_info_bean.dart';
import 'package:musico/pages/index/idnex_model.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/image_utils.dart';

///
/// 首页
///

class IndexPage extends BasePage {
  IndexPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends BasePageState<IndexPage>
    with BasePageMixin<IndexPage, IndexModel> {
  PageController controller = PageController();

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
  Widget buildContentWidget() {
    screen_utils.ScreenUtil.init(
      context,
      designSize: const Size(
        AppConst.pageWidth,
        AppConst.pageHeight,
      ),
      minTextAdapt: true,
    );

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.w,
        crossAxisSpacing: 36.w,
      ),
      itemBuilder: (c, i) {
        return _buildFunctionItem(model.functionData[i]);
      },
      itemCount: model.functionData.length,
      padding: EdgeInsets.all(42.w),
    );
  }

  Widget _buildFunctionItem(FunctionInfoBean functionInfoBean) {
    return InkWell(
      onTap: Feedback.wrapForTap(
        () {
          model.gotoPage(functionInfoBean);
        },
        context,
      ),
      onLongPress: Feedback.wrapForTap(
        () {},
        context,
      ),
      borderRadius: BorderRadius.circular(16.w), //按压时背景圆角
      child: Card(
        shadowColor: ColorName.secondaryColor, // 阴影颜色
        elevation: 10, // 阴影高度
        borderOnForeground: false, // 是否在 child 前绘制 border，默认为 true
        // 边框
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.w),
          side: const BorderSide(
            color: ColorName.primaryColor,
            width: 8,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageUtils.loadImage(
              functionInfoBean.iconUrl ?? '',
              width: 80.w,
              height: 80.w,
            ),
            SizedBox(
              height: 12.h,
            ),
            Text(
              functionInfoBean.title ?? '',
              style: FSUtils.functionCardTitleStyle,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 100,
              child: Text(
                functionInfoBean.description ?? '',
                style: TextStyle(fontSize: 34.sp),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
