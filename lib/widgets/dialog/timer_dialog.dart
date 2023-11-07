/*
 *  This file is part of BlackHole (https://github.com/Sangwan5688/BlackHole).
 * 
 * BlackHole is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * BlackHole is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with BlackHole.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Copyright (c) 2021-2022, Ankit Sangwan
 */

import 'package:flustars/flustars.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:flutter/material.dart';
import 'package:musico/utils/image_utils.dart';
import 'package:musico/widgets/fixed_scale_text_widget.dart';

import 'center_base_dialog.dart';

///
///带倒计时
///提示弹窗
class TimerDialog extends StatefulWidget {
  TimerDialog({
    Key? key,
    this.title = '标题',
    this.content,
    this.subContent,
    this.confirmText = "确认",
    this.cancelText = '取消',
    this.onConfirm,
    this.onConfirmWithCheckBox,
    this.onCancel,
    this.onBack,
    this.hiddenCancelBtn,
    this.hiddenConfirmBtn,
    this.autoFinish = true,
    this.bottom = 10,
    this.radius = 30,
    this.contentPaddingHorizontal = 13,
    this.contentPaddingVertical = 10,
  }) : super(key: key);

  final String title;
  final String? content;
  final String? subContent;
  final String confirmText;
  final String cancelText;
  final Function? onConfirm;
  final Function? onConfirmWithCheckBox;
  final Function? onCancel;
  final Function? onBack;
  final bool? hiddenCancelBtn;
  final bool? hiddenConfirmBtn;
  final bool autoFinish;
  final double bottom;
  final double radius;
  final double contentPaddingHorizontal;
  final double contentPaddingVertical;

  @override
  State<TimerDialog> createState() => _TimerDialogState();
}

bool b = false;

class _TimerDialogState extends State<TimerDialog> {
  @override
  Widget build(BuildContext context) {
    return FixedScaleTextWidget(
      child: CenterBaseDialog(
        width: MediaQuery.of(context).size.width * 0.8,
        title: widget.title,
        radius: widget.radius,
        cancelText: widget.cancelText,
        confirmText: widget.confirmText,
        contentBottomMargin: widget.bottom,
        showTimerButton: true,
        hiddenTitle: widget.title == null || widget.title.isEmpty,
        onPressed: () {
          if (widget.autoFinish) Navigator.pop(context);
          if (widget.onConfirm != null) {
            widget.onConfirm!();
          }
          if (widget.onConfirmWithCheckBox != null) {
            widget.onConfirmWithCheckBox!(b);
          }
        },
        onCancel: () {
          b = false;
          if (widget.onCancel != null) widget.onCancel!();
        },
        onBack: widget.onBack,
        hiddenCancelBtn: widget.hiddenCancelBtn ?? false,
        hiddenConfirmBtn: widget.hiddenConfirmBtn ?? false,
        child: ObjectUtil.isEmpty(widget.content)
            ? const SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.contentPaddingHorizontal,
                  vertical: widget.contentPaddingVertical,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        widget.content ?? '',
                        style: FSUtils.font_normal_14_color515151,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
