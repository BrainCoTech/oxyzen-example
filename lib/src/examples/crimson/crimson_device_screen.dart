import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenlite_sdk/zenlite_sdk.dart';
import 'package:zenlite_sdk_example/src/examples/charts/attention_chart.dart';
import 'package:zenlite_sdk_example/src/examples/charts/eeg_chart.dart';
import 'package:zenlite_sdk_example/src/examples/charts/imu_chart.dart';
import 'package:zenlite_sdk_example/src/examples/widgets/segment.dart';

import 'crimson_device_controller.dart';
import 'widgets.dart';

class CrimsonDeviceScreen extends StatelessWidget {
  final controller = Get.put(CrimsonDeviceController());
  CrimsonDeviceScreen({Key? key}) : super(key: key);

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
                  '解除配对', //: 'Unpair',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .labelLarge!
                      .copyWith(color: Colors.white),
                ))
          ]),
      body: CrimsonDataWidget(),
    );
  }
}

class CrimsonDataWidget extends StatefulWidget {
  const CrimsonDataWidget({Key? key}) : super(key: key);

  @override
  State<CrimsonDataWidget> createState() => _CrimsonDataWidgetState();
}

class _CrimsonDataWidgetState extends State<CrimsonDataWidget> {
  final device = HeadbandManager.headband as CrimsonHeadband;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CrimsonDeviceController>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(children: <Widget>[
              StreamBuilder<HeadbandConnectivity>(
                initialData: device.connectivity,
                stream: device.onConnectivityChanged,
                builder: (context, snapshot) => StatusText(
                  title: 'Connectivity',
                  value: snapshot.data!.desc,
                  highlighted: !snapshot.data!.isConnected,
                  // high
                ),
              ),
              StreamBuilder<ContactState>(
                initialData: device.contactState,
                stream: device.onContactStateChanged,
                builder: (context, snapshot) => StatusText(
                  title: 'Contact',
                  value: snapshot.data!.desc,
                  highlighted: !snapshot.data!.isContacted,
                ),
              ),
              StreamBuilder<LeadOffState>(
                initialData: device.leadOffState,
                stream: device.onLeadOff,
                builder: (context, snapshot) => StatusText(
                  title: 'LeadOff',
                  value: snapshot.data.toString(),
                ),
              ),
              if (!device.disableOrientationCheck)
                StreamBuilder<HeadbandOrientation>(
                  initialData: HeadbandProxy.instance.orientation,
                  stream: HeadbandProxy.instance.onOrientationChanged,
                  builder: (context, snapshot) => StatusText(
                    title: 'Orientation',
                    value: snapshot.data!.desc,
                    highlighted: snapshot.data != HeadbandOrientation.normal,
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
              ],
            ),
            const SizedBox(height: 10),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SegmentWidget(
                      segments: ['EEG', 'ACC', 'GYRO', '正念'].asMap(),
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
                  await device.startEEG();
                },
                child: const Text('Start EEG'),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () async {
                  await device.stopEEG();
                },
                child: const Text('Stop EEG'),
              ),
            ]),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () async {
                  await device.startIMU();
                },
                child: const Text('Start IMU'),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () async {
                  await device.stopIMU();
                },
                child: const Text('Stop IMU'),
              ),
            ]),
            const SizedBox(height: 20),
            Obx(() => Text(
                '${HeadbandProxy.instance.name}   固件版本：V${controller.firmware.value}')),
          ],
        ),
      ),
    );
  }

  Widget chartWidget(int index) {
    final controller = Get.find<CrimsonDeviceController>();
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
      default:
        return const MeditationChart();
    }
  }
}
