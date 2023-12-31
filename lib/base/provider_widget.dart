import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Provider封装类
///
/// 方便数据初始化
class ProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  const ProviderWidget({
    Key? key,
    required this.model,
    required this.builder,
    this.child,
    this.onModelReady,
  }) : super(key: key);

  final Widget Function(
    BuildContext context,
    T value,
    Widget? child,
  ) builder;
  final T model;
  final Widget? child;
  final Function(T)? onModelReady;

  @override
  _ProviderWidgetState<T> createState() => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends ChangeNotifier>
    extends State<ProviderWidget<T>> {
  late T model;

  @override
  void initState() {
    model = widget.model;
    if (widget.onModelReady != null) {
      widget.onModelReady?.call(model);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}

class MyProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  const MyProviderWidget({
    Key? key,
    required this.builder,
    required this.model,
    this.child,
    this.onModelReady,
  }) : super(key: key);

  final Widget Function(
    BuildContext context,
    T value,
    Widget? child,
  ) builder;
  final T model;
  final Widget? child;
  final Function(T)? onModelReady;

  @override
  _MyProviderWidgetState<T> createState() => _MyProviderWidgetState<T>();
}

class _MyProviderWidgetState<T extends ChangeNotifier>
    extends State<MyProviderWidget<T>> {
  late T model;

  @override
  void initState() {
    model = widget.model;

    if (widget.onModelReady != null) {
      widget.onModelReady?.call(model);
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}

class ProviderWidget2<A extends ChangeNotifier, B extends ChangeNotifier>
    extends StatefulWidget {
  const ProviderWidget2({
    Key? key,
    required this.builder,
    required this.model1,
    required this.model2,
    this.child,
    this.onModelReady,
  }) : super(key: key);
  final Widget Function(
    BuildContext context,
    A value,
    B value2,
    Widget? child,
  ) builder;
  final A model1;
  final B model2;
  final Widget? child;
  final Function(A, B)? onModelReady;

  @override
  _ProviderWidgetState2<A, B> createState() => _ProviderWidgetState2<A, B>();
}

class _ProviderWidgetState2<A extends ChangeNotifier, B extends ChangeNotifier>
    extends State<ProviderWidget2<A, B>> {
  late A model1;
  late B model2;

  @override
  void initState() {
    model1 = widget.model1;
    model2 = widget.model2;

    if (widget.onModelReady != null) {
      widget.onModelReady?.call(model1, model2);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<A>(
          create: (context) => model1,
        ),
        ChangeNotifierProvider<B>(
          create: (context) => model2,
        )
      ],
      child: Consumer2<A, B>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
