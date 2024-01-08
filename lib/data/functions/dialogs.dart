import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_bloc/presentation/bloc/todo/todo_bloc.dart';

class DialogService {
  void addUpdateDialog(
    context, {
    required TextEditingController controller,
    required Function() onPressed,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Note"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter a task",
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                onPressed();
              },
              child: const Text("Save"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.clear();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void deleteDialog(
    BuildContext context, {
    required int id,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text("Are you sure you want to delete?"),
          actions: [
            TextButton(
              onPressed: () {
                context.read<TodoBloc>().add(DeleteTodo(id: id));
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
