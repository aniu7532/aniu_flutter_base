import 'package:flutter/material.dart';
import 'package:musico/widgets/zz_back_button.dart';

class ZzAppBar extends AppBar {
  ZzAppBar({
    Key? key,
    leading,
    automaticallyImplyLeading = true,
    title,
    actions,
    flexibleSpace,
    bottom,
    shadowColor,
    shape,
    backgroundColor,
    foregroundColor,
    iconTheme,
    actionsIconTheme,
    primary = true,
    centerTitle,
    excludeHeaderSemantics = false,
    titleSpacing,
    toolbarOpacity = 1.0,
    bottomOpacity = 1.0,
    toolbarHeight,
    leadingWidth,
    toolbarTextStyle,
    titleTextStyle = const TextStyle(color: Colors.red),
    systemOverlayStyle,
  }) : super(
          key: key,
          leading: leading ?? const ZzBackButton(),
          automaticallyImplyLeading: automaticallyImplyLeading ?? true,
          title: title,
          actions: actions,
          flexibleSpace: flexibleSpace,
          bottom: bottom,
          elevation: 0, //设置无阴影
          shadowColor: shadowColor,
          shape: shape,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          iconTheme: iconTheme,
          actionsIconTheme: actionsIconTheme,
          primary: primary ?? true,
          centerTitle: centerTitle ?? true,
          excludeHeaderSemantics: excludeHeaderSemantics ?? false,
          titleSpacing: titleSpacing,
          toolbarOpacity: toolbarOpacity ?? 1.0,
          bottomOpacity: bottomOpacity ?? 1.0,
          toolbarHeight: toolbarHeight,
          leadingWidth: leadingWidth,
          toolbarTextStyle: toolbarTextStyle,
          titleTextStyle: titleTextStyle,
          systemOverlayStyle: systemOverlayStyle,
        );
}
