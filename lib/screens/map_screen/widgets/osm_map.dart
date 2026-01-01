import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class OSMMap extends StatelessWidget with OSMMixinObserver  {
  OSMMap({super.key, required this.controller});
  final MapController controller;

  ValueNotifier<int> zoomLevelNotifier = ValueNotifier(16);
  ValueNotifier<bool> trackingNotifier = ValueNotifier(false);
  ValueNotifier<bool> disableMapControlUserTracking = ValueNotifier(true);
  ValueNotifier<IconData> userLocationIcon = ValueNotifier(Icons.near_me);
  ValueNotifier<GeoPoint?> userLocationNotifier = ValueNotifier(null);
  ValueNotifier<bool> showFab = ValueNotifier(true);

  @override
  void initState() {
    //super.initState();

    controller.addObserver(this);
    trackingNotifier.addListener(() async {
      if (userLocationNotifier.value != null && !trackingNotifier.value) {
        await controller.removeMarker(userLocationNotifier.value!);
        userLocationNotifier.value = null;
      }
    });

  }

  @override
  void onLocationChanged(UserLocation userLocation) async {
    super.onLocationChanged(userLocation);
    if (disableMapControlUserTracking.value && trackingNotifier.value) {
      await controller.moveTo(userLocation);
      if (userLocationNotifier.value == null) {
        await controller.addMarker(
          userLocation,
          markerIcon: const MarkerIcon(icon: Icon(Icons.navigation, size: 48)),
          angle: userLocation.angle,
        );
      } else {
        await controller.changeLocationMarker(
          oldLocation: userLocationNotifier.value!,
          newLocation: userLocation,
          angle: userLocation.angle,
        );
      }
      userLocationNotifier.value = userLocation;
    } else {
      if (userLocationNotifier.value != null && !trackingNotifier.value) {
        await controller.removeMarker(userLocationNotifier.value!);
        userLocationNotifier.value = null;
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: controller,
      // mapIsLoading: Center(
      //   child: CircularProgressIndicator(),
      // ),
      onLocationChanged: (location) {
        debugPrint(location.toString());
      },
      osmOption: OSMOption(
        enableRotationByGesture: true,
        zoomOption: const ZoomOption(
          initZoom: 16,
          minZoomLevel: 3,
          maxZoomLevel: 19,
          stepZoom: 1.0,
        ),
        userLocationMarker: UserLocationMaker(
          personMarker: MarkerIcon(
            // icon: Icon(
            //   Icons.car_crash_sharp,
            //   color: Colors.red,
            //   size: 48,
            // ),
            // iconWidget: SizedBox.square(
            //   dimension: 56,
            //   child: Image.asset(
            //     "asset/taxi.png",
            //     scale: .3,
            //   ),
            // ),
            iconWidget: SizedBox(
              width: 32,
              height: 64,
              child: Image.asset("asset/directionIcon.png", scale: .3),
            ),
            // assetMarker: AssetMarker(
            //   image: AssetImage(
            //     "asset/taxi.png",
            //   ),
            //   scaleAssetImage: 0.3,
            // ),
          ),
          directionArrowMarker: const MarkerIcon(
            icon: Icon(Icons.navigation_rounded, size: 48),
            // iconWidget: SizedBox(
            //   width: 32,
            //   height: 64,
            //   child: Image.asset(
            //     "asset/directionIcon.png",
            //     scale: .3,
            //   ),
            // ),
          ),
          // directionArrowMarker: MarkerIcon(
          //   assetMarker: AssetMarker(
          //     image: AssetImage(
          //       "asset/taxi.png",
          //     ),
          //     scaleAssetImage: 0.25,
          //   ),
          // ),
        ),
        staticPoints: [
          StaticPositionGeoPoint(
            "line 1",
            const MarkerIcon(
              icon: Icon(Icons.train, color: Colors.green, size: 48),
            ),
            [
              GeoPoint(latitude: 47.4333594, longitude: 8.4680184),
              GeoPoint(latitude: 47.4317782, longitude: 8.4716146),
            ],
          ),
        ],
        roadConfiguration: const RoadOption(roadColor: Colors.blueAccent),
        showContributorBadgeForOSM: true,
        //trackMyPosition: trackingNotifier.value,
        showDefaultInfoWindow: false,
      ),
    );
    /*
    Positioned(
                    bottom: 32,
                    right: 15,
                    child: ActivationUserLocation(
                      controller: _mapController,
                      trackingNotifier: trackingNotifier,
                      userLocation: userLocationNotifier,
                      userLocationIcon: userLocationIcon,
                    ),
                  ),;
     */
  }

  @override
  Future<void> mapIsReady(bool isReady) {

    throw UnimplementedError();
  }

}