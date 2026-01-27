import 'package:emolog/provider/user_pvd.dart';
import 'package:emolog/widgets/template/form_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emolog/l10n/app_localizations.dart';
import '../utils/constant.dart';
import 'package:emolog/widgets/template/scaffold_template.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    return DefaultScaffold(title: "Register", child: RegisterForm());
  }
}

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String? _error;

  Future<bool> _showDisclaimerDialog(BuildContext c) async {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;

    return await showDialog<bool>(
          context: c,
          barrierDismissible: false, // không cho bấm ra ngoài
          builder: (_) => AlertDialog(
            icon: const Icon(Icons.warning),
            title: Text(
              "Disclaimer",
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            content: Text(
              "This app couldn't be use to cure / fix health problem. Only using to reflect and relaxing",
              style: textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(c, true),
                child: const Text("Accepted"),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _handleRegister(BuildContext c) async {
    if (_usernameCtrl.text.length < 6 || _passwordCtrl.text.length < 6) {
      setState(
        () => _error =
            "Username and password must be at least 6 characters long!",
      );
      return;
    }
    final isAccepted = await _showDisclaimerDialog(c);
    if (!isAccepted) {
      setState(
        () => _error = "Can't use this app without accept the disclaimer!",
      );
      return;
    }
    if (!c.mounted) return;
    final userPvd = c.read<UserProvider>();
    final result = await userPvd.register(
      _usernameCtrl.text,
      _passwordCtrl.text,
    );
    if (result == "registered") {
      if (!c.mounted) return;
      Navigator.pushReplacementNamed(c, '/');
    } else if (result == "username") {
      setState(() => _error = "This username is used!");
    } else if (result == "length") {
      setState(
        () => _error =
            "Username and password must be at least 6 characters long!",
      );
    } else {
      setState(
        () => _error =
            "An unusual error has occured. Please contact developement team!",
      );
    }
  }

  @override
  Widget build(BuildContext c) {
    final l10n = AppLocalizations.of(c)!;
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
                if (_error != null)
                  Text(
                    _error!,
                    style: TextStyle(color: Theme.of(c).colorScheme.error),
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
                SizedBox(height: kPaddingLarge),
                ElevatedButton(
                  onPressed: () => _handleRegister(c),
                  child: Text("Register"),
                ),
                SizedBox(height: kPadding),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(c, '/login'),
                  child: Text("Login"),
                ),
                SizedBox(height: kPaddingSmall),
                Text(
                  "Already had an account?",
                  style: TextStyle(color: Theme.of(c).colorScheme.tertiary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
