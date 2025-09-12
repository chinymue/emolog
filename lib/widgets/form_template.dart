import 'package:emolog/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../utils/constant.dart';

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
  bool isValidator = true,
}) {
  return SizedBox(
    width: kFormMaxWidth,
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: isValidator
          ? (validator ?? defaultTextValidator(context))
          : null,
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

class FormWrapper extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;

  const FormWrapper({super.key, required this.formKey, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: kPaddingLarge,
        right: kPaddingLarge,
        top: kPadding,
        bottom: kPadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: kFormMaxWidth + 2 * kPaddingLarge,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
