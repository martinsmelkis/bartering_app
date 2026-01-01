import 'package:barter_app/screens/map_screen/cubit/map_screen_api_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../../configure_dependencies.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/settings_service.dart';

class SearchInMap extends StatefulWidget {
  final MapController controller;
  final PoiCubit poiCubit;

  const SearchInMap({super.key, required this.controller, required this.poiCubit});
  @override
  State<StatefulWidget> createState() => _SearchInMapState();
}

class _SearchInMapState extends State<SearchInMap> {
  final textController = TextEditingController();
  late PickerMapController controller = PickerMapController(
    initMapWithUserPosition: const UserTrackingOption(),
  );

  @override
  void initState() {
    super.initState();
    textController.addListener(textOnChanged);
  }

  void textOnChanged() {
    controller.setSearchableText(textController.text);
  }

  @override
  void dispose() {
    textController.removeListener(textOnChanged);
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 48,
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: const StadiumBorder(),
        child: BlocBuilder<PoiCubit, PoiState>(
          bloc: widget.poiCubit,
          builder: (context, state) {
            final isLoading = state is PoiLoading;
            return TextField(
              controller: textController,
              onTap: () {},
              maxLines: 1,
              onSubmitted: (t) async {
                final settingsService = getIt<SettingsService>();
                final radiusKm = await settingsService.getKeywordSearchRadius();
                final weight = await settingsService.getKeywordSearchWeight();
                widget.poiCubit.getProfilesByKeyword(
                  t, 
                  radiusMeters: radiusKm * 1000,
                  weight: weight,
                );
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                filled: false,
                isDense: true,
                hintText: l10n.searchForAKeyword,
                prefixIcon: const Icon(Icons.search, size: 22),
                suffixIcon: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : null,
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
            );
          },
        ),
      ),
    );
  }
}