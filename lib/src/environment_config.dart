import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvironmentConfig {
  // Add the API key by running `flutter run --dart-define=movieApiKey=<value>`
  /// For this exam, here's my API key: 12d23511f39faf4a6a19aaf7f1866e5d
  final movieApiKey = const String.fromEnvironment('movieApiKey');
}

final environmentConfigProvider = Provider<EnvironmentConfig>(
  (ref) => EnvironmentConfig(),
);
