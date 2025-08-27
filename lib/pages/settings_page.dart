import 'package:emolog/isar/model/user.dart';
import 'package:emolog/l10n/app_localizations.dart';
import 'package:emolog/provider/user_pvd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/scaffold_template.dart';
import '../widgets/user_info.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Key _formKeyReset = UniqueKey();
  bool dbscreen = false;

  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().fetchAllUsers();
  }

  @override
  Widget build(BuildContext c) {
    final userPvd = c.read<UserProvider>();
    final userList = c.select<UserProvider, List<User>>(
      (provider) => provider.userList,
    );
    final l10n = AppLocalizations.of(context)!;
    return MainScaffold(
      currentIndex: 2,
      actions: [
        if (dbscreen)
          IconButton(
            onPressed: () async {
              userPvd.setGuestAccount();
              await userPvd.addUser();
              await userPvd.fetchAllUsers();
              setState(() => _formKeyReset = UniqueKey());
            },
            icon: Icon(Icons.add_box),
          ),
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
      ],
      child: dbscreen
          ? SizedBox(
              height: 700,
              width: 500,
              child: ListView.builder(
                itemCount: userList.length,
                itemBuilder: (c, i) {
                  final user = userList[i];
                  return ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Placeholder()),
                    ),
                    title: Text(user.username),
                    subtitle: Text(user.id.toString()),
                  );
                },
              ),
            )
          : UserInfo(key: _formKeyReset, userId: 1),
    );
  }
}
