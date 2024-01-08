import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_bloc/data/repository/todo_repository.dart';
import 'package:todo_app_bloc/presentation/bloc/todo/todo_bloc.dart';
import 'package:todo_app_bloc/presentation/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TodoRepository(),
      child: BlocProvider(
        create: (context) => TodoBloc(RepositoryProvider.of<TodoRepository>(context))..add(GetTodos()),
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
  }
}
