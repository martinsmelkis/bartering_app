// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bartering App';

  @override
  String get category_green =>
      'Nature, outdoors, gardening, animals, environment, hiking, plants, sustainability';

  @override
  String get category_red =>
      'Sports, exercise, hands-on, active lifestyle, physical work, mechanisms, tools';

  @override
  String get category_blue =>
      'Business, entrepreneurship, paid work, making contacts, money matters, finance, career';

  @override
  String get category_purple =>
      'Art, spirituality, philosophy, culture, music, crafts, creativity, design, history';

  @override
  String get category_yellow =>
      'Chat, social activities, casual conversation, local events, new contacts, communication';

  @override
  String get category_orange =>
      'Volunteering, support, free items/skills exchange, consulting, assistance, community';

  @override
  String get category_teal =>
      'Technology, learning, education, innovation, brainstorming, ideas, science, software';

  @override
  String get tapToChat => 'Tap to chat';

  @override
  String get locations => 'Locations';

  @override
  String get tapToExpandMainCluster => 'Tap to expand main cluster';

  @override
  String get closeLocations => 'Close Locations';

  @override
  String get tapToExpandSubCluster => 'Tap to expand sub-cluster';

  @override
  String get pointsOfInterest => 'Points of Interest';

  @override
  String get chat => 'Chat';

  @override
  String get typeAMessage => 'Type a message...';

  @override
  String errorWithMessage(Object errorMessage) {
    return 'Error: $errorMessage';
  }

  @override
  String get loading => 'Loading...';

  @override
  String get errorDuringInitialization => 'Error during initialization.';

  @override
  String get selectYourInterests => 'What is of interest to you?';

  @override
  String get selectYourOffers => 'What do you have to offer?';

  @override
  String get userInterestedIn => 'Interested in:';

  @override
  String get userOffers => 'Offering:';

  @override
  String get save => 'Save';

  @override
  String get username => 'User name';

  @override
  String get userId => 'User ID';

  @override
  String get onboardingScreenTitle => 'Onboarding';

  @override
  String get onboardingScreenQuestion => 'How much are you interested in this?';

  @override
  String get finishOnboarding => 'Finish';

  @override
  String questionsAnswered(Object count) {
    return '$count questions answered';
  }

  @override
  String get locationSaved => 'Location saved!';

  @override
  String get pleaseSelectLocationFirst => 'Please select a location first.';

  @override
  String get locationNotFound => 'Location not found.';

  @override
  String errorFindingLocation(Object error) {
    return 'Error finding location: $error';
  }

  @override
  String get selectLocation => 'Select Location';

  @override
  String get pickYourLocation => 'Pick your location';

  @override
  String get searchForALocation => 'Search for a location';

  @override
  String get searchForAKeyword => 'Search for a keyword';

  @override
  String get saveLocation => 'Save Location';

  @override
  String get chatError_Offline => 'User Offline';

  @override
  String mockPoiNotFound(Object id) {
    return 'Mock POI with id $id not found in service';
  }

  @override
  String mockPoiNotFoundForUpdate(Object id) {
    return 'Mock POI with id $id not found for update';
  }

  @override
  String get submitting => 'Submitting...';

  @override
  String get error => 'Error';

  @override
  String get anUnknownErrorOccurred => 'An unknown error occurred.';

  @override
  String get submittingOffers => 'Submitting offers...';

  @override
  String get drawer_menu_similar_users => 'Find similar users';

  @override
  String get drawer_menu_complementary_users => 'Find complementary users';

  @override
  String get drawer_menu_favorite_users => 'Find favorite users';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get settingsSaved => 'Settings saved successfully';

  @override
  String get settingsSearchSection => 'Search Settings';

  @override
  String get settingsSearchCenterPointTitle => 'Center Point of Search';

  @override
  String get settingsSearchCenterPointDescription =>
      'Choose the center point for nearby user searches';

  @override
  String get settingsSearchCenterUserLocation => 'User Location';

  @override
  String get settingsSearchCenterUserLocationDescription =>
      'Search from your saved location';

  @override
  String get settingsSearchCenterMapCenter => 'Map Center';

  @override
  String get settingsSearchCenterMapCenterDescription =>
      'Search from the current map center';

  @override
  String get settingsNearbyUsersRadiusTitle => 'Nearby Users Search Radius';

  @override
  String get settingsNearbyUsersRadiusDescription =>
      'How far to search for nearby users';

  @override
  String get settingsKeywordSearchRadiusTitle => 'Keyword Search Radius';

  @override
  String get settingsKeywordSearchRadiusDescription =>
      'Search radius when using keyword search';

  @override
  String get settingsKeywordSearchWeightTitle => 'Keyword Search Weight';

  @override
  String get settingsKeywordSearchWeightDescription =>
      'Weight parameter for keyword search relevance (10-100)';

  @override
  String get settingsShowResultsAsListTitle => 'Display Search Results As List';

  @override
  String get settingsShowResultsAsListDescription =>
      'Show keyword and nearby search results in a list view instead of on the map';

  @override
  String get settingsShowResultsOnMapDescription =>
      'Show search results on the map (default)';

  @override
  String get settingsShowResultsAsListViewDescription =>
      'Show search results in a list view';

  @override
  String get setPinTitle => 'Set Up PIN';

  @override
  String get setPinDescription => 'Create a 4-6 digit PIN to secure your app';

  @override
  String get setPinButton => 'Set PIN';

  @override
  String get skipPinButton => 'Skip for now';

  @override
  String get pinLabel => 'PIN';

  @override
  String get pinHint => 'Enter 4-6 digits';

  @override
  String get confirmPinLabel => 'Confirm PIN';

  @override
  String get pinErrorEmpty => 'Please enter a PIN';

  @override
  String get pinErrorTooShort => 'PIN must be at least 4 digits';

  @override
  String get pinErrorMismatch => 'PINs do not match';

  @override
  String get pinSetSuccessfully => 'PIN set successfully';

  @override
  String get enterPinTitle => 'Enter PIN';

  @override
  String get enterPinDescription => 'Enter your PIN to unlock the app';

  @override
  String get unlockButton => 'Unlock';

  @override
  String pinErrorIncorrect(int attempts) {
    return 'Incorrect PIN (Attempt $attempts)';
  }

  @override
  String get settingsSecuritySection => 'Security';

  @override
  String get settingsPinTitle => 'PIN Protection';

  @override
  String get settingsPinEnabledDescription => 'App is protected with PIN';

  @override
  String get settingsPinDisabledDescription => 'Enable PIN for extra security';

  @override
  String get settingsChangePinButton => 'Change PIN';

  @override
  String get settingsChangePinDescription => 'Update your security PIN';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsLanguageTitle => 'App Language';

  @override
  String get settingsLanguageDescription =>
      'Choose your preferred language for the app';

  @override
  String get settingsLanguageRestartMessage =>
      'Please restart the app to apply language changes';

  @override
  String get setupSecurityQuestion => 'Setup Security Question';

  @override
  String get securityQuestionDescription =>
      'Set up a security question to help recover your PIN if you forget it';

  @override
  String get selectSecurityQuestion => 'Select a question';

  @override
  String get yourAnswer => 'Your Answer';

  @override
  String get answerHint => 'Enter your answer';

  @override
  String get pleaseSelectQuestion => 'Please select a security question';

  @override
  String get pleaseEnterAnswer => 'Please enter your answer';

  @override
  String get answerTooShort => 'Answer must be at least 2 characters';

  @override
  String get securityAnswerNote => 'Note: Answers are case-insensitive';

  @override
  String get saveSecurityQuestion => 'Save Security Question';

  @override
  String get securityQuestionSaved => 'Security question saved successfully';

  @override
  String get securityQuestion1 => 'What was the name of your first pet?';

  @override
  String get securityQuestion2 => 'What city were you born in?';

  @override
  String get securityQuestion3 => 'What is your mother\'s maiden name?';

  @override
  String get securityQuestion4 =>
      'What was the name of your elementary school?';

  @override
  String get securityQuestion5 => 'What is your favorite book?';

  @override
  String get answerSecurityQuestion => 'Answer Security Question';

  @override
  String get enterYourAnswer => 'Enter your answer';

  @override
  String get verifyAndResetPin => 'Verify and Reset PIN';

  @override
  String securityAnswerIncorrect(int attempts) {
    return 'Incorrect answer (Attempt $attempts)';
  }

  @override
  String get pinResetSuccessfully => 'PIN reset successfully';

  @override
  String get noSecurityQuestionSet => 'No security question set up';

  @override
  String get contactSupportForPinReset =>
      'Please contact support for PIN reset assistance';

  @override
  String get manageSecurityQuestion => 'Manage Security Question';

  @override
  String get securityQuestionSet => 'Security question is set up';

  @override
  String get noSecurityQuestion => 'No security question configured';

  @override
  String get setupSecurityQuestionButton => 'Setup Security Question';

  @override
  String get changeSecurityQuestion => 'Change Security Question';

  @override
  String get managePostings => 'Manage Postings';

  @override
  String get noActivePostings => 'No active postings';

  @override
  String get deletePosting => 'Delete Posting';

  @override
  String get deletePostingConfirmation =>
      'Are you sure you want to delete this posting?';

  @override
  String get postingDeleted => 'Posting deleted successfully';

  @override
  String get offer => 'Offer';

  @override
  String get need => 'Need';

  @override
  String get expires => 'Expires';

  @override
  String get editPosting => 'Edit Posting';

  @override
  String get postingUpdatedSuccess => 'Posting updated successfully';

  @override
  String get updatePosting => 'Update Posting';

  @override
  String get continueButton => 'Continue';

  @override
  String get categoryNatureTitle => 'Nature & Outdoors';

  @override
  String get categoryNatureDescription =>
      'Gardening, outdoors, forests, camping, environmentalism, cleanup, animals';

  @override
  String get categoryActiveTitle => 'Active & Social';

  @override
  String get categoryActiveDescription =>
      'Sports, partying, dancing, active lifestyle, physical work, mechanisms';

  @override
  String get categoryBusinessTitle => 'Business & Finance';

  @override
  String get categoryBusinessDescription =>
      'Strictly business, paid work, networking, money matters, networking';

  @override
  String get categoryArtsTitle => 'Arts & Philosophy';

  @override
  String get categoryArtsDescription => 'Art, spirituality, philosophy';

  @override
  String get categoryCommTitle => 'Communication & Chat';

  @override
  String get categoryCommDescription => 'Misc/Communication, Chat';

  @override
  String get categoryCommunityTitle => 'Community & Volunteering';

  @override
  String get categoryCommunityDescription =>
      'Open to help out for free/non-specific exchange';

  @override
  String get categoryTechTitle => 'Technology & Learning';

  @override
  String get categoryTechDescription => 'Technology, learning, innovation';

  @override
  String get addYourOwnKeywords => 'Add your own keywords';

  @override
  String get enterYourPin => 'Enter Your PIN';

  @override
  String get pinSetupDescription => 'Please set up a 5-digit PIN for security';

  @override
  String get forgotPin => 'Forgot PIN?';

  @override
  String get pinResetSuccess => 'Your PIN has been successfully reset.';

  @override
  String get resetYourPin => 'Reset Your PIN';

  @override
  String get enterNewPinDescription => 'Enter a new 5-digit PIN';

  @override
  String get googleSignInNotImplemented => 'Google Sign-In not implemented.';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email.';

  @override
  String get pleaseEnter5DigitPin => 'Please enter a 5-digit PIN.';

  @override
  String get accountSetupSuccess => 'Your account has been set up!';

  @override
  String get setUpAccount => 'Set Up Account';

  @override
  String get or => 'OR';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get create5DigitPin => 'Create a 5-digit PIN';

  @override
  String get completeSetup => 'Complete Setup';

  @override
  String get resetLinkSentMessage =>
      'If an account exists, a reset link has been sent.';

  @override
  String get forgotPinSubtitle =>
      'Enter your email address to receive a PIN reset link.';

  @override
  String get pleaseEnterValidEmailAddress =>
      'Please enter a valid email address';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get generateAvatar => 'Generate Avatar';

  @override
  String get skin => 'Skin';

  @override
  String get hairStyle => 'Hair Style';

  @override
  String get hairColor => 'Hair Color';

  @override
  String get eyes => 'Eyes';

  @override
  String get nose => 'Nose';

  @override
  String get mouth => 'Mouth';

  @override
  String styleNumber(Object number) {
    return 'Style $number';
  }

  @override
  String get randomize => 'Randomize';

  @override
  String get saveAndContinue => 'Save & Continue';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get generateCryptoWallet => 'Generate Crypto Wallet';

  @override
  String get generateWallet => 'Generate Wallet';

  @override
  String get publicKey => 'Public Key';

  @override
  String get privateKey => 'Private Key';

  @override
  String get done => 'Done';

  @override
  String get attr_3d_printing => '3D printing';

  @override
  String get attr_artificial_intelligence => 'Artificial Intelligence';

  @override
  String get attr_acting => 'Acting';

  @override
  String get attr_amateur_radio => 'Amateur radio';

  @override
  String get attr_animation => 'Animation';

  @override
  String get attr_baking => 'Baking';

  @override
  String get attr_beekeeping => 'Beekeeping';

  @override
  String get attr_blogging => 'Blogging';

  @override
  String get attr_board_games => 'Board games';

  @override
  String get attr_books => 'Books';

  @override
  String get attr_bowling => 'Bowling';

  @override
  String get attr_breadmaking => 'Breadmaking';

  @override
  String get attr_construction => 'Construction';

  @override
  String get attr_candle_making => 'Candle making';

  @override
  String get attr_car_maintenance => 'Car maintenance';

  @override
  String get attr_card_games => 'Card games';

  @override
  String get attr_ceramics => 'Ceramics';

  @override
  String get attr_charity_work => 'Charity work';

  @override
  String get attr_chess => 'Chess';

  @override
  String get attr_cleaning => 'Cleaning';

  @override
  String get attr_clothesmaking => 'Clothesmaking';

  @override
  String get attr_coffee => 'Coffee';

  @override
  String get attr_software_development => 'Software development';

  @override
  String get attr_cooking => 'Cooking';

  @override
  String get attr_couponing => 'Couponing';

  @override
  String get attr_creative_writing => 'Creative writing';

  @override
  String get attr_crocheting => 'Crocheting';

  @override
  String get attr_cross_stitch => 'Cross-stitch';

  @override
  String get attr_dance => 'Dance';

  @override
  String get attr_digital_arts => 'Digital arts';

  @override
  String get attr_djing => 'DJing';

  @override
  String get attr_diy => 'DIY';

  @override
  String get attr_drawing => 'Drawing';

  @override
  String get attr_electronics => 'Electronics';

  @override
  String get attr_embroidery => 'Embroidery';

  @override
  String get attr_engraving => 'Engraving';

  @override
  String get attr_event_hosting => 'Event hosting';

  @override
  String get attr_fashion => 'Fashion';

  @override
  String get attr_fashion_design => 'Fashion design';

  @override
  String get attr_flower_arranging => 'Flower arranging';

  @override
  String get attr_furniture_building => 'Furniture building';

  @override
  String get attr_gaming => 'Gaming';

  @override
  String get attr_genealogy => 'Genealogy';

  @override
  String get attr_graphic_design => 'Graphic design';

  @override
  String get attr_hacking => 'Hacking';

  @override
  String get attr_herp_keeping => 'Herp keeping';

  @override
  String get attr_home_improvement => 'Home improvement';

  @override
  String get attr_homebrewing => 'Homebrewing';

  @override
  String get attr_houseplant_care => 'Houseplant care';

  @override
  String get attr_hydroponics => 'Hydroponics';

  @override
  String get attr_jewelry => 'Jewelry';

  @override
  String get attr_knitting => 'Knitting';

  @override
  String get attr_kombucha => 'Kombucha';

  @override
  String get attr_leather_crafting => 'Leather crafting';

  @override
  String get attr_podcasts => 'Podcasts';

  @override
  String get attr_machining => 'Machining';

  @override
  String get attr_magic => 'Magic';

  @override
  String get attr_makeup => 'Makeup';

  @override
  String get attr_massage => 'Massage';

  @override
  String get attr_metalworking => 'Metalworking';

  @override
  String get attr_nail_art => 'Nail art';

  @override
  String get attr_painting => 'Painting';

  @override
  String get attr_photography => 'Photography';

  @override
  String get attr_pottery => 'Pottery';

  @override
  String get attr_powerlifting => 'Powerlifting';

  @override
  String get attr_puzzles => 'Puzzles';

  @override
  String get attr_quilting => 'Quilting';

  @override
  String get attr_gadgets => 'Gadgets';

  @override
  String get attr_robotics => 'Robotics';

  @override
  String get attr_sculpting => 'Sculpting';

  @override
  String get attr_sewing => 'Sewing';

  @override
  String get attr_shoemaking => 'Shoemaking';

  @override
  String get attr_singing => 'Singing';

  @override
  String get attr_skateboarding => 'Skateboarding';

  @override
  String get attr_sketching => 'Sketching';

  @override
  String get attr_soapmaking => 'Soapmaking';

  @override
  String get attr_social_media => 'Social media';

  @override
  String get attr_stand_up_comedy => 'Stand-up comedy';

  @override
  String get attr_storytelling => 'Storytelling';

  @override
  String get attr_sudoku => 'Sudoku';

  @override
  String get attr_table_tennis => 'Table tennis';

  @override
  String get attr_thrifting => 'Thrifting';

  @override
  String get attr_video_editing => 'Video editing';

  @override
  String get attr_video_game_developing => 'Video game developing';

  @override
  String get attr_weaving => 'Weaving';

  @override
  String get attr_weight_training => 'Weight training';

  @override
  String get attr_welding => 'Welding';

  @override
  String get attr_wood_carving => 'Wood carving';

  @override
  String get attr_woodworking => 'Woodworking';

  @override
  String get attr_writing => 'Writing';

  @override
  String get attr_yoga => 'Yoga';

  @override
  String get attr_zumba => 'Zumba';

  @override
  String get attr_hiking => 'Hiking';

  @override
  String get attr_reading => 'Reading';

  @override
  String get attr_gardening => 'Gardening';

  @override
  String get attr_music => 'Music';

  @override
  String get attr_dancing => 'Dancing';

  @override
  String get attr_aerobics => 'Aerobics';

  @override
  String get attr_traveling => 'Traveling';

  @override
  String get attr_coding => 'Coding';

  @override
  String get attr_sports => 'Sports';

  @override
  String get attr_movies => 'Movies';

  @override
  String get attr_volunteering => 'Volunteering';

  @override
  String get attr_meditation => 'Meditation';

  @override
  String get attr_crafting => 'Crafting';

  @override
  String get attr_astronomy => 'Astronomy';

  @override
  String get attr_backpacking => 'Backpacking';

  @override
  String get attr_bird_watching => 'Bird watching';

  @override
  String get attr_camping => 'Camping';

  @override
  String get attr_canyoning => 'Canyoning';

  @override
  String get attr_car_restoration => 'Car restoration';

  @override
  String get attr_climbing => 'Climbing';

  @override
  String get attr_cryptocurrency => 'Cryptocurrency';

  @override
  String get attr_culinary_arts => 'Culinary arts';

  @override
  String get attr_cycling => 'Cycling';

  @override
  String get attr_drones => 'Drones';

  @override
  String get attr_fermentation => 'Fermentation';

  @override
  String get attr_film_making => 'Film making';

  @override
  String get attr_financial_investing => 'Financial investing';

  @override
  String get attr_fishing => 'Fishing';

  @override
  String get attr_foraging => 'Foraging';

  @override
  String get attr_geocaching => 'Geocaching';

  @override
  String get attr_kayaking => 'Kayaking';

  @override
  String get attr_martial_arts => 'Martial arts';

  @override
  String get attr_mindfulness => 'Mindfulness';

  @override
  String get attr_mushroom_hunting => 'Mushroom hunting';

  @override
  String get attr_personal_finance => 'Personal finance';

  @override
  String get attr_rock_climbing => 'Rock climbing';

  @override
  String get attr_running => 'Running';

  @override
  String get attr_sustainable_living => 'Sustainable living';

  @override
  String get attr_urban_exploration => 'Urban exploration';

  @override
  String get attr_alternative_medicine => 'Alternative medicine';

  @override
  String get attr_biohacking => 'Biohacking';

  @override
  String get attr_cold_plunging => 'Cold plunging';

  @override
  String get attr_community_gardening => 'Community gardening';

  @override
  String get attr_cybersecurity => 'Cybersecurity';

  @override
  String get attr_day_trading => 'Day trading';

  @override
  String get attr_deep_cleaning => 'Deep cleaning';

  @override
  String get attr_digital_nomadism => 'Digital nomadism';

  @override
  String get attr_recipes => 'Recipes';

  @override
  String get attr_bodybuilding => 'Bodybuilding';

  @override
  String get attr_memes => 'Memes';

  @override
  String get attr_metal_detecting => 'Metal detecting';

  @override
  String get attr_minimalism => 'Minimalism';

  @override
  String get attr_pet_grooming => 'Pet grooming';

  @override
  String get attr_podcasting => 'Podcasting';

  @override
  String get attr_record_collecting => 'Record collecting';

  @override
  String get attr_tiny_homes => 'Tiny homes';

  @override
  String get attr_upcycling => 'Upcycling';

  @override
  String get attr_virtual_reality => 'Virtual reality';

  @override
  String get attr_pc_building => 'PC building';

  @override
  String get attr_babysitting => 'Babysitting';

  @override
  String get attr_backgammon => 'Backgammon';

  @override
  String get attr_bicycles => 'Bicycles';

  @override
  String get attr_billiards => 'Billiards';

  @override
  String get attr_canned_goods => 'Canned goods';

  @override
  String get attr_car_detailing => 'Car detailing';

  @override
  String get attr_carpentry => 'Carpentry';

  @override
  String get attr_code_review => 'Code review';

  @override
  String get attr_comic_books => 'Comic books';

  @override
  String get attr_computer_hardware => 'Computer hardware';

  @override
  String get attr_computer_repair => 'Computer repair';

  @override
  String get attr_concert_tickets => 'Concert tickets';

  @override
  String get attr_co_op_gaming => 'Co-op gaming';

  @override
  String get attr_creative_brainstorming => 'Creative brainstorming';

  @override
  String get attr_dance_lessons => 'Dance lessons';

  @override
  String get attr_dog_walking => 'Dog walking';

  @override
  String get attr_elderly_care => 'Elderly care';

  @override
  String get attr_electronic_components => 'Electronic components';

  @override
  String get attr_exercise_partner => 'Exercise partner';

  @override
  String get attr_firewood => 'Firewood';

  @override
  String get attr_fitness_coaching => 'Fitness coaching';

  @override
  String get attr_fresh_eggs => 'Fresh eggs';

  @override
  String get attr_furniture_repair => 'Furniture repair';

  @override
  String get attr_gardening_advice => 'Gardening advice';

  @override
  String get attr_graphic_novels => 'Graphic novels';

  @override
  String get attr_guitar => 'Guitar';

  @override
  String get attr_handmade => 'Handmade';

  @override
  String get attr_handyman_services => 'Handyman services';

  @override
  String get attr_hauling_services => 'Hauling services';

  @override
  String get attr_herbal_remedies => 'Herbal remedies';

  @override
  String get attr_horseback_riding => 'Horseback riding';

  @override
  String get attr_interview_practice => 'Interview practice';

  @override
  String get attr_language_exchange => 'Language exchange';

  @override
  String get attr_lawn_mowing => 'Lawn mowing';

  @override
  String get attr_local_tours => 'Local tours';

  @override
  String get attr_math_tutoring => 'Math tutoring';

  @override
  String get attr_mentorship => 'Mentorship';

  @override
  String get attr_motorcycles => 'Motorcycles';

  @override
  String get attr_moving_help => 'Moving help';

  @override
  String get attr_musical_instruments => 'Musical instruments';

  @override
  String get attr_pair_programming => 'Pair programming';

  @override
  String get attr_pet_sitting => 'Pet sitting';

  @override
  String get attr_photo_restoration => 'Photo restoration';

  @override
  String get attr_piano_lessons => 'Piano lessons';

  @override
  String get attr_plant_cuttings => 'Plant cuttings';

  @override
  String get attr_proofreading => 'Proofreading';

  @override
  String get attr_resume_writing => 'Resume writing';

  @override
  String get attr_rpg_games => 'RPG games';

  @override
  String get attr_scrap_metal => 'Scrap metal';

  @override
  String get attr_event_tickets => 'Event tickets';

  @override
  String get attr_sports_coaching => 'Sports coaching';

  @override
  String get attr_study_partner => 'Study partner';

  @override
  String get attr_technical_writing => 'Technical writing';

  @override
  String get attr_tennis => 'Tennis';

  @override
  String get attr_tool_lending => 'Tool lending';

  @override
  String get attr_translation_services => 'Translation services';

  @override
  String get attr_used_books => 'Used books';

  @override
  String get attr_used_electronics => 'Used electronics';

  @override
  String get attr_used_furniture => 'Used furniture';

  @override
  String get attr_vehicle_repair => 'Vehicle repair';

  @override
  String get attr_video_game_consoles => 'Video game consoles';

  @override
  String get attr_vintage_clothing => 'Vintage clothing';

  @override
  String get attr_voice_lessons => 'Voice lessons';

  @override
  String get attr_ux_design => 'UX design';

  @override
  String get attr_window_cleaning => 'Window cleaning';

  @override
  String get attr_yard_work => 'Yard work';

  @override
  String get attr_drumming => 'Drumming';

  @override
  String get attr_vocals => 'Vocals';

  @override
  String get attr_permaculture => 'Permaculture';

  @override
  String get attr_physical_work => 'Physical work';

  @override
  String get attr_business_mentorship => 'Business Mentorship';

  @override
  String get attr_spirituality => 'Spirituality';

  @override
  String get attr_natural_remedies => 'Natural remedies';

  @override
  String get attr_retreats => 'Retreats';

  @override
  String get attr_zen => 'Zen';

  @override
  String get attr_linux => 'Linux';

  @override
  String get attr_app_development => 'App development';

  @override
  String get attr_android => 'Android';

  @override
  String get attr_ios => 'iOS';

  @override
  String get attr_backend_development => 'Backend development';

  @override
  String get attr_plumbing => 'Plumbing';

  @override
  String get attr_art_exhibitions => 'Art Exhibitions';

  @override
  String get attr_environmentalism => 'Environmentalism';

  @override
  String get attr_fresh_vegetables => 'Fresh vegetables';

  @override
  String get attr_fresh_fruits => 'Fresh fruits';

  @override
  String get attr_fresh_herbs => 'Fresh herbs';

  @override
  String get attr_tea => 'Tea';

  @override
  String get attr_legal_advice => 'Legal advice';

  @override
  String get attr_cats => 'Cats';

  @override
  String get attr_dogs => 'Dogs';

  @override
  String get attr_poker => 'Poker';

  @override
  String get attr_trees => 'Trees';

  @override
  String get attr_plants => 'Plants';

  @override
  String get attr_farm_animals => 'Farm animals';

  @override
  String get attr_organic_food => 'Organic food';

  @override
  String get attr_technician => 'Technician';

  @override
  String get attr_tractor => 'Tractor';

  @override
  String get attr_driving => 'Driving';

  @override
  String get attr_machinery_operation => 'Machinery operation';

  @override
  String get attr_truck_driving => 'Truck driving';

  @override
  String get attr_assembly => 'Assembly';

  @override
  String get attr_animal_care => 'Animal care';

  @override
  String get attr_horses => 'Horses';

  @override
  String get attr_goats => 'Goats';

  @override
  String get attr_cows => 'Cows';

  @override
  String get attr_self_sufficiency => 'Self-sufficiency';

  @override
  String get attr_ridesharing => 'Ridesharing';

  @override
  String get attr_fruit_harvesting => 'Fruit harvesting';

  @override
  String get attr_vegetable_harvesting => 'Vegetable harvesting';

  @override
  String get attr_car_cleaning => 'Car cleaning';

  @override
  String get attr_farmstay => 'Farmstay';

  @override
  String get attr_house_maintenance => 'House maintenance';

  @override
  String get attr_shepherding => 'Shepherding';

  @override
  String get attr_renovation => 'Renovation';

  @override
  String get attr_landscaping => 'Landscaping';

  @override
  String get attr_forestry => 'Forestry';

  @override
  String get attr_academic_tutoring => 'Academic tutoring';

  @override
  String get attr_building_materials => 'Building materials';

  @override
  String get attr_spare_parts => 'Spare parts';

  @override
  String get attr_alternative_healing => 'Alternative healing';

  @override
  String get attr_socializing => 'Socializing';

  @override
  String get userLocation => 'Location:';

  @override
  String get editLocation => 'Edit Location';

  @override
  String get editKeywords => 'Edit Your Overall Interests';

  @override
  String get createOfferPosting => 'Create Offer Posting';

  @override
  String get createInterestPosting => 'Create Interest Posting';

  @override
  String get postingTitle => 'Title';

  @override
  String get postingTitleHint => 'Brief title for your posting';

  @override
  String get postingTitleRequired => 'Title is required';

  @override
  String get postingTitleTooShort => 'Title must be at least 3 characters';

  @override
  String get postingDescription => 'Description';

  @override
  String get postingDescriptionHint =>
      'Detailed description of what you\'re offering or looking for';

  @override
  String get postingDescriptionRequired => 'Description is required';

  @override
  String get postingDescriptionTooShort =>
      'Description must be at least 10 characters';

  @override
  String get postingValue => 'Value (Optional)';

  @override
  String get postingValueHint => 'Estimated value';

  @override
  String get postingValueInvalid => 'Please enter a valid positive number';

  @override
  String get optionalField => 'Optional';

  @override
  String get expirationDate => 'Expiration Date';

  @override
  String get tapToSelectDate => 'Tap to select expiration date (optional)';

  @override
  String get postingImages => 'Images';

  @override
  String get postingImagesHint => 'Add up to 3 images (optional)';

  @override
  String get addImage => 'Add Image';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Device';

  @override
  String get maxImagesReached => 'Maximum 3 images allowed';

  @override
  String get createPosting => 'Create Posting';

  @override
  String get postingCreatedSuccess => 'Posting created successfully!';

  @override
  String get addNewPosting => 'Add Posting';

  @override
  String get deleteConversation => 'Delete Conversation';

  @override
  String get deleteConversationConfirmation =>
      'Are you sure you want to delete this conversation? All messages will be permanently removed.';

  @override
  String get conversationDeleted => 'Conversation deleted';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get errorLoadingChats => 'Error loading chats';

  @override
  String get couldNotFindChatParticipant => 'Could not find chat participant';

  @override
  String get errorDeletingConversation => 'Error deleting conversation';

  @override
  String get unknownUser => 'Unknown User';

  @override
  String get noMessagesYet => 'No messages yet';

  @override
  String get ninetyNinePlus => '99+';

  @override
  String get userDetails => 'User Details';

  @override
  String matchingUsersFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'users',
      one: 'user',
    );
    return '$count matching $_temp0 found';
  }

  @override
  String matchingPostingsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'postings',
      one: 'posting',
    );
    return '$count matching $_temp0 found';
  }

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get notSet => 'Not set';

  @override
  String get errorUpdatingFavorite => 'Error updating favorite';

  @override
  String get noAttributesToDisplay => 'No attributes to display.';

  @override
  String get errorLoadingPostings => 'Error loading postings';

  @override
  String get errorLoadingAttributes => 'Error loading attributes';

  @override
  String get userPrefix => 'User';

  @override
  String get activePostings => 'Active Postings';

  @override
  String get posting => 'Posting';

  @override
  String get postings => 'Postings';

  @override
  String get offers => 'Offers';

  @override
  String get lookingFor => 'Looking For';

  @override
  String get valuePrefix => 'Value';

  @override
  String get expiresPrefix => 'Expires';

  @override
  String get postedPrefix => 'Posted';

  @override
  String get noChatsYet => 'No chats yet';

  @override
  String get startConversationFromMap => 'Start a conversation from the map';

  @override
  String get welcomeTagline => 'Connect. Trade. Build Community.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get howItWorks => 'How It Works';

  @override
  String get welcomeStep1Title => 'Create your Profile';

  @override
  String get welcomeStep1Description =>
      'Create an anonymous profile with your interests and what you have to offer';

  @override
  String get welcomeStep2Title => 'Discover, Search, Post';

  @override
  String get welcomeStep2Description =>
      'Search by keywords, similarity or trade match, get match notifications';

  @override
  String get welcomeStep3Title => 'Start Chatting';

  @override
  String get welcomeStep3Description =>
      'Connect with others through End-to-end encrypted chat';

  @override
  String get welcomeStep4Title => 'Make Exchanges';

  @override
  String get welcomeStep4Description =>
      'Trade knowledge, services, items, or simply connect with your community';

  @override
  String get gdprConsentTitle => 'Privacy & Data Consent';

  @override
  String get gdprConsentIntro =>
      'Before you continue, please review and choose how your data is processed.';

  @override
  String get gdprConsentRequiredLabel => 'Required: Core service processing';

  @override
  String get gdprConsentRequiredDescription =>
      'Needed to create your account, match with users, and run secure messaging. This cannot be turned off if you want to use the app.';

  @override
  String get gdprConsentLocationLabel => 'Optional: Location processing';

  @override
  String get gdprConsentLocationDescription =>
      'Use your location to discover users nearby and improve match relevance.';

  @override
  String get gdprConsentAiLabel => 'Optional: AI-assisted matching';

  @override
  String get gdprConsentAiDescription =>
      'Analyze profile and interaction signals to improve recommendations and relevance.';

  @override
  String get gdprCookiesSectionTitle => 'Cookies (Web)';

  @override
  String get gdprCookiesRequiredLabel => 'Required cookies';

  @override
  String get gdprCookiesRequiredDescription =>
      'Needed for core web functionality such as security, session handling, and storing your essential settings.';

  @override
  String get gdprCookiesAnalyticsLabel => 'Optional analytics cookies';

  @override
  String get gdprCookiesAnalyticsDescription =>
      'Help us understand usage and improve performance. These are only used if you allow them.';

  @override
  String get gdprConsentManageLater =>
      'You can change these choices later in Settings.';

  @override
  String get gdprConsentDecline => 'Not now';

  @override
  String get gdprConsentAccept => 'Continue';

  @override
  String get wishlist => 'Wishlist';

  @override
  String get myWishlist => 'My Wishlist';

  @override
  String get addWishlistItem => 'Add Wishlist Item';

  @override
  String get editWishlistItem => 'Edit Wishlist Item';

  @override
  String get wishlistItemTitle => 'Title';

  @override
  String get wishlistItemDescription => 'Description';

  @override
  String get wishlistItemKeywords => 'Keywords (comma separated)';

  @override
  String get wishlistItemPriceRange => 'Price Range';

  @override
  String get wishlistItemMinPrice => 'Min Price';

  @override
  String get wishlistItemMaxPrice => 'Max Price';

  @override
  String get wishlistItemLocation => 'Location';

  @override
  String get wishlistItemRadius => 'Search Radius (km)';

  @override
  String get wishlistItemNotifications => 'Enable Notifications';

  @override
  String get noWishlistItems => 'No wishlist items yet';

  @override
  String get createYourFirstWishlistItem =>
      'Create your first wishlist item to get notified when matches appear';

  @override
  String get deleteWishlistItem => 'Delete Wishlist Item';

  @override
  String get deleteWishlistItemConfirmation =>
      'Are you sure you want to delete this wishlist item?';

  @override
  String get wishlistItemDeleted => 'Wishlist item deleted';

  @override
  String get errorDeletingWishlistItem => 'Error deleting wishlist item';

  @override
  String get wishlistItemCreated => 'Wishlist item created';

  @override
  String get wishlistItemUpdated => 'Wishlist item updated';

  @override
  String get errorCreatingWishlistItem => 'Error creating wishlist item';

  @override
  String get errorUpdatingWishlistItem => 'Error updating wishlist item';

  @override
  String get errorLoadingWishlist => 'Error loading wishlist';

  @override
  String get wishlistStatusActive => 'Active';

  @override
  String get wishlistStatusPaused => 'Paused';

  @override
  String get wishlistStatusFulfilled => 'Fulfilled';

  @override
  String get wishlistStatusArchived => 'Archived';

  @override
  String get wishlistMatches => 'Matches';

  @override
  String get noMatchesYet => 'No matches yet';

  @override
  String get matchScore => 'Match Score';

  @override
  String get viewMatches => 'View Matches';

  @override
  String get pauseWishlist => 'Pause';

  @override
  String get activateWishlist => 'Activate';

  @override
  String get markAsFulfilled => 'Mark as Fulfilled';

  @override
  String get archiveWishlist => 'Archive';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get atLeastOneKeyword => 'Please enter at least one keyword';

  @override
  String get pleaseSelectAtLeastOneInterest =>
      'Please select at least one interest or add a custom keyword';

  @override
  String get pleaseSelectAtLeastOneOffer =>
      'Please select at least one offer or add a custom keyword';

  @override
  String get notificationPreferences => 'Notification Preferences';

  @override
  String get contacts => 'Contacts';

  @override
  String get attributes => 'Attributes';

  @override
  String get noContactsFound => 'No contacts found';

  @override
  String get verified => 'Verified';

  @override
  String get notVerified => 'Not Verified';

  @override
  String get updateEmail => 'Update Email';

  @override
  String get updatePhone => 'Update Phone';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get noPushTokens => 'No push notification tokens registered';

  @override
  String get removePushToken => 'Remove Push Token';

  @override
  String get removePushTokenConfirmation =>
      'Are you sure you want to remove this push token?';

  @override
  String get remove => 'Remove';

  @override
  String get pushTokenRemoved => 'Push token removed';

  @override
  String get emailUpdated => 'Email updated';

  @override
  String get phoneUpdated => 'Phone updated';

  @override
  String get noAttributePreferences => 'No attribute preferences';

  @override
  String get attributePreferencesHint =>
      'Set notification preferences for your interests and offerings';

  @override
  String get frequency => 'Frequency';

  @override
  String get minMatchScore => 'Min. Match Score';

  @override
  String get newPostings => 'New Postings';

  @override
  String get newUsers => 'New Users';

  @override
  String get instant => 'Instant';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get manual => 'Manual';

  @override
  String get edit => 'Edit';

  @override
  String get deletePreference => 'Delete Preference';

  @override
  String get deletePreferenceConfirmation =>
      'Are you sure you want to delete this preference?';

  @override
  String get preferenceDeleted => 'Preference deleted';

  @override
  String get editPreference => 'Edit Preference';

  @override
  String get notifyOnNewPostings => 'Notify on new postings';

  @override
  String get notifyOnNewUsers => 'Notify on new users';

  @override
  String get preferenceUpdated => 'Preference updated';

  @override
  String get unviewed => 'Unviewed';

  @override
  String get unviewedOnly => 'Unviewed Only';

  @override
  String get noUnviewedMatches => 'No unviewed matches';

  @override
  String get newBadge => 'NEW';

  @override
  String get markAsViewed => 'Mark as Viewed';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get dismissed => 'Dismissed';

  @override
  String get postingMatch => 'Posting Match';

  @override
  String get userMatch => 'User Match';

  @override
  String get attributeMatch => 'Attribute Match';

  @override
  String get match => 'Match';

  @override
  String get dismissMatch => 'Dismiss Match';

  @override
  String get dismissMatchConfirmation =>
      'Are you sure you want to dismiss this match?';

  @override
  String get matchDismissed => 'Match dismissed';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get matches => 'Matches';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get enableNotificationsDescription =>
      'Receive notifications for matches and updates';

  @override
  String get quietHours => 'Quiet Hours';

  @override
  String get quietHoursDescription =>
      'Do not send notifications during these hours';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get clearQuietHours => 'Clear Quiet Hours';

  @override
  String get noAttributesInProfile =>
      'Add interests and skills to your profile first';

  @override
  String get setupAttributeNotifications => 'Set Up Notifications';

  @override
  String get setupAttributeNotificationsHint =>
      'Enable notifications for your interests and skills to receive alerts when matches are found';

  @override
  String get defaultSettings => 'Default Settings';

  @override
  String get selectAttributes => 'Select Attributes';

  @override
  String get attributesSelected => 'selected';

  @override
  String get createPreferences => 'Save Preferences';

  @override
  String get preferencesCreated => 'Notification preferences saved';

  @override
  String get retry => 'Retry';

  @override
  String get offering => 'Offering';

  @override
  String get interest => 'Interest';

  @override
  String get category => 'Category';

  @override
  String get relevancy => 'Relevancy';

  @override
  String get matchHistory => 'Match History';

  @override
  String get addAttributes => 'Add Attributes';

  @override
  String get allAttributesHavePreferences =>
      'All attributes from your profile already have notification preferences';

  @override
  String get add => 'Add';

  @override
  String get setupEmailTitle => 'Set Up Email';

  @override
  String get setupEmailDescription =>
      'Enter your email address to receive notifications';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get emailRequired => 'Email address is required';

  @override
  String get emailInvalid => 'Please enter a valid email address';

  @override
  String get saveEmail => 'Save Email';

  @override
  String get emailSaved => 'Email address saved successfully';

  @override
  String get marketingConsentLabel =>
      'I agree to receive marketing emails about new features, offers, and updates';

  @override
  String get marketingConsentDescription =>
      'We may send you occasional emails about our services. You can unsubscribe at any time.';

  @override
  String get marketingConsentRequired =>
      'Please consent to receive marketing emails to continue';

  @override
  String get deleteProfile => 'Delete Profile';

  @override
  String get deleteProfileConfirmation =>
      'Are you sure you want to delete your profile? This action cannot be undone. All your data, postings, and conversations will be permanently removed.';

  @override
  String get profileDeleted => 'Profile deleted successfully';

  @override
  String get errorDeletingProfile => 'Error deleting profile';

  @override
  String get review => 'Review';

  @override
  String get reportScam => 'Report Scam';

  @override
  String get reportScamConfirmation =>
      'Are you sure you want to report this user for scam?';

  @override
  String get reportScamConsequencesTitle => 'This will:';

  @override
  String get reportScamConsequence1 =>
      '• Flag this transaction for moderator review';

  @override
  String get reportScamConsequence2 => '• Potentially suspend the other user';

  @override
  String get reportScamConsequence3 => '• Require evidence from you';

  @override
  String get falseReportsWarning =>
      'False reports may result in penalties to your account.';

  @override
  String get report => 'Report';

  @override
  String get reviewSubmitted => 'Review Submitted!';

  @override
  String get thankYouForFeedback => 'Thank you for your feedback!';

  @override
  String get reviewVisibilityNotice =>
      'Your review will be visible after the other User submits their review, or in 14 days.';

  @override
  String get ok => 'OK';

  @override
  String get skipReviewTitle => 'Skip Review?';

  @override
  String get skipReviewMessage =>
      'You can review this user later from your transaction history. Reviews help build trust in the community.';

  @override
  String get goBack => 'Go Back';

  @override
  String get skip => 'Skip';

  @override
  String reviewUser(String userName) {
    return 'Review $userName';
  }

  @override
  String get ratingRequired => 'Rating *';

  @override
  String get ratingExcellent => 'Excellent';

  @override
  String get ratingGood => 'Good';

  @override
  String get ratingOkay => 'Okay';

  @override
  String get ratingPoor => 'Poor';

  @override
  String get ratingVeryBad => 'Very Bad';

  @override
  String get tapToRate => 'Tap to rate';

  @override
  String get howDidItGo => 'How did it go? *';

  @override
  String get transactionStatusSuccessful => 'Successful Trade';

  @override
  String get transactionStatusCancelled => 'Cancelled';

  @override
  String get transactionStatusNoDeal => 'Talked but no deal';

  @override
  String get transactionStatusScam => '🚩 Report Scam';

  @override
  String get tellUsMore => 'Tell us more (optional)';

  @override
  String get shareYourExperience => 'Share your experience...';

  @override
  String get beSpecificAndConstructive => 'Be specific and constructive';

  @override
  String get reviewGuidelines => 'Review Guidelines';

  @override
  String get guidelineHonest => 'Be honest and fair';

  @override
  String get guidelineFocusExperience => 'Focus on your actual experience';

  @override
  String get guidelineVisibility =>
      'Reviews become visible after both parties submit';

  @override
  String get guideline90Days => 'You have 90 days to submit a review';

  @override
  String get guidelineFalseReports =>
      'False reports may result in account suspension';

  @override
  String get submitReview => 'Submit Review';

  @override
  String get skipForNow => 'Skip for Now';

  @override
  String get bonusTipOptional => 'Bonus / Tip (optional)';

  @override
  String get other => 'Other';

  @override
  String get enterBonusAmount => 'Enter bonus amount';

  @override
  String get loadingWalletBalance => 'Loading wallet balance...';

  @override
  String currentWalletBalance(String amount) {
    return 'Current wallet balance: $amount';
  }

  @override
  String get failedToSubmitReview => 'Failed to submit review';

  @override
  String get archiveConversationTitle => 'Archive Conversation?';

  @override
  String get archiveConversationMessage =>
      'Would you like to archive this conversation now?';

  @override
  String get keep => 'Keep';

  @override
  String get archive => 'Archive';

  @override
  String get unableToReviewUser => 'Unable to review this user at this time';

  @override
  String get barterCoinsTitle => 'Barter Coins';

  @override
  String get barterCoinsInfoMessage =>
      'Coins can be earned by providing a service, or by actively using the app.\n\nCoins can be spent on perks planned for future app versions: custom avatar icon, standing out on the map, and being able to add a picture and self-description.';

  @override
  String get cannotSendFileNoRecipientKey =>
      'Cannot send file: Recipient public key not available';

  @override
  String get gallery => 'Device';

  @override
  String get camera => 'Camera';

  @override
  String get uploadingFile => 'Uploading file...';

  @override
  String get fileSentSuccessfully => 'File sent successfully!';

  @override
  String downloadingFile(String filename) {
    return 'Downloading $filename...';
  }

  @override
  String decryptingFile(String filename) {
    return 'Decrypting $filename...';
  }

  @override
  String downloadFailed(String error) {
    return 'Download failed: $error';
  }

  @override
  String get noAppToOpenFile => 'No app found to open this file type';

  @override
  String fileSavedAt(String filePath) {
    return 'File saved at: $filePath';
  }

  @override
  String fileNotFound(String filePath) {
    return 'File not found: $filePath';
  }

  @override
  String get permissionDeniedOpenFile => 'Permission denied to open file';

  @override
  String errorOpeningFile(String message) {
    return 'Error opening file: $message';
  }

  @override
  String couldNotOpenFile(String error) {
    return 'Could not open file: $error';
  }

  @override
  String get finishTransaction => 'Finish Transaction';

  @override
  String get finishTransactionConfirmation =>
      'Are you sure you want to mark this transaction as completed?';

  @override
  String get transactionCreated => 'Transaction created successfully';

  @override
  String get transactionCompleted => 'Transaction marked as completed';

  @override
  String errorCreatingTransaction(String error) {
    return 'Error creating transaction: $error';
  }

  @override
  String errorUpdatingTransaction(String error) {
    return 'Error updating transaction: $error';
  }

  @override
  String get noUsersNearbyTitle => 'No Users Nearby';

  @override
  String get noUsersNearbyMessage =>
      'It looks like there are no users in your area yet. Be the first to invite your friends and start bartering!';

  @override
  String get shareApp => 'Share App';

  @override
  String get copyLink => 'Copy Link';

  @override
  String get close => 'Close';

  @override
  String get badgesTitle => 'Badges';

  @override
  String get noBadgesEarnedYet =>
      'No badges earned yet. Keep trading to unlock badges.';

  @override
  String get badgeEarnedStatus => 'Earned';

  @override
  String get badgeNotEarnedStatus => 'Not earned yet';

  @override
  String get badgeIdentityVerifiedTitle => 'Identity Verified';

  @override
  String get badgeIdentityVerifiedDescription =>
      'User has completed identity verification.';

  @override
  String get badgeVeteranTraderTitle => 'Veteran Trader';

  @override
  String get badgeVeteranTraderDescription =>
      'User has completed 100+ successful trades.';

  @override
  String get badgeTopRatedTitle => 'Top Rated Seller';

  @override
  String get badgeTopRatedDescription =>
      'Maintains 4.8+ average rating with 50+ reviews.';

  @override
  String get badgeQuickResponderTitle => 'Quick Responder';

  @override
  String get badgeQuickResponderDescription =>
      'Usually responds within 24 hours.';

  @override
  String get badgeCommunityConnectorTitle => 'Community Connector';

  @override
  String get badgeCommunityConnectorDescription =>
      'Trades with diverse partners (high diversity score).';

  @override
  String get badgeVerifiedBusinessTitle => 'Verified Business';

  @override
  String get badgeVerifiedBusinessDescription =>
      'Business registration is verified.';

  @override
  String get badgeDisputeFreeTitle => 'Dispute-Free History';

  @override
  String get badgeDisputeFreeDescription =>
      'Has never had a disputed transaction.';

  @override
  String get badgeFastTraderTitle => 'Fast & Reliable';

  @override
  String get badgeFastTraderDescription =>
      'Completes trades faster than average.';

  @override
  String get showMore => 'Show more';

  @override
  String get showLess => 'Show less';

  @override
  String get linkCopiedToClipboard => 'Link copied to clipboard!';

  @override
  String get unableToShareAtThisTime => 'Unable to share at this time';

  @override
  String inviteMessageShare(String appLink) {
    return 'Hey! Join me on BarterApp - a great way to trade items and services with people nearby! 🔄\n\n$appLink';
  }

  @override
  String get inviteMessageSubject => 'Join me on BarterApp!';

  @override
  String get reportUser => 'Report User';

  @override
  String get viewProfile => 'View Profile';

  @override
  String get blockUser => 'Block User';

  @override
  String get unblockUser => 'Unblock User';

  @override
  String get reportUserConfirmation =>
      'Please provide a reason for reporting this user.';

  @override
  String get reportReason => 'Reason for report (optional)';

  @override
  String get userReported => 'User reported successfully';

  @override
  String get blockUserConfirmation =>
      'Are you sure you want to block this user? You will no longer be able to communicate with them.';

  @override
  String get unblockUserConfirmation =>
      'Are you sure you want to unblock this user? They will be able to communicate with you again.';

  @override
  String get block => 'Block';

  @override
  String get unblock => 'Unblock';

  @override
  String get userBlocked => 'User blocked successfully';

  @override
  String get userUnblocked => 'User unblocked successfully';

  @override
  String get failedToBlockUser => 'Failed to block user';

  @override
  String get failedToUnblockUser => 'Failed to unblock user';

  @override
  String get failedToSubmitReport =>
      'Failed to submit report. Please try again.';

  @override
  String get reportSubmittedOfferBlock =>
      'Thank you for helping keep the community safe. Would you also like to block this user?';

  @override
  String reportUserTitle(String userName) {
    return 'Report $userName';
  }

  @override
  String blockUserConfirmationDetailed(String userName) {
    return 'Blocking $userName will prevent them from:\n• Sending you messages\n• Seeing your profile\n• Commenting on your postings';
  }

  @override
  String unblockUserConfirmationDetailed(String userName) {
    return 'Unblocking $userName will allow them to:\n• Send you messages\n• See your profile\n• Comment on your postings';
  }

  @override
  String get whyReportingUser => 'Why are you reporting this user?';

  @override
  String get reportReasonSpam => 'Spam';

  @override
  String get reportReasonHarassment => 'Harassment';

  @override
  String get reportReasonInappropriateContent => 'Inappropriate Content';

  @override
  String get reportReasonScam => 'Scam';

  @override
  String get reportReasonFakeProfile => 'Fake Profile';

  @override
  String get reportReasonImpersonation => 'Impersonation';

  @override
  String get reportReasonThreateningBehavior => 'Threatening Behavior';

  @override
  String get reportReasonOther => 'Other';

  @override
  String get additionalDetails => 'Additional details (optional)';

  @override
  String get provideMoreContext => 'Provide more context...';

  @override
  String get submitReport => 'Submit Report';

  @override
  String get privacyPolicyIntroTitle => 'Introduction';

  @override
  String get privacyPolicyIntroContent =>
      'This Privacy Policy describes how we collect, use, and protect your personal information when you use our bartering application. We are committed to ensuring your privacy and protecting your data.';

  @override
  String get privacyPolicyDataCollectionTitle => 'Information We Collect';

  @override
  String get privacyPolicyDataCollectionContent =>
      'We collect information you provide directly, including your profile information, interests, offerings, location data, and chat messages. We also collect usage data such as app interactions and device information to improve our service.';

  @override
  String get privacyPolicyDataUsageTitle => 'How We Use Your Information';

  @override
  String get privacyPolicyDataUsageContent =>
      'We use your information to: facilitate bartering connections between users, display your profile to other users in your area, enable chat functionality, improve our services, and send notifications about matches and messages.';

  @override
  String get privacyPolicyDataSharingTitle => 'Information Sharing';

  @override
  String get privacyPolicyDataSharingContent =>
      'Your profile information, interests, and offerings are visible to other users of the app to facilitate bartering. We do not sell your personal information to third parties. We may share data with service providers who assist in operating our app, and we may disclose information if required by law.';

  @override
  String get privacyPolicyDataSecurityTitle => 'Data Security';

  @override
  String get privacyPolicyDataSecurityContent =>
      'We implement appropriate technical and organizational measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure.';

  @override
  String get privacyPolicyUserRightsTitle => 'Your Rights';

  @override
  String get privacyPolicyUserRightsContent =>
      'You have the right to access, update, or delete your personal information at any time through the app settings. You can also request a copy of your data or object to certain types of processing.';

  @override
  String get privacyPolicyThirdPartyTitle => 'Third-Party Services';

  @override
  String get privacyPolicyThirdPartyContent =>
      'Our app may use third-party services for analytics, maps, and notifications. These services have their own privacy policies, and we encourage you to review them.';

  @override
  String get privacyPolicyChangesTitle => 'Changes to This Policy';

  @override
  String get privacyPolicyChangesContent =>
      'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy in the app. Continued use of the app after changes constitutes acceptance of the updated policy.';

  @override
  String get privacyPolicyContactTitle => 'Contact Us';

  @override
  String get privacyPolicyContactContent =>
      'If you have any questions about this Privacy Policy or our data practices, please contact us at info@bartering.app';

  @override
  String get privacyPolicyLastUpdated => 'Last updated: January 2026';

  @override
  String get chats => 'Chats';

  @override
  String get gpsLocationDisabled =>
      'GPS location is disabled. Enable it in Settings to use this feature.';

  @override
  String get recommendations => 'Recommendations:';

  @override
  String get transactionWillBeReviewed =>
      'This transaction will be reviewed by our security team.';

  @override
  String get continueAnyway => 'Continue Anyway';

  @override
  String get transactionBlocked => 'Transaction Blocked';

  @override
  String get securityWarning => 'Security Warning';

  @override
  String get securityNotice => 'Security Notice';

  @override
  String get securityCheck => 'Security Check';

  @override
  String get transactionBlockedMessage =>
      'This transaction has been blocked due to suspicious activity patterns. Please contact support if you believe this is an error.';

  @override
  String get securityWarningMessage =>
      'Unusual activity has been detected. Additional verification may be required.';

  @override
  String get securityNoticeMessage =>
      'We\'ve detected some unusual patterns. Your review may be subject to additional verification.';

  @override
  String get securityCheckMessage => 'Everything looks good!';

  @override
  String get downloadStarted => 'Download started! Check your downloads folder';

  @override
  String get showPath => 'Show Path';

  @override
  String get users => 'Users';

  @override
  String get tradeMatch => 'Trade match';

  @override
  String get similar => 'Similar';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageLatvian => 'Latviešu';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageSpanish => 'Español';

  @override
  String errorWithException(String exception) {
    return 'Error: $exception';
  }

  @override
  String get errorVerifyingPin => 'Error verifying PIN';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get deleteAllMatchesConfirmation =>
      'Are you sure you want to delete all match history? This action cannot be undone.';

  @override
  String get allMatchesDeleted => 'All matches have been deleted';

  @override
  String get selectTheInterestsThatMatchYourPreferences =>
      'What services or items do you need?\nYou can change this later.';

  @override
  String get selectTheOffersThatYouCanProvide =>
      'What can you provide or help out with?\nYou can change this later.';

  @override
  String get shareYourInterestsToFindBestMatches =>
      'Share your interests to find the best matches with others!';

  @override
  String get migrateToNewDevice => 'Migrate to New Device';

  @override
  String get migrateYourAccount => 'Migrate Your Account';

  @override
  String get migrationCodeDescription =>
      'Generate a migration code to transfer your account data to a new device. The code will be valid for 15 minutes.';

  @override
  String get generateMigrationCode => 'Generate Migration Code';

  @override
  String get generating => 'Generating...';

  @override
  String get yourMigrationCode => 'Your Migration Code';

  @override
  String expiresIn(String time) {
    return 'Expires in: $time';
  }

  @override
  String get copyCode => 'Copy Code';

  @override
  String get codeCopied => 'Migration code copied to clipboard';

  @override
  String get generateNewCode => 'Generate New Code';

  @override
  String get migrationStep1 => 'Generate a migration code';

  @override
  String get migrationStep2 => 'Open the app on your new device';

  @override
  String get migrationStep3 =>
      'Tap \"Import Existing Account\" on the welcome screen';

  @override
  String get migrationStep4 => 'Enter this code on the new device';

  @override
  String get newDeviceDetected => 'New Device Detected';

  @override
  String get newDeviceDetectedMessage =>
      'A new device wants to import your account data. Do you want to allow this?';

  @override
  String get deny => 'Deny';

  @override
  String get allow => 'Allow';

  @override
  String get migrationDenied => 'Migration denied by user';

  @override
  String get migrationCompleted => 'Migration completed successfully!';

  @override
  String get failedToSendMigration => 'Failed to send migration data';

  @override
  String get migrationCodeExpired =>
      'Migration code has expired. Please generate a new one.';

  @override
  String get targetDeviceTimeout => 'Target device did not join in time';

  @override
  String get expired => 'Expired';

  @override
  String get importAccount => 'Import Account';

  @override
  String get importAccountDescription =>
      'Enter the 10-character migration code from your other device to import your account data.';

  @override
  String get failedToJoinMigration => 'Failed to join migration session';

  @override
  String get failedToSendCode => 'Failed to send recovery code';

  @override
  String get migrationTimedOut =>
      'Migration timed out. Please try again with a new code.';

  @override
  String get failedToProcessMigration => 'Failed to process migration data';

  @override
  String get clear => 'Clear';

  @override
  String get importExistingAccount => 'Import Existing Account';

  @override
  String get targetStep1 => 'Open the app on your other device';

  @override
  String get targetStep2 => 'Go to Settings → Account → Migrate Device';

  @override
  String get targetStep3 => 'Enter the code shown on that device here';

  @override
  String get recoverViaEmail => 'Recover via Email';

  @override
  String get recoverAccount => 'Recover Account';

  @override
  String get recoverAccountDescription =>
      'Enter your email address to receive a recovery code and restore your account on this device.';

  @override
  String get sendRecoveryCode => 'Send Recovery Code';

  @override
  String codeSentTo(Object email) {
    return 'Recovery code sent to $email';
  }

  @override
  String get resendCode => 'Resend Code';

  @override
  String resendCodeIn(Object seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get verifyAndRecover => 'Verify & Recover';

  @override
  String get invalidCode => 'Invalid recovery code';

  @override
  String get recoveryFailed => 'Account recovery failed';

  @override
  String get recoverySuccess => 'Recovery Successful!';

  @override
  String get recoverySuccessMessage =>
      'Your account has been successfully recovered on this device.';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get noPostingsFound => 'No postings found';

  @override
  String get settingsGpsLocationTitle => 'Enable GPS Location';

  @override
  String get settingsGpsLocationEnabledDescription =>
      'GPS location tracking is enabled';

  @override
  String get settingsGpsLocationDisabledDescription =>
      'GPS location tracking is disabled';

  @override
  String get settingsGpsLocationDescription =>
      'When enabled, you can zoom to your current GPS location on the map. The app will request location permissions when needed.';

  @override
  String get locationPermissionRequiredDescription =>
      'Location permission is required to use GPS location tracking. Please enable location permission in your device settings.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get profilePanelTitle => 'Profile';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'reviews',
      one: 'review',
    );
    return '$count $_temp0';
  }
}
