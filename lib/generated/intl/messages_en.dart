// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(amount) => "Balance: ${amount} ₿";

  static String m1(coins) => "Buy ${coins} ₿";

  static String m2(price) => "Each avatar: ${price} ₿";

  static String m3(error) => "Failed to load avatar shop: ${error}";

  static String m4(coins) => "Need ${coins} ₿";

  static String m5(coins) => "Not enough coins. You need ${coins} coins.";

  static String m6(error) => "Purchase failed: ${error}";

  static String m7(userName) =>
      "Blocking ${userName} will prevent them from:\n• Sending you messages\n• Seeing your profile\n• Commenting on your postings";

  static String m8(email) => "Recovery code sent to ${email}";

  static String m9(error) => "Could not open file: ${error}";

  static String m10(amount) => "Current wallet balance: ${amount}";

  static String m11(filename) => "Decrypting ${filename}...";

  static String m12(error) => "Download failed: ${error}";

  static String m13(filename) => "Downloading ${filename}...";

  static String m14(error) => "Error creating transaction: ${error}";

  static String m15(error) => "Error finding location: ${error}";

  static String m16(message) => "Error opening file: ${message}";

  static String m17(error) => "Error updating transaction: ${error}";

  static String m18(exception) => "Error: ${exception}";

  static String m19(errorMessage) => "Error: ${errorMessage}";

  static String m20(time) => "Expires in: ${time}";

  static String m21(filePath) => "File not found: ${filePath}";

  static String m22(filePath) => "File saved at: ${filePath}";

  static String m23(appLink) =>
      "Hey! Join me on BarterApp - a great way to trade items and services with people nearby! 🔄\n\n${appLink}";

  static String m24(count) => "${count} d ago";

  static String m25(count) => "${count} h ago";

  static String m26(count) => "${count} min ago";

  static String m27(count) =>
      "${count} matching ${Intl.plural(count, one: 'posting', other: 'postings')} found";

  static String m28(count) =>
      "${count} matching ${Intl.plural(count, one: 'user', other: 'users')} found";

  static String m29(id) => "Mock POI with id ${id} not found in service";

  static String m30(id) => "Mock POI with id ${id} not found for update";

  static String m31(count) => "Notify me when ${count}+ users are nearby";

  static String m32(email) => "Alerts can be sent to ${email}";

  static String m33(attempts) => "Incorrect PIN (Attempt ${attempts})";

  static String m34(fileName) => "Selected: ${fileName}";

  static String m35(count) => "${count} questions answered";

  static String m36(userName) => "Report ${userName}";

  static String m37(seconds) => "Resend code in ${seconds}s";

  static String m38(userName) => "Review ${userName}";

  static String m39(count) =>
      "${count} ${Intl.plural(count, one: 'review', other: 'reviews')}";

  static String m40(attempts) => "Incorrect answer (Attempt ${attempts})";

  static String m41(amount) => "Selected coin package: ${amount}";

  static String m42(number) => "Style ${number}";

  static String m43(userName) =>
      "Unblocking ${userName} will allow them to:\n• Send you messages\n• See your profile\n• Comment on your postings";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accountDeletionCodeHint": MessageLookupByLibrary.simpleMessage(
      "Enter code from email",
    ),
    "accountDeletionCodeInvalid": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid verification code.",
    ),
    "accountDeletionCodeLabel": MessageLookupByLibrary.simpleMessage(
      "Verification code",
    ),
    "accountDeletionCodeSent": MessageLookupByLibrary.simpleMessage(
      "Verification code sent. Please check your email.",
    ),
    "accountDeletionConfirmButton": MessageLookupByLibrary.simpleMessage(
      "Confirm account deletion",
    ),
    "accountDeletionDataDeletedItems": MessageLookupByLibrary.simpleMessage(
      "- Account registration data and profile\n- Device keys and migration/recovery sessions\n- Postings and associated uploaded images\n- Attributes, relationships, reports, and favorites/match history\n- Messages, read receipts, encrypted file metadata, and chat response stats\n- Reviews, reputation, transactions, moderation/appeals, and review audit data\n- Notification contacts and notification preferences\n- Presence/activity cache entries and related analytics/location tracking rows",
    ),
    "accountDeletionDataDeletedTitle": MessageLookupByLibrary.simpleMessage(
      "If confirmed, we will permanently delete:",
    ),
    "accountDeletionDataDeletedTitleAfterConfirmed":
        MessageLookupByLibrary.simpleMessage(
          "Your user profile with the following data has been deleted:",
        ),
    "accountDeletionEmailLabel": MessageLookupByLibrary.simpleMessage(
      "Account email",
    ),
    "accountDeletionHeader": MessageLookupByLibrary.simpleMessage(
      "Request account deletion",
    ),
    "accountDeletionInfo": MessageLookupByLibrary.simpleMessage(
      "Use this page to request permanent account deletion. Once completed, your profile and related account data will be removed according to our retention policy.",
    ),
    "accountDeletionSendCodeButton": MessageLookupByLibrary.simpleMessage(
      "Send verification code",
    ),
    "accountDeletionSteps": MessageLookupByLibrary.simpleMessage(
      "Steps:\n1. Enter your account email\n2. Submit to receive a verification code\n3. Enter the code to confirm deletion",
    ),
    "accountDeletionSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Deletion request submitted successfully. Our team will process your request and your account will be deleted after verification.",
    ),
    "accountDeletionTitle": MessageLookupByLibrary.simpleMessage(
      "Delete account",
    ),
    "accountDeletionTokenInfo": MessageLookupByLibrary.simpleMessage(
      "Account deletion request confirmed. This action is permanent and cannot be undone.",
    ),
    "accountSetupSuccess": MessageLookupByLibrary.simpleMessage(
      "Your account has been set up!",
    ),
    "activateWishlist": MessageLookupByLibrary.simpleMessage("Activate"),
    "activePostings": MessageLookupByLibrary.simpleMessage("Active Postings"),
    "add": MessageLookupByLibrary.simpleMessage("Add"),
    "addAttributes": MessageLookupByLibrary.simpleMessage("Add Attributes"),
    "addImage": MessageLookupByLibrary.simpleMessage("Add Image"),
    "addNewPosting": MessageLookupByLibrary.simpleMessage("Add Posting"),
    "addWishlistItem": MessageLookupByLibrary.simpleMessage(
      "Add Wishlist Item",
    ),
    "addYourOwnKeywords": MessageLookupByLibrary.simpleMessage(
      "Add your own keywords",
    ),
    "additionalDetails": MessageLookupByLibrary.simpleMessage(
      "Additional details (optional)",
    ),
    "allAttributesHavePreferences": MessageLookupByLibrary.simpleMessage(
      "All attributes from your profile already have notification preferences",
    ),
    "allMatchesDeleted": MessageLookupByLibrary.simpleMessage(
      "All matches have been deleted",
    ),
    "allow": MessageLookupByLibrary.simpleMessage("Allow"),
    "anUnknownErrorOccurred": MessageLookupByLibrary.simpleMessage(
      "An unknown error occurred.",
    ),
    "answerHint": MessageLookupByLibrary.simpleMessage("Enter your answer"),
    "answerSecurityQuestion": MessageLookupByLibrary.simpleMessage(
      "Answer Security Question",
    ),
    "answerTooShort": MessageLookupByLibrary.simpleMessage(
      "Answer must be at least 2 characters",
    ),
    "apiErrorAuthSessionExpired": MessageLookupByLibrary.simpleMessage(
      "Your session has expired. Please sign in again.",
    ),
    "apiErrorBadRequest": MessageLookupByLibrary.simpleMessage(
      "There was an issue with the request. Please check your input and try again.",
    ),
    "apiErrorConflict": MessageLookupByLibrary.simpleMessage(
      "Conflict with existing data. Please refresh and try again.",
    ),
    "apiErrorFavoriteUsersFallback": MessageLookupByLibrary.simpleMessage(
      "Unable to load favorite users right now.",
    ),
    "apiErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "You do not have permission to perform this action.",
    ),
    "apiErrorMatchingUsersFallback": MessageLookupByLibrary.simpleMessage(
      "Unable to load matching users right now.",
    ),
    "apiErrorNearbyUsersFallback": MessageLookupByLibrary.simpleMessage(
      "Unable to load nearby users right now.",
    ),
    "apiErrorNoInternet": MessageLookupByLibrary.simpleMessage(
      "No internet connection. Please check your network and try again.",
    ),
    "apiErrorNotFound": MessageLookupByLibrary.simpleMessage(
      "The requested resource was not found.",
    ),
    "apiErrorSearchUsersFallback": MessageLookupByLibrary.simpleMessage(
      "Unable to search users right now.",
    ),
    "apiErrorServer": MessageLookupByLibrary.simpleMessage(
      "Server error. Please try again later.",
    ),
    "apiErrorSimilarUsersFallback": MessageLookupByLibrary.simpleMessage(
      "Unable to load similar users right now.",
    ),
    "apiErrorTimeout": MessageLookupByLibrary.simpleMessage(
      "The request timed out. Please try again.",
    ),
    "apiErrorValidation": MessageLookupByLibrary.simpleMessage(
      "Some of the provided data is invalid.",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("Bartering App"),
    "appealReasonRequired": MessageLookupByLibrary.simpleMessage(
      "Appeal reason is required",
    ),
    "appealReviewReasonHint": MessageLookupByLibrary.simpleMessage(
      "Describe why this review should be reconsidered",
    ),
    "appealReviewTitle": MessageLookupByLibrary.simpleMessage("Appeal review"),
    "archive": MessageLookupByLibrary.simpleMessage("Archive"),
    "archiveConversationMessage": MessageLookupByLibrary.simpleMessage(
      "Would you like to archive this conversation now?",
    ),
    "archiveConversationTitle": MessageLookupByLibrary.simpleMessage(
      "Archive Conversation?",
    ),
    "archiveWishlist": MessageLookupByLibrary.simpleMessage("Archive"),
    "atLeastOneKeyword": MessageLookupByLibrary.simpleMessage(
      "Please enter at least one keyword",
    ),
    "attr_3d_printing": MessageLookupByLibrary.simpleMessage("3D printing"),
    "attr_academic_tutoring": MessageLookupByLibrary.simpleMessage(
      "Academic tutoring",
    ),
    "attr_acting": MessageLookupByLibrary.simpleMessage("Acting"),
    "attr_administrative_work": MessageLookupByLibrary.simpleMessage(
      "Administrative work",
    ),
    "attr_ai_consulting": MessageLookupByLibrary.simpleMessage("AI Consulting"),
    "attr_alternative_healing": MessageLookupByLibrary.simpleMessage(
      "Alternative healing",
    ),
    "attr_alternative_medicine": MessageLookupByLibrary.simpleMessage(
      "Alternative medicine",
    ),
    "attr_android": MessageLookupByLibrary.simpleMessage("Android"),
    "attr_animal_care": MessageLookupByLibrary.simpleMessage("Animal care"),
    "attr_animation": MessageLookupByLibrary.simpleMessage("Animation"),
    "attr_app_development": MessageLookupByLibrary.simpleMessage(
      "App development",
    ),
    "attr_art_exhibitions": MessageLookupByLibrary.simpleMessage(
      "Art Exhibitions",
    ),
    "attr_artificial_intelligence": MessageLookupByLibrary.simpleMessage(
      "Artificial Intelligence",
    ),
    "attr_astronomy": MessageLookupByLibrary.simpleMessage("Astronomy"),
    "attr_audio_equipment": MessageLookupByLibrary.simpleMessage(
      "Audio equipment",
    ),
    "attr_babysitting": MessageLookupByLibrary.simpleMessage("Babysitting"),
    "attr_backend_development": MessageLookupByLibrary.simpleMessage(
      "Backend development",
    ),
    "attr_backpacking": MessageLookupByLibrary.simpleMessage("Backpacking"),
    "attr_baking": MessageLookupByLibrary.simpleMessage("Baking"),
    "attr_beauty_products": MessageLookupByLibrary.simpleMessage(
      "Beauty products",
    ),
    "attr_beekeeping": MessageLookupByLibrary.simpleMessage("Beekeeping"),
    "attr_bicycle_parts": MessageLookupByLibrary.simpleMessage("Bicycle parts"),
    "attr_bicycles": MessageLookupByLibrary.simpleMessage("Bicycles"),
    "attr_billiards": MessageLookupByLibrary.simpleMessage("Billiards"),
    "attr_biohacking": MessageLookupByLibrary.simpleMessage("Biohacking"),
    "attr_board_games": MessageLookupByLibrary.simpleMessage("Board games"),
    "attr_bodybuilding": MessageLookupByLibrary.simpleMessage("Bodybuilding"),
    "attr_bookkeeping": MessageLookupByLibrary.simpleMessage("Bookkeeping"),
    "attr_books": MessageLookupByLibrary.simpleMessage("Books"),
    "attr_bowling": MessageLookupByLibrary.simpleMessage("Bowling"),
    "attr_brainstorming": MessageLookupByLibrary.simpleMessage("Brainstorming"),
    "attr_breadmaking": MessageLookupByLibrary.simpleMessage("Breadmaking"),
    "attr_building_materials": MessageLookupByLibrary.simpleMessage(
      "Building materials",
    ),
    "attr_business_mentorship": MessageLookupByLibrary.simpleMessage(
      "Business Mentorship",
    ),
    "attr_camping": MessageLookupByLibrary.simpleMessage("Camping"),
    "attr_camping_gear": MessageLookupByLibrary.simpleMessage("Camping gear"),
    "attr_canned_goods": MessageLookupByLibrary.simpleMessage("Canned goods"),
    "attr_canyoning": MessageLookupByLibrary.simpleMessage("Canyoning"),
    "attr_car_cleaning": MessageLookupByLibrary.simpleMessage("Car cleaning"),
    "attr_car_detailing": MessageLookupByLibrary.simpleMessage("Car detailing"),
    "attr_car_maintenance": MessageLookupByLibrary.simpleMessage(
      "Car maintenance",
    ),
    "attr_car_restoration": MessageLookupByLibrary.simpleMessage(
      "Car restoration",
    ),
    "attr_card_games": MessageLookupByLibrary.simpleMessage("Card games"),
    "attr_carpentry": MessageLookupByLibrary.simpleMessage("Carpentry"),
    "attr_cats": MessageLookupByLibrary.simpleMessage("Cats"),
    "attr_ceramics": MessageLookupByLibrary.simpleMessage("Ceramics"),
    "attr_charity_work": MessageLookupByLibrary.simpleMessage("Charity work"),
    "attr_chess": MessageLookupByLibrary.simpleMessage("Chess"),
    "attr_chicken_eggs": MessageLookupByLibrary.simpleMessage("Chicken eggs"),
    "attr_cleaning": MessageLookupByLibrary.simpleMessage("Cleaning"),
    "attr_clothesmaking": MessageLookupByLibrary.simpleMessage("Clothesmaking"),
    "attr_clothing": MessageLookupByLibrary.simpleMessage("Clothing"),
    "attr_co_op_gaming": MessageLookupByLibrary.simpleMessage("Co-op gaming"),
    "attr_code_review": MessageLookupByLibrary.simpleMessage("Code review"),
    "attr_coding": MessageLookupByLibrary.simpleMessage("Coding"),
    "attr_comic_books": MessageLookupByLibrary.simpleMessage("Comic books"),
    "attr_community_gardening": MessageLookupByLibrary.simpleMessage(
      "Community gardening",
    ),
    "attr_computer_accessories": MessageLookupByLibrary.simpleMessage(
      "Computer accessories",
    ),
    "attr_computer_repair": MessageLookupByLibrary.simpleMessage(
      "Computer repair",
    ),
    "attr_concert_tickets": MessageLookupByLibrary.simpleMessage(
      "Concert tickets",
    ),
    "attr_construction": MessageLookupByLibrary.simpleMessage("Construction"),
    "attr_cooking": MessageLookupByLibrary.simpleMessage("Cooking"),
    "attr_couponing": MessageLookupByLibrary.simpleMessage("Couponing"),
    "attr_crafting": MessageLookupByLibrary.simpleMessage("Crafting"),
    "attr_crocheting": MessageLookupByLibrary.simpleMessage("Crocheting"),
    "attr_cross_stitch": MessageLookupByLibrary.simpleMessage("Cross-stitch"),
    "attr_cryptocurrency": MessageLookupByLibrary.simpleMessage(
      "Cryptocurrency",
    ),
    "attr_culinary_arts": MessageLookupByLibrary.simpleMessage("Culinary arts"),
    "attr_cybersecurity": MessageLookupByLibrary.simpleMessage("Cybersecurity"),
    "attr_cycling": MessageLookupByLibrary.simpleMessage("Cycling"),
    "attr_dance_lessons": MessageLookupByLibrary.simpleMessage("Dance lessons"),
    "attr_dancing": MessageLookupByLibrary.simpleMessage("Dancing"),
    "attr_day_trading": MessageLookupByLibrary.simpleMessage("Day trading"),
    "attr_deep_cleaning": MessageLookupByLibrary.simpleMessage("Deep cleaning"),
    "attr_device_lending": MessageLookupByLibrary.simpleMessage(
      "Device lending",
    ),
    "attr_digital_arts": MessageLookupByLibrary.simpleMessage("Digital arts"),
    "attr_digital_products": MessageLookupByLibrary.simpleMessage(
      "Digital products",
    ),
    "attr_diy": MessageLookupByLibrary.simpleMessage("DIY"),
    "attr_dj_ing": MessageLookupByLibrary.simpleMessage("DJing"),
    "attr_dog_walking": MessageLookupByLibrary.simpleMessage("Dog walking"),
    "attr_dogs": MessageLookupByLibrary.simpleMessage("Dogs"),
    "attr_drawing": MessageLookupByLibrary.simpleMessage("Drawing"),
    "attr_driving": MessageLookupByLibrary.simpleMessage("Driving"),
    "attr_drones": MessageLookupByLibrary.simpleMessage("Drones"),
    "attr_drumming": MessageLookupByLibrary.simpleMessage("Drumming"),
    "attr_elderly_care": MessageLookupByLibrary.simpleMessage("Elderly care"),
    "attr_electronic_components": MessageLookupByLibrary.simpleMessage(
      "Electronic components",
    ),
    "attr_electronics": MessageLookupByLibrary.simpleMessage("Electronics"),
    "attr_embroidery": MessageLookupByLibrary.simpleMessage("Embroidery"),
    "attr_engraving": MessageLookupByLibrary.simpleMessage("Engraving"),
    "attr_environmentalism": MessageLookupByLibrary.simpleMessage(
      "Environmentalism",
    ),
    "attr_errand_running": MessageLookupByLibrary.simpleMessage(
      "Errand running",
    ),
    "attr_event_hosting": MessageLookupByLibrary.simpleMessage("Event hosting"),
    "attr_event_tickets": MessageLookupByLibrary.simpleMessage("Event tickets"),
    "attr_exercise_partner": MessageLookupByLibrary.simpleMessage(
      "Exercise partner",
    ),
    "attr_farm_animals": MessageLookupByLibrary.simpleMessage("Farm animals"),
    "attr_farm_machinery": MessageLookupByLibrary.simpleMessage(
      "Farm machinery",
    ),
    "attr_farmstay": MessageLookupByLibrary.simpleMessage("Farmstay"),
    "attr_fashion_design": MessageLookupByLibrary.simpleMessage(
      "Fashion design",
    ),
    "attr_filmmaking": MessageLookupByLibrary.simpleMessage("Film making"),
    "attr_financial_investing": MessageLookupByLibrary.simpleMessage(
      "Financial investing",
    ),
    "attr_firewood": MessageLookupByLibrary.simpleMessage("Firewood"),
    "attr_fishing": MessageLookupByLibrary.simpleMessage("Fishing"),
    "attr_fitness_coaching": MessageLookupByLibrary.simpleMessage(
      "Fitness coaching",
    ),
    "attr_flower_arranging": MessageLookupByLibrary.simpleMessage(
      "Flower arranging",
    ),
    "attr_foraging": MessageLookupByLibrary.simpleMessage("Foraging"),
    "attr_forestry": MessageLookupByLibrary.simpleMessage("Forestry"),
    "attr_fresh_herbs": MessageLookupByLibrary.simpleMessage("Fresh herbs"),
    "attr_fruits": MessageLookupByLibrary.simpleMessage("Fruits"),
    "attr_furniture_assembly": MessageLookupByLibrary.simpleMessage(
      "Furniture assembly",
    ),
    "attr_gadgets": MessageLookupByLibrary.simpleMessage("Gadgets"),
    "attr_gaming": MessageLookupByLibrary.simpleMessage("Gaming"),
    "attr_gardening": MessageLookupByLibrary.simpleMessage("Gardening"),
    "attr_gardening_advice": MessageLookupByLibrary.simpleMessage(
      "Gardening advice",
    ),
    "attr_graphic_design": MessageLookupByLibrary.simpleMessage(
      "Graphic design",
    ),
    "attr_hacking": MessageLookupByLibrary.simpleMessage("Hacking"),
    "attr_hair_styling": MessageLookupByLibrary.simpleMessage("Hair styling"),
    "attr_handmade_items": MessageLookupByLibrary.simpleMessage(
      "Handmade items",
    ),
    "attr_handyman_services": MessageLookupByLibrary.simpleMessage(
      "Handyman services",
    ),
    "attr_hauling_services": MessageLookupByLibrary.simpleMessage(
      "Hauling services",
    ),
    "attr_health_supplements": MessageLookupByLibrary.simpleMessage(
      "Health supplements",
    ),
    "attr_herbal_remedies": MessageLookupByLibrary.simpleMessage(
      "Herbal remedies",
    ),
    "attr_hiking": MessageLookupByLibrary.simpleMessage("Hiking"),
    "attr_home_decor": MessageLookupByLibrary.simpleMessage("Home decor"),
    "attr_home_improvement": MessageLookupByLibrary.simpleMessage(
      "Home improvement",
    ),
    "attr_homebrewing": MessageLookupByLibrary.simpleMessage("Homebrewing"),
    "attr_homemade_goods": MessageLookupByLibrary.simpleMessage(
      "Homemade goods",
    ),
    "attr_horses": MessageLookupByLibrary.simpleMessage("Horses"),
    "attr_house_maintenance": MessageLookupByLibrary.simpleMessage(
      "House maintenance",
    ),
    "attr_houseplant_care": MessageLookupByLibrary.simpleMessage(
      "Houseplant care",
    ),
    "attr_interview_practice": MessageLookupByLibrary.simpleMessage(
      "Interview practice",
    ),
    "attr_ios": MessageLookupByLibrary.simpleMessage("iOS"),
    "attr_jewelry": MessageLookupByLibrary.simpleMessage("Jewelry"),
    "attr_kids_toys": MessageLookupByLibrary.simpleMessage("Kids toys"),
    "attr_kitchen_appliances": MessageLookupByLibrary.simpleMessage(
      "Kitchen appliances",
    ),
    "attr_knitting": MessageLookupByLibrary.simpleMessage("Knitting"),
    "attr_kombucha": MessageLookupByLibrary.simpleMessage("Kombucha"),
    "attr_landscaping": MessageLookupByLibrary.simpleMessage("Landscaping"),
    "attr_language_exchange": MessageLookupByLibrary.simpleMessage(
      "Language exchange",
    ),
    "attr_lawn_care": MessageLookupByLibrary.simpleMessage("Lawn care"),
    "attr_leather_crafting": MessageLookupByLibrary.simpleMessage(
      "Leather crafting",
    ),
    "attr_legal_advice": MessageLookupByLibrary.simpleMessage("Legal advice"),
    "attr_linux": MessageLookupByLibrary.simpleMessage("Linux"),
    "attr_local_tours": MessageLookupByLibrary.simpleMessage("Local tours"),
    "attr_machinery_operation": MessageLookupByLibrary.simpleMessage(
      "Machinery operation",
    ),
    "attr_machining": MessageLookupByLibrary.simpleMessage("Machining"),
    "attr_magic": MessageLookupByLibrary.simpleMessage("Magic"),
    "attr_makeup": MessageLookupByLibrary.simpleMessage("Makeup"),
    "attr_marketing": MessageLookupByLibrary.simpleMessage("Marketing"),
    "attr_martial_arts": MessageLookupByLibrary.simpleMessage("Martial arts"),
    "attr_massage": MessageLookupByLibrary.simpleMessage("Massage"),
    "attr_math_tutoring": MessageLookupByLibrary.simpleMessage("Math tutoring"),
    "attr_mechanisms": MessageLookupByLibrary.simpleMessage("Mechanisms"),
    "attr_meditation": MessageLookupByLibrary.simpleMessage("Meditation"),
    "attr_mentorship": MessageLookupByLibrary.simpleMessage("Mentorship"),
    "attr_metal_detecting": MessageLookupByLibrary.simpleMessage(
      "Metal detecting",
    ),
    "attr_metalworking": MessageLookupByLibrary.simpleMessage("Metalworking"),
    "attr_mindfulness": MessageLookupByLibrary.simpleMessage("Mindfulness"),
    "attr_motorcycles": MessageLookupByLibrary.simpleMessage("Motorcycles"),
    "attr_movies": MessageLookupByLibrary.simpleMessage("Movies"),
    "attr_moving_help": MessageLookupByLibrary.simpleMessage("Moving help"),
    "attr_multiplayer_games": MessageLookupByLibrary.simpleMessage(
      "Multiplayer games",
    ),
    "attr_music_performance": MessageLookupByLibrary.simpleMessage(
      "Music performance",
    ),
    "attr_music_production": MessageLookupByLibrary.simpleMessage(
      "Music production",
    ),
    "attr_musical_instruments": MessageLookupByLibrary.simpleMessage(
      "Musical instruments",
    ),
    "attr_natural_remedies": MessageLookupByLibrary.simpleMessage(
      "Natural remedies",
    ),
    "attr_networking": MessageLookupByLibrary.simpleMessage("Networking"),
    "attr_nutrition_advice": MessageLookupByLibrary.simpleMessage(
      "Nutrition advice",
    ),
    "attr_organic_food": MessageLookupByLibrary.simpleMessage("Organic food"),
    "attr_painting": MessageLookupByLibrary.simpleMessage("Painting"),
    "attr_pc_building": MessageLookupByLibrary.simpleMessage("PC building"),
    "attr_permaculture": MessageLookupByLibrary.simpleMessage("Permaculture"),
    "attr_personal_finance": MessageLookupByLibrary.simpleMessage(
      "Personal finance",
    ),
    "attr_pet_grooming": MessageLookupByLibrary.simpleMessage("Pet grooming"),
    "attr_pet_sitting": MessageLookupByLibrary.simpleMessage("Pet sitting"),
    "attr_pet_supplies": MessageLookupByLibrary.simpleMessage("Pet supplies"),
    "attr_phone_repair": MessageLookupByLibrary.simpleMessage("Phone repair"),
    "attr_photo_restoration": MessageLookupByLibrary.simpleMessage(
      "Photo restoration",
    ),
    "attr_photography": MessageLookupByLibrary.simpleMessage("Photography"),
    "attr_physical_work": MessageLookupByLibrary.simpleMessage("Physical work"),
    "attr_piano_lessons": MessageLookupByLibrary.simpleMessage("Piano lessons"),
    "attr_plants": MessageLookupByLibrary.simpleMessage("Plants"),
    "attr_plumbing": MessageLookupByLibrary.simpleMessage("Plumbing"),
    "attr_poker": MessageLookupByLibrary.simpleMessage("Poker"),
    "attr_pottery": MessageLookupByLibrary.simpleMessage("Pottery"),
    "attr_power_tools": MessageLookupByLibrary.simpleMessage("Power tools"),
    "attr_proofreading": MessageLookupByLibrary.simpleMessage("Proofreading"),
    "attr_quilting": MessageLookupByLibrary.simpleMessage("Quilting"),
    "attr_recipes": MessageLookupByLibrary.simpleMessage("Recipes"),
    "attr_record_collecting": MessageLookupByLibrary.simpleMessage(
      "Record collecting",
    ),
    "attr_renovation": MessageLookupByLibrary.simpleMessage("Renovation"),
    "attr_retreats": MessageLookupByLibrary.simpleMessage("Retreats"),
    "attr_reviewing": MessageLookupByLibrary.simpleMessage("Reviewing"),
    "attr_ridesharing": MessageLookupByLibrary.simpleMessage("Ridesharing"),
    "attr_robotics": MessageLookupByLibrary.simpleMessage("Robotics"),
    "attr_rock_climbing": MessageLookupByLibrary.simpleMessage("Rock climbing"),
    "attr_sales": MessageLookupByLibrary.simpleMessage("Sales"),
    "attr_scrap_metal": MessageLookupByLibrary.simpleMessage("Scrap metal"),
    "attr_sculpting": MessageLookupByLibrary.simpleMessage("Sculpting"),
    "attr_self_sufficiency": MessageLookupByLibrary.simpleMessage(
      "Self-sufficiency",
    ),
    "attr_sewing": MessageLookupByLibrary.simpleMessage("Sewing"),
    "attr_shoemaking": MessageLookupByLibrary.simpleMessage("Shoemaking"),
    "attr_social_media": MessageLookupByLibrary.simpleMessage("Social media"),
    "attr_socializing": MessageLookupByLibrary.simpleMessage("Socializing"),
    "attr_software_accounts": MessageLookupByLibrary.simpleMessage(
      "Software accounts",
    ),
    "attr_software_development": MessageLookupByLibrary.simpleMessage(
      "Software development",
    ),
    "attr_spare_parts": MessageLookupByLibrary.simpleMessage("Spare parts"),
    "attr_spirituality": MessageLookupByLibrary.simpleMessage("Spirituality"),
    "attr_sports_coaching": MessageLookupByLibrary.simpleMessage(
      "Sports coaching",
    ),
    "attr_sports_equipment": MessageLookupByLibrary.simpleMessage(
      "Sports equipment",
    ),
    "attr_stand_up_comedy": MessageLookupByLibrary.simpleMessage(
      "Stand-up comedy",
    ),
    "attr_study_partner": MessageLookupByLibrary.simpleMessage("Study partner"),
    "attr_sustainable_living": MessageLookupByLibrary.simpleMessage(
      "Sustainable living",
    ),
    "attr_tea": MessageLookupByLibrary.simpleMessage("Tea"),
    "attr_technical_writing": MessageLookupByLibrary.simpleMessage(
      "Technical writing",
    ),
    "attr_tennis": MessageLookupByLibrary.simpleMessage("Tennis"),
    "attr_tool_lending": MessageLookupByLibrary.simpleMessage("Tool lending"),
    "attr_translation_services": MessageLookupByLibrary.simpleMessage(
      "Translation services",
    ),
    "attr_transport_service": MessageLookupByLibrary.simpleMessage(
      "Transport service",
    ),
    "attr_traveling": MessageLookupByLibrary.simpleMessage("Traveling"),
    "attr_upcycling": MessageLookupByLibrary.simpleMessage("Upcycling"),
    "attr_urban_exploration": MessageLookupByLibrary.simpleMessage(
      "Urban exploration",
    ),
    "attr_used_electronics": MessageLookupByLibrary.simpleMessage(
      "Used electronics",
    ),
    "attr_ux_design": MessageLookupByLibrary.simpleMessage("UX design"),
    "attr_vegetables": MessageLookupByLibrary.simpleMessage("Vegetables"),
    "attr_vehicle_repair": MessageLookupByLibrary.simpleMessage(
      "Vehicle repair",
    ),
    "attr_video_editing": MessageLookupByLibrary.simpleMessage("Video editing"),
    "attr_video_game_developing": MessageLookupByLibrary.simpleMessage(
      "Video game developing",
    ),
    "attr_video_game_hardware": MessageLookupByLibrary.simpleMessage(
      "Video game hardware",
    ),
    "attr_virtual_assistance": MessageLookupByLibrary.simpleMessage(
      "Virtual assistance",
    ),
    "attr_virtual_reality": MessageLookupByLibrary.simpleMessage(
      "Virtual reality",
    ),
    "attr_vocals": MessageLookupByLibrary.simpleMessage("Vocals"),
    "attr_voice_lessons": MessageLookupByLibrary.simpleMessage("Voice lessons"),
    "attr_volunteering": MessageLookupByLibrary.simpleMessage("Volunteering"),
    "attr_weaving": MessageLookupByLibrary.simpleMessage("Weaving"),
    "attr_web_development": MessageLookupByLibrary.simpleMessage(
      "Web Development",
    ),
    "attr_weight_training": MessageLookupByLibrary.simpleMessage(
      "Weight training",
    ),
    "attr_welding": MessageLookupByLibrary.simpleMessage("Welding"),
    "attr_wood_carving": MessageLookupByLibrary.simpleMessage("Wood carving"),
    "attr_woodworking": MessageLookupByLibrary.simpleMessage("Woodworking"),
    "attr_workout_planning": MessageLookupByLibrary.simpleMessage(
      "Workout planning",
    ),
    "attr_writing": MessageLookupByLibrary.simpleMessage("Writing"),
    "attr_yoga": MessageLookupByLibrary.simpleMessage("Yoga"),
    "attr_zen": MessageLookupByLibrary.simpleMessage("Zen"),
    "attr_zumba": MessageLookupByLibrary.simpleMessage("Zumba"),
    "attributeMatch": MessageLookupByLibrary.simpleMessage("Attribute Match"),
    "attributePreferencesHint": MessageLookupByLibrary.simpleMessage(
      "Set notification preferences for your interests and offerings",
    ),
    "attributes": MessageLookupByLibrary.simpleMessage("Attributes"),
    "attributesSelected": MessageLookupByLibrary.simpleMessage("selected"),
    "avatarShopAvatarAlreadySelected": MessageLookupByLibrary.simpleMessage(
      "This avatar is already selected.",
    ),
    "avatarShopBalance": m0,
    "avatarShopBuyButton": m1,
    "avatarShopDescription": MessageLookupByLibrary.simpleMessage(
      "Buy and apply a custom avatar icon.",
    ),
    "avatarShopEachAvatarPrice": m2,
    "avatarShopEquip": MessageLookupByLibrary.simpleMessage("Equip"),
    "avatarShopLoadFailed": m3,
    "avatarShopNeedCoins": m4,
    "avatarShopNotEnoughCoins": m5,
    "avatarShopPurchaseFailed": m6,
    "avatarShopPurchaseSuccess": MessageLookupByLibrary.simpleMessage(
      "Avatar purchased and applied successfully.",
    ),
    "avatarShopRefresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "avatarShopSelected": MessageLookupByLibrary.simpleMessage("Selected"),
    "avatarShopTitle": MessageLookupByLibrary.simpleMessage("Avatar Shop"),
    "avatarShopUnableToProcessPurchase": MessageLookupByLibrary.simpleMessage(
      "Unable to process purchase right now.",
    ),
    "badgeCommunityConnectorDescription": MessageLookupByLibrary.simpleMessage(
      "Trades with diverse partners (high diversity score).",
    ),
    "badgeCommunityConnectorTitle": MessageLookupByLibrary.simpleMessage(
      "Community Connector",
    ),
    "badgeDisputeFreeDescription": MessageLookupByLibrary.simpleMessage(
      "Has never had a disputed transaction.",
    ),
    "badgeDisputeFreeTitle": MessageLookupByLibrary.simpleMessage(
      "Dispute-Free History",
    ),
    "badgeEarnedStatus": MessageLookupByLibrary.simpleMessage("Earned"),
    "badgeFastTraderDescription": MessageLookupByLibrary.simpleMessage(
      "Completes trades faster than average.",
    ),
    "badgeFastTraderTitle": MessageLookupByLibrary.simpleMessage(
      "Fast & Reliable",
    ),
    "badgeIdentityVerifiedDescription": MessageLookupByLibrary.simpleMessage(
      "User has completed identity verification.",
    ),
    "badgeIdentityVerifiedTitle": MessageLookupByLibrary.simpleMessage(
      "Identity Verified",
    ),
    "badgeNotEarnedStatus": MessageLookupByLibrary.simpleMessage(
      "Not earned yet",
    ),
    "badgePremiumUserDescription": MessageLookupByLibrary.simpleMessage(
      "User has an active Premium subscription.",
    ),
    "badgePremiumUserTitle": MessageLookupByLibrary.simpleMessage(
      "Premium User",
    ),
    "badgeQuickResponderDescription": MessageLookupByLibrary.simpleMessage(
      "Usually responds within 24 hours.",
    ),
    "badgeQuickResponderTitle": MessageLookupByLibrary.simpleMessage(
      "Quick Responder",
    ),
    "badgeTop1000Description": MessageLookupByLibrary.simpleMessage(
      "User was among the first 1000 registered users.",
    ),
    "badgeTop1000Title": MessageLookupByLibrary.simpleMessage(
      "Early Adopter - First 1000 Users",
    ),
    "badgeTopRatedDescription": MessageLookupByLibrary.simpleMessage(
      "Maintains 4.8+ average rating with 50+ reviews.",
    ),
    "badgeTopRatedTitle": MessageLookupByLibrary.simpleMessage(
      "Top Rated Seller",
    ),
    "badgeVerifiedBusinessDescription": MessageLookupByLibrary.simpleMessage(
      "Favorited by 30+ Users.",
    ),
    "badgeVerifiedBusinessTitle": MessageLookupByLibrary.simpleMessage(
      "Local Legend",
    ),
    "badgeVeteranTraderDescription": MessageLookupByLibrary.simpleMessage(
      "User has completed 100+ successful trades.",
    ),
    "badgeVeteranTraderTitle": MessageLookupByLibrary.simpleMessage(
      "Veteran Trader",
    ),
    "badgesTitle": MessageLookupByLibrary.simpleMessage("Badges"),
    "barterCoinsInfoMessage": MessageLookupByLibrary.simpleMessage(
      "Coins can be earned by providing a service, or by actively using the app.\n\nCoins can be spent on: standing out on the map, boosting postings, custom Avatar icons, tipping other Users",
    ),
    "barterCoinsTitle": MessageLookupByLibrary.simpleMessage("Barter Coins"),
    "beSpecificAndConstructive": MessageLookupByLibrary.simpleMessage(
      "Be specific and constructive",
    ),
    "block": MessageLookupByLibrary.simpleMessage("Block"),
    "blockUser": MessageLookupByLibrary.simpleMessage("Block User"),
    "blockUserConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to block this user? You will no longer be able to communicate with them.",
    ),
    "blockUserConfirmationDetailed": m7,
    "bonusTipOptional": MessageLookupByLibrary.simpleMessage(
      "Bonus / Tip (optional)",
    ),
    "buyPremium": MessageLookupByLibrary.simpleMessage("Buy Premium"),
    "camera": MessageLookupByLibrary.simpleMessage("Camera"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cannotSendFileNoRecipientKey": MessageLookupByLibrary.simpleMessage(
      "Cannot send file: Recipient public key not available",
    ),
    "category": MessageLookupByLibrary.simpleMessage("Category"),
    "categoryActiveDescription": MessageLookupByLibrary.simpleMessage(
      "Sports, partying, dancing, active lifestyle, physical work, mechanisms",
    ),
    "categoryActiveTitle": MessageLookupByLibrary.simpleMessage(
      "Active & Social",
    ),
    "categoryArtsDescription": MessageLookupByLibrary.simpleMessage(
      "Art, spirituality, philosophy",
    ),
    "categoryArtsTitle": MessageLookupByLibrary.simpleMessage(
      "Arts & Philosophy",
    ),
    "categoryBusinessDescription": MessageLookupByLibrary.simpleMessage(
      "Strictly business, paid work, networking, money matters, networking",
    ),
    "categoryBusinessTitle": MessageLookupByLibrary.simpleMessage(
      "Business & Finance",
    ),
    "categoryCommDescription": MessageLookupByLibrary.simpleMessage(
      "Misc/Communication, Chat",
    ),
    "categoryCommTitle": MessageLookupByLibrary.simpleMessage(
      "Communication & Chat",
    ),
    "categoryCommunityDescription": MessageLookupByLibrary.simpleMessage(
      "Open to help out for free/non-specific exchange",
    ),
    "categoryCommunityTitle": MessageLookupByLibrary.simpleMessage(
      "Community & Volunteering",
    ),
    "categoryNatureDescription": MessageLookupByLibrary.simpleMessage(
      "Gardening, outdoors, forests, camping, environmentalism, cleanup, animals",
    ),
    "categoryNatureTitle": MessageLookupByLibrary.simpleMessage(
      "Nature & Outdoors",
    ),
    "categoryTechDescription": MessageLookupByLibrary.simpleMessage(
      "Technology, learning, innovation",
    ),
    "categoryTechTitle": MessageLookupByLibrary.simpleMessage(
      "Technology & Learning",
    ),
    "category_blue": MessageLookupByLibrary.simpleMessage(
      "Business, entrepreneurship, paid work, making contacts, money matters, finance, career",
    ),
    "category_green": MessageLookupByLibrary.simpleMessage(
      "Nature, outdoors, gardening, animals, environment, hiking, plants, sustainability",
    ),
    "category_orange": MessageLookupByLibrary.simpleMessage(
      "Volunteering, support, free items/skills exchange, consulting, assistance, community",
    ),
    "category_purple": MessageLookupByLibrary.simpleMessage(
      "Art, spirituality, philosophy, culture, music, crafts, creativity, design, history",
    ),
    "category_red": MessageLookupByLibrary.simpleMessage(
      "Sports, exercise, hands-on, active lifestyle, physical work, mechanisms, tools",
    ),
    "category_teal": MessageLookupByLibrary.simpleMessage(
      "Technology, learning, education, innovation, brainstorming, ideas, science, software",
    ),
    "category_yellow": MessageLookupByLibrary.simpleMessage(
      "Chat, social activities, casual conversation, local events, new contacts, communication",
    ),
    "changeSecurityQuestion": MessageLookupByLibrary.simpleMessage(
      "Change Security Question",
    ),
    "chat": MessageLookupByLibrary.simpleMessage("Chat"),
    "chatError_Offline": MessageLookupByLibrary.simpleMessage("User Offline"),
    "chatOpenFailed": MessageLookupByLibrary.simpleMessage(
      "Unable to open this chat right now. Please try again.",
    ),
    "chats": MessageLookupByLibrary.simpleMessage("Chats"),
    "chooseFromGallery": MessageLookupByLibrary.simpleMessage(
      "Choose from Device",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clearQuietHours": MessageLookupByLibrary.simpleMessage(
      "Clear Quiet Hours",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "closeLocations": MessageLookupByLibrary.simpleMessage("Close Locations"),
    "codeCopied": MessageLookupByLibrary.simpleMessage(
      "Migration code copied to clipboard",
    ),
    "codeSentTo": m8,
    "completeSetup": MessageLookupByLibrary.simpleMessage("Complete Setup"),
    "confirmPinLabel": MessageLookupByLibrary.simpleMessage("Confirm PIN"),
    "contactSupportForPinReset": MessageLookupByLibrary.simpleMessage(
      "Please contact support for PIN reset assistance",
    ),
    "contacts": MessageLookupByLibrary.simpleMessage("Contacts"),
    "continueAnyway": MessageLookupByLibrary.simpleMessage("Continue Anyway"),
    "continueButton": MessageLookupByLibrary.simpleMessage("Continue"),
    "conversationDeleted": MessageLookupByLibrary.simpleMessage(
      "Conversation deleted",
    ),
    "copiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "Copied to clipboard",
    ),
    "copyCode": MessageLookupByLibrary.simpleMessage("Copy Code"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Copy Link"),
    "couldNotFindChatParticipant": MessageLookupByLibrary.simpleMessage(
      "Could not find chat participant",
    ),
    "couldNotOpenFile": m9,
    "couldNotOpenFileGeneric": MessageLookupByLibrary.simpleMessage(
      "Could not open this file. Please try another app or check the file path.",
    ),
    "create5DigitPin": MessageLookupByLibrary.simpleMessage(
      "Create a 5-digit PIN",
    ),
    "createInterestPosting": MessageLookupByLibrary.simpleMessage(
      "Create Interest Posting",
    ),
    "createOfferPosting": MessageLookupByLibrary.simpleMessage(
      "Create Offer Posting",
    ),
    "createPosting": MessageLookupByLibrary.simpleMessage("Create Posting"),
    "createPostingBoost3Days": MessageLookupByLibrary.simpleMessage(
      "3 days (20 coins)",
    ),
    "createPostingBoost7Days": MessageLookupByLibrary.simpleMessage(
      "7 days (50 coins)",
    ),
    "createPostingBoostDescription": MessageLookupByLibrary.simpleMessage(
      "Spend coins to boost this posting in search results.",
    ),
    "createPostingBoostInsufficientCoins": MessageLookupByLibrary.simpleMessage(
      "Not enough coins for selected boost.",
    ),
    "createPostingBoostNone": MessageLookupByLibrary.simpleMessage("No boost"),
    "createPostingBoostTitle": MessageLookupByLibrary.simpleMessage(
      "Boost visibility",
    ),
    "createPreferences": MessageLookupByLibrary.simpleMessage(
      "Save Preferences",
    ),
    "createYourFirstWishlistItem": MessageLookupByLibrary.simpleMessage(
      "Create your first wishlist item to get notified when matches appear",
    ),
    "currentWalletBalance": m10,
    "daily": MessageLookupByLibrary.simpleMessage("Daily"),
    "dataExportEmailRequired": MessageLookupByLibrary.simpleMessage(
      "Please add an email in Notification Preferences before requesting data export.",
    ),
    "dataExportRequestAccepted": MessageLookupByLibrary.simpleMessage(
      "Your data export request has been accepted.",
    ),
    "dataExportRequestFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to request data export.",
    ),
    "decryptingFile": m11,
    "defaultSettings": MessageLookupByLibrary.simpleMessage("Default Settings"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteAll": MessageLookupByLibrary.simpleMessage("Delete All"),
    "deleteAllMatchesConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete all match history? This action cannot be undone.",
    ),
    "deleteConversation": MessageLookupByLibrary.simpleMessage(
      "Delete Conversation",
    ),
    "deleteConversationConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this conversation? All messages will be permanently removed.",
    ),
    "deletePosting": MessageLookupByLibrary.simpleMessage("Delete Posting"),
    "deletePostingConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this posting?",
    ),
    "deletePreference": MessageLookupByLibrary.simpleMessage(
      "Delete Preference",
    ),
    "deletePreferenceConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this preference?",
    ),
    "deleteProfile": MessageLookupByLibrary.simpleMessage("Delete Profile"),
    "deleteProfileConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete your profile? This action cannot be undone. All your data, postings, and conversations will be permanently removed.",
    ),
    "deleteWishlistItem": MessageLookupByLibrary.simpleMessage(
      "Delete Wishlist Item",
    ),
    "deleteWishlistItemConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this wishlist item?",
    ),
    "deny": MessageLookupByLibrary.simpleMessage("Deny"),
    "dismiss": MessageLookupByLibrary.simpleMessage("Dismiss"),
    "dismissMatch": MessageLookupByLibrary.simpleMessage("Dismiss Match"),
    "dismissMatchConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to dismiss this match?",
    ),
    "dismissed": MessageLookupByLibrary.simpleMessage("Dismissed"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "downloadFailed": m12,
    "downloadStarted": MessageLookupByLibrary.simpleMessage(
      "Download started! Check your downloads folder",
    ),
    "downloadingFile": m13,
    "drawer_menu_complementary_users": MessageLookupByLibrary.simpleMessage(
      "Find complementary users",
    ),
    "drawer_menu_favorite_users": MessageLookupByLibrary.simpleMessage(
      "Find favorite users",
    ),
    "drawer_menu_similar_users": MessageLookupByLibrary.simpleMessage(
      "Find similar users",
    ),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editKeywords": MessageLookupByLibrary.simpleMessage(
      "Edit Your Overall Interests",
    ),
    "editLocation": MessageLookupByLibrary.simpleMessage("Edit Location"),
    "editPosting": MessageLookupByLibrary.simpleMessage("Edit Posting"),
    "editPreference": MessageLookupByLibrary.simpleMessage("Edit Preference"),
    "editWishlistItem": MessageLookupByLibrary.simpleMessage(
      "Edit Wishlist Item",
    ),
    "emailAddress": MessageLookupByLibrary.simpleMessage("Email Address"),
    "emailHint": MessageLookupByLibrary.simpleMessage("example@email.com"),
    "emailInvalid": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email address",
    ),
    "emailNotificationPreferences": MessageLookupByLibrary.simpleMessage(
      "Email Notification Preferences",
    ),
    "emailRequired": MessageLookupByLibrary.simpleMessage(
      "Email address is required",
    ),
    "emailSaved": MessageLookupByLibrary.simpleMessage(
      "Email address saved successfully",
    ),
    "emailUnsubscribe": MessageLookupByLibrary.simpleMessage("Unsubscribe"),
    "emailUnsubscribed": MessageLookupByLibrary.simpleMessage(
      "Unsubscribed successfully",
    ),
    "emailUpdated": MessageLookupByLibrary.simpleMessage("Email updated"),
    "enableNotifications": MessageLookupByLibrary.simpleMessage(
      "Enable Notifications",
    ),
    "enableNotificationsDescription": MessageLookupByLibrary.simpleMessage(
      "Receive notifications for matches and updates",
    ),
    "endTime": MessageLookupByLibrary.simpleMessage("End Time"),
    "enterBonusAmount": MessageLookupByLibrary.simpleMessage(
      "Enter bonus amount",
    ),
    "enterNewPinDescription": MessageLookupByLibrary.simpleMessage(
      "Enter a new 5-digit PIN",
    ),
    "enterPinDescription": MessageLookupByLibrary.simpleMessage(
      "Enter your PIN to unlock the app",
    ),
    "enterPinTitle": MessageLookupByLibrary.simpleMessage("Enter PIN"),
    "enterYourAnswer": MessageLookupByLibrary.simpleMessage(
      "Enter your answer",
    ),
    "enterYourPin": MessageLookupByLibrary.simpleMessage("Enter Your PIN"),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "errorCreatingTransaction": m14,
    "errorCreatingWishlistItem": MessageLookupByLibrary.simpleMessage(
      "Error creating wishlist item",
    ),
    "errorDeletingConversation": MessageLookupByLibrary.simpleMessage(
      "Error deleting conversation",
    ),
    "errorDeletingProfile": MessageLookupByLibrary.simpleMessage(
      "Error deleting profile",
    ),
    "errorDeletingWishlistItem": MessageLookupByLibrary.simpleMessage(
      "Error deleting wishlist item",
    ),
    "errorDuringInitialization": MessageLookupByLibrary.simpleMessage(
      "Error during initialization.",
    ),
    "errorFindingLocation": m15,
    "errorLoadingAttributes": MessageLookupByLibrary.simpleMessage(
      "Error loading attributes",
    ),
    "errorLoadingChats": MessageLookupByLibrary.simpleMessage(
      "Error loading chats",
    ),
    "errorLoadingPostings": MessageLookupByLibrary.simpleMessage(
      "Error loading postings",
    ),
    "errorLoadingWishlist": MessageLookupByLibrary.simpleMessage(
      "Error loading wishlist",
    ),
    "errorOpeningFile": m16,
    "errorUpdatingFavorite": MessageLookupByLibrary.simpleMessage(
      "Error updating favorite",
    ),
    "errorUpdatingTransaction": m17,
    "errorUpdatingWishlistItem": MessageLookupByLibrary.simpleMessage(
      "Error updating wishlist item",
    ),
    "errorVerifyingPin": MessageLookupByLibrary.simpleMessage(
      "Error verifying PIN",
    ),
    "errorWithException": m18,
    "errorWithMessage": m19,
    "expirationDate": MessageLookupByLibrary.simpleMessage("Expiration Date"),
    "expired": MessageLookupByLibrary.simpleMessage("Expired"),
    "expires": MessageLookupByLibrary.simpleMessage("Expires"),
    "expiresIn": m20,
    "expiresPrefix": MessageLookupByLibrary.simpleMessage("Expires"),
    "eyes": MessageLookupByLibrary.simpleMessage("Eyes"),
    "failedToBlockUser": MessageLookupByLibrary.simpleMessage(
      "Failed to block user",
    ),
    "failedToJoinMigration": MessageLookupByLibrary.simpleMessage(
      "Failed to join migration session",
    ),
    "failedToProcessMigration": MessageLookupByLibrary.simpleMessage(
      "Failed to process migration data",
    ),
    "failedToSendCode": MessageLookupByLibrary.simpleMessage(
      "Failed to send recovery code",
    ),
    "failedToSendMigration": MessageLookupByLibrary.simpleMessage(
      "Failed to send migration data",
    ),
    "failedToSubmitAppeal": MessageLookupByLibrary.simpleMessage(
      "Failed to submit appeal",
    ),
    "failedToSubmitReport": MessageLookupByLibrary.simpleMessage(
      "Failed to submit report. Please try again.",
    ),
    "failedToSubmitReview": MessageLookupByLibrary.simpleMessage(
      "Failed to submit review",
    ),
    "failedToUnblockUser": MessageLookupByLibrary.simpleMessage(
      "Failed to unblock user",
    ),
    "falseReportsWarning": MessageLookupByLibrary.simpleMessage(
      "False reports may result in penalties to your account.",
    ),
    "fileDecryptKeyMissing": MessageLookupByLibrary.simpleMessage(
      "Cannot decrypt this file yet. Try again after the chat keys are synchronized.",
    ),
    "fileDownloadFailed": MessageLookupByLibrary.simpleMessage(
      "Unable to download this file right now. Please try again.",
    ),
    "fileNotFound": m21,
    "fileReadFailed": MessageLookupByLibrary.simpleMessage(
      "Could not read the selected file. Please try another file.",
    ),
    "fileSavedAt": m22,
    "fileSendFailed": MessageLookupByLibrary.simpleMessage(
      "Unable to send the file right now. Please try again.",
    ),
    "fileSentSuccessfully": MessageLookupByLibrary.simpleMessage(
      "File sent successfully!",
    ),
    "finishOnboarding": MessageLookupByLibrary.simpleMessage("Finish"),
    "finishTransaction": MessageLookupByLibrary.simpleMessage(
      "Finish Transaction",
    ),
    "finishTransactionConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to mark this transaction as completed?",
    ),
    "forgotPin": MessageLookupByLibrary.simpleMessage("Forgot PIN?"),
    "forgotPinSubtitle": MessageLookupByLibrary.simpleMessage(
      "Enter your email address to receive a PIN reset link.",
    ),
    "frequency": MessageLookupByLibrary.simpleMessage("Frequency"),
    "gallery": MessageLookupByLibrary.simpleMessage("Device"),
    "gdprConsentAccept": MessageLookupByLibrary.simpleMessage(
      "Continue (Accept Terms & Conditions)",
    ),
    "gdprConsentAiDescription": MessageLookupByLibrary.simpleMessage(
      "Analyze profile configuration to improve recommendations and relevance.",
    ),
    "gdprConsentAiLabel": MessageLookupByLibrary.simpleMessage(
      "Optional: AI-assisted matching",
    ),
    "gdprConsentDecline": MessageLookupByLibrary.simpleMessage("Not now"),
    "gdprConsentIntro": MessageLookupByLibrary.simpleMessage(
      "Before you continue, please review and choose how your data is processed.",
    ),
    "gdprConsentLocationDescription": MessageLookupByLibrary.simpleMessage(
      "Use your location to discover matching users nearby.",
    ),
    "gdprConsentLocationLabel": MessageLookupByLibrary.simpleMessage(
      "Optional: Location processing",
    ),
    "gdprConsentManageLater": MessageLookupByLibrary.simpleMessage(
      "You can change this later in Settings.",
    ),
    "gdprConsentRequiredDescription": MessageLookupByLibrary.simpleMessage(
      "Needed to create your account, match with users, and run secure messaging. This cannot be turned off.",
    ),
    "gdprConsentRequiredLabel": MessageLookupByLibrary.simpleMessage(
      "Required: Core service processing",
    ),
    "gdprConsentTitle": MessageLookupByLibrary.simpleMessage(
      "Privacy & Data Consent",
    ),
    "gdprCookiesAnalyticsDescription": MessageLookupByLibrary.simpleMessage(
      "Helps us understand usage and improve performance. These are only used if you allow them.",
    ),
    "gdprCookiesAnalyticsLabel": MessageLookupByLibrary.simpleMessage(
      "Optional analytics cookies",
    ),
    "gdprCookiesRequiredDescription": MessageLookupByLibrary.simpleMessage(
      "Needed for core web functionality: security, session handling, and storing preferences.",
    ),
    "gdprCookiesRequiredLabel": MessageLookupByLibrary.simpleMessage(
      "Required cookies",
    ),
    "gdprCookiesSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Cookies (Web)",
    ),
    "generateAvatar": MessageLookupByLibrary.simpleMessage("Generate Avatar"),
    "generateCryptoWallet": MessageLookupByLibrary.simpleMessage(
      "Generate Crypto Wallet",
    ),
    "generateMigrationCode": MessageLookupByLibrary.simpleMessage(
      "Generate Migration Code",
    ),
    "generateNewCode": MessageLookupByLibrary.simpleMessage(
      "Generate New Code",
    ),
    "generateWallet": MessageLookupByLibrary.simpleMessage("Generate Wallet"),
    "generating": MessageLookupByLibrary.simpleMessage("Generating..."),
    "getStarted": MessageLookupByLibrary.simpleMessage("Get Started"),
    "goBack": MessageLookupByLibrary.simpleMessage("Go Back"),
    "googleSignInNotImplemented": MessageLookupByLibrary.simpleMessage(
      "Google Sign-In not implemented.",
    ),
    "gpsLocationDisabled": MessageLookupByLibrary.simpleMessage(
      "GPS location is disabled. Enable it in Settings to use this feature.",
    ),
    "guideline90Days": MessageLookupByLibrary.simpleMessage(
      "You have 90 days to submit a review",
    ),
    "guidelineFalseReports": MessageLookupByLibrary.simpleMessage(
      "False reports may result in account suspension",
    ),
    "guidelineFocusExperience": MessageLookupByLibrary.simpleMessage(
      "Focus on your actual experience",
    ),
    "guidelineHonest": MessageLookupByLibrary.simpleMessage(
      "Be honest and fair",
    ),
    "guidelineVisibility": MessageLookupByLibrary.simpleMessage(
      "Reviews become visible after both parties submit",
    ),
    "hairColor": MessageLookupByLibrary.simpleMessage("Hair Color"),
    "hairStyle": MessageLookupByLibrary.simpleMessage("Hair Style"),
    "howDidItGo": MessageLookupByLibrary.simpleMessage("How did it go? *"),
    "howItWorks": MessageLookupByLibrary.simpleMessage("How It Works"),
    "importAccount": MessageLookupByLibrary.simpleMessage("Import Account"),
    "importAccountDescription": MessageLookupByLibrary.simpleMessage(
      "Enter the 10-character migration code from your other device to import your account data.",
    ),
    "importExistingAccount": MessageLookupByLibrary.simpleMessage(
      "Import Existing Account",
    ),
    "inAppFailedToInitializePurchases": MessageLookupByLibrary.simpleMessage(
      "Failed to initialize purchases",
    ),
    "inAppFailedToLoadOfferings": MessageLookupByLibrary.simpleMessage(
      "Failed to load offerings",
    ),
    "inAppNoActivePremiumPurchasesToRestore":
        MessageLookupByLibrary.simpleMessage(
          "No active Premium purchases found to restore.",
        ),
    "inAppNoPremiumPackagesAvailable": MessageLookupByLibrary.simpleMessage(
      "No premium packages available right now.",
    ),
    "inAppPremiumActivatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Premium activated successfully.",
    ),
    "inAppPremiumRestoredSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Premium restored successfully.",
    ),
    "inAppPurchaseCancelled": MessageLookupByLibrary.simpleMessage(
      "Purchase cancelled.",
    ),
    "inAppPurchaseCompletedEntitlementNotActiveYet":
        MessageLookupByLibrary.simpleMessage(
          "Purchase completed, but entitlement not active yet.",
        ),
    "inAppPurchaseFailed": MessageLookupByLibrary.simpleMessage(
      "Purchase failed",
    ),
    "inAppRestoreFailed": MessageLookupByLibrary.simpleMessage(
      "Restore failed",
    ),
    "inAppRevenueCatApiKeyMissing": MessageLookupByLibrary.simpleMessage(
      "RevenueCat API key is missing.",
    ),
    "instant": MessageLookupByLibrary.simpleMessage("Instant"),
    "interest": MessageLookupByLibrary.simpleMessage("Interest"),
    "invalidCode": MessageLookupByLibrary.simpleMessage(
      "Invalid recovery code",
    ),
    "inviteMessageShare": m23,
    "inviteMessageSubject": MessageLookupByLibrary.simpleMessage(
      "Join me on BarterApp!",
    ),
    "keep": MessageLookupByLibrary.simpleMessage("Keep"),
    "languageEnglish": MessageLookupByLibrary.simpleMessage("English"),
    "languageFrench": MessageLookupByLibrary.simpleMessage("Français"),
    "languageGerman": MessageLookupByLibrary.simpleMessage("Deutsch"),
    "languageLatvian": MessageLookupByLibrary.simpleMessage("Latviešu"),
    "languageSpanish": MessageLookupByLibrary.simpleMessage("Español"),
    "lastOnlineDaysAgo": m24,
    "lastOnlineHoursAgo": m25,
    "lastOnlineJustNow": MessageLookupByLibrary.simpleMessage("just now"),
    "lastOnlineMinutesAgo": m26,
    "lastOnlinePrefix": MessageLookupByLibrary.simpleMessage("Last online:"),
    "lastOnlineUnknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "linkCopiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "Link copied to clipboard!",
    ),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "loadingWalletBalance": MessageLookupByLibrary.simpleMessage(
      "Loading wallet balance...",
    ),
    "locationNotFound": MessageLookupByLibrary.simpleMessage(
      "Location not found.",
    ),
    "locationPermissionRequiredDescription": MessageLookupByLibrary.simpleMessage(
      "Location permission is required to use GPS location tracking. Please enable location permission in your device settings.",
    ),
    "locationSaved": MessageLookupByLibrary.simpleMessage("Location saved!"),
    "locationSetAtMarkerInfo": MessageLookupByLibrary.simpleMessage(
      "Your location will be set at the marker location",
    ),
    "locations": MessageLookupByLibrary.simpleMessage("Locations"),
    "lookingFor": MessageLookupByLibrary.simpleMessage("Looking For"),
    "managePostings": MessageLookupByLibrary.simpleMessage("Manage Postings"),
    "manageSecurityQuestion": MessageLookupByLibrary.simpleMessage(
      "Manage Security Question",
    ),
    "manual": MessageLookupByLibrary.simpleMessage("Manual"),
    "markAsFulfilled": MessageLookupByLibrary.simpleMessage(
      "Mark as Fulfilled",
    ),
    "markAsViewed": MessageLookupByLibrary.simpleMessage("Mark as Viewed"),
    "marketingConsentDescription": MessageLookupByLibrary.simpleMessage(
      "We may send you occasional emails about our services. You can unsubscribe at any time.",
    ),
    "marketingConsentLabel": MessageLookupByLibrary.simpleMessage(
      "I agree to receive emails about new matches, offers, and updates",
    ),
    "match": MessageLookupByLibrary.simpleMessage("Match"),
    "matchDismissed": MessageLookupByLibrary.simpleMessage("Match dismissed"),
    "matchHistory": MessageLookupByLibrary.simpleMessage("Match History"),
    "matchLabel": MessageLookupByLibrary.simpleMessage("Match:"),
    "matchScore": MessageLookupByLibrary.simpleMessage("Match Score"),
    "matches": MessageLookupByLibrary.simpleMessage("Matches"),
    "matchingPostingsFound": m27,
    "matchingUsersFound": m28,
    "maxImagesReached": MessageLookupByLibrary.simpleMessage(
      "Maximum 3 images allowed",
    ),
    "migrateToNewDevice": MessageLookupByLibrary.simpleMessage(
      "Migrate to New Device",
    ),
    "migrateYourAccount": MessageLookupByLibrary.simpleMessage(
      "Migrate Your Account",
    ),
    "migrationCodeDescription": MessageLookupByLibrary.simpleMessage(
      "Generate a migration code to transfer your account data to a new device. The code will be valid for 15 minutes.",
    ),
    "migrationCodeExpired": MessageLookupByLibrary.simpleMessage(
      "Migration code has expired. Please generate a new one.",
    ),
    "migrationCompleted": MessageLookupByLibrary.simpleMessage(
      "Migration completed successfully!",
    ),
    "migrationDenied": MessageLookupByLibrary.simpleMessage(
      "Migration denied by user",
    ),
    "migrationStep1": MessageLookupByLibrary.simpleMessage(
      "Generate a migration code",
    ),
    "migrationStep2": MessageLookupByLibrary.simpleMessage(
      "Open the app on your new device",
    ),
    "migrationStep3": MessageLookupByLibrary.simpleMessage(
      "Tap \"Import Existing Account\" on the welcome screen",
    ),
    "migrationStep4": MessageLookupByLibrary.simpleMessage(
      "Enter this code on the new device",
    ),
    "migrationTimedOut": MessageLookupByLibrary.simpleMessage(
      "Migration timed out. Please try again with a new code.",
    ),
    "minMatchScore": MessageLookupByLibrary.simpleMessage("Min. Match Score"),
    "mockPoiNotFound": m29,
    "mockPoiNotFoundForUpdate": m30,
    "mouth": MessageLookupByLibrary.simpleMessage("Mouth"),
    "myWishlist": MessageLookupByLibrary.simpleMessage("My Wishlist"),
    "nearbyUsersAlertCheckboxSubtitle": MessageLookupByLibrary.simpleMessage(
      "We’ll send an alert when enough users appear in your area.",
    ),
    "nearbyUsersAlertCheckboxTitle": m31,
    "nearbyUsersAlertDisabled": MessageLookupByLibrary.simpleMessage(
      "Nearby users alert disabled.",
    ),
    "nearbyUsersAlertEnabled": MessageLookupByLibrary.simpleMessage(
      "Nearby users alert enabled.",
    ),
    "nearbyUsersAlertLoading": MessageLookupByLibrary.simpleMessage(
      "Checking alert preference...",
    ),
    "nearbyUsersAlertManageDelivery": MessageLookupByLibrary.simpleMessage(
      "Manage where nearby-user alerts are delivered.",
    ),
    "nearbyUsersAlertSaveError": MessageLookupByLibrary.simpleMessage(
      "Unable to update nearby users alert right now.",
    ),
    "need": MessageLookupByLibrary.simpleMessage("Need"),
    "newBadge": MessageLookupByLibrary.simpleMessage("NEW"),
    "newDeviceDetected": MessageLookupByLibrary.simpleMessage(
      "New Device Detected",
    ),
    "newDeviceDetectedMessage": MessageLookupByLibrary.simpleMessage(
      "A new device wants to import your account data. Do you want to allow this?",
    ),
    "newPostings": MessageLookupByLibrary.simpleMessage("New Postings"),
    "newUsers": MessageLookupByLibrary.simpleMessage("New Users"),
    "ninetyNinePlus": MessageLookupByLibrary.simpleMessage("99+"),
    "noActivePostings": MessageLookupByLibrary.simpleMessage(
      "No active postings",
    ),
    "noAppToOpenFile": MessageLookupByLibrary.simpleMessage(
      "No app found to open this file type",
    ),
    "noAttributePreferences": MessageLookupByLibrary.simpleMessage(
      "No attribute preferences",
    ),
    "noAttributesInProfile": MessageLookupByLibrary.simpleMessage(
      "Add interests and skills to your profile first",
    ),
    "noAttributesToDisplay": MessageLookupByLibrary.simpleMessage(
      "No attributes to display.",
    ),
    "noBadgesEarnedYet": MessageLookupByLibrary.simpleMessage(
      "No badges earned yet. Keep trading to unlock badges.",
    ),
    "noChatsYet": MessageLookupByLibrary.simpleMessage("No chats yet"),
    "noContactsFound": MessageLookupByLibrary.simpleMessage(
      "No contacts found",
    ),
    "noMatchesYet": MessageLookupByLibrary.simpleMessage("No matches yet"),
    "noMessagesYet": MessageLookupByLibrary.simpleMessage("No messages yet"),
    "noPostingsFound": MessageLookupByLibrary.simpleMessage(
      "No postings found",
    ),
    "noPushTokens": MessageLookupByLibrary.simpleMessage(
      "No push notification tokens registered",
    ),
    "noSecurityQuestion": MessageLookupByLibrary.simpleMessage(
      "No security question configured",
    ),
    "noSecurityQuestionSet": MessageLookupByLibrary.simpleMessage(
      "No security question set up",
    ),
    "noUnviewedMatches": MessageLookupByLibrary.simpleMessage(
      "No unviewed matches",
    ),
    "noUsersFound": MessageLookupByLibrary.simpleMessage("No users found"),
    "noUsersNearbyMessage": MessageLookupByLibrary.simpleMessage(
      "Your area is currently still growing. Invite people you know and help grow the community — your first referral earns 50 coins!",
    ),
    "noUsersNearbyTitle": MessageLookupByLibrary.simpleMessage(
      "No Users Nearby",
    ),
    "noWishlistItems": MessageLookupByLibrary.simpleMessage(
      "No wishlist items yet",
    ),
    "nose": MessageLookupByLibrary.simpleMessage("Nose"),
    "notSet": MessageLookupByLibrary.simpleMessage("Not set"),
    "notVerified": MessageLookupByLibrary.simpleMessage("Not Verified"),
    "notificationEmailConfigured": m32,
    "notificationEmailInvalid": MessageLookupByLibrary.simpleMessage(
      "Enter a valid email address.",
    ),
    "notificationEmailLabel": MessageLookupByLibrary.simpleMessage(
      "Email address",
    ),
    "notificationEmailRequired": MessageLookupByLibrary.simpleMessage(
      "Enter an email address.",
    ),
    "notificationEmailSave": MessageLookupByLibrary.simpleMessage("Save email"),
    "notificationEmailSaveError": MessageLookupByLibrary.simpleMessage(
      "Unable to save notification email right now.",
    ),
    "notificationEmailSaved": MessageLookupByLibrary.simpleMessage(
      "Notification email saved.",
    ),
    "notificationEmailSubtitle": MessageLookupByLibrary.simpleMessage(
      "Add an email address so we can notify you even if push notifications are unavailable.",
    ),
    "notificationEmailTitle": MessageLookupByLibrary.simpleMessage(
      "E-mail where to receive the notification",
    ),
    "notificationPreferences": MessageLookupByLibrary.simpleMessage(
      "Notification Preferences",
    ),
    "notificationSettings": MessageLookupByLibrary.simpleMessage(
      "Notification Settings",
    ),
    "notifyOnNewPostings": MessageLookupByLibrary.simpleMessage(
      "Notify on new postings",
    ),
    "notifyOnNewUsers": MessageLookupByLibrary.simpleMessage(
      "Notify on new users",
    ),
    "offer": MessageLookupByLibrary.simpleMessage("Offer"),
    "offering": MessageLookupByLibrary.simpleMessage("Offering"),
    "offers": MessageLookupByLibrary.simpleMessage("Offers"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "onboardingScreenQuestion": MessageLookupByLibrary.simpleMessage(
      "How much are you interested in this?",
    ),
    "onboardingScreenTitle": MessageLookupByLibrary.simpleMessage("Onboarding"),
    "openSettings": MessageLookupByLibrary.simpleMessage("Open Settings"),
    "optionalField": MessageLookupByLibrary.simpleMessage("Optional"),
    "or": MessageLookupByLibrary.simpleMessage("OR"),
    "other": MessageLookupByLibrary.simpleMessage("Other"),
    "pauseWishlist": MessageLookupByLibrary.simpleMessage("Pause"),
    "permissionDeniedOpenFile": MessageLookupByLibrary.simpleMessage(
      "Permission denied to open file",
    ),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "phoneUpdated": MessageLookupByLibrary.simpleMessage("Phone updated"),
    "pickYourLocation": MessageLookupByLibrary.simpleMessage(
      "Pick your location",
    ),
    "pinErrorEmpty": MessageLookupByLibrary.simpleMessage("Please enter a PIN"),
    "pinErrorIncorrect": m33,
    "pinErrorMismatch": MessageLookupByLibrary.simpleMessage(
      "PINs do not match",
    ),
    "pinErrorTooShort": MessageLookupByLibrary.simpleMessage(
      "PIN must be at least 4 digits",
    ),
    "pinHint": MessageLookupByLibrary.simpleMessage("Enter 4-6 digits"),
    "pinLabel": MessageLookupByLibrary.simpleMessage("PIN"),
    "pinResetSuccess": MessageLookupByLibrary.simpleMessage(
      "Your PIN has been successfully reset.",
    ),
    "pinResetSuccessfully": MessageLookupByLibrary.simpleMessage(
      "PIN reset successfully",
    ),
    "pinSetSuccessfully": MessageLookupByLibrary.simpleMessage(
      "PIN set successfully",
    ),
    "pinSetupDescription": MessageLookupByLibrary.simpleMessage(
      "Please set up a 5-digit PIN for security",
    ),
    "pleaseEnter5DigitPin": MessageLookupByLibrary.simpleMessage(
      "Please enter a 5-digit PIN.",
    ),
    "pleaseEnterAnswer": MessageLookupByLibrary.simpleMessage(
      "Please enter your answer",
    ),
    "pleaseEnterTitle": MessageLookupByLibrary.simpleMessage(
      "Please enter a title",
    ),
    "pleaseEnterValidEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email.",
    ),
    "pleaseEnterValidEmailAddress": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email address",
    ),
    "pleaseSelectAtLeastOneInterest": MessageLookupByLibrary.simpleMessage(
      "Please select at least one interest or add a custom keyword",
    ),
    "pleaseSelectAtLeastOneOffer": MessageLookupByLibrary.simpleMessage(
      "Please select at least one offer or add a custom keyword",
    ),
    "pleaseSelectLocationFirst": MessageLookupByLibrary.simpleMessage(
      "Please select a location first.",
    ),
    "pleaseSelectQuestion": MessageLookupByLibrary.simpleMessage(
      "Please select a security question",
    ),
    "pointsOfInterest": MessageLookupByLibrary.simpleMessage(
      "Points of Interest",
    ),
    "postedPrefix": MessageLookupByLibrary.simpleMessage("Posted"),
    "posting": MessageLookupByLibrary.simpleMessage("Posting"),
    "postingCreatedSuccess": MessageLookupByLibrary.simpleMessage(
      "Posting created successfully!",
    ),
    "postingDeleted": MessageLookupByLibrary.simpleMessage(
      "Posting deleted successfully",
    ),
    "postingDescription": MessageLookupByLibrary.simpleMessage("Description"),
    "postingDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "Detailed description of what you\'re offering or looking for",
    ),
    "postingDescriptionRequired": MessageLookupByLibrary.simpleMessage(
      "Description is required",
    ),
    "postingDescriptionTooShort": MessageLookupByLibrary.simpleMessage(
      "Description must be at least 10 characters",
    ),
    "postingImages": MessageLookupByLibrary.simpleMessage("Images"),
    "postingImagesHint": MessageLookupByLibrary.simpleMessage(
      "Add up to 3 images (optional)",
    ),
    "postingMatch": MessageLookupByLibrary.simpleMessage("Posting Match"),
    "postingTitle": MessageLookupByLibrary.simpleMessage("Title"),
    "postingTitleHint": MessageLookupByLibrary.simpleMessage(
      "Brief title for your posting",
    ),
    "postingTitleRequired": MessageLookupByLibrary.simpleMessage(
      "Title is required",
    ),
    "postingTitleTooShort": MessageLookupByLibrary.simpleMessage(
      "Title must be at least 3 characters",
    ),
    "postingUpdatedSuccess": MessageLookupByLibrary.simpleMessage(
      "Posting updated successfully",
    ),
    "postingValue": MessageLookupByLibrary.simpleMessage("Value (Optional)"),
    "postingValueHint": MessageLookupByLibrary.simpleMessage("Estimated value"),
    "postingValueInvalid": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid positive number",
    ),
    "postings": MessageLookupByLibrary.simpleMessage("Postings"),
    "preferenceDeleted": MessageLookupByLibrary.simpleMessage(
      "Preference deleted",
    ),
    "preferenceUpdated": MessageLookupByLibrary.simpleMessage(
      "Preference updated",
    ),
    "preferencesCreated": MessageLookupByLibrary.simpleMessage(
      "Notification preferences saved",
    ),
    "premiumProfileEditorAddImage": MessageLookupByLibrary.simpleMessage(
      "Add image",
    ),
    "premiumProfileEditorAvatarSvg": MessageLookupByLibrary.simpleMessage(
      "Avatar (.svg)",
    ),
    "premiumProfileEditorDescription": MessageLookupByLibrary.simpleMessage(
      "Here you can update your name, description, work references, and avatar SVG.",
    ),
    "premiumProfileEditorDescriptionOptional":
        MessageLookupByLibrary.simpleMessage("Description (optional)"),
    "premiumProfileEditorDisplayNameOptional":
        MessageLookupByLibrary.simpleMessage("Display name (optional)"),
    "premiumProfileEditorHeader": MessageLookupByLibrary.simpleMessage(
      "Customize your premium profile",
    ),
    "premiumProfileEditorNoAvatarSvgSelected":
        MessageLookupByLibrary.simpleMessage("No avatar SVG selected."),
    "premiumProfileEditorNoWorkReferenceImages":
        MessageLookupByLibrary.simpleMessage("No work reference images yet."),
    "premiumProfileEditorRemoveSvg": MessageLookupByLibrary.simpleMessage(
      "Remove SVG",
    ),
    "premiumProfileEditorReplace": MessageLookupByLibrary.simpleMessage(
      "Replace",
    ),
    "premiumProfileEditorSaving": MessageLookupByLibrary.simpleMessage(
      "Saving...",
    ),
    "premiumProfileEditorSelectedFile": m34,
    "premiumProfileEditorTitle": MessageLookupByLibrary.simpleMessage(
      "Premium Profile Editor",
    ),
    "premiumProfileEditorUploadSvg": MessageLookupByLibrary.simpleMessage(
      "Upload SVG",
    ),
    "premiumProfileEditorWorkReferenceDescription":
        MessageLookupByLibrary.simpleMessage(
          "Add and manage your reference images.",
        ),
    "premiumProfileEditorWorkReferenceImages":
        MessageLookupByLibrary.simpleMessage("Work reference images"),
    "premiumUserBenefitsMessage": MessageLookupByLibrary.simpleMessage(
      "Unlock Premium to get these benefits:\n• Edit your name\n• Edit your profile description\n• Edit your Avatar icon\n• Add images as work references\n• Stand out on the map\n• Have a limit of more than 3 active postings",
    ),
    "premiumUserBenefitsTitle": MessageLookupByLibrary.simpleMessage(
      "Premium User Benefits",
    ),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "privacyPolicyChangesContent": MessageLookupByLibrary.simpleMessage(
      "We may update this policy from time to time. Material changes should be communicated in-app or via another appropriate channel, with updated effective dates.",
    ),
    "privacyPolicyChangesTitle": MessageLookupByLibrary.simpleMessage(
      "Changes to This Policy",
    ),
    "privacyPolicyContactContent": MessageLookupByLibrary.simpleMessage(
      "For privacy and GDPR requests, contact: info@bartering.app",
    ),
    "privacyPolicyContactTitle": MessageLookupByLibrary.simpleMessage(
      "Contact",
    ),
    "privacyPolicyDataCollectionContent": MessageLookupByLibrary.simpleMessage(
      "We may process account/authentication data (including signature metadata), profile data, postings and chat-related data, notification data (email, push tokens, consent flags), security/compliance records, and technical request metadata.",
    ),
    "privacyPolicyDataCollectionTitle": MessageLookupByLibrary.simpleMessage(
      "Data We Process",
    ),
    "privacyPolicyDataSecurityContent": MessageLookupByLibrary.simpleMessage(
      "We apply measures such as authenticated request-signature checks, access controls, transport security, and audit logging. Retention controls and scheduled cleanup are used for operational/compliance records, with legal-hold-aware handling where required.",
    ),
    "privacyPolicyDataSecurityTitle": MessageLookupByLibrary.simpleMessage(
      "Security, Retention and Deletion",
    ),
    "privacyPolicyDataSharingContent": MessageLookupByLibrary.simpleMessage(
      "Current integrations include PostgreSQL, Mailjet, Firebase/FCM, Ollama, and Nginx + Docker infrastructure. Optional federation peers are used only when enabled and trusted. If data is processed outside your country/EEA, legally required safeguards (such as SCCs) are applied.",
    ),
    "privacyPolicyDataSharingTitle": MessageLookupByLibrary.simpleMessage(
      "Processors, Infrastructure and Transfers",
    ),
    "privacyPolicyDataUsageContent": MessageLookupByLibrary.simpleMessage(
      "Processing supports service delivery (Art. 6(1)(b)), security and abuse prevention (Art. 6(1)(f)), and legal/compliance obligations (Art. 6(1)(c), 6(1)(f)). Where applicable, optional features and consents are processed under Art. 6(1)(a).",
    ),
    "privacyPolicyDataUsageTitle": MessageLookupByLibrary.simpleMessage(
      "Purposes and GDPR Legal Bases",
    ),
    "privacyPolicyIntroContent": MessageLookupByLibrary.simpleMessage(
      "This policy explains how Barter backend services and connected mobile/web clients process personal data. It covers backend APIs, client apps, admin/compliance tooling, and optional federation features when enabled.",
    ),
    "privacyPolicyIntroTitle": MessageLookupByLibrary.simpleMessage(
      "Controller, Scope and Contact",
    ),
    "privacyPolicyLastUpdated": MessageLookupByLibrary.simpleMessage(
      "Last updated: 2026-04-13",
    ),
    "privacyPolicyThirdPartyContent": MessageLookupByLibrary.simpleMessage(
      "This in-app text summarizes backend-centric processing and should be read together with client-facing app notices (permissions, identifiers, push UX, and local storage/cookies where applicable).",
    ),
    "privacyPolicyThirdPartyTitle": MessageLookupByLibrary.simpleMessage(
      "Backend and Client Privacy Notice",
    ),
    "privacyPolicyUserRightsContent": MessageLookupByLibrary.simpleMessage(
      "Subject to applicable law, you may request access, rectification, erasure, restriction, portability, objection, and consent withdrawal. Authenticated deletion/export workflows include legal-hold checks, DSAR tracking, and compliance event logging.",
    ),
    "privacyPolicyUserRightsTitle": MessageLookupByLibrary.simpleMessage(
      "Your Rights, Erasure and Portability",
    ),
    "privateKey": MessageLookupByLibrary.simpleMessage("Private Key"),
    "profileDeleted": MessageLookupByLibrary.simpleMessage(
      "Profile deleted successfully",
    ),
    "profilePanelTitle": MessageLookupByLibrary.simpleMessage("Profile"),
    "provideMoreContext": MessageLookupByLibrary.simpleMessage(
      "Provide more context...",
    ),
    "publicKey": MessageLookupByLibrary.simpleMessage("Public Key"),
    "purchaseCoins": MessageLookupByLibrary.simpleMessage("Purchase coins"),
    "purchaseCoinsFlowComingSoon": MessageLookupByLibrary.simpleMessage(
      "Purchase coins flow coming soon",
    ),
    "pushNotifications": MessageLookupByLibrary.simpleMessage(
      "Push Notifications",
    ),
    "pushTokenRemoved": MessageLookupByLibrary.simpleMessage(
      "Push token removed",
    ),
    "questionsAnswered": m35,
    "quietHours": MessageLookupByLibrary.simpleMessage("Quiet Hours"),
    "quietHoursDescription": MessageLookupByLibrary.simpleMessage(
      "Do not send notifications during these hours",
    ),
    "randomize": MessageLookupByLibrary.simpleMessage("Randomize"),
    "ratingAndReviews": MessageLookupByLibrary.simpleMessage(
      "Rating and Reviews",
    ),
    "ratingExcellent": MessageLookupByLibrary.simpleMessage("Excellent"),
    "ratingGood": MessageLookupByLibrary.simpleMessage("Good"),
    "ratingOkay": MessageLookupByLibrary.simpleMessage("Okay"),
    "ratingPoor": MessageLookupByLibrary.simpleMessage("Poor"),
    "ratingRequired": MessageLookupByLibrary.simpleMessage("Rating *"),
    "ratingVeryBad": MessageLookupByLibrary.simpleMessage("Very Bad"),
    "recommendations": MessageLookupByLibrary.simpleMessage("Recommendations:"),
    "recoverAccount": MessageLookupByLibrary.simpleMessage("Recover Account"),
    "recoverAccountDescription": MessageLookupByLibrary.simpleMessage(
      "Enter your email address to receive a recovery code and restore your account on this device.",
    ),
    "recoverViaEmail": MessageLookupByLibrary.simpleMessage(
      "Recover via Email",
    ),
    "recoveryFailed": MessageLookupByLibrary.simpleMessage(
      "Account recovery failed",
    ),
    "recoverySuccess": MessageLookupByLibrary.simpleMessage(
      "Recovery Successful!",
    ),
    "recoverySuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Your account has been successfully recovered on this device.",
    ),
    "relevancy": MessageLookupByLibrary.simpleMessage("Relevancy"),
    "remove": MessageLookupByLibrary.simpleMessage("Remove"),
    "removePushToken": MessageLookupByLibrary.simpleMessage(
      "Remove Push Token",
    ),
    "removePushTokenConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to remove this push token?",
    ),
    "report": MessageLookupByLibrary.simpleMessage("Report"),
    "reportReason": MessageLookupByLibrary.simpleMessage(
      "Reason for report (optional)",
    ),
    "reportReasonFakeProfile": MessageLookupByLibrary.simpleMessage(
      "Fake Profile",
    ),
    "reportReasonHarassment": MessageLookupByLibrary.simpleMessage(
      "Harassment",
    ),
    "reportReasonImpersonation": MessageLookupByLibrary.simpleMessage(
      "Impersonation",
    ),
    "reportReasonInappropriateContent": MessageLookupByLibrary.simpleMessage(
      "Inappropriate Content",
    ),
    "reportReasonOther": MessageLookupByLibrary.simpleMessage("Other"),
    "reportReasonScam": MessageLookupByLibrary.simpleMessage("Scam"),
    "reportReasonSpam": MessageLookupByLibrary.simpleMessage("Spam"),
    "reportReasonThreateningBehavior": MessageLookupByLibrary.simpleMessage(
      "Threatening Behavior",
    ),
    "reportScam": MessageLookupByLibrary.simpleMessage("Report Scam"),
    "reportScamConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to report this user for scam?",
    ),
    "reportScamConsequence1": MessageLookupByLibrary.simpleMessage(
      "• Flag this transaction for moderator review",
    ),
    "reportScamConsequence2": MessageLookupByLibrary.simpleMessage(
      "• Potentially suspend the other user",
    ),
    "reportScamConsequence3": MessageLookupByLibrary.simpleMessage(
      "• Require evidence from you",
    ),
    "reportScamConsequencesTitle": MessageLookupByLibrary.simpleMessage(
      "This will:",
    ),
    "reportSubmittedOfferBlock": MessageLookupByLibrary.simpleMessage(
      "Thank you for helping keep the community safe. Would you also like to block this user?",
    ),
    "reportUser": MessageLookupByLibrary.simpleMessage("Report User"),
    "reportUserConfirmation": MessageLookupByLibrary.simpleMessage(
      "Please provide a reason for reporting this user.",
    ),
    "reportUserTitle": m36,
    "requestCollectedDataExport": MessageLookupByLibrary.simpleMessage(
      "Request collected data export",
    ),
    "resendCode": MessageLookupByLibrary.simpleMessage("Resend Code"),
    "resendCodeIn": m37,
    "resetLinkSentMessage": MessageLookupByLibrary.simpleMessage(
      "If an account exists, a reset link has been sent.",
    ),
    "resetYourPin": MessageLookupByLibrary.simpleMessage("Reset Your PIN"),
    "restorePurchases": MessageLookupByLibrary.simpleMessage(
      "Restore Purchases",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "review": MessageLookupByLibrary.simpleMessage("Review"),
    "reviewGuidelines": MessageLookupByLibrary.simpleMessage(
      "Review Guidelines",
    ),
    "reviewSubmitted": MessageLookupByLibrary.simpleMessage(
      "Review Submitted!",
    ),
    "reviewUser": m38,
    "reviewVisibilityNotice": MessageLookupByLibrary.simpleMessage(
      "Your review will be visible after the other User submits their review, or in 14 days.",
    ),
    "reviewsCount": m39,
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "saveAndContinue": MessageLookupByLibrary.simpleMessage("Save & Continue"),
    "saveEmail": MessageLookupByLibrary.simpleMessage("Save Email"),
    "saveLocation": MessageLookupByLibrary.simpleMessage("Save Location"),
    "saveSecurityQuestion": MessageLookupByLibrary.simpleMessage(
      "Save Security Question",
    ),
    "searchForAKeyword": MessageLookupByLibrary.simpleMessage(
      "Search for a keyword",
    ),
    "searchForALocation": MessageLookupByLibrary.simpleMessage(
      "Search for a location",
    ),
    "securityAnswerIncorrect": m40,
    "securityAnswerNote": MessageLookupByLibrary.simpleMessage(
      "Note: Answers are case-insensitive",
    ),
    "securityCheck": MessageLookupByLibrary.simpleMessage("Security Check"),
    "securityCheckMessage": MessageLookupByLibrary.simpleMessage(
      "Everything looks good!",
    ),
    "securityNotice": MessageLookupByLibrary.simpleMessage("Security Notice"),
    "securityNoticeMessage": MessageLookupByLibrary.simpleMessage(
      "We\'ve detected some unusual patterns. Your review may be subject to additional verification.",
    ),
    "securityQuestion1": MessageLookupByLibrary.simpleMessage(
      "What was the name of your first pet?",
    ),
    "securityQuestion2": MessageLookupByLibrary.simpleMessage(
      "What city were you born in?",
    ),
    "securityQuestion3": MessageLookupByLibrary.simpleMessage(
      "What is your mother\'s maiden name?",
    ),
    "securityQuestion4": MessageLookupByLibrary.simpleMessage(
      "What was the name of your elementary school?",
    ),
    "securityQuestion5": MessageLookupByLibrary.simpleMessage(
      "What is your favorite book?",
    ),
    "securityQuestionDescription": MessageLookupByLibrary.simpleMessage(
      "Set up a security question to help recover your PIN if you forget it",
    ),
    "securityQuestionSaved": MessageLookupByLibrary.simpleMessage(
      "Security question saved successfully",
    ),
    "securityQuestionSet": MessageLookupByLibrary.simpleMessage(
      "Security question is set up",
    ),
    "securityWarning": MessageLookupByLibrary.simpleMessage("Security Warning"),
    "securityWarningMessage": MessageLookupByLibrary.simpleMessage(
      "Unusual activity has been detected. Additional verification may be required.",
    ),
    "selectAttributes": MessageLookupByLibrary.simpleMessage(
      "Select Attributes",
    ),
    "selectCoinPackage": MessageLookupByLibrary.simpleMessage(
      "Select coin package:",
    ),
    "selectLocation": MessageLookupByLibrary.simpleMessage("Select Location"),
    "selectSecurityQuestion": MessageLookupByLibrary.simpleMessage(
      "Select a question",
    ),
    "selectTheInterestsThatMatchYourPreferences":
        MessageLookupByLibrary.simpleMessage(
          "What services or items do you need?\nYou can change this later.",
        ),
    "selectTheOffersThatYouCanProvide": MessageLookupByLibrary.simpleMessage(
      "What can you provide or help out with?\nYou can change this later.",
    ),
    "selectYourInterests": MessageLookupByLibrary.simpleMessage(
      "What is of interest to you?",
    ),
    "selectYourOffers": MessageLookupByLibrary.simpleMessage(
      "What do you have to offer?",
    ),
    "selectedCoinPackage": m41,
    "sendRecoveryCode": MessageLookupByLibrary.simpleMessage(
      "Send Recovery Code",
    ),
    "sendResetLink": MessageLookupByLibrary.simpleMessage("Send Reset Link"),
    "setPinButton": MessageLookupByLibrary.simpleMessage("Set PIN"),
    "setPinDescription": MessageLookupByLibrary.simpleMessage(
      "Create a 4-6 digit PIN to secure your app",
    ),
    "setPinTitle": MessageLookupByLibrary.simpleMessage("Set Up PIN"),
    "setUpAccount": MessageLookupByLibrary.simpleMessage("Set Up Account"),
    "settingsChangePinButton": MessageLookupByLibrary.simpleMessage(
      "Change PIN",
    ),
    "settingsChangePinDescription": MessageLookupByLibrary.simpleMessage(
      "Update your security PIN",
    ),
    "settingsGpsLocationDescription": MessageLookupByLibrary.simpleMessage(
      "When enabled, you can zoom to your current GPS location on the map. The app will request location permissions when needed.",
    ),
    "settingsGpsLocationDisabledDescription":
        MessageLookupByLibrary.simpleMessage(
          "GPS location tracking is disabled",
        ),
    "settingsGpsLocationEnabledDescription":
        MessageLookupByLibrary.simpleMessage(
          "GPS location tracking is enabled",
        ),
    "settingsGpsLocationTitle": MessageLookupByLibrary.simpleMessage(
      "Enable GPS Location",
    ),
    "settingsKeywordSearchRadiusDescription":
        MessageLookupByLibrary.simpleMessage(
          "Search radius when using keyword search",
        ),
    "settingsKeywordSearchRadiusTitle": MessageLookupByLibrary.simpleMessage(
      "Keyword Search Radius",
    ),
    "settingsKeywordSearchWeightDescription":
        MessageLookupByLibrary.simpleMessage(
          "Weight parameter for keyword search relevance (10-100)",
        ),
    "settingsKeywordSearchWeightTitle": MessageLookupByLibrary.simpleMessage(
      "Keyword Search Weight",
    ),
    "settingsLanguageDescription": MessageLookupByLibrary.simpleMessage(
      "Choose your preferred language for the app",
    ),
    "settingsLanguageRestartMessage": MessageLookupByLibrary.simpleMessage(
      "Please restart the app to apply language changes",
    ),
    "settingsLanguageSection": MessageLookupByLibrary.simpleMessage("Language"),
    "settingsLanguageTitle": MessageLookupByLibrary.simpleMessage(
      "App Language",
    ),
    "settingsNearbyUsersRadiusDescription":
        MessageLookupByLibrary.simpleMessage(
          "How far to search for nearby users",
        ),
    "settingsNearbyUsersRadiusTitle": MessageLookupByLibrary.simpleMessage(
      "Nearby Users Search Radius",
    ),
    "settingsPinDisabledDescription": MessageLookupByLibrary.simpleMessage(
      "Enable PIN for extra security",
    ),
    "settingsPinEnabledDescription": MessageLookupByLibrary.simpleMessage(
      "App is protected with PIN",
    ),
    "settingsPinTitle": MessageLookupByLibrary.simpleMessage("PIN Protection"),
    "settingsSaved": MessageLookupByLibrary.simpleMessage(
      "Settings saved successfully",
    ),
    "settingsSearchCenterMapCenter": MessageLookupByLibrary.simpleMessage(
      "Map Center",
    ),
    "settingsSearchCenterMapCenterDescription":
        MessageLookupByLibrary.simpleMessage(
          "Search from the current map center",
        ),
    "settingsSearchCenterPointDescription":
        MessageLookupByLibrary.simpleMessage(
          "Choose the center point for nearby user searches",
        ),
    "settingsSearchCenterPointTitle": MessageLookupByLibrary.simpleMessage(
      "Center Point of Search",
    ),
    "settingsSearchCenterUserLocation": MessageLookupByLibrary.simpleMessage(
      "User Location",
    ),
    "settingsSearchCenterUserLocationDescription":
        MessageLookupByLibrary.simpleMessage("Search from your saved location"),
    "settingsSearchSection": MessageLookupByLibrary.simpleMessage(
      "Search Settings",
    ),
    "settingsSecuritySection": MessageLookupByLibrary.simpleMessage("Security"),
    "settingsShowResultsAsListDescription": MessageLookupByLibrary.simpleMessage(
      "Show keyword and nearby search results in a list view instead of on the map",
    ),
    "settingsShowResultsAsListTitle": MessageLookupByLibrary.simpleMessage(
      "Display Search Results As List",
    ),
    "settingsShowResultsAsListViewDescription":
        MessageLookupByLibrary.simpleMessage(
          "Show search results in a list view",
        ),
    "settingsShowResultsOnMapDescription": MessageLookupByLibrary.simpleMessage(
      "Show search results on the map (default)",
    ),
    "settingsTitle": MessageLookupByLibrary.simpleMessage("Settings"),
    "setupAttributeNotifications": MessageLookupByLibrary.simpleMessage(
      "Set Up Notifications",
    ),
    "setupAttributeNotificationsHint": MessageLookupByLibrary.simpleMessage(
      "Enable notifications for your interests and skills to receive alerts when matches are found",
    ),
    "setupEmailDescription": MessageLookupByLibrary.simpleMessage(
      "Enter your email address to receive notifications",
    ),
    "setupEmailTitle": MessageLookupByLibrary.simpleMessage("Set Up Email"),
    "setupSecurityQuestion": MessageLookupByLibrary.simpleMessage(
      "Setup Security Question",
    ),
    "setupSecurityQuestionButton": MessageLookupByLibrary.simpleMessage(
      "Setup Security Question",
    ),
    "shareApp": MessageLookupByLibrary.simpleMessage("Share App"),
    "shareYourExperience": MessageLookupByLibrary.simpleMessage(
      "Share your experience...",
    ),
    "shareYourInterestsToFindBestMatches": MessageLookupByLibrary.simpleMessage(
      "Share your interests to find the best matches with others!",
    ),
    "showLess": MessageLookupByLibrary.simpleMessage("Show less"),
    "showMore": MessageLookupByLibrary.simpleMessage("Show more"),
    "showPath": MessageLookupByLibrary.simpleMessage("Show Path"),
    "similar": MessageLookupByLibrary.simpleMessage("Similar"),
    "skin": MessageLookupByLibrary.simpleMessage("Skin"),
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "skipForNow": MessageLookupByLibrary.simpleMessage("Skip for Now"),
    "skipPinButton": MessageLookupByLibrary.simpleMessage("Skip for now"),
    "skipReviewMessage": MessageLookupByLibrary.simpleMessage(
      "You can review this user later from your transaction history. Reviews help build trust in the community.",
    ),
    "skipReviewTitle": MessageLookupByLibrary.simpleMessage("Skip Review?"),
    "startConversationFromMap": MessageLookupByLibrary.simpleMessage(
      "Start a conversation from the map",
    ),
    "startTime": MessageLookupByLibrary.simpleMessage("Start Time"),
    "styleNumber": m42,
    "submitReport": MessageLookupByLibrary.simpleMessage("Submit Report"),
    "submitReview": MessageLookupByLibrary.simpleMessage("Submit Review"),
    "submitting": MessageLookupByLibrary.simpleMessage("Submitting..."),
    "submittingOffers": MessageLookupByLibrary.simpleMessage(
      "Submitting offers...",
    ),
    "takePhoto": MessageLookupByLibrary.simpleMessage("Take Photo"),
    "tapToChat": MessageLookupByLibrary.simpleMessage("Tap to chat"),
    "tapToExpandMainCluster": MessageLookupByLibrary.simpleMessage(
      "Tap to expand main cluster",
    ),
    "tapToExpandSubCluster": MessageLookupByLibrary.simpleMessage(
      "Tap to expand sub-cluster",
    ),
    "tapToRate": MessageLookupByLibrary.simpleMessage("Tap to rate"),
    "tapToSelectDate": MessageLookupByLibrary.simpleMessage(
      "Tap to select expiration date (optional)",
    ),
    "targetDeviceTimeout": MessageLookupByLibrary.simpleMessage(
      "Target device did not join in time",
    ),
    "targetStep1": MessageLookupByLibrary.simpleMessage(
      "Open the app on your other device",
    ),
    "targetStep2": MessageLookupByLibrary.simpleMessage(
      "Go to Settings → Account → Migrate Device",
    ),
    "targetStep3": MessageLookupByLibrary.simpleMessage(
      "Enter the code shown on that device here",
    ),
    "tellUsMore": MessageLookupByLibrary.simpleMessage(
      "Tell us more (optional)",
    ),
    "termsConditionsSectionAccountRestrictionContent":
        MessageLookupByLibrary.simpleMessage(
          "We may restrict or terminate accounts for violations of these terms or security risks.",
        ),
    "termsConditionsSectionAccountRestrictionTitle":
        MessageLookupByLibrary.simpleMessage(
          "5. Account Restriction or Termination",
        ),
    "termsConditionsSectionAccountUseContent": MessageLookupByLibrary.simpleMessage(
      "You are responsible for maintaining your account security and activities performed through your account. You must provide your e-mail in Profile - Notification Preferences to be able to migrate/recover your account and to request it\'s deletion if you lose access to your device.",
    ),
    "termsConditionsSectionAccountUseTitle":
        MessageLookupByLibrary.simpleMessage(
          "3. Account Use, Recovery and Deletion",
        ),
    "termsConditionsSectionChangesContent": MessageLookupByLibrary.simpleMessage(
      "We may update these terms from time to time. Continued use of the app after changes means acceptance of the updated terms.",
    ),
    "termsConditionsSectionChangesTitle": MessageLookupByLibrary.simpleMessage(
      "8. Changes to Terms",
    ),
    "termsConditionsSectionKidsSafetyContent": MessageLookupByLibrary.simpleMessage(
      "We have zero tolerance for child sexual abuse and exploitation (CSAE), including child sexual abuse material (CSAM), grooming, trafficking, and any sexual exploitation of minors.\n\nThe following are strictly prohibited on this platform:\n- Sharing, requesting, promoting, or storing CSAM\n- Sexualized communication involving minors\n- Grooming, coercion, trafficking, or exploitation of minors\n- Any attempt to use this service to endanger a child\n\nWe may remove content, suspend or terminate accounts, and report relevant cases to competent authorities as required by law. Users can report concerns through in-app reporting tools or by contacting info@bartering.app.\n\nWe review safety reports as quickly as possible and cooperate with lawful requests from authorities regarding CSAE-related violations.",
    ),
    "termsConditionsSectionKidsSafetyTitle":
        MessageLookupByLibrary.simpleMessage(
          "8. Child Safety and CSAE Standards",
        ),
    "termsConditionsSectionLiabilityDisputesContent":
        MessageLookupByLibrary.simpleMessage(
          "Users are responsible for their own exchanges and interactions. The platform provides an intermediary environment to the extent permitted by law.",
        ),
    "termsConditionsSectionLiabilityDisputesTitle":
        MessageLookupByLibrary.simpleMessage("6. Liability and Disputes"),
    "termsConditionsSectionMinimumAgeContent": MessageLookupByLibrary.simpleMessage(
      "The app is intended for users aged 16 or older. By registering, you confirm you are at least 16 years old.",
    ),
    "termsConditionsSectionMinimumAgeTitle":
        MessageLookupByLibrary.simpleMessage("Minimum Age"),
    "termsConditionsSectionProhibitedConductContent":
        MessageLookupByLibrary.simpleMessage(
          "Fraud, harassment, unlawful content, misuse of other users’ data, and other illegal actions are prohibited.",
        ),
    "termsConditionsSectionProhibitedConductTitle":
        MessageLookupByLibrary.simpleMessage("4. Prohibited Conduct"),
    "termsConditionsSectionScopeContent": MessageLookupByLibrary.simpleMessage(
      "These terms govern your use of Barter App and define user rights and responsibilities.",
    ),
    "termsConditionsSectionScopeTitle": MessageLookupByLibrary.simpleMessage(
      "1. Scope",
    ),
    "termsConditionsTitle": MessageLookupByLibrary.simpleMessage(
      "Terms & Conditions",
    ),
    "thankYouForFeedback": MessageLookupByLibrary.simpleMessage(
      "Thank you for your feedback!",
    ),
    "today": MessageLookupByLibrary.simpleMessage("Today"),
    "tradeMatch": MessageLookupByLibrary.simpleMessage("Trade match"),
    "transactionBlocked": MessageLookupByLibrary.simpleMessage(
      "Transaction Blocked",
    ),
    "transactionBlockedMessage": MessageLookupByLibrary.simpleMessage(
      "This transaction has been blocked due to suspicious activity patterns. Please contact support if you believe this is an error.",
    ),
    "transactionCompleted": MessageLookupByLibrary.simpleMessage(
      "Transaction marked as completed",
    ),
    "transactionCreated": MessageLookupByLibrary.simpleMessage(
      "Transaction created successfully",
    ),
    "transactionStatusCancelled": MessageLookupByLibrary.simpleMessage(
      "Cancelled",
    ),
    "transactionStatusNoDeal": MessageLookupByLibrary.simpleMessage(
      "Talked but no deal",
    ),
    "transactionStatusScam": MessageLookupByLibrary.simpleMessage(
      "🚩 Report Scam",
    ),
    "transactionStatusSuccessful": MessageLookupByLibrary.simpleMessage(
      "Successful Trade",
    ),
    "transactionWillBeReviewed": MessageLookupByLibrary.simpleMessage(
      "This transaction will be reviewed by our security team.",
    ),
    "typeAMessage": MessageLookupByLibrary.simpleMessage("Type a message..."),
    "unableToReviewUser": MessageLookupByLibrary.simpleMessage(
      "Unable to review this user at this time",
    ),
    "unableToShareAtThisTime": MessageLookupByLibrary.simpleMessage(
      "Unable to share at this time",
    ),
    "unableToSubmitAppealNow": MessageLookupByLibrary.simpleMessage(
      "Unable to submit appeal right now",
    ),
    "unblock": MessageLookupByLibrary.simpleMessage("Unblock"),
    "unblockUser": MessageLookupByLibrary.simpleMessage("Unblock User"),
    "unblockUserConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to unblock this user? They will be able to communicate with you again.",
    ),
    "unblockUserConfirmationDetailed": m43,
    "unknownUser": MessageLookupByLibrary.simpleMessage("Unknown User"),
    "unlockButton": MessageLookupByLibrary.simpleMessage("Unlock"),
    "unviewed": MessageLookupByLibrary.simpleMessage("Unviewed"),
    "unviewedOnly": MessageLookupByLibrary.simpleMessage("Unviewed Only"),
    "updateEmail": MessageLookupByLibrary.simpleMessage("Update Email"),
    "updatePhone": MessageLookupByLibrary.simpleMessage("Update Phone"),
    "updatePosting": MessageLookupByLibrary.simpleMessage("Update Posting"),
    "uploadingFile": MessageLookupByLibrary.simpleMessage("Uploading file..."),
    "userBlocked": MessageLookupByLibrary.simpleMessage(
      "User blocked successfully",
    ),
    "userDetails": MessageLookupByLibrary.simpleMessage("User Details"),
    "userId": MessageLookupByLibrary.simpleMessage("User ID"),
    "userInterestedIn": MessageLookupByLibrary.simpleMessage("Interested in:"),
    "userLocation": MessageLookupByLibrary.simpleMessage("Location:"),
    "userMatch": MessageLookupByLibrary.simpleMessage("User Match"),
    "userOffers": MessageLookupByLibrary.simpleMessage("Offering:"),
    "userPrefix": MessageLookupByLibrary.simpleMessage("User"),
    "userReported": MessageLookupByLibrary.simpleMessage(
      "User reported successfully",
    ),
    "userUnblocked": MessageLookupByLibrary.simpleMessage(
      "User unblocked successfully",
    ),
    "username": MessageLookupByLibrary.simpleMessage("User name"),
    "users": MessageLookupByLibrary.simpleMessage("Users"),
    "valuePrefix": MessageLookupByLibrary.simpleMessage("Value"),
    "verified": MessageLookupByLibrary.simpleMessage("Verified"),
    "verifyAndRecover": MessageLookupByLibrary.simpleMessage(
      "Verify & Recover",
    ),
    "verifyAndResetPin": MessageLookupByLibrary.simpleMessage(
      "Verify and Reset PIN",
    ),
    "viewMatches": MessageLookupByLibrary.simpleMessage("View Matches"),
    "viewProfile": MessageLookupByLibrary.simpleMessage("View Profile"),
    "weekly": MessageLookupByLibrary.simpleMessage("Weekly"),
    "welcomeStep1Description": MessageLookupByLibrary.simpleMessage(
      "Create an anonymous profile with your interests and what you have to offer",
    ),
    "welcomeStep1Title": MessageLookupByLibrary.simpleMessage(
      "Create your Profile",
    ),
    "welcomeStep2Description": MessageLookupByLibrary.simpleMessage(
      "Search by keywords, similarity or trade match, get match notifications",
    ),
    "welcomeStep2Title": MessageLookupByLibrary.simpleMessage(
      "Discover, Search, Post",
    ),
    "welcomeStep3Description": MessageLookupByLibrary.simpleMessage(
      "Connect with others through End-to-end encrypted chat",
    ),
    "welcomeStep3Title": MessageLookupByLibrary.simpleMessage("Start Chatting"),
    "welcomeStep4Description": MessageLookupByLibrary.simpleMessage(
      "Trade knowledge, services, items, or simply connect with your community",
    ),
    "welcomeStep4Title": MessageLookupByLibrary.simpleMessage("Make Exchanges"),
    "welcomeTagline": MessageLookupByLibrary.simpleMessage(
      "Connect. Trade. Build Community.",
    ),
    "whyReportingUser": MessageLookupByLibrary.simpleMessage(
      "Why are you reporting this user?",
    ),
    "wishlist": MessageLookupByLibrary.simpleMessage("Wishlist"),
    "wishlistItemCreated": MessageLookupByLibrary.simpleMessage(
      "Wishlist item created",
    ),
    "wishlistItemDeleted": MessageLookupByLibrary.simpleMessage(
      "Wishlist item deleted",
    ),
    "wishlistItemDescription": MessageLookupByLibrary.simpleMessage(
      "Description",
    ),
    "wishlistItemKeywords": MessageLookupByLibrary.simpleMessage(
      "Keywords (comma separated)",
    ),
    "wishlistItemLocation": MessageLookupByLibrary.simpleMessage("Location"),
    "wishlistItemMaxPrice": MessageLookupByLibrary.simpleMessage("Max Price"),
    "wishlistItemMinPrice": MessageLookupByLibrary.simpleMessage("Min Price"),
    "wishlistItemNotifications": MessageLookupByLibrary.simpleMessage(
      "Enable Notifications",
    ),
    "wishlistItemPriceRange": MessageLookupByLibrary.simpleMessage(
      "Price Range",
    ),
    "wishlistItemRadius": MessageLookupByLibrary.simpleMessage(
      "Search Radius (km)",
    ),
    "wishlistItemTitle": MessageLookupByLibrary.simpleMessage("Title"),
    "wishlistItemUpdated": MessageLookupByLibrary.simpleMessage(
      "Wishlist item updated",
    ),
    "wishlistMatches": MessageLookupByLibrary.simpleMessage("Matches"),
    "wishlistStatusActive": MessageLookupByLibrary.simpleMessage("Active"),
    "wishlistStatusArchived": MessageLookupByLibrary.simpleMessage("Archived"),
    "wishlistStatusFulfilled": MessageLookupByLibrary.simpleMessage(
      "Fulfilled",
    ),
    "wishlistStatusPaused": MessageLookupByLibrary.simpleMessage("Paused"),
    "yesterday": MessageLookupByLibrary.simpleMessage("Yesterday"),
    "yourAnswer": MessageLookupByLibrary.simpleMessage("Your Answer"),
    "yourMigrationCode": MessageLookupByLibrary.simpleMessage(
      "Your Migration Code",
    ),
  };
}
