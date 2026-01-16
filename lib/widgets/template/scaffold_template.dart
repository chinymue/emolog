import 'package:flutter/material.dart';
import '../../utils/constant.dart';
import '../../l10n/app_localizations.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

String localizedLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'pageHome':
      return l10n.pageHome;
    case 'pageLog':
      return "Mood Logs";
    case 'pageRelax':
      return "Relax";
    case 'pageStats':
      return "Statistics";
    case 'pageSettings':
      return l10n.pageSettings;
    default:
      return key;
  }
}

// Scaffold with bottom navigation bar -----------------------------
class MainScaffold extends StatelessWidget {
  final int currentIndex;
  final Widget child;
  final List<Widget>? actions;

  const MainScaffold({
    required this.currentIndex,
    required this.child,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext c) {
    final l10n = AppLocalizations.of(c)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizedLabel(l10n, pages[currentIndex]['label']),
          style: Theme.of(c).textTheme.headlineLarge?.copyWith(
            color: Theme.of(c).colorScheme.primary,
          ),
        ),
        actions: actions == null
            ? null
            : [
                Padding(
                  padding: const EdgeInsets.only(right: kPaddingSmall),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!,
                  ),
                ),
              ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => Navigator.pushReplacementNamed(c, pages[i]['route']),
        items: [
          for (var i in pages)
            BottomNavigationBarItem(
              backgroundColor: Theme.of(c).colorScheme.primary,
              icon: Icon(i['icon']),
              label: localizedLabel(l10n, i['label']),
            ),
        ],
      ),
    );
  }
}

// Scaffold without bottom navigation bar -----------------------------
class DefaultScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;

  const DefaultScaffold({
    required this.title,
    required this.child,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          title,
          style: Theme.of(c).textTheme.headlineLarge?.copyWith(
            color: Theme.of(c).colorScheme.primary,
          ),
        ),
        actions: actions == null
            ? null
            : [
                Padding(
                  padding: const EdgeInsets.only(right: kPaddingSmall),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!,
                  ),
                ),
              ],
      ),
      body: child,
    );
  }
}
