import 'dart:async';

import 'package:drawing/main.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_svg/flame_svg.dart';

import '../widget/button.dart';

class HubScreen extends Component with HasGameReference<RouterGame> {
  HubScreen() {
    _bg = SpriteComponent(anchor: Anchor.center);
    _startButton = PlayButton(
      icon: "svg/play.svg",
      action: () => game.router.pushNamed('level1'),
    );
    _soundButton = PlayButton(
      icon: "svg/sound_on.svg",
      action: () async {
        await FlameAudio.bgm.stop();

        remove(_soundButton);
        add(_unsoundButton);
      },
    );
    _unsoundButton = PlayButton(
      icon: "svg/sound_off.svg",
      action: () async {
        await FlameAudio.bgm.play('bg.mp3', volume: 0.1);
        remove(_unsoundButton);
        add(_soundButton);
      },
    );
    _rateButton = PlayButton(
      icon: "svg/rating.svg",
      action: () => game.router.pushNamed('level1'),
    );
    _startButton.size = Vector2(160, 80);

    addAll([
      _bg,
      _logo = SvgComponent(size: Vector2.all(340.0), anchor: Anchor.center),
      _startButton,
      _soundButton,
      _rateButton,
    ]);
  }

  late final SvgComponent _logo;
  late final SpriteComponent _bg;
  late final PlayButton _startButton;
  late final PlayButton _soundButton;
  late final PlayButton _unsoundButton;
  late final PlayButton _rateButton;

  bool isPlaying = true;

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

    final centerX = size.x / 2;
    final smallBtnSize = Vector2(100, 80);

    _logo.position = Vector2(centerX, size.y * 0.15);
    _startButton.position = Vector2(centerX - 80, _logo.y + 250);
    _startButton.size = Vector2(160, 80);

    _soundButton.position =
        Vector2(centerX - 100, _startButton.y + 5 + _startButton.height);
    _soundButton.size = smallBtnSize;
    _unsoundButton.position = _soundButton.position;
    _unsoundButton.size = smallBtnSize;

    _rateButton.position =
        Vector2((size.x / 2) - 10, _startButton.y + 5 + _startButton.height);
    _rateButton.size = smallBtnSize;
    _bg.position = size / 2;
  }
}
