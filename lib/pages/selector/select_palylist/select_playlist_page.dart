import 'package:musico/base/base_page.dart';
import 'package:musico/base/selector/selector_page_mixin.dart';
import 'package:musico/pages/selector/select_palylist/provider/select_playlist_model.dart';
import 'package:flutter/material.dart';

///
/// create by ls 2022/5/30
///
class SelectPlaylistPage extends BasePage {
  SelectPlaylistPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<SelectPlaylistPage> createState() => _HandlePersonPageState();
}

class _HandlePersonPageState extends BasePageState<SelectPlaylistPage>
    with SelectorMixin<SelectPlaylistPage, SelectPlaylistModel> {
  @override
  SelectPlaylistModel initModel() {
    return SelectPlaylistModel(requestParam: widget.requestParams);
  }

  @override
  void onAddButtonPressed() {
    // model.createPlayList(context);
  }

  @override
  Widget buildContentWidget(item) {
    return const Text('该条数据为空!');
  }
}
