import 'dart:async';

import 'package:get/get.dart';
import 'package:zenlite_sdk_example/main.dart';


const int eegXRange = 1000;
const int imuXRange = 100;
const int _imuMaxLen = imuXRange ~/ 2;

class OxyzenDeviceController extends GetxController {
  final device = HeadbandProxy.instance;
  final firmware = HeadbandProxy.instance.deviceInfo.firmwareRevision.obs;

  final eegSeqNum = RxnInt(null);
  final imuSeqNum = RxnInt(null);
  final ppgData = Rx<PpgModule_PpgData?>(null);

  final RxInt tabIndex = 0.obs;
  final RxList<double> eegValues = <double>[].obs;
  final RxList<double> accX = <double>[].obs;
  final RxList<double> accY = <double>[].obs;
  final RxList<double> accZ = <double>[].obs;
  final RxList<double> gyroX = <double>[].obs;
  final RxList<double> gyroY = <double>[].obs;
  final RxList<double> gyroZ = <double>[].obs;
  final RxList<double> yaw = <double>[].obs;
  final RxList<double> pitch = <double>[].obs;
  final RxList<double> roll = <double>[].obs;

  final _eegValues = <double>[];
  final _imuModels = <IMUModel>[];

  final _ppgValues = <PPGDataModel>[];
  final ppgValues = <PPGDataModel>[].obs;

  final List<StreamSubscription> _subscriptions = [];

  @override
  void onInit() async {
    super.onInit();

    addListenerEEG();
    addListenerIMU();
    if (HeadbandManager.headband is! OxyZenHeadband) return;
    addListenerPpg();
  }

  @override
  void onClose() async {
    for (var s in _subscriptions) {
      s.cancel();
    }
    _subscriptions.clear();
  }

  void addListenerEEG() {
    _subscriptions.add(device.onEEGData.listen((event) {
      eegSeqNum.value = event.seqNum;
      _eegValues.addAll(event.eeg);
      if (_eegValues.length > eegXRange) {
        _eegValues.removeRange(0, _eegValues.length - eegXRange);
      }
      loggerExample.i('eegSeqNum=${eegSeqNum.value}, len=${event.eeg.length}');
      eegValues.value = _eegValues;
    }));
  }

  void addListenerIMU() {
    _subscriptions.add(device.onIMUData.listen((event) {
      imuSeqNum.value = event.seqNum;
      _imuModels.add(event);
      if (_imuModels.length > _imuMaxLen) {
        _imuModels.removeRange(0, _imuModels.length - _imuMaxLen);
      }
      accX.value = _imuModels.map((e) => e.acc.x).expand((e) => e).toList();
      accY.value = _imuModels.map((e) => e.acc.y).expand((e) => e).toList();
      accZ.value = _imuModels.map((e) => e.acc.z).expand((e) => e).toList();
      gyroX.value =
          _imuModels.map((e) => e.gyro?.x ?? []).expand((e) => e).toList();
      gyroY.value =
          _imuModels.map((e) => e.gyro?.y ?? []).expand((e) => e).toList();
      gyroZ.value =
          _imuModels.map((e) => e.gyro?.z ?? []).expand((e) => e).toList();
      yaw.value = _imuModels
          .where((e) => e.eulerAngle != null)
          .map((e) => e.eulerAngle!.yaw)
          .expand((e) => e)
          .toList();
      pitch.value = _imuModels
          .where((e) => e.eulerAngle != null)
          .map((e) => e.eulerAngle!.pitch)
          .expand((e) => e)
          .toList();
      roll.value = _imuModels
          .where((e) => e.eulerAngle != null)
          .map((e) => e.eulerAngle!.roll)
          .expand((e) => e)
          .toList();
    }));
  }

  void addListenerPpg() {
    final device = HeadbandManager.headband;
    if (device is! OxyZenHeadband) return;

    _subscriptions.add(device.onConnectivityChanged.listen((e) async {
      if (e.isConnected) {
        firmware.value = HeadbandProxy.instance.deviceInfo.firmwareRevision;
      }
    }));
    _subscriptions.add(device.onReceiveZenLiteData
        .where((e) => e.hasPpgModule() && e.ppgModule.hasData())
        .map((e) => e.ppgModule.data)
        .listen((data) {
      ppgData.value = data;
    }));
    _subscriptions.add(device.onPPGData.listen((e) {
      final ppgSeqNum = e.seqNum;
      if (ppgSeqNum == 0) return;
      _ppgValues.add(e);
      if (_ppgValues.length > 1000) {
        _ppgValues.removeAt(0);
      }
      ppgValues.value = _ppgValues;
    }));
  }
}
