# Adaptive Design Guide - Best Practices for Flutter

This guide explains the adaptive design system implemented in the Barter App, following Flutter and
Material Design 3 best practices.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Breakpoints](#breakpoints)
- [Usage Examples](#usage-examples)
- [Best Practices](#best-practices)
- [Implementation Details](#implementation-details)

## Overview

### What is Adaptive Design?

Adaptive design ensures your app looks great and provides optimal UX across all screen sizes:

- **Phones** (< 600dp): Single column, full-screen navigation
- **Tablets** (600-840dp): Two columns, flexible layouts
- **Desktops/Web** (> 840dp): Multi-column, side-by-side layouts

### Why It Matters

- **Better UX**: Users see more content on larger screens
- **Efficiency**: Desktop users can multitask (e.g., browse map + chat simultaneously)
- **Modern**: Follows Material Design 3 guidelines
- **Future-proof**: Works on foldables, tablets, and future form factors

## Architecture

### Key Components

```
lib/
├── utils/
│   └── responsive_breakpoints.dart    # Breakpoint definitions & utilities
├── screens/
│   └── chat_screen/
│       ├── adaptive_chat_layout.dart  # Adaptive chat implementation
│       └── chat_screen.dart           # Chat screen (works in both modes)
└── theme/
    └── app_dimensions.dart            # Platform-aware sizing
```

## Breakpoints

Following Material Design 3 guidelines:

| Breakpoint | Width | Device | Layout Pattern |
|------------|-------|--------|----------------|
| **Compact** | < 600dp | Phone (portrait) | Single column, full-screen |
| **Medium** | 600-840dp | Phone (landscape), Tablet (portrait) | 2 columns, adaptive |
| **Expanded** | 840-1200dp | Tablet (landscape), Small desktop | Side-by-side, 3 columns |
| **Large** | 1200-1600dp | Desktop | Multi-column, spacious |
| **Extra Large** | > 1600dp | Ultra-wide | Max content width |

### Code Example:

```dart
// Check device type
if (context.isPhone) {
  // Show mobile layout
} else if (context.isTablet) {
  // Show tablet layout
} else {
  // Show desktop layout
}

// Or use helper methods
if (context.canShowSideBySide) {
  // Show master-detail pattern
}
```

## Usage Examples

### 1. Basic Responsive Check

```dart
import 'package:barter_app/utils/responsive_breakpoints.dart';

Widget build(BuildContext context) {
  if (context.canShowSideBySide) {
    return Row(
      children: [
        Expanded(child: MasterView()),
        SizedBox(width: 400, child: DetailView()),
      ],
    );
  }
  
  // On small screens, navigate instead
  return MasterView();
}
```

### 2. Responsive Values

```dart
// Get different values based on screen size
final columns = ResponsiveBreakpoints.getColumns(
  context,
  mobile: 1,
  tablet: 2,
  desktop: 3,
);

// Get padding that adapts
final padding = context.responsivePadding; // 16/24/32/48 based on size

// Get custom values
final fontSize = ResponsiveBreakpoints.getValue(
  context: context,
  compact: 14.0,
  medium: 16.0,
  expanded: 18.0,
);
```

### 3. Adaptive Chat (Full Implementation)

#### Step 1: Wrap your main screen

```dart
class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveChatWrapper(
      child: YourMapContent(),
    );
  }
}
```

#### Step 2: Access the wrapper to open chat

```dart
// Find the wrapper state
final wrapperState = context.findAncestorStateOfType<AdaptiveChatWrapperState>();

// Open chat adaptively
wrapperState?.openChat(
  poiId,
  poiName: poiName,
);

// On large screens: Opens side panel
// On small screens: Navigates to full screen
```

#### Step 3: Close chat (side panel only)

```dart
wrapperState?.closeChat();
```

### 4. Conditional Widget Building

```dart
// Show different widgets based on device
Widget build(BuildContext context) {
  return ResponsiveBreakpoints.valueWhen(
    context: context,
    mobile: MobileWidget(),
    tablet: TabletWidget(),
    desktop: DesktopWidget(),
  );
}

// Or use switch
switch (context.deviceSize) {
  case DeviceSize.compact:
    return CompactLayout();
  case DeviceSize.medium:
    return MediumLayout();
  case DeviceSize.expanded:
  case DeviceSize.large:
  case DeviceSize.extraLarge:
    return LargeLayout();
}
```

### 5. Responsive Grid

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: ResponsiveBreakpoints.getColumns(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    ),
    spacing: ResponsiveBreakpoints.getGridSpacing(context),
  ),
  itemBuilder: (context, index) => ItemCard(),
)
```

## Best Practices

### 1. Master-Detail Pattern

**Best for**: Lists with details, maps with info panels, chats, etc.

```dart
// ✅ GOOD: Adaptive master-detail
if (context.canShowSideBySide) {
  Row(
    children: [
      Expanded(flex: 2, child: MasterList()),
      Expanded(flex: 3, child: DetailView()),
    ],
  )
} else {
  // Navigate to detail when item tapped
  MasterList()
}

// ❌ BAD: Same on all screens
Row(
  children: [
    Expanded(child: MasterList()),
    Expanded(child: DetailView()), // Cramped on phones!
  ],
)
```

### 2. Navigation Patterns

**Phone**: Bottom Navigation Bar
**Tablet/Desktop**: Navigation Rail or Drawer

```dart
if (context.shouldUseNavigationRail) {
  Row(
    children: [
      NavigationRail(...),
      Expanded(child: content),
    ],
  )
} else {
  Scaffold(
    body: content,
    bottomNavigationBar: BottomNavigationBar(...),
  )
}
```

### 3. Content Width

Limit content width on large screens for readability:

```dart
Center(
  child: ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: ResponsiveBreakpoints.getMaxContentWidth(context),
    ),
    child: content,
  ),
)
```

### 4. Responsive Text

```dart
// Use from app_dimensions.dart
Text(
  'Heading',
  style: TextStyle(fontSize: AppDimensions.headingTextSize),
)

// Or make it responsive
Text(
  'Body',
  style: TextStyle(
    fontSize: ResponsiveBreakpoints.getValue(
      context: context,
      compact: 14.0,
      medium: 16.0,
      expanded: 18.0,
    ),
  ),
)
```

### 5. Responsive Images

```dart
// Adapt image size based on screen
Image.network(
  imageUrl,
  width: ResponsiveBreakpoints.getValue(
    context: context,
    compact: 300,
    medium: 400,
    expanded: 500,
  ),
)
```

## Implementation Details

### Chat Screen Modes

The ChatScreen supports two modes:

1. **Full Screen Mode** (default)
    - Has AppBar
    - Used on phones
    - Accessed via normal navigation

2. **Panel Mode**
    - No AppBar (header in panel)
    - Used on large screens
    - Embedded in AdaptiveChatLayout

```dart
// Full screen (mobile)
ChatScreen(
  poiId: 'user123',
  poiName: 'John',
  showAppBar: true, // default
)

// Panel mode (desktop)
ChatScreen(
  poiId: 'user123',
  poiName: 'John',
  showAppBar: false, // no app bar
)
```

### State Management

The `AdaptiveChatWrapper` manages chat panel state:

```dart
class AdaptiveChatWrapperState {
  String? _selectedPoiId;    // Currently open chat
  String? _selectedPoiName;
  
  void openChat(String poiId, {String? poiName}) {
    // Opens panel or navigates based on screen size
  }
  
  void closeChat() {
    // Closes the side panel
  }
}
```

### Why This Architecture?

✅ **Separation of Concerns**: Layout logic separate from business logic
✅ **Reusable**: Same ChatScreen works in both modes
✅ **Testable**: Easy to test responsive behavior
✅ **Maintainable**: Single source of truth for breakpoints
✅ **Performant**: Uses extension methods for efficiency

## Testing Responsive Layouts

### In Flutter DevTools

1. Open Flutter DevTools
2. Go to "Widget Inspector"
3. Click "Select Render Mode"
4. Choose different device sizes

### Programmatically

```dart
// Override size for testing
Widget build(BuildContext context) {
  return MediaQuery(
    data: MediaQuery.of(context).copyWith(
      size: Size(1200, 800), // Desktop size
    ),
    child: YourWidget(),
  );
}
```

### Using Breakpoint Constants

```dart
testWidgets('Shows side panel on desktop', (tester) async {
  await tester.binding.setSurfaceSize(
    Size(ResponsiveBreakpoints.expanded + 100, 800),
  );
  
  await tester.pumpWidget(YourApp());
  
  expect(find.byType(SidePanel), findsOneWidget);
});
```

## Migration Guide

### Converting Existing Screens

#### Before:

```dart
class MyScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: content,
    );
  }
}
```

#### After:

```dart
import 'package:barter_app/utils/responsive_breakpoints.dart';

class MyScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    if (context.canShowSideBySide) {
      return Row(
        children: [
          Expanded(flex: 2, child: mainContent),
          Expanded(flex: 1, child: sidePanel),
        ],
      );
    }
    
    return Scaffold(
      body: mainContent,
    );
  }
}
```

## Resources

- [Material Design 3 - Layout](https://m3.material.io/foundations/layout/applying-layout/window-size-classes)
- [Flutter - Adaptive & Responsive Design](https://docs.flutter.dev/ui/layout/responsive-adaptive)
- [Flutter - Building Adaptive Apps](https://flutter.dev/docs/development/ui/layout/building-adaptive-apps)

## Summary

Key takeaways:

- ✅ Use `ResponsiveBreakpoints` for device size checks
- ✅ Use `AppDimensions` for platform-aware sizing
- ✅ Implement master-detail pattern on large screens
- ✅ Keep business logic separate from layout logic
- ✅ Test on multiple screen sizes
- ✅ Follow Material Design 3 guidelines

This architecture ensures your app provides the best UX on every device! 🎉
