import 'dart:async';

import 'package:drawing/cores/game_sound.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_svg/flame_svg.dart';

class PlayButton extends PositionComponent with TapCallbacks {
  final String icon;
  final void Function() action;

  PlayButton({
    super.position,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor,
    super.children,
    super.priority,
    super.key,
    super.size,
    required this.icon,
    required this.action,
  });

  @override
  FutureOr<void> onLoad() async {
    final svg = await Svg.load(icon);

    final svgSprite = SvgComponent(
      svg: svg,
      anchor: Anchor.center,
      position: size / 2,
      size: size,
    );

    add(svgSprite);
  }

  @override
  void onTapDown(TapDownEvent event) {
    scale = Vector2.all(1.05);
  }

  @override
  void onTapUp(TapUpEvent event) {
    scale = Vector2.all(1.0);
    GameSound.playClickSound();
    action();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    scale = Vector2.all(1.0);
  }
}
