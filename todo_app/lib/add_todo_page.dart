import 'package:flutter/material.dart';
import 'package:todo_app/utils/extension.dart';
import 'package:todo_app/models/todo.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  static const routeName = '/add-todo';

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();
  DateTime? _deadline;
  bool _isComplete = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Todo'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) => value.isNullOrEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            InkWell(
              onFocusChange: (hasFocus) async {
                if (hasFocus) {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date == null) return;
                  _deadline = date;
                  _deadlineController.text = date.toString();
                }
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: TextFormField(
                controller: _deadlineController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Deadline'),
                validator: (value) => value.isNullOrEmpty ? 'Required' : null,
              ),
            ),
            Row(
              children: [
                const Text('isComplete: '),
                Switch(
                  value: _isComplete,
                  onChanged: (value) => setState(() => _isComplete = value),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).pop(
                    Todo(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      title: _titleController.text,
                      description: _descriptionController.text,
                      deadline: _deadline!,
                      isComplete: _isComplete,
                    ),
                  );
                }
              },
              child: const Text('Add Todo'),
            ),
          ],
        ),
      ),
    );
  }
}
