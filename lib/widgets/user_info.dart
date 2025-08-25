import 'package:emolog/export/decor_utils.dart';
import 'package:emolog/isar/model/user.dart';
import 'package:emolog/l10n/app_localizations.dart';
import 'package:emolog/provider/lang_pvd.dart';
import 'package:emolog/provider/user_pvd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/default_form.dart';
import '../enum/lang.dart';
import '../enum/theme_style.dart';

class UserInfo extends StatefulWidget {
  UserInfo({super.key, required this.userId});
  final int userId;

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _passwordCtrl;
  late final TextEditingController _fullnameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _avatarCtrl;

  // dropdown selections
  LanguageAvailable? _selectedLanguage;
  ThemeStyle? _selectedTheme;

  // state flags
  bool _initializedFromUser = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _usernameCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _fullnameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _avatarCtrl = TextEditingController();

    _setupListeners();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) =>
          context.read<UserProvider>().loadUser(context, userId: widget.userId),
    );
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _fullnameCtrl.dispose();
    _emailCtrl.dispose();
    _avatarCtrl.dispose();
    super.dispose();
  }

  /// Lắng nghe thay đổi của các TextEditingController để trigger rebuild
  void _setupListeners() {
    for (final ctrl in [
      _usernameCtrl,
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
    if (_usernameCtrl.text != (user.username)) return true;
    if (_passwordCtrl.text != (user.password)) return true;
    if (_fullnameCtrl.text != (user.fullName ?? '')) return true;
    if (_emailCtrl.text != (user.email ?? '')) return true;
    if (_avatarCtrl.text != (user.avatarUrl)) return true;
    if (_selectedLanguage != (user.language)) return true;
    if (_selectedTheme != (user.theme)) return true;
    return false;
  }

  Future<void> _handleSave(User user, bool isChangeLanguage) async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.saveChangesNotVaid)));
      return;
    }

    setState(() => _isSaving = true);

    final newUsername = _usernameCtrl.text.trim();
    final newPass = _passwordCtrl.text;
    final newFullname = _fullnameCtrl.text.trim();
    final newEmail = _emailCtrl.text.trim();
    final newAvatar = _avatarCtrl.text.trim();
    final newLang = _selectedLanguage ?? user.language;
    final newTheme = _selectedTheme ?? user.theme;

    try {
      await context.read<UserProvider>().updateUser(
        newUsername: newUsername,
        newPass: newPass,
        newFullname: newFullname,
        newEmail: newEmail,
        newURL: newAvatar,
        newLanguage: newLang,
        newTheme: newTheme,
      );
      context.read<LanguageProvider>().setLang(newLang);

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
      _usernameCtrl.text = user.username;
      _passwordCtrl.text = user.password;
      _fullnameCtrl.text = user.fullName ?? '';
      _emailCtrl.text = user.email ?? '';
      _avatarCtrl.text = user.avatarUrl;
      _selectedLanguage = user.language;
      _selectedTheme = user.theme;
    }

    final changed = _hasChanges(user);

    final currentLang = c.watch<LanguageProvider>().currentLang;
    final l10n = AppLocalizations.of(context)!;
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
                FloatingActionButton(
                  tooltip: l10n.changeLanguage,
                  child: Icon(Icons.language),
                  onPressed: () {
                    c.read<LanguageProvider>().setLang(
                      currentLang == LanguageAvailable.en
                          ? LanguageAvailable.vi
                          : LanguageAvailable.en,
                    );
                  },
                ),
                buildTextField(
                  context,
                  label: l10n.username,
                  controller: _usernameCtrl,
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
                ),
                buildTextField(
                  context,
                  label: l10n.avatarUrl,
                  controller: _avatarCtrl,
                ),
                buildDropdownField<LanguageAvailable>(
                  label: l10n.language,
                  value: _selectedLanguage,
                  values: LanguageAvailable.values,
                  onChanged: (value) =>
                      setState(() => _selectedLanguage = value),
                ),
                buildDropdownField<ThemeStyle>(
                  label: l10n.theme,
                  value: _selectedTheme,
                  values: ThemeStyle.values,
                  onChanged: (value) => setState(() => _selectedTheme = value),
                ),
                SizedBox(height: kPaddingLarge),
                ElevatedButton(
                  onPressed: (!_isSaving && changed)
                      ? () =>
                            _handleSave(user, _selectedLanguage != currentLang)
                      : null,
                  child: Text(l10n.saveChanges),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
