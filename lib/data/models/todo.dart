// To parse this JSON data, do
//
//     final todo = todoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'todo.freezed.dart';
part 'todo.g.dart';

Todo todoFromJson(String str) => Todo.fromJson(json.decode(str));

String todoToJson(Todo data) => json.encode(data.toJson());

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String todo,
    required bool completed,
    required int userId,
    @Default(false) bool isDeleted,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
