import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_pvd.dart';
import '../l10n/app_localizations.dart';
import '../isar/model/user.dart';

void setupListeners(
  List<TextEditingController> ctrls,
  bool mounted,
  void Function(VoidCallback fn) setState,
) {
  for (final ctrl in ctrls) {
    ctrl.addListener(() {
      if (mounted) setState(() {});
    });
  }
}

void initFormFromUser(
  User user,
  List<TextEditingController> ctrls,
  void Function(dynamic) setLang,
  void Function(dynamic) setTheme,
) {
  ctrls[0].text = '********';
  ctrls[1].text = user.fullName ?? '';
  ctrls[2].text = user.email ?? '';
  ctrls[3].text = user.avatarUrl;
  setLang(user.language);
  setTheme(user.theme);
}

bool hasChanges(
  User user,
  List<TextEditingController> ctrls,
  dynamic lang,
  dynamic theme,
) {
  if (ctrls[0].text != '********') return true;
  if (ctrls[1].text != (user.fullName ?? '')) return true;
  if (ctrls[2].text != (user.email ?? '')) return true;
  if (ctrls[3].text != user.avatarUrl) return true;
  if (lang != user.language) return true;
  if (theme != user.theme) return true;
  return false;
}

Future<void> handleSave(
  BuildContext c,
  GlobalKey<FormState> formKey,
  List<TextEditingController> ctrls,
  dynamic lang,
  dynamic theme,
  User user,
  VoidCallback onSaving,
  VoidCallback onDone,
) async {
  final l10n = AppLocalizations.of(c)!;
  if (!formKey.currentState!.validate()) {
    ScaffoldMessenger.of(
      c,
    ).showSnackBar(SnackBar(content: Text(l10n.saveChangesNotVaid)));
    return;
  }

  onSaving();

  try {
    final rawPass = ctrls[0].text;
    final newPass = (rawPass == '********' || rawPass.trim().isEmpty)
        ? null
        : rawPass; // hash at update function in user_pvd.dart

    await c.read<UserProvider>().updateUser(
      newPass: newPass,
      newFullname: ctrls[1].text.trim(),
      newEmail: ctrls[2].text.trim(),
      newURL: ctrls[3].text.trim(),
      newLanguage: lang ?? user.language,
      newTheme: theme ?? user.theme,
    );
    if (!c.mounted) return;
    ScaffoldMessenger.of(
      c,
    ).showSnackBar(SnackBar(content: Text(l10n.saveSuccess)));
  } catch (_) {
    ScaffoldMessenger.of(
      c,
    ).showSnackBar(SnackBar(content: Text(l10n.saveFailed)));
  } finally {
    onDone();
  }
}

Future<void> handleLogout(BuildContext c) async {
  c.read<UserProvider>().logout(c);
  Navigator.pushReplacementNamed(c, '/login');
}
