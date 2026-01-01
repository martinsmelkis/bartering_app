import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Barter App'**
  String get appTitle;

  /// No description provided for @tapToChat.
  ///
  /// In en, this message translates to:
  /// **'Tap to chat'**
  String get tapToChat;

  /// No description provided for @locations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get locations;

  /// No description provided for @tapToExpandMainCluster.
  ///
  /// In en, this message translates to:
  /// **'Tap to expand main cluster'**
  String get tapToExpandMainCluster;

  /// No description provided for @closeLocations.
  ///
  /// In en, this message translates to:
  /// **'Close Locations'**
  String get closeLocations;

  /// No description provided for @tapToExpandSubCluster.
  ///
  /// In en, this message translates to:
  /// **'Tap to expand sub-cluster'**
  String get tapToExpandSubCluster;

  /// No description provided for @pointsOfInterest.
  ///
  /// In en, this message translates to:
  /// **'Points of Interest'**
  String get pointsOfInterest;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @typeAMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeAMessage;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {errorMessage}'**
  String errorWithMessage(Object errorMessage);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @errorDuringInitialization.
  ///
  /// In en, this message translates to:
  /// **'Error during initialization.'**
  String get errorDuringInitialization;

  /// No description provided for @selectYourInterests.
  ///
  /// In en, this message translates to:
  /// **'What do you seek/require?'**
  String get selectYourInterests;

  /// No description provided for @selectYourOffers.
  ///
  /// In en, this message translates to:
  /// **'What do you have/offer?'**
  String get selectYourOffers;

  /// No description provided for @userInterestedIn.
  ///
  /// In en, this message translates to:
  /// **'Interested in:'**
  String get userInterestedIn;

  /// No description provided for @userOffers.
  ///
  /// In en, this message translates to:
  /// **'Offering:'**
  String get userOffers;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get username;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// No description provided for @onboardingScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get onboardingScreenTitle;

  /// No description provided for @onboardingScreenQuestion.
  ///
  /// In en, this message translates to:
  /// **'How much are you interested in this?'**
  String get onboardingScreenQuestion;

  /// No description provided for @finishOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finishOnboarding;

  /// No description provided for @questionsAnswered.
  ///
  /// In en, this message translates to:
  /// **'{count} questions answered'**
  String questionsAnswered(Object count);

  /// No description provided for @locationSaved.
  ///
  /// In en, this message translates to:
  /// **'Location saved!'**
  String get locationSaved;

  /// No description provided for @pleaseSelectLocationFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a location first.'**
  String get pleaseSelectLocationFirst;

  /// No description provided for @locationNotFound.
  ///
  /// In en, this message translates to:
  /// **'Location not found.'**
  String get locationNotFound;

  /// No description provided for @errorFindingLocation.
  ///
  /// In en, this message translates to:
  /// **'Error finding location: {error}'**
  String errorFindingLocation(Object error);

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @pickYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Pick your location'**
  String get pickYourLocation;

  /// No description provided for @searchForALocation.
  ///
  /// In en, this message translates to:
  /// **'Search for a location'**
  String get searchForALocation;

  /// No description provided for @searchForAKeyword.
  ///
  /// In en, this message translates to:
  /// **'Search for a keyword'**
  String get searchForAKeyword;

  /// No description provided for @saveLocation.
  ///
  /// In en, this message translates to:
  /// **'Save Location'**
  String get saveLocation;

  /// No description provided for @chatError_Offline.
  ///
  /// In en, this message translates to:
  /// **'User Offline'**
  String get chatError_Offline;

  /// No description provided for @mockPoiNotFound.
  ///
  /// In en, this message translates to:
  /// **'Mock POI with id {id} not found in service'**
  String mockPoiNotFound(Object id);

  /// No description provided for @mockPoiNotFoundForUpdate.
  ///
  /// In en, this message translates to:
  /// **'Mock POI with id {id} not found for update'**
  String mockPoiNotFoundForUpdate(Object id);

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submitting;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @anUnknownErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get anUnknownErrorOccurred;

  /// No description provided for @submittingOffers.
  ///
  /// In en, this message translates to:
  /// **'Submitting offers...'**
  String get submittingOffers;

  /// No description provided for @drawer_menu_similar_users.
  ///
  /// In en, this message translates to:
  /// **'Find similar users'**
  String get drawer_menu_similar_users;

  /// No description provided for @drawer_menu_complementary_users.
  ///
  /// In en, this message translates to:
  /// **'Find complementary users'**
  String get drawer_menu_complementary_users;

  /// No description provided for @drawer_menu_favorite_users.
  ///
  /// In en, this message translates to:
  /// **'Find favorite users'**
  String get drawer_menu_favorite_users;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get settingsSaved;

  /// No description provided for @settingsSearchSection.
  ///
  /// In en, this message translates to:
  /// **'Search Settings'**
  String get settingsSearchSection;

  /// No description provided for @settingsSearchCenterPointTitle.
  ///
  /// In en, this message translates to:
  /// **'Center Point of Search'**
  String get settingsSearchCenterPointTitle;

  /// No description provided for @settingsSearchCenterPointDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the center point for nearby user searches'**
  String get settingsSearchCenterPointDescription;

  /// No description provided for @settingsSearchCenterUserLocation.
  ///
  /// In en, this message translates to:
  /// **'User Location'**
  String get settingsSearchCenterUserLocation;

  /// No description provided for @settingsSearchCenterUserLocationDescription.
  ///
  /// In en, this message translates to:
  /// **'Search from your saved location'**
  String get settingsSearchCenterUserLocationDescription;

  /// No description provided for @settingsSearchCenterMapCenter.
  ///
  /// In en, this message translates to:
  /// **'Map Center'**
  String get settingsSearchCenterMapCenter;

  /// No description provided for @settingsSearchCenterMapCenterDescription.
  ///
  /// In en, this message translates to:
  /// **'Search from the current map center'**
  String get settingsSearchCenterMapCenterDescription;

  /// No description provided for @settingsNearbyUsersRadiusTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby Users Search Radius'**
  String get settingsNearbyUsersRadiusTitle;

  /// No description provided for @settingsNearbyUsersRadiusDescription.
  ///
  /// In en, this message translates to:
  /// **'How far to search for nearby users'**
  String get settingsNearbyUsersRadiusDescription;

  /// No description provided for @settingsKeywordSearchRadiusTitle.
  ///
  /// In en, this message translates to:
  /// **'Keyword Search Radius'**
  String get settingsKeywordSearchRadiusTitle;

  /// No description provided for @settingsKeywordSearchRadiusDescription.
  ///
  /// In en, this message translates to:
  /// **'Search radius when using keyword search'**
  String get settingsKeywordSearchRadiusDescription;

  /// No description provided for @settingsKeywordSearchWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Keyword Search Weight'**
  String get settingsKeywordSearchWeightTitle;

  /// No description provided for @settingsKeywordSearchWeightDescription.
  ///
  /// In en, this message translates to:
  /// **'Weight parameter for keyword search relevance (10-100)'**
  String get settingsKeywordSearchWeightDescription;

  /// No description provided for @setPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Up PIN'**
  String get setPinTitle;

  /// No description provided for @setPinDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a 4-6 digit PIN to secure your app'**
  String get setPinDescription;

  /// No description provided for @setPinButton.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get setPinButton;

  /// No description provided for @skipPinButton.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipPinButton;

  /// No description provided for @pinLabel.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pinLabel;

  /// No description provided for @pinHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-6 digits'**
  String get pinHint;

  /// No description provided for @confirmPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPinLabel;

  /// No description provided for @pinErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a PIN'**
  String get pinErrorEmpty;

  /// No description provided for @pinErrorTooShort.
  ///
  /// In en, this message translates to:
  /// **'PIN must be at least 4 digits'**
  String get pinErrorTooShort;

  /// No description provided for @pinErrorMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinErrorMismatch;

  /// No description provided for @pinSetSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PIN set successfully'**
  String get pinSetSuccessfully;

  /// No description provided for @enterPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPinTitle;

  /// No description provided for @enterPinDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN to unlock the app'**
  String get enterPinDescription;

  /// No description provided for @unlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlockButton;

  /// No description provided for @pinErrorIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN (Attempt {attempts})'**
  String pinErrorIncorrect(int attempts);

  /// No description provided for @settingsSecuritySection.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecuritySection;

  /// No description provided for @settingsPinTitle.
  ///
  /// In en, this message translates to:
  /// **'PIN Protection'**
  String get settingsPinTitle;

  /// No description provided for @settingsPinEnabledDescription.
  ///
  /// In en, this message translates to:
  /// **'App is protected with PIN'**
  String get settingsPinEnabledDescription;

  /// No description provided for @settingsPinDisabledDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable PIN for extra security'**
  String get settingsPinDisabledDescription;

  /// No description provided for @settingsChangePinButton.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get settingsChangePinButton;

  /// No description provided for @settingsChangePinDescription.
  ///
  /// In en, this message translates to:
  /// **'Update your security PIN'**
  String get settingsChangePinDescription;

  /// No description provided for @setupSecurityQuestion.
  ///
  /// In en, this message translates to:
  /// **'Setup Security Question'**
  String get setupSecurityQuestion;

  /// No description provided for @securityQuestionDescription.
  ///
  /// In en, this message translates to:
  /// **'Set up a security question to help recover your PIN if you forget it'**
  String get securityQuestionDescription;

  /// No description provided for @selectSecurityQuestion.
  ///
  /// In en, this message translates to:
  /// **'Select a question'**
  String get selectSecurityQuestion;

  /// No description provided for @yourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your Answer'**
  String get yourAnswer;

  /// No description provided for @answerHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your answer'**
  String get answerHint;

  /// No description provided for @pleaseSelectQuestion.
  ///
  /// In en, this message translates to:
  /// **'Please select a security question'**
  String get pleaseSelectQuestion;

  /// No description provided for @pleaseEnterAnswer.
  ///
  /// In en, this message translates to:
  /// **'Please enter your answer'**
  String get pleaseEnterAnswer;

  /// No description provided for @answerTooShort.
  ///
  /// In en, this message translates to:
  /// **'Answer must be at least 2 characters'**
  String get answerTooShort;

  /// No description provided for @securityAnswerNote.
  ///
  /// In en, this message translates to:
  /// **'Note: Answers are case-insensitive'**
  String get securityAnswerNote;

  /// No description provided for @saveSecurityQuestion.
  ///
  /// In en, this message translates to:
  /// **'Save Security Question'**
  String get saveSecurityQuestion;

  /// No description provided for @securityQuestionSaved.
  ///
  /// In en, this message translates to:
  /// **'Security question saved successfully'**
  String get securityQuestionSaved;

  /// No description provided for @securityQuestion1.
  ///
  /// In en, this message translates to:
  /// **'What was the name of your first pet?'**
  String get securityQuestion1;

  /// No description provided for @securityQuestion2.
  ///
  /// In en, this message translates to:
  /// **'What city were you born in?'**
  String get securityQuestion2;

  /// No description provided for @securityQuestion3.
  ///
  /// In en, this message translates to:
  /// **'What is your mother\'s maiden name?'**
  String get securityQuestion3;

  /// No description provided for @securityQuestion4.
  ///
  /// In en, this message translates to:
  /// **'What was the name of your elementary school?'**
  String get securityQuestion4;

  /// No description provided for @securityQuestion5.
  ///
  /// In en, this message translates to:
  /// **'What is your favorite book?'**
  String get securityQuestion5;

  /// No description provided for @answerSecurityQuestion.
  ///
  /// In en, this message translates to:
  /// **'Answer Security Question'**
  String get answerSecurityQuestion;

  /// No description provided for @enterYourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Enter your answer'**
  String get enterYourAnswer;

  /// No description provided for @verifyAndResetPin.
  ///
  /// In en, this message translates to:
  /// **'Verify and Reset PIN'**
  String get verifyAndResetPin;

  /// No description provided for @securityAnswerIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect answer (Attempt {attempts})'**
  String securityAnswerIncorrect(int attempts);

  /// No description provided for @pinResetSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PIN reset successfully'**
  String get pinResetSuccessfully;

  /// No description provided for @noSecurityQuestionSet.
  ///
  /// In en, this message translates to:
  /// **'No security question set up'**
  String get noSecurityQuestionSet;

  /// No description provided for @contactSupportForPinReset.
  ///
  /// In en, this message translates to:
  /// **'Please contact support for PIN reset assistance'**
  String get contactSupportForPinReset;

  /// No description provided for @manageSecurityQuestion.
  ///
  /// In en, this message translates to:
  /// **'Manage Security Question'**
  String get manageSecurityQuestion;

  /// No description provided for @securityQuestionSet.
  ///
  /// In en, this message translates to:
  /// **'Security question is set up'**
  String get securityQuestionSet;

  /// No description provided for @noSecurityQuestion.
  ///
  /// In en, this message translates to:
  /// **'No security question configured'**
  String get noSecurityQuestion;

  /// No description provided for @setupSecurityQuestionButton.
  ///
  /// In en, this message translates to:
  /// **'Setup Security Question'**
  String get setupSecurityQuestionButton;

  /// No description provided for @changeSecurityQuestion.
  ///
  /// In en, this message translates to:
  /// **'Change Security Question'**
  String get changeSecurityQuestion;

  /// No description provided for @managePostings.
  ///
  /// In en, this message translates to:
  /// **'Manage Postings'**
  String get managePostings;

  /// No description provided for @noActivePostings.
  ///
  /// In en, this message translates to:
  /// **'No active postings'**
  String get noActivePostings;

  /// No description provided for @deletePosting.
  ///
  /// In en, this message translates to:
  /// **'Delete Posting'**
  String get deletePosting;

  /// No description provided for @deletePostingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this posting?'**
  String get deletePostingConfirmation;

  /// No description provided for @postingDeleted.
  ///
  /// In en, this message translates to:
  /// **'Posting deleted successfully'**
  String get postingDeleted;

  /// No description provided for @createPosting.
  ///
  /// In en, this message translates to:
  /// **'Create Posting'**
  String get createPosting;

  /// No description provided for @offer.
  ///
  /// In en, this message translates to:
  /// **'Offer'**
  String get offer;

  /// No description provided for @need.
  ///
  /// In en, this message translates to:
  /// **'Need'**
  String get need;

  /// No description provided for @expires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expires;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @editPosting.
  ///
  /// In en, this message translates to:
  /// **'Edit Posting'**
  String get editPosting;

  /// No description provided for @postingUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Posting updated successfully'**
  String get postingUpdatedSuccess;

  /// No description provided for @updatePosting.
  ///
  /// In en, this message translates to:
  /// **'Update Posting'**
  String get updatePosting;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @categoryNatureTitle.
  ///
  /// In en, this message translates to:
  /// **'Nature & Outdoors'**
  String get categoryNatureTitle;

  /// No description provided for @categoryNatureDescription.
  ///
  /// In en, this message translates to:
  /// **'Gardening, outdoors, forests, camping, environmentalism, cleanup, animals'**
  String get categoryNatureDescription;

  /// No description provided for @categoryActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Active & Social'**
  String get categoryActiveTitle;

  /// No description provided for @categoryActiveDescription.
  ///
  /// In en, this message translates to:
  /// **'Sports, partying, dancing, running, physical, mechanical'**
  String get categoryActiveDescription;

  /// No description provided for @categoryBusinessTitle.
  ///
  /// In en, this message translates to:
  /// **'Business & Finance'**
  String get categoryBusinessTitle;

  /// No description provided for @categoryBusinessDescription.
  ///
  /// In en, this message translates to:
  /// **'Strictly business, paid work, networking, money matters'**
  String get categoryBusinessDescription;

  /// No description provided for @categoryArtsTitle.
  ///
  /// In en, this message translates to:
  /// **'Arts & Philosophy'**
  String get categoryArtsTitle;

  /// No description provided for @categoryArtsDescription.
  ///
  /// In en, this message translates to:
  /// **'Art, spirituality, philosophy'**
  String get categoryArtsDescription;

  /// No description provided for @categoryCommTitle.
  ///
  /// In en, this message translates to:
  /// **'Communication & Chat'**
  String get categoryCommTitle;

  /// No description provided for @categoryCommDescription.
  ///
  /// In en, this message translates to:
  /// **'Misc/Communication, Chat'**
  String get categoryCommDescription;

  /// No description provided for @categoryCommunityTitle.
  ///
  /// In en, this message translates to:
  /// **'Community & Volunteering'**
  String get categoryCommunityTitle;

  /// No description provided for @categoryCommunityDescription.
  ///
  /// In en, this message translates to:
  /// **'Open to help out for free/non-specific exchange'**
  String get categoryCommunityDescription;

  /// No description provided for @categoryTechTitle.
  ///
  /// In en, this message translates to:
  /// **'Technology & Learning'**
  String get categoryTechTitle;

  /// No description provided for @categoryTechDescription.
  ///
  /// In en, this message translates to:
  /// **'Technology, learning, innovation'**
  String get categoryTechDescription;

  /// No description provided for @addYourOwnKeywords.
  ///
  /// In en, this message translates to:
  /// **'Add your own keywords'**
  String get addYourOwnKeywords;

  /// No description provided for @enterYourPin.
  ///
  /// In en, this message translates to:
  /// **'Enter Your PIN'**
  String get enterYourPin;

  /// No description provided for @pinSetupDescription.
  ///
  /// In en, this message translates to:
  /// **'Please set up a 5-digit PIN for security'**
  String get pinSetupDescription;

  /// No description provided for @forgotPin.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN?'**
  String get forgotPin;

  /// No description provided for @pinResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your PIN has been successfully reset.'**
  String get pinResetSuccess;

  /// No description provided for @resetYourPin.
  ///
  /// In en, this message translates to:
  /// **'Reset Your PIN'**
  String get resetYourPin;

  /// No description provided for @enterNewPinDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter a new 5-digit PIN'**
  String get enterNewPinDescription;

  /// No description provided for @googleSignInNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In not implemented.'**
  String get googleSignInNotImplemented;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email.'**
  String get pleaseEnterValidEmail;

  /// No description provided for @pleaseEnter5DigitPin.
  ///
  /// In en, this message translates to:
  /// **'Please enter a 5-digit PIN.'**
  String get pleaseEnter5DigitPin;

  /// No description provided for @accountSetupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your account has been set up!'**
  String get accountSetupSuccess;

  /// No description provided for @setUpAccount.
  ///
  /// In en, this message translates to:
  /// **'Set Up Account'**
  String get setUpAccount;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @create5DigitPin.
  ///
  /// In en, this message translates to:
  /// **'Create a 5-digit PIN'**
  String get create5DigitPin;

  /// No description provided for @completeSetup.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get completeSetup;

  /// No description provided for @resetLinkSentMessage.
  ///
  /// In en, this message translates to:
  /// **'If an account exists, a reset link has been sent.'**
  String get resetLinkSentMessage;

  /// No description provided for @forgotPinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to receive a PIN reset link.'**
  String get forgotPinSubtitle;

  /// No description provided for @pleaseEnterValidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmailAddress;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @generateAvatar.
  ///
  /// In en, this message translates to:
  /// **'Generate Avatar'**
  String get generateAvatar;

  /// No description provided for @skin.
  ///
  /// In en, this message translates to:
  /// **'Skin'**
  String get skin;

  /// No description provided for @hairStyle.
  ///
  /// In en, this message translates to:
  /// **'Hair Style'**
  String get hairStyle;

  /// No description provided for @hairColor.
  ///
  /// In en, this message translates to:
  /// **'Hair Color'**
  String get hairColor;

  /// No description provided for @eyes.
  ///
  /// In en, this message translates to:
  /// **'Eyes'**
  String get eyes;

  /// No description provided for @nose.
  ///
  /// In en, this message translates to:
  /// **'Nose'**
  String get nose;

  /// No description provided for @mouth.
  ///
  /// In en, this message translates to:
  /// **'Mouth'**
  String get mouth;

  /// No description provided for @styleNumber.
  ///
  /// In en, this message translates to:
  /// **'Style {number}'**
  String styleNumber(Object number);

  /// No description provided for @randomize.
  ///
  /// In en, this message translates to:
  /// **'Randomize'**
  String get randomize;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get saveAndContinue;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @generateCryptoWallet.
  ///
  /// In en, this message translates to:
  /// **'Generate Crypto Wallet'**
  String get generateCryptoWallet;

  /// No description provided for @generateWallet.
  ///
  /// In en, this message translates to:
  /// **'Generate Wallet'**
  String get generateWallet;

  /// No description provided for @publicKey.
  ///
  /// In en, this message translates to:
  /// **'Public Key'**
  String get publicKey;

  /// No description provided for @privateKey.
  ///
  /// In en, this message translates to:
  /// **'Private Key'**
  String get privateKey;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @category_green.
  ///
  /// In en, this message translates to:
  /// **'Nature, outdoors, gardening, animals, environment, hiking, plants, sustainability'**
  String get category_green;

  /// No description provided for @category_red.
  ///
  /// In en, this message translates to:
  /// **'Sports, physical exercise, partying, dancing, physical work, mechanisms, tools, hands-on activities'**
  String get category_red;

  /// No description provided for @category_blue.
  ///
  /// In en, this message translates to:
  /// **'Business, entrepreneurship, paid work, making contacts, money matters, finance, career'**
  String get category_blue;

  /// No description provided for @category_purple.
  ///
  /// In en, this message translates to:
  /// **'Art, spirituality, philosophy, culture, music, crafts, creativity, design, history'**
  String get category_purple;

  /// No description provided for @category_yellow.
  ///
  /// In en, this message translates to:
  /// **'Chat, social activities, casual conversation, local events, new contacts, communication'**
  String get category_yellow;

  /// No description provided for @category_orange.
  ///
  /// In en, this message translates to:
  /// **'Volunteering, open-ended support, free exchange, consulting, non-specific assistance, community'**
  String get category_orange;

  /// No description provided for @category_teal.
  ///
  /// In en, this message translates to:
  /// **'Technology, learning, education, innovation, brainstorming, ideas, science, software'**
  String get category_teal;

  /// No description provided for @attr_3d_printing.
  ///
  /// In en, this message translates to:
  /// **'3D printing'**
  String get attr_3d_printing;

  /// No description provided for @attr_artificial_intelligence.
  ///
  /// In en, this message translates to:
  /// **'Artificial Intelligence'**
  String get attr_artificial_intelligence;

  /// No description provided for @attr_acting.
  ///
  /// In en, this message translates to:
  /// **'Acting'**
  String get attr_acting;

  /// No description provided for @attr_amateur_radio.
  ///
  /// In en, this message translates to:
  /// **'Amateur radio'**
  String get attr_amateur_radio;

  /// No description provided for @attr_animation.
  ///
  /// In en, this message translates to:
  /// **'Animation'**
  String get attr_animation;

  /// No description provided for @attr_baking.
  ///
  /// In en, this message translates to:
  /// **'Baking'**
  String get attr_baking;

  /// No description provided for @attr_beekeeping.
  ///
  /// In en, this message translates to:
  /// **'Beekeeping'**
  String get attr_beekeeping;

  /// No description provided for @attr_blogging.
  ///
  /// In en, this message translates to:
  /// **'Blogging'**
  String get attr_blogging;

  /// No description provided for @attr_board_games.
  ///
  /// In en, this message translates to:
  /// **'Board games'**
  String get attr_board_games;

  /// No description provided for @attr_books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get attr_books;

  /// No description provided for @attr_bowling.
  ///
  /// In en, this message translates to:
  /// **'Bowling'**
  String get attr_bowling;

  /// No description provided for @attr_breadmaking.
  ///
  /// In en, this message translates to:
  /// **'Breadmaking'**
  String get attr_breadmaking;

  /// No description provided for @attr_construction.
  ///
  /// In en, this message translates to:
  /// **'Construction'**
  String get attr_construction;

  /// No description provided for @attr_candle_making.
  ///
  /// In en, this message translates to:
  /// **'Candle making'**
  String get attr_candle_making;

  /// No description provided for @attr_car_maintenance.
  ///
  /// In en, this message translates to:
  /// **'Car maintenance'**
  String get attr_car_maintenance;

  /// No description provided for @attr_card_games.
  ///
  /// In en, this message translates to:
  /// **'Card games'**
  String get attr_card_games;

  /// No description provided for @attr_ceramics.
  ///
  /// In en, this message translates to:
  /// **'Ceramics'**
  String get attr_ceramics;

  /// No description provided for @attr_charity_work.
  ///
  /// In en, this message translates to:
  /// **'Charity work'**
  String get attr_charity_work;

  /// No description provided for @attr_chess.
  ///
  /// In en, this message translates to:
  /// **'Chess'**
  String get attr_chess;

  /// No description provided for @attr_cleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get attr_cleaning;

  /// No description provided for @attr_clothesmaking.
  ///
  /// In en, this message translates to:
  /// **'Clothesmaking'**
  String get attr_clothesmaking;

  /// No description provided for @attr_coffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get attr_coffee;

  /// No description provided for @attr_software_development.
  ///
  /// In en, this message translates to:
  /// **'Software development'**
  String get attr_software_development;

  /// No description provided for @attr_cooking.
  ///
  /// In en, this message translates to:
  /// **'Cooking'**
  String get attr_cooking;

  /// No description provided for @attr_couponing.
  ///
  /// In en, this message translates to:
  /// **'Couponing'**
  String get attr_couponing;

  /// No description provided for @attr_creative_writing.
  ///
  /// In en, this message translates to:
  /// **'Creative writing'**
  String get attr_creative_writing;

  /// No description provided for @attr_crocheting.
  ///
  /// In en, this message translates to:
  /// **'Crocheting'**
  String get attr_crocheting;

  /// No description provided for @attr_cross_stitch.
  ///
  /// In en, this message translates to:
  /// **'Cross-stitch'**
  String get attr_cross_stitch;

  /// No description provided for @attr_dance.
  ///
  /// In en, this message translates to:
  /// **'Dance'**
  String get attr_dance;

  /// No description provided for @attr_digital_arts.
  ///
  /// In en, this message translates to:
  /// **'Digital arts'**
  String get attr_digital_arts;

  /// No description provided for @attr_djing.
  ///
  /// In en, this message translates to:
  /// **'DJing'**
  String get attr_djing;

  /// No description provided for @attr_diy.
  ///
  /// In en, this message translates to:
  /// **'DIY'**
  String get attr_diy;

  /// No description provided for @attr_drawing.
  ///
  /// In en, this message translates to:
  /// **'Drawing'**
  String get attr_drawing;

  /// No description provided for @attr_electronics.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get attr_electronics;

  /// No description provided for @attr_embroidery.
  ///
  /// In en, this message translates to:
  /// **'Embroidery'**
  String get attr_embroidery;

  /// No description provided for @attr_engraving.
  ///
  /// In en, this message translates to:
  /// **'Engraving'**
  String get attr_engraving;

  /// No description provided for @attr_event_hosting.
  ///
  /// In en, this message translates to:
  /// **'Event hosting'**
  String get attr_event_hosting;

  /// No description provided for @attr_fashion.
  ///
  /// In en, this message translates to:
  /// **'Fashion'**
  String get attr_fashion;

  /// No description provided for @attr_fashion_design.
  ///
  /// In en, this message translates to:
  /// **'Fashion design'**
  String get attr_fashion_design;

  /// No description provided for @attr_flower_arranging.
  ///
  /// In en, this message translates to:
  /// **'Flower arranging'**
  String get attr_flower_arranging;

  /// No description provided for @attr_furniture_building.
  ///
  /// In en, this message translates to:
  /// **'Furniture building'**
  String get attr_furniture_building;

  /// No description provided for @attr_gaming.
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get attr_gaming;

  /// No description provided for @attr_genealogy.
  ///
  /// In en, this message translates to:
  /// **'Genealogy'**
  String get attr_genealogy;

  /// No description provided for @attr_graphic_design.
  ///
  /// In en, this message translates to:
  /// **'Graphic design'**
  String get attr_graphic_design;

  /// No description provided for @attr_hacking.
  ///
  /// In en, this message translates to:
  /// **'Hacking'**
  String get attr_hacking;

  /// No description provided for @attr_herp_keeping.
  ///
  /// In en, this message translates to:
  /// **'Herp keeping'**
  String get attr_herp_keeping;

  /// No description provided for @attr_home_improvement.
  ///
  /// In en, this message translates to:
  /// **'Home improvement'**
  String get attr_home_improvement;

  /// No description provided for @attr_homebrewing.
  ///
  /// In en, this message translates to:
  /// **'Homebrewing'**
  String get attr_homebrewing;

  /// No description provided for @attr_houseplant_care.
  ///
  /// In en, this message translates to:
  /// **'Houseplant care'**
  String get attr_houseplant_care;

  /// No description provided for @attr_hydroponics.
  ///
  /// In en, this message translates to:
  /// **'Hydroponics'**
  String get attr_hydroponics;

  /// No description provided for @attr_jewelry.
  ///
  /// In en, this message translates to:
  /// **'Jewelry'**
  String get attr_jewelry;

  /// No description provided for @attr_knitting.
  ///
  /// In en, this message translates to:
  /// **'Knitting'**
  String get attr_knitting;

  /// No description provided for @attr_kombucha.
  ///
  /// In en, this message translates to:
  /// **'Kombucha'**
  String get attr_kombucha;

  /// No description provided for @attr_leather_crafting.
  ///
  /// In en, this message translates to:
  /// **'Leather crafting'**
  String get attr_leather_crafting;

  /// No description provided for @attr_podcasts.
  ///
  /// In en, this message translates to:
  /// **'Podcasts'**
  String get attr_podcasts;

  /// No description provided for @attr_machining.
  ///
  /// In en, this message translates to:
  /// **'Machining'**
  String get attr_machining;

  /// No description provided for @attr_magic.
  ///
  /// In en, this message translates to:
  /// **'Magic'**
  String get attr_magic;

  /// No description provided for @attr_makeup.
  ///
  /// In en, this message translates to:
  /// **'Makeup'**
  String get attr_makeup;

  /// No description provided for @attr_massage.
  ///
  /// In en, this message translates to:
  /// **'Massage'**
  String get attr_massage;

  /// No description provided for @attr_metalworking.
  ///
  /// In en, this message translates to:
  /// **'Metalworking'**
  String get attr_metalworking;

  /// No description provided for @attr_nail_art.
  ///
  /// In en, this message translates to:
  /// **'Nail art'**
  String get attr_nail_art;

  /// No description provided for @attr_painting.
  ///
  /// In en, this message translates to:
  /// **'Painting'**
  String get attr_painting;

  /// No description provided for @attr_photography.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get attr_photography;

  /// No description provided for @attr_pottery.
  ///
  /// In en, this message translates to:
  /// **'Pottery'**
  String get attr_pottery;

  /// No description provided for @attr_powerlifting.
  ///
  /// In en, this message translates to:
  /// **'Powerlifting'**
  String get attr_powerlifting;

  /// No description provided for @attr_puzzles.
  ///
  /// In en, this message translates to:
  /// **'Puzzles'**
  String get attr_puzzles;

  /// No description provided for @attr_quilting.
  ///
  /// In en, this message translates to:
  /// **'Quilting'**
  String get attr_quilting;

  /// No description provided for @attr_gadgets.
  ///
  /// In en, this message translates to:
  /// **'Gadgets'**
  String get attr_gadgets;

  /// No description provided for @attr_robotics.
  ///
  /// In en, this message translates to:
  /// **'Robotics'**
  String get attr_robotics;

  /// No description provided for @attr_sculpting.
  ///
  /// In en, this message translates to:
  /// **'Sculpting'**
  String get attr_sculpting;

  /// No description provided for @attr_sewing.
  ///
  /// In en, this message translates to:
  /// **'Sewing'**
  String get attr_sewing;

  /// No description provided for @attr_shoemaking.
  ///
  /// In en, this message translates to:
  /// **'Shoemaking'**
  String get attr_shoemaking;

  /// No description provided for @attr_singing.
  ///
  /// In en, this message translates to:
  /// **'Singing'**
  String get attr_singing;

  /// No description provided for @attr_skateboarding.
  ///
  /// In en, this message translates to:
  /// **'Skateboarding'**
  String get attr_skateboarding;

  /// No description provided for @attr_sketching.
  ///
  /// In en, this message translates to:
  /// **'Sketching'**
  String get attr_sketching;

  /// No description provided for @attr_soapmaking.
  ///
  /// In en, this message translates to:
  /// **'Soapmaking'**
  String get attr_soapmaking;

  /// No description provided for @attr_social_media.
  ///
  /// In en, this message translates to:
  /// **'Social media'**
  String get attr_social_media;

  /// No description provided for @attr_stand_up_comedy.
  ///
  /// In en, this message translates to:
  /// **'Stand-up comedy'**
  String get attr_stand_up_comedy;

  /// No description provided for @attr_storytelling.
  ///
  /// In en, this message translates to:
  /// **'Storytelling'**
  String get attr_storytelling;

  /// No description provided for @attr_sudoku.
  ///
  /// In en, this message translates to:
  /// **'Sudoku'**
  String get attr_sudoku;

  /// No description provided for @attr_table_tennis.
  ///
  /// In en, this message translates to:
  /// **'Table tennis'**
  String get attr_table_tennis;

  /// No description provided for @attr_thrifting.
  ///
  /// In en, this message translates to:
  /// **'Thrifting'**
  String get attr_thrifting;

  /// No description provided for @attr_video_editing.
  ///
  /// In en, this message translates to:
  /// **'Video editing'**
  String get attr_video_editing;

  /// No description provided for @attr_video_game_developing.
  ///
  /// In en, this message translates to:
  /// **'Video game developing'**
  String get attr_video_game_developing;

  /// No description provided for @attr_weaving.
  ///
  /// In en, this message translates to:
  /// **'Weaving'**
  String get attr_weaving;

  /// No description provided for @attr_weight_training.
  ///
  /// In en, this message translates to:
  /// **'Weight training'**
  String get attr_weight_training;

  /// No description provided for @attr_welding.
  ///
  /// In en, this message translates to:
  /// **'Welding'**
  String get attr_welding;

  /// No description provided for @attr_wood_carving.
  ///
  /// In en, this message translates to:
  /// **'Wood carving'**
  String get attr_wood_carving;

  /// No description provided for @attr_woodworking.
  ///
  /// In en, this message translates to:
  /// **'Woodworking'**
  String get attr_woodworking;

  /// No description provided for @attr_writing.
  ///
  /// In en, this message translates to:
  /// **'Writing'**
  String get attr_writing;

  /// No description provided for @attr_yoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get attr_yoga;

  /// No description provided for @attr_zumba.
  ///
  /// In en, this message translates to:
  /// **'Zumba'**
  String get attr_zumba;

  /// No description provided for @attr_hiking.
  ///
  /// In en, this message translates to:
  /// **'Hiking'**
  String get attr_hiking;

  /// No description provided for @attr_reading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get attr_reading;

  /// No description provided for @attr_gardening.
  ///
  /// In en, this message translates to:
  /// **'Gardening'**
  String get attr_gardening;

  /// No description provided for @attr_music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get attr_music;

  /// No description provided for @attr_dancing.
  ///
  /// In en, this message translates to:
  /// **'Dancing'**
  String get attr_dancing;

  /// No description provided for @attr_aerobics.
  ///
  /// In en, this message translates to:
  /// **'Aerobics'**
  String get attr_aerobics;

  /// No description provided for @attr_traveling.
  ///
  /// In en, this message translates to:
  /// **'Traveling'**
  String get attr_traveling;

  /// No description provided for @attr_coding.
  ///
  /// In en, this message translates to:
  /// **'Coding'**
  String get attr_coding;

  /// No description provided for @attr_sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get attr_sports;

  /// No description provided for @attr_movies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get attr_movies;

  /// No description provided for @attr_volunteering.
  ///
  /// In en, this message translates to:
  /// **'Volunteering'**
  String get attr_volunteering;

  /// No description provided for @attr_meditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get attr_meditation;

  /// No description provided for @attr_crafting.
  ///
  /// In en, this message translates to:
  /// **'Crafting'**
  String get attr_crafting;

  /// No description provided for @attr_astronomy.
  ///
  /// In en, this message translates to:
  /// **'Astronomy'**
  String get attr_astronomy;

  /// No description provided for @attr_backpacking.
  ///
  /// In en, this message translates to:
  /// **'Backpacking'**
  String get attr_backpacking;

  /// No description provided for @attr_bird_watching.
  ///
  /// In en, this message translates to:
  /// **'Bird watching'**
  String get attr_bird_watching;

  /// No description provided for @attr_camping.
  ///
  /// In en, this message translates to:
  /// **'Camping'**
  String get attr_camping;

  /// No description provided for @attr_canyoning.
  ///
  /// In en, this message translates to:
  /// **'Canyoning'**
  String get attr_canyoning;

  /// No description provided for @attr_car_restoration.
  ///
  /// In en, this message translates to:
  /// **'Car restoration'**
  String get attr_car_restoration;

  /// No description provided for @attr_climbing.
  ///
  /// In en, this message translates to:
  /// **'Climbing'**
  String get attr_climbing;

  /// No description provided for @attr_cryptocurrency.
  ///
  /// In en, this message translates to:
  /// **'Cryptocurrency'**
  String get attr_cryptocurrency;

  /// No description provided for @attr_culinary_arts.
  ///
  /// In en, this message translates to:
  /// **'Culinary arts'**
  String get attr_culinary_arts;

  /// No description provided for @attr_cycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get attr_cycling;

  /// No description provided for @attr_drones.
  ///
  /// In en, this message translates to:
  /// **'Drones'**
  String get attr_drones;

  /// No description provided for @attr_fermentation.
  ///
  /// In en, this message translates to:
  /// **'Fermentation'**
  String get attr_fermentation;

  /// No description provided for @attr_film_making.
  ///
  /// In en, this message translates to:
  /// **'Film making'**
  String get attr_film_making;

  /// No description provided for @attr_financial_investing.
  ///
  /// In en, this message translates to:
  /// **'Financial investing'**
  String get attr_financial_investing;

  /// No description provided for @attr_fishing.
  ///
  /// In en, this message translates to:
  /// **'Fishing'**
  String get attr_fishing;

  /// No description provided for @attr_foraging.
  ///
  /// In en, this message translates to:
  /// **'Foraging'**
  String get attr_foraging;

  /// No description provided for @attr_geocaching.
  ///
  /// In en, this message translates to:
  /// **'Geocaching'**
  String get attr_geocaching;

  /// No description provided for @attr_kayaking.
  ///
  /// In en, this message translates to:
  /// **'Kayaking'**
  String get attr_kayaking;

  /// No description provided for @attr_martial_arts.
  ///
  /// In en, this message translates to:
  /// **'Martial arts'**
  String get attr_martial_arts;

  /// No description provided for @attr_mindfulness.
  ///
  /// In en, this message translates to:
  /// **'Mindfulness'**
  String get attr_mindfulness;

  /// No description provided for @attr_mushroom_hunting.
  ///
  /// In en, this message translates to:
  /// **'Mushroom hunting'**
  String get attr_mushroom_hunting;

  /// No description provided for @attr_personal_finance.
  ///
  /// In en, this message translates to:
  /// **'Personal finance'**
  String get attr_personal_finance;

  /// No description provided for @attr_rock_climbing.
  ///
  /// In en, this message translates to:
  /// **'Rock climbing'**
  String get attr_rock_climbing;

  /// No description provided for @attr_running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get attr_running;

  /// No description provided for @attr_sustainable_living.
  ///
  /// In en, this message translates to:
  /// **'Sustainable living'**
  String get attr_sustainable_living;

  /// No description provided for @attr_urban_exploration.
  ///
  /// In en, this message translates to:
  /// **'Urban exploration'**
  String get attr_urban_exploration;

  /// No description provided for @attr_alternative_medicine.
  ///
  /// In en, this message translates to:
  /// **'Alternative medicine'**
  String get attr_alternative_medicine;

  /// No description provided for @attr_biohacking.
  ///
  /// In en, this message translates to:
  /// **'Biohacking'**
  String get attr_biohacking;

  /// No description provided for @attr_cold_plunging.
  ///
  /// In en, this message translates to:
  /// **'Cold plunging'**
  String get attr_cold_plunging;

  /// No description provided for @attr_community_gardening.
  ///
  /// In en, this message translates to:
  /// **'Community gardening'**
  String get attr_community_gardening;

  /// No description provided for @attr_cybersecurity.
  ///
  /// In en, this message translates to:
  /// **'Cybersecurity'**
  String get attr_cybersecurity;

  /// No description provided for @attr_day_trading.
  ///
  /// In en, this message translates to:
  /// **'Day trading'**
  String get attr_day_trading;

  /// No description provided for @attr_deep_cleaning.
  ///
  /// In en, this message translates to:
  /// **'Deep cleaning'**
  String get attr_deep_cleaning;

  /// No description provided for @attr_digital_nomadism.
  ///
  /// In en, this message translates to:
  /// **'Digital nomadism'**
  String get attr_digital_nomadism;

  /// No description provided for @attr_recipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get attr_recipes;

  /// No description provided for @attr_bodybuilding.
  ///
  /// In en, this message translates to:
  /// **'Bodybuilding'**
  String get attr_bodybuilding;

  /// No description provided for @attr_memes.
  ///
  /// In en, this message translates to:
  /// **'Memes'**
  String get attr_memes;

  /// No description provided for @attr_metal_detecting.
  ///
  /// In en, this message translates to:
  /// **'Metal detecting'**
  String get attr_metal_detecting;

  /// No description provided for @attr_minimalism.
  ///
  /// In en, this message translates to:
  /// **'Minimalism'**
  String get attr_minimalism;

  /// No description provided for @attr_pet_grooming.
  ///
  /// In en, this message translates to:
  /// **'Pet grooming'**
  String get attr_pet_grooming;

  /// No description provided for @attr_podcasting.
  ///
  /// In en, this message translates to:
  /// **'Podcasting'**
  String get attr_podcasting;

  /// No description provided for @attr_record_collecting.
  ///
  /// In en, this message translates to:
  /// **'Record collecting'**
  String get attr_record_collecting;

  /// No description provided for @attr_tiny_homes.
  ///
  /// In en, this message translates to:
  /// **'Tiny homes'**
  String get attr_tiny_homes;

  /// No description provided for @attr_upcycling.
  ///
  /// In en, this message translates to:
  /// **'Upcycling'**
  String get attr_upcycling;

  /// No description provided for @attr_virtual_reality.
  ///
  /// In en, this message translates to:
  /// **'Virtual reality'**
  String get attr_virtual_reality;

  /// No description provided for @attr_pc_building.
  ///
  /// In en, this message translates to:
  /// **'PC building'**
  String get attr_pc_building;

  /// No description provided for @attr_babysitting.
  ///
  /// In en, this message translates to:
  /// **'Babysitting'**
  String get attr_babysitting;

  /// No description provided for @attr_backgammon.
  ///
  /// In en, this message translates to:
  /// **'Backgammon'**
  String get attr_backgammon;

  /// No description provided for @attr_bicycles.
  ///
  /// In en, this message translates to:
  /// **'Bicycles'**
  String get attr_bicycles;

  /// No description provided for @attr_billiards.
  ///
  /// In en, this message translates to:
  /// **'Billiards'**
  String get attr_billiards;

  /// No description provided for @attr_canned_goods.
  ///
  /// In en, this message translates to:
  /// **'Canned goods'**
  String get attr_canned_goods;

  /// No description provided for @attr_car_detailing.
  ///
  /// In en, this message translates to:
  /// **'Car detailing'**
  String get attr_car_detailing;

  /// No description provided for @attr_carpentry.
  ///
  /// In en, this message translates to:
  /// **'Carpentry'**
  String get attr_carpentry;

  /// No description provided for @attr_code_review.
  ///
  /// In en, this message translates to:
  /// **'Code review'**
  String get attr_code_review;

  /// No description provided for @attr_comic_books.
  ///
  /// In en, this message translates to:
  /// **'Comic books'**
  String get attr_comic_books;

  /// No description provided for @attr_computer_hardware.
  ///
  /// In en, this message translates to:
  /// **'Computer hardware'**
  String get attr_computer_hardware;

  /// No description provided for @attr_computer_repair.
  ///
  /// In en, this message translates to:
  /// **'Computer repair'**
  String get attr_computer_repair;

  /// No description provided for @attr_concert_tickets.
  ///
  /// In en, this message translates to:
  /// **'Concert tickets'**
  String get attr_concert_tickets;

  /// No description provided for @attr_co_op_gaming.
  ///
  /// In en, this message translates to:
  /// **'Co-op gaming'**
  String get attr_co_op_gaming;

  /// No description provided for @attr_creative_brainstorming.
  ///
  /// In en, this message translates to:
  /// **'Creative brainstorming'**
  String get attr_creative_brainstorming;

  /// No description provided for @attr_dance_lessons.
  ///
  /// In en, this message translates to:
  /// **'Dance lessons'**
  String get attr_dance_lessons;

  /// No description provided for @attr_dog_walking.
  ///
  /// In en, this message translates to:
  /// **'Dog walking'**
  String get attr_dog_walking;

  /// No description provided for @attr_elderly_care.
  ///
  /// In en, this message translates to:
  /// **'Elderly care'**
  String get attr_elderly_care;

  /// No description provided for @attr_electronic_components.
  ///
  /// In en, this message translates to:
  /// **'Electronic components'**
  String get attr_electronic_components;

  /// No description provided for @attr_exercise_partner.
  ///
  /// In en, this message translates to:
  /// **'Exercise partner'**
  String get attr_exercise_partner;

  /// No description provided for @attr_firewood.
  ///
  /// In en, this message translates to:
  /// **'Firewood'**
  String get attr_firewood;

  /// No description provided for @attr_fitness_coaching.
  ///
  /// In en, this message translates to:
  /// **'Fitness coaching'**
  String get attr_fitness_coaching;

  /// No description provided for @attr_fresh_eggs.
  ///
  /// In en, this message translates to:
  /// **'Fresh eggs'**
  String get attr_fresh_eggs;

  /// No description provided for @attr_furniture_repair.
  ///
  /// In en, this message translates to:
  /// **'Furniture repair'**
  String get attr_furniture_repair;

  /// No description provided for @attr_gardening_advice.
  ///
  /// In en, this message translates to:
  /// **'Gardening advice'**
  String get attr_gardening_advice;

  /// No description provided for @attr_graphic_novels.
  ///
  /// In en, this message translates to:
  /// **'Graphic novels'**
  String get attr_graphic_novels;

  /// No description provided for @attr_guitar.
  ///
  /// In en, this message translates to:
  /// **'Guitar'**
  String get attr_guitar;

  /// No description provided for @attr_handmade.
  ///
  /// In en, this message translates to:
  /// **'Handmade'**
  String get attr_handmade;

  /// No description provided for @attr_handyman_services.
  ///
  /// In en, this message translates to:
  /// **'Handyman services'**
  String get attr_handyman_services;

  /// No description provided for @attr_hauling_services.
  ///
  /// In en, this message translates to:
  /// **'Hauling services'**
  String get attr_hauling_services;

  /// No description provided for @attr_herbal_remedies.
  ///
  /// In en, this message translates to:
  /// **'Herbal remedies'**
  String get attr_herbal_remedies;

  /// No description provided for @attr_horseback_riding.
  ///
  /// In en, this message translates to:
  /// **'Horseback riding'**
  String get attr_horseback_riding;

  /// No description provided for @attr_interview_practice.
  ///
  /// In en, this message translates to:
  /// **'Interview practice'**
  String get attr_interview_practice;

  /// No description provided for @attr_language_exchange.
  ///
  /// In en, this message translates to:
  /// **'Language exchange'**
  String get attr_language_exchange;

  /// No description provided for @attr_lawn_mowing.
  ///
  /// In en, this message translates to:
  /// **'Lawn mowing'**
  String get attr_lawn_mowing;

  /// No description provided for @attr_local_tours.
  ///
  /// In en, this message translates to:
  /// **'Local tours'**
  String get attr_local_tours;

  /// No description provided for @attr_math_tutoring.
  ///
  /// In en, this message translates to:
  /// **'Math tutoring'**
  String get attr_math_tutoring;

  /// No description provided for @attr_mentorship.
  ///
  /// In en, this message translates to:
  /// **'Mentorship'**
  String get attr_mentorship;

  /// No description provided for @attr_motorcycles.
  ///
  /// In en, this message translates to:
  /// **'Motorcycles'**
  String get attr_motorcycles;

  /// No description provided for @attr_moving_help.
  ///
  /// In en, this message translates to:
  /// **'Moving help'**
  String get attr_moving_help;

  /// No description provided for @attr_musical_instruments.
  ///
  /// In en, this message translates to:
  /// **'Musical instruments'**
  String get attr_musical_instruments;

  /// No description provided for @attr_pair_programming.
  ///
  /// In en, this message translates to:
  /// **'Pair programming'**
  String get attr_pair_programming;

  /// No description provided for @attr_pet_sitting.
  ///
  /// In en, this message translates to:
  /// **'Pet sitting'**
  String get attr_pet_sitting;

  /// No description provided for @attr_photo_restoration.
  ///
  /// In en, this message translates to:
  /// **'Photo restoration'**
  String get attr_photo_restoration;

  /// No description provided for @attr_piano_lessons.
  ///
  /// In en, this message translates to:
  /// **'Piano lessons'**
  String get attr_piano_lessons;

  /// No description provided for @attr_plant_cuttings.
  ///
  /// In en, this message translates to:
  /// **'Plant cuttings'**
  String get attr_plant_cuttings;

  /// No description provided for @attr_proofreading.
  ///
  /// In en, this message translates to:
  /// **'Proofreading'**
  String get attr_proofreading;

  /// No description provided for @attr_resume_writing.
  ///
  /// In en, this message translates to:
  /// **'Resume writing'**
  String get attr_resume_writing;

  /// No description provided for @attr_rpg_games.
  ///
  /// In en, this message translates to:
  /// **'RPG games'**
  String get attr_rpg_games;

  /// No description provided for @attr_scrap_metal.
  ///
  /// In en, this message translates to:
  /// **'Scrap metal'**
  String get attr_scrap_metal;

  /// No description provided for @attr_event_tickets.
  ///
  /// In en, this message translates to:
  /// **'Event tickets'**
  String get attr_event_tickets;

  /// No description provided for @attr_sports_coaching.
  ///
  /// In en, this message translates to:
  /// **'Sports coaching'**
  String get attr_sports_coaching;

  /// No description provided for @attr_study_partner.
  ///
  /// In en, this message translates to:
  /// **'Study partner'**
  String get attr_study_partner;

  /// No description provided for @attr_technical_writing.
  ///
  /// In en, this message translates to:
  /// **'Technical writing'**
  String get attr_technical_writing;

  /// No description provided for @attr_tennis.
  ///
  /// In en, this message translates to:
  /// **'Tennis'**
  String get attr_tennis;

  /// No description provided for @attr_tool_lending.
  ///
  /// In en, this message translates to:
  /// **'Tool lending'**
  String get attr_tool_lending;

  /// No description provided for @attr_translation_services.
  ///
  /// In en, this message translates to:
  /// **'Translation services'**
  String get attr_translation_services;

  /// No description provided for @attr_used_books.
  ///
  /// In en, this message translates to:
  /// **'Used books'**
  String get attr_used_books;

  /// No description provided for @attr_used_electronics.
  ///
  /// In en, this message translates to:
  /// **'Used electronics'**
  String get attr_used_electronics;

  /// No description provided for @attr_used_furniture.
  ///
  /// In en, this message translates to:
  /// **'Used furniture'**
  String get attr_used_furniture;

  /// No description provided for @attr_vehicle_repair.
  ///
  /// In en, this message translates to:
  /// **'Vehicle repair'**
  String get attr_vehicle_repair;

  /// No description provided for @attr_video_game_consoles.
  ///
  /// In en, this message translates to:
  /// **'Video game consoles'**
  String get attr_video_game_consoles;

  /// No description provided for @attr_vintage_clothing.
  ///
  /// In en, this message translates to:
  /// **'Vintage clothing'**
  String get attr_vintage_clothing;

  /// No description provided for @attr_voice_lessons.
  ///
  /// In en, this message translates to:
  /// **'Voice lessons'**
  String get attr_voice_lessons;

  /// No description provided for @attr_ux_design.
  ///
  /// In en, this message translates to:
  /// **'UX design'**
  String get attr_ux_design;

  /// No description provided for @attr_window_cleaning.
  ///
  /// In en, this message translates to:
  /// **'Window cleaning'**
  String get attr_window_cleaning;

  /// No description provided for @attr_yard_work.
  ///
  /// In en, this message translates to:
  /// **'Yard work'**
  String get attr_yard_work;

  /// No description provided for @attr_drumming.
  ///
  /// In en, this message translates to:
  /// **'Drumming'**
  String get attr_drumming;

  /// No description provided for @attr_vocals.
  ///
  /// In en, this message translates to:
  /// **'Vocals'**
  String get attr_vocals;

  /// No description provided for @attr_permaculture.
  ///
  /// In en, this message translates to:
  /// **'Permaculture'**
  String get attr_permaculture;

  /// No description provided for @attr_physical_work.
  ///
  /// In en, this message translates to:
  /// **'Physical work'**
  String get attr_physical_work;

  /// No description provided for @attr_business_mentorship.
  ///
  /// In en, this message translates to:
  /// **'Business Mentorship'**
  String get attr_business_mentorship;

  /// No description provided for @attr_spirituality.
  ///
  /// In en, this message translates to:
  /// **'Spirituality'**
  String get attr_spirituality;

  /// No description provided for @attr_natural_remedies.
  ///
  /// In en, this message translates to:
  /// **'Natural remedies'**
  String get attr_natural_remedies;

  /// No description provided for @attr_retreats.
  ///
  /// In en, this message translates to:
  /// **'Retreats'**
  String get attr_retreats;

  /// No description provided for @attr_zen.
  ///
  /// In en, this message translates to:
  /// **'Zen'**
  String get attr_zen;

  /// No description provided for @attr_linux.
  ///
  /// In en, this message translates to:
  /// **'Linux'**
  String get attr_linux;

  /// No description provided for @attr_app_development.
  ///
  /// In en, this message translates to:
  /// **'App development'**
  String get attr_app_development;

  /// No description provided for @attr_android.
  ///
  /// In en, this message translates to:
  /// **'Android'**
  String get attr_android;

  /// No description provided for @attr_ios.
  ///
  /// In en, this message translates to:
  /// **'iOS'**
  String get attr_ios;

  /// No description provided for @attr_backend_development.
  ///
  /// In en, this message translates to:
  /// **'Backend development'**
  String get attr_backend_development;

  /// No description provided for @attr_plumbing.
  ///
  /// In en, this message translates to:
  /// **'Plumbing'**
  String get attr_plumbing;

  /// No description provided for @attr_art_exhibitions.
  ///
  /// In en, this message translates to:
  /// **'Art Exhibitions'**
  String get attr_art_exhibitions;

  /// No description provided for @attr_environmentalism.
  ///
  /// In en, this message translates to:
  /// **'Environmentalism'**
  String get attr_environmentalism;

  /// No description provided for @attr_fresh_vegetables.
  ///
  /// In en, this message translates to:
  /// **'Fresh vegetables'**
  String get attr_fresh_vegetables;

  /// No description provided for @attr_fresh_fruits.
  ///
  /// In en, this message translates to:
  /// **'Fresh fruits'**
  String get attr_fresh_fruits;

  /// No description provided for @attr_fresh_herbs.
  ///
  /// In en, this message translates to:
  /// **'Fresh herbs'**
  String get attr_fresh_herbs;

  /// No description provided for @attr_tea.
  ///
  /// In en, this message translates to:
  /// **'Tea'**
  String get attr_tea;

  /// No description provided for @attr_legal_advice.
  ///
  /// In en, this message translates to:
  /// **'Legal advice'**
  String get attr_legal_advice;

  /// No description provided for @attr_cats.
  ///
  /// In en, this message translates to:
  /// **'Cats'**
  String get attr_cats;

  /// No description provided for @attr_dogs.
  ///
  /// In en, this message translates to:
  /// **'Dogs'**
  String get attr_dogs;

  /// No description provided for @attr_poker.
  ///
  /// In en, this message translates to:
  /// **'Poker'**
  String get attr_poker;

  /// No description provided for @attr_trees.
  ///
  /// In en, this message translates to:
  /// **'Trees'**
  String get attr_trees;

  /// No description provided for @attr_plants.
  ///
  /// In en, this message translates to:
  /// **'Plants'**
  String get attr_plants;

  /// No description provided for @attr_farm_animals.
  ///
  /// In en, this message translates to:
  /// **'Farm animals'**
  String get attr_farm_animals;

  /// No description provided for @attr_organic_food.
  ///
  /// In en, this message translates to:
  /// **'Organic food'**
  String get attr_organic_food;

  /// No description provided for @attr_technician.
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get attr_technician;

  /// No description provided for @attr_tractor.
  ///
  /// In en, this message translates to:
  /// **'Tractor'**
  String get attr_tractor;

  /// No description provided for @attr_driving.
  ///
  /// In en, this message translates to:
  /// **'Driving'**
  String get attr_driving;

  /// No description provided for @attr_machinery_operation.
  ///
  /// In en, this message translates to:
  /// **'Machinery operation'**
  String get attr_machinery_operation;

  /// No description provided for @attr_truck_driving.
  ///
  /// In en, this message translates to:
  /// **'Truck driving'**
  String get attr_truck_driving;

  /// No description provided for @attr_assembly.
  ///
  /// In en, this message translates to:
  /// **'Assembly'**
  String get attr_assembly;

  /// No description provided for @attr_animal_care.
  ///
  /// In en, this message translates to:
  /// **'Animal care'**
  String get attr_animal_care;

  /// No description provided for @attr_horses.
  ///
  /// In en, this message translates to:
  /// **'Horses'**
  String get attr_horses;

  /// No description provided for @attr_goats.
  ///
  /// In en, this message translates to:
  /// **'Goats'**
  String get attr_goats;

  /// No description provided for @attr_cows.
  ///
  /// In en, this message translates to:
  /// **'Cows'**
  String get attr_cows;

  /// No description provided for @attr_self_sufficiency.
  ///
  /// In en, this message translates to:
  /// **'Self-sufficiency'**
  String get attr_self_sufficiency;

  /// No description provided for @attr_ridesharing.
  ///
  /// In en, this message translates to:
  /// **'Ridesharing'**
  String get attr_ridesharing;

  /// No description provided for @attr_fruit_harvesting.
  ///
  /// In en, this message translates to:
  /// **'Fruit harvesting'**
  String get attr_fruit_harvesting;

  /// No description provided for @attr_vegetable_harvesting.
  ///
  /// In en, this message translates to:
  /// **'Vegetable harvesting'**
  String get attr_vegetable_harvesting;

  /// No description provided for @attr_car_cleaning.
  ///
  /// In en, this message translates to:
  /// **'Car cleaning'**
  String get attr_car_cleaning;

  /// No description provided for @attr_farmstay.
  ///
  /// In en, this message translates to:
  /// **'Farmstay'**
  String get attr_farmstay;

  /// No description provided for @attr_house_maintenance.
  ///
  /// In en, this message translates to:
  /// **'House maintenance'**
  String get attr_house_maintenance;

  /// No description provided for @attr_shepherding.
  ///
  /// In en, this message translates to:
  /// **'Shepherding'**
  String get attr_shepherding;

  /// No description provided for @attr_renovation.
  ///
  /// In en, this message translates to:
  /// **'Renovation'**
  String get attr_renovation;

  /// No description provided for @attr_landscaping.
  ///
  /// In en, this message translates to:
  /// **'Landscaping'**
  String get attr_landscaping;

  /// No description provided for @attr_forestry.
  ///
  /// In en, this message translates to:
  /// **'Forestry'**
  String get attr_forestry;

  /// No description provided for @attr_academic_tutoring.
  ///
  /// In en, this message translates to:
  /// **'Academic tutoring'**
  String get attr_academic_tutoring;

  /// No description provided for @attr_building_materials.
  ///
  /// In en, this message translates to:
  /// **'Building materials'**
  String get attr_building_materials;

  /// No description provided for @attr_spare_parts.
  ///
  /// In en, this message translates to:
  /// **'Spare parts'**
  String get attr_spare_parts;

  /// No description provided for @attr_alternative_healing.
  ///
  /// In en, this message translates to:
  /// **'Alternative healing'**
  String get attr_alternative_healing;

  /// No description provided for @attr_socializing.
  ///
  /// In en, this message translates to:
  /// **'Socializing'**
  String get attr_socializing;

  /// No description provided for @userLocation.
  ///
  /// In en, this message translates to:
  /// **'Location:'**
  String get userLocation;

  /// No description provided for @editLocation.
  ///
  /// In en, this message translates to:
  /// **'Edit Location'**
  String get editLocation;

  /// No description provided for @editKeywords.
  ///
  /// In en, this message translates to:
  /// **'Edit Your Overall Interests'**
  String get editKeywords;

  /// No description provided for @createOfferPosting.
  ///
  /// In en, this message translates to:
  /// **'Create Offer Posting'**
  String get createOfferPosting;

  /// No description provided for @createInterestPosting.
  ///
  /// In en, this message translates to:
  /// **'Create Interest Posting'**
  String get createInterestPosting;

  /// No description provided for @postingTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get postingTitle;

  /// No description provided for @postingTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Brief title for your posting'**
  String get postingTitleHint;

  /// No description provided for @postingTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get postingTitleRequired;

  /// No description provided for @postingTitleTooShort.
  ///
  /// In en, this message translates to:
  /// **'Title must be at least 3 characters'**
  String get postingTitleTooShort;

  /// No description provided for @postingDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get postingDescription;

  /// No description provided for @postingDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Detailed description of what you\'re offering or looking for'**
  String get postingDescriptionHint;

  /// No description provided for @postingDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get postingDescriptionRequired;

  /// No description provided for @postingDescriptionTooShort.
  ///
  /// In en, this message translates to:
  /// **'Description must be at least 10 characters'**
  String get postingDescriptionTooShort;

  /// No description provided for @postingValue.
  ///
  /// In en, this message translates to:
  /// **'Value (Optional)'**
  String get postingValue;

  /// No description provided for @postingValueHint.
  ///
  /// In en, this message translates to:
  /// **'Estimated value'**
  String get postingValueHint;

  /// No description provided for @postingValueInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid positive number'**
  String get postingValueInvalid;

  /// No description provided for @optionalField.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optionalField;

  /// No description provided for @expirationDate.
  ///
  /// In en, this message translates to:
  /// **'Expiration Date'**
  String get expirationDate;

  /// No description provided for @tapToSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Tap to select expiration date (optional)'**
  String get tapToSelectDate;

  /// No description provided for @postingImages.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get postingImages;

  /// No description provided for @postingImagesHint.
  ///
  /// In en, this message translates to:
  /// **'Add up to 3 images (optional)'**
  String get postingImagesHint;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @maxImagesReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum 3 images allowed'**
  String get maxImagesReached;

  /// No description provided for @postingCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Posting created successfully!'**
  String get postingCreatedSuccess;

  /// No description provided for @addNewPosting.
  ///
  /// In en, this message translates to:
  /// **'Add Posting'**
  String get addNewPosting;

  /// No description provided for @deleteConversation.
  ///
  /// In en, this message translates to:
  /// **'Delete Conversation'**
  String get deleteConversation;

  /// No description provided for @deleteConversationConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this conversation? All messages will be permanently removed.'**
  String get deleteConversationConfirmation;

  /// No description provided for @conversationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Conversation deleted'**
  String get conversationDeleted;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @errorLoadingChats.
  ///
  /// In en, this message translates to:
  /// **'Error loading chats'**
  String get errorLoadingChats;

  /// No description provided for @couldNotFindChatParticipant.
  ///
  /// In en, this message translates to:
  /// **'Could not find chat participant'**
  String get couldNotFindChatParticipant;

  /// No description provided for @errorDeletingConversation.
  ///
  /// In en, this message translates to:
  /// **'Error deleting conversation'**
  String get errorDeletingConversation;

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesYet;

  /// No description provided for @ninetyNinePlus.
  ///
  /// In en, this message translates to:
  /// **'99+'**
  String get ninetyNinePlus;

  /// No description provided for @userPrefix.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userPrefix;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @errorUpdatingFavorite.
  ///
  /// In en, this message translates to:
  /// **'Error updating favorite'**
  String get errorUpdatingFavorite;

  /// No description provided for @noAttributesToDisplay.
  ///
  /// In en, this message translates to:
  /// **'No attributes to display.'**
  String get noAttributesToDisplay;

  /// No description provided for @errorLoadingPostings.
  ///
  /// In en, this message translates to:
  /// **'Error loading postings'**
  String get errorLoadingPostings;

  /// No description provided for @errorLoadingAttributes.
  ///
  /// In en, this message translates to:
  /// **'Error loading attributes'**
  String get errorLoadingAttributes;

  /// No description provided for @activePostings.
  ///
  /// In en, this message translates to:
  /// **'Active Postings'**
  String get activePostings;

  /// No description provided for @offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offers;

  /// No description provided for @lookingFor.
  ///
  /// In en, this message translates to:
  /// **'Looking For'**
  String get lookingFor;

  /// No description provided for @valuePrefix.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get valuePrefix;

  /// No description provided for @expiresPrefix.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expiresPrefix;

  /// No description provided for @postedPrefix.
  ///
  /// In en, this message translates to:
  /// **'Posted'**
  String get postedPrefix;

  /// No description provided for @noChatsYet.
  ///
  /// In en, this message translates to:
  /// **'No chats yet'**
  String get noChatsYet;

  /// No description provided for @startConversationFromMap.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation from the map'**
  String get startConversationFromMap;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Connect. Trade. Build Community.'**
  String get welcomeTagline;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
  String get howItWorks;

  /// No description provided for @welcomeStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Create your Profile'**
  String get welcomeStep1Title;

  /// No description provided for @welcomeStep1Description.
  ///
  /// In en, this message translates to:
  /// **'Create an anonymous profile with your interests and what you have to offer'**
  String get welcomeStep1Description;

  /// No description provided for @welcomeStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Discover, Search, Post'**
  String get welcomeStep2Title;

  /// No description provided for @welcomeStep2Description.
  ///
  /// In en, this message translates to:
  /// **'Find people with matching or complementary interests, search by keywords'**
  String get welcomeStep2Description;

  /// No description provided for @welcomeStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Start Chatting'**
  String get welcomeStep3Title;

  /// No description provided for @welcomeStep3Description.
  ///
  /// In en, this message translates to:
  /// **'Connect with others through End-to-end encrypted chat'**
  String get welcomeStep3Description;

  /// No description provided for @welcomeStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Make Exchanges'**
  String get welcomeStep4Title;

  /// No description provided for @welcomeStep4Description.
  ///
  /// In en, this message translates to:
  /// **'Trade skills, services, items, or simply connect with your community'**
  String get welcomeStep4Description;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @myWishlist.
  ///
  /// In en, this message translates to:
  /// **'My Wishlist'**
  String get myWishlist;

  /// No description provided for @addWishlistItem.
  ///
  /// In en, this message translates to:
  /// **'Add Wishlist Item'**
  String get addWishlistItem;

  /// No description provided for @editWishlistItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Wishlist Item'**
  String get editWishlistItem;

  /// No description provided for @wishlistItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get wishlistItemTitle;

  /// No description provided for @wishlistItemDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get wishlistItemDescription;

  /// No description provided for @wishlistItemKeywords.
  ///
  /// In en, this message translates to:
  /// **'Keywords (comma separated)'**
  String get wishlistItemKeywords;

  /// No description provided for @wishlistItemPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get wishlistItemPriceRange;

  /// No description provided for @wishlistItemMinPrice.
  ///
  /// In en, this message translates to:
  /// **'Min Price'**
  String get wishlistItemMinPrice;

  /// No description provided for @wishlistItemMaxPrice.
  ///
  /// In en, this message translates to:
  /// **'Max Price'**
  String get wishlistItemMaxPrice;

  /// No description provided for @wishlistItemLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get wishlistItemLocation;

  /// No description provided for @wishlistItemRadius.
  ///
  /// In en, this message translates to:
  /// **'Search Radius (km)'**
  String get wishlistItemRadius;

  /// No description provided for @wishlistItemNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get wishlistItemNotifications;

  /// No description provided for @noWishlistItems.
  ///
  /// In en, this message translates to:
  /// **'No wishlist items yet'**
  String get noWishlistItems;

  /// No description provided for @createYourFirstWishlistItem.
  ///
  /// In en, this message translates to:
  /// **'Create your first wishlist item to get notified when matches appear'**
  String get createYourFirstWishlistItem;

  /// No description provided for @deleteWishlistItem.
  ///
  /// In en, this message translates to:
  /// **'Delete Wishlist Item'**
  String get deleteWishlistItem;

  /// No description provided for @deleteWishlistItemConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this wishlist item?'**
  String get deleteWishlistItemConfirmation;

  /// No description provided for @wishlistItemDeleted.
  ///
  /// In en, this message translates to:
  /// **'Wishlist item deleted'**
  String get wishlistItemDeleted;

  /// No description provided for @errorDeletingWishlistItem.
  ///
  /// In en, this message translates to:
  /// **'Error deleting wishlist item'**
  String get errorDeletingWishlistItem;

  /// No description provided for @wishlistItemCreated.
  ///
  /// In en, this message translates to:
  /// **'Wishlist item created'**
  String get wishlistItemCreated;

  /// No description provided for @wishlistItemUpdated.
  ///
  /// In en, this message translates to:
  /// **'Wishlist item updated'**
  String get wishlistItemUpdated;

  /// No description provided for @errorCreatingWishlistItem.
  ///
  /// In en, this message translates to:
  /// **'Error creating wishlist item'**
  String get errorCreatingWishlistItem;

  /// No description provided for @errorUpdatingWishlistItem.
  ///
  /// In en, this message translates to:
  /// **'Error updating wishlist item'**
  String get errorUpdatingWishlistItem;

  /// No description provided for @errorLoadingWishlist.
  ///
  /// In en, this message translates to:
  /// **'Error loading wishlist'**
  String get errorLoadingWishlist;

  /// No description provided for @wishlistStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get wishlistStatusActive;

  /// No description provided for @wishlistStatusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get wishlistStatusPaused;

  /// No description provided for @wishlistStatusFulfilled.
  ///
  /// In en, this message translates to:
  /// **'Fulfilled'**
  String get wishlistStatusFulfilled;

  /// No description provided for @wishlistStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get wishlistStatusArchived;

  /// No description provided for @wishlistMatches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get wishlistMatches;

  /// No description provided for @noMatchesYet.
  ///
  /// In en, this message translates to:
  /// **'No matches yet'**
  String get noMatchesYet;

  /// No description provided for @matchScore.
  ///
  /// In en, this message translates to:
  /// **'Match Score'**
  String get matchScore;

  /// No description provided for @viewMatches.
  ///
  /// In en, this message translates to:
  /// **'View Matches'**
  String get viewMatches;

  /// No description provided for @pauseWishlist.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseWishlist;

  /// No description provided for @activateWishlist.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activateWishlist;

  /// No description provided for @markAsFulfilled.
  ///
  /// In en, this message translates to:
  /// **'Mark as Fulfilled'**
  String get markAsFulfilled;

  /// No description provided for @archiveWishlist.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveWishlist;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterTitle;

  /// No description provided for @atLeastOneKeyword.
  ///
  /// In en, this message translates to:
  /// **'Please enter at least one keyword'**
  String get atLeastOneKeyword;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPreferences;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @attributes.
  ///
  /// In en, this message translates to:
  /// **'Attributes'**
  String get attributes;

  /// No description provided for @noContactsFound.
  ///
  /// In en, this message translates to:
  /// **'No contacts found'**
  String get noContactsFound;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not Verified'**
  String get notVerified;

  /// No description provided for @updateEmail.
  ///
  /// In en, this message translates to:
  /// **'Update Email'**
  String get updateEmail;

  /// No description provided for @updatePhone.
  ///
  /// In en, this message translates to:
  /// **'Update Phone'**
  String get updatePhone;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @noPushTokens.
  ///
  /// In en, this message translates to:
  /// **'No push notification tokens registered'**
  String get noPushTokens;

  /// No description provided for @removePushToken.
  ///
  /// In en, this message translates to:
  /// **'Remove Push Token'**
  String get removePushToken;

  /// No description provided for @removePushTokenConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this push token?'**
  String get removePushTokenConfirmation;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @pushTokenRemoved.
  ///
  /// In en, this message translates to:
  /// **'Push token removed'**
  String get pushTokenRemoved;

  /// No description provided for @emailUpdated.
  ///
  /// In en, this message translates to:
  /// **'Email updated'**
  String get emailUpdated;

  /// No description provided for @phoneUpdated.
  ///
  /// In en, this message translates to:
  /// **'Phone updated'**
  String get phoneUpdated;

  /// No description provided for @noAttributePreferences.
  ///
  /// In en, this message translates to:
  /// **'No attribute preferences'**
  String get noAttributePreferences;

  /// No description provided for @attributePreferencesHint.
  ///
  /// In en, this message translates to:
  /// **'Set notification preferences for your interests and offerings'**
  String get attributePreferencesHint;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @minMatchScore.
  ///
  /// In en, this message translates to:
  /// **'Min. Match Score'**
  String get minMatchScore;

  /// No description provided for @newPostings.
  ///
  /// In en, this message translates to:
  /// **'New Postings'**
  String get newPostings;

  /// No description provided for @newUsers.
  ///
  /// In en, this message translates to:
  /// **'New Users'**
  String get newUsers;

  /// No description provided for @instant.
  ///
  /// In en, this message translates to:
  /// **'Instant'**
  String get instant;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @deletePreference.
  ///
  /// In en, this message translates to:
  /// **'Delete Preference'**
  String get deletePreference;

  /// No description provided for @deletePreferenceConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this preference?'**
  String get deletePreferenceConfirmation;

  /// No description provided for @preferenceDeleted.
  ///
  /// In en, this message translates to:
  /// **'Preference deleted'**
  String get preferenceDeleted;

  /// No description provided for @editPreference.
  ///
  /// In en, this message translates to:
  /// **'Edit Preference'**
  String get editPreference;

  /// No description provided for @notifyOnNewPostings.
  ///
  /// In en, this message translates to:
  /// **'Notify on new postings'**
  String get notifyOnNewPostings;

  /// No description provided for @notifyOnNewUsers.
  ///
  /// In en, this message translates to:
  /// **'Notify on new users'**
  String get notifyOnNewUsers;

  /// No description provided for @preferenceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Preference updated'**
  String get preferenceUpdated;

  /// No description provided for @unviewed.
  ///
  /// In en, this message translates to:
  /// **'Unviewed'**
  String get unviewed;

  /// No description provided for @unviewedOnly.
  ///
  /// In en, this message translates to:
  /// **'Unviewed Only'**
  String get unviewedOnly;

  /// No description provided for @noUnviewedMatches.
  ///
  /// In en, this message translates to:
  /// **'No unviewed matches'**
  String get noUnviewedMatches;

  /// No description provided for @newBadge.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get newBadge;

  /// No description provided for @markAsViewed.
  ///
  /// In en, this message translates to:
  /// **'Mark as Viewed'**
  String get markAsViewed;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @dismissed.
  ///
  /// In en, this message translates to:
  /// **'Dismissed'**
  String get dismissed;

  /// No description provided for @postingMatch.
  ///
  /// In en, this message translates to:
  /// **'Posting Match'**
  String get postingMatch;

  /// No description provided for @userMatch.
  ///
  /// In en, this message translates to:
  /// **'User Match'**
  String get userMatch;

  /// No description provided for @attributeMatch.
  ///
  /// In en, this message translates to:
  /// **'Attribute Match'**
  String get attributeMatch;

  /// No description provided for @match.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get match;

  /// No description provided for @dismissMatch.
  ///
  /// In en, this message translates to:
  /// **'Dismiss Match'**
  String get dismissMatch;

  /// No description provided for @dismissMatchConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to dismiss this match?'**
  String get dismissMatchConfirmation;

  /// No description provided for @matchDismissed.
  ///
  /// In en, this message translates to:
  /// **'Match dismissed'**
  String get matchDismissed;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matches;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @enableNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications for matches and updates'**
  String get enableNotificationsDescription;

  /// No description provided for @quietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet Hours'**
  String get quietHours;

  /// No description provided for @quietHoursDescription.
  ///
  /// In en, this message translates to:
  /// **'Do not send notifications during these hours'**
  String get quietHoursDescription;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @clearQuietHours.
  ///
  /// In en, this message translates to:
  /// **'Clear Quiet Hours'**
  String get clearQuietHours;

  /// No description provided for @noAttributesInProfile.
  ///
  /// In en, this message translates to:
  /// **'Add interests and skills to your profile first'**
  String get noAttributesInProfile;

  /// No description provided for @setupAttributeNotifications.
  ///
  /// In en, this message translates to:
  /// **'Set Up Notifications'**
  String get setupAttributeNotifications;

  /// No description provided for @setupAttributeNotificationsHint.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications for your interests and skills to receive alerts when matches are found'**
  String get setupAttributeNotificationsHint;

  /// No description provided for @defaultSettings.
  ///
  /// In en, this message translates to:
  /// **'Default Settings'**
  String get defaultSettings;

  /// No description provided for @selectAttributes.
  ///
  /// In en, this message translates to:
  /// **'Select Attributes'**
  String get selectAttributes;

  /// No description provided for @attributesSelected.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get attributesSelected;

  /// No description provided for @createPreferences.
  ///
  /// In en, this message translates to:
  /// **'Save Preferences'**
  String get createPreferences;

  /// No description provided for @preferencesCreated.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences saved'**
  String get preferencesCreated;

  /// No description provided for @offering.
  ///
  /// In en, this message translates to:
  /// **'Offering'**
  String get offering;

  /// No description provided for @interest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get interest;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @relevancy.
  ///
  /// In en, this message translates to:
  /// **'Relevancy'**
  String get relevancy;

  /// No description provided for @matchHistory.
  ///
  /// In en, this message translates to:
  /// **'Match History'**
  String get matchHistory;

  /// No description provided for @addAttributes.
  ///
  /// In en, this message translates to:
  /// **'Add Attributes'**
  String get addAttributes;

  /// No description provided for @allAttributesHavePreferences.
  ///
  /// In en, this message translates to:
  /// **'All attributes from your profile already have notification preferences'**
  String get allAttributesHavePreferences;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @setupEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Up Email'**
  String get setupEmailTitle;

  /// No description provided for @setupEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to receive notifications'**
  String get setupEmailDescription;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email address is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @saveEmail.
  ///
  /// In en, this message translates to:
  /// **'Save Email'**
  String get saveEmail;

  /// No description provided for @emailSaved.
  ///
  /// In en, this message translates to:
  /// **'Email address saved successfully'**
  String get emailSaved;

  /// No description provided for @deleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get deleteProfile;

  /// No description provided for @deleteProfileConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your profile? This action cannot be undone. All your data, postings, and conversations will be permanently removed.'**
  String get deleteProfileConfirmation;

  /// No description provided for @profileDeleted.
  ///
  /// In en, this message translates to:
  /// **'Profile deleted successfully'**
  String get profileDeleted;

  /// No description provided for @errorDeletingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error deleting profile'**
  String get errorDeletingProfile;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
