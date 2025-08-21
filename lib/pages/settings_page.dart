import 'package:emolog/export/decor_utils.dart';
import 'package:emolog/isar/model/user.dart';
import 'package:emolog/provider/user_pvd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/default_scaffold.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Key _formKeyReset = UniqueKey();
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
    return MainScaffold(
      currentIndex: 2,
      actions: [
        if (dbscreen)
          IconButton(
            onPressed: () async {
              userPvd.setGuestAccount();
              await userPvd.addUser();
              await userPvd.fetchAllUsers();
              // setState(() => _formKeyReset = UniqueKey());
            },
            icon: Icon(Icons.add_box),
          ),
        IconButton(
          onPressed: () {
            userPvd.resetGuest();
            // setState(() => _formKeyReset = UniqueKey());
          },
          icon: Icon(Icons.disabled_by_default),
          tooltip: "Thiết lập lại tài khoản",
        ),
        IconButton(
          onPressed: () {
            userPvd.resetSetting();
            // setState(() => _formKeyReset = UniqueKey());
          },
          icon: Icon(Icons.restore),
          tooltip: "Thiết lập lại cài đặt",
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
          : UserInfo(userId: 1),
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

  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().loadUser(userId: widget.userId);
  }

  late String? _newUsername;

  late String? _newPass;

  late String? _newFullname;

  late String? _newEmail;

  late String? _newURL;

  late LanguageAvailable? _newLanguage;

  late ThemeStyle? _newTheme;

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
    final isFetched = c.select<UserProvider, bool>(
      (provider) => provider.isFetchedUser,
    );
    if (!isFetched) {
      return const Center(child: CircularProgressIndicator());
    } else {
      final user = c.select<UserProvider, User>((provider) => provider.user!);
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
                        SizedBox(
                          width: kFormMaxWidth,
                          child: TextFormField(
                            // key: ValueKey(user.username),
                            initialValue: user.username,
                            decoration: const InputDecoration(
                              labelText: "Username",
                            ),
                            onSaved: (value) => _newUsername = value,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? "Không được để trống"
                                : null,
                          ),
                        ),
                        SizedBox(
                          width: kFormMaxWidth,
                          child: TextFormField(
                            // key: ValueKey(user.password),
                            initialValue: user.password,
                            decoration: const InputDecoration(
                              labelText: "Password",
                            ),
                            onSaved: (value) => _newPass = value,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? "Không được để trống"
                                : null,
                          ),
                        ),
                        SizedBox(
                          width: kFormMaxWidth,
                          child: TextFormField(
                            // key: ValueKey(user.fullName),
                            initialValue: user.fullName ?? "-",
                            decoration: const InputDecoration(
                              labelText: "Fullname",
                            ),
                            onSaved: (value) => _newFullname = value,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? "Không được để trống"
                                : null,
                          ),
                        ),
                        SizedBox(
                          width: kFormMaxWidth,
                          child: TextFormField(
                            // key: ValueKey(user.email),
                            initialValue: user.email ?? "-",
                            decoration: const InputDecoration(
                              labelText: "Email",
                            ),
                            onSaved: (value) => _newEmail = value,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? "Không được để trống"
                                : null,
                          ),
                        ),
                        SizedBox(
                          width: kFormMaxWidth,
                          child: TextFormField(
                            // key: ValueKey(user.avatarUrl),
                            initialValue: user.avatarUrl != ""
                                ? user.avatarUrl
                                : "-",
                            decoration: const InputDecoration(
                              labelText: "Avatar URL",
                            ),
                            onSaved: (value) => _newURL = value,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? "Không được để trống"
                                : null,
                          ),
                        ),
                        SizedBox(
                          width: kFormMaxWidth,
                          child: DropdownButtonFormField<LanguageAvailable>(
                            // key: ValueKey(user.language),
                            value: user.language,
                            decoration: const InputDecoration(
                              labelText: "language",
                            ),
                            items: LanguageAvailable.values.map((lang) {
                              return DropdownMenuItem(
                                value: lang,
                                child: Text(lang.toString().split('.').last),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _newLanguage = value);
                              }
                            },
                            onSaved: (value) => _newLanguage = value,
                            validator: (value) =>
                                (value == null) ? "Không được để trống" : null,
                          ),
                        ),
                        SizedBox(
                          width: kFormMaxWidth,
                          child: DropdownButtonFormField<ThemeStyle>(
                            value: user.theme,
                            decoration: const InputDecoration(
                              labelText: "theme",
                            ),
                            items: ThemeStyle.values.map((ts) {
                              return DropdownMenuItem(
                                value: ts,
                                child: Text(ts.toString().split('.').last),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _newTheme = value);
                              }
                            },
                            onSaved: (value) => _newTheme = value,
                            validator: (value) =>
                                (value == null) ? "Không được để trống" : null,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _handleSave(c),
                          icon: Icon(Icons.save),
                          tooltip: "Lưu thay đổi",
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
}
