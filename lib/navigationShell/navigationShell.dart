import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/routes/routes.dart';

class ScaffoldWithBottomNavBar extends StatelessWidget {
  const ScaffoldWithBottomNavBar({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final branches =
        navigationShell.route.branches.cast<StatefulShellBranchWithIcon>();
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: branches.map((branch) {
          return BottomNavigationBarItem(
            icon: Icon(branch.icon),
            label: branch.label,
          );
        }).toList(),
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
