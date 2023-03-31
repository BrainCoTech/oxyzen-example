# Oxyzen & Crimson SDK Example

## Quick Start

[Documents](https://www.brainco-hz.com/docs/oxyzen-sdk/index.html)

## Download

[Sample](https://app.brainco.cn/zen/android/apk/oxyzen-demo-1.0.0-profile.apk)

## Installation

```yaml
zenlite_sdk:
  version: 1.4.3+1
  hosted:
    name: zenlite_sdk
    url: https://dart-pub.brainco.cn
```

## Init

```dart
HeadbandConfig.logLevel = Level.INFO;
HeadbandConfig.availableTypes = <HeadbandType>{
  HeadbandType.crimson,
  HeadbandType.oxyzen,
};
await HeadbandManager.init();
```

## Scan

if the device cannot be scanned, or pair failed, please check [Instructions](https://www.brainco-hz.com/docs/oxyzen-sdk/guide/faq.html)

```dart
// Start Scan Crimson Devices
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
} else if (Platform.isIOS) {
    await [Permission.bluetooth].request();
}
await HeadbandManager.bleScanner.startScan();
```

```dart
// Stop Scan Crimson Devices
await HeadbandManager.bleScanner.stopScan();
```

```dart
// Scanned Devices
HeadbandManager.bleScanner.onFoundDevices.map((event) => event as List<ScanResult>)
```

## Pair

if the device cannot be scanned, or pair failed, please check [Instructions](https://www.brainco-hz.com/docs/oxyzen-sdk/guide/faq.html)

```dart
try {
    await EasyLoading.show(status: 'pairing...');
    await HeadbandManager.bindCrimson(result);
    await EasyLoading.showSuccess('pair success');
} catch (e, _) {
    loggerExample.i('$e');
    await EasyLoading.showError('pair failed !!');
    await HeadbandManager.bleScanner.startScan();; //restart scan
}
```

## Device State & Stream

```dart
HeadbandProxy.instance.id
HeadbandProxy.instance.name
HeadbandProxy.instance.state
HeadbandProxy.instance.meditation
HeadbandProxy.instance.drowsiness
HeadbandProxy.instance.stress 

HeadbandProxy.instance.onStateChanged
HeadbandProxy.instance.onEEGData
HeadbandProxy.instance.onBrainWave
HeadbandProxy.instance.onMeditation
HeadbandProxy.instance.onDrowsiness
HeadbandProxy.instance.onStress
HeadbandProxy.instance.onPPGModel

enum HeadbandState {
  /// 
  disconnected,

  /// 
  connecting,

  /// device connected
  connected,

  /// device adjust fit
  contacting,

  /// device wear upsideDown 
  contactUpsideDown,

  /// AFE contact well and device wear normal
  contacted,

  /// attention & meditation analyzed
  analyzed
}

state.isConnected
state.isContacted
state.isAnalyzed

class EEGModel {
  final int seqNum;
  final List<double> eeg;
}

class BrainWaveModel {
  late double gamma;
  late double highBeta;
  late double lowBeta;
  late double alpha;
  late double theta;
  late double delta;
}
```
