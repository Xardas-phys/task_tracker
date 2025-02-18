import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';
import '../providers/project_task_provider.dart';
import 'add_time_entry_screen.dart';
import 'project_task_management_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Time Tracker')),
          
          bottom: TabBar(
            tabs: [
              Tab(text: 'All entries'),
              Tab(text: 'Grouped by project'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.task),
                title: Text('Manage Tasks'),
                onTap: () {
                  // Close the drawer first
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProjectTaskManagementScreen(initialShowProjects: false,)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.work),
                title: Text('Manage Projects'),
                onTap: () {
                  // Close the drawer first
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProjectTaskManagementScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AllEntriesTab(),
            GroupedByProjectTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the screen to add a new time entry
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
            );
          },
          tooltip: 'Add Time Entry',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

/// Tab that shows all time entries
class AllEntriesTab extends StatelessWidget {
  const AllEntriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<TimeEntryProvider, ProjectTaskProvider>(
      builder: (context, provider, projectTaskProvider, child) {
        if (provider.entries.isNotEmpty) {
          return ListView.builder(
            itemCount: provider.entries.length,
            itemBuilder: (context, index) {
              final entry = provider.entries[index];
              final project = projectTaskProvider.projects.firstWhere(
                (proj) => proj.id == entry.projectId,
              );
              final task = projectTaskProvider.tasks.firstWhere(
                (task) => task.id == entry.taskId,
              );
              final projectName = project.name;
              final taskName = task.name;
              return ListTile(
                title: Text('$projectName - $taskName '),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total time: ${entry.totalTime} hours'),
                    Text('Date: ${entry.date.toString()}'),
                    Text('Notes: ${entry.notes}'),
                  ],
                ),
                trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      //pass
                    },
                  ),
                onTap: () {
                  // Open a detailed view or edit screen
                },
              );
            },
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hourglass_empty, size: 40, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  'No time entries yet!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Tap the + button to add a new time entry.'),
              ],
            ),
          );
        }
      },
    );
  }
}

/// Tab that groups time entries by project
class GroupedByProjectTab extends StatelessWidget {
  const GroupedByProjectTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<TimeEntryProvider, ProjectTaskProvider>(
      builder: (context, provider, projectTaskProvider, child) {
        // Group the entries by project id
        final Map<String, List<TimeEntry>> groupedEntries = {};
        for (var entry in provider.entries) {
          groupedEntries.putIfAbsent(entry.projectId, () => []).add(entry);
        }

        if (groupedEntries.isNotEmpty) {
          return ListView(
            children: groupedEntries.entries.map((group) {
              final projectId = group.key;
              final entries = group.value;
                            
              final project = projectTaskProvider.projects.firstWhere(
                (proj) => proj.id == projectId,
              );

              final projectName = project.name;
              
              return ExpansionTile(
                title: Text(projectName),
                children: entries.map((entry) {
                  final task = projectTaskProvider.tasks.firstWhere(
                    (task) => task.id == entry.taskId,
                  );
                  final taskName = task.name;
                  return ListTile(
                    title: Text('$taskName: ${entry.totalTime} hours (${entry.date.toString()})'),
                    onTap: () {
                      // Open details or edit screen
                    },
                  );
                }).toList(),
              );
            }).toList(),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hourglass_empty, size: 40, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  'No time entries yet!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Tap the + button to add a new time entry.'),
              ],
            ),
          );
        }
      },
    );
  }
}
