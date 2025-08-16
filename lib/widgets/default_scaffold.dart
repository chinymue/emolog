import 'package:flutter/material.dart';
import '../utils/constant.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pages[currentIndex]['label'] ?? 'Not found name',
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
            BottomNavigationBarItem(icon: Icon(i['icon']), label: i['label']),
        ],
      ),
    );
  }
}
