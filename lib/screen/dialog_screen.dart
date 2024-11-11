import 'package:drawing/data_loader.dart';
import 'package:drawing/main.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_svg/flame_svg.dart';

class PausePage extends Component
    with TapCallbacks, HasGameReference<RouterGame> {
  late final SvgComponent dialog;
  late final SvgComponent next;
  late final SvgComponent retry;

  @override
  Future<void> onLoad() async {
    final game = findGame()!;

    final svg = await Svg.load('svg/dummy.svg');
    final svgnext = await Svg.load('svg/next.svg');
    final svgretry = await Svg.load('svg/retry.svg');
    dialog =
        SvgComponent(svg: svg, size: Vector2(324, 406), anchor: Anchor.center);
    next = SvgComponent(
        svg: svgnext, size: Vector2(80, 80), anchor: Anchor.center);
    retry = SvgComponent(
        svg: svgretry, size: Vector2(100, 100), anchor: Anchor.center);

    dialog.position = game.size / 2;
    retry.position = Vector2(dialog.position.x - 40, dialog.position.y);
    next.position = Vector2(dialog.position.x + 60, dialog.position.y + 10);
    addAll([dialog, next, retry]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) {
    if (next.containsPoint(event.localPosition)) {
      game.router.pop();
      game.router.pop();
      Future.delayed(const Duration(milliseconds: 10)).then((_) async {
        await dataLoader.next();
        game.router.pushNamed('level2');
      });
    }
    if (retry.containsPoint(event.localPosition)) {
      game.router.pop();
      game.router.pop();
      Future.delayed(const Duration(milliseconds: 10)).then((_) async {
        game.router.pushNamed('level2');
      });
    }
  }
}
