import 'package:emolog/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Message greeting
class HelloLog extends StatelessWidget {
  const HelloLog({super.key});

  @override
  Widget build(BuildContext c) => Text(
    AppLocalizations.of(c)!.helloMessageNeutral,
    textAlign: TextAlign.center,
    style: Theme.of(c).textTheme.displayMedium?.copyWith(
      color: Theme.of(c).colorScheme.primary,
      fontStyle: FontStyle.italic,
    ),
  );
}
