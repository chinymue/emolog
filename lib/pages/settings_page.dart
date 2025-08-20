import 'package:emolog/export/decor_utils.dart';
import 'package:emolog/provider/user_pvd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/default_scaffold.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Key _formKeyReset = UniqueKey();

  @override
  Widget build(BuildContext c) {
    return MainScaffold(
      currentIndex: 2,
      actions: [
        IconButton(
          onPressed: () {
            c.read<UserProvider>().resetGuest();
            setState(() => _formKeyReset = UniqueKey());
          },
          icon: Icon(Icons.disabled_by_default),
          tooltip: "Thiết lập lại tài khoản",
        ),
        IconButton(
          onPressed: () {
            c.read<UserProvider>().resetSetting();
            setState(() => _formKeyReset = UniqueKey());
          },
          icon: Icon(Icons.restore),
          tooltip: "Thiết lập lại cài đặt",
        ),
      ],
      child: UserInfo(key: _formKeyReset, userId: 0),
    );
  }
}

class UserInfo extends StatefulWidget {
  UserInfo({super.key, required this.userId});
  final int userId;

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _formKey = GlobalKey<FormState>();

  late String? _newUsername;

  late String? _newPass;

  late String? _newFullname;

  late String? _newEmail;

  late String? _newURL;

  late String? _newLanguage;

  late String? _newTheme;

  void _handleSave(BuildContext c) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      c.read<UserProvider>().updateUser(
        newUsername: _newUsername,
        newPass: _newPass,
        newFullname: _newFullname,
        newEmail: _newEmail,
        newURL: _newURL,
        newLanguage: _newLanguage,
        newTheme: _newTheme,
      );
      ScaffoldMessenger.of(
        c,
      ).showSnackBar(const SnackBar(content: Text("Lưu thay đổi thành công")));
    } else {
      ScaffoldMessenger.of(
        c,
      ).showSnackBar(const SnackBar(content: Text("Không lưu được thay đổi")));
    }
  }

  @override
  Widget build(BuildContext c) {
    final user = c.watch<UserProvider>().user;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(kPadding),
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () => _handleSave(c),
                        icon: Icon(Icons.save),
                        tooltip: "Lưu thay đổi",
                      ),
                      SizedBox(
                        width: kFormMaxWidth,
                        child: TextFormField(
                          key: ValueKey(user.username),
                          initialValue: user.username,
                          decoration: const InputDecoration(
                            labelText: "Username",
                          ),
                          onSaved: (value) => _newUsername = value,
                          validator: (value) => (value == null || value.isEmpty)
                              ? "Không được để trống"
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: kFormMaxWidth,
                        child: TextFormField(
                          key: ValueKey(user.password),
                          initialValue: user.password,
                          decoration: const InputDecoration(
                            labelText: "Password",
                          ),
                          onSaved: (value) => _newPass = value,
                          validator: (value) => (value == null || value.isEmpty)
                              ? "Không được để trống"
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: kFormMaxWidth,
                        child: TextFormField(
                          key: ValueKey(user.fullName),
                          initialValue: user.fullName ?? "-",
                          decoration: const InputDecoration(
                            labelText: "Fullname",
                          ),
                          onSaved: (value) => _newFullname = value,
                          validator: (value) => (value == null || value.isEmpty)
                              ? "Không được để trống"
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: kFormMaxWidth,
                        child: TextFormField(
                          key: ValueKey(user.email),
                          initialValue: user.email ?? "-",
                          decoration: const InputDecoration(labelText: "Email"),
                          onSaved: (value) => _newEmail = value,
                          validator: (value) => (value == null || value.isEmpty)
                              ? "Không được để trống"
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: kFormMaxWidth,
                        child: TextFormField(
                          key: ValueKey(user.avatarUrl),
                          initialValue: user.avatarUrl != ""
                              ? user.avatarUrl
                              : "-",
                          decoration: const InputDecoration(
                            labelText: "Avatar URL",
                          ),
                          onSaved: (value) => _newURL = value,
                          validator: (value) => (value == null || value.isEmpty)
                              ? "Không được để trống"
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: kFormMaxWidth,
                        child: TextFormField(
                          key: ValueKey(user.language),
                          initialValue: user.language,
                          decoration: const InputDecoration(
                            labelText: "language",
                          ),
                          onSaved: (value) => _newLanguage = value,
                          validator: (value) => (value == null || value.isEmpty)
                              ? "Không được để trống"
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: kFormMaxWidth,
                        child: TextFormField(
                          key: ValueKey(user.theme),
                          initialValue: user.theme,
                          decoration: const InputDecoration(labelText: "Theme"),
                          onSaved: (value) => _newTheme = value,
                          validator: (value) => (value == null || value.isEmpty)
                              ? "Không được để trống"
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
