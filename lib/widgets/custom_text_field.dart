import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  const CustomTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  });
  final String label;
  final String? initialValue;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
