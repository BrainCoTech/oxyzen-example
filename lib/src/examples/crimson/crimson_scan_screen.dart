import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:oxyzen_example/src/examples/crimson/crimson_device_screen.dart';
import 'package:oxyzen_example/src/examples/oxyzen/oxyzen_device_screen.dart';

import '../../../main.dart';
import 'crimson_scan_provider.dart';
import 'widgets.dart';

class CrimsonScanScreen extends StatelessWidget {
  const CrimsonScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HeadbandPermission>(
        stream: onPeriodicCrimsonPermission,
        initialData: HeadbandPermission.normal,
        builder: (c, snapshot) {
          final p = snapshot.data!;
          return p.isOn
              ? const FindCrimsonScreen()
              : BluetoothOffScreen(permission: p);
        });
  }
}

class BluetoothOffScreen extends StatelessWidget {
  final HeadbandPermission permission;

  const BluetoothOffScreen({Key? key, required this.permission})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                permission == HeadbandPermission.bluetooth
                    ? Icons.bluetooth_disabled
                    : Icons.location_disabled,
                size: 200.0,
                color: Colors.white54,
              ),
              Text(
                permission.isOn
                    ? 'crimson permission is on'
                    : '${permission.desc} not available',
                style: Theme.of(context)
                    .primaryTextTheme
                    .titleMedium!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ));
  }
}

class FindCrimsonScreen extends StatefulWidget {
  const FindCrimsonScreen({Key? key}) : super(key: key);

  @override
  _FindCrimsonState createState() => _FindCrimsonState();
}

class _FindCrimsonState extends State<FindCrimsonScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Crimson or OxyZen'),
        backgroundColor: Colors.lightBlue,
      ),
      body: ChangeNotifierProvider(
          create: (_) {
            final provider = CrimsonScanProvider();
            provider.init();
            return provider;
          },
          lazy: true,
          child: Consumer<CrimsonScanProvider>(
              builder: (context, provider, _) => RefreshIndicator(
                    onRefresh: () async =>
                        await HeadbandManager.bleScanner.startScan(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          StreamBuilder<List<ScanResult>>(
                            stream: HeadbandManager.bleScanner.onFoundDevices
                                .map((event) => event as List<ScanResult>),
                            initialData: const [],
                            builder: (c, snapshot) {
                              //loggerExample.i(snapshot.data);
                              if (snapshot.data != null &&
                                  snapshot.data!.isNotEmpty) {
                                return IntrinsicHeight(
                                    child: Column(
                                        children: snapshot.data!
                                            .map((r) =>
                                                ScanResultWidget(r, context))
                                            .toList()));
                              } else {
                                return const Center(
                                    child: Text('未找到设备，请确认设备处于配对状态'));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ))),
      floatingActionButton: StreamBuilder<bool>(
        stream: HeadbandManager.bleScanner.onScanningChanged,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data == true) {
            return FloatingActionButton(
              onPressed: () async =>
                  await HeadbandManager.bleScanner.stopScan(),
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
                onPressed: () async =>
                    await HeadbandManager.bleScanner.startScan(),
                child: const Icon(Icons.search));
          }
        },
      ),
    );
  }
}

class ScanResultWidget extends StatelessWidget {
  final ScanResult result;
  final BuildContext ctx;

  const ScanResultWidget(this.result, this.ctx, {Key? key}) : super(key: key);

  String? getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    var res = <String>[];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return ScanResultTile(
      result: result,
      onTap: () async {
        try {
          await EasyLoading.show(status: '配对中...');
          await HeadbandManager.bindScanResult(result);
          await EasyLoading.showSuccess('配对成功!');
          await Get.off(() =>
              result.isZenLite ? OxyZenDeviceScreen() : CrimsonDeviceScreen());
        } catch (e, st) {
          loggerExample.i('$e');
          if (kDebugMode) {
            print(st);
          }
          await EasyLoading.showError('配对失败');
          await HeadbandManager.bleScanner.startScan(); //restart scan
        }
      },
    );
  }
}
