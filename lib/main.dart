import 'package:emolog/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:emolog/pages/login_page.dart';
import 'package:emolog/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emolog/isar/isar_service.dart';
import 'package:emolog/provider/lang_pvd.dart';
import 'package:emolog/provider/theme_pvd.dart';
import './provider/log_pvd.dart';
import './provider/log_view_pvd.dart';
import './provider/user_pvd.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_localizations/flutter_localizations.dart';
import './pages/home_page.dart';
import './pages/history_page.dart';
import './pages/settings_page.dart';
import './l10n/app_localizations.dart';
import './utils/color_utils.dart';
import './utils/constant.dart';
import './utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final isarService = IsarService();
  final userPvd = UserProvider(isarService);
  // await userPvd.syncAllUsersToFirestore(); // Debug only
  runApp(
    MultiProvider(
      providers: [
        Provider<IsarService>.value(value: isarService),
        ChangeNotifierProvider(
          create: (c) => LogProvider(c.read<IsarService>()),
        ),
        ChangeNotifierProvider<UserProvider>.value(value: userPvd),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext c) {
    return Consumer2<LanguageProvider, ThemeProvider>(
      builder: (c, lang, theme, _) {
        return MaterialApp(
          onGenerateTitle: (c) => AppLocalizations.of(c)!.appTitle,
          themeMode: theme.themeMode,
          theme: buildAppTheme(follyRed),
          darkTheme: buildAppTheme(follyRed, isLight: false),
          initialRoute: '/login',
          routes: {
            '/login': (_) => LoginPage(),
            '/register': (_) => RegisterPage(),
            pages[0]['route']: (_) => HomePage(),
            pages[1]['route']: (_) => ChangeNotifierProvider(
              create: (c) => LogViewProvider(),
              child: HistoryPage(),
            ),
            pages[2]['route']: (_) => SettingsPage(),
          },
          locale: lang.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            ...AppLocalizations.localizationsDelegates,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            quill.FlutterQuillLocalizations.delegate,
          ],
        );
      },
    );
  }
}
