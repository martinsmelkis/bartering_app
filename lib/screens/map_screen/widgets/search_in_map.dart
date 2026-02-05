import 'package:barter_app/screens/map_screen/cubit/map_screen_api_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../../configure_dependencies.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/settings_service.dart';
import '../../../theme/app_colors.dart';

class SearchInMap extends StatefulWidget {
  final MapController controller;
  final PoiCubit poiCubit;
  final ValueNotifier<bool> showCheckboxesNotifier;
  final ValueNotifier<bool> seekingCheckedNotifier;
  final ValueNotifier<bool> offeringCheckedNotifier;

  const SearchInMap({
    super.key, 
    required this.controller, 
    required this.poiCubit,
    required this.showCheckboxesNotifier,
    required this.seekingCheckedNotifier,
    required this.offeringCheckedNotifier,
  });
  
  @override
  State<StatefulWidget> createState() => _SearchInMapState();
}

class _SearchInMapState extends State<SearchInMap> {
  final textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late PickerMapController controller = PickerMapController(
    initMapWithUserPosition: const UserTrackingOption(),
  );
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    textController.addListener(textOnChanged);
    _focusNode.addListener(_onFocusChange);
  }

  void textOnChanged() {
    controller.setSearchableText(textController.text);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _clearAndUnfocus() {
    textController.clear();
    _focusNode.unfocus();
    widget.showCheckboxesNotifier.value = false;
  }

  @override
  void dispose() {
    textController.removeListener(textOnChanged);
    _focusNode.removeListener(_onFocusChange);
    textController.dispose();
    _focusNode.dispose();
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: BlocBuilder<PoiCubit, PoiState>(
          bloc: widget.poiCubit,
          builder: (context, state) {
            final isLoading = state is PoiLoading;
            return TextField(
              controller: textController,
              focusNode: _focusNode,
              onTap: () {
                widget.showCheckboxesNotifier.value = true;
              },
              maxLines: 1,
              onSubmitted: (t) async {
                final settingsService = getIt<SettingsService>();
                final radiusKm = await settingsService.getKeywordSearchRadius();
                final weight = await settingsService.getKeywordSearchWeight();
                widget.poiCubit.getProfilesByKeyword(
                  t, 
                  radiusMeters: radiusKm * 1000,
                  weight: weight,
                  seeking: widget.seekingCheckedNotifier.value ? 'true' : 'false',
                  offering: widget.offeringCheckedNotifier.value ? 'true' : 'false',
                );
                // Hide checkboxes and unfocus after search
                widget.showCheckboxesNotifier.value = false;
                _focusNode.unfocus();
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(right: 0),
                filled: false,
                isDense: true,
                hintText: l10n.searchForAKeyword,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 0),
                  child: const Icon(Icons.search, size: 22, color: AppColors.primary,),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 40),
                suffixIcon: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : _isFocused
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 20, color: AppColors.primary),
                            onPressed: _clearAndUnfocus,
                            padding: const EdgeInsets.all(8.0),
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