import 'package:emolog/utils/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constant.dart';
import 'package:emolog/isar/model/user.dart';
import 'package:emolog/l10n/app_localizations.dart';
import 'package:emolog/provider/user_pvd.dart';
import 'package:emolog/provider/lang_pvd.dart';
import 'package:emolog/provider/theme_pvd.dart';
import 'form_template.dart';
import '../enum/lang.dart';
import '../enum/theme_style.dart';

class UserInfo extends StatefulWidget {
  UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _passwordCtrl;
  late final TextEditingController _fullnameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _avatarCtrl;

  LanguageAvailable? _selectedLanguage;
  ThemeStyle? _selectedTheme;

  bool _initializedFromUser = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _passwordCtrl = TextEditingController();
    _fullnameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _avatarCtrl = TextEditingController();

    _setupListeners();
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _fullnameCtrl.dispose();
    _emailCtrl.dispose();
    _avatarCtrl.dispose();
    super.dispose();
  }

  void _setupListeners() {
    for (final ctrl in [
      _passwordCtrl,
      _fullnameCtrl,
      _emailCtrl,
      _avatarCtrl,
    ]) {
      ctrl.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  bool _hasChanges(User user) {
    if (_passwordCtrl.text != kPasswordPlaceholder) return true;
    if (_fullnameCtrl.text != (user.fullName ?? '')) return true;
    if (_emailCtrl.text != (user.email ?? '')) return true;
    if (_avatarCtrl.text != (user.avatarUrl)) return true;
    if (_selectedLanguage != (user.language)) return true;
    if (_selectedTheme != (user.theme)) return true;
    return false;
  }

  Future<void> _handleSave(User user) async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.saveChangesNotVaid)));
      return;
    }

    setState(() => _isSaving = true);

    final rawPass = _passwordCtrl.text;
    final String? newPass =
        (rawPass == kPasswordPlaceholder || rawPass.trim().isEmpty)
        ? null
        : rawPass;
    final newFullname = _fullnameCtrl.text.trim();
    final newEmail = _emailCtrl.text.trim();
    final newAvatar = _avatarCtrl.text.trim();
    final newLang = _selectedLanguage ?? user.language;
    final newTheme = _selectedTheme ?? user.theme;

    try {
      await context.read<UserProvider>().updateUser(
        newPass: newPass,
        newFullname: newFullname,
        newEmail: newEmail,
        newURL: newAvatar,
        newLanguage: newLang,
        newTheme: newTheme,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.saveSuccess)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.saveFailed)));
      print(e);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _handleLogout(BuildContext c) async {
    final user = c.read<UserProvider>().user;
    if (user!.username == 'guest') {
      c.read<UserProvider>().resetGuest(c, isLogout: true);
    }
    c.read<UserProvider>().logout(c);
    Navigator.pushReplacementNamed(c, '/login');
  }

  @override
  Widget build(BuildContext c) {
    final isFetched = c.select<UserProvider, bool>(
      (provider) => provider.isFetchedUser,
    );
    if (!isFetched) {
      return const Center(child: CircularProgressIndicator());
    }
    final user = c.select<UserProvider, User>((provider) => provider.user!);

    if (!_initializedFromUser) {
      _initializedFromUser = true;
      _passwordCtrl.text = kPasswordPlaceholder;
      _fullnameCtrl.text = user.fullName ?? '';
      _emailCtrl.text = user.email ?? '';
      _avatarCtrl.text = user.avatarUrl;
      _selectedLanguage = user.language;
      _selectedTheme = user.theme;
    }

    final changed = _hasChanges(user);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(c).colorScheme;
    final textTheme = Theme.of(c).textTheme;
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
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.username,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.tertiary,
                        ),
                      ),
                      Text(
                        user.username,
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                buildTextField(
                  context,
                  label: l10n.password,
                  controller: _passwordCtrl,
                ),
                buildTextField(
                  context,
                  label: l10n.fullname,
                  controller: _fullnameCtrl,
                ),
                buildTextField(
                  context,
                  label: l10n.email,
                  controller: _emailCtrl,
                  isValidator: false,
                ),
                buildTextField(
                  context,
                  label: l10n.avatarUrl,
                  controller: _avatarCtrl,
                  isValidator: false,
                ),
                buildDropdownField<LanguageAvailable>(
                  label: l10n.language,
                  value: _selectedLanguage,
                  values: LanguageAvailable.values,
                  onChanged: (value) {
                    if (value != null) {
                      c.read<LanguageProvider>().setLang(value);
                    }
                    setState(() => _selectedLanguage = value);
                  },
                ),
                buildDropdownField<ThemeStyle>(
                  label: l10n.theme,
                  value: _selectedTheme,
                  values: ThemeStyle.values,
                  onChanged: (value) {
                    if (value != null) {
                      c.read<ThemeProvider>().setTheme(value);
                    }
                    setState(() => _selectedTheme = value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: (!_isSaving && changed)
                            ? () => _handleSave(user)
                            : null,
                        child: Text(l10n.saveChanges),
                      ),
                      SizedBox(width: kPaddingLarge),
                      ElevatedButton(
                        onPressed: () => _handleLogout(c),
                        child: Text('logout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
