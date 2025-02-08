part of 'edit_todo_bloc.dart';

enum EditTodoStatus { initial, loading, success, failure }

extension EditTodoStatusX on EditTodoStatus {
  bool get isLoadingOrSuccess => [
    EditTodoStatus.loading,
    EditTodoStatus.success,
  ].contains(this);
}

final class EditTodoState extends Equatable {
  const EditTodoState( {
    this.status = EditTodoStatus.initial,
    this.initialTodo,
    this.title = '',
    this.description = '',
    this.completionDate,
    this.reminderDate,
  });

  final EditTodoStatus status;
  final Todo? initialTodo;
  final String title;
  final String description;
  final DateTime? completionDate;
  final DateTime? reminderDate;


  bool get isNewTodo => initialTodo == null;

  EditTodoState copyWith({
    EditTodoStatus? status,
    Todo? initialTodo,
    String? title,
    String? description,
    DateTime? completionDate,
    DateTime? reminderDate,
  }) {
    return EditTodoState(
      status: status ?? this.status,
      initialTodo: initialTodo ?? this.initialTodo,
      title: title ?? this.title,
      description: description ?? this.description,
      completionDate: completionDate ?? this.completionDate,
      reminderDate: reminderDate ?? this.reminderDate,
    );
  }

  @override
  List<Object?> get props => [status, initialTodo, title, description,completionDate,reminderDate];
}