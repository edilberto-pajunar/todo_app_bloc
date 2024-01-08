part of 'todo_bloc.dart';

sealed class TodoEvent {}

class GetTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;

  AddTodo({
    required this.todo,
  });
}

class EditTodo extends TodoEvent {}

class UpdateTodo extends TodoEvent {
  final Todo todo;

  UpdateTodo({
    required this.todo,
  });
}

class DeleteTodo extends TodoEvent {
  final int id;

  DeleteTodo({
    required this.id,
  });
}
