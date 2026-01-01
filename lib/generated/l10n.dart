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

  /// `Barter App`
  String get appTitle {
    return Intl.message('Barter App', name: 'appTitle', desc: '', args: []);
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

  /// `What do you seek/require?`
  String get selectYourInterests {
    return Intl.message(
      'What do you seek/require?',
      name: 'selectYourInterests',
      desc: '',
      args: [],
    );
  }

  /// `What do you have/offer?`
  String get selectYourOffers {
    return Intl.message(
      'What do you have/offer?',
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

  /// `Sports, partying, dancing, running, physical, mechanical`
  String get categoryActiveDescription {
    return Intl.message(
      'Sports, partying, dancing, running, physical, mechanical',
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

  /// `Strictly business, paid work, networking, money matters`
  String get categoryBusinessDescription {
    return Intl.message(
      'Strictly business, paid work, networking, money matters',
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

  /// `Continue with Google`
  String get continueWithGoogle {
    return Intl.message(
      'Continue with Google',
      name: 'continueWithGoogle',
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

  /// `Nature, outdoors, gardening, animals, environment, hiking, plants, sustainability`
  String get category_green {
    return Intl.message(
      'Nature, outdoors, gardening, animals, environment, hiking, plants, sustainability',
      name: 'category_green',
      desc: '',
      args: [],
    );
  }

  /// `Sports, physical exercise, partying, dancing, physical work, mechanisms, tools, hands-on activities`
  String get category_red {
    return Intl.message(
      'Sports, physical exercise, partying, dancing, physical work, mechanisms, tools, hands-on activities',
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

  /// `Volunteering, open-ended support, free exchange, consulting, non-specific assistance, community`
  String get category_orange {
    return Intl.message(
      'Volunteering, open-ended support, free exchange, consulting, non-specific assistance, community',
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

  /// `Amateur radio`
  String get attr_amateur_radio {
    return Intl.message(
      'Amateur radio',
      name: 'attr_amateur_radio',
      desc: '',
      args: [],
    );
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

  /// `Blogging`
  String get attr_blogging {
    return Intl.message('Blogging', name: 'attr_blogging', desc: '', args: []);
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

  /// `Candle making`
  String get attr_candle_making {
    return Intl.message(
      'Candle making',
      name: 'attr_candle_making',
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

  /// `Coffee`
  String get attr_coffee {
    return Intl.message('Coffee', name: 'attr_coffee', desc: '', args: []);
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

  /// `Creative writing`
  String get attr_creative_writing {
    return Intl.message(
      'Creative writing',
      name: 'attr_creative_writing',
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

  /// `Dance`
  String get attr_dance {
    return Intl.message('Dance', name: 'attr_dance', desc: '', args: []);
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
  String get attr_djing {
    return Intl.message('DJing', name: 'attr_djing', desc: '', args: []);
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

  /// `Fashion`
  String get attr_fashion {
    return Intl.message('Fashion', name: 'attr_fashion', desc: '', args: []);
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

  /// `Furniture building`
  String get attr_furniture_building {
    return Intl.message(
      'Furniture building',
      name: 'attr_furniture_building',
      desc: '',
      args: [],
    );
  }

  /// `Gaming`
  String get attr_gaming {
    return Intl.message('Gaming', name: 'attr_gaming', desc: '', args: []);
  }

  /// `Genealogy`
  String get attr_genealogy {
    return Intl.message(
      'Genealogy',
      name: 'attr_genealogy',
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

  /// `Hacking`
  String get attr_hacking {
    return Intl.message('Hacking', name: 'attr_hacking', desc: '', args: []);
  }

  /// `Herp keeping`
  String get attr_herp_keeping {
    return Intl.message(
      'Herp keeping',
      name: 'attr_herp_keeping',
      desc: '',
      args: [],
    );
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

  /// `Hydroponics`
  String get attr_hydroponics {
    return Intl.message(
      'Hydroponics',
      name: 'attr_hydroponics',
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

  /// `Podcasts`
  String get attr_podcasts {
    return Intl.message('Podcasts', name: 'attr_podcasts', desc: '', args: []);
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

  /// `Nail art`
  String get attr_nail_art {
    return Intl.message('Nail art', name: 'attr_nail_art', desc: '', args: []);
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

  /// `Powerlifting`
  String get attr_powerlifting {
    return Intl.message(
      'Powerlifting',
      name: 'attr_powerlifting',
      desc: '',
      args: [],
    );
  }

  /// `Puzzles`
  String get attr_puzzles {
    return Intl.message('Puzzles', name: 'attr_puzzles', desc: '', args: []);
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

  /// `Singing`
  String get attr_singing {
    return Intl.message('Singing', name: 'attr_singing', desc: '', args: []);
  }

  /// `Skateboarding`
  String get attr_skateboarding {
    return Intl.message(
      'Skateboarding',
      name: 'attr_skateboarding',
      desc: '',
      args: [],
    );
  }

  /// `Sketching`
  String get attr_sketching {
    return Intl.message(
      'Sketching',
      name: 'attr_sketching',
      desc: '',
      args: [],
    );
  }

  /// `Soapmaking`
  String get attr_soapmaking {
    return Intl.message(
      'Soapmaking',
      name: 'attr_soapmaking',
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

  /// `Storytelling`
  String get attr_storytelling {
    return Intl.message(
      'Storytelling',
      name: 'attr_storytelling',
      desc: '',
      args: [],
    );
  }

  /// `Sudoku`
  String get attr_sudoku {
    return Intl.message('Sudoku', name: 'attr_sudoku', desc: '', args: []);
  }

  /// `Table tennis`
  String get attr_table_tennis {
    return Intl.message(
      'Table tennis',
      name: 'attr_table_tennis',
      desc: '',
      args: [],
    );
  }

  /// `Thrifting`
  String get attr_thrifting {
    return Intl.message(
      'Thrifting',
      name: 'attr_thrifting',
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

  /// `Reading`
  String get attr_reading {
    return Intl.message('Reading', name: 'attr_reading', desc: '', args: []);
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

  /// `Music`
  String get attr_music {
    return Intl.message('Music', name: 'attr_music', desc: '', args: []);
  }

  /// `Dancing`
  String get attr_dancing {
    return Intl.message('Dancing', name: 'attr_dancing', desc: '', args: []);
  }

  /// `Aerobics`
  String get attr_aerobics {
    return Intl.message('Aerobics', name: 'attr_aerobics', desc: '', args: []);
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

  /// `Sports`
  String get attr_sports {
    return Intl.message('Sports', name: 'attr_sports', desc: '', args: []);
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

  /// `Bird watching`
  String get attr_bird_watching {
    return Intl.message(
      'Bird watching',
      name: 'attr_bird_watching',
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

  /// `Climbing`
  String get attr_climbing {
    return Intl.message('Climbing', name: 'attr_climbing', desc: '', args: []);
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

  /// `Fermentation`
  String get attr_fermentation {
    return Intl.message(
      'Fermentation',
      name: 'attr_fermentation',
      desc: '',
      args: [],
    );
  }

  /// `Film making`
  String get attr_film_making {
    return Intl.message(
      'Film making',
      name: 'attr_film_making',
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

  /// `Geocaching`
  String get attr_geocaching {
    return Intl.message(
      'Geocaching',
      name: 'attr_geocaching',
      desc: '',
      args: [],
    );
  }

  /// `Kayaking`
  String get attr_kayaking {
    return Intl.message('Kayaking', name: 'attr_kayaking', desc: '', args: []);
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

  /// `Mushroom hunting`
  String get attr_mushroom_hunting {
    return Intl.message(
      'Mushroom hunting',
      name: 'attr_mushroom_hunting',
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

  /// `Running`
  String get attr_running {
    return Intl.message('Running', name: 'attr_running', desc: '', args: []);
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

  /// `Cold plunging`
  String get attr_cold_plunging {
    return Intl.message(
      'Cold plunging',
      name: 'attr_cold_plunging',
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

  /// `Deep cleaning`
  String get attr_deep_cleaning {
    return Intl.message(
      'Deep cleaning',
      name: 'attr_deep_cleaning',
      desc: '',
      args: [],
    );
  }

  /// `Digital nomadism`
  String get attr_digital_nomadism {
    return Intl.message(
      'Digital nomadism',
      name: 'attr_digital_nomadism',
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

  /// `Memes`
  String get attr_memes {
    return Intl.message('Memes', name: 'attr_memes', desc: '', args: []);
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

  /// `Minimalism`
  String get attr_minimalism {
    return Intl.message(
      'Minimalism',
      name: 'attr_minimalism',
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

  /// `Podcasting`
  String get attr_podcasting {
    return Intl.message(
      'Podcasting',
      name: 'attr_podcasting',
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

  /// `Tiny homes`
  String get attr_tiny_homes {
    return Intl.message(
      'Tiny homes',
      name: 'attr_tiny_homes',
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

  /// `PC building`
  String get attr_pc_building {
    return Intl.message(
      'PC building',
      name: 'attr_pc_building',
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

  /// `Backgammon`
  String get attr_backgammon {
    return Intl.message(
      'Backgammon',
      name: 'attr_backgammon',
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

  /// `Computer hardware`
  String get attr_computer_hardware {
    return Intl.message(
      'Computer hardware',
      name: 'attr_computer_hardware',
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

  /// `Creative brainstorming`
  String get attr_creative_brainstorming {
    return Intl.message(
      'Creative brainstorming',
      name: 'attr_creative_brainstorming',
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

  /// `Fresh eggs`
  String get attr_fresh_eggs {
    return Intl.message(
      'Fresh eggs',
      name: 'attr_fresh_eggs',
      desc: '',
      args: [],
    );
  }

  /// `Furniture repair`
  String get attr_furniture_repair {
    return Intl.message(
      'Furniture repair',
      name: 'attr_furniture_repair',
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

  /// `Graphic novels`
  String get attr_graphic_novels {
    return Intl.message(
      'Graphic novels',
      name: 'attr_graphic_novels',
      desc: '',
      args: [],
    );
  }

  /// `Guitar`
  String get attr_guitar {
    return Intl.message('Guitar', name: 'attr_guitar', desc: '', args: []);
  }

  /// `Handmade`
  String get attr_handmade {
    return Intl.message('Handmade', name: 'attr_handmade', desc: '', args: []);
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

  /// `Horseback riding`
  String get attr_horseback_riding {
    return Intl.message(
      'Horseback riding',
      name: 'attr_horseback_riding',
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

  /// `Lawn mowing`
  String get attr_lawn_mowing {
    return Intl.message(
      'Lawn mowing',
      name: 'attr_lawn_mowing',
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

  /// `Pair programming`
  String get attr_pair_programming {
    return Intl.message(
      'Pair programming',
      name: 'attr_pair_programming',
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

  /// `Plant cuttings`
  String get attr_plant_cuttings {
    return Intl.message(
      'Plant cuttings',
      name: 'attr_plant_cuttings',
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

  /// `Resume writing`
  String get attr_resume_writing {
    return Intl.message(
      'Resume writing',
      name: 'attr_resume_writing',
      desc: '',
      args: [],
    );
  }

  /// `RPG games`
  String get attr_rpg_games {
    return Intl.message(
      'RPG games',
      name: 'attr_rpg_games',
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

  /// `Used books`
  String get attr_used_books {
    return Intl.message(
      'Used books',
      name: 'attr_used_books',
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

  /// `Used furniture`
  String get attr_used_furniture {
    return Intl.message(
      'Used furniture',
      name: 'attr_used_furniture',
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

  /// `Video game consoles`
  String get attr_video_game_consoles {
    return Intl.message(
      'Video game consoles',
      name: 'attr_video_game_consoles',
      desc: '',
      args: [],
    );
  }

  /// `Vintage clothing`
  String get attr_vintage_clothing {
    return Intl.message(
      'Vintage clothing',
      name: 'attr_vintage_clothing',
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

  /// `Window cleaning`
  String get attr_window_cleaning {
    return Intl.message(
      'Window cleaning',
      name: 'attr_window_cleaning',
      desc: '',
      args: [],
    );
  }

  /// `Yard work`
  String get attr_yard_work {
    return Intl.message(
      'Yard work',
      name: 'attr_yard_work',
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

  /// `Fresh vegetables`
  String get attr_fresh_vegetables {
    return Intl.message(
      'Fresh vegetables',
      name: 'attr_fresh_vegetables',
      desc: '',
      args: [],
    );
  }

  /// `Fresh fruits`
  String get attr_fresh_fruits {
    return Intl.message(
      'Fresh fruits',
      name: 'attr_fresh_fruits',
      desc: '',
      args: [],
    );
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

  /// `Trees`
  String get attr_trees {
    return Intl.message('Trees', name: 'attr_trees', desc: '', args: []);
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

  /// `Technician`
  String get attr_technician {
    return Intl.message(
      'Technician',
      name: 'attr_technician',
      desc: '',
      args: [],
    );
  }

  /// `Tractor`
  String get attr_tractor {
    return Intl.message('Tractor', name: 'attr_tractor', desc: '', args: []);
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

  /// `Truck driving`
  String get attr_truck_driving {
    return Intl.message(
      'Truck driving',
      name: 'attr_truck_driving',
      desc: '',
      args: [],
    );
  }

  /// `Assembly`
  String get attr_assembly {
    return Intl.message('Assembly', name: 'attr_assembly', desc: '', args: []);
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

  /// `Goats`
  String get attr_goats {
    return Intl.message('Goats', name: 'attr_goats', desc: '', args: []);
  }

  /// `Cows`
  String get attr_cows {
    return Intl.message('Cows', name: 'attr_cows', desc: '', args: []);
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

  /// `Fruit harvesting`
  String get attr_fruit_harvesting {
    return Intl.message(
      'Fruit harvesting',
      name: 'attr_fruit_harvesting',
      desc: '',
      args: [],
    );
  }

  /// `Vegetable harvesting`
  String get attr_vegetable_harvesting {
    return Intl.message(
      'Vegetable harvesting',
      name: 'attr_vegetable_harvesting',
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

  /// `Shepherding`
  String get attr_shepherding {
    return Intl.message(
      'Shepherding',
      name: 'attr_shepherding',
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

  /// `Socializing`
  String get attr_socializing {
    return Intl.message(
      'Socializing',
      name: 'attr_socializing',
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

  /// `Choose from Gallery`
  String get chooseFromGallery {
    return Intl.message(
      'Choose from Gallery',
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

  /// `User`
  String get userPrefix {
    return Intl.message('User', name: 'userPrefix', desc: '', args: []);
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

  /// `Active Postings`
  String get activePostings {
    return Intl.message(
      'Active Postings',
      name: 'activePostings',
      desc: '',
      args: [],
    );
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

  /// `Find people with matching or complementary interests, search by keywords`
  String get welcomeStep2Description {
    return Intl.message(
      'Find people with matching or complementary interests, search by keywords',
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

  /// `Trade skills, services, items, or simply connect with your community`
  String get welcomeStep4Description {
    return Intl.message(
      'Trade skills, services, items, or simply connect with your community',
      name: 'welcomeStep4Description',
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
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
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
