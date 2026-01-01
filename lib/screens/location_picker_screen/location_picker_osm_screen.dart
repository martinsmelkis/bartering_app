import 'package:barter_app/screens/map_screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/user_repository.dart';
import '../../services/api_client.dart';
import '../../services/secure_storage_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/dialogs/error_dialog.dart';
import '../../widgets/dialogs/progress_dialog.dart';
import '../map_screen/widgets/top_search_widget.dart';
import '../map_screen/widgets/user_location.dart';
import 'cubit/location_picker_cubit.dart';

class LocationPickerScreenOsm extends StatelessWidget {
  const LocationPickerScreenOsm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationPickerCubit(
          ApiClient.create(), getIt<UserRepository>()),
      child: const LocationPickerScreenWidget(),
    );
  }
}

class LocationPickerScreenWidget extends StatefulWidget {
  const LocationPickerScreenWidget({super.key});

  @override
  State<LocationPickerScreenWidget> createState() => _LocationPickerOsmScreenState();
}

class _LocationPickerOsmScreenState extends State<LocationPickerScreenWidget> {

  ValueNotifier<bool> trackingNotifier = ValueNotifier(false);
  ValueNotifier<bool> showFab = ValueNotifier(false);
  ValueNotifier<bool> disableMapControlUserTracking = ValueNotifier(true);
  ValueNotifier<IconData> userLocationIcon = ValueNotifier(Icons.near_me);
  ValueNotifier<GeoPoint?> lastGeoPoint = ValueNotifier(null);
  List<GeoPoint> geos = [];
  ValueNotifier<GeoPoint?> userLocationNotifier = ValueNotifier(null);
  ValueNotifier<int> zoomLevelNotifier = ValueNotifier(16);
  final mapKey = GlobalKey();

  // Fetch user location and fallback to Paris if not available
  late PickerMapController controller = PickerMapController(
      initPosition: GeoPoint(latitude: 48.8584, longitude: 2.2945),
      /*initMapWithUserPosition: const UserTrackingOption(
        enableTracking: true,
        unFollowUser: false,
      ),*/
  )..customTile = CustomTile(
    sourceName: "osm_bright", //for caching | osmFrance
    tileExtension: ".png",
    minZoomLevel: 2,
    maxZoomLevel: 19,
    keyApi: MapEntry("api_key", "99031957-2f86-4c0b-b1a3-998c32b7f299"),
    urlsServers: [
      TileURLs(url: "https://tiles-eu.stadiamaps.com/tiles/osm_bright/"),
    ],
    //tileSize: 256,
  );
  late TextEditingController textEditingController = TextEditingController();

  GeoPoint? _selectedPoint;
  LocationPickerCubit _locationPickerCubit = LocationPickerCubit(
      ApiClient.create(), getIt<UserRepository>());

  Future<void> _saveLocation(GeoPoint point) async {
    _selectedPoint = point;
    if (_selectedPoint != null) {
      final prefs = await SecureStorageService();
      await prefs.saveOwnLocation(
          "${_selectedPoint!.latitude.toString()}"
              ", ${_selectedPoint!.longitude.toString()}");
      if (mounted) {
        _locationPickerCubit.state.selectedLocation = _selectedPoint;
        // update profile trough Cubit, navigate to MapScreen on submit success
        _locationPickerCubit.saveLocation(_selectedPoint);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.pleaseSelectLocationFirst)),
        );
      }
    }
  }

  /*@override
  void onSingleTap(GeoPoint position) {
    super.onSingleTap(position);
    Future.microtask(() async {
      if (lastGeoPoint.value != null) {
        // await controller.changeLocationMarker(
        //   oldLocation: lastGeoPoint.value!,
        //   newLocation: position,
        //   //iconAnchor: IconAnchor(anchor: Anchor.top),
        // );
        //controller.removeMarker(lastGeoPoint.value!);
        await controller.addMarker(
          position,
          markerIcon: const MarkerIcon(
            icon: Icon(Icons.person_pin, color: Colors.red, size: 56),
          ),
          //angle: userLocation.angle,
        );
      } else {
        await controller.addMarker(
          position,
          markerIcon: const MarkerIcon(
            icon: Icon(Icons.person_pin, color: Colors.red, size: 56),
          ),
          // iconAnchor: IconAnchor(
          //   anchor: Anchor.left,
          //   //offset: (x: 32.5, y: -32),
          // ),
          //angle: -pi / 4,
        );
      }
      //await controller.moveTo(position, animate: true);
      lastGeoPoint.value = position;
      geos.add(position);
    });
  }*/

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(textOnChanged);
  }

  void textOnChanged() {
    controller.setSearchableText(textEditingController.text);
  }

  @override
  void dispose() {
    textEditingController.removeListener(textOnChanged);
    super.dispose();
  }

  void _onMapReady(bool isReady) async {
    await controller.osmBaseController.setZoom(zoomLevel: 6);
    await controller.goToLocation(GeoPoint(latitude: 48.8584, longitude: 2.2945));
  }

  @override
  Widget build(BuildContext context) {
    _locationPickerCubit = context.read<LocationPickerCubit>();
    return BlocListener<LocationPickerCubit, LocationPickerState>(
        listener: (context, state) {
          if (state.status == LocationPickerStatus.loading) {
            showDialog(
              context: context,
              builder: (context) =>
                  ProgressDialog(
                      message: AppLocalizations.of(context)!.submitting),
            );
          } else if (state.status == LocationPickerStatus.error) {
            showDialog(
              context: context,
              builder: (context) =>
                  ErrorDialog(
                    title: AppLocalizations.of(context)!.error,
                    content: state.errorMessage ??
                        AppLocalizations.of(context)!.anUnknownErrorOccurred,
                  ),
            );
          } else if (state.status == LocationPickerStatus.success) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MapScreenV2()),
            );
          }
        },
      child: CustomPickerLocation(
        controller: controller,
        onMapReady: _onMapReady,
        showDefaultMarkerPickWidget: true,
        topWidgetPicker: Padding(
          padding: const EdgeInsets.only(top: 56, left: 8, right: 8),
          child: Column(
            children: [
              Row(
                children: [
                  PointerInterceptor(
                    child: TextButton(
                      style: TextButton.styleFrom(),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  Expanded(
                    child: PointerInterceptor(
                      child: TextField(
                        controller: textEditingController,
                        onEditingComplete: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          suffix: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: textEditingController,
                            builder: (ctx, text, child) {
                              if (text.text.isNotEmpty) {
                                return child!;
                              }
                              return const SizedBox.shrink();
                            },
                            child: InkWell(
                              focusNode: FocusNode(),
                              onTap: () {
                                textEditingController.clear();
                                controller.setSearchableText("");
                                FocusScope.of(context).requestFocus(FocusNode());
                              },
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          focusColor: Colors.black,
                          filled: true,
                          hintText: AppLocalizations.of(context)!
                              .searchForALocation,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          fillColor: Colors.grey[100],
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TopSearchWidget(
                controller: controller,
                onLocationPicked: _saveLocation,
              ),
            ],
          ),
        ),
        bottomWidgetPicker: Stack(
          children: [
            // Zoom buttons at bottom left
            Positioned(
              bottom: 23.0,
              left: 15,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PointerInterceptor(
                    child: ElevatedButton(
                      onPressed: () async {
                        controller.osmBaseController.zoomIn();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(48, 32),
                        maximumSize: const Size(48, 48),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        backgroundColor: AppColors.background,
                        padding: EdgeInsets.zero,
                        elevation: 0,
                      ),
                      child: const Center(
                          child: Icon(Icons.add, color: Colors.black)),
                    ),
                  ),
                  PointerInterceptor(
                    child: ElevatedButton(
                      onPressed: () async {
                        controller.osmBaseController.zoomOut();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(48, 32),
                        maximumSize: const Size(48, 48),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        backgroundColor: AppColors.background,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Center(
                          child: Icon(Icons.remove, color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
            // Save location button at bottom right
            Positioned(
              bottom: 12,
              right: 8,
              child: PointerInterceptor(
                child: FloatingActionButton(
                  backgroundColor: AppColors.background,
                  onPressed: () async {
                    if (!context.mounted) return;
                    final center = await controller.osmBaseController
                        .getMapCenter();
                    _saveLocation(center);
                  },
                  child: const Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ],
        ),
        pickerConfig: const CustomPickerLocationConfig(
          zoomOption: ZoomOption(initZoom: 8),
        ),
      )
    );
  }
}
