import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project.dart';
import '../providers/project_task_provider.dart';

class AddProjectDialog extends StatefulWidget {
  const AddProjectDialog({super.key});

  @override
  _AddProjectDialogState createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  String projectName = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Project'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Project Name'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a project name';
            }
            return null;
          },
          onSaved: (value) {
            projectName = value!.trim();
          },
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: Text('Add'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              // Create a new project using a simple id.
              final newProject = Project(
                id: DateTime.now().toString(),
                name: projectName,
              );
              Provider.of<ProjectTaskProvider>(context, listen: false)
                  .addProject(newProject);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
