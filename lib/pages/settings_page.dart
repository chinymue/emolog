import 'package:emolog/export/decor_utils.dart';
import 'package:emolog/isar/model/user.dart';
import 'package:emolog/provider/user_pvd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/default_scaffold.dart';
import '../widgets/default_form.dart';

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
            userPvd.resetGuest();
            setState(() => _formKeyReset = UniqueKey());
          },
          icon: Icon(Icons.disabled_by_default),
          tooltip: "Thiết lập lại tài khoản",
        ),
        IconButton(
          onPressed: () {
            userPvd.resetSetting();
            setState(() => _formKeyReset = UniqueKey());
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
          : UserInfo(key: _formKeyReset, userId: 1),
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
  bool _initializedFromUser = false; // ensure we init controllers once
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _usernameCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _fullnameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _avatarCtrl = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<UserProvider>().loadUser(userId: widget.userId),
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

  Future<void> _handleSave(User user) async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Không lưu được thay đổi")));
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

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Lưu thay đổi thành công")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lưu thất bại: $e")));
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
                buildTextField(label: "Username", controller: _usernameCtrl),
                buildTextField(label: "Password", controller: _passwordCtrl),
                buildTextField(label: "Fullname", controller: _fullnameCtrl),
                buildTextField(label: "Email", controller: _emailCtrl),
                buildTextField(label: "AvatarURL", controller: _avatarCtrl),
                buildDropdownField<LanguageAvailable>(
                  label: "Language",
                  value: _selectedLanguage,
                  values: LanguageAvailable.values,
                  onChanged: (value) =>
                      setState(() => _selectedLanguage = value),
                ),
                buildDropdownField<ThemeStyle>(
                  label: "Theme",
                  value: _selectedTheme,
                  values: ThemeStyle.values,
                  onChanged: (value) => setState(() => _selectedTheme = value),
                ),
                SizedBox(height: kPaddingLarge),
                ElevatedButton(
                  onPressed: (!_isSaving && changed)
                      ? () => _handleSave(user)
                      : null,
                  child: Text("Lưu thay đổi"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
