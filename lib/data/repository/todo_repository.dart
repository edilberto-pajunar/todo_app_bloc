import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_bloc/core/strings/api.dart';
import 'package:todo_app_bloc/data/models/todo.dart';

class TodoRepository {
  Future<List<Todo>> getTodos() async {
    final Uri uri = Uri.https(TodoApp.baseUrl, "/todos/user/1");
    final SharedPreferences sp = await SharedPreferences.getInstance();
    debugPrint("Calling: $uri");

    try {
      final res = await http.get(uri).then((response) async {
        debugPrint("Response: ${response.body}");
        if (response.statusCode == 200) {
          final List result = jsonDecode(response.body)["todos"];

          final todos = result.map((data) => Todo.fromJson(data)).toList();

          final List<Todo>? todosLocal = await getTodoLocal();

          if (sp.getString("myListKey") == null) {
            await sp.setString("myListKey", jsonEncode(result));
          }

          return todos;
        } else {
          throw "Something went wrong";
        }
      });

      return res;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> addTodo({
    required Todo todo,
  }) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? todoLocal = sp.getString("myListKey");

    if (todoLocal == null) {
      final List<Todo> todos = [];
      todos.add(todo);

      await sp.setString("myListKey", jsonEncode(todos));
    } else {
      final List decoded = jsonDecode(todoLocal);

      // read all the list
      final List<Todo> todos = (decoded).map((data) => Todo.fromJson(data)).toList();

      // add todo locally
      todos.add(todo);

      await sp.setString("myListKey", jsonEncode(todos));
    }
  }

  Future<List<Todo>?> getTodoLocal() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? todoJson = sp.getString("myListKey");

    debugPrint("Local Todos: $todoJson");

    if (todoJson != null) {
      final List jsonDecoded = jsonDecode(todoJson);

      return (jsonDecoded).map((e) => Todo.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<void> deleteTodo({
    required int id,
  }) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? todoJson = sp.getString("myListKey");

    if (todoJson != null) {
      final List jsonDecoded = jsonDecode(todoJson);

      final List<Todo> todos = (jsonDecoded).map((e) => Todo.fromJson(e)).toList();

      todos.removeAt(id - 1);

      await sp.setString("myListKey", jsonEncode(todos));
    }
  }

  Future<void> updateTodo({
    required Todo todo,
  }) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? todoJson = sp.getString("myListKey");

    if (todoJson != null) {
      final List jsonDecoded = jsonDecode(todoJson);

      final List<Todo> todos = (jsonDecoded).map((e) => Todo.fromJson(e)).toList();

      for (int i = 0; i < todos.length; i++) {
        print('Checking userId: ${todo.userId} vs ${todos[i].userId}');
        if (todo.userId == todos[i].userId) {
          todos[i] = todos[i].copyWith(
            todo: todo.todo,
          );

          print('Updated todo at index $i: ${todos[i]}');
        }
      }

      await sp.setString("myListKey", jsonEncode(todos));
    }
  }
}
