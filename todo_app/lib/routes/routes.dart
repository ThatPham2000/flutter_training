import 'package:flutter/material.dart';
import 'package:todo_app/add_todo_page.dart';
import 'package:todo_app/edit_todo_page.dart';
import 'package:todo_app/home_page.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/unknown_page.dart';

class AppRoutes {
  static Route<dynamic>? onGenerateAppRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (context) => const HomePage(title: 'Todo List'));
      case AddTodoPage.routeName:
        return MaterialPageRoute(builder: (context) => const AddTodoPage());
      case EditTodoPage.routeName:
        final todo = settings.arguments as Todo;
        return MaterialPageRoute(
          builder: (context) => EditTodoPage(todo: todo),
        );
    }
    return MaterialPageRoute(builder: (ctx) => const UnknownPage());
  }
}
