import 'package:flutter/material.dart';
import 'package:todo_app/utils/extension.dart';
import 'package:todo_app/models/todo.dart';

class EditTodoPage extends StatefulWidget {
  const EditTodoPage({super.key, required this.todo});

  static const routeName = '/edit-todo';
  final Todo todo;

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();
  DateTime? _deadline;
  bool _isComplete = false;

  @override
  void initState() {
    _titleController.text = widget.todo.title;
    _descriptionController.text = widget.todo.description ?? '';
    _deadlineController.text = widget.todo.deadline.toString();
    _deadline = widget.todo.deadline;
    _isComplete = widget.todo.isComplete;

    super.initState();
  }

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
        title: const Text('Edit Todo'),
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
                      id: widget.todo.id,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      deadline: _deadline!,
                      isComplete: _isComplete,
                    ),
                  );
                }
              },
              child: const Text('Edit Todo'),
            ),
          ],
        ),
      ),
    );
  }
}
