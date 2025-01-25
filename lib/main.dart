import 'package:drawing/routes.dart';
import 'package:flame/game.dart';

import 'package:flutter/widgets.dart' hide Route;
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  final game = RouterGame();

  runApp(GameWidget(game: game));
}
