import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/widgets/close_icon_widget.dart';
import 'package:musico/widgets/common/loading_button.dart';
import 'package:musico/widgets/fixed_scale_text_widget.dart';
import 'package:musico/widgets/primary_button.dart';
import 'package:musico/widgets/time_circle_progressbar/time_circle_progressbar.dart';
import 'package:musico/widgets/zz_scaffold.dart';

class CenterBaseDialog extends StatelessWidget {
  const CenterBaseDialog({
    Key? key,
    this.title = '',
    this.titleStytle,
    this.titlePadding,
    this.confirmText = '确定',
    this.cancelText = '取消',
    this.width = 270,
    this.onPressed,
    this.onCancel,
    this.onBack,
    this.radius = 13,
    this.hiddenTitle = false,
    this.hiddenCancelBtn = false,
    this.hiddenConfirmBtn = false,
    this.enableConfirmBtn = true,
    this.singleBtn = false,
    this.twoBtn = false,
    this.showCloseButton = false,
    this.showTimerButton = false,
    required this.child,
    this.top = 40,
    this.maxHeight = 420,
    this.contentBottomMargin = 10,
    this.cancelColor = const Color(0xFF999999),
  }) : super(key: key);

  final String title;
  final TextStyle? titleStytle;
  final EdgeInsets? titlePadding;
  final String confirmText;
  final String cancelText;
  final double width;
  final double radius;
  final Function? onPressed;
  final Function? onCancel;
  final Function? onBack;

  ///按返回键处理
  final Widget child;
  final bool hiddenTitle;
  final bool hiddenCancelBtn;
  final bool singleBtn;
  final bool twoBtn;
  final bool hiddenConfirmBtn;
  final bool enableConfirmBtn;
  final double top;
  final double maxHeight;
  final double contentBottomMargin;
  final bool showCloseButton;
  final bool showTimerButton;
  final Color cancelColor;

  @override
  Widget build(BuildContext context) {
    Widget cancelBtn = SizedBox(
      height: 45.0,
      child: TextButton(
        //textColor: cancelColor,
        onPressed: () {
          Navigator.pop(context);
          if (onCancel != null) onCancel!();
        },
        child: Container(
          width: double.maxFinite,
          alignment: Alignment.center,
          child: Text(
            cancelText,
            style:
                const TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );

    Widget enterBtn = SizedBox(
      height: 45.0,
      child: TextButton(
        //textColor: ColorName.themeColor,
        onPressed: enableConfirmBtn
            ? () {
                if (onPressed != null) onPressed!();
                //NavigatorUtils.finish(context);
              }
            : null,
        child: Container(
          width: double.maxFinite,
          alignment: Alignment.center,
          child: Text(
            confirmText,
            style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: ColorName.themeColor),
          ),
        ),
      ),
    );

    ///保存按钮
    Widget buildSaveButton() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF8BD0FF).withAlpha(155),
              ColorName.themeColor,
            ],
          ),
        ),
        child: TextButton(
          onPressed: enableConfirmBtn
              ? () {
                  if (onPressed != null) onPressed!();
                  //NavigatorUtils.finish(context);
                }
              : null,
          child: Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Text(
              confirmText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    ///
    Widget buildCancelButton() {
      return PrimaryButton.singleWithBorder(
        text: cancelText,
        height: 48.h,
        width: 102.h,
        fontSize: 18,
        borderColor: const Color(0xFFD7DBE3),
        color: ColorName.bgColorFFF9F9F9,
        fontColor: ColorName.textColor111a34,
        onPressed: () {
          Navigator.pop(context);
          if (onCancel != null) onCancel?.call();
        },
      );
    }

    Widget _buildBtns() {
      if (twoBtn) {
        return Padding(
          padding: EdgeInsets.only(bottom: 25.h),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 30.w,
              ),
              Expanded(
                child: buildSaveButton(),
              ),
              SizedBox(
                width: 25.w,
              ),
              buildCancelButton(),
              SizedBox(
                width: 30.w,
              ),
            ],
          ),
        );
      } else if (singleBtn) {
        return buildSaveButton();
      } else if (hiddenCancelBtn && hiddenConfirmBtn) {
        return const SizedBox.shrink();
      } else if (hiddenCancelBtn) {
        return enterBtn;
      } else if (hiddenConfirmBtn) {
        return cancelBtn;
      } else {
        return Row(
          children: <Widget>[
            Expanded(
              child: cancelBtn,
            ),
            const SizedBox(
              height: 45.0,
              width: 1,
              child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFEEEEEE))),
            ),
            Expanded(
              child: enterBtn,
            ),
          ],
        );
      }
    }

    return WillPopScope(
      onWillPop: () {
        if (onBack != null) onBack!();
        return Future.value(true);
      },
      child: FixedScaleTextWidget(
        child: ZzScaffold(
          //创建透明层
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          // 键盘弹出收起动画过渡
          body: AnimatedContainer(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewInsets.bottom,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInCubic,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radius),
              ),
              constraints: BoxConstraints(
                maxHeight: maxHeight,
              ),
              padding: EdgeInsets.only(top: top),
              width: width,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: top),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Offstage(
                          offstage: hiddenTitle,
                          child: Padding(
                            padding: titlePadding ??
                                const EdgeInsets.only(
                                  left: 12,
                                  right: 12,
                                ), //top:10,
                            child: Text(
                              hiddenTitle ? "" : title,
                              style: titleStytle ??
                                  FSUtils.font_bold_20_colorFF222429,
                            ),
                          ),
                        ),
                        if (child == null)
                          const SizedBox.shrink()
                        else
                          Flexible(child: child),
                        Visibility(
                          visible: child != null &&
                              (!hiddenCancelBtn || !hiddenConfirmBtn),
                          child: SizedBox(height: contentBottomMargin),
                        ),
                        Offstage(
                          offstage: singleBtn ||
                              (hiddenCancelBtn && hiddenConfirmBtn),
                          child: const SizedBox(
                            height: 0.5,
                            width: double.infinity,
                            child: DecoratedBox(
                                decoration:
                                    BoxDecoration(color: Color(0xFFEEEEEE))),
                          ),
                        ),
                        _buildBtns(),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Visibility(
                      visible: showCloseButton,
                      child: const CloseIconWidget(),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Visibility(
                      visible: showTimerButton,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: TimeCircleProgressbar(
                          timeOverCallback: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BaseDialog extends StatelessWidget {
  const BaseDialog(
      {Key? key,
      this.width = 270,
      this.onBack,
      this.cancelAble = false,
      required this.child,
      this.top = 15,
      this.maxHeight = 420,
      this.contentBottomMargin = 10,
      this.cancelColor = const Color(0xFF999999)})
      : super(key: key);

  final double width;

  final Function? onBack;
  final bool? cancelAble;

  ///按返回键处理
  final Widget child;

  final double top;
  final double maxHeight;
  final double contentBottomMargin;

  final Color cancelColor;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (onBack != null) onBack!();
        return Future.value(cancelAble);
      },
      child: FixedScaleTextWidget(
        child: ZzScaffold(
          //创建透明层
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          // 键盘弹出收起动画过渡
          body: AnimatedContainer(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewInsets.bottom,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInCubic,
            child: child,
          ),
        ),
      ),
    );
  }
}

class BottomBaseDialog extends StatelessWidget {
  const BottomBaseDialog({
    Key? key,
    this.onPressed,
    this.onCancel,
    this.maxHeight = 480.0,
    this.alignment = Alignment.bottomCenter,
    required this.child,
  }) : super(key: key);

  ///离顶部的最小高度
  final double maxHeight;
  final Widget child;
  final AlignmentGeometry alignment;
  final Function? onPressed;
  final Function? onCancel;
  @override
  Widget build(BuildContext context) {
    //num ddd = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      //创建透明层
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      // 键盘弹出收起动画过渡
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pop(context);
          if (onCancel != null) onCancel!();
        },
        child: AnimatedContainer(
          alignment: alignment,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewInsets.bottom,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInCubic,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (onPressed != null) onPressed!();
            },
            child: Container(
              constraints: BoxConstraints(
                maxHeight: maxHeight,
              ),
              //            decoration: BoxDecoration(
              //              color: Colors.white,
              //            ),
              width: double.infinity,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
