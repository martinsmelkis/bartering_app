import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../theme/app_colors.dart';

class ZoomNavigation extends StatelessWidget {
  const ZoomNavigation({
    super.key,
    required this.controller,
    required this.zoomNotifier,
  });
  final MapController controller;
  final ValueNotifier<int> zoomNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PointerInterceptor(
          child: ElevatedButton(
            onPressed: () async {
              controller.zoomIn();
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
            child: const Center(child: Icon(Icons.add, color: Colors.black,)),
          ),
        ),
        PointerInterceptor(
          child: ElevatedButton(
            onPressed: () async {
              controller.zoomOut();
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
            child: const Center(child: Icon(Icons.remove, color: Colors.black,)),
          ),
        ),
      ],
    );
  }
}