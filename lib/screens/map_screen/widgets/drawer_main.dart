import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/services/settings_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/responsive_breakpoints.dart';
import '../cubit/map_screen_api_cubit.dart';
import '../../settings_screen/settings_screen.dart';
import '../../privacy_policy_screen/privacy_policy_screen.dart';

class DrawerMain extends StatelessWidget {

  final PoiCubit poiCubit;
  final MapController mapController;
  final VoidCallback? onAttributesChanged;
  final VoidCallback? onOpenSettingsPanel;

  const DrawerMain({
    super.key, 
    required this.poiCubit, 
    required this.mapController,
    this.onAttributesChanged,
    this.onOpenSettingsPanel,
  });

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
                    
                    final settingsService = getIt<SettingsService>();
                    final useMapCenter = await settingsService.getUseMapCenterForSearch();
                    final radiusKm = await settingsService.getNearbyUsersRadius();
                    
                    if (useMapCenter) {
                      final mapCenter = await mapController.centerMap;
                      await poiCubit.getComplementaryProfiles(
                        poiCubit.userId ?? "",
                        lat: mapCenter.latitude,
                        lon: mapCenter.longitude,
                        radiusMeters: radiusKm * 1000,
                      );
                    } else {
                      await poiCubit.getComplementaryProfiles(
                        poiCubit.userId ?? "",
                        radiusMeters: radiusKm * 1000,
                      );
                    }
                  },
                  title: Text(l10n?.drawer_menu_complementary_users ?? "Complementary Profiles"),
                ),
                PointerInterceptor(
                  child: ListTile(
                    onTap: () async {
                      Scaffold.of(context).closeDrawer();
                      
                      final settingsService = getIt<SettingsService>();
                      final useMapCenter = await settingsService.getUseMapCenterForSearch();
                      final radiusKm = await settingsService.getNearbyUsersRadius();
                      
                      if (useMapCenter) {
                        final mapCenter = await mapController.centerMap;
                        await poiCubit.getSimilarProfiles(
                          poiCubit.userId ?? "",
                          lat: mapCenter.latitude,
                          lon: mapCenter.longitude,
                          radiusMeters: radiusKm * 1000,
                        );
                      } else {
                        await poiCubit.getSimilarProfiles(
                          poiCubit.userId ?? "",
                          radiusMeters: radiusKm * 1000,
                        );
                      }
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
                    onTap: () async {
                      Scaffold.of(context).closeDrawer();
                      
                      // Use adaptive behavior: panel on web/desktop, full-screen on mobile
                      if (kIsWeb && context.canShowSideBySide && onOpenSettingsPanel != null) {
                        // Open as left panel on web
                        onOpenSettingsPanel!();
                      } else {
                        // Navigate to full-screen on mobile
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                        // Notify that attributes may have changed after returning from settings
                        onAttributesChanged?.call();
                      }
                    },
                    title: Text(l10n?.settingsTitle ?? "Settings"),
                  ),
                ),
                PointerInterceptor(
                  child: ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                    title: Text(l10n?.privacyPolicy ?? "Privacy Policy"),
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