import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/project_task_provider.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  String taskName = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Task Name'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a task name';
            }
            return null;
          },
          onSaved: (value) {
            taskName = value!.trim();
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
              // Create a new task using a simple id.
              final newTask = Task(
                id: DateTime.now().toString(),
                name: taskName,
              );
              Provider.of<ProjectTaskProvider>(context, listen: false)
                  .addTask(newTask);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
