// ignore_for_file: unused_element, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:zenlite_sdk_example/main.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:version/version.dart';

class PermissionUtil {
  static Future<Map<Permission, PermissionStatus>> request(
      Permission permission) async {
    return await [permission].request();
  }

  static bool isGranted(Map<Permission, PermissionStatus> result) {
    return result.values.every((state) => state == PermissionStatus.granted);
  }

  static Future openPermission(HeadbandPermission permission) async {
    if (permission == HeadbandPermission.location) {
      if (!(await Permission.locationWhenInUse.isGranted)) {
        await AppSettings.openAppSettings();
      } else {
        await AppSettings.openLocationSettings();
      }
    } else if (permission == HeadbandPermission.bluetooth) {
      if (!(await Permission.bluetooth.isGranted)) {
        await AppSettings.openAppSettings();
      } else {
        if (Platform.isAndroid) {
          await FlutterBlue.instance.requestEnableBluetooth();
        } else {
          await AppSettings.openBluetoothSettings();
        }
      }
    } else if (permission == HeadbandPermission.wifi) {
      await AppSettings.openWIFISettings();
    }
  }

  static void showDeniedDialog(
      BuildContext context, String reason, HeadbandPermission p) {
    Get.dialog(Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              reason,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            Get.back();
            await PermissionUtil.openPermission(p);
          },
          child: Text('去开启'),
        ),
      ],
    ));
  }

  static Future<bool> requestPermissions(BuildContext context,
      {HeadbandType type = HeadbandType.crimson}) async {
    if (type == HeadbandType.crimson) {
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        if (!androidInfo.isPhysicalDevice) return true;
        if (androidInfo.version.sdkInt >= 31) {
          loggerExample.i('request bluetooth scan & connect permission');
          await [
            Permission.locationWhenInUse,
            Permission.bluetoothScan,
            Permission.bluetoothConnect
          ].request();
        } else {
          // await [Permission.locationWhenInUse, Permission.bluetooth].request();
          await Permission.locationWhenInUse.request();
        }
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        if (!iosInfo.isPhysicalDevice) return true;
        // if (Version.parse(iosInfo.systemVersion) < Version.parse('13.0')) {
        //   return true;
        // }
        await Permission.bluetooth.request();
      }
      final p = await crimsonPermission;
      if (p == HeadbandPermission.bluetooth) {
        showDeniedDialog(context, '蓝牙未打开\n\n请先打开蓝牙', p);
        return false;
      }
      if (p == HeadbandPermission.location) {
        showDeniedDialog(context, '为了能够搜索到附近的蓝牙头环，需要开启定位权限', p);
        return false;
      }
    } else if (type == HeadbandType.focus1) {
      await Permission.locationWhenInUse.request();

      final p = await focus1Permission;
      if (p == HeadbandPermission.location) {
        // 'Allow access Location for scan Focus1 Device'
        var text = '为了能够搜索到附近的Focus1设备，需要开启定位权限';
        if (Platform.isIOS) {
          final deviceInfo = DeviceInfoPlugin();
          final iosDeviceInfo = await deviceInfo.iosInfo;
          if (Version.parse(iosDeviceInfo.systemVersion) >=
              Version.parse('14.0')) {
            // Allow access Precise Location for scan Focus1 Device
            text = '为了能够搜索到附近的Focus1设备，需要开启定位权限，并开启精确位置。';
          }
        }
        showDeniedDialog(context, text, p);
        return false;
      } else if (p == HeadbandPermission.wifi) {
        // 'Allow access Wi-Fi for scan Focus1 Device'
        var text = '为了能够搜索到附近的Focus1设备，需要开启Wi-Fi';
        if (Platform.isIOS) {
          final deviceInfo = DeviceInfoPlugin();
          final iosDeviceInfo = await deviceInfo.iosInfo;
          if (Version.parse(iosDeviceInfo.systemVersion) >=
              Version.parse('14.0')) {
            // 'Allow access Wi-Fi & Precise Location for scan Focus1 Device'
            text = '为了能够搜索到附近的Focus1设备，需要开启Wi-Fi，并开启精确位置。';
          }
        }
        showDeniedDialog(context, text, p);
        return false;
      }
    }

    return true;
  }

  static Future<void> requestIgnoreBatteryOptimizations(
      BuildContext context) async {
    if (Platform.isAndroid) {
      await PermissionUtil.request(Permission.ignoreBatteryOptimizations);
    }
  }
}
