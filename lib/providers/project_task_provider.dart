import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';

import '../models/task.dart';
import '../models/project.dart';

class ProjectTaskProvider with ChangeNotifier {
  final LocalStorage storage;

  ProjectTaskProvider(this.storage) {
    _init();
  }

  List<Task> _tasks = [];
  
  List<Task> get tasks => _tasks;
  List<Project> _projects = [];
  

  List<Project> get projects => _projects;

  Future<void> _init() async {

    _loadProjectsFromStorage();
    _loadTasksFromStorage();
  }

  

  void addTask(Task task) {
    _tasks.add(task);
    _saveTasksToStorage();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasksToStorage();
    notifyListeners();
  }

  
  void addProject(Project project) {
    _projects.add(project);
    _saveProjectsToStorage();
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _saveProjectsToStorage();
    notifyListeners();
  }


  void _loadProjectsFromStorage() {
    final storedProjectsString = storage.getItem('projects');
    if (storedProjectsString != null) {
      final List<dynamic> storedProjects = jsonDecode(storedProjectsString);
      _projects = storedProjects.map((item) => Project.fromJson(item)).toList();
      notifyListeners();
    }
  }

  void _saveProjectsToStorage() {
    final projectsJson = jsonEncode(_projects.map((e) => e.toJson()).toList());
    storage.setItem('projects', projectsJson);
    
  }

    void _loadTasksFromStorage() {
    final storedTasksString = storage.getItem('tasks');
    if (storedTasksString != null) {
      final List<dynamic> storedTasks = jsonDecode(storedTasksString);
      _tasks = storedTasks.map((item) => Task.fromJson(item)).toList();
      notifyListeners();
    }
  }

  void _saveTasksToStorage() {
    final tasksJson = jsonEncode(_tasks.map((e) => e.toJson()).toList());
    storage.setItem('tasks', tasksJson);
    
  }

}