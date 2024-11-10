import 'package:drawing/data_loader.dart';
import 'package:drawing/widget/widget.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Letter extends SvgComponent with TapCallbacks {
  Letter({
    super.svg,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
    super.paint,
    super.key,
    required this.pos,
  });

  final PositionData pos;
  late final List<SpriteComponent> monkeys = [];
  late final List<SpriteComponent> bananas = [];

  @override
  Future<void> onLoad() async {
    final spriteSizeBig = Vector2.all(340.0);
    svg = await Svg.load(pos.asset);
    size = spriteSizeBig;
    anchor = Anchor.center;
    addDrawingRange();
    loadDebug();
  }

  List<Vector2> points = [];

  @override
  void onTapDown(TapDownEvent event) {
    if (kDebugMode) {
      print(event.localPosition);
      points.add(event.localPosition);
    }
  }

  void addDrawingRange() {
    final bs = pos.banana;

    for (final position in bs) {
      final banana = Banana();
      banana.position = Vector2(position.first, position.last);

      bananas.add(banana);
      add(banana);
    }

    final ms = pos.monkey;
    for (final position in ms) {
      final monkey = Monkey();
      monkey.position = Vector2(position.first, position.last);
      monkeys.add(monkey);
      add(monkey);
    }
  }

  @override
  void onRemove() {
    removeFromParent();
  }

  void loadDebug() {
    if (kDebugMode) {
      final btnCopy = RoundedButton(
        text: 'COPY',
        action: () {
          Clipboard.setData(ClipboardData(text: "${points}"));
        },
        color: Colors.green,
        borderColor: Colors.white,
      );
      final btnClear = RoundedButton(
        text: 'CLEAR',
        action: () {
          points.clear();
        },
        color: Colors.red,
        borderColor: Colors.white,
      );
      const offset = -120.0;
      btnCopy.position = Vector2(size.x / 1.5 + 20, offset);
      btnClear.position = Vector2(size.x / 3 - 20, offset);
      // btnCopy.position = size / 2.5;
      addAll([btnClear, btnCopy]);
    }
  }
}

class Monkey extends SpriteComponent {
  @override
  Future<void> onLoad() async {
    final spriteSize = Vector2.all(40.0);
    sprite = await Sprite.load('monkey.png');
    size = spriteSize;
    anchor = Anchor.center;
    size = Vector2.all(45.0);
  }
}

class Banana extends SpriteComponent {
  @override
  Future<void> onLoad() async {
    final spriteSize = Vector2.all(40.0);
    sprite = await Sprite.load('banana.png');
    size = spriteSize;
    anchor = Anchor.center;
    size = Vector2.all(45.0);
  }
}
