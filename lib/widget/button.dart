import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_svg/flame_svg.dart';

class PlayButton extends PositionComponent with TapCallbacks {
  final void Function() action;

  PlayButton({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor,
    super.children,
    super.priority,
    super.key,
    required this.action,
  });

  @override
  FutureOr<void> onLoad() async {
    final svg = await Svg.load('/svg/play.svg');

    final svgSprite = SvgComponent(
      svg: svg,
      anchor: Anchor.center,
      position: size / 2,
      size: Vector2(160, 80),
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
    action();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    scale = Vector2.all(1.0);
  }
}
