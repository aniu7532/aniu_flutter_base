import 'package:flutter/material.dart';
import 'package:musico/widgets/zz_show_model_bottom_sheet.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/utils/divider_urils.dart';

///
///Create by ls on 2022/8/10 13:39
///
///Description: 文件选择
///
void showFilePick(
  BuildContext context,
  Function(int) onCallback, {
  bool isImage = true,
}) {
  FocusScope.of(context).unfocus();
  zzShowModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return FilePickWidget(
        isImage: isImage,
        onCallback: onCallback,
      );
    },
  );
}

class FilePickWidget extends StatelessWidget {
  const FilePickWidget({
    Key? key,
    required this.onCallback,
    this.isImage = true,
  }) : super(key: key);

  ///true 图片  false 视频
  final bool isImage;

  ///选择回调  0 拍照,1 从相册中选择照片,2 拍视频,3 从相册选择视频
  final Function(int) onCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: appRouter.pop,
            child: Container(
              color: Colors.transparent,
              height: double.infinity,
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          child: Column(
            children: [
              ...showList(),
              Container(
                width: double.infinity,
                height: 10,
                color: Colors.grey[200],
              ),
              // 取消按钮
              InkWell(
                onTap: appRouter.pop,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text(
                    '取消',
                    style: TextStyle(
                      fontSize: 18,
                      color: ColorName.normalTxtColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> showList() {
    if (isImage) {
      return [
        _buildItem('拍照', () {
          onCallback(0);
        }),
        dividerList1,
        _buildItem('从相册选择', () {
          onCallback(1);
        })
      ];
    }
    return [
      _buildItem('拍摄', () {
        onCallback(2);
      }),
      dividerList1,
      _buildItem('从相册选择', () {
        onCallback(3);
      })
    ];
  }

  Widget _buildItem(String name, Function onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        appRouter.pop();
        Future.delayed(const Duration(milliseconds: 200)).then((value) {
          onTap();
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        alignment: Alignment.center,
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            color: ColorName.txtColor41485d,
          ),
        ),
      ),
    );
  }
}
