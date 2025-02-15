import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';


part 'todo.g.dart';

@JsonSerializable()
class Todo extends Equatable {
  Todo( {
    String? id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.dueDate,
    this.reminderTime,

  })  : assert(id == null || id.isNotEmpty, 'id must either be null or not empty'),
        id = id ?? const Uuid().v4();

  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? dueDate;
  final DateTime? reminderTime;


  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    DateTime? reminderTime,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }


  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  @override
  List<Object?> get props => [id, title, description, isCompleted,dueDate,reminderTime];
}
