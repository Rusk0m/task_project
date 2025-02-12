import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextFieldWithDatePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;  // Параметр для текущей выбранной даты
  final Function(DateTime) onDateSelected;

  const TextFieldWithDatePicker({super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(), // Если нет выбранной даты, показываем сегодняшнюю
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (picked != null) {
          onDateSelected(picked);  // Обрабатываем выбранную дату
        }
      },
      child: AbsorbPointer(  // Запрещает редактирование в TextField, но позволяет его нажимать
        child: TextField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : label,
          ),
        ),
      ),
    );
  }
}


