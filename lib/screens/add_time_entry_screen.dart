import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';
import '../providers/project_task_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key});

  @override
  AddTimeEntryScreenState createState() => AddTimeEntryScreenState();
}

class AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? projectId;
  String? taskId;
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';

  // Controller for the date field.
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the date field with the current date.
    _dateController.text = "${date.toLocal()}".split(' ')[0];
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve projects and tasks from the provider.
    final projectTaskProvider = Provider.of<ProjectTaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Time Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Project Dropdown
              DropdownButtonFormField<String>(
                value: projectId,
                onChanged: (String? newValue) {
                  setState(() {
                    projectId = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a project' : null,
                decoration: const InputDecoration(labelText: 'Project'),
                items: projectTaskProvider.projects.map((project) {
                  return DropdownMenuItem<String>(
                    value: project.id,
                    child: Text(project.name),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Task Dropdown
              DropdownButtonFormField<String>(
                value: taskId,
                onChanged: (String? newValue) {
                  setState(() {
                    taskId = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a task' : null,
                decoration: const InputDecoration(labelText: 'Task'),
                items: projectTaskProvider.tasks.map((task) {
                  return DropdownMenuItem<String>(
                    value: task.id,
                    child: Text(task.name),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Date Picker Field
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null && pickedDate != date) {
                    setState(() {
                      date = pickedDate;
                      // Update the text in the date field.
                      _dateController.text =
                          "${date.toLocal()}".split(' ')[0];
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(labelText: 'Date'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Total Time Text Field
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Total Time (hours)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter total time';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => totalTime = double.parse(value!),
              ),
              const SizedBox(height: 16),
              // Notes Text Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Notes'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some notes';
                  }
                  return null;
                },
                onSaved: (value) => notes = value!,
              ),
              const SizedBox(height: 24),
              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Provider.of<TimeEntryProvider>(context, listen: false)
                        .addTimeEntry(
                      TimeEntry(
                        id: DateTime.now().toString(), // Simple ID generation.
                        projectId: projectId!,
                        taskId: taskId!,
                        totalTime: totalTime,
                        date: date,
                        notes: notes,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
