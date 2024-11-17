import 'package:shared_preferences/shared_preferences.dart';

class GameStore {
  final _key = "UNLOCKED";
  var unlocked = {"ក", "ខ", "គ"};
  String? wantToUnlocked;

  Future<void> store() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList(_key, unlocked.toList());
  }

  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final result = prefs.getStringList(_key);

    if (result != null) {
      unlocked = result.toSet();
    }
  }
}

GameStore gameStore = GameStore();
