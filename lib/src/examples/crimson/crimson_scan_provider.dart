// ignore_for_file: unnecessary_import

import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:oxyzen_example/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zenlite_sdk/zenlite_sdk.dart';

class CrimsonScanProvider extends ChangeNotifier {
  Future<void> init() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      if (androidInfo.version.sdkInt >= 31) {
        loggerExample.i('request Permission.bluetoothScan & bluetoothConnect');
        await [
          Permission.locationWhenInUse,
          Permission.bluetoothScan,
          Permission.bluetoothConnect
        ].request();
      } else {
        await [Permission.locationWhenInUse].request();
      }
    } else if (Platform.isIOS || Platform.isWindows) {
      await [Permission.bluetooth].request();
    }
    await HeadbandManager.bleScanner.startScan();
  }

  @override
  void dispose() async {
    await HeadbandManager.bleScanner.stopScan();
    super.dispose();
  }
}
