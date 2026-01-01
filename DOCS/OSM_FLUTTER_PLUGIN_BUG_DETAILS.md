# flutter_osm_plugin Bug - Exact Location and Details

## Plugin Information

- **Package**: flutter_osm_plugin
- **Version**: 1.4.3
- **Repository**: https://github.com/liodali/osm_flutter
- **Bug File**: `lib/src/controller/osm/osm_controller.dart`
- **Bug Lines**: 509-531

## Exact Buggy Code

Location:
`C:\Users\User\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_osm_plugin-1.4.3\lib\src\controller\osm\osm_controller.dart`

```dart
@override
Future<void> addMarker(
  GeoPoint p, {
  MarkerIcon? markerIcon,
  double? angle,
  IconAnchor? iconAnchor,
}) async {
  if (markerIcon != null) {
    // BUG: Single shared notifier for ALL markers
    _osmFlutterState.widget.dynamicMarkerWidgetNotifier.value = markerIcon;
    
    // 300ms delay before actual rendering
    await Future.delayed(duration, () async {  // duration = const Duration(milliseconds: 300)
      await osmPlatform.addMarker(
        _idMap,
        angle != null && angle != 0
            ? GeoPointWithOrientation(
                angle: angle,
                latitude: p.latitude,
                longitude: p.longitude,
              )
            : p,
        globalKeyIcon: _osmFlutterState.dynamicMarkerKey,  // Uses shared key!
        iconAnchor: iconAnchor,
      );
    });
  } else {
    await osmPlatform.addMarker(_idMap, p, iconAnchor: iconAnchor);
  }
}
```

## Why This is a Bug

### The Problem

1. **Shared State**: `dynamicMarkerWidgetNotifier` is a single `ValueNotifier` used for ALL markers
2. **Race Condition**: When multiple markers are added quickly:
   ```
   Marker 1: Set notifier → Wait 300ms → Render
   Marker 2: OVERWRITE notifier → Wait 300ms → Render  ← Marker 1 now uses Marker 2's data!
   Marker 3: OVERWRITE notifier → Wait 300ms → Render  ← Both 1 and 2 use Marker 3's data!
   ```
3. **Last Value Wins**: All markers end up using the LAST value set in the notifier

### Impact

- All markers render with the same icon/color
- The last marker's appearance is used for all markers
- User cannot distinguish between different marker types

## Similar Affected Methods

The same bug pattern exists in:

1. **setMarkerIcon** (lines ~732-740):

```dart
Future<void> setIconMarker(GeoPoint point, MarkerIcon markerIcon) async {
  _osmFlutterState.widget.dynamicMarkerWidgetNotifier.value = markerIcon;  // Same bug!
  await Future.delayed(duration, () async {
    await osmPlatform.setIconMarker(_idMap, point, _osmFlutterState.dynamicMarkerKey);
  });
}
```

2. **changeMarker** (lines ~746-769):

```dart
Future<void> changeMarker({...}) async {
  if (newMarkerIcon != null) {
    _osmFlutterState.widget.dynamicMarkerWidgetNotifier.value = newMarkerIcon;  // Same bug!
  }
  await Future.delayed(Duration(milliseconds: durationMilliSecond), () async {
    await osmPlatform.changeMarker(...);
  });
}
```

3. **setIconStaticPositions** (lines ~463-475):

```dart
Future<void> setIconStaticPositions(...) async {
  _osmFlutterState.widget.dynamicMarkerWidgetNotifier.value = markerIcon;  // Same bug!
  await osmPlatform.customMarkerStaticPosition(...);
  await Future.delayed(duration);
}
```

## Proper Fix (For Library Maintainers)

### Solution 1: Queue System

```dart
final Queue<_MarkerTask> _markerQueue = Queue();
bool _isProcessingQueue = false;

Future<void> addMarker(...) async {
  final task = _MarkerTask(
    markerIcon: markerIcon,
    point: p,
    angle: angle,
    iconAnchor: iconAnchor,
  );
  
  _markerQueue.add(task);
  
  if (!_isProcessingQueue) {
    await _processMarkerQueue();
  }
}

Future<void> _processMarkerQueue() async {
  _isProcessingQueue = true;
  
  while (_markerQueue.isNotEmpty) {
    final task = _markerQueue.removeFirst();
    
    if (task.markerIcon != null) {
      _osmFlutterState.widget.dynamicMarkerWidgetNotifier.value = task.markerIcon;
      await Future.delayed(duration);
    }
    
    await osmPlatform.addMarker(
      _idMap,
      task.point,
      globalKeyIcon: task.markerIcon != null ? _osmFlutterState.dynamicMarkerKey : null,
      iconAnchor: task.iconAnchor,
    );
  }
  
  _isProcessingQueue = false;
}
```

### Solution 2: Unique Keys Per Marker

```dart
final Map<String, GlobalKey> _markerKeys = {};

Future<void> addMarker(...) async {
  if (markerIcon != null) {
    // Create unique key for this marker
    final markerKey = GlobalKey();
    final markerId = '${p.latitude}_${p.longitude}';
    _markerKeys[markerId] = markerKey;
    
    _osmFlutterState.widget.dynamicMarkerWidgetNotifier.value = markerIcon;
    
    await Future.delayed(duration, () async {
      await osmPlatform.addMarker(
        _idMap,
        p,
        globalKeyIcon: markerKey,  // Use unique key instead of shared
        iconAnchor: iconAnchor,
      );
    });
  }
}
```

### Solution 3: Synchronous Processing

```dart
final _markerLock = Lock(); // From synchronized package

Future<void> addMarker(...) async {
  await _markerLock.synchronized(() async {
    if (markerIcon != null) {
      _osmFlutterState.widget.dynamicMarkerWidgetNotifier.value = markerIcon;
      await Future.delayed(duration);
      
      await osmPlatform.addMarker(
        _idMap,
        p,
        globalKeyIcon: _osmFlutterState.dynamicMarkerKey,
        iconAnchor: iconAnchor,
      );
    } else {
      await osmPlatform.addMarker(_idMap, p, iconAnchor: iconAnchor);
    }
  });
}
```

## Reporting the Bug

### Template for GitHub Issue

**Title**:
`dynamicMarkerWidgetNotifier race condition causes all markers to render with same appearance`

**Description**:

```markdown
## Bug Description
When adding multiple markers with custom `MarkerIcon` widgets quickly in succession, all markers render with the appearance of the last marker added.

## Root Cause
The `MobileOSMController.addMarker()` method uses a single shared `ValueNotifier` called `dynamicMarkerWidgetNotifier` for all dynamic markers. When markers are added before the previous marker finishes rendering (300ms delay), the notifier value gets overwritten.

## Affected Methods
- `addMarker()` (line 509)
- `setIconMarker()` (line 732)
- `changeMarker()` (line 746)
- `setIconStaticPositions()` (line 463)

## Steps to Reproduce
1. Create 3+ markers with different icons/colors
2. Add them rapidly using `controller.addMarker()`
3. Observe that all markers show the same appearance (the last one)

## Expected Behavior
Each marker should render with its own unique icon/color

## Actual Behavior
All markers render with the appearance of the last marker added

## Workaround
Add a 400ms delay between each `addMarker()` call to allow rendering to complete

## Proposed Fix
Implement a queue system or use unique keys per marker instead of a shared notifier

## Environment
- flutter_osm_plugin: 1.4.3
- Flutter: 3.8+
- Platform: Android/iOS
```

## Additional Context

### Why the 400ms Workaround Works

- Internal delay: 300ms (`Future.delayed(duration)`)
- Buffer time: 100ms (safety margin)
- Total: 400ms ensures previous marker completes rendering

### Performance Impact

- Small datasets (3-10 markers): Acceptable delay (1-4 seconds)
- Large datasets (50+ markers): Consider batching by color or other optimization

### Related Issues

Search the repository for similar issues or PRs:

```
site:github.com/liodali/osm_flutter marker icon bug
site:github.com/liodali/osm_flutter dynamicMarkerWidgetNotifier
```

## Testing the Library Fix

If the library maintainers implement a fix, test with:

```dart
// Should work without delays
for (var i = 0; i < 10; i++) {
  await controller.addMarker(
    GeoPoint(latitude: 48.8584 + i * 0.001, longitude: 2.2945),
    markerIcon: MarkerIcon(
      icon: Icon(Icons.place, color: Color(0xFF000000 + i * 0x111111)),
    ),
  );
  // No delay needed!
}
// All markers should have different colors
```
