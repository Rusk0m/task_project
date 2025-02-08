import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:todos_api/src/models/todo/todo.dart' show Todo;

part 'edit_todo_event.dart';
part 'edit_todo_state.dart';

class EditTodoBloc extends Bloc<EditTodoEvent, EditTodoState> {
  EditTodoBloc({
    required TodosRepository todosRepository,
    required Todo? initialTodo,
  })  : _todosRepository = todosRepository,
        super(
        EditTodoState(
          initialTodo: initialTodo,
          title: initialTodo?.title ?? '',
          description: initialTodo?.description ?? '',
          completionDate: initialTodo?.dueDate,
        ),
      ) {
    on<EditTodoTitleChanged>(_onTitleChanged);
    on<EditTodoDescriptionChanged>(_onDescriptionChanged);
    on<EditTodoSubmitted>(_onSubmitted);
    on<EditTodoSetCompletionDate>(_onSetCompletionDate);
    on<EditTodoSetReminderDate>(_onSetReminderDate);
  }

  final TodosRepository _todosRepository;

  void _onTitleChanged(EditTodoTitleChanged event, Emitter<EditTodoState> emit) {
    emit(state.copyWith(title: event.title));
  }

  void _onDescriptionChanged(EditTodoDescriptionChanged event, Emitter<EditTodoState> emit) {
    emit(state.copyWith(description: event.description));
  }

  Future<void> _onSubmitted(EditTodoSubmitted event, Emitter<EditTodoState> emit) async {
    emit(state.copyWith(status: EditTodoStatus.loading));
    final todo = (state.initialTodo ?? Todo(title: '')).copyWith(
      title: state.title,
      description: state.description,
      dueDate: state.completionDate,
      reminderTime: state.reminderDate,
    );

    try {
      await _todosRepository.saveTodo(todo);
      emit(state.copyWith(status: EditTodoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditTodoStatus.failure));
    }
  }

  // Обработчик для события EditTodoSetCompletionDate
  void _onSetCompletionDate(
      EditTodoSetCompletionDate event,
      Emitter<EditTodoState> emit,
      ) {
    emit(state.copyWith(completionDate: event.completionDate));
  }

  // Обработчик для события EditTodoSetReminderDate
  void _onSetReminderDate(
      EditTodoSetReminderDate event,
      Emitter<EditTodoState> emit,
      ) {
    // Проверяем, что reminderDate не может быть позже completionDate
    if (state.completionDate != null && event.reminderDate.isAfter(state.completionDate!)) {
      emit(state.copyWith(reminderDate: null));  // Мы можем сбросить reminderDate, если условие нарушено
      // Можно добавить уведомление пользователю или обработать ошибку
    } else {
      emit(state.copyWith(reminderDate: event.reminderDate));
    }
  }
}
