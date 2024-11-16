// First, add your JSON file to assets folder and declare it in pubspec.yaml:
// assets:
//   - assets/data.json

import 'dart:convert';
import 'package:flutter/services.dart';

class JsonReader {
  // Read and parse JSON file from assets
  static Future<Map<String, dynamic>> readJson(String filePath) async {
    try {
      // Load the JSON file from assets
      final String response = await rootBundle.loadString(filePath);
      // Parse the JSON string
      final Map<String, dynamic> data = json.decode(response);
      return data;
    } catch (e) {
      throw Exception('Failed to load JSON file: $e');
    }
  }

  // Read JSON file and return as List
  static Future<List<dynamic>> readJsonList(String filePath) async {
    try {
      final String response = await rootBundle.loadString(filePath);
      final List<dynamic> data = json.decode(response);
      return data;
    } catch (e) {
      throw Exception('Failed to load JSON file: $e');
    }
  }
}

class Step {
  final List<PositionData> data;

  Step({required this.data});

  factory Step.fromJson(Map<String, dynamic> json, {String key = "ក"}) {
    final List<dynamic> rawData = json[key] as List<dynamic>;
    return Step(
      data: rawData.map((item) => PositionData.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ក': data.map((item) => item.toJson()).toList(),
    };
  }
}

// PositionData model for individual position entries
class PositionData {
  final String asset;
  final List<List<double>> monkey;
  final List<List<double>> banana;

  PositionData({
    required this.asset,
    required this.monkey,
    required this.banana,
  });

  factory PositionData.fromJson(Map<String, dynamic> json) {
    return PositionData(
      asset: json['asset'] as String,
      monkey:
          (json['monkey'] as List).map((e) => List<double>.from(e)).toList(),
      banana:
          (json['banana'] as List).map((e) => List<double>.from(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asset': asset,
      'monkey': monkey,
      'banana': banana,
    };
  }
}

// Updated DataLoader class
class DataLoader {
  Step? position;
  int? currentIndex;
  int total = -1;

  // next
  Future<bool> next() async {
    if (currentIndex == null) {
      return false;
    }
    if (currentIndex == total - 1) {
      return false;
    }

    currentIndex = currentIndex! + 1;
    await loadData(currentIndex!);

    return true;
  }

  Future<void> loadData(int index) async {
    currentIndex = index;
    final data = await JsonReader.readJson('assets/data/position.json');
    final key = data.keys.toList()[currentIndex!];
    total = data.keys.length;
    position = Step.fromJson(data, key: key);
  }

  bool get isLast => currentIndex == total - 1;
}

final DataLoader dataLoader = DataLoader();
