import 'package:musico/gen/colors.gen.dart';
import 'package:musico/generated/l10n.dart';
import 'package:musico/router/router.dart';
import 'package:musico/router/router.gr.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final appRouter = AppRouter();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      // 1.亮度 Brightness.dark就是暗黑模式，一般我们不设置
      brightness: Brightness.light,
      // 2.primarySwatch传入不是Color, 而是MaterialColor，是继承于Color的
      // 包含了primaryColor和accentColor
      // 设置完之后，导航条的颜色，TabBar的颜色，Switch的颜色，floatingActionButton的颜色都会改变
      primarySwatch: Colors.red,
      // 3.primaryColor: 单独设置导航和TabBar的颜色，会覆盖primarySwatch
      primaryColor: ColorName.primaryColor,
      // 4.accentColor: 单独设置FloatingActionButton、Switch的颜色
      accentColor: ColorName.primaryColor,
      // 5.Button的主题
/*        buttonTheme: const ButtonThemeData(
          // 默认是88x36
          height: 25,
          minWidth: 10,
          buttonColor: ColorName.secondaryColor,
        ),*/
      // 6.Card的主题
      cardTheme: const CardTheme(
        // 背景颜色
        color: Colors.white,
        // 阴影
        elevation: 11,
      ),
      // 7.Text的主题
      textTheme: const TextTheme(
        titleSmall: TextStyle(color: Colors.white, fontSize: 18),
        titleMedium: TextStyle(color: Colors.white, fontSize: 18),
        titleLarge: TextStyle(color: Colors.white, fontSize: 18),
      ),
      //8.appbar
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        titleTextStyle: TextStyle(color: Colors.red, fontSize: 18),
        toolbarTextStyle: TextStyle(color: Colors.red, fontSize: 18),
      ),
      //9.全局背景色
      scaffoldBackgroundColor: ColorName.bgColor,
      colorScheme: Theme.of(context)
          .colorScheme
          .copyWith(secondary: ColorName.secondaryColor.withOpacity(0.4)),
    );

    return MaterialApp.router(
      // 全局主题
      theme: theme,
      darkTheme: theme,

      debugShowCheckedModeBanner: dotenv.get('IS_PRODUCTION') == '0',
      routeInformationParser: appRouter.defaultRouteParser(),
      routeInformationProvider: appRouter.routeInfoProvider(),
      routerDelegate: AutoRouterDelegate(
        appRouter,
        navigatorObservers: () => [AppRouteObserver()],
      ),
      builder: MyToast.init(
        builder: (context, child) {
          return child!;
        },
      ),
      //默认显示英文
      locale: const Locale('en'),
      localizationsDelegates: const [
        RefreshLocalizations.delegate,
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
        //print("change language");
        return locale;
      },
    );
  }
}
