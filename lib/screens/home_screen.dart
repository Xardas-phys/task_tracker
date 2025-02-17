import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';

import 'time_entry_screen.dart';
import 'project_task_management_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
      ),
      body: Column (

        children: [
            Text('first line'),
            Expanded(
                child: Consumer<TimeEntryProvider>(
                    builder: (context, provider, child) {
                        if (provider.entries.length > 0) {
                            return ListView.builder(
                                itemCount: provider.entries.length,
                                itemBuilder: (context, index) {
                                final entry = provider.entries[index];
                                return ListTile(
                                    title: Text('${entry.projectId} - ${entry.totalTime} hours'),
                                    subtitle: Text('${entry.date.toString()} - Notes: ${entry.notes}'),
                                    onTap: () {
                                    // This could open a detailed view or edit screen
                                    },
                                );
                                },
                            );
                        }
                        else {
                            return Container( 
                                child:Text('No time entries yet!'),
                            );
                        }
                    },
                ),
            ),
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
        child: Icon(Icons.add),
        tooltip: 'Add Time Entry',
      ),
    );
  }
}