import 'package:barter_app/screens/location_picker_screen/location_picker_osm_screen.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../models/user/parsed_attribute_data.dart';
import '../../repositories/user_repository.dart';
import '../../services/api_client.dart';
import '../../utils/attribute_style_helper.dart';
import '../../utils/text_utils.dart';
import '../../widgets/dialogs/error_dialog.dart';
import '../../widgets/dialogs/progress_dialog.dart';
import '../map_screen/map_screen.dart';
import 'cubit/offers_cubit.dart';

class OffersScreen extends StatelessWidget {
  bool? isInitialOnboarding = true;
  OffersScreen({super.key, this.isInitialOnboarding});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OffersCubit(ApiClient.create(), getIt<UserRepository>()),
      child: OffersScreenWidget(isInitialOnboarding: isInitialOnboarding),
    );
  }
}

class OffersScreenWidget extends StatefulWidget {
  bool? isInitialOnboarding = true;
  OffersScreenWidget({super.key, this.isInitialOnboarding});

  @override
  State<OffersScreenWidget> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreenWidget> {

  final _customKeywordController = TextEditingController();

  @override
  void dispose() {
    _customKeywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;
    var _offersCubit = context.read<OffersCubit>();

    return BlocListener<OffersCubit, OffersState>(
      listener: (context, state) async {
        // Dismiss any existing dialog first
        //Navigator.of(context).popUntil((route) => route is! PageRoute || route.isFirst);

        if (state.status == OffersStatus.loading) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ProgressDialog(
                  message: AppLocalizations.of(context)!.submittingOffers);
            },
          );
        } else if (state.status == OffersStatus.error) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                title: AppLocalizations.of(context)!.error,
                content: state.errorMessage ??
                    AppLocalizations.of(context)!.anUnknownErrorOccurred,
              );
            },
          );
        } else if (state.status == OffersStatus.success) {
          if (this.widget.isInitialOnboarding == false) {
            Navigator.of(context).pop();
            final canPop = await Navigator.of(context).canPop();
            if (canPop) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => MapScreenV2()),
              );
            }
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LocationPickerScreenOsm()),
            );
          }
        }

      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.selectYourOffers),
        ),
        body: BlocBuilder<OffersCubit, OffersState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: state.allOffers.map((offer) {
                              final isSelected = state.selectedOffers.contains(
                                  offer);
                              final chipColor = AttributeStyleHelper
                                  .getColorForStyleHint(
                                offer.uiStyleHint,
                                isSelected: isSelected,
                              );
                              final textColor = AttributeStyleHelper
                                  .getTextColor(
                                offer.uiStyleHint,
                                isSelected: isSelected,
                              );

                              return ChoiceChip(
                                label: Text(offer.attribute),
                                selected: isSelected,
                                onSelected: (selected) {
                                  context
                                      .read<OffersCubit>()
                                      .toggleInterest(offer);
                                },
                                selectedColor: Colors.blue,
                                backgroundColor: chipColor,
                                checkmarkColor: Colors.white,
                                side: BorderSide(
                                  color: AttributeStyleHelper.getBorderColor(
                                      offer.uiStyleHint),
                                  width: isSelected ? 2.0 : 1.0,
                                ),
                                labelStyle: TextStyle(
                                  color: textColor,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          // Custom keyword input
                          TextField(
                            controller: _customKeywordController,
                            decoration: InputDecoration(
                              labelText: l10n.addYourOwnKeywords,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  context
                                      .read<OffersCubit>()
                                      .addCustomKeyword(
                                      TextUtils.getTranslatedOrNormalizedAttribute(_customKeywordController.text, context));
                                  _customKeywordController.clear();
                                },
                              ),
                            ),
                            onSubmitted: (value) {
                              context
                                  .read<OffersCubit>()
                                  .addCustomKeyword(value);
                              _customKeywordController.clear();
                            },
                          ),
                          const SizedBox(height: 16),
                          // Custom keywords list
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: state.customKeywords.map((keyword) {
                              return Chip(
                                label: Text(keyword),
                                onDeleted: () {
                                  context
                                      .read<OffersCubit>()
                                      .removeCustomKeyword(keyword);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Submit button - stays at bottom
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final locale = Localizations.localeOf(context);
                        _offersCubit.submitOffers(locale.languageCode);
                      },
                      child: Text(l10n.save),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )
    );
  }

}