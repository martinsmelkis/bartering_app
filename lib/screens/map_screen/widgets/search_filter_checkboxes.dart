import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../l10n/app_localizations.dart';

class SearchFilterCheckboxes extends StatelessWidget {
  final ValueNotifier<bool> showCheckboxesNotifier;
  final ValueNotifier<bool> seekingCheckedNotifier;
  final ValueNotifier<bool> offeringCheckedNotifier;

  const SearchFilterCheckboxes({
    super.key,
    required this.showCheckboxesNotifier,
    required this.seekingCheckedNotifier,
    required this.offeringCheckedNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth >= 600;
    
    return ValueListenableBuilder<bool>(
      valueListenable: showCheckboxesNotifier,
      builder: (context, showCheckboxes, _) {
        if (!showCheckboxes) return const SizedBox.shrink();
        
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isLargeScreen ? 600 : double.infinity,
            ),
            child: PointerInterceptor(
              child: Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: seekingCheckedNotifier,
                          builder: (context, seekingChecked, _) {
                            return CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                AppLocalizations.of(context)!.userInterestedIn,
                                style: const TextStyle(fontSize: 14),
                              ),
                              value: seekingChecked,
                              onChanged: (value) {
                                seekingCheckedNotifier.value = value ?? true;
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: offeringCheckedNotifier,
                          builder: (context, offeringChecked, _) {
                            return CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                AppLocalizations.of(context)!.userOffers,
                                style: const TextStyle(fontSize: 14),
                              ),
                              value: offeringChecked,
                              onChanged: (value) {
                                offeringCheckedNotifier.value = value ?? true;
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
