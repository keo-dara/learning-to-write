import 'package:drawing/conf.dart';
import 'package:flutter/foundation.dart';

class GameConfig {
  static const statusBarHeight = 78.0;

  static const musicBgValum = 0.05;

  static const testrewardAdUnit = "ca-app-pub-3940256099942544/5224354917";
  static const rewardAdUnit =
      kReleaseMode ? realRewardAdUnit : testrewardAdUnit;
}
