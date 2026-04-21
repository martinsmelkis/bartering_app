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

  static String m0(userName) =>
      "Blocking ${userName} will prevent them from:\n• Sending you messages\n• Seeing your profile\n• Commenting on your postings";

  static String m1(error) => "Could not open file: ${error}";

  static String m2(error) => "Download failed: ${error}";

  static String m3(filename) => "Downloading ${filename}...";

  static String m4(error) => "Error creating transaction: ${error}";

  static String m5(error) => "Error finding location: ${error}";

  static String m6(message) => "Error opening file: ${message}";

  static String m7(error) => "Error updating transaction: ${error}";

  static String m8(exception) => "Error: ${exception}";

  static String m9(errorMessage) => "Error: ${errorMessage}";

  static String m10(filePath) => "File not found: ${filePath}";

  static String m11(filePath) => "File saved at: ${filePath}";

  static String m12(appLink) =>
      "Hey! Join me on BarterApp - a great way to trade items and services with people nearby! 🔄\n\n${appLink}";

  static String m13(id) => "Mock POI with id ${id} not found in service";

  static String m14(id) => "Mock POI with id ${id} not found for update";

  static String m15(attempts) => "Incorrect PIN (Attempt ${attempts})";

  static String m16(count) => "${count} questions answered";

  static String m17(userName) => "Report ${userName}";

  static String m18(userName) => "Review ${userName}";

  static String m19(otherUserName) =>
      "Your review will be visible after ${otherUserName} submits their review, or in 14 days.";

  static String m20(attempts) => "Incorrect answer (Attempt ${attempts})";

  static String m21(number) => "Style ${number}";

  static String m22(userName) =>
      "Unblocking ${userName} will allow them to:\n• Send you messages\n• See your profile\n• Comment on your postings";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
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
    "appTitle": MessageLookupByLibrary.simpleMessage("Bartering App"),
    "archive": MessageLookupByLibrary.simpleMessage("Archive"),
    "archiveConversationMessage": MessageLookupByLibrary.simpleMessage(
      "Would you like to archive this conversation now?",
    ),
    "archiveConversationTitle": MessageLookupByLibrary.simpleMessage(
      "Archive Conversation?",
    ),
    "appealReasonRequired": MessageLookupByLibrary.simpleMessage(
      "Appeal reason is required",
    ),
    "appealReviewReasonHint": MessageLookupByLibrary.simpleMessage(
      "Describe why this review should be reconsidered",
    ),
    "appealReviewTitle": MessageLookupByLibrary.simpleMessage("Appeal review"),
    "archiveWishlist": MessageLookupByLibrary.simpleMessage("Archive"),
    "atLeastOneKeyword": MessageLookupByLibrary.simpleMessage(
      "Please enter at least one keyword",
    ),
    "attr_3d_printing": MessageLookupByLibrary.simpleMessage("3D printing"),
    "attr_academic_tutoring": MessageLookupByLibrary.simpleMessage(
      "Academic tutoring",
    ),
    "attr_acting": MessageLookupByLibrary.simpleMessage("Acting"),
    "attr_aerobics": MessageLookupByLibrary.simpleMessage("Aerobics"),
    "attr_alternative_healing": MessageLookupByLibrary.simpleMessage(
      "Alternative healing",
    ),
    "attr_alternative_medicine": MessageLookupByLibrary.simpleMessage(
      "Alternative medicine",
    ),
    "attr_amateur_radio": MessageLookupByLibrary.simpleMessage("Amateur radio"),
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
    "attr_assembly": MessageLookupByLibrary.simpleMessage("Assembly"),
    "attr_astronomy": MessageLookupByLibrary.simpleMessage("Astronomy"),
    "attr_babysitting": MessageLookupByLibrary.simpleMessage("Babysitting"),
    "attr_backend_development": MessageLookupByLibrary.simpleMessage(
      "Backend development",
    ),
    "attr_backgammon": MessageLookupByLibrary.simpleMessage("Backgammon"),
    "attr_backpacking": MessageLookupByLibrary.simpleMessage("Backpacking"),
    "attr_baking": MessageLookupByLibrary.simpleMessage("Baking"),
    "attr_beekeeping": MessageLookupByLibrary.simpleMessage("Beekeeping"),
    "attr_bicycles": MessageLookupByLibrary.simpleMessage("Bicycles"),
    "attr_billiards": MessageLookupByLibrary.simpleMessage("Billiards"),
    "attr_biohacking": MessageLookupByLibrary.simpleMessage("Biohacking"),
    "attr_bird_watching": MessageLookupByLibrary.simpleMessage("Bird watching"),
    "attr_blogging": MessageLookupByLibrary.simpleMessage("Blogging"),
    "attr_board_games": MessageLookupByLibrary.simpleMessage("Board games"),
    "attr_bodybuilding": MessageLookupByLibrary.simpleMessage("Bodybuilding"),
    "attr_books": MessageLookupByLibrary.simpleMessage("Books"),
    "attr_bowling": MessageLookupByLibrary.simpleMessage("Bowling"),
    "attr_breadmaking": MessageLookupByLibrary.simpleMessage("Breadmaking"),
    "attr_building_materials": MessageLookupByLibrary.simpleMessage(
      "Building materials",
    ),
    "attr_business_mentorship": MessageLookupByLibrary.simpleMessage(
      "Business Mentorship",
    ),
    "attr_camping": MessageLookupByLibrary.simpleMessage("Camping"),
    "attr_candle_making": MessageLookupByLibrary.simpleMessage("Candle making"),
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
    "attr_cleaning": MessageLookupByLibrary.simpleMessage("Cleaning"),
    "attr_climbing": MessageLookupByLibrary.simpleMessage("Climbing"),
    "attr_clothesmaking": MessageLookupByLibrary.simpleMessage("Clothesmaking"),
    "attr_co_op_gaming": MessageLookupByLibrary.simpleMessage("Co-op gaming"),
    "attr_code_review": MessageLookupByLibrary.simpleMessage("Code review"),
    "attr_coding": MessageLookupByLibrary.simpleMessage("Coding"),
    "attr_coffee": MessageLookupByLibrary.simpleMessage("Coffee"),
    "attr_cold_plunging": MessageLookupByLibrary.simpleMessage("Cold plunging"),
    "attr_comic_books": MessageLookupByLibrary.simpleMessage("Comic books"),
    "attr_community_gardening": MessageLookupByLibrary.simpleMessage(
      "Community gardening",
    ),
    "attr_computer_hardware": MessageLookupByLibrary.simpleMessage(
      "Computer hardware",
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
    "attr_cows": MessageLookupByLibrary.simpleMessage("Cows"),
    "attr_crafting": MessageLookupByLibrary.simpleMessage("Crafting"),
    "attr_creative_brainstorming": MessageLookupByLibrary.simpleMessage(
      "Creative brainstorming",
    ),
    "attr_creative_writing": MessageLookupByLibrary.simpleMessage(
      "Creative writing",
    ),
    "attr_crocheting": MessageLookupByLibrary.simpleMessage("Crocheting"),
    "attr_cross_stitch": MessageLookupByLibrary.simpleMessage("Cross-stitch"),
    "attr_cryptocurrency": MessageLookupByLibrary.simpleMessage(
      "Cryptocurrency",
    ),
    "attr_culinary_arts": MessageLookupByLibrary.simpleMessage("Culinary arts"),
    "attr_cybersecurity": MessageLookupByLibrary.simpleMessage("Cybersecurity"),
    "attr_cycling": MessageLookupByLibrary.simpleMessage("Cycling"),
    "attr_dance": MessageLookupByLibrary.simpleMessage("Dance"),
    "attr_dance_lessons": MessageLookupByLibrary.simpleMessage("Dance lessons"),
    "attr_dancing": MessageLookupByLibrary.simpleMessage("Dancing"),
    "attr_day_trading": MessageLookupByLibrary.simpleMessage("Day trading"),
    "attr_deep_cleaning": MessageLookupByLibrary.simpleMessage("Deep cleaning"),
    "attr_digital_arts": MessageLookupByLibrary.simpleMessage("Digital arts"),
    "attr_digital_nomadism": MessageLookupByLibrary.simpleMessage(
      "Digital nomadism",
    ),
    "attr_diy": MessageLookupByLibrary.simpleMessage("DIY"),
    "attr_djing": MessageLookupByLibrary.simpleMessage("DJing"),
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
    "attr_event_hosting": MessageLookupByLibrary.simpleMessage("Event hosting"),
    "attr_event_tickets": MessageLookupByLibrary.simpleMessage("Event tickets"),
    "attr_exercise_partner": MessageLookupByLibrary.simpleMessage(
      "Exercise partner",
    ),
    "attr_farm_animals": MessageLookupByLibrary.simpleMessage("Farm animals"),
    "attr_farmstay": MessageLookupByLibrary.simpleMessage("Farmstay"),
    "attr_fashion": MessageLookupByLibrary.simpleMessage("Fashion"),
    "attr_fashion_design": MessageLookupByLibrary.simpleMessage(
      "Fashion design",
    ),
    "attr_fermentation": MessageLookupByLibrary.simpleMessage("Fermentation"),
    "attr_film_making": MessageLookupByLibrary.simpleMessage("Film making"),
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
    "attr_fresh_eggs": MessageLookupByLibrary.simpleMessage("Fresh eggs"),
    "attr_fresh_fruits": MessageLookupByLibrary.simpleMessage("Fresh fruits"),
    "attr_fresh_herbs": MessageLookupByLibrary.simpleMessage("Fresh herbs"),
    "attr_fresh_vegetables": MessageLookupByLibrary.simpleMessage(
      "Fresh vegetables",
    ),
    "attr_fruit_harvesting": MessageLookupByLibrary.simpleMessage(
      "Fruit harvesting",
    ),
    "attr_furniture_building": MessageLookupByLibrary.simpleMessage(
      "Furniture building",
    ),
    "attr_furniture_repair": MessageLookupByLibrary.simpleMessage(
      "Furniture repair",
    ),
    "attr_gadgets": MessageLookupByLibrary.simpleMessage("Gadgets"),
    "attr_gaming": MessageLookupByLibrary.simpleMessage("Gaming"),
    "attr_gardening": MessageLookupByLibrary.simpleMessage("Gardening"),
    "attr_gardening_advice": MessageLookupByLibrary.simpleMessage(
      "Gardening advice",
    ),
    "attr_genealogy": MessageLookupByLibrary.simpleMessage("Genealogy"),
    "attr_geocaching": MessageLookupByLibrary.simpleMessage("Geocaching"),
    "attr_goats": MessageLookupByLibrary.simpleMessage("Goats"),
    "attr_graphic_design": MessageLookupByLibrary.simpleMessage(
      "Graphic design",
    ),
    "attr_graphic_novels": MessageLookupByLibrary.simpleMessage(
      "Graphic novels",
    ),
    "attr_guitar": MessageLookupByLibrary.simpleMessage("Guitar"),
    "attr_hacking": MessageLookupByLibrary.simpleMessage("Hacking"),
    "attr_handmade": MessageLookupByLibrary.simpleMessage("Handmade"),
    "attr_handyman_services": MessageLookupByLibrary.simpleMessage(
      "Handyman services",
    ),
    "attr_hauling_services": MessageLookupByLibrary.simpleMessage(
      "Hauling services",
    ),
    "attr_herbal_remedies": MessageLookupByLibrary.simpleMessage(
      "Herbal remedies",
    ),
    "attr_herp_keeping": MessageLookupByLibrary.simpleMessage("Herp keeping"),
    "attr_hiking": MessageLookupByLibrary.simpleMessage("Hiking"),
    "attr_home_improvement": MessageLookupByLibrary.simpleMessage(
      "Home improvement",
    ),
    "attr_homebrewing": MessageLookupByLibrary.simpleMessage("Homebrewing"),
    "attr_horseback_riding": MessageLookupByLibrary.simpleMessage(
      "Horseback riding",
    ),
    "attr_horses": MessageLookupByLibrary.simpleMessage("Horses"),
    "attr_house_maintenance": MessageLookupByLibrary.simpleMessage(
      "House maintenance",
    ),
    "attr_houseplant_care": MessageLookupByLibrary.simpleMessage(
      "Houseplant care",
    ),
    "attr_hydroponics": MessageLookupByLibrary.simpleMessage("Hydroponics"),
    "attr_interview_practice": MessageLookupByLibrary.simpleMessage(
      "Interview practice",
    ),
    "attr_ios": MessageLookupByLibrary.simpleMessage("iOS"),
    "attr_jewelry": MessageLookupByLibrary.simpleMessage("Jewelry"),
    "attr_kayaking": MessageLookupByLibrary.simpleMessage("Kayaking"),
    "attr_knitting": MessageLookupByLibrary.simpleMessage("Knitting"),
    "attr_kombucha": MessageLookupByLibrary.simpleMessage("Kombucha"),
    "attr_landscaping": MessageLookupByLibrary.simpleMessage("Landscaping"),
    "attr_language_exchange": MessageLookupByLibrary.simpleMessage(
      "Language exchange",
    ),
    "attr_lawn_mowing": MessageLookupByLibrary.simpleMessage("Lawn mowing"),
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
    "attr_martial_arts": MessageLookupByLibrary.simpleMessage("Martial arts"),
    "attr_massage": MessageLookupByLibrary.simpleMessage("Massage"),
    "attr_math_tutoring": MessageLookupByLibrary.simpleMessage("Math tutoring"),
    "attr_meditation": MessageLookupByLibrary.simpleMessage("Meditation"),
    "attr_memes": MessageLookupByLibrary.simpleMessage("Memes"),
    "attr_mentorship": MessageLookupByLibrary.simpleMessage("Mentorship"),
    "attr_metal_detecting": MessageLookupByLibrary.simpleMessage(
      "Metal detecting",
    ),
    "attr_metalworking": MessageLookupByLibrary.simpleMessage("Metalworking"),
    "attr_mindfulness": MessageLookupByLibrary.simpleMessage("Mindfulness"),
    "attr_minimalism": MessageLookupByLibrary.simpleMessage("Minimalism"),
    "attr_motorcycles": MessageLookupByLibrary.simpleMessage("Motorcycles"),
    "attr_movies": MessageLookupByLibrary.simpleMessage("Movies"),
    "attr_moving_help": MessageLookupByLibrary.simpleMessage("Moving help"),
    "attr_mushroom_hunting": MessageLookupByLibrary.simpleMessage(
      "Mushroom hunting",
    ),
    "attr_music": MessageLookupByLibrary.simpleMessage("Music"),
    "attr_musical_instruments": MessageLookupByLibrary.simpleMessage(
      "Musical instruments",
    ),
    "attr_nail_art": MessageLookupByLibrary.simpleMessage("Nail art"),
    "attr_natural_remedies": MessageLookupByLibrary.simpleMessage(
      "Natural remedies",
    ),
    "attr_organic_food": MessageLookupByLibrary.simpleMessage("Organic food"),
    "attr_painting": MessageLookupByLibrary.simpleMessage("Painting"),
    "attr_pair_programming": MessageLookupByLibrary.simpleMessage(
      "Pair programming",
    ),
    "attr_pc_building": MessageLookupByLibrary.simpleMessage("PC building"),
    "attr_permaculture": MessageLookupByLibrary.simpleMessage("Permaculture"),
    "attr_personal_finance": MessageLookupByLibrary.simpleMessage(
      "Personal finance",
    ),
    "attr_pet_grooming": MessageLookupByLibrary.simpleMessage("Pet grooming"),
    "attr_pet_sitting": MessageLookupByLibrary.simpleMessage("Pet sitting"),
    "attr_photo_restoration": MessageLookupByLibrary.simpleMessage(
      "Photo restoration",
    ),
    "attr_photography": MessageLookupByLibrary.simpleMessage("Photography"),
    "attr_physical_work": MessageLookupByLibrary.simpleMessage("Physical work"),
    "attr_piano_lessons": MessageLookupByLibrary.simpleMessage("Piano lessons"),
    "attr_plant_cuttings": MessageLookupByLibrary.simpleMessage(
      "Plant cuttings",
    ),
    "attr_plants": MessageLookupByLibrary.simpleMessage("Plants"),
    "attr_plumbing": MessageLookupByLibrary.simpleMessage("Plumbing"),
    "attr_podcasting": MessageLookupByLibrary.simpleMessage("Podcasting"),
    "attr_podcasts": MessageLookupByLibrary.simpleMessage("Podcasts"),
    "attr_poker": MessageLookupByLibrary.simpleMessage("Poker"),
    "attr_pottery": MessageLookupByLibrary.simpleMessage("Pottery"),
    "attr_powerlifting": MessageLookupByLibrary.simpleMessage("Powerlifting"),
    "attr_proofreading": MessageLookupByLibrary.simpleMessage("Proofreading"),
    "attr_puzzles": MessageLookupByLibrary.simpleMessage("Puzzles"),
    "attr_quilting": MessageLookupByLibrary.simpleMessage("Quilting"),
    "attr_reading": MessageLookupByLibrary.simpleMessage("Reading"),
    "attr_recipes": MessageLookupByLibrary.simpleMessage("Recipes"),
    "attr_record_collecting": MessageLookupByLibrary.simpleMessage(
      "Record collecting",
    ),
    "attr_renovation": MessageLookupByLibrary.simpleMessage("Renovation"),
    "attr_resume_writing": MessageLookupByLibrary.simpleMessage(
      "Resume writing",
    ),
    "attr_retreats": MessageLookupByLibrary.simpleMessage("Retreats"),
    "attr_ridesharing": MessageLookupByLibrary.simpleMessage("Ridesharing"),
    "attr_robotics": MessageLookupByLibrary.simpleMessage("Robotics"),
    "attr_rock_climbing": MessageLookupByLibrary.simpleMessage("Rock climbing"),
    "attr_rpg_games": MessageLookupByLibrary.simpleMessage("RPG games"),
    "attr_running": MessageLookupByLibrary.simpleMessage("Running"),
    "attr_scrap_metal": MessageLookupByLibrary.simpleMessage("Scrap metal"),
    "attr_sculpting": MessageLookupByLibrary.simpleMessage("Sculpting"),
    "attr_self_sufficiency": MessageLookupByLibrary.simpleMessage(
      "Self-sufficiency",
    ),
    "attr_sewing": MessageLookupByLibrary.simpleMessage("Sewing"),
    "attr_shepherding": MessageLookupByLibrary.simpleMessage("Shepherding"),
    "attr_shoemaking": MessageLookupByLibrary.simpleMessage("Shoemaking"),
    "attr_singing": MessageLookupByLibrary.simpleMessage("Singing"),
    "attr_skateboarding": MessageLookupByLibrary.simpleMessage("Skateboarding"),
    "attr_sketching": MessageLookupByLibrary.simpleMessage("Sketching"),
    "attr_soapmaking": MessageLookupByLibrary.simpleMessage("Soapmaking"),
    "attr_social_media": MessageLookupByLibrary.simpleMessage("Social media"),
    "attr_socializing": MessageLookupByLibrary.simpleMessage("Socializing"),
    "attr_software_development": MessageLookupByLibrary.simpleMessage(
      "Software development",
    ),
    "attr_spare_parts": MessageLookupByLibrary.simpleMessage("Spare parts"),
    "attr_spirituality": MessageLookupByLibrary.simpleMessage("Spirituality"),
    "attr_sports": MessageLookupByLibrary.simpleMessage("Sports"),
    "attr_sports_coaching": MessageLookupByLibrary.simpleMessage(
      "Sports coaching",
    ),
    "attr_stand_up_comedy": MessageLookupByLibrary.simpleMessage(
      "Stand-up comedy",
    ),
    "attr_storytelling": MessageLookupByLibrary.simpleMessage("Storytelling"),
    "attr_study_partner": MessageLookupByLibrary.simpleMessage("Study partner"),
    "attr_sudoku": MessageLookupByLibrary.simpleMessage("Sudoku"),
    "attr_sustainable_living": MessageLookupByLibrary.simpleMessage(
      "Sustainable living",
    ),
    "attr_table_tennis": MessageLookupByLibrary.simpleMessage("Table tennis"),
    "attr_tea": MessageLookupByLibrary.simpleMessage("Tea"),
    "attr_technical_writing": MessageLookupByLibrary.simpleMessage(
      "Technical writing",
    ),
    "attr_technician": MessageLookupByLibrary.simpleMessage("Technician"),
    "attr_tennis": MessageLookupByLibrary.simpleMessage("Tennis"),
    "attr_thrifting": MessageLookupByLibrary.simpleMessage("Thrifting"),
    "attr_tiny_homes": MessageLookupByLibrary.simpleMessage("Tiny homes"),
    "attr_tool_lending": MessageLookupByLibrary.simpleMessage("Tool lending"),
    "attr_tractor": MessageLookupByLibrary.simpleMessage("Tractor"),
    "attr_translation_services": MessageLookupByLibrary.simpleMessage(
      "Translation services",
    ),
    "attr_traveling": MessageLookupByLibrary.simpleMessage("Traveling"),
    "attr_trees": MessageLookupByLibrary.simpleMessage("Trees"),
    "attr_truck_driving": MessageLookupByLibrary.simpleMessage("Truck driving"),
    "attr_upcycling": MessageLookupByLibrary.simpleMessage("Upcycling"),
    "attr_urban_exploration": MessageLookupByLibrary.simpleMessage(
      "Urban exploration",
    ),
    "attr_used_books": MessageLookupByLibrary.simpleMessage("Used books"),
    "attr_used_electronics": MessageLookupByLibrary.simpleMessage(
      "Used electronics",
    ),
    "attr_used_furniture": MessageLookupByLibrary.simpleMessage(
      "Used furniture",
    ),
    "attr_ux_design": MessageLookupByLibrary.simpleMessage("UX design"),
    "attr_vegetable_harvesting": MessageLookupByLibrary.simpleMessage(
      "Vegetable harvesting",
    ),
    "attr_vehicle_repair": MessageLookupByLibrary.simpleMessage(
      "Vehicle repair",
    ),
    "attr_video_editing": MessageLookupByLibrary.simpleMessage("Video editing"),
    "attr_video_game_consoles": MessageLookupByLibrary.simpleMessage(
      "Video game consoles",
    ),
    "attr_video_game_developing": MessageLookupByLibrary.simpleMessage(
      "Video game developing",
    ),
    "attr_vintage_clothing": MessageLookupByLibrary.simpleMessage(
      "Vintage clothing",
    ),
    "attr_virtual_reality": MessageLookupByLibrary.simpleMessage(
      "Virtual reality",
    ),
    "attr_vocals": MessageLookupByLibrary.simpleMessage("Vocals"),
    "attr_voice_lessons": MessageLookupByLibrary.simpleMessage("Voice lessons"),
    "attr_volunteering": MessageLookupByLibrary.simpleMessage("Volunteering"),
    "attr_weaving": MessageLookupByLibrary.simpleMessage("Weaving"),
    "attr_weight_training": MessageLookupByLibrary.simpleMessage(
      "Weight training",
    ),
    "attr_welding": MessageLookupByLibrary.simpleMessage("Welding"),
    "attr_window_cleaning": MessageLookupByLibrary.simpleMessage(
      "Window cleaning",
    ),
    "attr_wood_carving": MessageLookupByLibrary.simpleMessage("Wood carving"),
    "attr_woodworking": MessageLookupByLibrary.simpleMessage("Woodworking"),
    "attr_writing": MessageLookupByLibrary.simpleMessage("Writing"),
    "attr_yard_work": MessageLookupByLibrary.simpleMessage("Yard work"),
    "attr_yoga": MessageLookupByLibrary.simpleMessage("Yoga"),
    "attr_zen": MessageLookupByLibrary.simpleMessage("Zen"),
    "attr_zumba": MessageLookupByLibrary.simpleMessage("Zumba"),
    "attributeMatch": MessageLookupByLibrary.simpleMessage("Attribute Match"),
    "attributePreferencesHint": MessageLookupByLibrary.simpleMessage(
      "Set notification preferences for your interests and offerings",
    ),
    "attributes": MessageLookupByLibrary.simpleMessage("Attributes"),
    "attributesSelected": MessageLookupByLibrary.simpleMessage("selected"),
    "beSpecificAndConstructive": MessageLookupByLibrary.simpleMessage(
      "Be specific and constructive",
    ),
    "block": MessageLookupByLibrary.simpleMessage("Block"),
    "blockUser": MessageLookupByLibrary.simpleMessage("Block User"),
    "blockUserConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to block this user? You will no longer be able to communicate with them.",
    ),
    "blockUserConfirmationDetailed": m0,
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
    "chats": MessageLookupByLibrary.simpleMessage("Chats"),
    "chooseFromGallery": MessageLookupByLibrary.simpleMessage(
      "Choose from Device",
    ),
    "clearQuietHours": MessageLookupByLibrary.simpleMessage(
      "Clear Quiet Hours",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "closeLocations": MessageLookupByLibrary.simpleMessage("Close Locations"),
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
    "copyLink": MessageLookupByLibrary.simpleMessage("Copy Link"),
    "couldNotFindChatParticipant": MessageLookupByLibrary.simpleMessage(
      "Could not find chat participant",
    ),
    "couldNotOpenFile": m1,
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
    "createPreferences": MessageLookupByLibrary.simpleMessage(
      "Save Preferences",
    ),
    "createYourFirstWishlistItem": MessageLookupByLibrary.simpleMessage(
      "Create your first wishlist item to get notified when matches appear",
    ),
    "daily": MessageLookupByLibrary.simpleMessage("Daily"),
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
    "dismiss": MessageLookupByLibrary.simpleMessage("Dismiss"),
    "dismissMatch": MessageLookupByLibrary.simpleMessage("Dismiss Match"),
    "dismissMatchConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to dismiss this match?",
    ),
    "dismissed": MessageLookupByLibrary.simpleMessage("Dismissed"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "downloadFailed": m2,
    "downloadStarted": MessageLookupByLibrary.simpleMessage(
      "Download started! Check your downloads folder",
    ),
    "downloadingFile": m3,
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
    "emailRequired": MessageLookupByLibrary.simpleMessage(
      "Email address is required",
    ),
    "emailSaved": MessageLookupByLibrary.simpleMessage(
      "Email address saved successfully",
    ),
    "marketingConsentLabel": MessageLookupByLibrary.simpleMessage(
      "I agree to receive marketing emails about new features, offers, and updates",
    ),
    "marketingConsentDescription": MessageLookupByLibrary.simpleMessage(
      "We may send you occasional emails about our services. You can unsubscribe at any time.",
    ),
    "marketingConsentRequired": MessageLookupByLibrary.simpleMessage(
      "Please consent to receive marketing emails to continue",
    ),
    "emailUpdated": MessageLookupByLibrary.simpleMessage("Email updated"),
    "enableNotifications": MessageLookupByLibrary.simpleMessage(
      "Enable Notifications",
    ),
    "enableNotificationsDescription": MessageLookupByLibrary.simpleMessage(
      "Receive notifications for matches and updates",
    ),
    "endTime": MessageLookupByLibrary.simpleMessage("End Time"),
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
    "errorCreatingTransaction": m4,
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
    "errorFindingLocation": m5,
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
    "errorOpeningFile": m6,
    "errorUpdatingFavorite": MessageLookupByLibrary.simpleMessage(
      "Error updating favorite",
    ),
    "errorUpdatingTransaction": m7,
    "errorUpdatingWishlistItem": MessageLookupByLibrary.simpleMessage(
      "Error updating wishlist item",
    ),
    "errorVerifyingPin": MessageLookupByLibrary.simpleMessage(
      "Error verifying PIN",
    ),
    "errorWithException": m8,
    "errorWithMessage": m9,
    "expirationDate": MessageLookupByLibrary.simpleMessage("Expiration Date"),
    "expires": MessageLookupByLibrary.simpleMessage("Expires"),
    "expiresPrefix": MessageLookupByLibrary.simpleMessage("Expires"),
    "eyes": MessageLookupByLibrary.simpleMessage("Eyes"),
    "failedToBlockUser": MessageLookupByLibrary.simpleMessage(
      "Failed to block user",
    ),
    "failedToSubmitReport": MessageLookupByLibrary.simpleMessage(
      "Failed to submit report. Please try again.",
    ),
    "failedToSubmitReview": MessageLookupByLibrary.simpleMessage(
      "Failed to submit review",
    ),
    "failedToSubmitAppeal": MessageLookupByLibrary.simpleMessage(
      "Failed to submit appeal",
    ),
    "failedToUnblockUser": MessageLookupByLibrary.simpleMessage(
      "Failed to unblock user",
    ),
    "falseReportsWarning": MessageLookupByLibrary.simpleMessage(
      "False reports may result in penalties to your account.",
    ),
    "fileNotFound": m10,
    "fileSavedAt": m11,
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
    "generateAvatar": MessageLookupByLibrary.simpleMessage("Generate Avatar"),
    "generateCryptoWallet": MessageLookupByLibrary.simpleMessage(
      "Generate Crypto Wallet",
    ),
    "generateWallet": MessageLookupByLibrary.simpleMessage("Generate Wallet"),
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
    "instant": MessageLookupByLibrary.simpleMessage("Instant"),
    "interest": MessageLookupByLibrary.simpleMessage("Interest"),
    "inviteMessageShare": m12,
    "inviteMessageSubject": MessageLookupByLibrary.simpleMessage(
      "Join me on BarterApp!",
    ),
    "keep": MessageLookupByLibrary.simpleMessage("Keep"),
    "languageEnglish": MessageLookupByLibrary.simpleMessage("English"),
    "languageFrench": MessageLookupByLibrary.simpleMessage("Français"),
    "languageGerman": MessageLookupByLibrary.simpleMessage("Deutsch"),
    "languageLatvian": MessageLookupByLibrary.simpleMessage("Latviešu"),
    "languageSpanish": MessageLookupByLibrary.simpleMessage("Español"),
    "linkCopiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "Link copied to clipboard!",
    ),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "locationNotFound": MessageLookupByLibrary.simpleMessage(
      "Location not found.",
    ),
    "locationSaved": MessageLookupByLibrary.simpleMessage("Location saved!"),
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
    "match": MessageLookupByLibrary.simpleMessage("Match"),
    "matchDismissed": MessageLookupByLibrary.simpleMessage("Match dismissed"),
    "matchHistory": MessageLookupByLibrary.simpleMessage("Match History"),
    "matchScore": MessageLookupByLibrary.simpleMessage("Match Score"),
    "matches": MessageLookupByLibrary.simpleMessage("Matches"),
    "maxImagesReached": MessageLookupByLibrary.simpleMessage(
      "Maximum 3 images allowed",
    ),
    "minMatchScore": MessageLookupByLibrary.simpleMessage("Min. Match Score"),
    "mockPoiNotFound": m13,
    "mockPoiNotFoundForUpdate": m14,
    "mouth": MessageLookupByLibrary.simpleMessage("Mouth"),
    "myWishlist": MessageLookupByLibrary.simpleMessage("My Wishlist"),
    "need": MessageLookupByLibrary.simpleMessage("Need"),
    "newBadge": MessageLookupByLibrary.simpleMessage("NEW"),
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
    "noChatsYet": MessageLookupByLibrary.simpleMessage("No chats yet"),
    "noContactsFound": MessageLookupByLibrary.simpleMessage(
      "No contacts found",
    ),
    "noMatchesYet": MessageLookupByLibrary.simpleMessage("No matches yet"),
    "noMessagesYet": MessageLookupByLibrary.simpleMessage("No messages yet"),
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
    "noUsersNearbyMessage": MessageLookupByLibrary.simpleMessage(
      "It looks like there are no users in your area yet. Be the first to invite your friends and start bartering!",
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
    "optionalField": MessageLookupByLibrary.simpleMessage("Optional"),
    "or": MessageLookupByLibrary.simpleMessage("OR"),
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
    "pinErrorIncorrect": m15,
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
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "privacyPolicyChangesContent": MessageLookupByLibrary.simpleMessage(
      "We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy in the app. Continued use of the app after changes constitutes acceptance of the updated policy.",
    ),
    "privacyPolicyChangesTitle": MessageLookupByLibrary.simpleMessage(
      "Changes to This Policy",
    ),
    "privacyPolicyContactContent": MessageLookupByLibrary.simpleMessage(
      "If you have any questions about this Privacy Policy or our data practices, please contact us at info@bartering.app",
    ),
    "privacyPolicyContactTitle": MessageLookupByLibrary.simpleMessage(
      "Contact Us",
    ),
    "privacyPolicyDataCollectionContent": MessageLookupByLibrary.simpleMessage(
      "We collect information you provide directly, including your profile information, interests, offerings, location data, and chat messages. We also collect usage data such as app interactions and device information to improve our service.",
    ),
    "privacyPolicyDataCollectionTitle": MessageLookupByLibrary.simpleMessage(
      "Information We Collect",
    ),
    "privacyPolicyDataSecurityContent": MessageLookupByLibrary.simpleMessage(
      "We implement appropriate technical and organizational measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure.",
    ),
    "privacyPolicyDataSecurityTitle": MessageLookupByLibrary.simpleMessage(
      "Data Security",
    ),
    "privacyPolicyDataSharingContent": MessageLookupByLibrary.simpleMessage(
      "Your profile information, interests, and offerings are visible to other users of the app to facilitate bartering. We do not sell your personal information to third parties. We may share data with service providers who assist in operating our app, and we may disclose information if required by law.",
    ),
    "privacyPolicyDataSharingTitle": MessageLookupByLibrary.simpleMessage(
      "Information Sharing",
    ),
    "privacyPolicyDataUsageContent": MessageLookupByLibrary.simpleMessage(
      "We use your information to: facilitate bartering connections between users, display your profile to other users in your area, enable chat functionality, improve our services, and send notifications about matches and messages.",
    ),
    "privacyPolicyDataUsageTitle": MessageLookupByLibrary.simpleMessage(
      "How We Use Your Information",
    ),
    "privacyPolicyIntroContent": MessageLookupByLibrary.simpleMessage(
      "This Privacy Policy describes how we collect, use, and protect your personal information when you use our bartering application. We are committed to ensuring your privacy and protecting your data.",
    ),
    "privacyPolicyIntroTitle": MessageLookupByLibrary.simpleMessage(
      "Introduction",
    ),
    "privacyPolicyLastUpdated": MessageLookupByLibrary.simpleMessage(
      "Last updated: January 2026",
    ),
    "privacyPolicyThirdPartyContent": MessageLookupByLibrary.simpleMessage(
      "Our app may use third-party services for analytics, maps, and notifications. These services have their own privacy policies, and we encourage you to review them.",
    ),
    "privacyPolicyThirdPartyTitle": MessageLookupByLibrary.simpleMessage(
      "Third-Party Services",
    ),
    "privacyPolicyUserRightsContent": MessageLookupByLibrary.simpleMessage(
      "You have the right to access, update, or delete your personal information at any time through the app settings. You can also request a copy of your data or object to certain types of processing.",
    ),
    "privacyPolicyUserRightsTitle": MessageLookupByLibrary.simpleMessage(
      "Your Rights",
    ),
    "privateKey": MessageLookupByLibrary.simpleMessage("Private Key"),
    "profileDeleted": MessageLookupByLibrary.simpleMessage(
      "Profile deleted successfully",
    ),
    "provideMoreContext": MessageLookupByLibrary.simpleMessage(
      "Provide more context...",
    ),
    "publicKey": MessageLookupByLibrary.simpleMessage("Public Key"),
    "pushNotifications": MessageLookupByLibrary.simpleMessage(
      "Push Notifications",
    ),
    "pushTokenRemoved": MessageLookupByLibrary.simpleMessage(
      "Push token removed",
    ),
    "questionsAnswered": m16,
    "quietHours": MessageLookupByLibrary.simpleMessage("Quiet Hours"),
    "quietHoursDescription": MessageLookupByLibrary.simpleMessage(
      "Do not send notifications during these hours",
    ),
    "randomize": MessageLookupByLibrary.simpleMessage("Randomize"),
    "ratingExcellent": MessageLookupByLibrary.simpleMessage("Excellent"),
    "ratingGood": MessageLookupByLibrary.simpleMessage("Good"),
    "ratingOkay": MessageLookupByLibrary.simpleMessage("Okay"),
    "ratingPoor": MessageLookupByLibrary.simpleMessage("Poor"),
    "ratingRequired": MessageLookupByLibrary.simpleMessage("Rating *"),
    "ratingVeryBad": MessageLookupByLibrary.simpleMessage("Very Bad"),
    "recommendations": MessageLookupByLibrary.simpleMessage("Recommendations:"),
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
    "reportUserTitle": m17,
    "resetLinkSentMessage": MessageLookupByLibrary.simpleMessage(
      "If an account exists, a reset link has been sent.",
    ),
    "resetYourPin": MessageLookupByLibrary.simpleMessage("Reset Your PIN"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "review": MessageLookupByLibrary.simpleMessage("Review"),
    "reviewGuidelines": MessageLookupByLibrary.simpleMessage(
      "Review Guidelines",
    ),
    "reviewSubmitted": MessageLookupByLibrary.simpleMessage(
      "Review Submitted!",
    ),
    "reviewUser": m18,
    "reviewVisibilityNotice": m19,
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
    "securityAnswerIncorrect": m20,
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
    "selectLocation": MessageLookupByLibrary.simpleMessage("Select Location"),
    "selectSecurityQuestion": MessageLookupByLibrary.simpleMessage(
      "Select a question",
    ),
    "selectTheInterestsThatMatchYourPreferences":
        MessageLookupByLibrary.simpleMessage(
          "What do you need? What would you like assistance with?\nYou can change this later.",
        ),
    "selectTheOffersThatYouCanProvide": MessageLookupByLibrary.simpleMessage(
      "What can you provide or help out with?\nYou can change this later.",
    ),
    "selectYourInterests": MessageLookupByLibrary.simpleMessage(
      "What would be of interest to you?",
    ),
    "selectYourOffers": MessageLookupByLibrary.simpleMessage(
      "What do you have to offer?",
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
    "styleNumber": m21,
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
    "tellUsMore": MessageLookupByLibrary.simpleMessage(
      "Tell us more (optional)",
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
    "unableToSubmitAppealNow": MessageLookupByLibrary.simpleMessage(
      "Unable to submit appeal right now",
    ),
    "unableToShareAtThisTime": MessageLookupByLibrary.simpleMessage(
      "Unable to share at this time",
    ),
    "unblock": MessageLookupByLibrary.simpleMessage("Unblock"),
    "unblockUser": MessageLookupByLibrary.simpleMessage("Unblock User"),
    "unblockUserConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to unblock this user? They will be able to communicate with you again.",
    ),
    "unblockUserConfirmationDetailed": m22,
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
    "verifyAndResetPin": MessageLookupByLibrary.simpleMessage(
      "Verify and Reset PIN",
    ),
    "viewMatches": MessageLookupByLibrary.simpleMessage("View Matches"),
    "weekly": MessageLookupByLibrary.simpleMessage("Weekly"),
    "welcomeStep1Description": MessageLookupByLibrary.simpleMessage(
      "Create an anonymous profile with your interests and what you have to offer",
    ),
    "welcomeStep1Title": MessageLookupByLibrary.simpleMessage(
      "Create your Profile",
    ),
    "welcomeStep2Description": MessageLookupByLibrary.simpleMessage(
      "Find similar or complementary people, search by keywords",
    ),
    "welcomeStep2Title": MessageLookupByLibrary.simpleMessage(
      "Discover, Search, Post",
    ),
    "welcomeStep3Description": MessageLookupByLibrary.simpleMessage(
      "Connect with others through End-to-end encrypted chat",
    ),
    "welcomeStep3Title": MessageLookupByLibrary.simpleMessage("Start Chatting"),
    "welcomeStep4Description": MessageLookupByLibrary.simpleMessage(
      "Trade skills, services, items, or simply connect with your community",
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
  };
}
