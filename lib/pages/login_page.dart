import 'package:emolog/provider/user_pvd.dart';
import 'package:emolog/widgets/form_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emolog/l10n/app_localizations.dart';
import '../utils/constant.dart';
import 'package:emolog/widgets/scaffold_template.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    return DefaultScaffold(title: "Login", child: LoginForm());
  }
}

class LoginForm extends StatefulWidget {
  final String redirect;
  const LoginForm({super.key, this.redirect = '/'});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String? _error;

  Future<void> _handleLogin(BuildContext c) async {
    final userPvd = c.read<UserProvider>();
    final ok = await userPvd.login(
      c,
      username: _usernameCtrl.text,
      password: _passwordCtrl.text,
    );
    if (ok) {
      if (!c.mounted) return;
      Navigator.pushReplacementNamed(c, widget.redirect);
    } else {
      setState(() => _error = "Invalid username or password");
    }
  }

  Future<void> _handleLoginAsGuest(BuildContext c) async {
    final userPvd = c.read<UserProvider>();
    final ok = await userPvd.loginAsGuest(c);
    if (ok) {
      if (!c.mounted) return;
      Navigator.pushReplacementNamed(c, widget.redirect);
    } else {
      setState(
        () => _error = "Can't login as guest. Please contact developer team!",
      );
    }
  }

  @override
  Widget build(BuildContext c) {
    final l10n = AppLocalizations.of(c)!;
    // TODO: add toggle change language
    // TODO: add remember me checkbox & this feature
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
                  onPressed: () => _handleLogin(c),
                  child: Text("Login"),
                ),
                SizedBox(height: kPadding),
                ElevatedButton(
                  onPressed: () => _handleLoginAsGuest(c),
                  child: Text("Continue as guest"),
                ),
                SizedBox(height: kPadding),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(c, '/register'),
                  child: Text("Create new account"),
                ),
                SizedBox(height: kPaddingSmall),
                Text(
                  "Don't have an account yet?",
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
