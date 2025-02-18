import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';

import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;
  List<TimeEntry> _entries = [];

  List<TimeEntry> get entries => _entries;

  TimeEntryProvider(this.storage) {
    _init();
  }

  Future<void> _init() async {

    _loadEntriesFromStorage();

  }

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveEntriesToStorage();
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveEntriesToStorage();
    notifyListeners();
  }


  void _loadEntriesFromStorage() {
    final storedEntriesString = storage.getItem('entries');
    if (storedEntriesString != null) {
      final List<dynamic> storedProjects = jsonDecode(storedEntriesString);
      _entries = storedProjects.map((item) => TimeEntry.fromJson(item)).toList();
      notifyListeners();
    }
  }

  void _saveEntriesToStorage() {
    final entriesJson = jsonEncode(_entries.map((e) => e.toJson()).toList());
    storage.setItem('entries', entriesJson);
    
  }
}