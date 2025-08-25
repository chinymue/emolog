import 'package:emolog/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:emolog/export/decor_utils.dart';

/// Validator mặc định cho text field
FormFieldValidator<String> defaultTextValidator(BuildContext context) {
  return (String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.validEmpty;
    }
    return null;
  };
}

Widget buildTextField(
  BuildContext context, {
  required String label,
  required TextEditingController controller,
  String? Function(String?)? validator,
}) {
  return SizedBox(
    width: kFormMaxWidth,
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: validator ?? defaultTextValidator(context),
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
      validator: validator,
    ),
  );
}
