import 'package:flutter/material.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/base_page_mixin.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/pages/functions/fun_ble/function_ble_model.dart';
import 'package:musico/pages/functions/fun_ble/widget/scan_result_title.dart';
import 'package:musico/pages/functions/fun_ble/widget/system_device_tile.dart';

/// Ble 功能模块
class FunctionBlePage extends BasePage {
  FunctionBlePage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams) {}

  @override
  State<FunctionBlePage> createState() => _FunctionBlePageState();
}

class _FunctionBlePageState extends BasePageState<FunctionBlePage>
    with BasePageMixin<FunctionBlePage, FunctionBleModel> {
  @override
  FunctionBleModel initModel() {
    return FunctionBleModel(requestParam: widget.requestParams);
  }

  @override
  Widget buildContentWidget() {
    return Hero(
      tag: widget.requestParams?['guid'],
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            ..._buildSystemDeviceTiles(context),
            ..._buildScanResultTiles(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSystemDeviceTiles(BuildContext context) {
    final list = <Widget>[
      Container(
        height: 40,
        decoration: const BoxDecoration(
          color: ColorName.primaryColor,
        ),
        child: Center(
          child: Text(
            'systemDevices: ${model.systemDevices.length}',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      ...model.systemDevices
          .map(
            (d) => SystemDeviceTile(
              device: d,
              onConnect: () => model.onConnectPressed(d),
              onOpen: () => model.onOpen(d),
            ),
          )
          .toList()
    ];

    return list;
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    final list = <Widget>[
      Container(
        height: 40,
        decoration: const BoxDecoration(
          color: ColorName.primaryColor,
        ),
        child: Center(
          child: Text(
            'scanResults: ${model.scanResults.length}',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      ...model.scanResults
          .map(
            (r) => ScanResultTile(
              result: r,
              onTap: () => model.onConnectPressed(r.device),
              onOpen: () => model.onOpen(r.device),
            ),
          )
          .toList()
    ];

    return list;
  }

  @override
  Widget? buildAppBar() {
    return const SizedBox.shrink();
  }

  @override
  Widget? buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        model.initData();
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: ColorName.primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.change_circle_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
