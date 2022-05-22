import 'package:blood_bank/ui/inputs/custom_inputs.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class CustomDateInput extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd");
  final String text;
  final Function onChanged;

  CustomDateInput({super.key, required this.text, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DateTimeField(
        decoration: CustomInputs.loginInputDecoration(
            hint: "", label: text, icon: Icons.calendar_month_outlined),
        format: format,
        style: TextStyle(color: Colors.white),
        onChanged: (value) => onChanged(value),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(2022),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      ),
    ]);
  }
}
