import 'package:blood_bank/ui/inputs/custom_inputs.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTimeField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  final String text;
  final Function onChanged;

  CustomDateTimeField({super.key, required this.text, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DateTimeField(
        decoration: CustomInputs.loginInputDecoration(
            hint: "", label: text, icon: Icons.calendar_month_outlined),
        format: format,
        style: TextStyle(color: Colors.white),
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(
                  currentValue ?? DateTime.now().toLocal()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
        onChanged: (value) => onChanged(value),
      ),
    ]);
  }
}
