import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as screen_utils;
import 'package:musico/app/myapp.dart';
import 'package:musico/base/mixins/api_mixin.dart';
import 'package:musico/const/app_const.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/router/router.gr.dart';

///启动页
class SplashPage extends StatefulWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin, ApiMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    //隐藏头部底部导航栏 以达到全屏效果
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    //更新以及跳转
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await loadingPage();
    });
    //进度条控制器
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: splashTime),
    );
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // 设置尺寸（填写设计中设备的屏幕尺寸）如果设计基于360dp * 690dp的屏幕
    screen_utils.ScreenUtil.init(
      context,
      designSize: const Size(
        AppConst.pageWidth,
        AppConst.pageHeight,
      ),
      minTextAdapt: true, //不允许随系统改变字体大小
    );

    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Assets.images.splashBg.image(fit: BoxFit.fill, width: 1080.w),
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Assets.images.noData.defaultNoTrack
                  .image(fit: BoxFit.fill, height: 36),
            ),
          ),
          Positioned(
            bottom: 90,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget? child) {
                  return SizedBox(
                    height: 3,
                    width: 200,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(1.5)),
                      child: LinearProgressIndicator(
                        value: controller.value,
                        backgroundColor: ColorName.bgColorFFF9F9F9,
                        valueColor: AlwaysStoppedAnimation(
                          ColorName.themeColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  //启动时间
  static const splashTime = 2;

  ///加载页面
  Future<void> loadingPage() async {
    //替换到主页
    await appRouter.replace(IndexRoute());
  }
}
