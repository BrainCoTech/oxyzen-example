import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_utils/flutter_utils.dart' as utils;
import 'package:get/get.dart';
import 'package:zenlite_sdk/zenlite_sdk.dart';
import 'package:oxyzen_example/src/examples/constants/constant.dart';

import 'src/examples/crimson/crimson_device_screen.dart';
import 'src/examples/crimson/crimson_scan_screen.dart';
import 'src/examples/oxyzen/oxyzen_device_screen.dart';
export 'package:zenlite_sdk/zenlite_sdk.dart';

final loggerExample = initLogging(tag: 'example');

void main() async {
  loggerExample.i(
      '------------------main, init, cmsn version=${getCrimsonSDKVersion()}, oxyz version=${getOxyzenSDKVersion()}--------------');

  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) await HeadbandManager.disconnectConnectedDevices();

  HeadbandConfig.logLevel = Level.INFO;
  HeadbandConfig.availableTypes = {
    HeadbandType.crimson,
    HeadbandType.oxyzen,
  };
  await HeadbandManager.init();
  utils.Devices.init();

  loggerExample.i('------------------main, runApp--------------');
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..indicatorSize = 45
    ..radius = 10
    ..progressColor = ColorExt.primaryColor
    ..backgroundColor = ColorExt.primaryColor
    ..indicatorColor = ColorExt.primaryColor
    ..textColor = ColorExt.primaryColor
    ..maskColor = ColorExt.primaryColor.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorObservers: [routeObserver],
      home: const HomeScreen(),
      builder: EasyLoading.init(),
    );
  }
}

// Register the RouteObserver as a navigation observer.
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    loggerExample.i('initState');
  }

  @override
  void dispose() {
    loggerExample.i('dispose');
    HeadbandManager.dispose();
    super.dispose();
  }

  void _pushBondHeadbandScreen() {
    final headband = HeadbandManager.headband;
    if (headband == null) return;
    // if (headband is Focus1Headband) Get.to(() => Focus1DeviceDataScreen());
    if (headband is CrimsonHeadband) Get.to(() => CrimsonDeviceScreen());
    if (headband is OxyZenHeadband) Get.to(() => OxyZenDeviceScreen());
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('脑电设备DEMO'),
        backgroundColor: Colors.lightBlue,
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Wrap(
            spacing: 15,
            children: <Widget>[
              if (HeadbandConfig.supportZenLite)
                _button('OxyZen', () async {
                  loggerExample.i(HeadbandManager.headband);
                  if (HeadbandManager.headband != null) {
                    _pushBondHeadbandScreen();
                  } else {
                    await Get.to(() => const CrimsonScanScreen());
                  }
                }),
              if (HeadbandConfig.supportCrimson)
                _button('Crimson', () async {
                  if (HeadbandManager.headband != null) {
                    _pushBondHeadbandScreen();
                  } else {
                    await Get.to(() => const CrimsonScanScreen());
                  }
                }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _button(String text, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Text(text),
  );
}

///back事件响应阈值
const int _exitAppThreshold = 2000;
int? _popTimestamp;

Future<bool> _onWillPop() async {
  if (Platform.isAndroid) {
    if (_popTimestamp != null &&
        DateTime.now().millisecondsSinceEpoch - _popTimestamp! <
            _exitAppThreshold) {
      await HeadbandManager.dispose();
      return true;
    } else {
      _popTimestamp = DateTime.now().millisecondsSinceEpoch;
      loggerExample.i('再按一次退出');
      return false;
    }
  } else {
    await HeadbandManager.dispose();
    return true;
  }
}
