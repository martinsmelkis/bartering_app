import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Utility class for rendering sharp SVGs on web, especially mobile
class SvgUtils {
  /// Creates a sharp SVG widget optimized for web high-DPI displays
  ///
  /// On web, this renders the SVG at the device's pixel ratio and scales it down
  /// using Transform.scale with high filter quality. This prevents blurriness
  /// on high-DPI mobile screens (2x, 3x, 4x pixel ratio).
  ///
  /// On mobile native, it renders normally without transformation.
  ///
  /// Parameters:
  /// - [svgString]: The SVG content as a string
  /// - [width]: The desired display width
  /// - [height]: The desired display height
  /// - [devicePixelRatio]: Optional device pixel ratio (auto-detected from context if null)
  /// - [fit]: How to fit the SVG within the bounds
  /// - [clipBehavior]: The clip behavior for the SVG
  /// - [semanticsLabel]: Accessibility label
  /// - [key]: Widget key
  /// - [allowDrawingOutsideViewBox]: Whether to allow drawing outside viewBox
  static Widget buildSharpSvg({
    required String svgString,
    required double width,
    required double height,
    double? devicePixelRatio,
    BoxFit fit = BoxFit.contain,
    Clip clipBehavior = Clip.antiAlias,
    String? semanticsLabel,
    Key? key,
    bool allowDrawingOutsideViewBox = false,
  }) {

    return RepaintBoundary(
      child: kIsWeb
          ? Transform.scale(
        scale: 1.0,
        filterQuality: FilterQuality.high,
        child: SizedBox(
          width: width,
          height: height,
          child: SvgPicture.string(
            svgString,
            width: width,
            height: height,
            fit: fit,
            clipBehavior: clipBehavior,
            semanticsLabel: semanticsLabel,
            key: key,
            allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
          ),
        ),
      )
          : SvgPicture.string(
        svgString,
        width: width,
        height: height,
        fit: fit,
        clipBehavior: clipBehavior,
        semanticsLabel: semanticsLabel,
        key: key,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      ),
    );
  }

  /// Creates a sharp SVG widget from an asset optimized for web high-DPI displays
  /// 
  /// Similar to [buildSharpSvg] but loads from asset path instead of string.
  /// 
  /// Parameters:
  /// - [assetPath]: Path to the SVG asset
  /// - [width]: The desired display width
  /// - [height]: The desired display height
  /// - [devicePixelRatio]: Optional device pixel ratio (auto-detected from context if null)
  /// - [fit]: How to fit the SVG within the bounds
  /// - [clipBehavior]: The clip behavior for the SVG
  /// - [semanticsLabel]: Accessibility label
  /// - [key]: Widget key
  static Widget buildSharpSvgFromAsset({
    required String assetPath,
    required double width,
    required double height,
    double? devicePixelRatio,
    BoxFit fit = BoxFit.contain,
    Clip clipBehavior = Clip.antiAlias,
    String? semanticsLabel,
    Key? key,
  }) {
    // Use provided pixel ratio, or default to 2.5x for web (covers most high-DPI screens)
    final scaleFactor = kIsWeb ? (devicePixelRatio ?? 2.5) : 1.0;

    return RepaintBoundary(
      child: kIsWeb
          ? Transform.scale(
        scale: 1.0 / scaleFactor,
        filterQuality: FilterQuality.high,
        child: SizedBox(
          width: width * scaleFactor,
          height: height * scaleFactor,
          child: SvgPicture.asset(
            assetPath,
            width: width * scaleFactor,
            height: height * scaleFactor,
            fit: fit,
            clipBehavior: clipBehavior,
            semanticsLabel: semanticsLabel,
            key: key,
          ),
        ),
      )
          : SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        clipBehavior: clipBehavior,
        semanticsLabel: semanticsLabel,
        key: key,
      ),
    );
  }
}
