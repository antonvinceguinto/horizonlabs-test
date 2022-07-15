import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  prefs = await SharedPreferences.getInstance();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
