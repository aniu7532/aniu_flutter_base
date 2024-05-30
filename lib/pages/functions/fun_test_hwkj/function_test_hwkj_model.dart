import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:basecore/basecore_module.dart';
import 'package:dio/dio.dart';
import 'package:download_file/download_file_module.dart' as download;
import 'package:flutter/material.dart';
import 'package:log/log_module.dart';
import 'package:musico/base/view_state_model.dart';
import 'package:network/network.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upload_file/upload_file_module.dart';
import 'package:browsemedia/browse_media.dart';

///  model
class FunctionTestHwkjModel extends ViewStateModel {
  FunctionTestHwkjModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam);

  List<String> get menus => _menus;

  final List<String> _menus = [
    'basecore-toast',
    'basecore-notification',
    'log-print',
    'network-get',
    'download_file',
    'upload_file',
    'browse_media-openBrowseFilesMedia',
    'browse_media-openBrowseDirectoryMedia',
  ];

  String get content => _content;

  String _content = '';

  @override
  Future<void> initData() async {
    return super.initData();
  }

  @override
  Future? loadData() async {}

  Future<void> onTap(BuildContext context, String menu) async {
    switch (menu) {
      case 'basecore-toast':
        Toast.show(context, 'basecore-toast');
        break;
      case 'basecore-notification':
        break;
      case 'log-print':
        PrintLog.v('计数器', '打印的数:${DateTime.now().millisecond}');
        PrintLog.d('计数器', '打印的数:${DateTime.now().millisecond}');
        PrintLog.i('计数器', '打印的数:${DateTime.now().millisecond}');
        PrintLog.w('计数器', '打印的数:${DateTime.now().millisecond}');
        PrintLog.e('计数器', '打印的数:${DateTime.now().millisecond}');
        break;
      case 'network-get':
        final api = BaseHttpApi();
        final rst = await api.onGet(
          'http://192.168.0.52:8021/api/configuration/configjson',
          null,
          onSuccess: (rst) {
            _content = 'asdasdas';
            notifyListeners();
          },
        );
        _content = json.encode(rst);
        notifyListeners();

        break;
      case 'download_file':
        final token = CancelToken();

        final fileSavePath = (await getDownloadsDirectory())?.path ?? '';
        final fileSavePath1 = (await getApplicationCacheDirectory()).path ?? '';
        final fileSavePath2 =
            (await getApplicationDocumentsDirectory()).path ?? '';
        final fileSavePath3 =
            (await getApplicationSupportDirectory()).path ?? '';
        final fileSavePath4 = (await getExternalStorageDirectory())?.path ?? '';
        final fileSavePath5 = (await getTemporaryDirectory()).path ?? '';

        _content += fileSavePath + '\n';
        _content += fileSavePath1 + '\n';
        _content += fileSavePath2 + '\n';
        _content += fileSavePath3 + '\n';
        _content += fileSavePath4 + '\n';
        _content += fileSavePath5 + '\n';

        String savePath = "";
        Directory? saveDirectory;
        if (Platform.isAndroid) {
          saveDirectory = await getExternalStorageDirectory();
        } else {
          saveDirectory = await getApplicationDocumentsDirectory();
        }
        final String dirPath = '${saveDirectory!.path}/download';
        Directory directory = Directory(dirPath);
        bool isExists = await directory.exists();
        if (!isExists) {
          await directory.create(recursive: true);
        }
        savePath = '$dirPath/xxx.mp4';
        _content += savePath + '\n';
        notifyListeners();

        await download.DownloadFileManager().onDownload(
          'http://192.168.0.52:8023/files/0-ed93bfb9174d4d0e93efab9dc610a8b4.mp4',
          savePath,
          token,
          null,
          onProgress: (int count, int total) {
            _content = '$count/$total';
            notifyListeners();
          },
          downloadFailed: (String errorMsg) {
            _content = errorMsg;
            notifyListeners();
          },
          downloadSuccess: (String saveFileAddress) {
            _content = saveFileAddress;
            notifyListeners();
          },
        );
        break;

      case 'upload_file':
        var uploadFileEntity = UploadFileEntity(
            filePath: '/storage/emulated/0/Movies/REC8615998913887186123.mp4',
            userId: '5B408040F89E48A1A1C5C4D0C2067175',
            uploadStatus: UploadFileEntity.WAITING_UPLOAD_STATUS,
            uploadType: 1);
        uploadFileEntity.initFileType();

        final iUploadFileCallback = MyUploadFileCallback(
          (path, total, progress) {
            _content = '$path:$progress/$total';
            notifyListeners();
          },
          (path, state) {
            _content = '$path:$state';
            notifyListeners();
          },
          (path, fileName, fileId) {
            _content = '$path\n';
            _content += '$fileName\n';
            _content += '$fileId\n';
            notifyListeners();
          },
          (path, errorMsg) {
            _content = '$path\n';
            _content += '$errorMsg\n';
            notifyListeners();
          },
        );

        await UploadFileManager.instance!
            .start(uploadFileRootUrl: 'http://192.168.0.52:8023/');
        UploadFileManager.instance!.addCallback(iUploadFileCallback);
        await UploadFileManager.instance!.addFilesUpload([uploadFileEntity]);
        break;

      case 'browse_media-openBrowseFilesMedia':
        {
          await BrowseMedia.openBrowseFilesMedia([
            "http://192.168.0.52:8023/files/100-6e4613944a67439f91a92eb57aea1017.jpg",
            "http://192.168.0.52:8023/files/100-1549fce5db13465bb2db1079683193ce.jpg"
          ], "http://192.168.0.52:8023/files/100-1549fce5db13465bb2db1079683193ce.jpg");
        }
        break;
      case 'browse_media-openBrowseDirectoryMedia':
        {
          final directory = await getExternalStorageDirectory();

          await BrowseMedia.openBrowseDirectoryMedia(directory!);
        }
        break;
    }
  }
}

class MyUploadFileCallback implements IUploadFileCallback {
  MyUploadFileCallback(this.mProgress, this.mStateChange,
      this.mUploadFileComplete, this.mUploadFileFailed);

  Function(String? path, int? total, int? progress)? mProgress;
  Function(String? path, int? state)? mStateChange;
  Function(String? path, String? fileName, String? fileId)? mUploadFileComplete;
  Function(String? path, String? errorMsg)? mUploadFileFailed;

  @override
  void onProgress(String? path, int? total, int? progress) {
    mProgress?.call(path, total, progress);
  }

  @override
  void onStateChange(String? path, int? state) {
    mStateChange?.call(path, state);
  }

  @override
  void uploadFileComplete(String? path, String? fileName, String? fileId) {
    mUploadFileComplete?.call(path, fileName, fileId);
  }

  @override
  void uploadFileFailed(String? path, String? errorMsg) {
    mUploadFileFailed?.call(path, errorMsg);
  }
}
