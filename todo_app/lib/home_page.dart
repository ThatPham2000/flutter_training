import 'package:flutter/material.dart';
import 'package:todo_app/add_todo_page.dart';
import 'package:todo_app/edit_todo_page.dart';
import 'package:todo_app/models/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _todos = <Todo>[];
  final _searchController = TextEditingController();

  @override
  void initState() {
    _todos.addAll(List.generate(5, (index) {
      return Todo(
        id: '$index',
        title: 'Todo ${index + 1}',
        deadline: DateTime.now().add(Duration(days: index)),
        description:
            'This is a description for this task ${index + 1}, you can edit it if you feel it is not correct',
        isComplete: index % 4 == 0,
      );
    }));
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showTodos =
        _todos.where((e) => e.title.contains(_searchController.text)).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _searchController,
              decoration: const InputDecoration(labelText: 'Search title'),
              onChanged: (value) {
                setState(() {});
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: showTodos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(showTodos[index].title),
                    subtitle: showTodos[index].description == null
                        ? null
                        : Text(
                            '${showTodos[index].description!}\n${showTodos[index].deadline}'),
                    leading: Checkbox(
                      value: showTodos[index].isComplete,
                      onChanged: null,
                    ),
                    trailing: Tooltip(
                      message: 'Delete',
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _todos.removeWhere(
                                (e) => e.id == showTodos[index].id);
                          });
                        },
                      ),
                    ),
                    onTap: () async {
                      final newTodo = await Navigator.of(context).pushNamed(
                          EditTodoPage.routeName,
                          arguments: showTodos[index]);
                      newTodo as Todo?;
                      if (newTodo != null) {
                        setState(() {
                          _todos[_todos.indexWhere(
                              (e) => e.id == showTodos[index].id)] = newTodo;
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTodo =
              await Navigator.of(context).pushNamed(AddTodoPage.routeName);
          newTodo as Todo?;
          if (newTodo != null) {
            setState(() => _todos.add(newTodo));
          }
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
