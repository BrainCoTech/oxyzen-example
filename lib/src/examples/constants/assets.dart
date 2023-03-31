const String assetsPrefix = 'assets';

const _resUrl = 'https://focus-resource.oss-cn-beijing.aliyuncs.com/headband';

class Images {
  static const String _prefix = '$assetsPrefix/images';
  static const String headbandEmpty = '$_prefix/ic_headband_empty.webp';
  static const String headband = '$_prefix/ic_headband.webp';
  static const String rewardDecoration2 = '$_prefix/reward_decoration_2.webp';
  static const String rewardFirework = '$_prefix/reward_firework.webp';
  static const String shining = '$_prefix/shining.webp';
  static const String icDialogBg = '$_prefix/ic_head_alert_bg.webp';
  static const String btnBack = '$_prefix/btn_back.webp';
  static const String btnShort = '$_prefix/btn_short.webp';
  static const String titleBgRibbon = '$_prefix/title_bg_ribbon.webp';
  static const String icCrimson = '$_prefix/ic_crimson.webp';
  static const String icBluetoothYellow = '$_prefix/ic_bluetooth_yellow.webp';
  static const String icRefresh = '$_prefix/ic_refresh.webp';
  static const String bgScanHeadband = '$_prefix/bg_scan_headband.webp';
  static const String icAdd = '$_prefix/ic_add.svg';
  static const String icLock = '$_prefix/ic_lock.svg';
  static const String icRouter = '$_prefix/ic_router.svg';
  static const String icDisconnect = '$_prefix/ic_disconnect.svg';
  static const String icEmpty = '$_prefix/ic_empty.svg';
  static const String icBattery = '$_prefix/ic_battery.svg';
  static const String icBatteryVertical = '$_prefix/ic_battery_vertical.svg';
  static const String icPerson = '$_prefix/ic_person.svg';
  static const String icHelp = '$_prefix/ic_help.svg';
  static const String icArrow = '$_prefix/ic_arrow.webp';
  static const String btnDisabled = '$_prefix/bg_btn_disabled.webp';
  static const String icTips = '$_prefix/ic_tips.png';
  static const String icArrowGray = '$_prefix/ic_arrow_gray.png';
  static const String icDeviceZen = '$_prefix/ic_headband_zen.png';
  static const String icDeviceZenLite = '$_prefix/ic_headband_zenlite.png';

  static const String _gifUrlPrefix = '$_resUrl/gif';
  static const String headbandSetup2Ap =
      '$_gifUrlPrefix/headband_setup_2_ap.gif';
  static const String apModeVideoUrl =
      '$_gifUrlPrefix/light_state_1234554321.gif';
  static const String normalModeVideoUrl =
      '$_gifUrlPrefix/light_state_12345.gif';

  static const _urlPrefix = '$_resUrl/app_custom_config/app_focus_world/image';
  static String get focusWorldImageUrlPrefix => _urlPrefix;
  static const cmsnConnected = '$_urlPrefix/cmsn_connected.png';
  static const cmsnPressPowerKey = '$_urlPrefix/cmsn_press_power.png';
}

class Audios {
  static const String _audioUrlPrefix = '$_resUrl/audios';
  static const String crimsonPairingMode =
      '$_audioUrlPrefix/crimson_pairing_mode.mp3';
}

///远程资源存储在OSS目录 oss://focus-resource/headband/
class Videos {
  static const String _videoAsset = '$assetsPrefix/videos';
  static const String assetPairing =
      '$_videoAsset/crimson_led_pairing_loop.mp4';
  static const String assetConnecting = '$_videoAsset/crimson_connecting.mp4';
  static const String zenConnecting = '$_videoAsset/zen_connecting.mp4';

  static const String _videoUrlPrefix = '$_resUrl/videos';
  static const String _focus1Prefix = '$_videoUrlPrefix/focus1';
  static const String _cmsnPrefix = '$_videoUrlPrefix/cmsn';

  static const String crimsonLoopPairingModeVideoUrl =
      '$_cmsnPrefix/crimson_led_pairing_loop.mp4';
  static const String crimsonPairingModeVideoUrl =
      '$_cmsnPrefix/crimson_led_pairing.mp4';
  static const String crimsonNormalModeVideoUrl =
      '$_cmsnPrefix/crimson_led_normal.mp4';
  static const String crimsonTutorialsPair =
      '$_cmsnPrefix/crimson_tutorials_pair.mp4';
  static const String crimsonTutorialsBoot =
      '$_cmsnPrefix/crimson_tutorials_boot.mp4';
  static const String crimsonTutorialsWear =
      '$_cmsnPrefix/crimson_tutorials_wear.mp4';

  static const String electrodeSetup = '$_focus1Prefix/electrode_setup.mp4';
  static const String headbandSetup1 = '$_focus1Prefix/headband_setup_1.mp4';
  static const String headbandSetup2Reset =
      '$_focus1Prefix/headband_setup_2_reset.mp4';
  static const String headbandSetup3Sn =
      '$_focus1Prefix/headband_setup_3_sn.mp4';
  static const String headbandHintReset =
      '$_focus1Prefix/headband_hint_reset.mp4';
  static const String headbandHintSn = '$_focus1Prefix/headband_hint_sn.mp4';
  static const String connectWifiIos = '$_focus1Prefix/connect_wifi_ios.mp4';
  static const String connectWifiAndroid =
      '$_focus1Prefix/connect_wifi_android.mp4';
}

class Animations {
  static const String _prefix = '$assetsPrefix/lottie';
  static const String headbandConnecting =
      '$_prefix/headband_connecting.json'; //Focus1
  static const String headbandConnectingCalm =
      '$_prefix/wear_success_calm.json';
  static const String headbandScanning =
      '$_prefix/headband_scanning.json'; //Crimson
  static const String tvShake = '$_prefix/tv_dance.json';
  static const String textConnecting = '$_prefix/text_connecting.json';
  static const String textPairing = '$_prefix/text_pairing.json';
}
