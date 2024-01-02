import 'package:shared_preferences/shared_preferences.dart';

class ProgressionStore {
  final SharedPreferences _prefs;

  int _lastPlayedLevelIndex;
  int _highestLevelIndex;

  ProgressionStore({
    required SharedPreferences prefs,
  })  : _prefs = prefs,
        _lastPlayedLevelIndex = prefs.getInt('lastPlayedLevelIndex') ?? 0,
        _highestLevelIndex = prefs.getInt('highestLevelIndex') ?? 0;

  void updateLastPlayedLevelIndex(int index) {
    _lastPlayedLevelIndex = index;
    _prefs.setInt('lastPlayedLevelIndex', index);
  }

  void updateHighestLevelIndex(int index) {
    _highestLevelIndex = index;
    _prefs.setInt('highestLevelIndex', index);
  }

  int get lastPlayedLevelIndex => _lastPlayedLevelIndex;
  int get highestLevelIndex => _highestLevelIndex;
}
