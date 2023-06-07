// ignore_for_file: unnecessary_import

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zenlite_sdk/zenlite_sdk.dart';
import 'package:oxyzen_example/main.dart';

class DeviceProvider with ChangeNotifier {
  final int duration = 900;
  final List<double> chartValues = [];
  StreamSubscription<double>? _subscription;

  DeviceProvider() {
    _init();
  }

  void _init() {
    _subscription = HeadbandProxy.instance.onMeditation.listen((event) {
      chartValues.add(event);
      notifyListeners();
    });
  }

  @override
  void dispose() async {
    try {
      await _subscription?.cancel();
      _subscription = null;
    } catch (e, _) {
      loggerExample.i('e=$e');
    }
    super.dispose();
  }
}
