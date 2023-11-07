import 'package:flutter/material.dart';
import 'package:musico/widgets/cooldrop/controllers/dropdown_controller.dart';
import 'package:musico/widgets/cooldrop/models/cool_dropdown_item.dart';
import 'package:musico/widgets/cooldrop/options/dropdown_item_options.dart';
import 'package:musico/widgets/cooldrop/options/dropdown_options.dart';
import 'package:musico/widgets/cooldrop/options/dropdown_triangle_options.dart';
import 'package:musico/widgets/cooldrop/options/result_options.dart';
import 'package:musico/widgets/cooldrop/widgets/result_widget.dart';

export 'package:musico/widgets/cooldrop/controllers/dropdown_controller.dart';
export 'package:musico/widgets/cooldrop/customPaints/arrow_down_painter.dart';
export 'package:musico/widgets/cooldrop/enums/dropdown_align.dart';
export 'package:musico/widgets/cooldrop/enums/dropdown_animation.dart';
export 'package:musico/widgets/cooldrop/enums/dropdown_item_render.dart';
export 'package:musico/widgets/cooldrop/enums/dropdown_triangle_align.dart';
export 'package:musico/widgets/cooldrop/enums/result_render.dart';
export 'package:musico/widgets/cooldrop/enums/selected_item_align.dart';
export 'package:musico/widgets/cooldrop/options/dropdown_item_options.dart';
export 'package:musico/widgets/cooldrop/options/dropdown_options.dart';
export 'package:musico/widgets/cooldrop/options/dropdown_triangle_options.dart';
export 'package:musico/widgets/cooldrop/options/result_options.dart';

class CoolDropdown<T> extends StatelessWidget {
  final List<CoolDropdownItem<T>> dropdownList;
  final CoolDropdownItem<T>? defaultItem;

  final ResultOptions resultOptions;
  final DropdownOptions dropdownOptions;
  final DropdownItemOptions dropdownItemOptions;
  final DropdownTriangleOptions dropdownTriangleOptions;
  final DropdownController controller;

  final Function(T) onChange;
  final Function(bool)? onOpen;

  final bool isMarquee;

  CoolDropdown({
    Key? key,
    required this.dropdownList,
    this.defaultItem,
    this.resultOptions = const ResultOptions(),
    this.dropdownOptions = const DropdownOptions(),
    this.dropdownItemOptions = const DropdownItemOptions(),
    this.dropdownTriangleOptions = const DropdownTriangleOptions(),
    required this.controller,
    required this.onChange,
    this.onOpen,
    this.isMarquee = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResultWidget<T>(
      dropdownList: dropdownList,
      resultOptions: resultOptions,
      dropdownOptions: dropdownOptions,
      dropdownItemOptions: dropdownItemOptions,
      dropdownArrowOptions: dropdownTriangleOptions,
      controller: controller,
      onChange: onChange,
      onOpen: onOpen,
      defaultItem: defaultItem,
    );
  }
}
