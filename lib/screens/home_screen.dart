import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';
import 'add_time_entry_screen.dart';

class HomeScreen extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isNotEmpty) {
          return ListView.builder(
            itemCount: provider.entries.length,
            itemBuilder: (context, index) {
              final entry = provider.entries[index];
              return ListTile(
                title: Text('${entry.projectId} - ${entry.totalTime} hours'),
                subtitle: Text('${entry.date.toString()} - Notes: ${entry.notes}'),
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
  @override
  Widget build(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
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
              return ExpansionTile(
                title: Text(projectId),
                children: entries.map((entry) {
                  return ListTile(
                    title: Text('${entry.totalTime} hours'),
                    subtitle: Text('${entry.date.toString()} - Notes: ${entry.notes}'),
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
