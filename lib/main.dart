import 'package:emolog/isar/isar_service.dart';

import 'export/package/app_essential.dart';
import 'export/provider/main_essential.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_localizations/flutter_localizations.dart';
import './export/theme_essential.dart';
import 'export/pages.dart';

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
      ],
      child: MaterialApp(
        title: 'Emolog',
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
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          quill.FlutterQuillLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('vi')],
      ),
    );
  }
}
