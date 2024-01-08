part of 'todo_bloc.dart';

sealed class TodoState {}

final class TodoInitial extends TodoState {}

final class TodoLoading extends TodoState {}

final class TodoLoaded extends TodoState {
  final List<Todo> todos;

  TodoLoaded({
    required this.todos,
  });
}

final class TodoFailed extends TodoState {
  final String error;

  TodoFailed({
    required this.error,
  });
}
