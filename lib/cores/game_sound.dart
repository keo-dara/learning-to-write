import 'package:flame_audio/flame_audio.dart';

class GameSound {
  static void playClickSound() {
    FlameAudio.play("click.wav", volume: 0.35);
  }
}
