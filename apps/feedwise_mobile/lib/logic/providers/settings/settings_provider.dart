import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateProvider<bool>((ref) => true); // true = dark mode

final localeProvider = StateProvider<String>((ref) => 'en');

final textScaleProvider = StateProvider<double>((ref) => 1.0);

final settingsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'dark_mode': prefs.getBool('dark_mode') ?? true,
    'locale': prefs.getString('locale') ?? 'en',
    'notifications_enabled': prefs.getBool('notifications_enabled') ?? true,
    'reduce_animations': prefs.getBool('reduce_animations') ?? false,
  };
});

class SettingsController extends Notifier<void> {
  @override
  void build() {}

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
    ref.read(themeProvider.notifier).state = value;
  }

  Future<void> setLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale);
    ref.read(localeProvider.notifier).state = locale;
  }
}

final settingsControllerProvider = NotifierProvider<SettingsController, void>(
  SettingsController.new,
);
