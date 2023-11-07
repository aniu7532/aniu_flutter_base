import 'package:musico/base/selector/selector_base_model.dart';
import 'package:flustars/flustars.dart';

mixin _Protocol {}

/// palylist选择 model
class SelectPlaylistModel extends BaseSelectorModel<String> with _Protocol {
  SelectPlaylistModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {
    hideSearch = true;
    needDiver = false;
    if (ObjectUtil.isNotEmpty(requestParam) &&
        requestParam!.containsKey('audioId')) {
      audioId = int.tryParse(requestParam['audioId']);
    }
    if (ObjectUtil.isNotEmpty(requestParam) &&
        requestParam!.containsKey('audioPath')) {
      audioPath = requestParam['audioPath'];
    }
  }

  int? audioId;
  String? audioPath;

  @override
  Future<bool> initData() async {
    setBusy(busy: true);
    return super.initData();
  }

  @override
  Future<List<String>> loadRefreshListData({int? pageNum}) async {
    return [];
  }
}
