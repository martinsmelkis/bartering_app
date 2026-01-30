import 'package:flutter/material.dart';

/// A responsive container that centers content on large screens with a max width
class ResponsiveCenterContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;
  final bool centerVertically;

  const ResponsiveCenterContainer({
    super.key,
    required this.child,
    this.maxWidth = 800.0,
    this.padding,
    this.centerVertically = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    Widget content = Container(
      constraints: BoxConstraints(
        maxWidth: isLargeScreen ? maxWidth : double.infinity,
      ),
      padding: padding,
      child: child,
    );

    // Wrap in SingleChildScrollView for scrollability
    Widget scrollableContent = SingleChildScrollView(
      child: content,
    );

    // On large screens with vertical centering, wrap in Center
    if (isLargeScreen && centerVertically) {
      return Center(
        child: scrollableContent,
      );
    } else {
      // On small screens, just return the scrollable content
      return scrollableContent;
    }
  }
}
