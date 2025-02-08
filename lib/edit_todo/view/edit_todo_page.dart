import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todos_repository/todos_repository.dart';
import "package:todos_api/src/models/todo/todo.dart" show Todo;
import '../bloc/edit_todo_bloc.dart';
import '../widgets/text_field_with_date_picker.dart';

class EditTodoPage extends StatelessWidget {
  const EditTodoPage({super.key});

  static Route<void> route({Todo? initialTodo}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditTodoBloc(
          todosRepository: context.read<TodosRepository>(),
          initialTodo: initialTodo,
        ),
        child: const EditTodoPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTodoBloc, EditTodoState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditTodoStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditTodoView(),
    );
  }
}

class EditTodoView extends StatelessWidget {
  const EditTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final status = context.select((EditTodoBloc bloc) => bloc.state.status);
    final isNewTodo = context.select((EditTodoBloc bloc) => bloc.state.isNewTodo,);
    //DateTime? reminderTime;


    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewTodo
              ? l10n!.editTodoAddAppBarTitle
              : l10n!.editTodoEditAppBarTitle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.editTodoSaveButtonTooltip,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context.read<EditTodoBloc>().add(const EditTodoSubmitted()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _TitleField(),
                _DescriptionField(),
                _TextFieldWithDatePicker()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.title ?? '';

    return TextFormField(
      key: const Key('editTodoView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n!.editTodoTitleLabel,
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      onChanged: (value) {
        context.read<EditTodoBloc>().add(EditTodoTitleChanged(value));
      },
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.description ?? '';

    return TextFormField(
      key: const Key('editTodoView_description_textFormField'),
      initialValue: state.description,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n!.editTodoDescriptionLabel,
        hintText: hintText,
      ),
      maxLength: 300,
      minLines: 1,
      maxLines: null,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        context.read<EditTodoBloc>().add(EditTodoDescriptionChanged(value));
      },
    );
  }
}

class _TextFieldWithDatePicker extends StatelessWidget {
  const _TextFieldWithDatePicker();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditTodoBloc>().state;
    final l10n = AppLocalizations.of(context);

    return TextFieldWithDatePicker(

      label: 'Completion Date',
      selectedDate: state.completionDate, // Передаем дату из состояния блока
      onDateSelected: (selectedDate) {
        context
            .read<EditTodoBloc>()
            .add(EditTodoSetCompletionDate(selectedDate));
      },
    );
  }
}
/*

class _TextFieldWithDatePicker extends StatelessWidget {
  const _TextFieldWithDatePicker();


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<EditTodoBloc>().state;

    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Время напоминания',
        suffixIcon: IconButton(
          icon: Icon(Icons.access_time),
          onPressed: () => _selectReminderTime(context),
        ),
      ),
      controller: TextEditingController(
        text: reminderTime != null
            ? DateFormat('HH:mm').format(reminderTime!)
            : '',
      ),
    );
  }
}

Future<void> _selectReminderTime(BuildContext context) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (pickedTime == null) return;

  // Объединить с текущей датой
  final now = DateTime.now();
  reminderTime = DateTime(
    now.year,
    now.month,
    now.day,
    pickedTime.hour,
    pickedTime.minute,
  );
}
*/
