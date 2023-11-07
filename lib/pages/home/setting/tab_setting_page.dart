import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/pages/home/setting/setting_model.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/plugins/usb_scan_plugin.dart';
import 'package:musico/widgets/tablet/signature.dart';

///Setting
class TabSettingPage extends BasePage {
  TabSettingPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<TabSettingPage> createState() => _TabSettingPageState();
}

class _TabSettingPageState extends BasePageState<TabSettingPage>
    with ListMoreSearchPageStateMixin<TabSettingPage, SettingModel> {
  late List<CameraDescription> cameras;

  late CameraDescription firstCamera = cameras.first;

  late CameraController controller;
  late String imagePath;

  late Future<void> _initializeControllerFuture;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    exportBackgroundColor: Colors.white,
  );
  @override
  SettingModel initModel() {
    return SettingModel(requestParam: widget.requestParams);
  }

  @override
  void initState() {
    super.initState();
    // Obtain a list of the available cameras on the device.
    availableCameras().then((value) {
      cameras = value;
      firstCamera = cameras.first;
      controller = CameraController(cameras[1], ResolutionPreset.medium);
      // Next, initialize the controller. This returns a Future.
      _initializeControllerFuture = controller.initialize();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget buildAppBar() {
    return AppBar(
      leadingWidth: 200,
      leading: Container(
        height: 18.h,
        margin: const EdgeInsets.only(left: 16),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  @override
  Widget getItemWidget(item, index) {
    final ImportItemBean bean = item;
    return InkWell(
      onTap: () {
        model.click(index, context);
      },
      child: bean.haveCamera
          ? FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return Row(
                    children: [
                      SizedBox(
                        width: 50.w,
                        height: 150.h,
                        child: CameraPreview(controller),
                      ),
                      InkWell(
                        onTap: () async {
                          await UsbScantPlugin.initUsbScanService();
                        },
                        child: const Text(
                          'usb scan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 50.w,
                        height: 150.h,
                        child: Signature(
                          controller: _controller,
                          backgroundColor: Colors.white,
                          screenCapGlobalKey: globalKey,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          // Take the Picture in a try / catch block. If anything goes wrong,
                          // catch the error.
                          try {
                            // Ensure that the camera is initialized.
                            await _initializeControllerFuture;

                            // Attempt to take a picture and log where it's been saved.
                            await controller
                                .takePicture()
                                .then((XFile afterFile) async {
                              if (controller.value.isInitialized) {
                                if (afterFile != null) {
                                  imagePath = afterFile.path;
                                  print(
                                      '第一张图片保存在------${afterFile.path}---------');
                                }
                              }
                            });

                            // If the picture was taken, display it on a new screen.
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DisplayPictureScreen(imagePath: imagePath),
                              ),
                            );
                          } catch (e) {
                            // If an error occurs, log the error to the console.
                            print(e);
                          }
                        },
                        child: const Text(
                          'take photo',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  );
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          : Container(
              height: 75.h,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const SizedBox(
                    width: 18,
                  ),
                  Expanded(
                    child: Text(
                      bean.title,
                      style: FSUtils.weight500_14_FFFFFF,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // _initializeCameraController(cameraController.description);
    }
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String? imagePath;

  const DisplayPictureScreen({Key? key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath ?? '')),
    );
  }
}
