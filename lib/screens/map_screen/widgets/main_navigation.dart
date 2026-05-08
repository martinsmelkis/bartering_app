import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: UniqueKey(),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      heroTag: "MainMenuFab",
      mini: true,
      elevation: 0,
      backgroundColor: AppColors.fabColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Icon(Icons.menu),
    );
  }
}