import 'package:blood_bank/ui/inputs/custom_inputs.dart';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';

class CustomSelectInput extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String text;
  final Function onChanged;
  final IconData icon;

  const CustomSelectInput({
    super.key,
    required this.items,
    required this.text,
    required this.onChanged,
    this.icon = Icons.bloodtype_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return SelectFormField(
      type: SelectFormFieldType.dropdown,
      icon: Icon(Icons.bloodtype_outlined),
      labelText: text,
      style: TextStyle(color: Colors.white),
      items: items,
      decoration: CustomInputs.loginInputDecoration(
        hint: "",
        label: text,
        icon: icon,
      ),
      onChanged: (val) => onChanged(val),
    );
  }
}
