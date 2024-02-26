import 'package:flutter/material.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/provider_widget.dart';
import 'package:musico/base/view_state_model.dart';
import 'package:musico/base/view_state_widget.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/widgets/zz_app_bar.dart';
import 'package:musico/widgets/zz_scaffold.dart';
import 'package:musico/widgets/zz_title_widget.dart';

///页面加载数据使用
///M: 数据控制model
mixin BasePageMixin<T extends BasePage, M extends ViewStateModel>
    on BasePageState<T> {
  late M model;

  @override
  void initState() {
    super.initState();
    model = initModel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPop,
      child: needNotifyAll()
          ? ProviderWidget<M>(
              model: model,
              onModelReady: (model) {
                ///初始化
                model.initData();
              },
              builder: (context, model, child) {
                return buildRoot();
              },
            )
          : buildRoot(),
    );
  }

  ///
  /// 根布局
  ///
  Widget buildRoot() {
    return buildContainerWidget() ??
        ZzScaffold(
          appBar: buildAppBar() ??
              ZzAppBar(
                backgroundColor: ColorName.primaryColor,
                title: buildTitle(),
                actions: <Widget>[
                  ...getActions(),
                ],
              ),
          body: Column(
            children: [
              buildTopHeaderWidget(),
              Expanded(child: buildContent()),
              buildBottomWidget(),
            ],
          ),
          floatingActionButton: buildFloatingActionButton(),
        );
  }

  ///必须实现
  @protected
  M initModel();

  ///重载，实现自定义的AppBar
  @protected
  Widget? buildAppBar() {
    return null;
  }

  ///重载，不需要全局刷新
  @protected
  bool needNotifyAll() {
    return true;
  }

  ///重载，实现自定义的Title
  @protected
  Widget buildTitle() {
    return ZzTitle(
      widget.title ?? '',
    );
  }

  ///重载，实现右侧按钮
  @protected
  List<Widget> getActions() {
    return [];
  }

  ///主要内容
  Widget buildContent() {
    ///异常状态显示
    if (model.needStateControl &&
        (!model.idle || LoadStatusWidget.isEmpty(model))) {
      return LoadStatusWidget(model: model);
    }

    final header = buildHeaderWidget();

    var result = buildContentWidget();

    if (header != null) {
      result = Column(
        children: <Widget>[
          header,
          Expanded(
            child: result,
          ),
        ],
      );
    }
    return result;
  }

  ///防止被 暂无数据页面替换
  ///顶级头部组件
  Widget buildTopHeaderWidget() {
    return const SizedBox.shrink();
  }

  ///防止被 暂无数据页面替换
  ///顶级底部组件
  Widget buildBottomWidget() {
    return const SizedBox.shrink();
  }

  ///生成显示页面  需要用户实现
  @protected
  Widget buildContentWidget();

  ///
  /// 需要
  Widget? buildHeaderWidget() {
    return null;
  }

  ///
  /// 需要
  Widget? buildFloatingActionButton() {
    return const SizedBox.shrink();
  }

  ///
  /// 重写整个root
  ///
  @protected
  Widget? buildContainerWidget() {
    return null;
  }

  ///返回事件处理
  Future<bool> willPop() async {
    return true;
  }
}
