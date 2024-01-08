import 'package:bloc/bloc.dart';
import 'package:todo_app_bloc/data/models/todo.dart';
import 'package:todo_app_bloc/data/repository/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;
  TodoBloc(this.todoRepository) : super(TodoInitial()) {
    on<GetTodos>(getTodos);
    on<AddTodo>(addTodo);
    on<DeleteTodo>(deleteTodo);
    on<UpdateTodo>(updateTodo);
  }

  int todosLength = 0;

  void getTodos(GetTodos event, Emitter emit) async {
    emit(TodoLoading());

    try {
      final todoLocal = await todoRepository.getTodoLocal();

      // final List<Todo> todo = todoLocal.where((element) => !element.isDeleted).toList();

      if (todoLocal != null) {
        todosLength = todoLocal.length;
        emit(TodoLoaded(todos: todoLocal));
      }
    } catch (e) {
      emit(TodoFailed(error: e.toString()));
    }
  }

  void addTodo(AddTodo event, Emitter emit) async {
    emit(TodoLoading());

    try {
      await todoRepository.addTodo(todo: event.todo);

      final List<Todo>? todoLocal = await todoRepository.getTodoLocal();
      if (todoLocal != null) {
        todosLength = todoLocal.length;
        emit(TodoLoaded(todos: todoLocal));
      }
    } catch (e) {
      emit(TodoFailed(error: e.toString()));
    }
  }

  void deleteTodo(DeleteTodo event, Emitter emit) async {
    try {
      await todoRepository.deleteTodo(id: event.id);
      final List<Todo>? todoLocal = await todoRepository.getTodoLocal();

      if (todoLocal != null) {
        todosLength = todoLocal.length;
        emit(TodoLoaded(todos: todoLocal));
      }
    } catch (e) {
      emit(TodoFailed(error: e.toString()));
    }
  }

  void updateTodo(UpdateTodo event, Emitter emit) async {
    try {
      await todoRepository.updateTodo(todo: event.todo);
      final List<Todo>? todoLocal = await todoRepository.getTodoLocal();

      if (todoLocal != null) {
        todosLength = todoLocal.length;
        emit(TodoLoaded(todos: todoLocal));
      }
    } catch (e) {
      emit(TodoFailed(error: e.toString()));
    }
  }
}
