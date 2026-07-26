import 'package:shared_preferences/shared_preferences.dart';

class ExerciseTutorialPreferences {
  const ExerciseTutorialPreferences._();

  static const _seenPrefix = 'exercise_tutorial_seen_';
  static const _skipPrefix = 'exercise_tutorial_skip_';

  static Future<bool> shouldShow(String exerciseId) async {
    final preferences = await SharedPreferences.getInstance();
    return !(preferences.getBool('$_skipPrefix$exerciseId') ?? false);
  }

  static Future<void> complete(
    String exerciseId, {
    required bool skipNextTime,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('$_seenPrefix$exerciseId', true);
    await preferences.setBool('$_skipPrefix$exerciseId', skipNextTime);
  }

  static Future<bool> hasSeen(String exerciseId) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool('$_seenPrefix$exerciseId') ?? false;
  }

  static Future<void> resetAll() async {
    final preferences = await SharedPreferences.getInstance();
    final keys = preferences
        .getKeys()
        .where(
          (key) => key.startsWith(_seenPrefix) || key.startsWith(_skipPrefix),
        )
        .toList(growable: false);
    for (final key in keys) {
      await preferences.remove(key);
    }
  }
}
