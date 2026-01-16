import 'package:emolog/l10n/app_localizations.dart';
import 'package:emolog/pages/login_page.dart';
import 'package:emolog/provider/user_pvd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/template/scaffold_template.dart';
import '../widgets/user_info.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Key _formKeyReset = UniqueKey();

  @override
  Widget build(BuildContext c) {
    final userPvd = c.read<UserProvider>();
    final l10n = AppLocalizations.of(context)!;
    return MainScaffold(
      currentIndex: 4,
      actions: [
        IconButton(
          onPressed: () {
            userPvd.resetGuest(c);
            setState(() => _formKeyReset = UniqueKey());
          },
          icon: Icon(Icons.disabled_by_default),
          tooltip: l10n.restoreAcc,
        ),
        IconButton(
          onPressed: () {
            userPvd.resetSetting(c);
            setState(() => _formKeyReset = UniqueKey());
          },
          icon: Icon(Icons.restore),
          tooltip: l10n.restoreSettings,
        ),
        IconButton(
          onPressed: () {
            userPvd.deleteAllUsers();
            setState(() => _formKeyReset = UniqueKey());
          },
          icon: Icon(Icons.dangerous),
          tooltip: "Xóa toàn bộ người dùng trong cơ sở dữ liệu",
        ),
      ],
      child: userPvd.user == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You haven\'t login yet',
                  style: Theme.of(c).textTheme.labelLarge?.copyWith(
                    color: Theme.of(c).colorScheme.error,
                  ),
                ),
                LoginForm(redirect: '/settings'),
              ],
            )
          : UserInfo(key: _formKeyReset),
    );
  }
}
