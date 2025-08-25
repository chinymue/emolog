import 'package:emolog/isar/isar_service.dart';
import 'package:emolog/provider/lang_pvd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/log_pvd.dart';
import './provider/log_view_pvd.dart';
import './provider/user_pvd.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_localizations/flutter_localizations.dart';
import './utils/color_utils.dart';
import './utils/constant.dart';
import './utils/theme.dart';
import './pages/home_page.dart';
import './pages/history_page.dart';
import './pages/settings_page.dart';
import './l10n/app_localizations.dart';
import './enum/lang.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext c) {
    return MultiProvider(
      providers: [
        Provider<IsarService>(create: (_) => IsarService()),
        ChangeNotifierProvider(
          create: (c) => LogProvider(c.read<IsarService>()),
        ),
        ChangeNotifierProvider(
          create: (c) => UserProvider(c.read<IsarService>()),
        ),
        ChangeNotifierProvider(
          create: (c) => LanguageProvider(LanguageAvailable.en),
        ),
      ],
      child: Consumer<LanguageProvider>(
        builder: (c, lang, _) {
          return MaterialApp(
            onGenerateTitle: (c) => AppLocalizations.of(c)!.appTitle,
            theme: buildAppTheme(follyRed),
            initialRoute: pages[0]['route'],
            routes: {
              pages[0]['route']: (c) => HomePage(),
              pages[1]['route']: (c) => ChangeNotifierProvider(
                create: (c) => LogViewProvider(),
                child: HistoryPage(),
              ),
              pages[2]['route']: (c) => SettingsPage(),
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
      ),
    );
  }
}
