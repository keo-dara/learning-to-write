import 'package:flame_audio/flame_audio.dart';

class GameSound {
    constructor() {
        FlameAudio.bgm.play('bg.mp3', volume: .1);
    }
}