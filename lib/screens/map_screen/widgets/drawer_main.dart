import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../l10n/app_localizations.dart';
import '../cubit/map_screen_api_cubit.dart';
import '../../settings_screen/settings_screen.dart';

class DrawerMain extends StatelessWidget {

  final PoiCubit poiCubit;

  const DrawerMain({super.key, required this.poiCubit});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PointerInterceptor(
      child: GestureDetector(
        onHorizontalDragEnd: (_) {
          Scaffold.of(context).closeDrawer();
        },
        child: PointerInterceptor(
          child: Drawer(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.viewPaddingOf(context).top),
                ListTile(
                  onTap: () async {
                    Scaffold.of(context).closeDrawer();
                    await poiCubit.getComplementaryProfiles(poiCubit.userId ?? "");
                  },
                  title: Text(l10n?.drawer_menu_complementary_users ?? "Complementary Profiles"),
                ),
                PointerInterceptor(
                  child: ListTile(
                    onTap: () async {
                      Scaffold.of(context).closeDrawer();
                      await poiCubit.getSimilarProfiles(poiCubit.userId ?? "");
                    },
                    title: Text(l10n?.drawer_menu_similar_users ?? "Similar Profiles"),
                  ),
                ),
                PointerInterceptor(
                  child: ListTile(
                    onTap: () async {
                      Scaffold.of(context).closeDrawer();
                      await poiCubit.getFavoriteProfiles(poiCubit.userId ?? "");
                    },
                    title: Text(l10n?.drawer_menu_favorite_users ?? "Favorite Profiles"),
                  ),
                ),
                const Divider(),
                PointerInterceptor(
                  child: ListTile(
                    leading: const Icon(Icons.settings),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                    title: Text(l10n?.settingsTitle ?? "Settings"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}