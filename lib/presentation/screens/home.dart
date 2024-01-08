import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_bloc/data/functions/dialogs.dart';
import 'package:todo_app_bloc/data/models/todo.dart';
import 'package:todo_app_bloc/presentation/bloc/todo/todo_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController task = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    task.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove("myListKey");
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TodoBloc todoBloc = BlocProvider.of<TodoBloc>(context);
    final DialogService dialog = DialogService();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Todo App"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialog.addUpdateDialog(
            context,
            controller: task,
            onPressed: () {
              final Todo todo = Todo(
                todo: task.text,
                completed: false,
                userId: todoBloc.todosLength + 1,
              );
              context.read<TodoBloc>().add(AddTodo(todo: todo));
              task.clear();
              Navigator.of(context).pop();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoFailed) {
            return Center(
              child: Text("Error: ${state.error}"),
            );
          }

          if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return const Center(
                child: Text("No task today"),
              );
            }
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final Todo todo = state.todos[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          todo.todo,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            decoration: todo.completed ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Icon(todo.completed ? Icons.check_box : Icons.check_box_outline_blank),
                      IconButton(
                        onPressed: () {
                          dialog.deleteDialog(
                            scaffoldKey.currentContext!,
                            id: todo.userId,
                          );
                        },
                        icon: const Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: () {
                          dialog.addUpdateDialog(
                            context,
                            controller: TextEditingController(text: todo.todo),
                            onPressed: () {
                              context.read<TodoBloc>().add(UpdateTodo(todo: todo));
                              task.clear();
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
