import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flame_svg/svg.dart';
import 'package:flame_svg/svg_component.dart';
import 'package:flutter/material.dart';

class LevelCell extends PositionComponent with TapCallbacks {
  final String levelNumber;
  final bool locked;
  late TextComponent levelText;
  late final SvgComponent background;

  final void Function() action;

  LevelCell(
    this.levelNumber,
    Vector2 position,
    Vector2 size, {
    required this.action,
    required this.locked,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    background = SvgComponent(
      svg: !locked
          ? await Svg.load('svg/tile.svg')
          : await Svg.load('svg/locked.svg'),
      size: size,
    );
    add(background);

    // Add level number text
    levelText = TextComponent(
      text: levelNumber.toString(),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    levelText.position = Vector2(
      (size.x - levelText.size.x) / 2,
      (size.y - levelText.size.y) / 2,
    );

    add(levelText);
  }

  @override
  bool onTapDown(TapDownEvent event) {
    scale = Vector2.all(1.05);
    return true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    action();
    scale = Vector2.all(1.0);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    scale = Vector2.all(1.0);
  }
}
