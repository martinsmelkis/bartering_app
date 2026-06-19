// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Bartering App`
  String get appTitle {
    return Intl.message('Bartering App', name: 'appTitle', desc: '', args: []);
  }

  /// `Nature, outdoors, gardening, animals, environment, hiking, plants, sustainability`
  String get category_green {
    return Intl.message(
      'Nature, outdoors, gardening, animals, environment, hiking, plants, sustainability',
      name: 'category_green',
      desc: '',
      args: [],
    );
  }

  /// `Sports, exercise, hands-on, active lifestyle, physical work, mechanisms, tools`
  String get category_red {
    return Intl.message(
      'Sports, exercise, hands-on, active lifestyle, physical work, mechanisms, tools',
      name: 'category_red',
      desc: '',
      args: [],
    );
  }

  /// `Business, entrepreneurship, paid work, making contacts, money matters, finance, career`
  String get category_blue {
    return Intl.message(
      'Business, entrepreneurship, paid work, making contacts, money matters, finance, career',
      name: 'category_blue',
      desc: '',
      args: [],
    );
  }

  /// `Art, spirituality, philosophy, culture, music, crafts, creativity, design, history`
  String get category_purple {
    return Intl.message(
      'Art, spirituality, philosophy, culture, music, crafts, creativity, design, history',
      name: 'category_purple',
      desc: '',
      args: [],
    );
  }

  /// `Chat, social activities, casual conversation, local events, new contacts, communication`
  String get category_yellow {
    return Intl.message(
      'Chat, social activities, casual conversation, local events, new contacts, communication',
      name: 'category_yellow',
      desc: '',
      args: [],
    );
  }

  /// `Volunteering, support, free items/skills exchange, consulting, assistance, community`
  String get category_orange {
    return Intl.message(
      'Volunteering, support, free items/skills exchange, consulting, assistance, community',
      name: 'category_orange',
      desc: '',
      args: [],
    );
  }

  /// `Technology, learning, education, innovation, brainstorming, ideas, science, software`
  String get category_teal {
    return Intl.message(
      'Technology, learning, education, innovation, brainstorming, ideas, science, software',
      name: 'category_teal',
      desc: '',
      args: [],
    );
  }

  /// `Tap to chat`
  String get tapToChat {
    return Intl.message('Tap to chat', name: 'tapToChat', desc: '', args: []);
  }

  /// `Locations`
  String get locations {
    return Intl.message('Locations', name: 'locations', desc: '', args: []);
  }

  /// `Tap to expand main cluster`
  String get tapToExpandMainCluster {
    return Intl.message(
      'Tap to expand main cluster',
      name: 'tapToExpandMainCluster',
      desc: '',
      args: [],
    );
  }

  /// `Close Locations`
  String get closeLocations {
    return Intl.message(
      'Close Locations',
      name: 'closeLocations',
      desc: '',
      args: [],
    );
  }

  /// `Tap to expand sub-cluster`
  String get tapToExpandSubCluster {
    return Intl.message(
      'Tap to expand sub-cluster',
      name: 'tapToExpandSubCluster',
      desc: '',
      args: [],
    );
  }

  /// `Points of Interest`
  String get pointsOfInterest {
    return Intl.message(
      'Points of Interest',
      name: 'pointsOfInterest',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message('Chat', name: 'chat', desc: '', args: []);
  }

  /// `Type a message...`
  String get typeAMessage {
    return Intl.message(
      'Type a message...',
      name: 'typeAMessage',
      desc: '',
      args: [],
    );
  }

  /// `Error: {errorMessage}`
  String errorWithMessage(Object errorMessage) {
    return Intl.message(
      'Error: $errorMessage',
      name: 'errorWithMessage',
      desc: '',
      args: [errorMessage],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Error during initialization.`
  String get errorDuringInitialization {
    return Intl.message(
      'Error during initialization.',
      name: 'errorDuringInitialization',
      desc: '',
      args: [],
    );
  }

  /// `Your session has expired. Please sign in again.`
  String get apiErrorAuthSessionExpired {
    return Intl.message(
      'Your session has expired. Please sign in again.',
      name: 'apiErrorAuthSessionExpired',
      desc: '',
      args: [],
    );
  }

  /// `The request timed out. Please try again.`
  String get apiErrorTimeout {
    return Intl.message(
      'The request timed out. Please try again.',
      name: 'apiErrorTimeout',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection. Please check your network and try again.`
  String get apiErrorNoInternet {
    return Intl.message(
      'No internet connection. Please check your network and try again.',
      name: 'apiErrorNoInternet',
      desc: '',
      args: [],
    );
  }

  /// `There was an issue with the request. Please check your input and try again.`
  String get apiErrorBadRequest {
    return Intl.message(
      'There was an issue with the request. Please check your input and try again.',
      name: 'apiErrorBadRequest',
      desc: '',
      args: [],
    );
  }

  /// `You do not have permission to perform this action.`
  String get apiErrorForbidden {
    return Intl.message(
      'You do not have permission to perform this action.',
      name: 'apiErrorForbidden',
      desc: '',
      args: [],
    );
  }

  /// `The requested resource was not found.`
  String get apiErrorNotFound {
    return Intl.message(
      'The requested resource was not found.',
      name: 'apiErrorNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Conflict with existing data. Please refresh and try again.`
  String get apiErrorConflict {
    return Intl.message(
      'Conflict with existing data. Please refresh and try again.',
      name: 'apiErrorConflict',
      desc: '',
      args: [],
    );
  }

  /// `Some of the provided data is invalid.`
  String get apiErrorValidation {
    return Intl.message(
      'Some of the provided data is invalid.',
      name: 'apiErrorValidation',
      desc: '',
      args: [],
    );
  }

  /// `Server error. Please try again later.`
  String get apiErrorServer {
    return Intl.message(
      'Server error. Please try again later.',
      name: 'apiErrorServer',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load nearby users right now.`
  String get apiErrorNearbyUsersFallback {
    return Intl.message(
      'Unable to load nearby users right now.',
      name: 'apiErrorNearbyUsersFallback',
      desc: '',
      args: [],
    );
  }

  /// `Unable to search users right now.`
  String get apiErrorSearchUsersFallback {
    return Intl.message(
      'Unable to search users right now.',
      name: 'apiErrorSearchUsersFallback',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load similar users right now.`
  String get apiErrorSimilarUsersFallback {
    return Intl.message(
      'Unable to load similar users right now.',
      name: 'apiErrorSimilarUsersFallback',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load matching users right now.`
  String get apiErrorMatchingUsersFallback {
    return Intl.message(
      'Unable to load matching users right now.',
      name: 'apiErrorMatchingUsersFallback',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load favorite users right now.`
  String get apiErrorFavoriteUsersFallback {
    return Intl.message(
      'Unable to load favorite users right now.',
      name: 'apiErrorFavoriteUsersFallback',
      desc: '',
      args: [],
    );
  }

  /// `What is of interest to you?`
  String get selectYourInterests {
    return Intl.message(
      'What is of interest to you?',
      name: 'selectYourInterests',
      desc: '',
      args: [],
    );
  }

  /// `What do you have to offer?`
  String get selectYourOffers {
    return Intl.message(
      'What do you have to offer?',
      name: 'selectYourOffers',
      desc: '',
      args: [],
    );
  }

  /// `Interested in:`
  String get userInterestedIn {
    return Intl.message(
      'Interested in:',
      name: 'userInterestedIn',
      desc: '',
      args: [],
    );
  }

  /// `Offering:`
  String get userOffers {
    return Intl.message('Offering:', name: 'userOffers', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `User name`
  String get username {
    return Intl.message('User name', name: 'username', desc: '', args: []);
  }

  /// `User ID`
  String get userId {
    return Intl.message('User ID', name: 'userId', desc: '', args: []);
  }

  /// `Onboarding`
  String get onboardingScreenTitle {
    return Intl.message(
      'Onboarding',
      name: 'onboardingScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `How much are you interested in this?`
  String get onboardingScreenQuestion {
    return Intl.message(
      'How much are you interested in this?',
      name: 'onboardingScreenQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finishOnboarding {
    return Intl.message('Finish', name: 'finishOnboarding', desc: '', args: []);
  }

  /// `{count} questions answered`
  String questionsAnswered(Object count) {
    return Intl.message(
      '$count questions answered',
      name: 'questionsAnswered',
      desc: '',
      args: [count],
    );
  }

  /// `Location saved!`
  String get locationSaved {
    return Intl.message(
      'Location saved!',
      name: 'locationSaved',
      desc: '',
      args: [],
    );
  }

  /// `Please select a location first.`
  String get pleaseSelectLocationFirst {
    return Intl.message(
      'Please select a location first.',
      name: 'pleaseSelectLocationFirst',
      desc: '',
      args: [],
    );
  }

  /// `Location not found.`
  String get locationNotFound {
    return Intl.message(
      'Location not found.',
      name: 'locationNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Error finding location: {error}`
  String errorFindingLocation(Object error) {
    return Intl.message(
      'Error finding location: $error',
      name: 'errorFindingLocation',
      desc: '',
      args: [error],
    );
  }

  /// `Select Location`
  String get selectLocation {
    return Intl.message(
      'Select Location',
      name: 'selectLocation',
      desc: '',
      args: [],
    );
  }

  /// `Pick your location`
  String get pickYourLocation {
    return Intl.message(
      'Pick your location',
      name: 'pickYourLocation',
      desc: '',
      args: [],
    );
  }

  /// `Search for a location`
  String get searchForALocation {
    return Intl.message(
      'Search for a location',
      name: 'searchForALocation',
      desc: '',
      args: [],
    );
  }

  /// `Search for a keyword`
  String get searchForAKeyword {
    return Intl.message(
      'Search for a keyword',
      name: 'searchForAKeyword',
      desc: '',
      args: [],
    );
  }

  /// `Save Location`
  String get saveLocation {
    return Intl.message(
      'Save Location',
      name: 'saveLocation',
      desc: '',
      args: [],
    );
  }

  /// `Your location will be set at the marker location`
  String get locationSetAtMarkerInfo {
    return Intl.message(
      'Your location will be set at the marker location',
      name: 'locationSetAtMarkerInfo',
      desc: '',
      args: [],
    );
  }

  /// `User Offline`
  String get chatError_Offline {
    return Intl.message(
      'User Offline',
      name: 'chatError_Offline',
      desc: '',
      args: [],
    );
  }

  /// `Mock POI with id {id} not found in service`
  String mockPoiNotFound(Object id) {
    return Intl.message(
      'Mock POI with id $id not found in service',
      name: 'mockPoiNotFound',
      desc: '',
      args: [id],
    );
  }

  /// `Mock POI with id {id} not found for update`
  String mockPoiNotFoundForUpdate(Object id) {
    return Intl.message(
      'Mock POI with id $id not found for update',
      name: 'mockPoiNotFoundForUpdate',
      desc: '',
      args: [id],
    );
  }

  /// `Submitting...`
  String get submitting {
    return Intl.message(
      'Submitting...',
      name: 'submitting',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `An unknown error occurred.`
  String get anUnknownErrorOccurred {
    return Intl.message(
      'An unknown error occurred.',
      name: 'anUnknownErrorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Submitting offers...`
  String get submittingOffers {
    return Intl.message(
      'Submitting offers...',
      name: 'submittingOffers',
      desc: '',
      args: [],
    );
  }

  /// `Find similar users`
  String get drawer_menu_similar_users {
    return Intl.message(
      'Find similar users',
      name: 'drawer_menu_similar_users',
      desc: '',
      args: [],
    );
  }

  /// `Find complementary users`
  String get drawer_menu_complementary_users {
    return Intl.message(
      'Find complementary users',
      name: 'drawer_menu_complementary_users',
      desc: '',
      args: [],
    );
  }

  /// `Find favorite users`
  String get drawer_menu_favorite_users {
    return Intl.message(
      'Find favorite users',
      name: 'drawer_menu_favorite_users',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTitle {
    return Intl.message('Settings', name: 'settingsTitle', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Conditions`
  String get termsConditionsTitle {
    return Intl.message(
      'Terms & Conditions',
      name: 'termsConditionsTitle',
      desc: '',
      args: [],
    );
  }

  /// `1. Scope`
  String get termsConditionsSectionScopeTitle {
    return Intl.message(
      '1. Scope',
      name: 'termsConditionsSectionScopeTitle',
      desc: '',
      args: [],
    );
  }

  /// `These terms govern your use of Barter App and define user rights and responsibilities.`
  String get termsConditionsSectionScopeContent {
    return Intl.message(
      'These terms govern your use of Barter App and define user rights and responsibilities.',
      name: 'termsConditionsSectionScopeContent',
      desc: '',
      args: [],
    );
  }

  /// `Minimum Age`
  String get termsConditionsSectionMinimumAgeTitle {
    return Intl.message(
      'Minimum Age',
      name: 'termsConditionsSectionMinimumAgeTitle',
      desc: '',
      args: [],
    );
  }

  /// `The app is intended for users aged 16 or older. By registering, you confirm you are at least 16 years old.`
  String get termsConditionsSectionMinimumAgeContent {
    return Intl.message(
      'The app is intended for users aged 16 or older. By registering, you confirm you are at least 16 years old.',
      name: 'termsConditionsSectionMinimumAgeContent',
      desc: '',
      args: [],
    );
  }

  /// `3. Account Use, Recovery and Deletion`
  String get termsConditionsSectionAccountUseTitle {
    return Intl.message(
      '3. Account Use, Recovery and Deletion',
      name: 'termsConditionsSectionAccountUseTitle',
      desc: '',
      args: [],
    );
  }

  /// `You are responsible for maintaining your account security and activities performed through your account. You must provide your e-mail in Profile - Notification Preferences to be able to migrate/recover your account and to request it's deletion if you lose access to your device.`
  String get termsConditionsSectionAccountUseContent {
    return Intl.message(
      'You are responsible for maintaining your account security and activities performed through your account. You must provide your e-mail in Profile - Notification Preferences to be able to migrate/recover your account and to request it\'s deletion if you lose access to your device.',
      name: 'termsConditionsSectionAccountUseContent',
      desc: '',
      args: [],
    );
  }

  /// `4. Prohibited Conduct`
  String get termsConditionsSectionProhibitedConductTitle {
    return Intl.message(
      '4. Prohibited Conduct',
      name: 'termsConditionsSectionProhibitedConductTitle',
      desc: '',
      args: [],
    );
  }

  /// `Fraud, harassment, unlawful content, misuse of other users’ data, and other illegal actions are prohibited.`
  String get termsConditionsSectionProhibitedConductContent {
    return Intl.message(
      'Fraud, harassment, unlawful content, misuse of other users’ data, and other illegal actions are prohibited.',
      name: 'termsConditionsSectionProhibitedConductContent',
      desc: '',
      args: [],
    );
  }

  /// `5. Account Restriction or Termination`
  String get termsConditionsSectionAccountRestrictionTitle {
    return Intl.message(
      '5. Account Restriction or Termination',
      name: 'termsConditionsSectionAccountRestrictionTitle',
      desc: '',
      args: [],
    );
  }

  /// `We may restrict or terminate accounts for violations of these terms or security risks.`
  String get termsConditionsSectionAccountRestrictionContent {
    return Intl.message(
      'We may restrict or terminate accounts for violations of these terms or security risks.',
      name: 'termsConditionsSectionAccountRestrictionContent',
      desc: '',
      args: [],
    );
  }

  /// `6. Liability and Disputes`
  String get termsConditionsSectionLiabilityDisputesTitle {
    return Intl.message(
      '6. Liability and Disputes',
      name: 'termsConditionsSectionLiabilityDisputesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Users are responsible for their own exchanges and interactions. The platform provides an intermediary environment to the extent permitted by law.`
  String get termsConditionsSectionLiabilityDisputesContent {
    return Intl.message(
      'Users are responsible for their own exchanges and interactions. The platform provides an intermediary environment to the extent permitted by law.',
      name: 'termsConditionsSectionLiabilityDisputesContent',
      desc: '',
      args: [],
    );
  }

  /// `8. Child Safety and CSAE Standards`
  String get termsConditionsSectionKidsSafetyTitle {
    return Intl.message(
      '8. Child Safety and CSAE Standards',
      name: 'termsConditionsSectionKidsSafetyTitle',
      desc: '',
      args: [],
    );
  }

  /// `We have zero tolerance for child sexual abuse and exploitation (CSAE), including child sexual abuse material (CSAM), grooming, trafficking, and any sexual exploitation of minors.\n\nThe following are strictly prohibited on this platform:\n- Sharing, requesting, promoting, or storing CSAM\n- Sexualized communication involving minors\n- Grooming, coercion, trafficking, or exploitation of minors\n- Any attempt to use this service to endanger a child\n\nWe may remove content, suspend or terminate accounts, and report relevant cases to competent authorities as required by law. Users can report concerns through in-app reporting tools or by contacting info@bartering.app.\n\nWe review safety reports as quickly as possible and cooperate with lawful requests from authorities regarding CSAE-related violations.`
  String get termsConditionsSectionKidsSafetyContent {
    return Intl.message(
      'We have zero tolerance for child sexual abuse and exploitation (CSAE), including child sexual abuse material (CSAM), grooming, trafficking, and any sexual exploitation of minors.\n\nThe following are strictly prohibited on this platform:\n- Sharing, requesting, promoting, or storing CSAM\n- Sexualized communication involving minors\n- Grooming, coercion, trafficking, or exploitation of minors\n- Any attempt to use this service to endanger a child\n\nWe may remove content, suspend or terminate accounts, and report relevant cases to competent authorities as required by law. Users can report concerns through in-app reporting tools or by contacting info@bartering.app.\n\nWe review safety reports as quickly as possible and cooperate with lawful requests from authorities regarding CSAE-related violations.',
      name: 'termsConditionsSectionKidsSafetyContent',
      desc: '',
      args: [],
    );
  }

  /// `8. Changes to Terms`
  String get termsConditionsSectionChangesTitle {
    return Intl.message(
      '8. Changes to Terms',
      name: 'termsConditionsSectionChangesTitle',
      desc: '',
      args: [],
    );
  }

  /// `We may update these terms from time to time. Continued use of the app after changes means acceptance of the updated terms.`
  String get termsConditionsSectionChangesContent {
    return Intl.message(
      'We may update these terms from time to time. Continued use of the app after changes means acceptance of the updated terms.',
      name: 'termsConditionsSectionChangesContent',
      desc: '',
      args: [],
    );
  }

  /// `Settings saved successfully`
  String get settingsSaved {
    return Intl.message(
      'Settings saved successfully',
      name: 'settingsSaved',
      desc: '',
      args: [],
    );
  }

  /// `Search Settings`
  String get settingsSearchSection {
    return Intl.message(
      'Search Settings',
      name: 'settingsSearchSection',
      desc: '',
      args: [],
    );
  }

  /// `Center Point of Search`
  String get settingsSearchCenterPointTitle {
    return Intl.message(
      'Center Point of Search',
      name: 'settingsSearchCenterPointTitle',
      desc: '',
      args: [],
    );
  }

  /// `Choose the center point for nearby user searches`
  String get settingsSearchCenterPointDescription {
    return Intl.message(
      'Choose the center point for nearby user searches',
      name: 'settingsSearchCenterPointDescription',
      desc: '',
      args: [],
    );
  }

  /// `User Location`
  String get settingsSearchCenterUserLocation {
    return Intl.message(
      'User Location',
      name: 'settingsSearchCenterUserLocation',
      desc: '',
      args: [],
    );
  }

  /// `Search from your saved location`
  String get settingsSearchCenterUserLocationDescription {
    return Intl.message(
      'Search from your saved location',
      name: 'settingsSearchCenterUserLocationDescription',
      desc: '',
      args: [],
    );
  }

  /// `Map Center`
  String get settingsSearchCenterMapCenter {
    return Intl.message(
      'Map Center',
      name: 'settingsSearchCenterMapCenter',
      desc: '',
      args: [],
    );
  }

  /// `Search from the current map center`
  String get settingsSearchCenterMapCenterDescription {
    return Intl.message(
      'Search from the current map center',
      name: 'settingsSearchCenterMapCenterDescription',
      desc: '',
      args: [],
    );
  }

  /// `Nearby Users Search Radius`
  String get settingsNearbyUsersRadiusTitle {
    return Intl.message(
      'Nearby Users Search Radius',
      name: 'settingsNearbyUsersRadiusTitle',
      desc: '',
      args: [],
    );
  }

  /// `How far to search for nearby users`
  String get settingsNearbyUsersRadiusDescription {
    return Intl.message(
      'How far to search for nearby users',
      name: 'settingsNearbyUsersRadiusDescription',
      desc: '',
      args: [],
    );
  }

  /// `Keyword Search Radius`
  String get settingsKeywordSearchRadiusTitle {
    return Intl.message(
      'Keyword Search Radius',
      name: 'settingsKeywordSearchRadiusTitle',
      desc: '',
      args: [],
    );
  }

  /// `Search radius when using keyword search`
  String get settingsKeywordSearchRadiusDescription {
    return Intl.message(
      'Search radius when using keyword search',
      name: 'settingsKeywordSearchRadiusDescription',
      desc: '',
      args: [],
    );
  }

  /// `Keyword Search Weight`
  String get settingsKeywordSearchWeightTitle {
    return Intl.message(
      'Keyword Search Weight',
      name: 'settingsKeywordSearchWeightTitle',
      desc: '',
      args: [],
    );
  }

  /// `Weight parameter for keyword search relevance (10-100)`
  String get settingsKeywordSearchWeightDescription {
    return Intl.message(
      'Weight parameter for keyword search relevance (10-100)',
      name: 'settingsKeywordSearchWeightDescription',
      desc: '',
      args: [],
    );
  }

  /// `Display Search Results As List`
  String get settingsShowResultsAsListTitle {
    return Intl.message(
      'Display Search Results As List',
      name: 'settingsShowResultsAsListTitle',
      desc: '',
      args: [],
    );
  }

  /// `Show keyword and nearby search results in a list view instead of on the map`
  String get settingsShowResultsAsListDescription {
    return Intl.message(
      'Show keyword and nearby search results in a list view instead of on the map',
      name: 'settingsShowResultsAsListDescription',
      desc: '',
      args: [],
    );
  }

  /// `Show search results on the map (default)`
  String get settingsShowResultsOnMapDescription {
    return Intl.message(
      'Show search results on the map (default)',
      name: 'settingsShowResultsOnMapDescription',
      desc: '',
      args: [],
    );
  }

  /// `Show search results in a list view`
  String get settingsShowResultsAsListViewDescription {
    return Intl.message(
      'Show search results in a list view',
      name: 'settingsShowResultsAsListViewDescription',
      desc: '',
      args: [],
    );
  }

  /// `Set Up PIN`
  String get setPinTitle {
    return Intl.message('Set Up PIN', name: 'setPinTitle', desc: '', args: []);
  }

  /// `Create a 4-6 digit PIN to secure your app`
  String get setPinDescription {
    return Intl.message(
      'Create a 4-6 digit PIN to secure your app',
      name: 'setPinDescription',
      desc: '',
      args: [],
    );
  }

  /// `Set PIN`
  String get setPinButton {
    return Intl.message('Set PIN', name: 'setPinButton', desc: '', args: []);
  }

  /// `Skip for now`
  String get skipPinButton {
    return Intl.message(
      'Skip for now',
      name: 'skipPinButton',
      desc: '',
      args: [],
    );
  }

  /// `PIN`
  String get pinLabel {
    return Intl.message('PIN', name: 'pinLabel', desc: '', args: []);
  }

  /// `Enter 4-6 digits`
  String get pinHint {
    return Intl.message(
      'Enter 4-6 digits',
      name: 'pinHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm PIN`
  String get confirmPinLabel {
    return Intl.message(
      'Confirm PIN',
      name: 'confirmPinLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a PIN`
  String get pinErrorEmpty {
    return Intl.message(
      'Please enter a PIN',
      name: 'pinErrorEmpty',
      desc: '',
      args: [],
    );
  }

  /// `PIN must be at least 4 digits`
  String get pinErrorTooShort {
    return Intl.message(
      'PIN must be at least 4 digits',
      name: 'pinErrorTooShort',
      desc: '',
      args: [],
    );
  }

  /// `PINs do not match`
  String get pinErrorMismatch {
    return Intl.message(
      'PINs do not match',
      name: 'pinErrorMismatch',
      desc: '',
      args: [],
    );
  }

  /// `PIN set successfully`
  String get pinSetSuccessfully {
    return Intl.message(
      'PIN set successfully',
      name: 'pinSetSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Enter PIN`
  String get enterPinTitle {
    return Intl.message('Enter PIN', name: 'enterPinTitle', desc: '', args: []);
  }

  /// `Enter your PIN to unlock the app`
  String get enterPinDescription {
    return Intl.message(
      'Enter your PIN to unlock the app',
      name: 'enterPinDescription',
      desc: '',
      args: [],
    );
  }

  /// `Unlock`
  String get unlockButton {
    return Intl.message('Unlock', name: 'unlockButton', desc: '', args: []);
  }

  /// `Incorrect PIN (Attempt {attempts})`
  String pinErrorIncorrect(int attempts) {
    return Intl.message(
      'Incorrect PIN (Attempt $attempts)',
      name: 'pinErrorIncorrect',
      desc: '',
      args: [attempts],
    );
  }

  /// `Security`
  String get settingsSecuritySection {
    return Intl.message(
      'Security',
      name: 'settingsSecuritySection',
      desc: '',
      args: [],
    );
  }

  /// `PIN Protection`
  String get settingsPinTitle {
    return Intl.message(
      'PIN Protection',
      name: 'settingsPinTitle',
      desc: '',
      args: [],
    );
  }

  /// `App is protected with PIN`
  String get settingsPinEnabledDescription {
    return Intl.message(
      'App is protected with PIN',
      name: 'settingsPinEnabledDescription',
      desc: '',
      args: [],
    );
  }

  /// `Enable PIN for extra security`
  String get settingsPinDisabledDescription {
    return Intl.message(
      'Enable PIN for extra security',
      name: 'settingsPinDisabledDescription',
      desc: '',
      args: [],
    );
  }

  /// `Change PIN`
  String get settingsChangePinButton {
    return Intl.message(
      'Change PIN',
      name: 'settingsChangePinButton',
      desc: '',
      args: [],
    );
  }

  /// `Update your security PIN`
  String get settingsChangePinDescription {
    return Intl.message(
      'Update your security PIN',
      name: 'settingsChangePinDescription',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get settingsLanguageSection {
    return Intl.message(
      'Language',
      name: 'settingsLanguageSection',
      desc: '',
      args: [],
    );
  }

  /// `App Language`
  String get settingsLanguageTitle {
    return Intl.message(
      'App Language',
      name: 'settingsLanguageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Choose your preferred language for the app`
  String get settingsLanguageDescription {
    return Intl.message(
      'Choose your preferred language for the app',
      name: 'settingsLanguageDescription',
      desc: '',
      args: [],
    );
  }

  /// `Please restart the app to apply language changes`
  String get settingsLanguageRestartMessage {
    return Intl.message(
      'Please restart the app to apply language changes',
      name: 'settingsLanguageRestartMessage',
      desc: '',
      args: [],
    );
  }

  /// `Setup Security Question`
  String get setupSecurityQuestion {
    return Intl.message(
      'Setup Security Question',
      name: 'setupSecurityQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Set up a security question to help recover your PIN if you forget it`
  String get securityQuestionDescription {
    return Intl.message(
      'Set up a security question to help recover your PIN if you forget it',
      name: 'securityQuestionDescription',
      desc: '',
      args: [],
    );
  }

  /// `Select a question`
  String get selectSecurityQuestion {
    return Intl.message(
      'Select a question',
      name: 'selectSecurityQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Your Answer`
  String get yourAnswer {
    return Intl.message('Your Answer', name: 'yourAnswer', desc: '', args: []);
  }

  /// `Enter your answer`
  String get answerHint {
    return Intl.message(
      'Enter your answer',
      name: 'answerHint',
      desc: '',
      args: [],
    );
  }

  /// `Please select a security question`
  String get pleaseSelectQuestion {
    return Intl.message(
      'Please select a security question',
      name: 'pleaseSelectQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your answer`
  String get pleaseEnterAnswer {
    return Intl.message(
      'Please enter your answer',
      name: 'pleaseEnterAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Answer must be at least 2 characters`
  String get answerTooShort {
    return Intl.message(
      'Answer must be at least 2 characters',
      name: 'answerTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Note: Answers are case-insensitive`
  String get securityAnswerNote {
    return Intl.message(
      'Note: Answers are case-insensitive',
      name: 'securityAnswerNote',
      desc: '',
      args: [],
    );
  }

  /// `Save Security Question`
  String get saveSecurityQuestion {
    return Intl.message(
      'Save Security Question',
      name: 'saveSecurityQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Security question saved successfully`
  String get securityQuestionSaved {
    return Intl.message(
      'Security question saved successfully',
      name: 'securityQuestionSaved',
      desc: '',
      args: [],
    );
  }

  /// `What was the name of your first pet?`
  String get securityQuestion1 {
    return Intl.message(
      'What was the name of your first pet?',
      name: 'securityQuestion1',
      desc: '',
      args: [],
    );
  }

  /// `What city were you born in?`
  String get securityQuestion2 {
    return Intl.message(
      'What city were you born in?',
      name: 'securityQuestion2',
      desc: '',
      args: [],
    );
  }

  /// `What is your mother's maiden name?`
  String get securityQuestion3 {
    return Intl.message(
      'What is your mother\'s maiden name?',
      name: 'securityQuestion3',
      desc: '',
      args: [],
    );
  }

  /// `What was the name of your elementary school?`
  String get securityQuestion4 {
    return Intl.message(
      'What was the name of your elementary school?',
      name: 'securityQuestion4',
      desc: '',
      args: [],
    );
  }

  /// `What is your favorite book?`
  String get securityQuestion5 {
    return Intl.message(
      'What is your favorite book?',
      name: 'securityQuestion5',
      desc: '',
      args: [],
    );
  }

  /// `Answer Security Question`
  String get answerSecurityQuestion {
    return Intl.message(
      'Answer Security Question',
      name: 'answerSecurityQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Enter your answer`
  String get enterYourAnswer {
    return Intl.message(
      'Enter your answer',
      name: 'enterYourAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Verify and Reset PIN`
  String get verifyAndResetPin {
    return Intl.message(
      'Verify and Reset PIN',
      name: 'verifyAndResetPin',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect answer (Attempt {attempts})`
  String securityAnswerIncorrect(int attempts) {
    return Intl.message(
      'Incorrect answer (Attempt $attempts)',
      name: 'securityAnswerIncorrect',
      desc: '',
      args: [attempts],
    );
  }

  /// `PIN reset successfully`
  String get pinResetSuccessfully {
    return Intl.message(
      'PIN reset successfully',
      name: 'pinResetSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `No security question set up`
  String get noSecurityQuestionSet {
    return Intl.message(
      'No security question set up',
      name: 'noSecurityQuestionSet',
      desc: '',
      args: [],
    );
  }

  /// `Please contact support for PIN reset assistance`
  String get contactSupportForPinReset {
    return Intl.message(
      'Please contact support for PIN reset assistance',
      name: 'contactSupportForPinReset',
      desc: '',
      args: [],
    );
  }

  /// `Manage Security Question`
  String get manageSecurityQuestion {
    return Intl.message(
      'Manage Security Question',
      name: 'manageSecurityQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Security question is set up`
  String get securityQuestionSet {
    return Intl.message(
      'Security question is set up',
      name: 'securityQuestionSet',
      desc: '',
      args: [],
    );
  }

  /// `No security question configured`
  String get noSecurityQuestion {
    return Intl.message(
      'No security question configured',
      name: 'noSecurityQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Setup Security Question`
  String get setupSecurityQuestionButton {
    return Intl.message(
      'Setup Security Question',
      name: 'setupSecurityQuestionButton',
      desc: '',
      args: [],
    );
  }

  /// `Change Security Question`
  String get changeSecurityQuestion {
    return Intl.message(
      'Change Security Question',
      name: 'changeSecurityQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Manage Postings`
  String get managePostings {
    return Intl.message(
      'Manage Postings',
      name: 'managePostings',
      desc: '',
      args: [],
    );
  }

  /// `No active postings`
  String get noActivePostings {
    return Intl.message(
      'No active postings',
      name: 'noActivePostings',
      desc: '',
      args: [],
    );
  }

  /// `Delete Posting`
  String get deletePosting {
    return Intl.message(
      'Delete Posting',
      name: 'deletePosting',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this posting?`
  String get deletePostingConfirmation {
    return Intl.message(
      'Are you sure you want to delete this posting?',
      name: 'deletePostingConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Posting deleted successfully`
  String get postingDeleted {
    return Intl.message(
      'Posting deleted successfully',
      name: 'postingDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Offer`
  String get offer {
    return Intl.message('Offer', name: 'offer', desc: '', args: []);
  }

  /// `Need`
  String get need {
    return Intl.message('Need', name: 'need', desc: '', args: []);
  }

  /// `Expires`
  String get expires {
    return Intl.message('Expires', name: 'expires', desc: '', args: []);
  }

  /// `Edit Posting`
  String get editPosting {
    return Intl.message(
      'Edit Posting',
      name: 'editPosting',
      desc: '',
      args: [],
    );
  }

  /// `Posting updated successfully`
  String get postingUpdatedSuccess {
    return Intl.message(
      'Posting updated successfully',
      name: 'postingUpdatedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Update Posting`
  String get updatePosting {
    return Intl.message(
      'Update Posting',
      name: 'updatePosting',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message('Continue', name: 'continueButton', desc: '', args: []);
  }

  /// `Nature & Outdoors`
  String get categoryNatureTitle {
    return Intl.message(
      'Nature & Outdoors',
      name: 'categoryNatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `Gardening, outdoors, forests, camping, environmentalism, cleanup, animals`
  String get categoryNatureDescription {
    return Intl.message(
      'Gardening, outdoors, forests, camping, environmentalism, cleanup, animals',
      name: 'categoryNatureDescription',
      desc: '',
      args: [],
    );
  }

  /// `Active & Social`
  String get categoryActiveTitle {
    return Intl.message(
      'Active & Social',
      name: 'categoryActiveTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sports, partying, dancing, active lifestyle, physical work, mechanisms`
  String get categoryActiveDescription {
    return Intl.message(
      'Sports, partying, dancing, active lifestyle, physical work, mechanisms',
      name: 'categoryActiveDescription',
      desc: '',
      args: [],
    );
  }

  /// `Business & Finance`
  String get categoryBusinessTitle {
    return Intl.message(
      'Business & Finance',
      name: 'categoryBusinessTitle',
      desc: '',
      args: [],
    );
  }

  /// `Strictly business, paid work, networking, money matters, networking`
  String get categoryBusinessDescription {
    return Intl.message(
      'Strictly business, paid work, networking, money matters, networking',
      name: 'categoryBusinessDescription',
      desc: '',
      args: [],
    );
  }

  /// `Arts & Philosophy`
  String get categoryArtsTitle {
    return Intl.message(
      'Arts & Philosophy',
      name: 'categoryArtsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Art, spirituality, philosophy`
  String get categoryArtsDescription {
    return Intl.message(
      'Art, spirituality, philosophy',
      name: 'categoryArtsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Communication & Chat`
  String get categoryCommTitle {
    return Intl.message(
      'Communication & Chat',
      name: 'categoryCommTitle',
      desc: '',
      args: [],
    );
  }

  /// `Misc/Communication, Chat`
  String get categoryCommDescription {
    return Intl.message(
      'Misc/Communication, Chat',
      name: 'categoryCommDescription',
      desc: '',
      args: [],
    );
  }

  /// `Community & Volunteering`
  String get categoryCommunityTitle {
    return Intl.message(
      'Community & Volunteering',
      name: 'categoryCommunityTitle',
      desc: '',
      args: [],
    );
  }

  /// `Open to help out for free/non-specific exchange`
  String get categoryCommunityDescription {
    return Intl.message(
      'Open to help out for free/non-specific exchange',
      name: 'categoryCommunityDescription',
      desc: '',
      args: [],
    );
  }

  /// `Technology & Learning`
  String get categoryTechTitle {
    return Intl.message(
      'Technology & Learning',
      name: 'categoryTechTitle',
      desc: '',
      args: [],
    );
  }

  /// `Technology, learning, innovation`
  String get categoryTechDescription {
    return Intl.message(
      'Technology, learning, innovation',
      name: 'categoryTechDescription',
      desc: '',
      args: [],
    );
  }

  /// `Add your own keywords`
  String get addYourOwnKeywords {
    return Intl.message(
      'Add your own keywords',
      name: 'addYourOwnKeywords',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your PIN`
  String get enterYourPin {
    return Intl.message(
      'Enter Your PIN',
      name: 'enterYourPin',
      desc: '',
      args: [],
    );
  }

  /// `Please set up a 5-digit PIN for security`
  String get pinSetupDescription {
    return Intl.message(
      'Please set up a 5-digit PIN for security',
      name: 'pinSetupDescription',
      desc: '',
      args: [],
    );
  }

  /// `Forgot PIN?`
  String get forgotPin {
    return Intl.message('Forgot PIN?', name: 'forgotPin', desc: '', args: []);
  }

  /// `Your PIN has been successfully reset.`
  String get pinResetSuccess {
    return Intl.message(
      'Your PIN has been successfully reset.',
      name: 'pinResetSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Reset Your PIN`
  String get resetYourPin {
    return Intl.message(
      'Reset Your PIN',
      name: 'resetYourPin',
      desc: '',
      args: [],
    );
  }

  /// `Enter a new 5-digit PIN`
  String get enterNewPinDescription {
    return Intl.message(
      'Enter a new 5-digit PIN',
      name: 'enterNewPinDescription',
      desc: '',
      args: [],
    );
  }

  /// `Google Sign-In not implemented.`
  String get googleSignInNotImplemented {
    return Intl.message(
      'Google Sign-In not implemented.',
      name: 'googleSignInNotImplemented',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email.`
  String get pleaseEnterValidEmail {
    return Intl.message(
      'Please enter a valid email.',
      name: 'pleaseEnterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a 5-digit PIN.`
  String get pleaseEnter5DigitPin {
    return Intl.message(
      'Please enter a 5-digit PIN.',
      name: 'pleaseEnter5DigitPin',
      desc: '',
      args: [],
    );
  }

  /// `Your account has been set up!`
  String get accountSetupSuccess {
    return Intl.message(
      'Your account has been set up!',
      name: 'accountSetupSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Set Up Account`
  String get setUpAccount {
    return Intl.message(
      'Set Up Account',
      name: 'setUpAccount',
      desc: '',
      args: [],
    );
  }

  /// `OR`
  String get or {
    return Intl.message('OR', name: 'or', desc: '', args: []);
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Create a 5-digit PIN`
  String get create5DigitPin {
    return Intl.message(
      'Create a 5-digit PIN',
      name: 'create5DigitPin',
      desc: '',
      args: [],
    );
  }

  /// `Complete Setup`
  String get completeSetup {
    return Intl.message(
      'Complete Setup',
      name: 'completeSetup',
      desc: '',
      args: [],
    );
  }

  /// `If an account exists, a reset link has been sent.`
  String get resetLinkSentMessage {
    return Intl.message(
      'If an account exists, a reset link has been sent.',
      name: 'resetLinkSentMessage',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address to receive a PIN reset link.`
  String get forgotPinSubtitle {
    return Intl.message(
      'Enter your email address to receive a PIN reset link.',
      name: 'forgotPinSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get pleaseEnterValidEmailAddress {
    return Intl.message(
      'Please enter a valid email address',
      name: 'pleaseEnterValidEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get sendResetLink {
    return Intl.message(
      'Send Reset Link',
      name: 'sendResetLink',
      desc: '',
      args: [],
    );
  }

  /// `Generate Avatar`
  String get generateAvatar {
    return Intl.message(
      'Generate Avatar',
      name: 'generateAvatar',
      desc: '',
      args: [],
    );
  }

  /// `Skin`
  String get skin {
    return Intl.message('Skin', name: 'skin', desc: '', args: []);
  }

  /// `Hair Style`
  String get hairStyle {
    return Intl.message('Hair Style', name: 'hairStyle', desc: '', args: []);
  }

  /// `Hair Color`
  String get hairColor {
    return Intl.message('Hair Color', name: 'hairColor', desc: '', args: []);
  }

  /// `Eyes`
  String get eyes {
    return Intl.message('Eyes', name: 'eyes', desc: '', args: []);
  }

  /// `Nose`
  String get nose {
    return Intl.message('Nose', name: 'nose', desc: '', args: []);
  }

  /// `Mouth`
  String get mouth {
    return Intl.message('Mouth', name: 'mouth', desc: '', args: []);
  }

  /// `Style {number}`
  String styleNumber(Object number) {
    return Intl.message(
      'Style $number',
      name: 'styleNumber',
      desc: '',
      args: [number],
    );
  }

  /// `Randomize`
  String get randomize {
    return Intl.message('Randomize', name: 'randomize', desc: '', args: []);
  }

  /// `Save & Continue`
  String get saveAndContinue {
    return Intl.message(
      'Save & Continue',
      name: 'saveAndContinue',
      desc: '',
      args: [],
    );
  }

  /// `Copied to clipboard`
  String get copiedToClipboard {
    return Intl.message(
      'Copied to clipboard',
      name: 'copiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Generate Crypto Wallet`
  String get generateCryptoWallet {
    return Intl.message(
      'Generate Crypto Wallet',
      name: 'generateCryptoWallet',
      desc: '',
      args: [],
    );
  }

  /// `Generate Wallet`
  String get generateWallet {
    return Intl.message(
      'Generate Wallet',
      name: 'generateWallet',
      desc: '',
      args: [],
    );
  }

  /// `Public Key`
  String get publicKey {
    return Intl.message('Public Key', name: 'publicKey', desc: '', args: []);
  }

  /// `Private Key`
  String get privateKey {
    return Intl.message('Private Key', name: 'privateKey', desc: '', args: []);
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `3D printing`
  String get attr_3d_printing {
    return Intl.message(
      '3D printing',
      name: 'attr_3d_printing',
      desc: '',
      args: [],
    );
  }

  /// `Artificial Intelligence`
  String get attr_artificial_intelligence {
    return Intl.message(
      'Artificial Intelligence',
      name: 'attr_artificial_intelligence',
      desc: '',
      args: [],
    );
  }

  /// `Acting`
  String get attr_acting {
    return Intl.message('Acting', name: 'attr_acting', desc: '', args: []);
  }

  /// `Animation`
  String get attr_animation {
    return Intl.message(
      'Animation',
      name: 'attr_animation',
      desc: '',
      args: [],
    );
  }

  /// `Baking`
  String get attr_baking {
    return Intl.message('Baking', name: 'attr_baking', desc: '', args: []);
  }

  /// `Beekeeping`
  String get attr_beekeeping {
    return Intl.message(
      'Beekeeping',
      name: 'attr_beekeeping',
      desc: '',
      args: [],
    );
  }

  /// `Board games`
  String get attr_board_games {
    return Intl.message(
      'Board games',
      name: 'attr_board_games',
      desc: '',
      args: [],
    );
  }

  /// `Books`
  String get attr_books {
    return Intl.message('Books', name: 'attr_books', desc: '', args: []);
  }

  /// `Bowling`
  String get attr_bowling {
    return Intl.message('Bowling', name: 'attr_bowling', desc: '', args: []);
  }

  /// `Breadmaking`
  String get attr_breadmaking {
    return Intl.message(
      'Breadmaking',
      name: 'attr_breadmaking',
      desc: '',
      args: [],
    );
  }

  /// `Construction`
  String get attr_construction {
    return Intl.message(
      'Construction',
      name: 'attr_construction',
      desc: '',
      args: [],
    );
  }

  /// `Car maintenance`
  String get attr_car_maintenance {
    return Intl.message(
      'Car maintenance',
      name: 'attr_car_maintenance',
      desc: '',
      args: [],
    );
  }

  /// `Card games`
  String get attr_card_games {
    return Intl.message(
      'Card games',
      name: 'attr_card_games',
      desc: '',
      args: [],
    );
  }

  /// `Ceramics`
  String get attr_ceramics {
    return Intl.message('Ceramics', name: 'attr_ceramics', desc: '', args: []);
  }

  /// `Charity work`
  String get attr_charity_work {
    return Intl.message(
      'Charity work',
      name: 'attr_charity_work',
      desc: '',
      args: [],
    );
  }

  /// `Chess`
  String get attr_chess {
    return Intl.message('Chess', name: 'attr_chess', desc: '', args: []);
  }

  /// `Cleaning`
  String get attr_cleaning {
    return Intl.message('Cleaning', name: 'attr_cleaning', desc: '', args: []);
  }

  /// `Clothesmaking`
  String get attr_clothesmaking {
    return Intl.message(
      'Clothesmaking',
      name: 'attr_clothesmaking',
      desc: '',
      args: [],
    );
  }

  /// `Software development`
  String get attr_software_development {
    return Intl.message(
      'Software development',
      name: 'attr_software_development',
      desc: '',
      args: [],
    );
  }

  /// `Cooking`
  String get attr_cooking {
    return Intl.message('Cooking', name: 'attr_cooking', desc: '', args: []);
  }

  /// `Couponing`
  String get attr_couponing {
    return Intl.message(
      'Couponing',
      name: 'attr_couponing',
      desc: '',
      args: [],
    );
  }

  /// `Crocheting`
  String get attr_crocheting {
    return Intl.message(
      'Crocheting',
      name: 'attr_crocheting',
      desc: '',
      args: [],
    );
  }

  /// `Cross-stitch`
  String get attr_cross_stitch {
    return Intl.message(
      'Cross-stitch',
      name: 'attr_cross_stitch',
      desc: '',
      args: [],
    );
  }

  /// `Digital arts`
  String get attr_digital_arts {
    return Intl.message(
      'Digital arts',
      name: 'attr_digital_arts',
      desc: '',
      args: [],
    );
  }

  /// `DJing`
  String get attr_dj_ing {
    return Intl.message('DJing', name: 'attr_dj_ing', desc: '', args: []);
  }

  /// `DIY`
  String get attr_diy {
    return Intl.message('DIY', name: 'attr_diy', desc: '', args: []);
  }

  /// `Drawing`
  String get attr_drawing {
    return Intl.message('Drawing', name: 'attr_drawing', desc: '', args: []);
  }

  /// `Electronics`
  String get attr_electronics {
    return Intl.message(
      'Electronics',
      name: 'attr_electronics',
      desc: '',
      args: [],
    );
  }

  /// `Embroidery`
  String get attr_embroidery {
    return Intl.message(
      'Embroidery',
      name: 'attr_embroidery',
      desc: '',
      args: [],
    );
  }

  /// `Engraving`
  String get attr_engraving {
    return Intl.message(
      'Engraving',
      name: 'attr_engraving',
      desc: '',
      args: [],
    );
  }

  /// `Event hosting`
  String get attr_event_hosting {
    return Intl.message(
      'Event hosting',
      name: 'attr_event_hosting',
      desc: '',
      args: [],
    );
  }

  /// `Fashion design`
  String get attr_fashion_design {
    return Intl.message(
      'Fashion design',
      name: 'attr_fashion_design',
      desc: '',
      args: [],
    );
  }

  /// `Flower arranging`
  String get attr_flower_arranging {
    return Intl.message(
      'Flower arranging',
      name: 'attr_flower_arranging',
      desc: '',
      args: [],
    );
  }

  /// `Furniture assembly`
  String get attr_furniture_assembly {
    return Intl.message(
      'Furniture assembly',
      name: 'attr_furniture_assembly',
      desc: '',
      args: [],
    );
  }

  /// `Gaming`
  String get attr_gaming {
    return Intl.message('Gaming', name: 'attr_gaming', desc: '', args: []);
  }

  /// `Hacking`
  String get attr_hacking {
    return Intl.message('Hacking', name: 'attr_hacking', desc: '', args: []);
  }

  /// `Home improvement`
  String get attr_home_improvement {
    return Intl.message(
      'Home improvement',
      name: 'attr_home_improvement',
      desc: '',
      args: [],
    );
  }

  /// `Homebrewing`
  String get attr_homebrewing {
    return Intl.message(
      'Homebrewing',
      name: 'attr_homebrewing',
      desc: '',
      args: [],
    );
  }

  /// `Houseplant care`
  String get attr_houseplant_care {
    return Intl.message(
      'Houseplant care',
      name: 'attr_houseplant_care',
      desc: '',
      args: [],
    );
  }

  /// `Home decor`
  String get attr_home_decor {
    return Intl.message(
      'Home decor',
      name: 'attr_home_decor',
      desc: '',
      args: [],
    );
  }

  /// `Jewelry`
  String get attr_jewelry {
    return Intl.message('Jewelry', name: 'attr_jewelry', desc: '', args: []);
  }

  /// `Knitting`
  String get attr_knitting {
    return Intl.message('Knitting', name: 'attr_knitting', desc: '', args: []);
  }

  /// `Kombucha`
  String get attr_kombucha {
    return Intl.message('Kombucha', name: 'attr_kombucha', desc: '', args: []);
  }

  /// `Leather crafting`
  String get attr_leather_crafting {
    return Intl.message(
      'Leather crafting',
      name: 'attr_leather_crafting',
      desc: '',
      args: [],
    );
  }

  /// `Machining`
  String get attr_machining {
    return Intl.message(
      'Machining',
      name: 'attr_machining',
      desc: '',
      args: [],
    );
  }

  /// `Magic`
  String get attr_magic {
    return Intl.message('Magic', name: 'attr_magic', desc: '', args: []);
  }

  /// `Makeup`
  String get attr_makeup {
    return Intl.message('Makeup', name: 'attr_makeup', desc: '', args: []);
  }

  /// `Massage`
  String get attr_massage {
    return Intl.message('Massage', name: 'attr_massage', desc: '', args: []);
  }

  /// `Metalworking`
  String get attr_metalworking {
    return Intl.message(
      'Metalworking',
      name: 'attr_metalworking',
      desc: '',
      args: [],
    );
  }

  /// `Painting`
  String get attr_painting {
    return Intl.message('Painting', name: 'attr_painting', desc: '', args: []);
  }

  /// `Photography`
  String get attr_photography {
    return Intl.message(
      'Photography',
      name: 'attr_photography',
      desc: '',
      args: [],
    );
  }

  /// `Pottery`
  String get attr_pottery {
    return Intl.message('Pottery', name: 'attr_pottery', desc: '', args: []);
  }

  /// `Workout planning`
  String get attr_workout_planning {
    return Intl.message(
      'Workout planning',
      name: 'attr_workout_planning',
      desc: '',
      args: [],
    );
  }

  /// `Quilting`
  String get attr_quilting {
    return Intl.message('Quilting', name: 'attr_quilting', desc: '', args: []);
  }

  /// `Gadgets`
  String get attr_gadgets {
    return Intl.message('Gadgets', name: 'attr_gadgets', desc: '', args: []);
  }

  /// `Robotics`
  String get attr_robotics {
    return Intl.message('Robotics', name: 'attr_robotics', desc: '', args: []);
  }

  /// `Sculpting`
  String get attr_sculpting {
    return Intl.message(
      'Sculpting',
      name: 'attr_sculpting',
      desc: '',
      args: [],
    );
  }

  /// `Sewing`
  String get attr_sewing {
    return Intl.message('Sewing', name: 'attr_sewing', desc: '', args: []);
  }

  /// `Shoemaking`
  String get attr_shoemaking {
    return Intl.message(
      'Shoemaking',
      name: 'attr_shoemaking',
      desc: '',
      args: [],
    );
  }

  /// `Social media`
  String get attr_social_media {
    return Intl.message(
      'Social media',
      name: 'attr_social_media',
      desc: '',
      args: [],
    );
  }

  /// `Stand-up comedy`
  String get attr_stand_up_comedy {
    return Intl.message(
      'Stand-up comedy',
      name: 'attr_stand_up_comedy',
      desc: '',
      args: [],
    );
  }

  /// `Video editing`
  String get attr_video_editing {
    return Intl.message(
      'Video editing',
      name: 'attr_video_editing',
      desc: '',
      args: [],
    );
  }

  /// `Video game developing`
  String get attr_video_game_developing {
    return Intl.message(
      'Video game developing',
      name: 'attr_video_game_developing',
      desc: '',
      args: [],
    );
  }

  /// `Weaving`
  String get attr_weaving {
    return Intl.message('Weaving', name: 'attr_weaving', desc: '', args: []);
  }

  /// `Weight training`
  String get attr_weight_training {
    return Intl.message(
      'Weight training',
      name: 'attr_weight_training',
      desc: '',
      args: [],
    );
  }

  /// `Welding`
  String get attr_welding {
    return Intl.message('Welding', name: 'attr_welding', desc: '', args: []);
  }

  /// `Wood carving`
  String get attr_wood_carving {
    return Intl.message(
      'Wood carving',
      name: 'attr_wood_carving',
      desc: '',
      args: [],
    );
  }

  /// `Woodworking`
  String get attr_woodworking {
    return Intl.message(
      'Woodworking',
      name: 'attr_woodworking',
      desc: '',
      args: [],
    );
  }

  /// `Writing`
  String get attr_writing {
    return Intl.message('Writing', name: 'attr_writing', desc: '', args: []);
  }

  /// `Yoga`
  String get attr_yoga {
    return Intl.message('Yoga', name: 'attr_yoga', desc: '', args: []);
  }

  /// `Zumba`
  String get attr_zumba {
    return Intl.message('Zumba', name: 'attr_zumba', desc: '', args: []);
  }

  /// `Hiking`
  String get attr_hiking {
    return Intl.message('Hiking', name: 'attr_hiking', desc: '', args: []);
  }

  /// `Gardening`
  String get attr_gardening {
    return Intl.message(
      'Gardening',
      name: 'attr_gardening',
      desc: '',
      args: [],
    );
  }

  /// `Music production`
  String get attr_music_production {
    return Intl.message(
      'Music production',
      name: 'attr_music_production',
      desc: '',
      args: [],
    );
  }

  /// `Dancing`
  String get attr_dancing {
    return Intl.message('Dancing', name: 'attr_dancing', desc: '', args: []);
  }

  /// `Traveling`
  String get attr_traveling {
    return Intl.message(
      'Traveling',
      name: 'attr_traveling',
      desc: '',
      args: [],
    );
  }

  /// `Coding`
  String get attr_coding {
    return Intl.message('Coding', name: 'attr_coding', desc: '', args: []);
  }

  /// `Movies`
  String get attr_movies {
    return Intl.message('Movies', name: 'attr_movies', desc: '', args: []);
  }

  /// `Volunteering`
  String get attr_volunteering {
    return Intl.message(
      'Volunteering',
      name: 'attr_volunteering',
      desc: '',
      args: [],
    );
  }

  /// `Meditation`
  String get attr_meditation {
    return Intl.message(
      'Meditation',
      name: 'attr_meditation',
      desc: '',
      args: [],
    );
  }

  /// `Crafting`
  String get attr_crafting {
    return Intl.message('Crafting', name: 'attr_crafting', desc: '', args: []);
  }

  /// `Sales`
  String get attr_sales {
    return Intl.message('Sales', name: 'attr_sales', desc: '', args: []);
  }

  /// `Networking`
  String get attr_networking {
    return Intl.message(
      'Networking',
      name: 'attr_networking',
      desc: '',
      args: [],
    );
  }

  /// `Bookkeeping`
  String get attr_bookkeeping {
    return Intl.message(
      'Bookkeeping',
      name: 'attr_bookkeeping',
      desc: '',
      args: [],
    );
  }

  /// `Administrative work`
  String get attr_administrative_work {
    return Intl.message(
      'Administrative work',
      name: 'attr_administrative_work',
      desc: '',
      args: [],
    );
  }

  /// `Astronomy`
  String get attr_astronomy {
    return Intl.message(
      'Astronomy',
      name: 'attr_astronomy',
      desc: '',
      args: [],
    );
  }

  /// `Backpacking`
  String get attr_backpacking {
    return Intl.message(
      'Backpacking',
      name: 'attr_backpacking',
      desc: '',
      args: [],
    );
  }

  /// `Camping`
  String get attr_camping {
    return Intl.message('Camping', name: 'attr_camping', desc: '', args: []);
  }

  /// `Canyoning`
  String get attr_canyoning {
    return Intl.message(
      'Canyoning',
      name: 'attr_canyoning',
      desc: '',
      args: [],
    );
  }

  /// `Car restoration`
  String get attr_car_restoration {
    return Intl.message(
      'Car restoration',
      name: 'attr_car_restoration',
      desc: '',
      args: [],
    );
  }

  /// `Cryptocurrency`
  String get attr_cryptocurrency {
    return Intl.message(
      'Cryptocurrency',
      name: 'attr_cryptocurrency',
      desc: '',
      args: [],
    );
  }

  /// `Culinary arts`
  String get attr_culinary_arts {
    return Intl.message(
      'Culinary arts',
      name: 'attr_culinary_arts',
      desc: '',
      args: [],
    );
  }

  /// `Cycling`
  String get attr_cycling {
    return Intl.message('Cycling', name: 'attr_cycling', desc: '', args: []);
  }

  /// `Drones`
  String get attr_drones {
    return Intl.message('Drones', name: 'attr_drones', desc: '', args: []);
  }

  /// `Film making`
  String get attr_filmmaking {
    return Intl.message(
      'Film making',
      name: 'attr_filmmaking',
      desc: '',
      args: [],
    );
  }

  /// `Financial investing`
  String get attr_financial_investing {
    return Intl.message(
      'Financial investing',
      name: 'attr_financial_investing',
      desc: '',
      args: [],
    );
  }

  /// `Fishing`
  String get attr_fishing {
    return Intl.message('Fishing', name: 'attr_fishing', desc: '', args: []);
  }

  /// `Foraging`
  String get attr_foraging {
    return Intl.message('Foraging', name: 'attr_foraging', desc: '', args: []);
  }

  /// `Martial arts`
  String get attr_martial_arts {
    return Intl.message(
      'Martial arts',
      name: 'attr_martial_arts',
      desc: '',
      args: [],
    );
  }

  /// `Mindfulness`
  String get attr_mindfulness {
    return Intl.message(
      'Mindfulness',
      name: 'attr_mindfulness',
      desc: '',
      args: [],
    );
  }

  /// `PC building`
  String get attr_pc_building {
    return Intl.message(
      'PC building',
      name: 'attr_pc_building',
      desc: '',
      args: [],
    );
  }

  /// `Personal finance`
  String get attr_personal_finance {
    return Intl.message(
      'Personal finance',
      name: 'attr_personal_finance',
      desc: '',
      args: [],
    );
  }

  /// `Rock climbing`
  String get attr_rock_climbing {
    return Intl.message(
      'Rock climbing',
      name: 'attr_rock_climbing',
      desc: '',
      args: [],
    );
  }

  /// `Sustainable living`
  String get attr_sustainable_living {
    return Intl.message(
      'Sustainable living',
      name: 'attr_sustainable_living',
      desc: '',
      args: [],
    );
  }

  /// `Urban exploration`
  String get attr_urban_exploration {
    return Intl.message(
      'Urban exploration',
      name: 'attr_urban_exploration',
      desc: '',
      args: [],
    );
  }

  /// `Alternative medicine`
  String get attr_alternative_medicine {
    return Intl.message(
      'Alternative medicine',
      name: 'attr_alternative_medicine',
      desc: '',
      args: [],
    );
  }

  /// `Biohacking`
  String get attr_biohacking {
    return Intl.message(
      'Biohacking',
      name: 'attr_biohacking',
      desc: '',
      args: [],
    );
  }

  /// `Community gardening`
  String get attr_community_gardening {
    return Intl.message(
      'Community gardening',
      name: 'attr_community_gardening',
      desc: '',
      args: [],
    );
  }

  /// `Cybersecurity`
  String get attr_cybersecurity {
    return Intl.message(
      'Cybersecurity',
      name: 'attr_cybersecurity',
      desc: '',
      args: [],
    );
  }

  /// `Day trading`
  String get attr_day_trading {
    return Intl.message(
      'Day trading',
      name: 'attr_day_trading',
      desc: '',
      args: [],
    );
  }

  /// `Web Development`
  String get attr_web_development {
    return Intl.message(
      'Web Development',
      name: 'attr_web_development',
      desc: '',
      args: [],
    );
  }

  /// `Deep cleaning`
  String get attr_deep_cleaning {
    return Intl.message(
      'Deep cleaning',
      name: 'attr_deep_cleaning',
      desc: '',
      args: [],
    );
  }

  /// `Recipes`
  String get attr_recipes {
    return Intl.message('Recipes', name: 'attr_recipes', desc: '', args: []);
  }

  /// `Bodybuilding`
  String get attr_bodybuilding {
    return Intl.message(
      'Bodybuilding',
      name: 'attr_bodybuilding',
      desc: '',
      args: [],
    );
  }

  /// `Metal detecting`
  String get attr_metal_detecting {
    return Intl.message(
      'Metal detecting',
      name: 'attr_metal_detecting',
      desc: '',
      args: [],
    );
  }

  /// `Pet grooming`
  String get attr_pet_grooming {
    return Intl.message(
      'Pet grooming',
      name: 'attr_pet_grooming',
      desc: '',
      args: [],
    );
  }

  /// `Record collecting`
  String get attr_record_collecting {
    return Intl.message(
      'Record collecting',
      name: 'attr_record_collecting',
      desc: '',
      args: [],
    );
  }

  /// `Marketing`
  String get attr_marketing {
    return Intl.message(
      'Marketing',
      name: 'attr_marketing',
      desc: '',
      args: [],
    );
  }

  /// `Upcycling`
  String get attr_upcycling {
    return Intl.message(
      'Upcycling',
      name: 'attr_upcycling',
      desc: '',
      args: [],
    );
  }

  /// `Virtual reality`
  String get attr_virtual_reality {
    return Intl.message(
      'Virtual reality',
      name: 'attr_virtual_reality',
      desc: '',
      args: [],
    );
  }

  /// `Babysitting`
  String get attr_babysitting {
    return Intl.message(
      'Babysitting',
      name: 'attr_babysitting',
      desc: '',
      args: [],
    );
  }

  /// `Bicycles`
  String get attr_bicycles {
    return Intl.message('Bicycles', name: 'attr_bicycles', desc: '', args: []);
  }

  /// `Billiards`
  String get attr_billiards {
    return Intl.message(
      'Billiards',
      name: 'attr_billiards',
      desc: '',
      args: [],
    );
  }

  /// `Canned goods`
  String get attr_canned_goods {
    return Intl.message(
      'Canned goods',
      name: 'attr_canned_goods',
      desc: '',
      args: [],
    );
  }

  /// `Car detailing`
  String get attr_car_detailing {
    return Intl.message(
      'Car detailing',
      name: 'attr_car_detailing',
      desc: '',
      args: [],
    );
  }

  /// `Carpentry`
  String get attr_carpentry {
    return Intl.message(
      'Carpentry',
      name: 'attr_carpentry',
      desc: '',
      args: [],
    );
  }

  /// `Code review`
  String get attr_code_review {
    return Intl.message(
      'Code review',
      name: 'attr_code_review',
      desc: '',
      args: [],
    );
  }

  /// `Comic books`
  String get attr_comic_books {
    return Intl.message(
      'Comic books',
      name: 'attr_comic_books',
      desc: '',
      args: [],
    );
  }

  /// `Computer repair`
  String get attr_computer_repair {
    return Intl.message(
      'Computer repair',
      name: 'attr_computer_repair',
      desc: '',
      args: [],
    );
  }

  /// `Concert tickets`
  String get attr_concert_tickets {
    return Intl.message(
      'Concert tickets',
      name: 'attr_concert_tickets',
      desc: '',
      args: [],
    );
  }

  /// `Co-op gaming`
  String get attr_co_op_gaming {
    return Intl.message(
      'Co-op gaming',
      name: 'attr_co_op_gaming',
      desc: '',
      args: [],
    );
  }

  /// `Brainstorming`
  String get attr_brainstorming {
    return Intl.message(
      'Brainstorming',
      name: 'attr_brainstorming',
      desc: '',
      args: [],
    );
  }

  /// `Dance lessons`
  String get attr_dance_lessons {
    return Intl.message(
      'Dance lessons',
      name: 'attr_dance_lessons',
      desc: '',
      args: [],
    );
  }

  /// `Dog walking`
  String get attr_dog_walking {
    return Intl.message(
      'Dog walking',
      name: 'attr_dog_walking',
      desc: '',
      args: [],
    );
  }

  /// `Elderly care`
  String get attr_elderly_care {
    return Intl.message(
      'Elderly care',
      name: 'attr_elderly_care',
      desc: '',
      args: [],
    );
  }

  /// `Electronic components`
  String get attr_electronic_components {
    return Intl.message(
      'Electronic components',
      name: 'attr_electronic_components',
      desc: '',
      args: [],
    );
  }

  /// `Exercise partner`
  String get attr_exercise_partner {
    return Intl.message(
      'Exercise partner',
      name: 'attr_exercise_partner',
      desc: '',
      args: [],
    );
  }

  /// `Firewood`
  String get attr_firewood {
    return Intl.message('Firewood', name: 'attr_firewood', desc: '', args: []);
  }

  /// `Fitness coaching`
  String get attr_fitness_coaching {
    return Intl.message(
      'Fitness coaching',
      name: 'attr_fitness_coaching',
      desc: '',
      args: [],
    );
  }

  /// `Chicken eggs`
  String get attr_chicken_eggs {
    return Intl.message(
      'Chicken eggs',
      name: 'attr_chicken_eggs',
      desc: '',
      args: [],
    );
  }

  /// `Nutrition advice`
  String get attr_nutrition_advice {
    return Intl.message(
      'Nutrition advice',
      name: 'attr_nutrition_advice',
      desc: '',
      args: [],
    );
  }

  /// `Gardening advice`
  String get attr_gardening_advice {
    return Intl.message(
      'Gardening advice',
      name: 'attr_gardening_advice',
      desc: '',
      args: [],
    );
  }

  /// `Handmade items`
  String get attr_handmade_items {
    return Intl.message(
      'Handmade items',
      name: 'attr_handmade_items',
      desc: '',
      args: [],
    );
  }

  /// `Handyman services`
  String get attr_handyman_services {
    return Intl.message(
      'Handyman services',
      name: 'attr_handyman_services',
      desc: '',
      args: [],
    );
  }

  /// `Hauling services`
  String get attr_hauling_services {
    return Intl.message(
      'Hauling services',
      name: 'attr_hauling_services',
      desc: '',
      args: [],
    );
  }

  /// `Herbal remedies`
  String get attr_herbal_remedies {
    return Intl.message(
      'Herbal remedies',
      name: 'attr_herbal_remedies',
      desc: '',
      args: [],
    );
  }

  /// `Interview practice`
  String get attr_interview_practice {
    return Intl.message(
      'Interview practice',
      name: 'attr_interview_practice',
      desc: '',
      args: [],
    );
  }

  /// `Language exchange`
  String get attr_language_exchange {
    return Intl.message(
      'Language exchange',
      name: 'attr_language_exchange',
      desc: '',
      args: [],
    );
  }

  /// `Local tours`
  String get attr_local_tours {
    return Intl.message(
      'Local tours',
      name: 'attr_local_tours',
      desc: '',
      args: [],
    );
  }

  /// `Math tutoring`
  String get attr_math_tutoring {
    return Intl.message(
      'Math tutoring',
      name: 'attr_math_tutoring',
      desc: '',
      args: [],
    );
  }

  /// `Mentorship`
  String get attr_mentorship {
    return Intl.message(
      'Mentorship',
      name: 'attr_mentorship',
      desc: '',
      args: [],
    );
  }

  /// `Motorcycles`
  String get attr_motorcycles {
    return Intl.message(
      'Motorcycles',
      name: 'attr_motorcycles',
      desc: '',
      args: [],
    );
  }

  /// `Moving help`
  String get attr_moving_help {
    return Intl.message(
      'Moving help',
      name: 'attr_moving_help',
      desc: '',
      args: [],
    );
  }

  /// `Musical instruments`
  String get attr_musical_instruments {
    return Intl.message(
      'Musical instruments',
      name: 'attr_musical_instruments',
      desc: '',
      args: [],
    );
  }

  /// `Pet sitting`
  String get attr_pet_sitting {
    return Intl.message(
      'Pet sitting',
      name: 'attr_pet_sitting',
      desc: '',
      args: [],
    );
  }

  /// `Photo restoration`
  String get attr_photo_restoration {
    return Intl.message(
      'Photo restoration',
      name: 'attr_photo_restoration',
      desc: '',
      args: [],
    );
  }

  /// `Piano lessons`
  String get attr_piano_lessons {
    return Intl.message(
      'Piano lessons',
      name: 'attr_piano_lessons',
      desc: '',
      args: [],
    );
  }

  /// `Proofreading`
  String get attr_proofreading {
    return Intl.message(
      'Proofreading',
      name: 'attr_proofreading',
      desc: '',
      args: [],
    );
  }

  /// `Multiplayer games`
  String get attr_multiplayer_games {
    return Intl.message(
      'Multiplayer games',
      name: 'attr_multiplayer_games',
      desc: '',
      args: [],
    );
  }

  /// `Scrap metal`
  String get attr_scrap_metal {
    return Intl.message(
      'Scrap metal',
      name: 'attr_scrap_metal',
      desc: '',
      args: [],
    );
  }

  /// `Event tickets`
  String get attr_event_tickets {
    return Intl.message(
      'Event tickets',
      name: 'attr_event_tickets',
      desc: '',
      args: [],
    );
  }

  /// `Sports coaching`
  String get attr_sports_coaching {
    return Intl.message(
      'Sports coaching',
      name: 'attr_sports_coaching',
      desc: '',
      args: [],
    );
  }

  /// `Study partner`
  String get attr_study_partner {
    return Intl.message(
      'Study partner',
      name: 'attr_study_partner',
      desc: '',
      args: [],
    );
  }

  /// `Technical writing`
  String get attr_technical_writing {
    return Intl.message(
      'Technical writing',
      name: 'attr_technical_writing',
      desc: '',
      args: [],
    );
  }

  /// `Tennis`
  String get attr_tennis {
    return Intl.message('Tennis', name: 'attr_tennis', desc: '', args: []);
  }

  /// `Tool lending`
  String get attr_tool_lending {
    return Intl.message(
      'Tool lending',
      name: 'attr_tool_lending',
      desc: '',
      args: [],
    );
  }

  /// `Translation services`
  String get attr_translation_services {
    return Intl.message(
      'Translation services',
      name: 'attr_translation_services',
      desc: '',
      args: [],
    );
  }

  /// `Used electronics`
  String get attr_used_electronics {
    return Intl.message(
      'Used electronics',
      name: 'attr_used_electronics',
      desc: '',
      args: [],
    );
  }

  /// `Homemade goods`
  String get attr_homemade_goods {
    return Intl.message(
      'Homemade goods',
      name: 'attr_homemade_goods',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle repair`
  String get attr_vehicle_repair {
    return Intl.message(
      'Vehicle repair',
      name: 'attr_vehicle_repair',
      desc: '',
      args: [],
    );
  }

  /// `Video game hardware`
  String get attr_video_game_hardware {
    return Intl.message(
      'Video game hardware',
      name: 'attr_video_game_hardware',
      desc: '',
      args: [],
    );
  }

  /// `Voice lessons`
  String get attr_voice_lessons {
    return Intl.message(
      'Voice lessons',
      name: 'attr_voice_lessons',
      desc: '',
      args: [],
    );
  }

  /// `UX design`
  String get attr_ux_design {
    return Intl.message(
      'UX design',
      name: 'attr_ux_design',
      desc: '',
      args: [],
    );
  }

  /// `Graphic design`
  String get attr_graphic_design {
    return Intl.message(
      'Graphic design',
      name: 'attr_graphic_design',
      desc: '',
      args: [],
    );
  }

  /// `Music performance`
  String get attr_music_performance {
    return Intl.message(
      'Music performance',
      name: 'attr_music_performance',
      desc: '',
      args: [],
    );
  }

  /// `Transport service`
  String get attr_transport_service {
    return Intl.message(
      'Transport service',
      name: 'attr_transport_service',
      desc: '',
      args: [],
    );
  }

  /// `AI Consulting`
  String get attr_ai_consulting {
    return Intl.message(
      'AI Consulting',
      name: 'attr_ai_consulting',
      desc: '',
      args: [],
    );
  }

  /// `Drumming`
  String get attr_drumming {
    return Intl.message('Drumming', name: 'attr_drumming', desc: '', args: []);
  }

  /// `Vocals`
  String get attr_vocals {
    return Intl.message('Vocals', name: 'attr_vocals', desc: '', args: []);
  }

  /// `Permaculture`
  String get attr_permaculture {
    return Intl.message(
      'Permaculture',
      name: 'attr_permaculture',
      desc: '',
      args: [],
    );
  }

  /// `Physical work`
  String get attr_physical_work {
    return Intl.message(
      'Physical work',
      name: 'attr_physical_work',
      desc: '',
      args: [],
    );
  }

  /// `Business Mentorship`
  String get attr_business_mentorship {
    return Intl.message(
      'Business Mentorship',
      name: 'attr_business_mentorship',
      desc: '',
      args: [],
    );
  }

  /// `Spirituality`
  String get attr_spirituality {
    return Intl.message(
      'Spirituality',
      name: 'attr_spirituality',
      desc: '',
      args: [],
    );
  }

  /// `Natural remedies`
  String get attr_natural_remedies {
    return Intl.message(
      'Natural remedies',
      name: 'attr_natural_remedies',
      desc: '',
      args: [],
    );
  }

  /// `Retreats`
  String get attr_retreats {
    return Intl.message('Retreats', name: 'attr_retreats', desc: '', args: []);
  }

  /// `Zen`
  String get attr_zen {
    return Intl.message('Zen', name: 'attr_zen', desc: '', args: []);
  }

  /// `Linux`
  String get attr_linux {
    return Intl.message('Linux', name: 'attr_linux', desc: '', args: []);
  }

  /// `App development`
  String get attr_app_development {
    return Intl.message(
      'App development',
      name: 'attr_app_development',
      desc: '',
      args: [],
    );
  }

  /// `Android`
  String get attr_android {
    return Intl.message('Android', name: 'attr_android', desc: '', args: []);
  }

  /// `iOS`
  String get attr_ios {
    return Intl.message('iOS', name: 'attr_ios', desc: '', args: []);
  }

  /// `Backend development`
  String get attr_backend_development {
    return Intl.message(
      'Backend development',
      name: 'attr_backend_development',
      desc: '',
      args: [],
    );
  }

  /// `Plumbing`
  String get attr_plumbing {
    return Intl.message('Plumbing', name: 'attr_plumbing', desc: '', args: []);
  }

  /// `Art Exhibitions`
  String get attr_art_exhibitions {
    return Intl.message(
      'Art Exhibitions',
      name: 'attr_art_exhibitions',
      desc: '',
      args: [],
    );
  }

  /// `Environmentalism`
  String get attr_environmentalism {
    return Intl.message(
      'Environmentalism',
      name: 'attr_environmentalism',
      desc: '',
      args: [],
    );
  }

  /// `Fruits`
  String get attr_fruits {
    return Intl.message('Fruits', name: 'attr_fruits', desc: '', args: []);
  }

  /// `Fresh herbs`
  String get attr_fresh_herbs {
    return Intl.message(
      'Fresh herbs',
      name: 'attr_fresh_herbs',
      desc: '',
      args: [],
    );
  }

  /// `Tea`
  String get attr_tea {
    return Intl.message('Tea', name: 'attr_tea', desc: '', args: []);
  }

  /// `Legal advice`
  String get attr_legal_advice {
    return Intl.message(
      'Legal advice',
      name: 'attr_legal_advice',
      desc: '',
      args: [],
    );
  }

  /// `Cats`
  String get attr_cats {
    return Intl.message('Cats', name: 'attr_cats', desc: '', args: []);
  }

  /// `Dogs`
  String get attr_dogs {
    return Intl.message('Dogs', name: 'attr_dogs', desc: '', args: []);
  }

  /// `Poker`
  String get attr_poker {
    return Intl.message('Poker', name: 'attr_poker', desc: '', args: []);
  }

  /// `Socializing`
  String get attr_socializing {
    return Intl.message(
      'Socializing',
      name: 'attr_socializing',
      desc: '',
      args: [],
    );
  }

  /// `Plants`
  String get attr_plants {
    return Intl.message('Plants', name: 'attr_plants', desc: '', args: []);
  }

  /// `Farm animals`
  String get attr_farm_animals {
    return Intl.message(
      'Farm animals',
      name: 'attr_farm_animals',
      desc: '',
      args: [],
    );
  }

  /// `Organic food`
  String get attr_organic_food {
    return Intl.message(
      'Organic food',
      name: 'attr_organic_food',
      desc: '',
      args: [],
    );
  }

  /// `Mechanisms`
  String get attr_mechanisms {
    return Intl.message(
      'Mechanisms',
      name: 'attr_mechanisms',
      desc: '',
      args: [],
    );
  }

  /// `Farm machinery`
  String get attr_farm_machinery {
    return Intl.message(
      'Farm machinery',
      name: 'attr_farm_machinery',
      desc: '',
      args: [],
    );
  }

  /// `Driving`
  String get attr_driving {
    return Intl.message('Driving', name: 'attr_driving', desc: '', args: []);
  }

  /// `Machinery operation`
  String get attr_machinery_operation {
    return Intl.message(
      'Machinery operation',
      name: 'attr_machinery_operation',
      desc: '',
      args: [],
    );
  }

  /// `Animal care`
  String get attr_animal_care {
    return Intl.message(
      'Animal care',
      name: 'attr_animal_care',
      desc: '',
      args: [],
    );
  }

  /// `Horses`
  String get attr_horses {
    return Intl.message('Horses', name: 'attr_horses', desc: '', args: []);
  }

  /// `Self-sufficiency`
  String get attr_self_sufficiency {
    return Intl.message(
      'Self-sufficiency',
      name: 'attr_self_sufficiency',
      desc: '',
      args: [],
    );
  }

  /// `Ridesharing`
  String get attr_ridesharing {
    return Intl.message(
      'Ridesharing',
      name: 'attr_ridesharing',
      desc: '',
      args: [],
    );
  }

  /// `Vegetables`
  String get attr_vegetables {
    return Intl.message(
      'Vegetables',
      name: 'attr_vegetables',
      desc: '',
      args: [],
    );
  }

  /// `Car cleaning`
  String get attr_car_cleaning {
    return Intl.message(
      'Car cleaning',
      name: 'attr_car_cleaning',
      desc: '',
      args: [],
    );
  }

  /// `Farmstay`
  String get attr_farmstay {
    return Intl.message('Farmstay', name: 'attr_farmstay', desc: '', args: []);
  }

  /// `House maintenance`
  String get attr_house_maintenance {
    return Intl.message(
      'House maintenance',
      name: 'attr_house_maintenance',
      desc: '',
      args: [],
    );
  }

  /// `Renovation`
  String get attr_renovation {
    return Intl.message(
      'Renovation',
      name: 'attr_renovation',
      desc: '',
      args: [],
    );
  }

  /// `Landscaping`
  String get attr_landscaping {
    return Intl.message(
      'Landscaping',
      name: 'attr_landscaping',
      desc: '',
      args: [],
    );
  }

  /// `Forestry`
  String get attr_forestry {
    return Intl.message('Forestry', name: 'attr_forestry', desc: '', args: []);
  }

  /// `Academic tutoring`
  String get attr_academic_tutoring {
    return Intl.message(
      'Academic tutoring',
      name: 'attr_academic_tutoring',
      desc: '',
      args: [],
    );
  }

  /// `Building materials`
  String get attr_building_materials {
    return Intl.message(
      'Building materials',
      name: 'attr_building_materials',
      desc: '',
      args: [],
    );
  }

  /// `Spare parts`
  String get attr_spare_parts {
    return Intl.message(
      'Spare parts',
      name: 'attr_spare_parts',
      desc: '',
      args: [],
    );
  }

  /// `Alternative healing`
  String get attr_alternative_healing {
    return Intl.message(
      'Alternative healing',
      name: 'attr_alternative_healing',
      desc: '',
      args: [],
    );
  }

  /// `Pet supplies`
  String get attr_pet_supplies {
    return Intl.message(
      'Pet supplies',
      name: 'attr_pet_supplies',
      desc: '',
      args: [],
    );
  }

  /// `Kids toys`
  String get attr_kids_toys {
    return Intl.message(
      'Kids toys',
      name: 'attr_kids_toys',
      desc: '',
      args: [],
    );
  }

  /// `Power tools`
  String get attr_power_tools {
    return Intl.message(
      'Power tools',
      name: 'attr_power_tools',
      desc: '',
      args: [],
    );
  }

  /// `Camping gear`
  String get attr_camping_gear {
    return Intl.message(
      'Camping gear',
      name: 'attr_camping_gear',
      desc: '',
      args: [],
    );
  }

  /// `Kitchen appliances`
  String get attr_kitchen_appliances {
    return Intl.message(
      'Kitchen appliances',
      name: 'attr_kitchen_appliances',
      desc: '',
      args: [],
    );
  }

  /// `Device lending`
  String get attr_device_lending {
    return Intl.message(
      'Device lending',
      name: 'attr_device_lending',
      desc: '',
      args: [],
    );
  }

  /// `Computer accessories`
  String get attr_computer_accessories {
    return Intl.message(
      'Computer accessories',
      name: 'attr_computer_accessories',
      desc: '',
      args: [],
    );
  }

  /// `Clothing`
  String get attr_clothing {
    return Intl.message('Clothing', name: 'attr_clothing', desc: '', args: []);
  }

  /// `Sports equipment`
  String get attr_sports_equipment {
    return Intl.message(
      'Sports equipment',
      name: 'attr_sports_equipment',
      desc: '',
      args: [],
    );
  }

  /// `Bicycle parts`
  String get attr_bicycle_parts {
    return Intl.message(
      'Bicycle parts',
      name: 'attr_bicycle_parts',
      desc: '',
      args: [],
    );
  }

  /// `Errand running`
  String get attr_errand_running {
    return Intl.message(
      'Errand running',
      name: 'attr_errand_running',
      desc: '',
      args: [],
    );
  }

  /// `Phone repair`
  String get attr_phone_repair {
    return Intl.message(
      'Phone repair',
      name: 'attr_phone_repair',
      desc: '',
      args: [],
    );
  }

  /// `Lawn care`
  String get attr_lawn_care {
    return Intl.message(
      'Lawn care',
      name: 'attr_lawn_care',
      desc: '',
      args: [],
    );
  }

  /// `Digital products`
  String get attr_digital_products {
    return Intl.message(
      'Digital products',
      name: 'attr_digital_products',
      desc: '',
      args: [],
    );
  }

  /// `Software accounts`
  String get attr_software_accounts {
    return Intl.message(
      'Software accounts',
      name: 'attr_software_accounts',
      desc: '',
      args: [],
    );
  }

  /// `Reviewing`
  String get attr_reviewing {
    return Intl.message(
      'Reviewing',
      name: 'attr_reviewing',
      desc: '',
      args: [],
    );
  }

  /// `Virtual assistance`
  String get attr_virtual_assistance {
    return Intl.message(
      'Virtual assistance',
      name: 'attr_virtual_assistance',
      desc: '',
      args: [],
    );
  }

  /// `Hair styling`
  String get attr_hair_styling {
    return Intl.message(
      'Hair styling',
      name: 'attr_hair_styling',
      desc: '',
      args: [],
    );
  }

  /// `Beauty products`
  String get attr_beauty_products {
    return Intl.message(
      'Beauty products',
      name: 'attr_beauty_products',
      desc: '',
      args: [],
    );
  }

  /// `Audio equipment`
  String get attr_audio_equipment {
    return Intl.message(
      'Audio equipment',
      name: 'attr_audio_equipment',
      desc: '',
      args: [],
    );
  }

  /// `Health supplements`
  String get attr_health_supplements {
    return Intl.message(
      'Health supplements',
      name: 'attr_health_supplements',
      desc: '',
      args: [],
    );
  }

  /// `Location:`
  String get userLocation {
    return Intl.message('Location:', name: 'userLocation', desc: '', args: []);
  }

  /// `Edit Location`
  String get editLocation {
    return Intl.message(
      'Edit Location',
      name: 'editLocation',
      desc: '',
      args: [],
    );
  }

  /// `Edit Your Overall Interests`
  String get editKeywords {
    return Intl.message(
      'Edit Your Overall Interests',
      name: 'editKeywords',
      desc: '',
      args: [],
    );
  }

  /// `Create Offer Posting`
  String get createOfferPosting {
    return Intl.message(
      'Create Offer Posting',
      name: 'createOfferPosting',
      desc: '',
      args: [],
    );
  }

  /// `Create Interest Posting`
  String get createInterestPosting {
    return Intl.message(
      'Create Interest Posting',
      name: 'createInterestPosting',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get postingTitle {
    return Intl.message('Title', name: 'postingTitle', desc: '', args: []);
  }

  /// `Brief title for your posting`
  String get postingTitleHint {
    return Intl.message(
      'Brief title for your posting',
      name: 'postingTitleHint',
      desc: '',
      args: [],
    );
  }

  /// `Title is required`
  String get postingTitleRequired {
    return Intl.message(
      'Title is required',
      name: 'postingTitleRequired',
      desc: '',
      args: [],
    );
  }

  /// `Title must be at least 3 characters`
  String get postingTitleTooShort {
    return Intl.message(
      'Title must be at least 3 characters',
      name: 'postingTitleTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get postingDescription {
    return Intl.message(
      'Description',
      name: 'postingDescription',
      desc: '',
      args: [],
    );
  }

  /// `Detailed description of what you're offering or looking for`
  String get postingDescriptionHint {
    return Intl.message(
      'Detailed description of what you\'re offering or looking for',
      name: 'postingDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `Description is required`
  String get postingDescriptionRequired {
    return Intl.message(
      'Description is required',
      name: 'postingDescriptionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Description must be at least 10 characters`
  String get postingDescriptionTooShort {
    return Intl.message(
      'Description must be at least 10 characters',
      name: 'postingDescriptionTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Value (Optional)`
  String get postingValue {
    return Intl.message(
      'Value (Optional)',
      name: 'postingValue',
      desc: '',
      args: [],
    );
  }

  /// `Estimated value`
  String get postingValueHint {
    return Intl.message(
      'Estimated value',
      name: 'postingValueHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid positive number`
  String get postingValueInvalid {
    return Intl.message(
      'Please enter a valid positive number',
      name: 'postingValueInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get optionalField {
    return Intl.message('Optional', name: 'optionalField', desc: '', args: []);
  }

  /// `Expiration Date`
  String get expirationDate {
    return Intl.message(
      'Expiration Date',
      name: 'expirationDate',
      desc: '',
      args: [],
    );
  }

  /// `Tap to select expiration date (optional)`
  String get tapToSelectDate {
    return Intl.message(
      'Tap to select expiration date (optional)',
      name: 'tapToSelectDate',
      desc: '',
      args: [],
    );
  }

  /// `Images`
  String get postingImages {
    return Intl.message('Images', name: 'postingImages', desc: '', args: []);
  }

  /// `Add up to 3 images (optional)`
  String get postingImagesHint {
    return Intl.message(
      'Add up to 3 images (optional)',
      name: 'postingImagesHint',
      desc: '',
      args: [],
    );
  }

  /// `Add Image`
  String get addImage {
    return Intl.message('Add Image', name: 'addImage', desc: '', args: []);
  }

  /// `Take Photo`
  String get takePhoto {
    return Intl.message('Take Photo', name: 'takePhoto', desc: '', args: []);
  }

  /// `Choose from Device`
  String get chooseFromGallery {
    return Intl.message(
      'Choose from Device',
      name: 'chooseFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Maximum 3 images allowed`
  String get maxImagesReached {
    return Intl.message(
      'Maximum 3 images allowed',
      name: 'maxImagesReached',
      desc: '',
      args: [],
    );
  }

  /// `Create Posting`
  String get createPosting {
    return Intl.message(
      'Create Posting',
      name: 'createPosting',
      desc: '',
      args: [],
    );
  }

  /// `Posting created successfully!`
  String get postingCreatedSuccess {
    return Intl.message(
      'Posting created successfully!',
      name: 'postingCreatedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Add Posting`
  String get addNewPosting {
    return Intl.message(
      'Add Posting',
      name: 'addNewPosting',
      desc: '',
      args: [],
    );
  }

  /// `Delete Conversation`
  String get deleteConversation {
    return Intl.message(
      'Delete Conversation',
      name: 'deleteConversation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this conversation? All messages will be permanently removed.`
  String get deleteConversationConfirmation {
    return Intl.message(
      'Are you sure you want to delete this conversation? All messages will be permanently removed.',
      name: 'deleteConversationConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Conversation deleted`
  String get conversationDeleted {
    return Intl.message(
      'Conversation deleted',
      name: 'conversationDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Error loading chats`
  String get errorLoadingChats {
    return Intl.message(
      'Error loading chats',
      name: 'errorLoadingChats',
      desc: '',
      args: [],
    );
  }

  /// `Could not find chat participant`
  String get couldNotFindChatParticipant {
    return Intl.message(
      'Could not find chat participant',
      name: 'couldNotFindChatParticipant',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting conversation`
  String get errorDeletingConversation {
    return Intl.message(
      'Error deleting conversation',
      name: 'errorDeletingConversation',
      desc: '',
      args: [],
    );
  }

  /// `Unknown User`
  String get unknownUser {
    return Intl.message(
      'Unknown User',
      name: 'unknownUser',
      desc: '',
      args: [],
    );
  }

  /// `No messages yet`
  String get noMessagesYet {
    return Intl.message(
      'No messages yet',
      name: 'noMessagesYet',
      desc: '',
      args: [],
    );
  }

  /// `99+`
  String get ninetyNinePlus {
    return Intl.message('99+', name: 'ninetyNinePlus', desc: '', args: []);
  }

  /// `User Details`
  String get userDetails {
    return Intl.message(
      'User Details',
      name: 'userDetails',
      desc: '',
      args: [],
    );
  }

  /// `{count} matching {count, plural, =1{user} other{users}} found`
  String matchingUsersFound(int count) {
    return Intl.message(
      '$count matching ${Intl.plural(count, one: 'user', other: 'users')} found',
      name: 'matchingUsersFound',
      desc: '',
      args: [count],
    );
  }

  /// `{count} matching {count, plural, =1{posting} other{postings}} found`
  String matchingPostingsFound(int count) {
    return Intl.message(
      '$count matching ${Intl.plural(count, one: 'posting', other: 'postings')} found',
      name: 'matchingPostingsFound',
      desc: '',
      args: [count],
    );
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message('Yesterday', name: 'yesterday', desc: '', args: []);
  }

  /// `Not set`
  String get notSet {
    return Intl.message('Not set', name: 'notSet', desc: '', args: []);
  }

  /// `Error updating favorite`
  String get errorUpdatingFavorite {
    return Intl.message(
      'Error updating favorite',
      name: 'errorUpdatingFavorite',
      desc: '',
      args: [],
    );
  }

  /// `No attributes to display.`
  String get noAttributesToDisplay {
    return Intl.message(
      'No attributes to display.',
      name: 'noAttributesToDisplay',
      desc: '',
      args: [],
    );
  }

  /// `Error loading postings`
  String get errorLoadingPostings {
    return Intl.message(
      'Error loading postings',
      name: 'errorLoadingPostings',
      desc: '',
      args: [],
    );
  }

  /// `Error loading attributes`
  String get errorLoadingAttributes {
    return Intl.message(
      'Error loading attributes',
      name: 'errorLoadingAttributes',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get userPrefix {
    return Intl.message('User', name: 'userPrefix', desc: '', args: []);
  }

  /// `Active Postings`
  String get activePostings {
    return Intl.message(
      'Active Postings',
      name: 'activePostings',
      desc: '',
      args: [],
    );
  }

  /// `Posting`
  String get posting {
    return Intl.message('Posting', name: 'posting', desc: '', args: []);
  }

  /// `Postings`
  String get postings {
    return Intl.message('Postings', name: 'postings', desc: '', args: []);
  }

  /// `Offers`
  String get offers {
    return Intl.message('Offers', name: 'offers', desc: '', args: []);
  }

  /// `Looking For`
  String get lookingFor {
    return Intl.message('Looking For', name: 'lookingFor', desc: '', args: []);
  }

  /// `Value`
  String get valuePrefix {
    return Intl.message('Value', name: 'valuePrefix', desc: '', args: []);
  }

  /// `Expires`
  String get expiresPrefix {
    return Intl.message('Expires', name: 'expiresPrefix', desc: '', args: []);
  }

  /// `Posted`
  String get postedPrefix {
    return Intl.message('Posted', name: 'postedPrefix', desc: '', args: []);
  }

  /// `No chats yet`
  String get noChatsYet {
    return Intl.message('No chats yet', name: 'noChatsYet', desc: '', args: []);
  }

  /// `Start a conversation from the map`
  String get startConversationFromMap {
    return Intl.message(
      'Start a conversation from the map',
      name: 'startConversationFromMap',
      desc: '',
      args: [],
    );
  }

  /// `Connect. Trade. Build Community.`
  String get welcomeTagline {
    return Intl.message(
      'Connect. Trade. Build Community.',
      name: 'welcomeTagline',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
  }

  /// `How It Works`
  String get howItWorks {
    return Intl.message('How It Works', name: 'howItWorks', desc: '', args: []);
  }

  /// `Create your Profile`
  String get welcomeStep1Title {
    return Intl.message(
      'Create your Profile',
      name: 'welcomeStep1Title',
      desc: '',
      args: [],
    );
  }

  /// `Create an anonymous profile with your interests and what you have to offer`
  String get welcomeStep1Description {
    return Intl.message(
      'Create an anonymous profile with your interests and what you have to offer',
      name: 'welcomeStep1Description',
      desc: '',
      args: [],
    );
  }

  /// `Discover, Search, Post`
  String get welcomeStep2Title {
    return Intl.message(
      'Discover, Search, Post',
      name: 'welcomeStep2Title',
      desc: '',
      args: [],
    );
  }

  /// `Search by keywords, similarity or trade match, get match notifications`
  String get welcomeStep2Description {
    return Intl.message(
      'Search by keywords, similarity or trade match, get match notifications',
      name: 'welcomeStep2Description',
      desc: '',
      args: [],
    );
  }

  /// `Start Chatting`
  String get welcomeStep3Title {
    return Intl.message(
      'Start Chatting',
      name: 'welcomeStep3Title',
      desc: '',
      args: [],
    );
  }

  /// `Connect with others through End-to-end encrypted chat`
  String get welcomeStep3Description {
    return Intl.message(
      'Connect with others through End-to-end encrypted chat',
      name: 'welcomeStep3Description',
      desc: '',
      args: [],
    );
  }

  /// `Make Exchanges`
  String get welcomeStep4Title {
    return Intl.message(
      'Make Exchanges',
      name: 'welcomeStep4Title',
      desc: '',
      args: [],
    );
  }

  /// `Trade knowledge, services, items, or simply connect with your community`
  String get welcomeStep4Description {
    return Intl.message(
      'Trade knowledge, services, items, or simply connect with your community',
      name: 'welcomeStep4Description',
      desc: '',
      args: [],
    );
  }

  /// `Privacy & Data Consent`
  String get gdprConsentTitle {
    return Intl.message(
      'Privacy & Data Consent',
      name: 'gdprConsentTitle',
      desc: '',
      args: [],
    );
  }

  /// `Before you continue, please review and choose how your data is processed.`
  String get gdprConsentIntro {
    return Intl.message(
      'Before you continue, please review and choose how your data is processed.',
      name: 'gdprConsentIntro',
      desc: '',
      args: [],
    );
  }

  /// `Required: Core service processing`
  String get gdprConsentRequiredLabel {
    return Intl.message(
      'Required: Core service processing',
      name: 'gdprConsentRequiredLabel',
      desc: '',
      args: [],
    );
  }

  /// `Needed to create your account, match with users, and run secure messaging. This cannot be turned off.`
  String get gdprConsentRequiredDescription {
    return Intl.message(
      'Needed to create your account, match with users, and run secure messaging. This cannot be turned off.',
      name: 'gdprConsentRequiredDescription',
      desc: '',
      args: [],
    );
  }

  /// `Optional: Location processing`
  String get gdprConsentLocationLabel {
    return Intl.message(
      'Optional: Location processing',
      name: 'gdprConsentLocationLabel',
      desc: '',
      args: [],
    );
  }

  /// `Use your location to discover matching users nearby.`
  String get gdprConsentLocationDescription {
    return Intl.message(
      'Use your location to discover matching users nearby.',
      name: 'gdprConsentLocationDescription',
      desc: '',
      args: [],
    );
  }

  /// `Optional: AI-assisted matching`
  String get gdprConsentAiLabel {
    return Intl.message(
      'Optional: AI-assisted matching',
      name: 'gdprConsentAiLabel',
      desc: '',
      args: [],
    );
  }

  /// `Analyze profile configuration to improve recommendations and relevance.`
  String get gdprConsentAiDescription {
    return Intl.message(
      'Analyze profile configuration to improve recommendations and relevance.',
      name: 'gdprConsentAiDescription',
      desc: '',
      args: [],
    );
  }

  /// `Cookies (Web)`
  String get gdprCookiesSectionTitle {
    return Intl.message(
      'Cookies (Web)',
      name: 'gdprCookiesSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Required cookies`
  String get gdprCookiesRequiredLabel {
    return Intl.message(
      'Required cookies',
      name: 'gdprCookiesRequiredLabel',
      desc: '',
      args: [],
    );
  }

  /// `Needed for core web functionality: security, session handling, and storing preferences.`
  String get gdprCookiesRequiredDescription {
    return Intl.message(
      'Needed for core web functionality: security, session handling, and storing preferences.',
      name: 'gdprCookiesRequiredDescription',
      desc: '',
      args: [],
    );
  }

  /// `Optional analytics cookies`
  String get gdprCookiesAnalyticsLabel {
    return Intl.message(
      'Optional analytics cookies',
      name: 'gdprCookiesAnalyticsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Helps us understand usage and improve performance. These are only used if you allow them.`
  String get gdprCookiesAnalyticsDescription {
    return Intl.message(
      'Helps us understand usage and improve performance. These are only used if you allow them.',
      name: 'gdprCookiesAnalyticsDescription',
      desc: '',
      args: [],
    );
  }

  /// `You can change this later in Settings.`
  String get gdprConsentManageLater {
    return Intl.message(
      'You can change this later in Settings.',
      name: 'gdprConsentManageLater',
      desc: '',
      args: [],
    );
  }

  /// `Not now`
  String get gdprConsentDecline {
    return Intl.message(
      'Not now',
      name: 'gdprConsentDecline',
      desc: '',
      args: [],
    );
  }

  /// `Continue (Accept Terms & Conditions)`
  String get gdprConsentAccept {
    return Intl.message(
      'Continue (Accept Terms & Conditions)',
      name: 'gdprConsentAccept',
      desc: '',
      args: [],
    );
  }

  /// `Wishlist`
  String get wishlist {
    return Intl.message('Wishlist', name: 'wishlist', desc: '', args: []);
  }

  /// `My Wishlist`
  String get myWishlist {
    return Intl.message('My Wishlist', name: 'myWishlist', desc: '', args: []);
  }

  /// `Add Wishlist Item`
  String get addWishlistItem {
    return Intl.message(
      'Add Wishlist Item',
      name: 'addWishlistItem',
      desc: '',
      args: [],
    );
  }

  /// `Edit Wishlist Item`
  String get editWishlistItem {
    return Intl.message(
      'Edit Wishlist Item',
      name: 'editWishlistItem',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get wishlistItemTitle {
    return Intl.message('Title', name: 'wishlistItemTitle', desc: '', args: []);
  }

  /// `Description`
  String get wishlistItemDescription {
    return Intl.message(
      'Description',
      name: 'wishlistItemDescription',
      desc: '',
      args: [],
    );
  }

  /// `Keywords (comma separated)`
  String get wishlistItemKeywords {
    return Intl.message(
      'Keywords (comma separated)',
      name: 'wishlistItemKeywords',
      desc: '',
      args: [],
    );
  }

  /// `Price Range`
  String get wishlistItemPriceRange {
    return Intl.message(
      'Price Range',
      name: 'wishlistItemPriceRange',
      desc: '',
      args: [],
    );
  }

  /// `Min Price`
  String get wishlistItemMinPrice {
    return Intl.message(
      'Min Price',
      name: 'wishlistItemMinPrice',
      desc: '',
      args: [],
    );
  }

  /// `Max Price`
  String get wishlistItemMaxPrice {
    return Intl.message(
      'Max Price',
      name: 'wishlistItemMaxPrice',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get wishlistItemLocation {
    return Intl.message(
      'Location',
      name: 'wishlistItemLocation',
      desc: '',
      args: [],
    );
  }

  /// `Search Radius (km)`
  String get wishlistItemRadius {
    return Intl.message(
      'Search Radius (km)',
      name: 'wishlistItemRadius',
      desc: '',
      args: [],
    );
  }

  /// `Enable Notifications`
  String get wishlistItemNotifications {
    return Intl.message(
      'Enable Notifications',
      name: 'wishlistItemNotifications',
      desc: '',
      args: [],
    );
  }

  /// `No wishlist items yet`
  String get noWishlistItems {
    return Intl.message(
      'No wishlist items yet',
      name: 'noWishlistItems',
      desc: '',
      args: [],
    );
  }

  /// `Create your first wishlist item to get notified when matches appear`
  String get createYourFirstWishlistItem {
    return Intl.message(
      'Create your first wishlist item to get notified when matches appear',
      name: 'createYourFirstWishlistItem',
      desc: '',
      args: [],
    );
  }

  /// `Delete Wishlist Item`
  String get deleteWishlistItem {
    return Intl.message(
      'Delete Wishlist Item',
      name: 'deleteWishlistItem',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this wishlist item?`
  String get deleteWishlistItemConfirmation {
    return Intl.message(
      'Are you sure you want to delete this wishlist item?',
      name: 'deleteWishlistItemConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Wishlist item deleted`
  String get wishlistItemDeleted {
    return Intl.message(
      'Wishlist item deleted',
      name: 'wishlistItemDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting wishlist item`
  String get errorDeletingWishlistItem {
    return Intl.message(
      'Error deleting wishlist item',
      name: 'errorDeletingWishlistItem',
      desc: '',
      args: [],
    );
  }

  /// `Wishlist item created`
  String get wishlistItemCreated {
    return Intl.message(
      'Wishlist item created',
      name: 'wishlistItemCreated',
      desc: '',
      args: [],
    );
  }

  /// `Wishlist item updated`
  String get wishlistItemUpdated {
    return Intl.message(
      'Wishlist item updated',
      name: 'wishlistItemUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Error creating wishlist item`
  String get errorCreatingWishlistItem {
    return Intl.message(
      'Error creating wishlist item',
      name: 'errorCreatingWishlistItem',
      desc: '',
      args: [],
    );
  }

  /// `Error updating wishlist item`
  String get errorUpdatingWishlistItem {
    return Intl.message(
      'Error updating wishlist item',
      name: 'errorUpdatingWishlistItem',
      desc: '',
      args: [],
    );
  }

  /// `Error loading wishlist`
  String get errorLoadingWishlist {
    return Intl.message(
      'Error loading wishlist',
      name: 'errorLoadingWishlist',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get wishlistStatusActive {
    return Intl.message(
      'Active',
      name: 'wishlistStatusActive',
      desc: '',
      args: [],
    );
  }

  /// `Paused`
  String get wishlistStatusPaused {
    return Intl.message(
      'Paused',
      name: 'wishlistStatusPaused',
      desc: '',
      args: [],
    );
  }

  /// `Fulfilled`
  String get wishlistStatusFulfilled {
    return Intl.message(
      'Fulfilled',
      name: 'wishlistStatusFulfilled',
      desc: '',
      args: [],
    );
  }

  /// `Archived`
  String get wishlistStatusArchived {
    return Intl.message(
      'Archived',
      name: 'wishlistStatusArchived',
      desc: '',
      args: [],
    );
  }

  /// `Matches`
  String get wishlistMatches {
    return Intl.message('Matches', name: 'wishlistMatches', desc: '', args: []);
  }

  /// `No matches yet`
  String get noMatchesYet {
    return Intl.message(
      'No matches yet',
      name: 'noMatchesYet',
      desc: '',
      args: [],
    );
  }

  /// `Match Score`
  String get matchScore {
    return Intl.message('Match Score', name: 'matchScore', desc: '', args: []);
  }

  /// `View Matches`
  String get viewMatches {
    return Intl.message(
      'View Matches',
      name: 'viewMatches',
      desc: '',
      args: [],
    );
  }

  /// `Pause`
  String get pauseWishlist {
    return Intl.message('Pause', name: 'pauseWishlist', desc: '', args: []);
  }

  /// `Activate`
  String get activateWishlist {
    return Intl.message(
      'Activate',
      name: 'activateWishlist',
      desc: '',
      args: [],
    );
  }

  /// `Mark as Fulfilled`
  String get markAsFulfilled {
    return Intl.message(
      'Mark as Fulfilled',
      name: 'markAsFulfilled',
      desc: '',
      args: [],
    );
  }

  /// `Archive`
  String get archiveWishlist {
    return Intl.message('Archive', name: 'archiveWishlist', desc: '', args: []);
  }

  /// `Please enter a title`
  String get pleaseEnterTitle {
    return Intl.message(
      'Please enter a title',
      name: 'pleaseEnterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enter at least one keyword`
  String get atLeastOneKeyword {
    return Intl.message(
      'Please enter at least one keyword',
      name: 'atLeastOneKeyword',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one interest or add a custom keyword`
  String get pleaseSelectAtLeastOneInterest {
    return Intl.message(
      'Please select at least one interest or add a custom keyword',
      name: 'pleaseSelectAtLeastOneInterest',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one offer or add a custom keyword`
  String get pleaseSelectAtLeastOneOffer {
    return Intl.message(
      'Please select at least one offer or add a custom keyword',
      name: 'pleaseSelectAtLeastOneOffer',
      desc: '',
      args: [],
    );
  }

  /// `Notification Preferences`
  String get notificationPreferences {
    return Intl.message(
      'Notification Preferences',
      name: 'notificationPreferences',
      desc: '',
      args: [],
    );
  }

  /// `Contacts`
  String get contacts {
    return Intl.message('Contacts', name: 'contacts', desc: '', args: []);
  }

  /// `Attributes`
  String get attributes {
    return Intl.message('Attributes', name: 'attributes', desc: '', args: []);
  }

  /// `No contacts found`
  String get noContactsFound {
    return Intl.message(
      'No contacts found',
      name: 'noContactsFound',
      desc: '',
      args: [],
    );
  }

  /// `Verified`
  String get verified {
    return Intl.message('Verified', name: 'verified', desc: '', args: []);
  }

  /// `Not Verified`
  String get notVerified {
    return Intl.message(
      'Not Verified',
      name: 'notVerified',
      desc: '',
      args: [],
    );
  }

  /// `Update Email`
  String get updateEmail {
    return Intl.message(
      'Update Email',
      name: 'updateEmail',
      desc: '',
      args: [],
    );
  }

  /// `Update Phone`
  String get updatePhone {
    return Intl.message(
      'Update Phone',
      name: 'updatePhone',
      desc: '',
      args: [],
    );
  }

  /// `Push Notifications`
  String get pushNotifications {
    return Intl.message(
      'Push Notifications',
      name: 'pushNotifications',
      desc: '',
      args: [],
    );
  }

  /// `No push notification tokens registered`
  String get noPushTokens {
    return Intl.message(
      'No push notification tokens registered',
      name: 'noPushTokens',
      desc: '',
      args: [],
    );
  }

  /// `Remove Push Token`
  String get removePushToken {
    return Intl.message(
      'Remove Push Token',
      name: 'removePushToken',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove this push token?`
  String get removePushTokenConfirmation {
    return Intl.message(
      'Are you sure you want to remove this push token?',
      name: 'removePushTokenConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message('Remove', name: 'remove', desc: '', args: []);
  }

  /// `Push token removed`
  String get pushTokenRemoved {
    return Intl.message(
      'Push token removed',
      name: 'pushTokenRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Email updated`
  String get emailUpdated {
    return Intl.message(
      'Email updated',
      name: 'emailUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Phone updated`
  String get phoneUpdated {
    return Intl.message(
      'Phone updated',
      name: 'phoneUpdated',
      desc: '',
      args: [],
    );
  }

  /// `No attribute preferences`
  String get noAttributePreferences {
    return Intl.message(
      'No attribute preferences',
      name: 'noAttributePreferences',
      desc: '',
      args: [],
    );
  }

  /// `Set notification preferences for your interests and offerings`
  String get attributePreferencesHint {
    return Intl.message(
      'Set notification preferences for your interests and offerings',
      name: 'attributePreferencesHint',
      desc: '',
      args: [],
    );
  }

  /// `Frequency`
  String get frequency {
    return Intl.message('Frequency', name: 'frequency', desc: '', args: []);
  }

  /// `Min. Match Score`
  String get minMatchScore {
    return Intl.message(
      'Min. Match Score',
      name: 'minMatchScore',
      desc: '',
      args: [],
    );
  }

  /// `New Postings`
  String get newPostings {
    return Intl.message(
      'New Postings',
      name: 'newPostings',
      desc: '',
      args: [],
    );
  }

  /// `New Users`
  String get newUsers {
    return Intl.message('New Users', name: 'newUsers', desc: '', args: []);
  }

  /// `Instant`
  String get instant {
    return Intl.message('Instant', name: 'instant', desc: '', args: []);
  }

  /// `Daily`
  String get daily {
    return Intl.message('Daily', name: 'daily', desc: '', args: []);
  }

  /// `Weekly`
  String get weekly {
    return Intl.message('Weekly', name: 'weekly', desc: '', args: []);
  }

  /// `Manual`
  String get manual {
    return Intl.message('Manual', name: 'manual', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Delete Preference`
  String get deletePreference {
    return Intl.message(
      'Delete Preference',
      name: 'deletePreference',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this preference?`
  String get deletePreferenceConfirmation {
    return Intl.message(
      'Are you sure you want to delete this preference?',
      name: 'deletePreferenceConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Preference deleted`
  String get preferenceDeleted {
    return Intl.message(
      'Preference deleted',
      name: 'preferenceDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Edit Preference`
  String get editPreference {
    return Intl.message(
      'Edit Preference',
      name: 'editPreference',
      desc: '',
      args: [],
    );
  }

  /// `Notify on new postings`
  String get notifyOnNewPostings {
    return Intl.message(
      'Notify on new postings',
      name: 'notifyOnNewPostings',
      desc: '',
      args: [],
    );
  }

  /// `Notify on new users`
  String get notifyOnNewUsers {
    return Intl.message(
      'Notify on new users',
      name: 'notifyOnNewUsers',
      desc: '',
      args: [],
    );
  }

  /// `Preference updated`
  String get preferenceUpdated {
    return Intl.message(
      'Preference updated',
      name: 'preferenceUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Unviewed`
  String get unviewed {
    return Intl.message('Unviewed', name: 'unviewed', desc: '', args: []);
  }

  /// `Unviewed Only`
  String get unviewedOnly {
    return Intl.message(
      'Unviewed Only',
      name: 'unviewedOnly',
      desc: '',
      args: [],
    );
  }

  /// `No unviewed matches`
  String get noUnviewedMatches {
    return Intl.message(
      'No unviewed matches',
      name: 'noUnviewedMatches',
      desc: '',
      args: [],
    );
  }

  /// `NEW`
  String get newBadge {
    return Intl.message('NEW', name: 'newBadge', desc: '', args: []);
  }

  /// `Mark as Viewed`
  String get markAsViewed {
    return Intl.message(
      'Mark as Viewed',
      name: 'markAsViewed',
      desc: '',
      args: [],
    );
  }

  /// `Dismiss`
  String get dismiss {
    return Intl.message('Dismiss', name: 'dismiss', desc: '', args: []);
  }

  /// `Dismissed`
  String get dismissed {
    return Intl.message('Dismissed', name: 'dismissed', desc: '', args: []);
  }

  /// `Posting Match`
  String get postingMatch {
    return Intl.message(
      'Posting Match',
      name: 'postingMatch',
      desc: '',
      args: [],
    );
  }

  /// `User Match`
  String get userMatch {
    return Intl.message('User Match', name: 'userMatch', desc: '', args: []);
  }

  /// `Attribute Match`
  String get attributeMatch {
    return Intl.message(
      'Attribute Match',
      name: 'attributeMatch',
      desc: '',
      args: [],
    );
  }

  /// `Match`
  String get match {
    return Intl.message('Match', name: 'match', desc: '', args: []);
  }

  /// `Match:`
  String get matchLabel {
    return Intl.message('Match:', name: 'matchLabel', desc: '', args: []);
  }

  /// `Dismiss Match`
  String get dismissMatch {
    return Intl.message(
      'Dismiss Match',
      name: 'dismissMatch',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to dismiss this match?`
  String get dismissMatchConfirmation {
    return Intl.message(
      'Are you sure you want to dismiss this match?',
      name: 'dismissMatchConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Match dismissed`
  String get matchDismissed {
    return Intl.message(
      'Match dismissed',
      name: 'matchDismissed',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Matches`
  String get matches {
    return Intl.message('Matches', name: 'matches', desc: '', args: []);
  }

  /// `Notification Settings`
  String get notificationSettings {
    return Intl.message(
      'Notification Settings',
      name: 'notificationSettings',
      desc: '',
      args: [],
    );
  }

  /// `Enable Notifications`
  String get enableNotifications {
    return Intl.message(
      'Enable Notifications',
      name: 'enableNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Receive notifications for matches and updates`
  String get enableNotificationsDescription {
    return Intl.message(
      'Receive notifications for matches and updates',
      name: 'enableNotificationsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Quiet Hours`
  String get quietHours {
    return Intl.message('Quiet Hours', name: 'quietHours', desc: '', args: []);
  }

  /// `Do not send notifications during these hours`
  String get quietHoursDescription {
    return Intl.message(
      'Do not send notifications during these hours',
      name: 'quietHoursDescription',
      desc: '',
      args: [],
    );
  }

  /// `Start Time`
  String get startTime {
    return Intl.message('Start Time', name: 'startTime', desc: '', args: []);
  }

  /// `End Time`
  String get endTime {
    return Intl.message('End Time', name: 'endTime', desc: '', args: []);
  }

  /// `Clear Quiet Hours`
  String get clearQuietHours {
    return Intl.message(
      'Clear Quiet Hours',
      name: 'clearQuietHours',
      desc: '',
      args: [],
    );
  }

  /// `Add interests and skills to your profile first`
  String get noAttributesInProfile {
    return Intl.message(
      'Add interests and skills to your profile first',
      name: 'noAttributesInProfile',
      desc: '',
      args: [],
    );
  }

  /// `Set Up Notifications`
  String get setupAttributeNotifications {
    return Intl.message(
      'Set Up Notifications',
      name: 'setupAttributeNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Enable notifications for your interests and skills to receive alerts when matches are found`
  String get setupAttributeNotificationsHint {
    return Intl.message(
      'Enable notifications for your interests and skills to receive alerts when matches are found',
      name: 'setupAttributeNotificationsHint',
      desc: '',
      args: [],
    );
  }

  /// `Default Settings`
  String get defaultSettings {
    return Intl.message(
      'Default Settings',
      name: 'defaultSettings',
      desc: '',
      args: [],
    );
  }

  /// `Select Attributes`
  String get selectAttributes {
    return Intl.message(
      'Select Attributes',
      name: 'selectAttributes',
      desc: '',
      args: [],
    );
  }

  /// `selected`
  String get attributesSelected {
    return Intl.message(
      'selected',
      name: 'attributesSelected',
      desc: '',
      args: [],
    );
  }

  /// `Save Preferences`
  String get createPreferences {
    return Intl.message(
      'Save Preferences',
      name: 'createPreferences',
      desc: '',
      args: [],
    );
  }

  /// `Notification preferences saved`
  String get preferencesCreated {
    return Intl.message(
      'Notification preferences saved',
      name: 'preferencesCreated',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Offering`
  String get offering {
    return Intl.message('Offering', name: 'offering', desc: '', args: []);
  }

  /// `Interest`
  String get interest {
    return Intl.message('Interest', name: 'interest', desc: '', args: []);
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Relevancy`
  String get relevancy {
    return Intl.message('Relevancy', name: 'relevancy', desc: '', args: []);
  }

  /// `Match History`
  String get matchHistory {
    return Intl.message(
      'Match History',
      name: 'matchHistory',
      desc: '',
      args: [],
    );
  }

  /// `Add Attributes`
  String get addAttributes {
    return Intl.message(
      'Add Attributes',
      name: 'addAttributes',
      desc: '',
      args: [],
    );
  }

  /// `All attributes from your profile already have notification preferences`
  String get allAttributesHavePreferences {
    return Intl.message(
      'All attributes from your profile already have notification preferences',
      name: 'allAttributesHavePreferences',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Set Up Email`
  String get setupEmailTitle {
    return Intl.message(
      'Set Up Email',
      name: 'setupEmailTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address to receive notifications`
  String get setupEmailDescription {
    return Intl.message(
      'Enter your email address to receive notifications',
      name: 'setupEmailDescription',
      desc: '',
      args: [],
    );
  }

  /// `example@email.com`
  String get emailHint {
    return Intl.message(
      'example@email.com',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `Email address is required`
  String get emailRequired {
    return Intl.message(
      'Email address is required',
      name: 'emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Email Notification Preferences`
  String get emailNotificationPreferences {
    return Intl.message(
      'Email Notification Preferences',
      name: 'emailNotificationPreferences',
      desc: '',
      args: [],
    );
  }

  /// `Unsubscribe`
  String get emailUnsubscribe {
    return Intl.message(
      'Unsubscribe',
      name: 'emailUnsubscribe',
      desc: '',
      args: [],
    );
  }

  /// `Unsubscribed successfully`
  String get emailUnsubscribed {
    return Intl.message(
      'Unsubscribed successfully',
      name: 'emailUnsubscribed',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get emailInvalid {
    return Intl.message(
      'Please enter a valid email address',
      name: 'emailInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Save Email`
  String get saveEmail {
    return Intl.message('Save Email', name: 'saveEmail', desc: '', args: []);
  }

  /// `Email address saved successfully`
  String get emailSaved {
    return Intl.message(
      'Email address saved successfully',
      name: 'emailSaved',
      desc: '',
      args: [],
    );
  }

  /// `I agree to receive emails about new matches, offers, and updates`
  String get marketingConsentLabel {
    return Intl.message(
      'I agree to receive emails about new matches, offers, and updates',
      name: 'marketingConsentLabel',
      desc: '',
      args: [],
    );
  }

  /// `We may send you occasional emails about our services. You can unsubscribe at any time.`
  String get marketingConsentDescription {
    return Intl.message(
      'We may send you occasional emails about our services. You can unsubscribe at any time.',
      name: 'marketingConsentDescription',
      desc: '',
      args: [],
    );
  }

  /// `Delete Profile`
  String get deleteProfile {
    return Intl.message(
      'Delete Profile',
      name: 'deleteProfile',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your profile? This action cannot be undone. All your data, postings, and conversations will be permanently removed.`
  String get deleteProfileConfirmation {
    return Intl.message(
      'Are you sure you want to delete your profile? This action cannot be undone. All your data, postings, and conversations will be permanently removed.',
      name: 'deleteProfileConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Profile deleted successfully`
  String get profileDeleted {
    return Intl.message(
      'Profile deleted successfully',
      name: 'profileDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting profile`
  String get errorDeletingProfile {
    return Intl.message(
      'Error deleting profile',
      name: 'errorDeletingProfile',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get review {
    return Intl.message('Review', name: 'review', desc: '', args: []);
  }

  /// `Rating and Reviews`
  String get ratingAndReviews {
    return Intl.message(
      'Rating and Reviews',
      name: 'ratingAndReviews',
      desc: '',
      args: [],
    );
  }

  /// `Report Scam`
  String get reportScam {
    return Intl.message('Report Scam', name: 'reportScam', desc: '', args: []);
  }

  /// `Are you sure you want to report this user for scam?`
  String get reportScamConfirmation {
    return Intl.message(
      'Are you sure you want to report this user for scam?',
      name: 'reportScamConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `This will:`
  String get reportScamConsequencesTitle {
    return Intl.message(
      'This will:',
      name: 'reportScamConsequencesTitle',
      desc: '',
      args: [],
    );
  }

  /// `• Flag this transaction for moderator review`
  String get reportScamConsequence1 {
    return Intl.message(
      '• Flag this transaction for moderator review',
      name: 'reportScamConsequence1',
      desc: '',
      args: [],
    );
  }

  /// `• Potentially suspend the other user`
  String get reportScamConsequence2 {
    return Intl.message(
      '• Potentially suspend the other user',
      name: 'reportScamConsequence2',
      desc: '',
      args: [],
    );
  }

  /// `• Require evidence from you`
  String get reportScamConsequence3 {
    return Intl.message(
      '• Require evidence from you',
      name: 'reportScamConsequence3',
      desc: '',
      args: [],
    );
  }

  /// `False reports may result in penalties to your account.`
  String get falseReportsWarning {
    return Intl.message(
      'False reports may result in penalties to your account.',
      name: 'falseReportsWarning',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get report {
    return Intl.message('Report', name: 'report', desc: '', args: []);
  }

  /// `Review Submitted!`
  String get reviewSubmitted {
    return Intl.message(
      'Review Submitted!',
      name: 'reviewSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for your feedback!`
  String get thankYouForFeedback {
    return Intl.message(
      'Thank you for your feedback!',
      name: 'thankYouForFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Your review will be visible after the other User submits their review, or in 14 days.`
  String get reviewVisibilityNotice {
    return Intl.message(
      'Your review will be visible after the other User submits their review, or in 14 days.',
      name: 'reviewVisibilityNotice',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Premium User Benefits`
  String get premiumUserBenefitsTitle {
    return Intl.message(
      'Premium User Benefits',
      name: 'premiumUserBenefitsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Unlock Premium to get these benefits:\n• Edit your name\n• Edit your profile description\n• Edit your Avatar icon\n• Add images as work references\n• Stand out on the map\n• Have a limit of more than 3 active postings`
  String get premiumUserBenefitsMessage {
    return Intl.message(
      'Unlock Premium to get these benefits:\n• Edit your name\n• Edit your profile description\n• Edit your Avatar icon\n• Add images as work references\n• Stand out on the map\n• Have a limit of more than 3 active postings',
      name: 'premiumUserBenefitsMessage',
      desc: '',
      args: [],
    );
  }

  /// `Buy Premium`
  String get buyPremium {
    return Intl.message('Buy Premium', name: 'buyPremium', desc: '', args: []);
  }

  /// `Restore Purchases`
  String get restorePurchases {
    return Intl.message(
      'Restore Purchases',
      name: 'restorePurchases',
      desc: '',
      args: [],
    );
  }

  /// `RevenueCat API key is missing.`
  String get inAppRevenueCatApiKeyMissing {
    return Intl.message(
      'RevenueCat API key is missing.',
      name: 'inAppRevenueCatApiKeyMissing',
      desc: '',
      args: [],
    );
  }

  /// `Failed to initialize purchases`
  String get inAppFailedToInitializePurchases {
    return Intl.message(
      'Failed to initialize purchases',
      name: 'inAppFailedToInitializePurchases',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load offerings`
  String get inAppFailedToLoadOfferings {
    return Intl.message(
      'Failed to load offerings',
      name: 'inAppFailedToLoadOfferings',
      desc: '',
      args: [],
    );
  }

  /// `No premium packages available right now.`
  String get inAppNoPremiumPackagesAvailable {
    return Intl.message(
      'No premium packages available right now.',
      name: 'inAppNoPremiumPackagesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Premium activated successfully.`
  String get inAppPremiumActivatedSuccessfully {
    return Intl.message(
      'Premium activated successfully.',
      name: 'inAppPremiumActivatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Purchase completed, but entitlement not active yet.`
  String get inAppPurchaseCompletedEntitlementNotActiveYet {
    return Intl.message(
      'Purchase completed, but entitlement not active yet.',
      name: 'inAppPurchaseCompletedEntitlementNotActiveYet',
      desc: '',
      args: [],
    );
  }

  /// `Purchase cancelled.`
  String get inAppPurchaseCancelled {
    return Intl.message(
      'Purchase cancelled.',
      name: 'inAppPurchaseCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Purchase failed`
  String get inAppPurchaseFailed {
    return Intl.message(
      'Purchase failed',
      name: 'inAppPurchaseFailed',
      desc: '',
      args: [],
    );
  }

  /// `Premium restored successfully.`
  String get inAppPremiumRestoredSuccessfully {
    return Intl.message(
      'Premium restored successfully.',
      name: 'inAppPremiumRestoredSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `No active Premium purchases found to restore.`
  String get inAppNoActivePremiumPurchasesToRestore {
    return Intl.message(
      'No active Premium purchases found to restore.',
      name: 'inAppNoActivePremiumPurchasesToRestore',
      desc: '',
      args: [],
    );
  }

  /// `Restore failed`
  String get inAppRestoreFailed {
    return Intl.message(
      'Restore failed',
      name: 'inAppRestoreFailed',
      desc: '',
      args: [],
    );
  }

  /// `Skip Review?`
  String get skipReviewTitle {
    return Intl.message(
      'Skip Review?',
      name: 'skipReviewTitle',
      desc: '',
      args: [],
    );
  }

  /// `You can review this user later from your transaction history. Reviews help build trust in the community.`
  String get skipReviewMessage {
    return Intl.message(
      'You can review this user later from your transaction history. Reviews help build trust in the community.',
      name: 'skipReviewMessage',
      desc: '',
      args: [],
    );
  }

  /// `Go Back`
  String get goBack {
    return Intl.message('Go Back', name: 'goBack', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Review {userName}`
  String reviewUser(String userName) {
    return Intl.message(
      'Review $userName',
      name: 'reviewUser',
      desc: '',
      args: [userName],
    );
  }

  /// `Rating *`
  String get ratingRequired {
    return Intl.message('Rating *', name: 'ratingRequired', desc: '', args: []);
  }

  /// `Excellent`
  String get ratingExcellent {
    return Intl.message(
      'Excellent',
      name: 'ratingExcellent',
      desc: '',
      args: [],
    );
  }

  /// `Good`
  String get ratingGood {
    return Intl.message('Good', name: 'ratingGood', desc: '', args: []);
  }

  /// `Okay`
  String get ratingOkay {
    return Intl.message('Okay', name: 'ratingOkay', desc: '', args: []);
  }

  /// `Poor`
  String get ratingPoor {
    return Intl.message('Poor', name: 'ratingPoor', desc: '', args: []);
  }

  /// `Very Bad`
  String get ratingVeryBad {
    return Intl.message('Very Bad', name: 'ratingVeryBad', desc: '', args: []);
  }

  /// `Tap to rate`
  String get tapToRate {
    return Intl.message('Tap to rate', name: 'tapToRate', desc: '', args: []);
  }

  /// `How did it go? *`
  String get howDidItGo {
    return Intl.message(
      'How did it go? *',
      name: 'howDidItGo',
      desc: '',
      args: [],
    );
  }

  /// `Successful Trade`
  String get transactionStatusSuccessful {
    return Intl.message(
      'Successful Trade',
      name: 'transactionStatusSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get transactionStatusCancelled {
    return Intl.message(
      'Cancelled',
      name: 'transactionStatusCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Talked but no deal`
  String get transactionStatusNoDeal {
    return Intl.message(
      'Talked but no deal',
      name: 'transactionStatusNoDeal',
      desc: '',
      args: [],
    );
  }

  /// `🚩 Report Scam`
  String get transactionStatusScam {
    return Intl.message(
      '🚩 Report Scam',
      name: 'transactionStatusScam',
      desc: '',
      args: [],
    );
  }

  /// `Tell us more (optional)`
  String get tellUsMore {
    return Intl.message(
      'Tell us more (optional)',
      name: 'tellUsMore',
      desc: '',
      args: [],
    );
  }

  /// `Share your experience...`
  String get shareYourExperience {
    return Intl.message(
      'Share your experience...',
      name: 'shareYourExperience',
      desc: '',
      args: [],
    );
  }

  /// `Be specific and constructive`
  String get beSpecificAndConstructive {
    return Intl.message(
      'Be specific and constructive',
      name: 'beSpecificAndConstructive',
      desc: '',
      args: [],
    );
  }

  /// `Review Guidelines`
  String get reviewGuidelines {
    return Intl.message(
      'Review Guidelines',
      name: 'reviewGuidelines',
      desc: '',
      args: [],
    );
  }

  /// `Be honest and fair`
  String get guidelineHonest {
    return Intl.message(
      'Be honest and fair',
      name: 'guidelineHonest',
      desc: '',
      args: [],
    );
  }

  /// `Focus on your actual experience`
  String get guidelineFocusExperience {
    return Intl.message(
      'Focus on your actual experience',
      name: 'guidelineFocusExperience',
      desc: '',
      args: [],
    );
  }

  /// `Reviews become visible after both parties submit`
  String get guidelineVisibility {
    return Intl.message(
      'Reviews become visible after both parties submit',
      name: 'guidelineVisibility',
      desc: '',
      args: [],
    );
  }

  /// `You have 90 days to submit a review`
  String get guideline90Days {
    return Intl.message(
      'You have 90 days to submit a review',
      name: 'guideline90Days',
      desc: '',
      args: [],
    );
  }

  /// `False reports may result in account suspension`
  String get guidelineFalseReports {
    return Intl.message(
      'False reports may result in account suspension',
      name: 'guidelineFalseReports',
      desc: '',
      args: [],
    );
  }

  /// `Submit Review`
  String get submitReview {
    return Intl.message(
      'Submit Review',
      name: 'submitReview',
      desc: '',
      args: [],
    );
  }

  /// `Skip for Now`
  String get skipForNow {
    return Intl.message('Skip for Now', name: 'skipForNow', desc: '', args: []);
  }

  /// `Bonus / Tip (optional)`
  String get bonusTipOptional {
    return Intl.message(
      'Bonus / Tip (optional)',
      name: 'bonusTipOptional',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `Enter bonus amount`
  String get enterBonusAmount {
    return Intl.message(
      'Enter bonus amount',
      name: 'enterBonusAmount',
      desc: '',
      args: [],
    );
  }

  /// `Loading wallet balance...`
  String get loadingWalletBalance {
    return Intl.message(
      'Loading wallet balance...',
      name: 'loadingWalletBalance',
      desc: '',
      args: [],
    );
  }

  /// `Current wallet balance: {amount}`
  String currentWalletBalance(String amount) {
    return Intl.message(
      'Current wallet balance: $amount',
      name: 'currentWalletBalance',
      desc: '',
      args: [amount],
    );
  }

  /// `Failed to submit review`
  String get failedToSubmitReview {
    return Intl.message(
      'Failed to submit review',
      name: 'failedToSubmitReview',
      desc: '',
      args: [],
    );
  }

  /// `Appeal review`
  String get appealReviewTitle {
    return Intl.message(
      'Appeal review',
      name: 'appealReviewTitle',
      desc: '',
      args: [],
    );
  }

  /// `Describe why this review should be reconsidered`
  String get appealReviewReasonHint {
    return Intl.message(
      'Describe why this review should be reconsidered',
      name: 'appealReviewReasonHint',
      desc: '',
      args: [],
    );
  }

  /// `Appeal reason is required`
  String get appealReasonRequired {
    return Intl.message(
      'Appeal reason is required',
      name: 'appealReasonRequired',
      desc: '',
      args: [],
    );
  }

  /// `Failed to submit appeal`
  String get failedToSubmitAppeal {
    return Intl.message(
      'Failed to submit appeal',
      name: 'failedToSubmitAppeal',
      desc: '',
      args: [],
    );
  }

  /// `Unable to submit appeal right now`
  String get unableToSubmitAppealNow {
    return Intl.message(
      'Unable to submit appeal right now',
      name: 'unableToSubmitAppealNow',
      desc: '',
      args: [],
    );
  }

  /// `Archive Conversation?`
  String get archiveConversationTitle {
    return Intl.message(
      'Archive Conversation?',
      name: 'archiveConversationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Would you like to archive this conversation now?`
  String get archiveConversationMessage {
    return Intl.message(
      'Would you like to archive this conversation now?',
      name: 'archiveConversationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Keep`
  String get keep {
    return Intl.message('Keep', name: 'keep', desc: '', args: []);
  }

  /// `Archive`
  String get archive {
    return Intl.message('Archive', name: 'archive', desc: '', args: []);
  }

  /// `Unable to review this user at this time`
  String get unableToReviewUser {
    return Intl.message(
      'Unable to review this user at this time',
      name: 'unableToReviewUser',
      desc: '',
      args: [],
    );
  }

  /// `Barter Coins`
  String get barterCoinsTitle {
    return Intl.message(
      'Barter Coins',
      name: 'barterCoinsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Coins can be earned by providing a service, or by actively using the app.\n\nCoins can be spent on: standing out on the map, boosting postings, custom Avatar icons, tipping other Users`
  String get barterCoinsInfoMessage {
    return Intl.message(
      'Coins can be earned by providing a service, or by actively using the app.\n\nCoins can be spent on: standing out on the map, boosting postings, custom Avatar icons, tipping other Users',
      name: 'barterCoinsInfoMessage',
      desc: '',
      args: [],
    );
  }

  /// `Purchase coins`
  String get purchaseCoins {
    return Intl.message(
      'Purchase coins',
      name: 'purchaseCoins',
      desc: '',
      args: [],
    );
  }

  /// `Select coin package:`
  String get selectCoinPackage {
    return Intl.message(
      'Select coin package:',
      name: 'selectCoinPackage',
      desc: '',
      args: [],
    );
  }

  /// `Selected coin package: {amount}`
  String selectedCoinPackage(String amount) {
    return Intl.message(
      'Selected coin package: $amount',
      name: 'selectedCoinPackage',
      desc: '',
      args: [amount],
    );
  }

  /// `Purchase coins flow coming soon`
  String get purchaseCoinsFlowComingSoon {
    return Intl.message(
      'Purchase coins flow coming soon',
      name: 'purchaseCoinsFlowComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Avatar Shop`
  String get avatarShopTitle {
    return Intl.message(
      'Avatar Shop',
      name: 'avatarShopTitle',
      desc: '',
      args: [],
    );
  }

  /// `Buy and apply a custom avatar icon.`
  String get avatarShopDescription {
    return Intl.message(
      'Buy and apply a custom avatar icon.',
      name: 'avatarShopDescription',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get avatarShopRefresh {
    return Intl.message(
      'Refresh',
      name: 'avatarShopRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Balance: {amount} ₿`
  String avatarShopBalance(String amount) {
    return Intl.message(
      'Balance: $amount ₿',
      name: 'avatarShopBalance',
      desc: '',
      args: [amount],
    );
  }

  /// `Each avatar: {price} ₿`
  String avatarShopEachAvatarPrice(String price) {
    return Intl.message(
      'Each avatar: $price ₿',
      name: 'avatarShopEachAvatarPrice',
      desc: '',
      args: [price],
    );
  }

  /// `Failed to load avatar shop: {error}`
  String avatarShopLoadFailed(String error) {
    return Intl.message(
      'Failed to load avatar shop: $error',
      name: 'avatarShopLoadFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Unable to process purchase right now.`
  String get avatarShopUnableToProcessPurchase {
    return Intl.message(
      'Unable to process purchase right now.',
      name: 'avatarShopUnableToProcessPurchase',
      desc: '',
      args: [],
    );
  }

  /// `This avatar is already selected.`
  String get avatarShopAvatarAlreadySelected {
    return Intl.message(
      'This avatar is already selected.',
      name: 'avatarShopAvatarAlreadySelected',
      desc: '',
      args: [],
    );
  }

  /// `Not enough coins. You need {coins} coins.`
  String avatarShopNotEnoughCoins(int coins) {
    return Intl.message(
      'Not enough coins. You need $coins coins.',
      name: 'avatarShopNotEnoughCoins',
      desc: '',
      args: [coins],
    );
  }

  /// `Purchase failed: {error}`
  String avatarShopPurchaseFailed(String error) {
    return Intl.message(
      'Purchase failed: $error',
      name: 'avatarShopPurchaseFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Avatar purchased and applied successfully.`
  String get avatarShopPurchaseSuccess {
    return Intl.message(
      'Avatar purchased and applied successfully.',
      name: 'avatarShopPurchaseSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get avatarShopSelected {
    return Intl.message(
      'Selected',
      name: 'avatarShopSelected',
      desc: '',
      args: [],
    );
  }

  /// `Equip`
  String get avatarShopEquip {
    return Intl.message('Equip', name: 'avatarShopEquip', desc: '', args: []);
  }

  /// `Buy {coins} ₿`
  String avatarShopBuyButton(String coins) {
    return Intl.message(
      'Buy $coins ₿',
      name: 'avatarShopBuyButton',
      desc: '',
      args: [coins],
    );
  }

  /// `Need {coins} ₿`
  String avatarShopNeedCoins(String coins) {
    return Intl.message(
      'Need $coins ₿',
      name: 'avatarShopNeedCoins',
      desc: '',
      args: [coins],
    );
  }

  /// `Boost visibility`
  String get createPostingBoostTitle {
    return Intl.message(
      'Boost visibility',
      name: 'createPostingBoostTitle',
      desc: '',
      args: [],
    );
  }

  /// `Spend coins to boost this posting in search results.`
  String get createPostingBoostDescription {
    return Intl.message(
      'Spend coins to boost this posting in search results.',
      name: 'createPostingBoostDescription',
      desc: '',
      args: [],
    );
  }

  /// `No boost`
  String get createPostingBoostNone {
    return Intl.message(
      'No boost',
      name: 'createPostingBoostNone',
      desc: '',
      args: [],
    );
  }

  /// `3 days (20 coins)`
  String get createPostingBoost3Days {
    return Intl.message(
      '3 days (20 coins)',
      name: 'createPostingBoost3Days',
      desc: '',
      args: [],
    );
  }

  /// `7 days (50 coins)`
  String get createPostingBoost7Days {
    return Intl.message(
      '7 days (50 coins)',
      name: 'createPostingBoost7Days',
      desc: '',
      args: [],
    );
  }

  /// `Not enough coins for selected boost.`
  String get createPostingBoostInsufficientCoins {
    return Intl.message(
      'Not enough coins for selected boost.',
      name: 'createPostingBoostInsufficientCoins',
      desc: '',
      args: [],
    );
  }

  /// `Cannot send file: Recipient public key not available`
  String get cannotSendFileNoRecipientKey {
    return Intl.message(
      'Cannot send file: Recipient public key not available',
      name: 'cannotSendFileNoRecipientKey',
      desc: '',
      args: [],
    );
  }

  /// `Unable to open this chat right now. Please try again.`
  String get chatOpenFailed {
    return Intl.message(
      'Unable to open this chat right now. Please try again.',
      name: 'chatOpenFailed',
      desc: '',
      args: [],
    );
  }

  /// `Could not read the selected file. Please try another file.`
  String get fileReadFailed {
    return Intl.message(
      'Could not read the selected file. Please try another file.',
      name: 'fileReadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Unable to send the file right now. Please try again.`
  String get fileSendFailed {
    return Intl.message(
      'Unable to send the file right now. Please try again.',
      name: 'fileSendFailed',
      desc: '',
      args: [],
    );
  }

  /// `Unable to download this file right now. Please try again.`
  String get fileDownloadFailed {
    return Intl.message(
      'Unable to download this file right now. Please try again.',
      name: 'fileDownloadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Cannot decrypt this file yet. Try again after the chat keys are synchronized.`
  String get fileDecryptKeyMissing {
    return Intl.message(
      'Cannot decrypt this file yet. Try again after the chat keys are synchronized.',
      name: 'fileDecryptKeyMissing',
      desc: '',
      args: [],
    );
  }

  /// `Could not open this file. Please try another app or check the file path.`
  String get couldNotOpenFileGeneric {
    return Intl.message(
      'Could not open this file. Please try another app or check the file path.',
      name: 'couldNotOpenFileGeneric',
      desc: '',
      args: [],
    );
  }

  /// `Device`
  String get gallery {
    return Intl.message('Device', name: 'gallery', desc: '', args: []);
  }

  /// `Camera`
  String get camera {
    return Intl.message('Camera', name: 'camera', desc: '', args: []);
  }

  /// `Uploading file...`
  String get uploadingFile {
    return Intl.message(
      'Uploading file...',
      name: 'uploadingFile',
      desc: '',
      args: [],
    );
  }

  /// `File sent successfully!`
  String get fileSentSuccessfully {
    return Intl.message(
      'File sent successfully!',
      name: 'fileSentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Downloading {filename}...`
  String downloadingFile(String filename) {
    return Intl.message(
      'Downloading $filename...',
      name: 'downloadingFile',
      desc: '',
      args: [filename],
    );
  }

  /// `Decrypting {filename}...`
  String decryptingFile(String filename) {
    return Intl.message(
      'Decrypting $filename...',
      name: 'decryptingFile',
      desc: '',
      args: [filename],
    );
  }

  /// `Download failed: {error}`
  String downloadFailed(String error) {
    return Intl.message(
      'Download failed: $error',
      name: 'downloadFailed',
      desc: '',
      args: [error],
    );
  }

  /// `No app found to open this file type`
  String get noAppToOpenFile {
    return Intl.message(
      'No app found to open this file type',
      name: 'noAppToOpenFile',
      desc: '',
      args: [],
    );
  }

  /// `File saved at: {filePath}`
  String fileSavedAt(String filePath) {
    return Intl.message(
      'File saved at: $filePath',
      name: 'fileSavedAt',
      desc: '',
      args: [filePath],
    );
  }

  /// `File not found: {filePath}`
  String fileNotFound(String filePath) {
    return Intl.message(
      'File not found: $filePath',
      name: 'fileNotFound',
      desc: '',
      args: [filePath],
    );
  }

  /// `Permission denied to open file`
  String get permissionDeniedOpenFile {
    return Intl.message(
      'Permission denied to open file',
      name: 'permissionDeniedOpenFile',
      desc: '',
      args: [],
    );
  }

  /// `Error opening file: {message}`
  String errorOpeningFile(String message) {
    return Intl.message(
      'Error opening file: $message',
      name: 'errorOpeningFile',
      desc: '',
      args: [message],
    );
  }

  /// `Could not open file: {error}`
  String couldNotOpenFile(String error) {
    return Intl.message(
      'Could not open file: $error',
      name: 'couldNotOpenFile',
      desc: '',
      args: [error],
    );
  }

  /// `Finish Transaction`
  String get finishTransaction {
    return Intl.message(
      'Finish Transaction',
      name: 'finishTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to mark this transaction as completed?`
  String get finishTransactionConfirmation {
    return Intl.message(
      'Are you sure you want to mark this transaction as completed?',
      name: 'finishTransactionConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Transaction created successfully`
  String get transactionCreated {
    return Intl.message(
      'Transaction created successfully',
      name: 'transactionCreated',
      desc: '',
      args: [],
    );
  }

  /// `Transaction marked as completed`
  String get transactionCompleted {
    return Intl.message(
      'Transaction marked as completed',
      name: 'transactionCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Error creating transaction: {error}`
  String errorCreatingTransaction(String error) {
    return Intl.message(
      'Error creating transaction: $error',
      name: 'errorCreatingTransaction',
      desc: '',
      args: [error],
    );
  }

  /// `Error updating transaction: {error}`
  String errorUpdatingTransaction(String error) {
    return Intl.message(
      'Error updating transaction: $error',
      name: 'errorUpdatingTransaction',
      desc: '',
      args: [error],
    );
  }

  /// `No Users Nearby`
  String get noUsersNearbyTitle {
    return Intl.message(
      'No Users Nearby',
      name: 'noUsersNearbyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your area is currently still growing. Invite people you know and help grow the community — your first referral earns 50 coins!`
  String get noUsersNearbyMessage {
    return Intl.message(
      'Your area is currently still growing. Invite people you know and help grow the community — your first referral earns 50 coins!',
      name: 'noUsersNearbyMessage',
      desc: '',
      args: [],
    );
  }

  /// `Notify me when {count}+ users are nearby`
  String nearbyUsersAlertCheckboxTitle(int count) {
    return Intl.message(
      'Notify me when $count+ users are nearby',
      name: 'nearbyUsersAlertCheckboxTitle',
      desc: '',
      args: [count],
    );
  }

  /// `We’ll send an alert when enough users appear in your area.`
  String get nearbyUsersAlertCheckboxSubtitle {
    return Intl.message(
      'We’ll send an alert when enough users appear in your area.',
      name: 'nearbyUsersAlertCheckboxSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Checking alert preference...`
  String get nearbyUsersAlertLoading {
    return Intl.message(
      'Checking alert preference...',
      name: 'nearbyUsersAlertLoading',
      desc: '',
      args: [],
    );
  }

  /// `Nearby users alert enabled.`
  String get nearbyUsersAlertEnabled {
    return Intl.message(
      'Nearby users alert enabled.',
      name: 'nearbyUsersAlertEnabled',
      desc: '',
      args: [],
    );
  }

  /// `Nearby users alert disabled.`
  String get nearbyUsersAlertDisabled {
    return Intl.message(
      'Nearby users alert disabled.',
      name: 'nearbyUsersAlertDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Unable to update nearby users alert right now.`
  String get nearbyUsersAlertSaveError {
    return Intl.message(
      'Unable to update nearby users alert right now.',
      name: 'nearbyUsersAlertSaveError',
      desc: '',
      args: [],
    );
  }

  /// `Manage where nearby-user alerts are delivered.`
  String get nearbyUsersAlertManageDelivery {
    return Intl.message(
      'Manage where nearby-user alerts are delivered.',
      name: 'nearbyUsersAlertManageDelivery',
      desc: '',
      args: [],
    );
  }

  /// `E-mail where to receive the notification`
  String get notificationEmailTitle {
    return Intl.message(
      'E-mail where to receive the notification',
      name: 'notificationEmailTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add an email address so we can notify you even if push notifications are unavailable.`
  String get notificationEmailSubtitle {
    return Intl.message(
      'Add an email address so we can notify you even if push notifications are unavailable.',
      name: 'notificationEmailSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Email address`
  String get notificationEmailLabel {
    return Intl.message(
      'Email address',
      name: 'notificationEmailLabel',
      desc: '',
      args: [],
    );
  }

  /// `Save email`
  String get notificationEmailSave {
    return Intl.message(
      'Save email',
      name: 'notificationEmailSave',
      desc: '',
      args: [],
    );
  }

  /// `Notification email saved.`
  String get notificationEmailSaved {
    return Intl.message(
      'Notification email saved.',
      name: 'notificationEmailSaved',
      desc: '',
      args: [],
    );
  }

  /// `Unable to save notification email right now.`
  String get notificationEmailSaveError {
    return Intl.message(
      'Unable to save notification email right now.',
      name: 'notificationEmailSaveError',
      desc: '',
      args: [],
    );
  }

  /// `Enter an email address.`
  String get notificationEmailRequired {
    return Intl.message(
      'Enter an email address.',
      name: 'notificationEmailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email address.`
  String get notificationEmailInvalid {
    return Intl.message(
      'Enter a valid email address.',
      name: 'notificationEmailInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Alerts can be sent to {email}`
  String notificationEmailConfigured(String email) {
    return Intl.message(
      'Alerts can be sent to $email',
      name: 'notificationEmailConfigured',
      desc: '',
      args: [email],
    );
  }

  /// `Share App`
  String get shareApp {
    return Intl.message('Share App', name: 'shareApp', desc: '', args: []);
  }

  /// `Copy Link`
  String get copyLink {
    return Intl.message('Copy Link', name: 'copyLink', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Badges`
  String get badgesTitle {
    return Intl.message('Badges', name: 'badgesTitle', desc: '', args: []);
  }

  /// `No badges earned yet. Keep trading to unlock badges.`
  String get noBadgesEarnedYet {
    return Intl.message(
      'No badges earned yet. Keep trading to unlock badges.',
      name: 'noBadgesEarnedYet',
      desc: '',
      args: [],
    );
  }

  /// `Earned`
  String get badgeEarnedStatus {
    return Intl.message(
      'Earned',
      name: 'badgeEarnedStatus',
      desc: '',
      args: [],
    );
  }

  /// `Not earned yet`
  String get badgeNotEarnedStatus {
    return Intl.message(
      'Not earned yet',
      name: 'badgeNotEarnedStatus',
      desc: '',
      args: [],
    );
  }

  /// `Identity Verified`
  String get badgeIdentityVerifiedTitle {
    return Intl.message(
      'Identity Verified',
      name: 'badgeIdentityVerifiedTitle',
      desc: '',
      args: [],
    );
  }

  /// `User has completed identity verification.`
  String get badgeIdentityVerifiedDescription {
    return Intl.message(
      'User has completed identity verification.',
      name: 'badgeIdentityVerifiedDescription',
      desc: '',
      args: [],
    );
  }

  /// `Veteran Trader`
  String get badgeVeteranTraderTitle {
    return Intl.message(
      'Veteran Trader',
      name: 'badgeVeteranTraderTitle',
      desc: '',
      args: [],
    );
  }

  /// `User has completed 100+ successful trades.`
  String get badgeVeteranTraderDescription {
    return Intl.message(
      'User has completed 100+ successful trades.',
      name: 'badgeVeteranTraderDescription',
      desc: '',
      args: [],
    );
  }

  /// `Top Rated Seller`
  String get badgeTopRatedTitle {
    return Intl.message(
      'Top Rated Seller',
      name: 'badgeTopRatedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Maintains 4.8+ average rating with 50+ reviews.`
  String get badgeTopRatedDescription {
    return Intl.message(
      'Maintains 4.8+ average rating with 50+ reviews.',
      name: 'badgeTopRatedDescription',
      desc: '',
      args: [],
    );
  }

  /// `Quick Responder`
  String get badgeQuickResponderTitle {
    return Intl.message(
      'Quick Responder',
      name: 'badgeQuickResponderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Usually responds within 24 hours.`
  String get badgeQuickResponderDescription {
    return Intl.message(
      'Usually responds within 24 hours.',
      name: 'badgeQuickResponderDescription',
      desc: '',
      args: [],
    );
  }

  /// `Community Connector`
  String get badgeCommunityConnectorTitle {
    return Intl.message(
      'Community Connector',
      name: 'badgeCommunityConnectorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Trades with diverse partners (high diversity score).`
  String get badgeCommunityConnectorDescription {
    return Intl.message(
      'Trades with diverse partners (high diversity score).',
      name: 'badgeCommunityConnectorDescription',
      desc: '',
      args: [],
    );
  }

  /// `Local Legend`
  String get badgeVerifiedBusinessTitle {
    return Intl.message(
      'Local Legend',
      name: 'badgeVerifiedBusinessTitle',
      desc: '',
      args: [],
    );
  }

  /// `Favorited by 30+ Users.`
  String get badgeVerifiedBusinessDescription {
    return Intl.message(
      'Favorited by 30+ Users.',
      name: 'badgeVerifiedBusinessDescription',
      desc: '',
      args: [],
    );
  }

  /// `Dispute-Free History`
  String get badgeDisputeFreeTitle {
    return Intl.message(
      'Dispute-Free History',
      name: 'badgeDisputeFreeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Has never had a disputed transaction.`
  String get badgeDisputeFreeDescription {
    return Intl.message(
      'Has never had a disputed transaction.',
      name: 'badgeDisputeFreeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Fast & Reliable`
  String get badgeFastTraderTitle {
    return Intl.message(
      'Fast & Reliable',
      name: 'badgeFastTraderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Completes trades faster than average.`
  String get badgeFastTraderDescription {
    return Intl.message(
      'Completes trades faster than average.',
      name: 'badgeFastTraderDescription',
      desc: '',
      args: [],
    );
  }

  /// `Premium User`
  String get badgePremiumUserTitle {
    return Intl.message(
      'Premium User',
      name: 'badgePremiumUserTitle',
      desc: '',
      args: [],
    );
  }

  /// `User has an active Premium subscription.`
  String get badgePremiumUserDescription {
    return Intl.message(
      'User has an active Premium subscription.',
      name: 'badgePremiumUserDescription',
      desc: '',
      args: [],
    );
  }

  /// `Early Adopter - First 1000 Users`
  String get badgeTop1000Title {
    return Intl.message(
      'Early Adopter - First 1000 Users',
      name: 'badgeTop1000Title',
      desc: '',
      args: [],
    );
  }

  /// `User was among the first 1000 registered users.`
  String get badgeTop1000Description {
    return Intl.message(
      'User was among the first 1000 registered users.',
      name: 'badgeTop1000Description',
      desc: '',
      args: [],
    );
  }

  /// `Show more`
  String get showMore {
    return Intl.message('Show more', name: 'showMore', desc: '', args: []);
  }

  /// `Show less`
  String get showLess {
    return Intl.message('Show less', name: 'showLess', desc: '', args: []);
  }

  /// `Link copied to clipboard!`
  String get linkCopiedToClipboard {
    return Intl.message(
      'Link copied to clipboard!',
      name: 'linkCopiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Unable to share at this time`
  String get unableToShareAtThisTime {
    return Intl.message(
      'Unable to share at this time',
      name: 'unableToShareAtThisTime',
      desc: '',
      args: [],
    );
  }

  /// `Hey! Join me on BarterApp - a great way to trade items and services with people nearby! 🔄\n\n{appLink}`
  String inviteMessageShare(String appLink) {
    return Intl.message(
      'Hey! Join me on BarterApp - a great way to trade items and services with people nearby! 🔄\n\n$appLink',
      name: 'inviteMessageShare',
      desc: '',
      args: [appLink],
    );
  }

  /// `Join me on BarterApp!`
  String get inviteMessageSubject {
    return Intl.message(
      'Join me on BarterApp!',
      name: 'inviteMessageSubject',
      desc: '',
      args: [],
    );
  }

  /// `Report User`
  String get reportUser {
    return Intl.message('Report User', name: 'reportUser', desc: '', args: []);
  }

  /// `View Profile`
  String get viewProfile {
    return Intl.message(
      'View Profile',
      name: 'viewProfile',
      desc: '',
      args: [],
    );
  }

  /// `Block User`
  String get blockUser {
    return Intl.message('Block User', name: 'blockUser', desc: '', args: []);
  }

  /// `Unblock User`
  String get unblockUser {
    return Intl.message(
      'Unblock User',
      name: 'unblockUser',
      desc: '',
      args: [],
    );
  }

  /// `Please provide a reason for reporting this user.`
  String get reportUserConfirmation {
    return Intl.message(
      'Please provide a reason for reporting this user.',
      name: 'reportUserConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Reason for report (optional)`
  String get reportReason {
    return Intl.message(
      'Reason for report (optional)',
      name: 'reportReason',
      desc: '',
      args: [],
    );
  }

  /// `User reported successfully`
  String get userReported {
    return Intl.message(
      'User reported successfully',
      name: 'userReported',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to block this user? You will no longer be able to communicate with them.`
  String get blockUserConfirmation {
    return Intl.message(
      'Are you sure you want to block this user? You will no longer be able to communicate with them.',
      name: 'blockUserConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to unblock this user? They will be able to communicate with you again.`
  String get unblockUserConfirmation {
    return Intl.message(
      'Are you sure you want to unblock this user? They will be able to communicate with you again.',
      name: 'unblockUserConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Block`
  String get block {
    return Intl.message('Block', name: 'block', desc: '', args: []);
  }

  /// `Unblock`
  String get unblock {
    return Intl.message('Unblock', name: 'unblock', desc: '', args: []);
  }

  /// `User blocked successfully`
  String get userBlocked {
    return Intl.message(
      'User blocked successfully',
      name: 'userBlocked',
      desc: '',
      args: [],
    );
  }

  /// `User unblocked successfully`
  String get userUnblocked {
    return Intl.message(
      'User unblocked successfully',
      name: 'userUnblocked',
      desc: '',
      args: [],
    );
  }

  /// `Failed to block user`
  String get failedToBlockUser {
    return Intl.message(
      'Failed to block user',
      name: 'failedToBlockUser',
      desc: '',
      args: [],
    );
  }

  /// `Failed to unblock user`
  String get failedToUnblockUser {
    return Intl.message(
      'Failed to unblock user',
      name: 'failedToUnblockUser',
      desc: '',
      args: [],
    );
  }

  /// `Failed to submit report. Please try again.`
  String get failedToSubmitReport {
    return Intl.message(
      'Failed to submit report. Please try again.',
      name: 'failedToSubmitReport',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for helping keep the community safe. Would you also like to block this user?`
  String get reportSubmittedOfferBlock {
    return Intl.message(
      'Thank you for helping keep the community safe. Would you also like to block this user?',
      name: 'reportSubmittedOfferBlock',
      desc: '',
      args: [],
    );
  }

  /// `Report {userName}`
  String reportUserTitle(String userName) {
    return Intl.message(
      'Report $userName',
      name: 'reportUserTitle',
      desc: '',
      args: [userName],
    );
  }

  /// `Blocking {userName} will prevent them from:\n• Sending you messages\n• Seeing your profile\n• Commenting on your postings`
  String blockUserConfirmationDetailed(String userName) {
    return Intl.message(
      'Blocking $userName will prevent them from:\n• Sending you messages\n• Seeing your profile\n• Commenting on your postings',
      name: 'blockUserConfirmationDetailed',
      desc: '',
      args: [userName],
    );
  }

  /// `Unblocking {userName} will allow them to:\n• Send you messages\n• See your profile\n• Comment on your postings`
  String unblockUserConfirmationDetailed(String userName) {
    return Intl.message(
      'Unblocking $userName will allow them to:\n• Send you messages\n• See your profile\n• Comment on your postings',
      name: 'unblockUserConfirmationDetailed',
      desc: '',
      args: [userName],
    );
  }

  /// `Why are you reporting this user?`
  String get whyReportingUser {
    return Intl.message(
      'Why are you reporting this user?',
      name: 'whyReportingUser',
      desc: '',
      args: [],
    );
  }

  /// `Spam`
  String get reportReasonSpam {
    return Intl.message('Spam', name: 'reportReasonSpam', desc: '', args: []);
  }

  /// `Harassment`
  String get reportReasonHarassment {
    return Intl.message(
      'Harassment',
      name: 'reportReasonHarassment',
      desc: '',
      args: [],
    );
  }

  /// `Inappropriate Content`
  String get reportReasonInappropriateContent {
    return Intl.message(
      'Inappropriate Content',
      name: 'reportReasonInappropriateContent',
      desc: '',
      args: [],
    );
  }

  /// `Scam`
  String get reportReasonScam {
    return Intl.message('Scam', name: 'reportReasonScam', desc: '', args: []);
  }

  /// `Fake Profile`
  String get reportReasonFakeProfile {
    return Intl.message(
      'Fake Profile',
      name: 'reportReasonFakeProfile',
      desc: '',
      args: [],
    );
  }

  /// `Impersonation`
  String get reportReasonImpersonation {
    return Intl.message(
      'Impersonation',
      name: 'reportReasonImpersonation',
      desc: '',
      args: [],
    );
  }

  /// `Threatening Behavior`
  String get reportReasonThreateningBehavior {
    return Intl.message(
      'Threatening Behavior',
      name: 'reportReasonThreateningBehavior',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get reportReasonOther {
    return Intl.message('Other', name: 'reportReasonOther', desc: '', args: []);
  }

  /// `Additional details (optional)`
  String get additionalDetails {
    return Intl.message(
      'Additional details (optional)',
      name: 'additionalDetails',
      desc: '',
      args: [],
    );
  }

  /// `Provide more context...`
  String get provideMoreContext {
    return Intl.message(
      'Provide more context...',
      name: 'provideMoreContext',
      desc: '',
      args: [],
    );
  }

  /// `Submit Report`
  String get submitReport {
    return Intl.message(
      'Submit Report',
      name: 'submitReport',
      desc: '',
      args: [],
    );
  }

  /// `Controller, Scope and Contact`
  String get privacyPolicyIntroTitle {
    return Intl.message(
      'Controller, Scope and Contact',
      name: 'privacyPolicyIntroTitle',
      desc: '',
      args: [],
    );
  }

  /// `This policy explains how Barter backend services and connected mobile/web clients process personal data. It covers backend APIs, client apps, admin/compliance tooling, and optional federation features when enabled.`
  String get privacyPolicyIntroContent {
    return Intl.message(
      'This policy explains how Barter backend services and connected mobile/web clients process personal data. It covers backend APIs, client apps, admin/compliance tooling, and optional federation features when enabled.',
      name: 'privacyPolicyIntroContent',
      desc: '',
      args: [],
    );
  }

  /// `Data We Process`
  String get privacyPolicyDataCollectionTitle {
    return Intl.message(
      'Data We Process',
      name: 'privacyPolicyDataCollectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `We may process account/authentication data (including signature metadata), profile data, postings and chat-related data, notification data (email, push tokens, consent flags), security/compliance records, and technical request metadata.`
  String get privacyPolicyDataCollectionContent {
    return Intl.message(
      'We may process account/authentication data (including signature metadata), profile data, postings and chat-related data, notification data (email, push tokens, consent flags), security/compliance records, and technical request metadata.',
      name: 'privacyPolicyDataCollectionContent',
      desc: '',
      args: [],
    );
  }

  /// `Purposes and GDPR Legal Bases`
  String get privacyPolicyDataUsageTitle {
    return Intl.message(
      'Purposes and GDPR Legal Bases',
      name: 'privacyPolicyDataUsageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Processing supports service delivery (Art. 6(1)(b)), security and abuse prevention (Art. 6(1)(f)), and legal/compliance obligations (Art. 6(1)(c), 6(1)(f)). Where applicable, optional features and consents are processed under Art. 6(1)(a).`
  String get privacyPolicyDataUsageContent {
    return Intl.message(
      'Processing supports service delivery (Art. 6(1)(b)), security and abuse prevention (Art. 6(1)(f)), and legal/compliance obligations (Art. 6(1)(c), 6(1)(f)). Where applicable, optional features and consents are processed under Art. 6(1)(a).',
      name: 'privacyPolicyDataUsageContent',
      desc: '',
      args: [],
    );
  }

  /// `Processors, Infrastructure and Transfers`
  String get privacyPolicyDataSharingTitle {
    return Intl.message(
      'Processors, Infrastructure and Transfers',
      name: 'privacyPolicyDataSharingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Current integrations include PostgreSQL, Mailjet, Firebase/FCM, Ollama, and Nginx + Docker infrastructure. Optional federation peers are used only when enabled and trusted. If data is processed outside your country/EEA, legally required safeguards (such as SCCs) are applied.`
  String get privacyPolicyDataSharingContent {
    return Intl.message(
      'Current integrations include PostgreSQL, Mailjet, Firebase/FCM, Ollama, and Nginx + Docker infrastructure. Optional federation peers are used only when enabled and trusted. If data is processed outside your country/EEA, legally required safeguards (such as SCCs) are applied.',
      name: 'privacyPolicyDataSharingContent',
      desc: '',
      args: [],
    );
  }

  /// `Security, Retention and Deletion`
  String get privacyPolicyDataSecurityTitle {
    return Intl.message(
      'Security, Retention and Deletion',
      name: 'privacyPolicyDataSecurityTitle',
      desc: '',
      args: [],
    );
  }

  /// `We apply measures such as authenticated request-signature checks, access controls, transport security, and audit logging. Retention controls and scheduled cleanup are used for operational/compliance records, with legal-hold-aware handling where required.`
  String get privacyPolicyDataSecurityContent {
    return Intl.message(
      'We apply measures such as authenticated request-signature checks, access controls, transport security, and audit logging. Retention controls and scheduled cleanup are used for operational/compliance records, with legal-hold-aware handling where required.',
      name: 'privacyPolicyDataSecurityContent',
      desc: '',
      args: [],
    );
  }

  /// `Your Rights, Erasure and Portability`
  String get privacyPolicyUserRightsTitle {
    return Intl.message(
      'Your Rights, Erasure and Portability',
      name: 'privacyPolicyUserRightsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Subject to applicable law, you may request access, rectification, erasure, restriction, portability, objection, and consent withdrawal. Authenticated deletion/export workflows include legal-hold checks, DSAR tracking, and compliance event logging.`
  String get privacyPolicyUserRightsContent {
    return Intl.message(
      'Subject to applicable law, you may request access, rectification, erasure, restriction, portability, objection, and consent withdrawal. Authenticated deletion/export workflows include legal-hold checks, DSAR tracking, and compliance event logging.',
      name: 'privacyPolicyUserRightsContent',
      desc: '',
      args: [],
    );
  }

  /// `Backend and Client Privacy Notice`
  String get privacyPolicyThirdPartyTitle {
    return Intl.message(
      'Backend and Client Privacy Notice',
      name: 'privacyPolicyThirdPartyTitle',
      desc: '',
      args: [],
    );
  }

  /// `This in-app text summarizes backend-centric processing and should be read together with client-facing app notices (permissions, identifiers, push UX, and local storage/cookies where applicable).`
  String get privacyPolicyThirdPartyContent {
    return Intl.message(
      'This in-app text summarizes backend-centric processing and should be read together with client-facing app notices (permissions, identifiers, push UX, and local storage/cookies where applicable).',
      name: 'privacyPolicyThirdPartyContent',
      desc: '',
      args: [],
    );
  }

  /// `Changes to This Policy`
  String get privacyPolicyChangesTitle {
    return Intl.message(
      'Changes to This Policy',
      name: 'privacyPolicyChangesTitle',
      desc: '',
      args: [],
    );
  }

  /// `We may update this policy from time to time. Material changes should be communicated in-app or via another appropriate channel, with updated effective dates.`
  String get privacyPolicyChangesContent {
    return Intl.message(
      'We may update this policy from time to time. Material changes should be communicated in-app or via another appropriate channel, with updated effective dates.',
      name: 'privacyPolicyChangesContent',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get privacyPolicyContactTitle {
    return Intl.message(
      'Contact',
      name: 'privacyPolicyContactTitle',
      desc: '',
      args: [],
    );
  }

  /// `For privacy and GDPR requests, contact: info@bartering.app`
  String get privacyPolicyContactContent {
    return Intl.message(
      'For privacy and GDPR requests, contact: info@bartering.app',
      name: 'privacyPolicyContactContent',
      desc: '',
      args: [],
    );
  }

  /// `Last updated: 2026-04-13`
  String get privacyPolicyLastUpdated {
    return Intl.message(
      'Last updated: 2026-04-13',
      name: 'privacyPolicyLastUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chats {
    return Intl.message('Chats', name: 'chats', desc: '', args: []);
  }

  /// `GPS location is disabled. Enable it in Settings to use this feature.`
  String get gpsLocationDisabled {
    return Intl.message(
      'GPS location is disabled. Enable it in Settings to use this feature.',
      name: 'gpsLocationDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Recommendations:`
  String get recommendations {
    return Intl.message(
      'Recommendations:',
      name: 'recommendations',
      desc: '',
      args: [],
    );
  }

  /// `This transaction will be reviewed by our security team.`
  String get transactionWillBeReviewed {
    return Intl.message(
      'This transaction will be reviewed by our security team.',
      name: 'transactionWillBeReviewed',
      desc: '',
      args: [],
    );
  }

  /// `Continue Anyway`
  String get continueAnyway {
    return Intl.message(
      'Continue Anyway',
      name: 'continueAnyway',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Blocked`
  String get transactionBlocked {
    return Intl.message(
      'Transaction Blocked',
      name: 'transactionBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Security Warning`
  String get securityWarning {
    return Intl.message(
      'Security Warning',
      name: 'securityWarning',
      desc: '',
      args: [],
    );
  }

  /// `Security Notice`
  String get securityNotice {
    return Intl.message(
      'Security Notice',
      name: 'securityNotice',
      desc: '',
      args: [],
    );
  }

  /// `Security Check`
  String get securityCheck {
    return Intl.message(
      'Security Check',
      name: 'securityCheck',
      desc: '',
      args: [],
    );
  }

  /// `This transaction has been blocked due to suspicious activity patterns. Please contact support if you believe this is an error.`
  String get transactionBlockedMessage {
    return Intl.message(
      'This transaction has been blocked due to suspicious activity patterns. Please contact support if you believe this is an error.',
      name: 'transactionBlockedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Unusual activity has been detected. Additional verification may be required.`
  String get securityWarningMessage {
    return Intl.message(
      'Unusual activity has been detected. Additional verification may be required.',
      name: 'securityWarningMessage',
      desc: '',
      args: [],
    );
  }

  /// `We've detected some unusual patterns. Your review may be subject to additional verification.`
  String get securityNoticeMessage {
    return Intl.message(
      'We\'ve detected some unusual patterns. Your review may be subject to additional verification.',
      name: 'securityNoticeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Everything looks good!`
  String get securityCheckMessage {
    return Intl.message(
      'Everything looks good!',
      name: 'securityCheckMessage',
      desc: '',
      args: [],
    );
  }

  /// `Download started! Check your downloads folder`
  String get downloadStarted {
    return Intl.message(
      'Download started! Check your downloads folder',
      name: 'downloadStarted',
      desc: '',
      args: [],
    );
  }

  /// `Show Path`
  String get showPath {
    return Intl.message('Show Path', name: 'showPath', desc: '', args: []);
  }

  /// `Users`
  String get users {
    return Intl.message('Users', name: 'users', desc: '', args: []);
  }

  /// `Trade match`
  String get tradeMatch {
    return Intl.message('Trade match', name: 'tradeMatch', desc: '', args: []);
  }

  /// `Similar`
  String get similar {
    return Intl.message('Similar', name: 'similar', desc: '', args: []);
  }

  /// `English`
  String get languageEnglish {
    return Intl.message('English', name: 'languageEnglish', desc: '', args: []);
  }

  /// `Latviešu`
  String get languageLatvian {
    return Intl.message(
      'Latviešu',
      name: 'languageLatvian',
      desc: '',
      args: [],
    );
  }

  /// `Français`
  String get languageFrench {
    return Intl.message('Français', name: 'languageFrench', desc: '', args: []);
  }

  /// `Deutsch`
  String get languageGerman {
    return Intl.message('Deutsch', name: 'languageGerman', desc: '', args: []);
  }

  /// `Español`
  String get languageSpanish {
    return Intl.message('Español', name: 'languageSpanish', desc: '', args: []);
  }

  /// `Error: {exception}`
  String errorWithException(String exception) {
    return Intl.message(
      'Error: $exception',
      name: 'errorWithException',
      desc: '',
      args: [exception],
    );
  }

  /// `Error verifying PIN`
  String get errorVerifyingPin {
    return Intl.message(
      'Error verifying PIN',
      name: 'errorVerifyingPin',
      desc: '',
      args: [],
    );
  }

  /// `Delete All`
  String get deleteAll {
    return Intl.message('Delete All', name: 'deleteAll', desc: '', args: []);
  }

  /// `Are you sure you want to delete all match history? This action cannot be undone.`
  String get deleteAllMatchesConfirmation {
    return Intl.message(
      'Are you sure you want to delete all match history? This action cannot be undone.',
      name: 'deleteAllMatchesConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `All matches have been deleted`
  String get allMatchesDeleted {
    return Intl.message(
      'All matches have been deleted',
      name: 'allMatchesDeleted',
      desc: '',
      args: [],
    );
  }

  /// `What services or items do you need?\nYou can change this later.`
  String get selectTheInterestsThatMatchYourPreferences {
    return Intl.message(
      'What services or items do you need?\nYou can change this later.',
      name: 'selectTheInterestsThatMatchYourPreferences',
      desc: '',
      args: [],
    );
  }

  /// `What can you provide or help out with?\nYou can change this later.`
  String get selectTheOffersThatYouCanProvide {
    return Intl.message(
      'What can you provide or help out with?\nYou can change this later.',
      name: 'selectTheOffersThatYouCanProvide',
      desc: '',
      args: [],
    );
  }

  /// `Share your interests to find the best matches with others!`
  String get shareYourInterestsToFindBestMatches {
    return Intl.message(
      'Share your interests to find the best matches with others!',
      name: 'shareYourInterestsToFindBestMatches',
      desc: '',
      args: [],
    );
  }

  /// `Migrate to New Device`
  String get migrateToNewDevice {
    return Intl.message(
      'Migrate to New Device',
      name: 'migrateToNewDevice',
      desc: '',
      args: [],
    );
  }

  /// `Migrate Your Account`
  String get migrateYourAccount {
    return Intl.message(
      'Migrate Your Account',
      name: 'migrateYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Generate a migration code to transfer your account data to a new device. The code will be valid for 15 minutes.`
  String get migrationCodeDescription {
    return Intl.message(
      'Generate a migration code to transfer your account data to a new device. The code will be valid for 15 minutes.',
      name: 'migrationCodeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Generate Migration Code`
  String get generateMigrationCode {
    return Intl.message(
      'Generate Migration Code',
      name: 'generateMigrationCode',
      desc: '',
      args: [],
    );
  }

  /// `Generating...`
  String get generating {
    return Intl.message(
      'Generating...',
      name: 'generating',
      desc: '',
      args: [],
    );
  }

  /// `Your Migration Code`
  String get yourMigrationCode {
    return Intl.message(
      'Your Migration Code',
      name: 'yourMigrationCode',
      desc: '',
      args: [],
    );
  }

  /// `Expires in: {time}`
  String expiresIn(String time) {
    return Intl.message(
      'Expires in: $time',
      name: 'expiresIn',
      desc: '',
      args: [time],
    );
  }

  /// `Copy Code`
  String get copyCode {
    return Intl.message('Copy Code', name: 'copyCode', desc: '', args: []);
  }

  /// `Migration code copied to clipboard`
  String get codeCopied {
    return Intl.message(
      'Migration code copied to clipboard',
      name: 'codeCopied',
      desc: '',
      args: [],
    );
  }

  /// `Generate New Code`
  String get generateNewCode {
    return Intl.message(
      'Generate New Code',
      name: 'generateNewCode',
      desc: '',
      args: [],
    );
  }

  /// `Generate a migration code`
  String get migrationStep1 {
    return Intl.message(
      'Generate a migration code',
      name: 'migrationStep1',
      desc: '',
      args: [],
    );
  }

  /// `Open the app on your new device`
  String get migrationStep2 {
    return Intl.message(
      'Open the app on your new device',
      name: 'migrationStep2',
      desc: '',
      args: [],
    );
  }

  /// `Tap "Import Existing Account" on the welcome screen`
  String get migrationStep3 {
    return Intl.message(
      'Tap "Import Existing Account" on the welcome screen',
      name: 'migrationStep3',
      desc: '',
      args: [],
    );
  }

  /// `Enter this code on the new device`
  String get migrationStep4 {
    return Intl.message(
      'Enter this code on the new device',
      name: 'migrationStep4',
      desc: '',
      args: [],
    );
  }

  /// `New Device Detected`
  String get newDeviceDetected {
    return Intl.message(
      'New Device Detected',
      name: 'newDeviceDetected',
      desc: '',
      args: [],
    );
  }

  /// `A new device wants to import your account data. Do you want to allow this?`
  String get newDeviceDetectedMessage {
    return Intl.message(
      'A new device wants to import your account data. Do you want to allow this?',
      name: 'newDeviceDetectedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Deny`
  String get deny {
    return Intl.message('Deny', name: 'deny', desc: '', args: []);
  }

  /// `Allow`
  String get allow {
    return Intl.message('Allow', name: 'allow', desc: '', args: []);
  }

  /// `Migration denied by user`
  String get migrationDenied {
    return Intl.message(
      'Migration denied by user',
      name: 'migrationDenied',
      desc: '',
      args: [],
    );
  }

  /// `Migration completed successfully!`
  String get migrationCompleted {
    return Intl.message(
      'Migration completed successfully!',
      name: 'migrationCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send migration data`
  String get failedToSendMigration {
    return Intl.message(
      'Failed to send migration data',
      name: 'failedToSendMigration',
      desc: '',
      args: [],
    );
  }

  /// `Migration code has expired. Please generate a new one.`
  String get migrationCodeExpired {
    return Intl.message(
      'Migration code has expired. Please generate a new one.',
      name: 'migrationCodeExpired',
      desc: '',
      args: [],
    );
  }

  /// `Target device did not join in time`
  String get targetDeviceTimeout {
    return Intl.message(
      'Target device did not join in time',
      name: 'targetDeviceTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Expired`
  String get expired {
    return Intl.message('Expired', name: 'expired', desc: '', args: []);
  }

  /// `Import Account`
  String get importAccount {
    return Intl.message(
      'Import Account',
      name: 'importAccount',
      desc: '',
      args: [],
    );
  }

  /// `Enter the 10-character migration code from your other device to import your account data.`
  String get importAccountDescription {
    return Intl.message(
      'Enter the 10-character migration code from your other device to import your account data.',
      name: 'importAccountDescription',
      desc: '',
      args: [],
    );
  }

  /// `Failed to join migration session`
  String get failedToJoinMigration {
    return Intl.message(
      'Failed to join migration session',
      name: 'failedToJoinMigration',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send recovery code`
  String get failedToSendCode {
    return Intl.message(
      'Failed to send recovery code',
      name: 'failedToSendCode',
      desc: '',
      args: [],
    );
  }

  /// `Migration timed out. Please try again with a new code.`
  String get migrationTimedOut {
    return Intl.message(
      'Migration timed out. Please try again with a new code.',
      name: 'migrationTimedOut',
      desc: '',
      args: [],
    );
  }

  /// `Failed to process migration data`
  String get failedToProcessMigration {
    return Intl.message(
      'Failed to process migration data',
      name: 'failedToProcessMigration',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Import or delete Account`
  String get importExistingAccount {
    return Intl.message(
      'Import or delete Account',
      name: 'importExistingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Open the app on your other device`
  String get targetStep1 {
    return Intl.message(
      'Open the app on your other device',
      name: 'targetStep1',
      desc: '',
      args: [],
    );
  }

  /// `Go to Settings → Account → Migrate Device`
  String get targetStep2 {
    return Intl.message(
      'Go to Settings → Account → Migrate Device',
      name: 'targetStep2',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code shown on that device here`
  String get targetStep3 {
    return Intl.message(
      'Enter the code shown on that device here',
      name: 'targetStep3',
      desc: '',
      args: [],
    );
  }

  /// `Recover via Email`
  String get recoverViaEmail {
    return Intl.message(
      'Recover via Email',
      name: 'recoverViaEmail',
      desc: '',
      args: [],
    );
  }

  /// `Recover Account`
  String get recoverAccount {
    return Intl.message(
      'Recover Account',
      name: 'recoverAccount',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address to receive a recovery code and restore your account on this device.`
  String get recoverAccountDescription {
    return Intl.message(
      'Enter your email address to receive a recovery code and restore your account on this device.',
      name: 'recoverAccountDescription',
      desc: '',
      args: [],
    );
  }

  /// `Send Recovery Code`
  String get sendRecoveryCode {
    return Intl.message(
      'Send Recovery Code',
      name: 'sendRecoveryCode',
      desc: '',
      args: [],
    );
  }

  /// `Recovery code sent to {email}`
  String codeSentTo(Object email) {
    return Intl.message(
      'Recovery code sent to $email',
      name: 'codeSentTo',
      desc: '',
      args: [email],
    );
  }

  /// `Resend Code`
  String get resendCode {
    return Intl.message('Resend Code', name: 'resendCode', desc: '', args: []);
  }

  /// `Resend code in {seconds}s`
  String resendCodeIn(Object seconds) {
    return Intl.message(
      'Resend code in ${seconds}s',
      name: 'resendCodeIn',
      desc: '',
      args: [seconds],
    );
  }

  /// `Verify & Recover`
  String get verifyAndRecover {
    return Intl.message(
      'Verify & Recover',
      name: 'verifyAndRecover',
      desc: '',
      args: [],
    );
  }

  /// `Invalid recovery code`
  String get invalidCode {
    return Intl.message(
      'Invalid recovery code',
      name: 'invalidCode',
      desc: '',
      args: [],
    );
  }

  /// `Account recovery failed`
  String get recoveryFailed {
    return Intl.message(
      'Account recovery failed',
      name: 'recoveryFailed',
      desc: '',
      args: [],
    );
  }

  /// `Recovery Successful!`
  String get recoverySuccess {
    return Intl.message(
      'Recovery Successful!',
      name: 'recoverySuccess',
      desc: '',
      args: [],
    );
  }

  /// `Your account has been successfully recovered on this device.`
  String get recoverySuccessMessage {
    return Intl.message(
      'Your account has been successfully recovered on this device.',
      name: 'recoverySuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `No users found`
  String get noUsersFound {
    return Intl.message(
      'No users found',
      name: 'noUsersFound',
      desc: '',
      args: [],
    );
  }

  /// `No postings found`
  String get noPostingsFound {
    return Intl.message(
      'No postings found',
      name: 'noPostingsFound',
      desc: '',
      args: [],
    );
  }

  /// `Enable GPS Location`
  String get settingsGpsLocationTitle {
    return Intl.message(
      'Enable GPS Location',
      name: 'settingsGpsLocationTitle',
      desc: '',
      args: [],
    );
  }

  /// `GPS location tracking is enabled`
  String get settingsGpsLocationEnabledDescription {
    return Intl.message(
      'GPS location tracking is enabled',
      name: 'settingsGpsLocationEnabledDescription',
      desc: '',
      args: [],
    );
  }

  /// `GPS location tracking is disabled`
  String get settingsGpsLocationDisabledDescription {
    return Intl.message(
      'GPS location tracking is disabled',
      name: 'settingsGpsLocationDisabledDescription',
      desc: '',
      args: [],
    );
  }

  /// `When enabled, you can zoom to your current GPS location on the map. The app will request location permissions when needed.`
  String get settingsGpsLocationDescription {
    return Intl.message(
      'When enabled, you can zoom to your current GPS location on the map. The app will request location permissions when needed.',
      name: 'settingsGpsLocationDescription',
      desc: '',
      args: [],
    );
  }

  /// `Location permission is required to use GPS location tracking. Please enable location permission in your device settings.`
  String get locationPermissionRequiredDescription {
    return Intl.message(
      'Location permission is required to use GPS location tracking. Please enable location permission in your device settings.',
      name: 'locationPermissionRequiredDescription',
      desc: '',
      args: [],
    );
  }

  /// `Open Settings`
  String get openSettings {
    return Intl.message(
      'Open Settings',
      name: 'openSettings',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profilePanelTitle {
    return Intl.message(
      'Profile',
      name: 'profilePanelTitle',
      desc: '',
      args: [],
    );
  }

  /// `Request collected data export`
  String get requestCollectedDataExport {
    return Intl.message(
      'Request collected data export',
      name: 'requestCollectedDataExport',
      desc: '',
      args: [],
    );
  }

  /// `Your data export request has been accepted.`
  String get dataExportRequestAccepted {
    return Intl.message(
      'Your data export request has been accepted.',
      name: 'dataExportRequestAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Failed to request data export.`
  String get dataExportRequestFailed {
    return Intl.message(
      'Failed to request data export.',
      name: 'dataExportRequestFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please add an email in Notification Preferences before requesting data export.`
  String get dataExportEmailRequired {
    return Intl.message(
      'Please add an email in Notification Preferences before requesting data export.',
      name: 'dataExportEmailRequired',
      desc: '',
      args: [],
    );
  }

  /// `{count} {count, plural, =1{review} other{reviews}}`
  String reviewsCount(int count) {
    return Intl.message(
      '$count ${Intl.plural(count, one: 'review', other: 'reviews')}',
      name: 'reviewsCount',
      desc: 'Number of reviews count display',
      args: [count],
    );
  }

  /// `Premium Profile Editor`
  String get premiumProfileEditorTitle {
    return Intl.message(
      'Premium Profile Editor',
      name: 'premiumProfileEditorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Customize your premium profile`
  String get premiumProfileEditorHeader {
    return Intl.message(
      'Customize your premium profile',
      name: 'premiumProfileEditorHeader',
      desc: '',
      args: [],
    );
  }

  /// `Here you can update your name, description, work references, and avatar SVG.`
  String get premiumProfileEditorDescription {
    return Intl.message(
      'Here you can update your name, description, work references, and avatar SVG.',
      name: 'premiumProfileEditorDescription',
      desc: '',
      args: [],
    );
  }

  /// `Saving...`
  String get premiumProfileEditorSaving {
    return Intl.message(
      'Saving...',
      name: 'premiumProfileEditorSaving',
      desc: '',
      args: [],
    );
  }

  /// `Display name (optional)`
  String get premiumProfileEditorDisplayNameOptional {
    return Intl.message(
      'Display name (optional)',
      name: 'premiumProfileEditorDisplayNameOptional',
      desc: '',
      args: [],
    );
  }

  /// `Description (optional)`
  String get premiumProfileEditorDescriptionOptional {
    return Intl.message(
      'Description (optional)',
      name: 'premiumProfileEditorDescriptionOptional',
      desc: '',
      args: [],
    );
  }

  /// `Avatar (.svg)`
  String get premiumProfileEditorAvatarSvg {
    return Intl.message(
      'Avatar (.svg)',
      name: 'premiumProfileEditorAvatarSvg',
      desc: '',
      args: [],
    );
  }

  /// `No avatar SVG selected.`
  String get premiumProfileEditorNoAvatarSvgSelected {
    return Intl.message(
      'No avatar SVG selected.',
      name: 'premiumProfileEditorNoAvatarSvgSelected',
      desc: '',
      args: [],
    );
  }

  /// `Selected: {fileName}`
  String premiumProfileEditorSelectedFile(String fileName) {
    return Intl.message(
      'Selected: $fileName',
      name: 'premiumProfileEditorSelectedFile',
      desc: '',
      args: [fileName],
    );
  }

  /// `Upload SVG`
  String get premiumProfileEditorUploadSvg {
    return Intl.message(
      'Upload SVG',
      name: 'premiumProfileEditorUploadSvg',
      desc: '',
      args: [],
    );
  }

  /// `Remove SVG`
  String get premiumProfileEditorRemoveSvg {
    return Intl.message(
      'Remove SVG',
      name: 'premiumProfileEditorRemoveSvg',
      desc: '',
      args: [],
    );
  }

  /// `Work reference images`
  String get premiumProfileEditorWorkReferenceImages {
    return Intl.message(
      'Work reference images',
      name: 'premiumProfileEditorWorkReferenceImages',
      desc: '',
      args: [],
    );
  }

  /// `Add and manage your reference images.`
  String get premiumProfileEditorWorkReferenceDescription {
    return Intl.message(
      'Add and manage your reference images.',
      name: 'premiumProfileEditorWorkReferenceDescription',
      desc: '',
      args: [],
    );
  }

  /// `No work reference images yet.`
  String get premiumProfileEditorNoWorkReferenceImages {
    return Intl.message(
      'No work reference images yet.',
      name: 'premiumProfileEditorNoWorkReferenceImages',
      desc: '',
      args: [],
    );
  }

  /// `Replace`
  String get premiumProfileEditorReplace {
    return Intl.message(
      'Replace',
      name: 'premiumProfileEditorReplace',
      desc: '',
      args: [],
    );
  }

  /// `Add image`
  String get premiumProfileEditorAddImage {
    return Intl.message(
      'Add image',
      name: 'premiumProfileEditorAddImage',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get accountDeletionTitle {
    return Intl.message(
      'Delete account',
      name: 'accountDeletionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Request account deletion`
  String get accountDeletionHeader {
    return Intl.message(
      'Request account deletion',
      name: 'accountDeletionHeader',
      desc: '',
      args: [],
    );
  }

  /// `Use this page to request permanent account deletion. Once completed, your profile and related account data will be removed according to our retention policy.`
  String get accountDeletionInfo {
    return Intl.message(
      'Use this page to request permanent account deletion. Once completed, your profile and related account data will be removed according to our retention policy.',
      name: 'accountDeletionInfo',
      desc: '',
      args: [],
    );
  }

  /// `Account deletion request confirmed. This action is permanent and cannot be undone.`
  String get accountDeletionTokenInfo {
    return Intl.message(
      'Account deletion request confirmed. This action is permanent and cannot be undone.',
      name: 'accountDeletionTokenInfo',
      desc: '',
      args: [],
    );
  }

  /// `Steps:\n1. Enter your account email\n2. Submit to receive a verification code\n3. Enter the code to confirm deletion`
  String get accountDeletionSteps {
    return Intl.message(
      'Steps:\n1. Enter your account email\n2. Submit to receive a verification code\n3. Enter the code to confirm deletion',
      name: 'accountDeletionSteps',
      desc: '',
      args: [],
    );
  }

  /// `Account email`
  String get accountDeletionEmailLabel {
    return Intl.message(
      'Account email',
      name: 'accountDeletionEmailLabel',
      desc: '',
      args: [],
    );
  }

  /// `Verification code`
  String get accountDeletionCodeLabel {
    return Intl.message(
      'Verification code',
      name: 'accountDeletionCodeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter code from email`
  String get accountDeletionCodeHint {
    return Intl.message(
      'Enter code from email',
      name: 'accountDeletionCodeHint',
      desc: '',
      args: [],
    );
  }

  /// `Send verification code`
  String get accountDeletionSendCodeButton {
    return Intl.message(
      'Send verification code',
      name: 'accountDeletionSendCodeButton',
      desc: '',
      args: [],
    );
  }

  /// `Confirm account deletion`
  String get accountDeletionConfirmButton {
    return Intl.message(
      'Confirm account deletion',
      name: 'accountDeletionConfirmButton',
      desc: '',
      args: [],
    );
  }

  /// `Verification code sent. Please check your email.`
  String get accountDeletionCodeSent {
    return Intl.message(
      'Verification code sent. Please check your email.',
      name: 'accountDeletionCodeSent',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid verification code.`
  String get accountDeletionCodeInvalid {
    return Intl.message(
      'Please enter a valid verification code.',
      name: 'accountDeletionCodeInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Deletion request submitted successfully. Our team will process your request and your account will be deleted after verification.`
  String get accountDeletionSuccessMessage {
    return Intl.message(
      'Deletion request submitted successfully. Our team will process your request and your account will be deleted after verification.',
      name: 'accountDeletionSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `If confirmed, we will permanently delete:`
  String get accountDeletionDataDeletedTitle {
    return Intl.message(
      'If confirmed, we will permanently delete:',
      name: 'accountDeletionDataDeletedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your user profile with the following data has been deleted:`
  String get accountDeletionDataDeletedTitleAfterConfirmed {
    return Intl.message(
      'Your user profile with the following data has been deleted:',
      name: 'accountDeletionDataDeletedTitleAfterConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `- Account registration data and profile\n- Device keys and migration/recovery sessions\n- Postings and associated uploaded images\n- Attributes, relationships, reports, and favorites/match history\n- Messages, read receipts, encrypted file metadata, and chat response stats\n- Reviews, reputation, transactions, moderation/appeals, and review audit data\n- Notification contacts and notification preferences\n- Presence/activity cache entries and related analytics/location tracking rows`
  String get accountDeletionDataDeletedItems {
    return Intl.message(
      '- Account registration data and profile\n- Device keys and migration/recovery sessions\n- Postings and associated uploaded images\n- Attributes, relationships, reports, and favorites/match history\n- Messages, read receipts, encrypted file metadata, and chat response stats\n- Reviews, reputation, transactions, moderation/appeals, and review audit data\n- Notification contacts and notification preferences\n- Presence/activity cache entries and related analytics/location tracking rows',
      name: 'accountDeletionDataDeletedItems',
      desc: '',
      args: [],
    );
  }

  /// `Last online:`
  String get lastOnlinePrefix {
    return Intl.message(
      'Last online:',
      name: 'lastOnlinePrefix',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get lastOnlineUnknown {
    return Intl.message(
      'Unknown',
      name: 'lastOnlineUnknown',
      desc: '',
      args: [],
    );
  }

  /// `just now`
  String get lastOnlineJustNow {
    return Intl.message(
      'just now',
      name: 'lastOnlineJustNow',
      desc: '',
      args: [],
    );
  }

  /// `{count} min ago`
  String lastOnlineMinutesAgo(int count) {
    return Intl.message(
      '$count min ago',
      name: 'lastOnlineMinutesAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count} h ago`
  String lastOnlineHoursAgo(int count) {
    return Intl.message(
      '$count h ago',
      name: 'lastOnlineHoursAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count} d ago`
  String lastOnlineDaysAgo(int count) {
    return Intl.message(
      '$count d ago',
      name: 'lastOnlineDaysAgo',
      desc: '',
      args: [count],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'lv'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
