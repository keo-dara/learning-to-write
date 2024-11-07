import 'package:drawing/data_loader.dart';
import 'package:drawing/screen/draw_tracing.dart';
import 'package:drawing/screen/hub_screen.dart';
import 'package:drawing/screen/level_screen.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/widgets.dart' hide Route;

import 'widget/widget.dart';

void main() {
  final game = RouterGame();
  runApp(GameWidget(game: game));
}

class RouterGame extends FlameGame {
  late final RouterComponent router;

  @override
  Future<void> onLoad() async {
    add(
      router = RouterComponent(
        routes: {
          'home': Route(HubScreen.new),
          'level1': Route(LevelPage.new),
          'level2': Route(PlayingPage.new),
          'pause': PauseRoute(),
        },
        initialRoute: 'home',
      ),
    );
  }
}

class Background extends Component {
  Background(this.color);
  final Color color;

  @override
  void render(Canvas canvas) {
    canvas.drawColor(color, BlendMode.srcATop);
  }
}

class LevelPage extends Component
    with TapCallbacks, HasGameReference<RouterGame> {
  late final SpriteComponent bg;
  @override
  Future<void> onLoad() async {
    final gg = findGame()!;
    final tracing = LevelScreen(onTapAt: (key) async {
      await dataLoader.loadData(key);
      game.router.pushNamed('level2');
    });
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

class PausePage extends Component
    with TapCallbacks, HasGameReference<RouterGame> {
  @override
  Future<void> onLoad() async {
    final game = findGame()!;
    addAll([
      TextComponent(
        text: 'PAUSED',
        position: game.canvasSize / 2,
        anchor: Anchor.center,
        children: [
          ScaleEffect.to(
            Vector2.all(1.1),
            EffectController(
              duration: 0.3,
              alternate: true,
              infinite: true,
            ),
          ),
        ],
      ),
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) => game.router.pop();
}
