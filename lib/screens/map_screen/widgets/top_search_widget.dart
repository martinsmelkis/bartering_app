import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class TopSearchWidget extends StatefulWidget {

  final PickerMapController controller;
  final void Function(GeoPoint) onLocationPicked;

  const TopSearchWidget({super.key, required this.controller, required this.onLocationPicked});

  @override
  State<StatefulWidget> createState() => _TopSearchWidgetState();
}

class _TopSearchWidgetState extends State<TopSearchWidget> {
  late PickerMapController controller;
  ValueNotifier<GeoPoint?> notifierGeoPoint = ValueNotifier(null);
  ValueNotifier<bool> notifierAutoCompletion = ValueNotifier(false);

  late StreamController<List<SearchInfo>> streamSuggestion = StreamController();
  late Future<List<SearchInfo>> _futureSuggestionAddress;
  String oldText = "";
  Timer? _timerToStartSuggestionReq;
  final Key streamKey = const Key("streamAddressSug");

  final Dio _photonDio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 8),
      headers: {
        'User-Agent': 'barter_app/1.0',
        'Accept': 'application/json',
      },
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  final Map<String, List<SearchInfo>> _suggestionCache = <String, List<SearchInfo>>{};

  @override
  void initState() {
    super.initState();
    controller = CustomPickerLocation.of(context);
    controller.searchableText.addListener(onSearchableTextChanged);
  }

  void onSearchableTextChanged() async {
    final v = controller.searchableText.value;
    if (v.length > 3 && oldText != v) {
      oldText = v;
      if (_timerToStartSuggestionReq != null &&
          _timerToStartSuggestionReq!.isActive) {
        _timerToStartSuggestionReq!.cancel();
      }
      _timerToStartSuggestionReq = Timer.periodic(const Duration(seconds: 3), (
          timer,) async {
        await suggestionProcessing(v);
        timer.cancel();
      });
    }
    if (v.isEmpty) {
      await reInitStream();
    }
  }

  Future reInitStream() async {
    notifierAutoCompletion.value = false;
    await streamSuggestion.close();
    setState(() {
      streamSuggestion = StreamController();
    });
  }

  Future<List<SearchInfo>> _addressSuggestion(
    String searchText, {
    int limitInformation = 5,
    String locale = "en",
  }) async {
    final query = searchText.trim();
    if (query.isEmpty) return [];

    final cacheKey = '$query|$limitInformation|$locale';
    final cached = _suggestionCache[cacheKey];
    if (cached != null) {
      return cached;
    }

    for (int attempt = 0; attempt < 3; attempt++) {
      final response = await _photonDio.get(
        "https://photon.komoot.io/api/",
        queryParameters: {
          "q": query,
          "limit": limitInformation,
          "lang": locale,
        },
        options: Options(
          headers: {
            'Accept-Language': locale,
          },
        ),
      );

      if (response.statusCode == 200) {
        final features = (response.data["features"] as List?) ?? [];
        final results =
            features.map((d) => SearchInfo.fromPhotonAPI(d as Map<String, dynamic>)).toList();
        _suggestionCache[cacheKey] = results;
        if (_suggestionCache.length > 100) {
          _suggestionCache.remove(_suggestionCache.keys.first);
        }
        return results;
      }

      if (response.statusCode == 403 ||
          response.statusCode == 429 ||
          (response.statusCode != null && response.statusCode! >= 500)) {
        await Future.delayed(Duration(milliseconds: 300 * (1 << attempt)));
        continue;
      }

      break;
    }

    return [];
  }

  Future<void> suggestionProcessing(String addr) async {
    notifierAutoCompletion.value = true;

    try {
      _futureSuggestionAddress = _addressSuggestion(
        addr,
        limitInformation: 5,
        locale: "en",
      );

      final value = await _futureSuggestionAddress;
      if (!streamSuggestion.isClosed) {
        streamSuggestion.sink.add(value);
      }
    } catch (_) {
      // Ignore search API failures and keep UI stable.
      if (!streamSuggestion.isClosed) {
        streamSuggestion.sink.add([]);
      }
    }
  }

  @override
  void dispose() {
    controller.searchableText.removeListener(onSearchableTextChanged);
    _timerToStartSuggestionReq?.cancel();
    _photonDio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifierAutoCompletion,
      builder: (ctx, isVisible, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: isVisible ? MediaQuery.of(context).size.height / 4 : 0,
          child: Card(child: child!),
        );
      },
      child: StreamBuilder<List<SearchInfo>>(
        stream: streamSuggestion.stream,
        key: streamKey,
        builder: (ctx, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemExtent: 50.0,
              itemBuilder: (ctx, index) {
                return PointerInterceptor(
                  child: ListTile(
                    title: Text(
                      snap.data![index].address.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                    onTap: () async {
                      /// go to location selected by address
                      widget.onLocationPicked(snap.data![index].point!);
                      controller.goToLocation(snap.data![index].point!);

                      /// hide suggestion card
                      notifierAutoCompletion.value = false;
                      await reInitStream();
                      if (!context.mounted) return;
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                );
              },
              itemCount: snap.data!.length,
            );
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return const Card(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}