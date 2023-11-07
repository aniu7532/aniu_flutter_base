import 'package:musico/app/myapp.dart';
import 'package:musico/base/baseinfo/base_info_edit_model.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/router/router.gr.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:url_launcher/url_launcher.dart';

mixin _Protocol {}

class ScanModel extends BaseInfoEditModel with _Protocol {
  ScanModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {}
}
