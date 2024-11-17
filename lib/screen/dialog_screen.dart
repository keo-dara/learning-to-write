import 'dart:async';

import 'package:drawing/cores/game_config.dart';
import 'package:drawing/cores/game_sound.dart';
import 'package:drawing/cores/game_store.dart';
import 'package:drawing/data_loader.dart';
import 'package:drawing/main.dart';
import 'package:drawing/widget/button.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PausePage extends Component
    with TapCallbacks, HasGameReference<RouterGame> {
  late final SvgComponent dialog;
  late final PlayButton next;
  late final PlayButton retry;
  late final PlayButton home;

  PausePage() {
    next = PlayButton(
        icon: "svg/next.svg",
        size: Vector2(80, 80),
        anchor: Anchor.center,
        action: nextPage);
    home = PlayButton(
        icon: "svg/home.svg",
        size: Vector2(80, 80),
        anchor: Anchor.center,
        action: nextPage);
  }

  @override
  FutureOr<void> onLoad() async {
    final game = findGame()!;

    final svg = await Svg.load('svg/dummy.svg');

    dialog =
        SvgComponent(svg: svg, size: Vector2(324, 406), anchor: Anchor.center);

    retry = PlayButton(
      icon: "svg/retry.svg",
      size: Vector2(100, 100),
      anchor: Anchor.center,
      action: retryGame,
    );

    dialog.position = game.size / 2;
    retry.position = Vector2(dialog.position.x - 40, dialog.position.y);
    next.position = Vector2(dialog.position.x + 60, dialog.position.y + 10);
    home.position = Vector2(dialog.position.x + 60, dialog.position.y + 10);

    addAll([
      dialog,
      retry,
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  void retryGame() {
    game.router.pop();
    game.router.pop();
    GameSound.playClickSound();
    Future.delayed(const Duration(milliseconds: 10)).then((_) async {
      game.router.pushNamed('level2');
    });
  }

  void nextPage() {
    game.router.pop();
    game.router.pop();
    Future.delayed(const Duration(milliseconds: 10)).then((_) async {
      final more = await dataLoader.next();
      GameSound.playClickSound();
      if (more) {
        game.router.pushNamed('level2');
      } else {
        game.router.pop();
      }
    });
  }

  @override
  void onGameResize(Vector2 size) async {
    super.onGameResize(size);

    addAll([
      if (!dataLoader.isLast) next,
      if (dataLoader.isLast) home,
    ]);
  }
}

class LockedDailog extends Component
    with TapCallbacks, HasGameReference<RouterGame> {
  late final SvgComponent dialog;
  late final PlayButton next;
  late final PlayButton home;

  LockedDailog() {
    next = PlayButton(
        icon: "svg/next.svg",
        size: Vector2(80, 80),
        anchor: Anchor.center,
        action: _loadRewardAds);
    home = PlayButton(
        icon: "svg/home.svg",
        size: Vector2(80, 80),
        anchor: Anchor.center,
        action: retryGame);
  }

  @override
  FutureOr<void> onLoad() async {
    final game = findGame()!;

    final svg = await Svg.load('svg/dummy.svg');

    dialog =
        SvgComponent(svg: svg, size: Vector2(324, 406), anchor: Anchor.center);

    dialog.position = game.size / 2;
    next.position = Vector2(dialog.position.x + 60, dialog.position.y + 80);
    home.position = Vector2(dialog.position.x - 40, next.position.y);
    addAll([
      dialog,
      next,
      home,
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  void retryGame() {
    game.router.pop();
  }

  void _loadRewardAds() {
    RewardedAd.load(
      adUnitId:
          kDebugMode ? GameConfig.testrewardAdUnit : GameConfig.rewardAdUnit,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.show(onUserEarnedReward: (view, reward) async {
            if (reward.amount == 10) {
              game.router.pop();
              if (gameStore.wantToUnlocked != null) {
                gameStore.unlocked.add(gameStore.wantToUnlocked!);
                gameStore.store();
              }
            }
          });
        },
        onAdFailedToLoad: (error) {
          print("Rewarded Ads Failed to load");
        },
      ),
    );
  }
}
