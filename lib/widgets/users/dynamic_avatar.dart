import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/profile/user_profile_data.dart';

class DynamicAvatar extends StatelessWidget {
  final UserProfileData profile;

  const DynamicAvatar({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    // --- Logic to select parts based on profile ---
    // Example: Use user ID for the base shape to keep it consistent.
    final base_part = 'assets/icons/avatar/base/base_${profile.userId.hashCode.abs() % 2 + 1}.svg';

    String? dominantTrait;
    final keywords = profile.profileKeywordDataMap;

    if (keywords?.isNotEmpty == true) {
      // Use reduce to find the key with the maximum value.
      // It iterates through the keys, keeping the one with the higher score.
      dominantTrait = keywords?.keys.reduce((key1, key2) {
        final value1 = keywords[key1]!;
        final value2 = keywords[key2]!;
        return value1 > value2 ? key1 : key2;
      });
    }
    // Example: Pick eyes based on a dominant personality trait from onboarding.
    final eyes_part = _getEyesForTrait(dominantTrait); // e.g., 'assets/icons/avatar/eyes/eyes_curious.svg'

    // Example: Pick an accessory if they are interested in "music".
    final accessory_part = dominantTrait?.contains('music') == true
        ? 'assets/icons/avatar/accessory/accessory_headphones.svg'
        : null; // No accessory

    // Use a Stack to layer the SVG parts on top of each other.
    return Stack(
      alignment: Alignment.center,
      children: [
        // Wrap the SvgPicture in a ColorFiltered widget.
        // This will apply the color to any part of the SVG that
        // does not have a hardcoded 'fill' attribute.
        ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.green, BlendMode.srcIn),
          child: SvgPicture.asset(base_part),
        ),
        SvgPicture.asset(eyes_part),
        // ... other parts like mouth, nose ...

        // Conditionally add the accessory layer
        if (accessory_part != null)
          SvgPicture.asset(accessory_part),
      ],
    );
  }

  String _getEyesForTrait(String? trait) {
    // Add your logic here to map the trait to an eye asset.
    switch (trait) {
      case 'adventurous':
        return 'assets/icons/avatar/eyes/eyes_curious.svg';
      case 'creative':
        return 'assets/icons/avatar/eyes/eyes_nerdy.svg';
      case 'social':
        return 'assets/icons/avatar/eyes/eyes_happy.svg';
      default:
      // A fallback for when there's no dominant trait or it's unrecognized.
        return 'assets/icons/avatar/eyes/eyes_happy.svg';
    }
  }

}