import 'package:flutter/material.dart';
import 'package:emolog/export/decor_utils.dart';

Widget buildTextField({
  required String label,
  required TextEditingController controller,
  String? Function(String?)? validator,
}) {
  return SizedBox(
    width: kFormMaxWidth,
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator:
          validator ??
          (value) =>
              (value == null || value.isEmpty) ? "Không được để trống" : null,
    ),
  );
}

Widget buildDropdownField<T>({
  required String label,
  required T? value,
  required List<T> values,
  required void Function(T?) onChanged,
  String? Function(T?)? validator,
}) {
  return SizedBox(
    width: kFormMaxWidth,
    child: DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: values
          .map(
            (v) => DropdownMenuItem<T>(
              value: v,
              child: Text(v.toString().split('.').last),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator:
          validator ?? (val) => val == null ? "Không được để trống" : null,
    ),
  );
}
