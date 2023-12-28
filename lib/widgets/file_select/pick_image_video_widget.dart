import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/base/provider_widget.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/eventbus/pick_file_event.dart';
import 'package:musico/router/router.gr.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:musico/widgets/bottomsheet/file_pick_bottom_sheet.dart';
import 'package:musico/widgets/draganddrop/grid_drag/sort_grid_drag.dart';
import 'package:musico/widgets/file_select/file_bean.dart';
import 'package:musico/widgets/file_select/file_state.dart';
import 'package:musico/widgets/file_select/pick_file_item.dart';
import 'package:musico/widgets/file_select/provider/pick_image_video_model.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

typedef OnFileSelectCallBack = Function(List<FileBean> files);

class PickImageVideoWidget extends StatefulWidget {
  ///选择一个视频，多张图片
  const PickImageVideoWidget({
    Key? key,
    this.isImageSingle = false,
    this.isVideoSingle = false,
    this.isImageOnly = false,
    this.canPreviewVideo = false,
    this.canPreviewImage = false,
    this.uploadAfterChoose = false,
    this.enable = true,
    this.maxImageLength = 12,
    this.onFileCallBack,
  }) : super(key: key);

  ///只选择一张图片
  const PickImageVideoWidget.singleImage({
    Key? key,
    this.isImageSingle = true,
    this.isVideoSingle = false,
    this.isImageOnly = false,
    this.canPreviewVideo = false,
    this.canPreviewImage = false,
    this.uploadAfterChoose = false,
    this.enable = true,
    this.maxImageLength = 1,
    this.onFileCallBack,
  }) : super(key: key);

  ///只选择一个视频
  const PickImageVideoWidget.singleVideo({
    Key? key,
    this.isImageSingle = false,
    this.isVideoSingle = true,
    this.isImageOnly = false,
    this.canPreviewVideo = false,
    this.canPreviewImage = false,
    this.uploadAfterChoose = false,
    this.enable = true,
    this.maxImageLength = 0,
    this.onFileCallBack,
  }) : super(key: key);

  ///可以选择多张图片
  const PickImageVideoWidget.onlyImage({
    Key? key,
    this.isImageSingle = false,
    this.isVideoSingle = false,
    this.isImageOnly = true,
    this.canPreviewVideo = false,
    this.canPreviewImage = false,
    this.uploadAfterChoose = false,
    this.enable = true,
    this.maxImageLength = 12,
    this.onFileCallBack,
  }) : super(key: key);

  ///只单选图片
  final bool isImageSingle;

  ///只单选视频
  final bool isVideoSingle;

  ///只选择图片
  final bool isImageOnly;

  ///是否支持预览视频
  final bool canPreviewVideo;

  ///是否支持预览图片
  final bool canPreviewImage;

  ///是否可编辑
  final bool enable;

  ///选择后是否上传
  final bool uploadAfterChoose;

  final int maxImageLength;

  ///文件选择回调
  final OnFileSelectCallBack? onFileCallBack;

  @override
  State<PickImageVideoWidget> createState() => _PickImageVideoWidgetState();
}

class _PickImageVideoWidgetState extends State<PickImageVideoWidget> {
  late PickImageVideoModel model;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    model = PickImageVideoModel(
      widget.isImageSingle,
      widget.isVideoSingle,
      widget.isImageOnly,
      /**/
      widget.maxImageLength,
    );
    subscription = AppData.eventBus.on<PickFileEvent>().listen((event) {
      //从商品新增过来的
      if (event.type == 'goods_add' && ObjectUtil.isNotEmpty(event.files)) {
        model.updateFileList(event.files);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enable,
      child: ProviderWidget(
        model: model,
        builder: (_, m, c) {
          if (widget.isVideoSingle) {
            return _buildSingleVideoWidget();
          }
          if (widget.isImageSingle) {
            return _buildSingleImageWidget();
          }
          if (widget.isImageOnly) {
            return _buildImageOnlyWidget();
          }
          return _buildVideoAndImage();
        },
      ),
    );
  }

  ///选择一个视频
  Widget _buildSingleVideoWidget() {
    return _buildGridView([
      FilePickItemWidget(
        path: ObjectUtil.isEmpty(model.fileList)
            ? ''
            : model.fileList[0].preUrl ?? '',
        canAdd: widget.enable && ObjectUtil.isEmpty(model.fileList),
        canMulti: false,
        canDelete: widget.enable && ObjectUtil.isNotEmpty(model.fileList),
        canPreview: ObjectUtil.isNotEmpty(model.fileList),
        state: model.state,
        addText: '添加视频',
        onAdd: () async {
          showFilePick(
            context,
            (int type) async {
              final pickList = <AssetEntity>[];
              if (type == 2) {
                final pickedFile = await CameraPicker.pickFromCamera(
                  context,
                  pickerConfig: const CameraPickerConfig(
                    enableRecording: true,
                    onlyEnableRecording: true,
                    enableTapRecording: true,
                  ),
                );
                if (pickedFile != null) {
                  pickList.add(pickedFile);
                }
              } else {
                final pickedFile = await AssetPicker.pickAssets(
                  context,
                  pickerConfig: const AssetPickerConfig(
                    maxAssets: 1,
                    requestType: RequestType.video,
                  ),
                );
                if (pickedFile != null && ObjectUtil.isNotEmpty(pickedFile)) {
                  pickList.addAll(pickedFile);
                }
              }
              if (pickList.isNotEmpty) {
                final file = await pickList.first.originFile;
                if (file != null) {
                  model.videoState = FileState.loading;
                  const maxLength = 1024 * 1024 * 20;
                  final fileLength = await file.length();
                  if (fileLength > maxLength) {
                    model.videoState = FileState.finish;
                    MyToast.showError('视频不能超过20M');
                    return;
                  }

                  List<FileBean>? list = [];
                  if (widget.uploadAfterChoose) {
                    list = await model.uploadFileOnly([file.path]);
                  } else {
                    final fileBean = FileBean.fromEmpty();
                    fileBean.preUrl = file.path;
                    list = [fileBean];
                  }

                  if (list == null || list.length == 0) {
                    model.videoState = FileState.finish;
                    return;
                  }
                  model.fileList
                      .add(FileBean.fromJson(list[0].toJson(), isImage: false));
                  model.videoState = FileState.finish;
                  onFileListChange();
                }
              }
            },
            isImage: false,
          );
        },
        onDelete: () {
          model.fileList.clear();
          onFileListChange(notify: true);
        },
        onPreview: (int index) {
          final items = model.fileList.map((e) => e.preUrl ?? '').toList();
          appRouter.push(VideoPreviewRoute(url: items.first, autoPlay: true));
        },
      ),
    ]);
  }

  ///选择一张图片
  Widget _buildSingleImageWidget() {
    return _buildGridView([
      FilePickItemWidget(
        path: ObjectUtil.isEmpty(model.fileList)
            ? ''
            : model.fileList[0].preUrl ?? '',
        canAdd: widget.enable && ObjectUtil.isEmpty(model.fileList),
        canMulti: false,
        canDelete: widget.enable && ObjectUtil.isNotEmpty(model.fileList),
        canPreview: ObjectUtil.isNotEmpty(model.fileList),
        state: model.state,
        onAdd: () {
          showFilePick(context, (int type) async {
            final pickList = <AssetEntity>[];
            if (type == 0) {
              final pickedFile = await CameraPicker.pickFromCamera(context);
              if (pickedFile != null) {
                pickList.add(pickedFile);
              }
            } else {
              final pickedFile = await AssetPicker.pickAssets(
                context,
                pickerConfig: const AssetPickerConfig(
                  maxAssets: 1,
                  requestType: RequestType.image,
                ),
              );
              if (pickedFile != null && ObjectUtil.isNotEmpty(pickedFile)) {
                pickList.addAll(pickedFile);
              }
            }
            if (pickList.isNotEmpty) {
              model.state = FileState.loading;
              final originFile = await pickList.first.originFile;
              if (originFile != null) {
                List<FileBean>? list = [];
                if (widget.uploadAfterChoose) {
                  list = await model.uploadFileOnly([originFile.path]);
                } else {
                  final fileBean = FileBean.fromEmpty();
                  fileBean.preUrl = originFile.path;
                  list = [fileBean];
                }

                if (list == null || list.length == 0) {
                  model.videoState = FileState.finish;
                  return;
                }
                model.fileList
                    .add(FileBean.fromJson(list[0].toJson(), isImage: false));

                model.state = FileState.finish;
                onFileListChange();
              }
            }
          });
        },
        onDelete: () {
          model.fileList.clear();
          onFileListChange(notify: true);
        },
        onPreview: (int index) {
          final items = model.fileList.map((e) => e.preUrl ?? '').toList();
          appRouter.push(ImagePreViewRoute(galleryItems: items));
        },
      ),
    ]);
  }

  ///只能选择图片，最多maxLength张
  Widget _buildImageOnlyWidget() {
    return SortableGridView<FileBean>(
      model.fileList,
      itemBuilder: (ctx, FileBean bean) {
        return FilePickItemWidget(
          path: bean.preUrl ?? '',
          canAdd: widget.enable && ObjectUtil.isEmpty(bean.preUrl ?? ''),
          canDelete: widget.enable && ObjectUtil.isNotEmpty(bean.preUrl ?? ''),
          canPreview: ObjectUtil.isNotEmpty(bean.preUrl ?? ''),
          showMainTag: true,
          state: model.state,
          index: model.fileList.indexWhere(
            (e) => (bean.businessId ?? '') == (e.businessId ?? ''),
          ),
          onAdd: () {
            showFilePick(context, (int type) async {
              //当前已经上传了的图片数量
              final curLength = model.fileList
                  .where(
                    (value) =>
                        (value.isImage ?? false) &&
                        ObjectUtil.isNotEmpty(value.businessId ?? ''),
                  )
                  .length;
              final pickList = <AssetEntity>[];
              if (type == 0) {
                final pickedFile = await CameraPicker.pickFromCamera(context);
                if (pickedFile != null) {
                  pickList.add(pickedFile);
                }
              } else {
                //剩余可上传图片的数量
                final restLength = widget.maxImageLength - curLength;
                final pickedFile = await AssetPicker.pickAssets(
                  context,
                  pickerConfig: AssetPickerConfig(
                    maxAssets: restLength,
                    requestType: RequestType.image,
                  ),
                );
                if (pickedFile != null && ObjectUtil.isNotEmpty(pickedFile)) {
                  pickList.addAll(pickedFile);
                }
              }
              if (ObjectUtil.isNotEmpty(pickList)) {
                model.state = FileState.loading;
                final fList = <String>[];
                for (final f in pickList) {
                  final file = await f.originFile;
                  if (file != null) {
                    fList.add(file.path);
                  }
                }

                List<FileBean>? list = [];
                if (widget.uploadAfterChoose) {
                  list = await model.uploadFileOnly(fList);
                } else {
                  fList.forEach((element) {
                    final fileBean = FileBean.fromEmpty();
                    fileBean.preUrl = element;
                    list?.add(fileBean);
                  });
                }

                if (list == null) {
                  model.state = FileState.finish;
                  return;
                }

                //增加图片,在最后一张图片的位置
                model.fileList.insertAll(curLength, list);

                final newLength = model.fileList
                    .where(
                      (value) =>
                          (value.isImage ?? false) &&
                          ObjectUtil.isNotEmpty(value.businessId ?? ''),
                    )
                    .length;
                //已达到最大数量
                if (newLength >= widget.maxImageLength) {
                  //删除新增的按钮
                  model.fileList.removeWhere(
                    (e) =>
                        (e.isImage ?? false) &&
                        ObjectUtil.isEmpty(e.businessId ?? ''),
                  );
                }
                model.state = FileState.finish;
                onFileListChange();
              }
            });
          },
          onDelete: () {
            model.onDeleteMultiImage(bean);
            onFileListChange(notify: true);
          },
          onPreview: (int index) {
            final previewList = model.fileList.where(
              (e) => ObjectUtil.isNotEmpty(e.businessId ?? ''),
            );
            final items = previewList.map((e) => e.preUrl ?? '').toList();
            appRouter.push(
              ImagePreViewRoute(galleryItems: items, initialIndex: index),
            );
          },
        );
      },
      canAccept: (int oldIndex, int newIndex, List<FileBean> list) {
        if (oldIndex == newIndex) {
          return false;
        }
        //交换位置
        final oldBean = model.fileList[oldIndex];
        model.fileList.removeWhere(
          (e) => (e.businessId ?? '') == (oldBean.businessId ?? ''),
        );
        model.fileList.insert(newIndex, oldBean);
        onFileListChange();
        return true;
      },
    );
  }

  ///选择一个视频和多张图片
  Widget _buildVideoAndImage() {
    return SortableGridView<FileBean>(
      model.fileList,
      itemBuilder: (ctx, FileBean bean) {
        var preUrl = bean.preUrl ?? '';
        if (bean.coverImage != null &&
            ObjectUtil.isNotEmpty(bean.coverImage!.preUrl)) {
          preUrl = bean.coverImage!.preUrl ?? '';
        }
        if (!(bean.isImage ?? false)) {
          //选择视频
          return FilePickItemWidget(
            path: preUrl,
            canAdd: widget.enable && ObjectUtil.isEmpty(bean.preUrl ?? ''),
            canMulti: false,
            canDelete:
                widget.enable && ObjectUtil.isNotEmpty(bean.preUrl ?? ''),
            canPreview: false,
            canCover: true,
            hasCover: model.fileList[0].coverImage != null &&
                ObjectUtil.isNotEmpty(model.fileList[0].coverImage!.mediaId),
            state: model.videoState,
            addText: '添加视频',
            onAdd: () {
              showFilePick(
                context,
                (int type) async {
                  final pickList = <AssetEntity>[];
                  if (type == 2) {
                    final pickedFile = await CameraPicker.pickFromCamera(
                      context,
                      pickerConfig: const CameraPickerConfig(
                        enableRecording: true,
                        onlyEnableRecording: true,
                        enableTapRecording: true,
                      ),
                    );
                    if (pickedFile != null) {
                      pickList.add(pickedFile);
                    }
                  } else {
                    final pickedFile = await AssetPicker.pickAssets(
                      context,
                      pickerConfig: const AssetPickerConfig(
                        maxAssets: 1,
                        requestType: RequestType.video,
                      ),
                    );
                    if (pickedFile != null &&
                        ObjectUtil.isNotEmpty(pickedFile)) {
                      pickList.addAll(pickedFile);
                    }
                  }
                  if (pickList.isNotEmpty) {
                    final file = await pickList.first.originFile;
                    if (file != null) {
                      model.videoState = FileState.loading;
                      const maxLength = 1024 * 1024 * 20;
                      final fileLength = await file.length();
                      if (fileLength > maxLength) {
                        model.videoState = FileState.finish;
                        MyToast.showError('视频不能超过20M');
                        return;
                      }
                      final list = await model.uploadFileOnly([file.path]);
                      if (list == null) {
                        model.videoState = FileState.finish;
                        return;
                      }
                      model.fileList[0] =
                          FileBean.fromJson(list[0].toJson(), isImage: false);
                      model.videoState = FileState.finish;
                      onFileListChange();
                    }
                  }
                },
                isImage: false,
              );
            },
            onDelete: () {
              model.fileList[0] = FileBean.fromEmpty();
              onFileListChange(notify: true);
            },
            onAddCover: () {
              showFilePick(context, (int type) async {
                //上传封面
                final pickList = <AssetEntity>[];
                if (type == 0) {
                  final pickedFile = await CameraPicker.pickFromCamera(context);
                  if (pickedFile != null) {
                    pickList.add(pickedFile);
                  }
                } else {
                  final pickedFile = await AssetPicker.pickAssets(
                    context,
                    pickerConfig: const AssetPickerConfig(
                      maxAssets: 1,
                      requestType: RequestType.image,
                    ),
                  );
                  if (pickedFile != null && ObjectUtil.isNotEmpty(pickedFile)) {
                    pickList.addAll(pickedFile);
                  }
                }
                if (pickList.isNotEmpty) {
                  final file = await pickList.first.originFile;
                  if (file != null) {
                    model.videoState = FileState.loading;
                    final list = await model.uploadFileOnly([file.path]);
                    if (list == null) {
                      model.videoState = FileState.finish;
                      return;
                    }
                    model.fileList[0].coverImage =
                        FileBean.fromJson(list[0].toJson());
                    model.videoState = FileState.finish;
                    onFileListChange(notify: true);
                  }
                }
              });
            },
            onPreview: (int index) {},
          );
        }
        return FilePickItemWidget(
          path: bean.preUrl ?? '',
          canAdd: widget.enable && ObjectUtil.isEmpty(bean.preUrl ?? ''),
          canDelete: widget.enable && ObjectUtil.isNotEmpty(bean.preUrl ?? ''),
          canPreview: ObjectUtil.isNotEmpty(bean.preUrl ?? ''),
          showMainTag: true,
          state: model.state,
          index: model.fileList.indexWhere(
                (e) => (bean.businessId ?? '') == (e.businessId ?? ''),
              ) -
              1,
          onAdd: () async {
            showFilePick(context, (int type) async {
              //当前已经上传了的图片数量
              final curLength = model.fileList
                  .where(
                    (value) =>
                        (value.isImage ?? false) &&
                        ObjectUtil.isNotEmpty(value.businessId ?? ''),
                  )
                  .length;
              final pickList = <AssetEntity>[];
              if (type == 0) {
                final pickedFile = await CameraPicker.pickFromCamera(context);
                if (pickedFile != null) {
                  pickList.add(pickedFile);
                }
              } else {
                //剩余可上传图片的数量
                final restLength = widget.maxImageLength - curLength;
                final pickedFile = await AssetPicker.pickAssets(
                  context,
                  pickerConfig: AssetPickerConfig(
                    maxAssets: restLength,
                    requestType: RequestType.image,
                  ),
                );
                if (pickedFile != null && ObjectUtil.isNotEmpty(pickedFile)) {
                  pickList.addAll(pickedFile);
                }
              }
              if (ObjectUtil.isNotEmpty(pickList)) {
                model.state = FileState.loading;
                final fList = <String>[];
                for (final f in pickList) {
                  final file = await f.originFile;
                  if (file != null) {
                    fList.add(file.path);
                  }
                }
                final list = await model.uploadFileOnly(
                  fList,
                  isImage: true,
                );
                if (list == null) {
                  model.state = FileState.finish;
                  return;
                }

                //增加图片,在最后一张图片的位置
                model.fileList.insertAll(curLength + 1, list);

                final newLength = model.fileList
                    .where(
                      (value) =>
                          (value.isImage ?? false) &&
                          ObjectUtil.isNotEmpty(value.businessId ?? ''),
                    )
                    .length;
                //已达到最大数量
                if (newLength >= widget.maxImageLength) {
                  //删除新增的按钮
                  model.fileList.removeWhere(
                    (e) =>
                        (e.isImage ?? false) &&
                        ObjectUtil.isEmpty(e.businessId ?? ''),
                  );
                }
                model.state = FileState.finish;
                onFileListChange();
              }
            });
          },
          onDelete: () {
            model.onDeleteMultiImage(bean);
            onFileListChange(notify: true);
          },
          onPreview: (int index) {
            final previewList = model.fileList.where(
              (e) =>
                  (e.isImage ?? false) &&
                  ObjectUtil.isNotEmpty(e.businessId ?? ''),
            );
            final items = previewList.map((e) => e.preUrl ?? '').toList();
            appRouter.push(
              ImagePreViewRoute(galleryItems: items, initialIndex: index),
            );
          },
        );
      },
      canAccept: (int oldIndex, int newIndex, List<FileBean> list) {
        if (oldIndex == newIndex) {
          return false;
        }
        //交换位置
        final oldBean = model.fileList[oldIndex];
        model.fileList.removeWhere(
          (e) => (e.businessId ?? '') == (oldBean.businessId ?? ''),
        );
        model.fileList.insert(newIndex, oldBean);
        onFileListChange();
        return true;
      },
    );
  }

  ///文件修改后调用
  void onFileListChange({bool notify = false}) {
    if (widget.onFileCallBack != null) {
      widget.onFileCallBack!(model.fileList);
    }
    if (notify) {
      model.notifyListeners();
    }
  }

  Widget _buildGridView(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(5),
      color: Colors.white,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        crossAxisCount: 4,
        childAspectRatio: 1,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        children: children,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }
}
