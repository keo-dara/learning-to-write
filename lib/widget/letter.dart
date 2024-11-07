import 'package:drawing/data_loader.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/foundation.dart';

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
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (kDebugMode) {
      print(event.localPosition);
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
}

class Monkey extends SpriteComponent {
  @override
  Future<void> onLoad() async {
    final spriteSize = Vector2.all(45.0);
    sprite = await Sprite.load('monkey.png');
    size = spriteSize;
    anchor = Anchor.center;
  }
}

class Banana extends SpriteComponent {
  @override
  Future<void> onLoad() async {
    final spriteSize = Vector2.all(40.0);
    sprite = await Sprite.load('banana.png');
    size = spriteSize;
    anchor = Anchor.center;
  }
}
