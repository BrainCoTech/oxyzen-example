// ignore: unused_import
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenlite_sdk_example/src/examples/charts/line_chart.dart';
import 'package:zenlite_sdk_example/src/examples/charts/eeg_chart.dart';
import 'package:zenlite_sdk_example/src/examples/charts/imu_chart.dart';
import 'package:zenlite_sdk_example/src/examples/charts/ppg_chart.dart';
import 'package:zenlite_sdk_example/src/examples/crimson/widgets.dart';
import 'package:zenlite_sdk_example/src/examples/oxyzen/ota/device_ota_screen.dart';
import 'package:zenlite_sdk_example/src/examples/widgets/segment.dart';

import '../../../main.dart';
import 'oxyzen_device_controller.dart';

class OxyZenDeviceScreen extends StatelessWidget {
  final controller = Get.put(OxyzenDeviceController());

  OxyZenDeviceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Obx(() => Text(
                  '${HeadbandProxy.instance.name} V${controller.firmware.value}')),
              const SizedBox(height: 3),
              Text(
                HeadbandProxy.instance.id,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              )
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  await HeadbandManager.unbind();
                  Get.back();
                },
                child: Text(
                  '解除配对',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .labelLarge!
                      .copyWith(color: Colors.white),
                ))
          ]),
      body: OxyzenDataWidget(),
    );
  }
}

class OxyzenDataWidget extends StatefulWidget {
  const OxyzenDataWidget({Key? key}) : super(key: key);

  @override
  State<OxyzenDataWidget> createState() => _OxyzenDataWidgetState();
}

class _OxyzenDataWidgetState extends State<OxyzenDataWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OxyzenDeviceController>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(children: <Widget>[
              StreamBuilder<PpgContactState>(
                initialData: PpgContactState.undetected,
                stream: HeadbandProxy.instance.onPPGData
                    .map((e) => e.ppgContactState),
                builder: (context, snapshot) => StatusText(
                  title: 'PpgContactState',
                  value: snapshot.data!.toString(),
                  highlighted: snapshot.data!.index <
                      PpgContactState.onSomeSubject.index,
                ),
              ),
            ]),
            const SizedBox(height: 5),
            Row(
              children: <Widget>[
                StreamBuilder<HeadbandState>(
                  initialData: HeadbandProxy.instance.state,
                  stream: HeadbandProxy.instance.onStateChanged,
                  builder: (context, snapshot) => StatusText(
                    title: '头环状态',
                    value: snapshot.data!.debugDescription,
                    highlighted: !snapshot.data!.isConnected,
                  ),
                ),
                StreamBuilder<int>(
                  initialData: HeadbandProxy.instance.batteryLevel,
                  stream: HeadbandProxy.instance.onBatteryLevelChanged,
                  builder: (context, snapshot) => StatusText(
                    title: '电量',
                    value: '${HeadbandProxy.instance.batteryLevel}%',
                    highlighted: HeadbandProxy.instance.batteryLevel <= 0,
                  ),
                ),
                StreamBuilder<String>(
                  initialData: '-',
                  stream: HeadbandProxy.instance.onMeditation
                      .map((value) => value.toStringAsFixed(1)),
                  builder: (context, snapshot) => StatusText(
                    title: '正念指数',
                    value: snapshot.data!,
                  ),
                ),
                StreamBuilder<String>(
                  initialData: '-',
                  stream: HeadbandProxy.instance.onAwareness
                      .map((value) => value.toStringAsFixed(1)),
                  builder: (context, snapshot) => StatusText(
                    title: '觉察指数',
                    value: snapshot.data!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SegmentWidget(
                      segments:
                          HeadbandManager.isBondZenLite
                              ? ['EEG', 'ACC', 'GYRO', 'PPG', '正念'].asMap()
                              : ['EEG', 'ACC', 'GYRO', '正念'].asMap(),
                      selectedIndex: controller.tabIndex),
                  const SizedBox(height: 10),
                  chartWidget(controller.tabIndex.value),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () async {
                  final device = HeadbandManager.headband;
                  if (device is! OxyZenHeadband) return;
                  await device.startEEG();
                },
                child: const Text('Start EEG'),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () async {
                  final device = HeadbandManager.headband;
                  if (device is! OxyZenHeadband) return;
                  await device.stopEEG();
                },
                child: const Text('Stop EEG'),
              ),
            ]),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () async {
                  final device = HeadbandManager.headband;
                  if (device is! OxyZenHeadband) return;
                  await device.startIMU();
                },
                child: const Text('Start IMU'),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () async {
                  final device = HeadbandManager.headband;
                  if (device is! OxyZenHeadband) return;
                  await device.stopIMU();
                },
                child: const Text('Stop IMU'),
              ),
            ]),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () async {
                  final device = HeadbandManager.headband;
                  if (device is! OxyZenHeadband) return;
                  await device.startPPG();
                },
                child: const Text('Start PPG'),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () async {
                  final device = HeadbandManager.headband;
                  if (device is! OxyZenHeadband) return;
                  device.stopPPG();
                },
                child: const Text('Stop PPG'),
              ),
              const SizedBox(width: 5),
            ]),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await OxyzOtaManager.checkNewFirmware(force: true);
                await Get.to(() => DeviceOtaScreen());
              },
              child: const Text('Device OTA'),
            ),
            const SizedBox(height: 20),
            if (kDebugMode && false)
              // ignore: dead_code
              Column(
                children: [
                  Obx(() => Text(
                      '${HeadbandProxy.instance.name}   固件版本：V${controller.firmware.value}')),
                ],
              ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget chartWidget(int index) {
    final controller = Get.find<OxyzenDeviceController>();
    switch (index) {
      case 0:
        return EEGChartWidget(
          eegSeqNum: controller.eegSeqNum,
          eegValues: controller.eegValues,
        );
      case 1:
        return IMUChartWidget(
          chartType: ChartType.acc,
          imuSeqNum: controller.imuSeqNum,
          valuesX: controller.accX,
          valuesY: controller.accY,
          valuesZ: controller.accZ,
        );
      case 2:
        return IMUChartWidget(
          chartType: ChartType.acc,
          imuSeqNum: controller.imuSeqNum,
          valuesX: controller.gyroX,
          valuesY: controller.gyroY,
          valuesZ: controller.gyroZ,
        );
      case 3:
        return PpgChartWidget();
      default:
        return const MeditationChart();
    }
  }
}
