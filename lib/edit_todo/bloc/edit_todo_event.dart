part of 'edit_todo_bloc.dart';

//import 'package:equatable/equatable.dart';

sealed class EditTodoEvent extends Equatable {
  const EditTodoEvent();

  @override
  List<Object> get props => [];
}

final class EditTodoTitleChanged extends EditTodoEvent {
  const EditTodoTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

final class EditTodoDescriptionChanged extends EditTodoEvent {
  const EditTodoDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

final class EditTodoSubmitted extends EditTodoEvent {
  const EditTodoSubmitted();
}

// Добавляем событие для изменения даты завершения
final class EditTodoSetCompletionDate extends EditTodoEvent {
  const EditTodoSetCompletionDate(this.completionDate);

  final DateTime completionDate;

  @override
  List<Object> get props => [completionDate];
}

// Добавляем событие для изменения даты напоминания
final class EditTodoSetReminderDate extends EditTodoEvent {
  const EditTodoSetReminderDate(this.reminderDate);

  final DateTime reminderDate;

  @override
  List<Object> get props => [reminderDate];
}