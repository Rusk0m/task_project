import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_project/screens/edit_todo/bloc/edit_todo_bloc.dart';

class TextFieldWithDateTimePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDateTime; // Теперь хранит дату и время
  final Function(DateTime) onDateTimeSelected;

  const TextFieldWithDateTimePicker({
    super.key,
    required this.label,
    required this.selectedDateTime,
    required this.onDateTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // 1. Выбор даты
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDateTime ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );

        if (pickedDate == null) return;

        // 2. Выбор времени
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: selectedDateTime != null
              ? TimeOfDay.fromDateTime(selectedDateTime!)
              : TimeOfDay.now(),
        );

        if (pickedTime == null) return;

        // 3. Объединение даты и времени
        final combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        onDateTimeSelected(combinedDateTime);
      },
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: label,
            labelText: selectedDateTime != null
                ? DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!)
                : label,
          ),
        ),
      ),
    );
  }
}