import 'package:flutter/material.dart';

// Message greeting
class HelloLog extends StatelessWidget {
  const HelloLog({super.key});

  @override
  Widget build(BuildContext c) => Text(
    'Hi sweetie,\nhow is your day?',
    textAlign: TextAlign.center,
    style: Theme.of(c).textTheme.displayMedium?.copyWith(
      color: Theme.of(c).colorScheme.primary,
      fontStyle: FontStyle.italic,
    ),
  );
}
