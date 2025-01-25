import 'package:drawing/cores/game_sound.dart';
import 'package:drawing/cores/game_store.dart';
import 'package:drawing/data_loader.dart';
import 'package:drawing/screen/dialog_screen.dart';
import 'package:drawing/screen/draw_tracing.dart';
import 'package:drawing/screen/hub_screen.dart';
import 'package:drawing/screen/level_screen.dart';
import 'package:drawing/widget/widget.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

class RouterGame extends FlameGame {
  late final RouterComponent router;

  @override
  Future<void> onLoad() async {
    add(
      router = RouterComponent(
        routes: {
          'home': Route(HubScreen.new),
          'levels': Route(LevelPage.new),
          'drawing': Route(PlayingPage.new),
          'pause': PauseRoute(),
          'locked': LockedRoute(),
        },
        initialRoute: 'home',
      ),
    );
    beforePlay();
  }

  void beforePlay() async {
    if (!kDebugMode) {
      await FlameAudio.bgm.play('bg.mp3', volume: 0.1);
    }
  }

  @override
  void onDispose() {
    FlameAudio.bgm.stop();
  }
}

class LevelPage extends Component
    with TapCallbacks, HasGameReference<RouterGame> {
  late final SpriteComponent bg;

  @override
  Future<void> onLoad() async {
    final gg = findGame()!;
    final tracing = LevelScreen(onTapAt: (index, locked) async {
      final key = await dataLoader.loadData(index);

      if (locked) {
        gameStore.wantToUnlocked = key;
        game.router.pushNamed('locked');
      } else {
        GameSound.playClickSound();
        game.router.pushNamed('drawing');
      }
    });
    tracing.position = Vector2(0, 20);
    tracing.size = gg.size;
    final bgSprite = await Sprite.load('bg.png');
    bg = SpriteComponent(anchor: Anchor.center);
    bg.sprite = bgSprite;
    addAll([
      bg,
      BackButton(),
      tracing,
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    bg.position = size / 2;
  }
}

class PlayingPage extends Component {
  late final SpriteComponent bg;
  late DrawingTracingGame drawingTracingGame;
  @override
  Future<void> onLoad() async {
    final game = findGame()!;

    drawingTracingGame = DrawingTracingGame();
    drawingTracingGame.size = game.size;
    final bgSprite = await Sprite.load('bg.png');
    bg = SpriteComponent(anchor: Anchor.center);
    bg.sprite = bgSprite;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    bg.position = size / 2;
  }

  @override
  void onMount() async {
    super.onMount();
    final game = findGame()!;

    drawingTracingGame = DrawingTracingGame();
    drawingTracingGame.size = game.size;

    addAll([
      bg,
      BackButton(),
      PauseButton(),
      drawingTracingGame,
    ]);
  }

  @override
  void onRemove() {
    removeFromParent();
  }
}

class PauseRoute extends Route {
  PauseRoute() : super(PausePage.new, transparent: true);

  @override
  void onPush(Route? previousRoute) {
    previousRoute!
      ..stopTime()
      ..addRenderEffect(
        PaintDecorator.grayscale(opacity: 0.5)..addBlur(3.0),
      );
  }

  @override
  void onPop(Route nextRoute) {
    nextRoute
      ..resumeTime()
      ..removeRenderEffect();
  }
}

class LockedRoute extends Route {
  LockedRoute() : super(LockedDailog.new, transparent: true);

  @override
  void onPush(Route? previousRoute) {
    previousRoute!
      ..stopTime()
      ..addRenderEffect(
        PaintDecorator.grayscale(opacity: 0.5)..addBlur(3.0),
      );
  }

  @override
  void onPop(Route nextRoute) {
    nextRoute
      ..resumeTime()
      ..removeRenderEffect();
  }
}
