import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final historyServiceProvider = Provider<HistoryService>((ref) {
  return HistoryService();
});

class HistoryService {
  static const String _historyKey = 'scan_history';
  static int _nextId = 1;

  Future<List<ScanHistoryItem>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];
      
      if (historyJson.isEmpty) {
        // Initialize nextId from existing items if any
        return [];
      }

      final history = historyJson
          .map((json) => ScanHistoryItem.fromJson(jsonDecode(json)))
          .toList()
        ..sort((a, b) {
          // Sort by date and time descending (newest first)
          final dateCompare = b.date.compareTo(a.date);
          if (dateCompare != 0) return dateCompare;
          return b.time.compareTo(a.time);
        });

      // Update nextId based on max id
      if (history.isNotEmpty) {
        _nextId = history.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
      }

      return history;
    } catch (e) {
      return [];
    }
  }

  Future<void> addHistoryItem(ScanHistoryItem item) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getHistory();
      
      // Insert at the beginning (newest first)
      history.insert(0, item);
      
      // Keep only last 100 items to avoid storage issues
      final limitedHistory = history.take(100).toList();
      
      final historyJson = limitedHistory
          .map((item) => jsonEncode(item.toJson()))
          .toList();
      
      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      // Silently fail - history is not critical
    }
  }

  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
      _nextId = 1;
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> deleteHistoryItem(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getHistory();
      history.removeWhere((item) => item.id == id);
      
      final historyJson = history
          .map((item) => jsonEncode(item.toJson()))
          .toList();
      
      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      // Silently fail
    }
  }

  int getNextId() {
    return _nextId++;
  }
}

class ScanHistoryItem {
  final int id;
  final String diseaseName;
  final String status;
  final double confidence;
  final String date;
  final String time;
  final String? imagePath; // Optional: path to saved image

  const ScanHistoryItem({
    required this.id,
    required this.diseaseName,
    required this.status,
    required this.confidence,
    required this.date,
    required this.time,
    this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'diseaseName': diseaseName,
        'status': status,
        'confidence': confidence,
        'date': date,
        'time': time,
        'imagePath': imagePath,
      };

  factory ScanHistoryItem.fromJson(Map<String, dynamic> json) => ScanHistoryItem(
        id: json['id'] as int,
        diseaseName: json['diseaseName'] as String,
        status: json['status'] as String,
        confidence: (json['confidence'] as num).toDouble(),
        date: json['date'] as String,
        time: json['time'] as String,
        imagePath: json['imagePath'] as String?,
      );
}

