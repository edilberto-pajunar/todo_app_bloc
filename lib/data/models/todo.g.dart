// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoImpl _$$TodoImplFromJson(Map<String, dynamic> json) => _$TodoImpl(
      todo: json['todo'] as String,
      completed: json['completed'] as bool,
      userId: json['userId'] as int,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$TodoImplToJson(_$TodoImpl instance) =>
    <String, dynamic>{
      'todo': instance.todo,
      'completed': instance.completed,
      'userId': instance.userId,
      'isDeleted': instance.isDeleted,
    };
