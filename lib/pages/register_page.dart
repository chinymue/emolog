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

  Future<void> _handleRegister(BuildContext c) async {
    final userPvd = c.read<UserProvider>();
    final ok = await userPvd.register(_usernameCtrl.text, _passwordCtrl.text);
    if (ok) {
      if (!c.mounted) return;
      Navigator.pushReplacementNamed(c, '/');
    } else {
      setState(() => _error = "This username has been used");
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
