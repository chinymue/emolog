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
import '../utils/user_info_helper.dart';

class UserInfo extends StatefulWidget {
  UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> with UserInfoControllers {
  final _formKey = GlobalKey<FormState>();
  LanguageAvailable? _selectedLanguage;
  ThemeStyle? _selectedTheme;
  bool _initializedFromUser = false;

  @override
  void initState() {
    super.initState();
    initControllers(setState, mounted);
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
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
      initFormFromUser(
        user,
        controllers,
        (lang) => _selectedLanguage = lang,
        (theme) => _selectedTheme = theme,
      );
    }
    final changed = hasChanges(
      user,
      controllers,
      _selectedLanguage,
      _selectedTheme,
    );
    final l10n = AppLocalizations.of(context)!;

    return FormWrapper(
      formKey: _formKey,
      children: [
        UsernameRow(),
        UserFields(ctrls: controllers),
        PreferencesFields(
          selectedLanguage: _selectedLanguage,
          selectedTheme: _selectedTheme,
          onLangChanged: (value) {
            if (value != null) {
              context.read<LanguageProvider>().setLang(value);
            }
            setState(() => _selectedLanguage = value);
          },
          onThemeChanged: (value) {
            if (value != null) {
              context.read<ThemeProvider>().setTheme(value);
            }
            setState(() => _selectedTheme = value);
          },
        ),
        ActionButtons(
          changed: changed,
          onSave: () async {
            await handleSave(
              c,
              _formKey,
              controllers,
              _selectedLanguage,
              _selectedTheme,
              user,
              () {
                if (mounted) {
                  setState(() {});
                }
              },
              () {
                if (mounted) {
                  setState(() {
                    _initializedFromUser = false;
                  });
                }
              },
            );
          },
          onLogout: () => handleLogout(c),
          saveLabel: l10n.saveChanges,
        ),
      ],
    );
  }
}

mixin UserInfoControllers<T extends StatefulWidget> on State<T> {
  late final TextEditingController passwordCtrl;
  late final TextEditingController fullnameCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController avatarCtrl;

  List<TextEditingController> get controllers => [
    passwordCtrl,
    fullnameCtrl,
    emailCtrl,
    avatarCtrl,
  ];

  void initControllers(Function(void Function()) setState, bool mounted) {
    passwordCtrl = TextEditingController();
    fullnameCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    avatarCtrl = TextEditingController();

    setupListeners(controllers, mounted, setState);
  }

  void disposeControllers() {
    for (final ctrl in controllers) {
      ctrl.dispose();
    }
  }
}

class UsernameRow extends StatelessWidget {
  const UsernameRow({super.key});

  @override
  Widget build(BuildContext c) {
    final l10n = AppLocalizations.of(c)!;
    final colorScheme = Theme.of(c).colorScheme;
    final textTheme = Theme.of(c).textTheme;
    final username = c.select<UserProvider, String>(
      (provider) => provider.user?.username ?? '',
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.username,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.tertiary),
          ),
          Text(
            username,
            style: textTheme.labelLarge?.copyWith(color: colorScheme.tertiary),
          ),
        ],
      ),
    );
  }
}

class UserFields extends StatelessWidget {
  final List<TextEditingController> ctrls;

  const UserFields({super.key, required this.ctrls});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        buildTextField(context, label: l10n.password, controller: ctrls[0]),
        buildTextField(context, label: l10n.fullname, controller: ctrls[1]),
        buildTextField(
          context,
          label: l10n.email,
          controller: ctrls[2],
          isValidator: false,
        ),
        buildTextField(
          context,
          label: l10n.avatarUrl,
          controller: ctrls[3],
          isValidator: false,
        ),
      ],
    );
  }
}

class PreferencesFields extends StatelessWidget {
  final LanguageAvailable? selectedLanguage;
  final ThemeStyle? selectedTheme;
  final ValueChanged<LanguageAvailable?> onLangChanged;
  final ValueChanged<ThemeStyle?> onThemeChanged;

  const PreferencesFields({
    super.key,
    required this.selectedLanguage,
    required this.selectedTheme,
    required this.onLangChanged,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        buildDropdownField<LanguageAvailable>(
          label: l10n.language,
          value: selectedLanguage,
          values: LanguageAvailable.values,
          onChanged: onLangChanged,
        ),
        buildDropdownField<ThemeStyle>(
          label: l10n.theme,
          value: selectedTheme,
          values: ThemeStyle.values,
          onChanged: onThemeChanged,
        ),
      ],
    );
  }
}

class ActionButtons extends StatelessWidget {
  final bool changed;
  final VoidCallback onSave;
  final VoidCallback onLogout;
  final String saveLabel;

  const ActionButtons({
    super.key,
    required this.changed,
    required this.onSave,
    required this.onLogout,
    required this.saveLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: changed ? onSave : null,
            child: Text(saveLabel),
          ),
          SizedBox(width: kPaddingLarge),
          ElevatedButton(onPressed: onLogout, child: const Text('logout')),
        ],
      ),
    );
  }
}
