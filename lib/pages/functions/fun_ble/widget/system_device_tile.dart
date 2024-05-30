import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:musico/gen/colors.gen.dart';

class SystemDeviceTile extends StatefulWidget {
  final BluetoothDevice device;
  final VoidCallback onOpen;
  final VoidCallback onConnect;

  const SystemDeviceTile({
    required this.device,
    required this.onOpen,
    required this.onConnect,
    Key? key,
  }) : super(key: key);

  @override
  State<SystemDeviceTile> createState() => _SystemDeviceTileState();
}

class _SystemDeviceTileState extends State<SystemDeviceTile> {
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription =
        widget.device.connectionState.listen((state) {
      _connectionState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'system[${widget.device.platformName}]',
        style: const TextStyle(fontSize: 18, color: ColorName.primaryColor),
      ),
      subtitle: Text(
        widget.device.remoteId.str,
        style: const TextStyle(fontSize: 14, color: ColorName.normalTipsColor),
      ),
      trailing: ElevatedButton(
        child: isConnected ? const Text('OPEN') : const Text('CONNECT'),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorName.primaryColor,
          foregroundColor: Colors.white,
        ),
        onPressed: isConnected ? widget.onOpen : widget.onConnect,
      ),
    );
  }
}
