import 'dart:convert';
import 'package:flutter/services.dart';

class Helper {
  static Future<dynamic> readJson() async {
    final String response = await rootBundle.loadString('test/data/movie.json');
    final data = await json.decode(response);
    return data;
  }
}
