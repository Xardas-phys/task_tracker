import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project.dart';
import '../models/task.dart';
import '../providers/project_task_provider.dart';
import '../dialogs/add_project_dialog.dart'; // Import the separate dialog file
import '../dialogs/add_task_dialog.dart';

class ProjectTaskManagementScreen extends StatefulWidget {
  final bool initialShowProjects;

  const ProjectTaskManagementScreen({super.key, this.initialShowProjects = true});

  @override
  _ProjectTaskManagementScreenState createState() =>
      _ProjectTaskManagementScreenState();
}

class _ProjectTaskManagementScreenState
    extends State<ProjectTaskManagementScreen> {
  // When true, show projects; when false, show tasks.
  bool showProjects = true;

  @override
  void initState() {
    super.initState();
    // Set the state based on the passed parameter.
    showProjects = widget.initialShowProjects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: showProjects ? Text('Manage Projects') : Text('Manage Tasks'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ProjectTaskProvider>(
              builder: (context, provider, child) {
                if (showProjects) {
                  // Display list of projects.
                  if (provider.projects.isNotEmpty) {
                    return ListView.builder(
                      itemCount: provider.projects.length,
                      itemBuilder: (context, index) {
                        final Project project = provider.projects[index];
                        return Card(
                          child: ListTile(
                            title: Text(project.name),
                            subtitle: Text('ID: ${project.id}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                provider.deleteProject(project.id);
                              },
                            ),
                            onTap: () {
                              // Handle project tap (e.g., navigate to details or edit).
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No projects available.'));
                  }
                } else {
                  // Display list of tasks.
                  if (provider.tasks.isNotEmpty) {
                    return ListView.builder(
                      itemCount: provider.tasks.length,
                      itemBuilder: (context, index) {
                        final Task task = provider.tasks[index];
                        return Card(
                          child: ListTile(
                            title: Text(task.name),
                            subtitle: Text('ID: ${task.id}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                provider.deleteTask(task.id);
                              },
                            ),
                            onTap: () {
                              // Handle task tap (e.g., navigate to details or edit).
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No tasks available.'));
                  }
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Launch the appropriate dialog based on showProjects.
          if (showProjects) {
            showDialog(
              context: context,
              builder: (_) => const AddProjectDialog(),
            );
          } else {
            showDialog(
              context: context,
              builder: (_) => const AddTaskDialog(),
            );
          }
        },
        tooltip: showProjects ? 'Add Project' : 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
