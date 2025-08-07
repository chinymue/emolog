import 'package:flutter/material.dart';
import '../utils/constant.dart';

// Scaffold with bottom navigation bar -----------------------------
class MainScaffold extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const MainScaffold({
    required this.currentIndex,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pages[currentIndex]['label'] ?? 'Not found name',
          style: Theme.of(c).textTheme.headlineLarge?.copyWith(
            color: Theme.of(c).colorScheme.primary,
          ),
        ),
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => Navigator.pushReplacementNamed(c, pages[i]['route']),
        items: [
          for (var i in pages)
            BottomNavigationBarItem(icon: Icon(i['icon']), label: i['label']),
        ],
      ),
    );
  }
}
