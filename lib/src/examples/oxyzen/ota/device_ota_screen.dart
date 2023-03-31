import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenlite_sdk/zenlite_sdk.dart';
import 'package:zenlite_sdk_example/src/examples/crimson/widgets.dart';
import 'package:zenlite_sdk_example/src/examples/oxyzen/ota/device_ota_controller.dart';
import 'package:zenlite_sdk_example/src/examples/ui.dart';

class DeviceOtaScreen extends StatelessWidget {
  final controller = Get.put(OxyZenOtaController(showUploadRate: true));

  DeviceOtaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 40.scale),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Name: ${HeadbandProxy.instance.name}'),
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
                  ],
                ),
                SizedBox(height: 40.scale),
                SizedBox(
                  height: 600.scale,
                  child: Obx(() {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                            'bluetoothRadio: ${controller.bluetoothRadio.value}'),
                        Text(
                            'latestVersion: ${controller.latestVersion.value}'),
                        SizedBox(height: 10),
                        Text(
                            'latestVersionNrf: ${controller.latestVersionNrf.value}'),
                        Text('nrfVersion: ${controller.nrfVersion.value}'),
                        SizedBox(height: 10),
                        Text(
                            'latestVersionPpg: ${controller.latestVersionPpg.value}'),
                        Text('ppgVersion: ${controller.ppgVersion.value}'),
                        SizedBox(height: 10),
                        Text('otaState: ${controller.otaState.value}'),
                        Text('otaProgress: ${controller.otaProgress.value}'),
                        // Text(
                        //     'ppgProgress: ${controller.ppgUploadProgress.value}'),
                        Text('uploadRate: ${controller.uploadRate.value}'),
                        SizedBox(height: 20),
                        LinearProgressIndicator(
                          value: controller.btnProgress,
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: !controller.btnEnabled.value
                              ? null
                              : () {
                                  controller.startOta();
                                },
                          child: Text(controller.btnText),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            controller.back();
                          },
                          child: Text('Back'),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ));
  }
}
