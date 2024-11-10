import 'dart:async';

import 'package:drawing/main.dart';
import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';

import '../widget/button.dart';

class HubScreen extends Component with HasGameReference<RouterGame> {
  HubScreen() {
    _bg = SpriteComponent(anchor: Anchor.center);
    _button1 = PlayButton(action: () => game.router.pushNamed('level1'));
    _button1.size = Vector2(160, 80);

    addAll([
      _bg,
      _logo = SvgComponent(size: Vector2.all(340.0), anchor: Anchor.center),
      _button1
    ]);
  }

  late final SvgComponent _logo;
  late final SpriteComponent _bg;
  late final PlayButton _button1;

  @override
  FutureOr<void> onLoad() async {
    final svg = await Svg.load('svg/logo.svg');
    final bg = await Sprite.load('bg.png');

    _bg.sprite = bg;
    _logo.svg = svg;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _logo.position = Vector2(size.x / 2, size.y * 0.15);
    _button1.position = Vector2((size.x / 2) - 80, _logo.y + 250);
    _bg.position = size / 2;
  }
}
