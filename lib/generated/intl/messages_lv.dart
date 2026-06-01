// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a lv locale. All the
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
  String get localeName => 'lv';

  static String m0(amount) => "Bilance: ${amount} ₿";

  static String m1(coins) => "Pirkt par ${coins} ₿";

  static String m2(price) => "Katrs avatārs: ${price} ₿";

  static String m3(error) => "Neizdevās ielādēt avatāru veikalu: ${error}";

  static String m4(coins) => "${coins} ₿";

  static String m5(coins) =>
      "Nepietiek monētu. Nepieciešamas ${coins} monētas.";

  static String m6(error) => "Pirkums neizdevās: ${error}";

  static String m7(userName) =>
      "Bloķējot ${userName}, viņi nevarēs:\n• Sūtīt jums ziņojumus\n• Skatīt jūsu profilu\n• Komentēt jūsu sludinājumus";

  static String m8(email) => "Atjaunošanas kods nosūtīts uz ${email}";

  static String m9(error) => "Neizdevās atvērt failu: ${error}";

  static String m10(amount) => "Pašreizējais maka atlikums: ${amount}";

  static String m11(filename) => "Atšifrē ${filename}...";

  static String m12(error) => "Lejupielāde neizdevās: ${error}";

  static String m13(filename) => "Notiek ${filename} lejupielāde...";

  static String m14(error) => "Kļūda transakcijas izveidē: ${error}";

  static String m15(error) => "Kļūda atrašanās vietas meklēšanā: ${error}";

  static String m16(message) => "Kļūda faila atvēršanā: ${message}";

  static String m17(error) => "Kļūda transakcijas atjaunināšanā: ${error}";

  static String m18(exception) => "Kļūda: ${exception}";

  static String m19(errorMessage) => "Kļūda: ${errorMessage}";

  static String m20(time) => "Derīgs vēl: ${time}";

  static String m21(filePath) => "Fails nav atrasts: ${filePath}";

  static String m22(filePath) => "Fails saglabāts: ${filePath}";

  static String m23(appLink) =>
      "Čau! Pievienojies man BarterApp - lielisks veids, kā mainīt priekšmetus un pakalpojumus ar cilvēkiem tuvumā! 🔄\n\n${appLink}";

  static String m24(count) => "pirms ${count} d";

  static String m25(count) => "pirms ${count} st";

  static String m26(count) => "pirms ${count} min";

  static String m27(count) =>
      "${count} ${Intl.plural(count, one: 'atbilstošs', other: 'atbilstoši')} ${Intl.plural(count, one: 'sludinājumi', other: 'sludinājumi')}";

  static String m28(count) =>
      "${count} ${Intl.plural(count, one: 'atbilstošs', other: 'atbilstoši')} ${Intl.plural(count, one: 'lietotājs', other: 'lietotāji')}";

  static String m29(id) => "Testa POI ar id ${id} nav atrasts servisā";

  static String m30(id) => "Testa POI ar id ${id} nav atrasts atjaunināšanai";

  static String m31(count) => "Paziņot, kad tuvumā ir ${count}+ lietotāji";

  static String m32(email) => "Paziņojumus var nosūtīt uz ${email}";

  static String m33(attempts) => "Nepareizs PIN kods (Mēģinājums ${attempts})";

  static String m34(fileName) => "Atlasīts: ${fileName}";

  static String m35(count) => "${count} atbildēti jautājumi";

  static String m36(userName) => "Ziņot par ${userName}";

  static String m37(seconds) => "Nosūtīt kodu pēc ${seconds}s";

  static String m38(userName) => "Atsauksmēt ${userName}";

  static String m39(count) =>
      "${count} ${Intl.plural(count, one: 'atsauksme', other: 'atsauksmes')}";

  static String m40(attempts) => "Nepareiza atbilde (Mēģinājums ${attempts})";

  static String m41(amount) => "Izvēlētā monētu pakotne: ${amount}";

  static String m42(number) => "Stils ${number}";

  static String m43(userName) =>
      "Atbloķējot ${userName}, viņi varēs:\n• Sūtīt jums ziņojumus\n• Skatīt jūsu profilu\n• Komentēt jūsu sludinājumus";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accountDeletionCodeHint": MessageLookupByLibrary.simpleMessage(
      "Ievadiet kodu no e-pasta",
    ),
    "accountDeletionCodeInvalid": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, ievadiet derīgu verifikācijas kodu.",
    ),
    "accountDeletionCodeLabel": MessageLookupByLibrary.simpleMessage(
      "Verifikācijas kods",
    ),
    "accountDeletionCodeSent": MessageLookupByLibrary.simpleMessage(
      "Verifikācijas kods nosūtīts. Lūdzu, pārbaudiet savu e-pastu.",
    ),
    "accountDeletionConfirmButton": MessageLookupByLibrary.simpleMessage(
      "Apstiprināt konta dzēšanu",
    ),
    "accountDeletionDataDeletedItems": MessageLookupByLibrary.simpleMessage(
      "- Konta reģistrācijas datus un profilu\n- Ierīču atslēgas un migrācijas/atjaunošanas sesijas\n- Sludinājumus un saistītos augšupielādētos attēlus\n- Atribūtus, saites, ziņojumus un favorītu/atbilstību vēsturi\n- Ziņojumus, izlasīšanas statusus, šifrēto failu metadatus un čata atbilžu statistiku\n- Atsauksmes, reputāciju, darījumus, moderēšanas/apelāciju un atsauksmju audita datus\n- Paziņojumu kontaktus un paziņojumu iestatījumus\n- Klātbūtnes/aktivitātes keša ierakstus un saistītās analītikas/atrašanās vietas izsekošanas rindas",
    ),
    "accountDeletionDataDeletedTitle": MessageLookupByLibrary.simpleMessage(
      "Pēc apstiprinājuma mēs neatgriezeniski dzēsīsim:",
    ),
    "accountDeletionDataDeletedTitleAfterConfirmed":
        MessageLookupByLibrary.simpleMessage(
          "Jūsu lietotāja profils ir dzēsts, ar šādiem datiem:",
        ),
    "accountDeletionEmailLabel": MessageLookupByLibrary.simpleMessage(
      "Konta e-pasts",
    ),
    "accountDeletionHeader": MessageLookupByLibrary.simpleMessage(
      "Pieprasīt konta dzēšanu",
    ),
    "accountDeletionInfo": MessageLookupByLibrary.simpleMessage(
      "Izmantojiet šo lapu, lai pieprasītu neatgriezenisku konta dzēšanu. Pēc procesa pabeigšanas jūsu profils un saistītie konta dati tiks dzēsti saskaņā ar mūsu datu glabāšanas politiku.",
    ),
    "accountDeletionSendCodeButton": MessageLookupByLibrary.simpleMessage(
      "Nosūtīt verifikācijas kodu",
    ),
    "accountDeletionSteps": MessageLookupByLibrary.simpleMessage(
      "Soļi:\n1. Ievadiet sava konta e-pastu\n2. Iesniedziet pieprasījumu, lai saņemtu verifikācijas kodu\n3. Ievadiet kodu, lai apstiprinātu dzēšanu",
    ),
    "accountDeletionSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Dzēšanas pieprasījums veiksmīgi iesniegts. Mūsu komanda apstrādās jūsu pieprasījumu, un konts tiks dzēsts pēc verifikācijas.",
    ),
    "accountDeletionTitle": MessageLookupByLibrary.simpleMessage("Dzēst kontu"),
    "accountDeletionTokenInfo": MessageLookupByLibrary.simpleMessage(
      "Konta dzēšanas pieprasījums apstiprināts. Šī darbība ir neatgriezeniska un to nevar atsaukt.",
    ),
    "accountSetupSuccess": MessageLookupByLibrary.simpleMessage(
      "Jūsu konts ir iestatīts!",
    ),
    "activateWishlist": MessageLookupByLibrary.simpleMessage("Aktivizēt"),
    "activePostings": MessageLookupByLibrary.simpleMessage(
      "Aktīvie sludinājumi",
    ),
    "add": MessageLookupByLibrary.simpleMessage("Pievienot"),
    "addAttributes": MessageLookupByLibrary.simpleMessage(
      "Pievienot atribūtus",
    ),
    "addImage": MessageLookupByLibrary.simpleMessage("Pievienot attēlu"),
    "addNewPosting": MessageLookupByLibrary.simpleMessage(
      "Pievienot sludinājumu",
    ),
    "addWishlistItem": MessageLookupByLibrary.simpleMessage(
      "Pievienot vēlmju saraksta vienumu",
    ),
    "addYourOwnKeywords": MessageLookupByLibrary.simpleMessage(
      "Pievienojiet savus atslēgvārdus",
    ),
    "additionalDetails": MessageLookupByLibrary.simpleMessage(
      "Papildu informācija (neobligāti)",
    ),
    "allAttributesHavePreferences": MessageLookupByLibrary.simpleMessage(
      "Visiem atribūtiem no jūsu profila jau ir paziņojumu iestatījumi",
    ),
    "allMatchesDeleted": MessageLookupByLibrary.simpleMessage(
      "Visas atbilstības ir dzēstas",
    ),
    "allow": MessageLookupByLibrary.simpleMessage("Atļaut"),
    "anUnknownErrorOccurred": MessageLookupByLibrary.simpleMessage(
      "Radās nezināma kļūda.",
    ),
    "answerHint": MessageLookupByLibrary.simpleMessage("Ievadiet savu atbildi"),
    "answerSecurityQuestion": MessageLookupByLibrary.simpleMessage(
      "Atbildēt uz drošības jautājumu",
    ),
    "answerTooShort": MessageLookupByLibrary.simpleMessage(
      "Atbildei jābūt vismaz 2 rakstzīmēm",
    ),
    "apiErrorAuthSessionExpired": MessageLookupByLibrary.simpleMessage(
      "Sesija beidzās. Lūdzu, autorizējieties vēlreiz.",
    ),
    "apiErrorBadRequest": MessageLookupByLibrary.simpleMessage(
      "Pieprasījumā ir kļūda. Lūdzu, pārbaudiet datus un mēģiniet vēlreiz.",
    ),
    "apiErrorConflict": MessageLookupByLibrary.simpleMessage(
      "Konflikts ar esošiem datiem. Lūdzu, atjaunojiet un mēģiniet vēlreiz.",
    ),
    "apiErrorFavoriteUsersFallback": MessageLookupByLibrary.simpleMessage(
      "Pašlaik neizdodas ielādēt iecienītos lietotājus.",
    ),
    "apiErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "Jums nav piekļuves šai darbībai.",
    ),
    "apiErrorMatchingUsersFallback": MessageLookupByLibrary.simpleMessage(
      "Pašlaik neizdodas ielādēt atbilstošus lietotājus.",
    ),
    "apiErrorNearbyUsersFallback": MessageLookupByLibrary.simpleMessage(
      "Pašlaik neizdodas ielādēt tuvumā esošos lietotājus.",
    ),
    "apiErrorNoInternet": MessageLookupByLibrary.simpleMessage(
      "Nav savienojuma ar internetu. Pārbaudiet tīklu un mēģiniet vēlreiz.",
    ),
    "apiErrorNotFound": MessageLookupByLibrary.simpleMessage(
      "Pieprasītais resurss nav atrasts.",
    ),
    "apiErrorSearchUsersFallback": MessageLookupByLibrary.simpleMessage(
      "Pašlaik neizdodas meklēt lietotājus.",
    ),
    "apiErrorServer": MessageLookupByLibrary.simpleMessage(
      "Servera kļūda. Lūdzu, mēģiniet vēlreiz vēlāk.",
    ),
    "apiErrorSimilarUsersFallback": MessageLookupByLibrary.simpleMessage(
      "Pašlaik neizdodas ielādēt līdzīgus lietotājus.",
    ),
    "apiErrorTimeout": MessageLookupByLibrary.simpleMessage(
      "Pieprasījums aizņēma pārāk ilgu laiku. Lūdzu, mēģiniet vēlreiz.",
    ),
    "apiErrorValidation": MessageLookupByLibrary.simpleMessage(
      "Daži ievadītie dati nav derīgi.",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("Barters.lv"),
    "appealReasonRequired": MessageLookupByLibrary.simpleMessage(
      "Apelācijas iemesls ir obligāts",
    ),
    "appealReviewReasonHint": MessageLookupByLibrary.simpleMessage(
      "Aprakstiet, kāpēc šī atsauksme būtu jāpārskata",
    ),
    "appealReviewTitle": MessageLookupByLibrary.simpleMessage(
      "Apstrīdēt atsauksmi",
    ),
    "archive": MessageLookupByLibrary.simpleMessage("Arhivēt"),
    "archiveConversationMessage": MessageLookupByLibrary.simpleMessage(
      "Vai vēlaties tagad arhivēt šo sarunu?",
    ),
    "archiveConversationTitle": MessageLookupByLibrary.simpleMessage(
      "Arhivēt sarunu?",
    ),
    "archiveWishlist": MessageLookupByLibrary.simpleMessage("Arhivēt"),
    "atLeastOneKeyword": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, ievadiet vismaz vienu atslēgvārdu",
    ),
    "attr_3d_printing": MessageLookupByLibrary.simpleMessage("3D drukāšana"),
    "attr_academic_tutoring": MessageLookupByLibrary.simpleMessage(
      "Akadēmiskā mācīšana",
    ),
    "attr_acting": MessageLookupByLibrary.simpleMessage("Aktierspēle"),
    "attr_administrative_work": MessageLookupByLibrary.simpleMessage(
      "Administratīvais darbs",
    ),
    "attr_ai_consulting": MessageLookupByLibrary.simpleMessage(
      "MI konsultācijas",
    ),
    "attr_alternative_healing": MessageLookupByLibrary.simpleMessage(
      "Alternatīvā dziedināšana",
    ),
    "attr_alternative_medicine": MessageLookupByLibrary.simpleMessage(
      "Alternatīvā medicīna",
    ),
    "attr_android": MessageLookupByLibrary.simpleMessage("Android"),
    "attr_animal_care": MessageLookupByLibrary.simpleMessage(
      "Dzīvnieku aprūpe",
    ),
    "attr_animation": MessageLookupByLibrary.simpleMessage("Animācija"),
    "attr_app_development": MessageLookupByLibrary.simpleMessage(
      "Lietotņu izstrāde",
    ),
    "attr_art_exhibitions": MessageLookupByLibrary.simpleMessage(
      "Mākslas izstādes",
    ),
    "attr_artificial_intelligence": MessageLookupByLibrary.simpleMessage(
      "Mākslīgais intelekts",
    ),
    "attr_astronomy": MessageLookupByLibrary.simpleMessage("Astronomija"),
    "attr_audio_equipment": MessageLookupByLibrary.simpleMessage(
      "Audio aprīkojums",
    ),
    "attr_babysitting": MessageLookupByLibrary.simpleMessage(
      "Bērnu pieskatīšana",
    ),
    "attr_backend_development": MessageLookupByLibrary.simpleMessage(
      "Backend izstrāde",
    ),
    "attr_backpacking": MessageLookupByLibrary.simpleMessage("Backpacking"),
    "attr_baking": MessageLookupByLibrary.simpleMessage("Cepšana"),
    "attr_beauty_products": MessageLookupByLibrary.simpleMessage(
      "Skaistumkopšanas produkti",
    ),
    "attr_beekeeping": MessageLookupByLibrary.simpleMessage("Biškopība"),
    "attr_bicycle_parts": MessageLookupByLibrary.simpleMessage(
      "Velosipēdu detaļas",
    ),
    "attr_bicycles": MessageLookupByLibrary.simpleMessage("Velosipēdi"),
    "attr_billiards": MessageLookupByLibrary.simpleMessage("Biljards"),
    "attr_biohacking": MessageLookupByLibrary.simpleMessage("Biohakings"),
    "attr_board_games": MessageLookupByLibrary.simpleMessage("Galda spēles"),
    "attr_bodybuilding": MessageLookupByLibrary.simpleMessage("Bodibildings"),
    "attr_bookkeeping": MessageLookupByLibrary.simpleMessage("Grāmatvedība"),
    "attr_books": MessageLookupByLibrary.simpleMessage("Grāmatas"),
    "attr_bowling": MessageLookupByLibrary.simpleMessage("Boulings"),
    "attr_breadmaking": MessageLookupByLibrary.simpleMessage("Maizes cepšana"),
    "attr_building_materials": MessageLookupByLibrary.simpleMessage(
      "Celtniecības materiāli",
    ),
    "attr_business_mentorship": MessageLookupByLibrary.simpleMessage(
      "Biznesa mentorings",
    ),
    "attr_camping": MessageLookupByLibrary.simpleMessage("Kempings"),
    "attr_camping_gear": MessageLookupByLibrary.simpleMessage(
      "Kempinga aprīkojums",
    ),
    "attr_canned_goods": MessageLookupByLibrary.simpleMessage(
      "Konservēti produkti",
    ),
    "attr_canyoning": MessageLookupByLibrary.simpleMessage("Kanjonu tūrisms"),
    "attr_car_cleaning": MessageLookupByLibrary.simpleMessage("Auto tīrīšana"),
    "attr_car_detailing": MessageLookupByLibrary.simpleMessage("Auto tjūnings"),
    "attr_car_maintenance": MessageLookupByLibrary.simpleMessage("Auto apkope"),
    "attr_car_restoration": MessageLookupByLibrary.simpleMessage(
      "Auto restaurācija",
    ),
    "attr_card_games": MessageLookupByLibrary.simpleMessage("Kāršu spēles"),
    "attr_carpentry": MessageLookupByLibrary.simpleMessage("Namdaru darbi"),
    "attr_cats": MessageLookupByLibrary.simpleMessage("Kaķi"),
    "attr_ceramics": MessageLookupByLibrary.simpleMessage("Keramika"),
    "attr_charity_work": MessageLookupByLibrary.simpleMessage(
      "Labdarības darbs",
    ),
    "attr_chess": MessageLookupByLibrary.simpleMessage("Šahs"),
    "attr_chicken_eggs": MessageLookupByLibrary.simpleMessage("Vistu olas"),
    "attr_cleaning": MessageLookupByLibrary.simpleMessage("Tīrīšana"),
    "attr_clothesmaking": MessageLookupByLibrary.simpleMessage(
      "Apģērbu šūšana",
    ),
    "attr_clothing": MessageLookupByLibrary.simpleMessage("Apģērbs"),
    "attr_co_op_gaming": MessageLookupByLibrary.simpleMessage(
      "Multi-player spēles",
    ),
    "attr_code_review": MessageLookupByLibrary.simpleMessage("Koda pārskats"),
    "attr_coding": MessageLookupByLibrary.simpleMessage("Programmēšana"),
    "attr_comic_books": MessageLookupByLibrary.simpleMessage("Komiksi"),
    "attr_community_gardening": MessageLookupByLibrary.simpleMessage(
      "Kopienas dārzkopība",
    ),
    "attr_computer_accessories": MessageLookupByLibrary.simpleMessage(
      "Datoru aksesuāri",
    ),
    "attr_computer_repair": MessageLookupByLibrary.simpleMessage(
      "Datoru remonts",
    ),
    "attr_concert_tickets": MessageLookupByLibrary.simpleMessage(
      "Koncerta biļetes",
    ),
    "attr_construction": MessageLookupByLibrary.simpleMessage("Celtniecība"),
    "attr_cooking": MessageLookupByLibrary.simpleMessage("Gatavošana"),
    "attr_couponing": MessageLookupByLibrary.simpleMessage(
      "Kuponu izmantošana",
    ),
    "attr_crafting": MessageLookupByLibrary.simpleMessage("Amatniecība"),
    "attr_crocheting": MessageLookupByLibrary.simpleMessage("Tamborēšana"),
    "attr_cross_stitch": MessageLookupByLibrary.simpleMessage(
      "Krustdūriena izšūšana",
    ),
    "attr_cryptocurrency": MessageLookupByLibrary.simpleMessage("Kriptovalūta"),
    "attr_culinary_arts": MessageLookupByLibrary.simpleMessage(
      "Kulinārijas māksla",
    ),
    "attr_cybersecurity": MessageLookupByLibrary.simpleMessage("Kiberdrošība"),
    "attr_cycling": MessageLookupByLibrary.simpleMessage("Riteņbraukšana"),
    "attr_dance_lessons": MessageLookupByLibrary.simpleMessage(
      "Deju nodarbības",
    ),
    "attr_dancing": MessageLookupByLibrary.simpleMessage("Dejas"),
    "attr_day_trading": MessageLookupByLibrary.simpleMessage(
      "Dienas tirdzniecība",
    ),
    "attr_deep_cleaning": MessageLookupByLibrary.simpleMessage(
      "Dziļā tīrīšana",
    ),
    "attr_device_lending": MessageLookupByLibrary.simpleMessage(
      "Ierīču aizdošana",
    ),
    "attr_digital_arts": MessageLookupByLibrary.simpleMessage(
      "Digitālā māksla",
    ),
    "attr_digital_products": MessageLookupByLibrary.simpleMessage(
      "Digitālie produkti",
    ),
    "attr_diy": MessageLookupByLibrary.simpleMessage("Dari pats"),
    "attr_dog_walking": MessageLookupByLibrary.simpleMessage("Suņu pastaigas"),
    "attr_dogs": MessageLookupByLibrary.simpleMessage("Suņi"),
    "attr_drawing": MessageLookupByLibrary.simpleMessage("Zīmēšana"),
    "attr_driving": MessageLookupByLibrary.simpleMessage("Vadīšana"),
    "attr_drones": MessageLookupByLibrary.simpleMessage("Droni"),
    "attr_drumming": MessageLookupByLibrary.simpleMessage("Bungu spēle"),
    "attr_elderly_care": MessageLookupByLibrary.simpleMessage(
      "Gados vecu cilvēku aprūpe",
    ),
    "attr_electronic_components": MessageLookupByLibrary.simpleMessage(
      "Elektronikas komponentes",
    ),
    "attr_electronics": MessageLookupByLibrary.simpleMessage("Elektronika"),
    "attr_embroidery": MessageLookupByLibrary.simpleMessage("Izšuvums"),
    "attr_engraving": MessageLookupByLibrary.simpleMessage("Gravēšana"),
    "attr_environmentalism": MessageLookupByLibrary.simpleMessage(
      "Vides aizsardzība",
    ),
    "attr_errand_running": MessageLookupByLibrary.simpleMessage(
      "Uzdevumu veikšana",
    ),
    "attr_event_hosting": MessageLookupByLibrary.simpleMessage(
      "Pasākumu organizēšana",
    ),
    "attr_event_tickets": MessageLookupByLibrary.simpleMessage(
      "Pasākumu biļetes",
    ),
    "attr_exercise_partner": MessageLookupByLibrary.simpleMessage(
      "Treniņu partneris",
    ),
    "attr_farm_animals": MessageLookupByLibrary.simpleMessage(
      "Lauksaimniecības dzīvnieki",
    ),
    "attr_farm_machinery": MessageLookupByLibrary.simpleMessage(
      "Lauksaimniecības tehnika",
    ),
    "attr_farmstay": MessageLookupByLibrary.simpleMessage(
      "Uzturēšanās lauku sētā",
    ),
    "attr_fashion_design": MessageLookupByLibrary.simpleMessage(
      "Modes dizains",
    ),
    "attr_filmmaking": MessageLookupByLibrary.simpleMessage("Filmu veidošana"),
    "attr_financial_investing": MessageLookupByLibrary.simpleMessage(
      "Finanšu investīcijas",
    ),
    "attr_firewood": MessageLookupByLibrary.simpleMessage("Malka"),
    "attr_fishing": MessageLookupByLibrary.simpleMessage("Makšķerēšana"),
    "attr_fitness_coaching": MessageLookupByLibrary.simpleMessage(
      "Fitnesa trenēšana",
    ),
    "attr_flower_arranging": MessageLookupByLibrary.simpleMessage(
      "Ziedu kompozīcijas",
    ),
    "attr_foraging": MessageLookupByLibrary.simpleMessage(
      "Pārtikas meklēšana dabā",
    ),
    "attr_forestry": MessageLookupByLibrary.simpleMessage("Mežsaimniecība"),
    "attr_fresh_herbs": MessageLookupByLibrary.simpleMessage("Svaigi garšaugi"),
    "attr_fruits": MessageLookupByLibrary.simpleMessage("Augļi"),
    "attr_gadgets": MessageLookupByLibrary.simpleMessage("Ierīces"),
    "attr_gaming": MessageLookupByLibrary.simpleMessage("Spēles"),
    "attr_gardening": MessageLookupByLibrary.simpleMessage("Dārzkopība"),
    "attr_gardening_advice": MessageLookupByLibrary.simpleMessage(
      "Dārzkopības padomi",
    ),
    "attr_graphic_design": MessageLookupByLibrary.simpleMessage(
      "Grafiskais dizains",
    ),
    "attr_hacking": MessageLookupByLibrary.simpleMessage("Hakings"),
    "attr_hair_styling": MessageLookupByLibrary.simpleMessage("Frizēšana"),
    "attr_handmade_items": MessageLookupByLibrary.simpleMessage("Rokdarbi"),
    "attr_handyman_services": MessageLookupByLibrary.simpleMessage(
      "Santehniķa pakalpojumi",
    ),
    "attr_hauling_services": MessageLookupByLibrary.simpleMessage(
      "Transporta pakalpojumi",
    ),
    "attr_health_supplements": MessageLookupByLibrary.simpleMessage(
      "Uztura bagātinātāji",
    ),
    "attr_herbal_remedies": MessageLookupByLibrary.simpleMessage(
      "Zāļu līdzekļi",
    ),
    "attr_hiking": MessageLookupByLibrary.simpleMessage("Pārgājieni"),
    "attr_home_decor": MessageLookupByLibrary.simpleMessage("Mājas dekors"),
    "attr_home_improvement": MessageLookupByLibrary.simpleMessage(
      "Mājas uzlabošana",
    ),
    "attr_homebrewing": MessageLookupByLibrary.simpleMessage(
      "Alus darīšana mājās",
    ),
    "attr_homemade_goods": MessageLookupByLibrary.simpleMessage(
      "Pašdarinātas preces",
    ),
    "attr_horses": MessageLookupByLibrary.simpleMessage("Zirgi"),
    "attr_house_maintenance": MessageLookupByLibrary.simpleMessage(
      "Mājas apkope",
    ),
    "attr_houseplant_care": MessageLookupByLibrary.simpleMessage(
      "Istabas augu kopšana",
    ),
    "attr_interview_practice": MessageLookupByLibrary.simpleMessage(
      "Intervijas prakse",
    ),
    "attr_ios": MessageLookupByLibrary.simpleMessage("iOS"),
    "attr_jewelry": MessageLookupByLibrary.simpleMessage(
      "Juvelierizstrādājumi",
    ),
    "attr_kids_toys": MessageLookupByLibrary.simpleMessage("Bērnu rotaļlietas"),
    "attr_kitchen_appliances": MessageLookupByLibrary.simpleMessage(
      "Virtuves tehnika",
    ),
    "attr_knitting": MessageLookupByLibrary.simpleMessage("Adīšana"),
    "attr_kombucha": MessageLookupByLibrary.simpleMessage("Kombuča"),
    "attr_landscaping": MessageLookupByLibrary.simpleMessage("Ainavu dizains"),
    "attr_language_exchange": MessageLookupByLibrary.simpleMessage(
      "Valodu apmaiņa",
    ),
    "attr_lawn_care": MessageLookupByLibrary.simpleMessage("Zāliena kopšana"),
    "attr_leather_crafting": MessageLookupByLibrary.simpleMessage(
      "Ādas apstrāde",
    ),
    "attr_legal_advice": MessageLookupByLibrary.simpleMessage(
      "Juridiskā palīdzība",
    ),
    "attr_linux": MessageLookupByLibrary.simpleMessage("Linux"),
    "attr_local_tours": MessageLookupByLibrary.simpleMessage(
      "Vietējās ekskursijas",
    ),
    "attr_machinery_operation": MessageLookupByLibrary.simpleMessage(
      "Smagā tehnika",
    ),
    "attr_machining": MessageLookupByLibrary.simpleMessage("Metālveidošana"),
    "attr_magic": MessageLookupByLibrary.simpleMessage("Maģija"),
    "attr_makeup": MessageLookupByLibrary.simpleMessage("Grims"),
    "attr_marketing": MessageLookupByLibrary.simpleMessage("Mārketings"),
    "attr_martial_arts": MessageLookupByLibrary.simpleMessage("Cīņas mākslas"),
    "attr_massage": MessageLookupByLibrary.simpleMessage("Masāža"),
    "attr_math_tutoring": MessageLookupByLibrary.simpleMessage(
      "Matemātikas mācīšana",
    ),
    "attr_mechanisms": MessageLookupByLibrary.simpleMessage("Mehānismi"),
    "attr_meditation": MessageLookupByLibrary.simpleMessage("Meditācija"),
    "attr_mentorship": MessageLookupByLibrary.simpleMessage("Mentorings"),
    "attr_metal_detecting": MessageLookupByLibrary.simpleMessage(
      "Metāla meklēšana",
    ),
    "attr_metalworking": MessageLookupByLibrary.simpleMessage(
      "Metāla apstrāde",
    ),
    "attr_mindfulness": MessageLookupByLibrary.simpleMessage("Apzinātība"),
    "attr_motorcycles": MessageLookupByLibrary.simpleMessage("Motocikli"),
    "attr_movies": MessageLookupByLibrary.simpleMessage("Filmas"),
    "attr_moving_help": MessageLookupByLibrary.simpleMessage(
      "Pārcelšanās palīdzība",
    ),
    "attr_music_performance": MessageLookupByLibrary.simpleMessage(
      "Mūzikas uzstāšanās",
    ),
    "attr_music_production": MessageLookupByLibrary.simpleMessage(
      "Mūzikas producēšana",
    ),
    "attr_musical_instruments": MessageLookupByLibrary.simpleMessage(
      "Mūzikas instrumenti",
    ),
    "attr_natural_remedies": MessageLookupByLibrary.simpleMessage(
      "Dabīgie līdzekļi",
    ),
    "attr_networking": MessageLookupByLibrary.simpleMessage("Tīklošanās"),
    "attr_nutrition_advice": MessageLookupByLibrary.simpleMessage(
      "Uztura konsultācijas",
    ),
    "attr_organic_food": MessageLookupByLibrary.simpleMessage(
      "Bioloģiskā pārtika",
    ),
    "attr_painting": MessageLookupByLibrary.simpleMessage("Gleznošana"),
    "attr_pc_building": MessageLookupByLibrary.simpleMessage("Datoru būvēšana"),
    "attr_permaculture": MessageLookupByLibrary.simpleMessage("Permakultūra"),
    "attr_personal_finance": MessageLookupByLibrary.simpleMessage(
      "Personīgās finanses",
    ),
    "attr_pet_grooming": MessageLookupByLibrary.simpleMessage(
      "Mājdzīvnieku kopšana",
    ),
    "attr_pet_sitting": MessageLookupByLibrary.simpleMessage(
      "Mājdzīvnieku pieskatīšana",
    ),
    "attr_pet_supplies": MessageLookupByLibrary.simpleMessage(
      "Mājdzīvnieku piederumi",
    ),
    "attr_phone_repair": MessageLookupByLibrary.simpleMessage(
      "Tālruņu remonts",
    ),
    "attr_photo_restoration": MessageLookupByLibrary.simpleMessage(
      "Foto restaurācija",
    ),
    "attr_photography": MessageLookupByLibrary.simpleMessage("Fotogrāfija"),
    "attr_physical_work": MessageLookupByLibrary.simpleMessage("Fizisks darbs"),
    "attr_piano_lessons": MessageLookupByLibrary.simpleMessage(
      "Klavieru nodarbības",
    ),
    "attr_plants": MessageLookupByLibrary.simpleMessage("Augi"),
    "attr_plumbing": MessageLookupByLibrary.simpleMessage("Santehnika"),
    "attr_poker": MessageLookupByLibrary.simpleMessage("Pokers"),
    "attr_pottery": MessageLookupByLibrary.simpleMessage("Podnieku māksla"),
    "attr_power_tools": MessageLookupByLibrary.simpleMessage(
      "Elektroinstrumenti",
    ),
    "attr_proofreading": MessageLookupByLibrary.simpleMessage("Korektūra"),
    "attr_quilting": MessageLookupByLibrary.simpleMessage("Segas šūšana"),
    "attr_recipes": MessageLookupByLibrary.simpleMessage("Receptes"),
    "attr_record_collecting": MessageLookupByLibrary.simpleMessage(
      "Ierakstu kolekcionēšana",
    ),
    "attr_renovation": MessageLookupByLibrary.simpleMessage("Renovācija"),
    "attr_retreats": MessageLookupByLibrary.simpleMessage("Retreats"),
    "attr_reviewing": MessageLookupByLibrary.simpleMessage("Vērtēšana"),
    "attr_ridesharing": MessageLookupByLibrary.simpleMessage(
      "Braucienu koplietošana",
    ),
    "attr_robotics": MessageLookupByLibrary.simpleMessage("Robotika"),
    "attr_rock_climbing": MessageLookupByLibrary.simpleMessage(
      "Klinšu kāpšana",
    ),
    "attr_sales": MessageLookupByLibrary.simpleMessage("Pārdošana"),
    "attr_scrap_metal": MessageLookupByLibrary.simpleMessage("Lūžņu metāls"),
    "attr_sculpting": MessageLookupByLibrary.simpleMessage("Tēlniecība"),
    "attr_self_sufficiency": MessageLookupByLibrary.simpleMessage(
      "Pašpietiekamība",
    ),
    "attr_sewing": MessageLookupByLibrary.simpleMessage("Šūšana"),
    "attr_shoemaking": MessageLookupByLibrary.simpleMessage("Kurpnieku darbs"),
    "attr_social_media": MessageLookupByLibrary.simpleMessage(
      "Sociālie mediji",
    ),
    "attr_socializing": MessageLookupByLibrary.simpleMessage("Socializēšanās"),
    "attr_software_accounts": MessageLookupByLibrary.simpleMessage(
      "Programmatūras konti",
    ),
    "attr_software_development": MessageLookupByLibrary.simpleMessage(
      "Programmatūras izstrāde",
    ),
    "attr_spare_parts": MessageLookupByLibrary.simpleMessage("Rezerves daļas"),
    "attr_spirituality": MessageLookupByLibrary.simpleMessage("Garīgums"),
    "attr_sports_coaching": MessageLookupByLibrary.simpleMessage(
      "Sporta trenēšana",
    ),
    "attr_sports_equipment": MessageLookupByLibrary.simpleMessage(
      "Sporta aprīkojums",
    ),
    "attr_stand_up_comedy": MessageLookupByLibrary.simpleMessage(
      "Stendup komēdija",
    ),
    "attr_study_partner": MessageLookupByLibrary.simpleMessage(
      "Studiju partneris",
    ),
    "attr_sustainable_living": MessageLookupByLibrary.simpleMessage(
      "Ilgtspējīga dzīvesveida",
    ),
    "attr_tea": MessageLookupByLibrary.simpleMessage("Tēja"),
    "attr_technical_writing": MessageLookupByLibrary.simpleMessage(
      "Tehniskā rakstīšana",
    ),
    "attr_tennis": MessageLookupByLibrary.simpleMessage("Teniss"),
    "attr_tool_lending": MessageLookupByLibrary.simpleMessage(
      "Instrumentu aizdošana",
    ),
    "attr_translation_services": MessageLookupByLibrary.simpleMessage(
      "Tulkošanas pakalpojumi",
    ),
    "attr_transport_service": MessageLookupByLibrary.simpleMessage(
      "Transporta pakalpojums",
    ),
    "attr_traveling": MessageLookupByLibrary.simpleMessage("Ceļošana"),
    "attr_upcycling": MessageLookupByLibrary.simpleMessage("Pārstrāde"),
    "attr_urban_exploration": MessageLookupByLibrary.simpleMessage(
      "Urbānā pētīšana",
    ),
    "attr_used_electronics": MessageLookupByLibrary.simpleMessage(
      "Lietota elektronika",
    ),
    "attr_ux_design": MessageLookupByLibrary.simpleMessage("UX dizains"),
    "attr_vegetables": MessageLookupByLibrary.simpleMessage("Dārzeņi"),
    "attr_vehicle_repair": MessageLookupByLibrary.simpleMessage(
      "Transportlīdzekļu remonts",
    ),
    "attr_video_editing": MessageLookupByLibrary.simpleMessage(
      "Video rediģēšana",
    ),
    "attr_video_game_developing": MessageLookupByLibrary.simpleMessage(
      "Videospēļu izstrāde",
    ),
    "attr_video_game_hardware": MessageLookupByLibrary.simpleMessage(
      "Videospēļu aparatūra",
    ),
    "attr_virtual_assistance": MessageLookupByLibrary.simpleMessage(
      "Virtuālā asistēšana",
    ),
    "attr_virtual_reality": MessageLookupByLibrary.simpleMessage(
      "Virtuālā realitāte",
    ),
    "attr_vocals": MessageLookupByLibrary.simpleMessage("Vokāls"),
    "attr_voice_lessons": MessageLookupByLibrary.simpleMessage(
      "Vokālās nodarbības",
    ),
    "attr_volunteering": MessageLookupByLibrary.simpleMessage(
      "Brīvprātīgais darbs",
    ),
    "attr_weaving": MessageLookupByLibrary.simpleMessage("Aušana"),
    "attr_web_development": MessageLookupByLibrary.simpleMessage(
      "Tīmekļa izstrāde",
    ),
    "attr_weight_training": MessageLookupByLibrary.simpleMessage("Svarcelšana"),
    "attr_welding": MessageLookupByLibrary.simpleMessage("Metināšana"),
    "attr_wood_carving": MessageLookupByLibrary.simpleMessage("Koka griešana"),
    "attr_woodworking": MessageLookupByLibrary.simpleMessage("Galdniecība"),
    "attr_workout_planning": MessageLookupByLibrary.simpleMessage(
      "Treniņu plānošana",
    ),
    "attr_writing": MessageLookupByLibrary.simpleMessage("Rakstīšana"),
    "attr_yoga": MessageLookupByLibrary.simpleMessage("Joga"),
    "attr_zen": MessageLookupByLibrary.simpleMessage("Zen"),
    "attr_zumba": MessageLookupByLibrary.simpleMessage("Zumba"),
    "attributeMatch": MessageLookupByLibrary.simpleMessage(
      "Atribūta atbilstība",
    ),
    "attributePreferencesHint": MessageLookupByLibrary.simpleMessage(
      "Iestatiet paziņojumu preferences savām interesēm un piedāvājumiem",
    ),
    "attributes": MessageLookupByLibrary.simpleMessage("Atribūti"),
    "attributesSelected": MessageLookupByLibrary.simpleMessage("izvēlēti"),
    "avatarShopAvatarAlreadySelected": MessageLookupByLibrary.simpleMessage(
      "Šis avatārs jau ir atlasīts.",
    ),
    "avatarShopBalance": m0,
    "avatarShopBuyButton": m1,
    "avatarShopDescription": MessageLookupByLibrary.simpleMessage(
      "Nopērc un uzreiz uzliec pielāgotu avatāra ikonu.",
    ),
    "avatarShopEachAvatarPrice": m2,
    "avatarShopEquip": MessageLookupByLibrary.simpleMessage("Aprīkot"),
    "avatarShopLoadFailed": m3,
    "avatarShopNeedCoins": m4,
    "avatarShopNotEnoughCoins": m5,
    "avatarShopPurchaseFailed": m6,
    "avatarShopPurchaseSuccess": MessageLookupByLibrary.simpleMessage(
      "Avatārs veiksmīgi nopirkts un uzlikts.",
    ),
    "avatarShopRefresh": MessageLookupByLibrary.simpleMessage("Atjaunot"),
    "avatarShopSelected": MessageLookupByLibrary.simpleMessage("Atlasīts"),
    "avatarShopTitle": MessageLookupByLibrary.simpleMessage("Avatāru veikals"),
    "avatarShopUnableToProcessPurchase": MessageLookupByLibrary.simpleMessage(
      "Šobrīd pirkumu nevar apstrādāt.",
    ),
    "badgeCommunityConnectorDescription": MessageLookupByLibrary.simpleMessage(
      "Augsta dažādība sadarbības partneros.",
    ),
    "badgeCommunityConnectorTitle": MessageLookupByLibrary.simpleMessage(
      "Kopienas savienotājs",
    ),
    "badgeDisputeFreeDescription": MessageLookupByLibrary.simpleMessage(
      "Nav bijuši strīdīgi darījumi.",
    ),
    "badgeDisputeFreeTitle": MessageLookupByLibrary.simpleMessage(
      "Bez strīdiem",
    ),
    "badgeEarnedStatus": MessageLookupByLibrary.simpleMessage("Nopelnīta"),
    "badgeFastTraderDescription": MessageLookupByLibrary.simpleMessage(
      "Pabeidz maiņas ātrāk nekā vidēji.",
    ),
    "badgeFastTraderTitle": MessageLookupByLibrary.simpleMessage(
      "Ātrs un uzticams",
    ),
    "badgeIdentityVerifiedDescription": MessageLookupByLibrary.simpleMessage(
      "Lietotājs ir pabeidzis identitātes verifikāciju.",
    ),
    "badgeIdentityVerifiedTitle": MessageLookupByLibrary.simpleMessage(
      "Identitāte verificēta",
    ),
    "badgeNotEarnedStatus": MessageLookupByLibrary.simpleMessage(
      "Nav nopelnīta",
    ),
    "badgePremiumUserDescription": MessageLookupByLibrary.simpleMessage(
      "Lietotājam ir aktīvs Premium abonements.",
    ),
    "badgePremiumUserTitle": MessageLookupByLibrary.simpleMessage(
      "Premium lietotājs",
    ),
    "badgeQuickResponderDescription": MessageLookupByLibrary.simpleMessage(
      "Parasti atbild 24 stundu laikā.",
    ),
    "badgeQuickResponderTitle": MessageLookupByLibrary.simpleMessage(
      "Ātrs atbildētājs",
    ),
    "badgeTop1000Description": MessageLookupByLibrary.simpleMessage(
      "Lietotājs bija starp pirmajiem 1000 reģistrētajiem lietotājiem.",
    ),
    "badgeTop1000Title": MessageLookupByLibrary.simpleMessage(
      "Agrīnais lietotājs - pirmie 1000",
    ),
    "badgeTopRatedDescription": MessageLookupByLibrary.simpleMessage(
      "Vidējais vērtējums 4.8+ ar vismaz 50 atsauksmēm.",
    ),
    "badgeTopRatedTitle": MessageLookupByLibrary.simpleMessage("Top vērtēts"),
    "badgeVerifiedBusinessDescription": MessageLookupByLibrary.simpleMessage(
      "Biznesa reģistrācija ir verificēta.",
    ),
    "badgeVerifiedBusinessTitle": MessageLookupByLibrary.simpleMessage(
      "Verificēts bizness",
    ),
    "badgeVeteranTraderDescription": MessageLookupByLibrary.simpleMessage(
      "Lietotājs ir pabeidzis 100+ veiksmīgas maiņas.",
    ),
    "badgeVeteranTraderTitle": MessageLookupByLibrary.simpleMessage(
      "Pieredzējis tirgotājs",
    ),
    "badgesTitle": MessageLookupByLibrary.simpleMessage("Nozīmītes"),
    "barterCoinsInfoMessage": MessageLookupByLibrary.simpleMessage(
      "Monētas var nopelnīt, sniedzot pakalpojumu vai aktīvi lietojot lietotni.\n\nMonētas var tērēt: izcelšanās kartē, sludinājumu izcelšana, speciālas avatara ikonas",
    ),
    "barterCoinsTitle": MessageLookupByLibrary.simpleMessage("Bartera monētas"),
    "beSpecificAndConstructive": MessageLookupByLibrary.simpleMessage(
      "Esiet konkrēts un konstruktīvs",
    ),
    "block": MessageLookupByLibrary.simpleMessage("Bloķēt"),
    "blockUser": MessageLookupByLibrary.simpleMessage("Bloķēt lietotāju"),
    "blockUserConfirmation": MessageLookupByLibrary.simpleMessage(
      "Vai tiešām vēlaties bloķēt šo lietotāju? Jūs vairs nevarēsiet ar viņiem sazināties.",
    ),
    "blockUserConfirmationDetailed": m7,
    "bonusTipOptional": MessageLookupByLibrary.simpleMessage(
      "Bonuss / dzeramnauda (neobligāti)",
    ),
    "buyPremium": MessageLookupByLibrary.simpleMessage("Pirkt Premium"),
    "camera": MessageLookupByLibrary.simpleMessage("Kamera"),
    "cancel": MessageLookupByLibrary.simpleMessage("Atcelt"),
    "cannotSendFileNoRecipientKey": MessageLookupByLibrary.simpleMessage(
      "Nevar nosūtīt failu: Saņēmēja publiskā atslēga nav pieejama",
    ),
    "category": MessageLookupByLibrary.simpleMessage("Kategorija"),
    "categoryActiveDescription": MessageLookupByLibrary.simpleMessage(
      "Sports, aktivitātes, dejas, skriešana, fizisk darbs, mehānismi",
    ),
    "categoryActiveTitle": MessageLookupByLibrary.simpleMessage(
      "Aktīvs un sabiedrisks",
    ),
    "categoryArtsDescription": MessageLookupByLibrary.simpleMessage(
      "Māksla, garīgums, filozofija",
    ),
    "categoryArtsTitle": MessageLookupByLibrary.simpleMessage(
      "Māksla un filozofija",
    ),
    "categoryBusinessDescription": MessageLookupByLibrary.simpleMessage(
      "Tikai bizness, algots darbs, tīklošanās, naudas lietas",
    ),
    "categoryBusinessTitle": MessageLookupByLibrary.simpleMessage(
      "Bizness un finanses",
    ),
    "categoryCommDescription": MessageLookupByLibrary.simpleMessage(
      "Dažādi/Komunikācija, Tērzēšana",
    ),
    "categoryCommTitle": MessageLookupByLibrary.simpleMessage(
      "Komunikācija un tērzēšana",
    ),
    "categoryCommunityDescription": MessageLookupByLibrary.simpleMessage(
      "Gatavs palīdzēt bez maksas/nespecifisku apmaiņu",
    ),
    "categoryCommunityTitle": MessageLookupByLibrary.simpleMessage(
      "Kopiena un brīvprātīgais darbs",
    ),
    "categoryNatureDescription": MessageLookupByLibrary.simpleMessage(
      "Dārzkopība, brīvdabas, meži, kempings, vides aizsardzība, uzkopšana, dzīvnieki",
    ),
    "categoryNatureTitle": MessageLookupByLibrary.simpleMessage(
      "Daba un brīvdabas",
    ),
    "categoryTechDescription": MessageLookupByLibrary.simpleMessage(
      "Tehnoloģijas, mācīšanās, inovācija",
    ),
    "categoryTechTitle": MessageLookupByLibrary.simpleMessage(
      "Tehnoloģijas un mācīšanās",
    ),
    "category_blue": MessageLookupByLibrary.simpleMessage(
      "Bizness, uzņēmējdarbība, algots darbs, kontaktu veidošana, naudas lietas, finanses, karjera",
    ),
    "category_green": MessageLookupByLibrary.simpleMessage(
      "Daba, brīvdabas aktivitātes, dārzkopība, dzīvnieki, vide, pārgājieni, augi, ilgtspēja",
    ),
    "category_orange": MessageLookupByLibrary.simpleMessage(
      "Brīvprātīgais darbs, atbalsts, bezmaksas priekšmetu/prasmju apmaiņa, konsultācijas, palīdzība, kopiena",
    ),
    "category_purple": MessageLookupByLibrary.simpleMessage(
      "Māksla, garīgums, filozofija, kultūra, mūzika, amatniecība, radošums, dizains, vēsture",
    ),
    "category_red": MessageLookupByLibrary.simpleMessage(
      "Sports, fiziskās aktivitātes, aktīvs dzīvesstils, dejas, mehānismi, instrumenti, praktiski darbi",
    ),
    "category_teal": MessageLookupByLibrary.simpleMessage(
      "Tehnoloģijas, mācīšanās, izglītība, inovācija, ideju ģenerēšana, zinātne, programmatūra",
    ),
    "category_yellow": MessageLookupByLibrary.simpleMessage(
      "Sarunas, sabiedriskas aktivitātes, ikdienas sarunas, vietējie pasākumi, jauni kontakti, komunikācija",
    ),
    "changeSecurityQuestion": MessageLookupByLibrary.simpleMessage(
      "Mainīt drošības jautājumu",
    ),
    "chat": MessageLookupByLibrary.simpleMessage("Tērzēšana"),
    "chatError_Offline": MessageLookupByLibrary.simpleMessage(
      "Lietotājs bezsaistē",
    ),
    "chatOpenFailed": MessageLookupByLibrary.simpleMessage(
      "Šobrīd nevar atvērt šo čatu. Lūdzu, mēģiniet vēlreiz.",
    ),
    "chats": MessageLookupByLibrary.simpleMessage("Čati"),
    "chooseFromGallery": MessageLookupByLibrary.simpleMessage(
      "Izvēlēties no iekārtas",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Notīrīt"),
    "clearQuietHours": MessageLookupByLibrary.simpleMessage(
      "Notīrīt klusās stundas",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Aizvērt"),
    "closeLocations": MessageLookupByLibrary.simpleMessage(
      "Aizvērt atrašanās vietas",
    ),
    "codeCopied": MessageLookupByLibrary.simpleMessage(
      "Pārcelšanas kods nokopēts starpliktuvē",
    ),
    "codeSentTo": m8,
    "completeSetup": MessageLookupByLibrary.simpleMessage(
      "Pabeigt iestatīšanu",
    ),
    "confirmPinLabel": MessageLookupByLibrary.simpleMessage(
      "Apstipriniet PIN kodu",
    ),
    "contactSupportForPinReset": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, sazinieties ar atbalstu PIN koda atiestatīšanas palīdzībai",
    ),
    "contacts": MessageLookupByLibrary.simpleMessage("Kontakti"),
    "continueAnyway": MessageLookupByLibrary.simpleMessage(
      "Turpināt tik un tā",
    ),
    "continueButton": MessageLookupByLibrary.simpleMessage("Turpināt"),
    "conversationDeleted": MessageLookupByLibrary.simpleMessage(
      "Saruna dzēsta",
    ),
    "copiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "Nokopēts starpliktuvē",
    ),
    "copyCode": MessageLookupByLibrary.simpleMessage("Kopēt kodu"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Kopēt saiti"),
    "couldNotFindChatParticipant": MessageLookupByLibrary.simpleMessage(
      "Neizdevās atrast sarunas dalībnieku",
    ),
    "couldNotOpenFile": m9,
    "couldNotOpenFileGeneric": MessageLookupByLibrary.simpleMessage(
      "Neizdevās atvērt šo failu. Lūdzu, mēģiniet citu lietotni vai pārbaudiet faila ceļu.",
    ),
    "create5DigitPin": MessageLookupByLibrary.simpleMessage(
      "Izveidojiet 5 ciparu PIN kodu",
    ),
    "createInterestPosting": MessageLookupByLibrary.simpleMessage(
      "Izveidot intereses sludinājumu",
    ),
    "createOfferPosting": MessageLookupByLibrary.simpleMessage(
      "Izveidot piedāvājuma sludinājumu",
    ),
    "createPosting": MessageLookupByLibrary.simpleMessage(
      "Izveidot sludinājumu",
    ),
    "createPostingBoost3Days": MessageLookupByLibrary.simpleMessage(
      "3 dienas (20 monētas)",
    ),
    "createPostingBoost7Days": MessageLookupByLibrary.simpleMessage(
      "7 dienas (50 monētas)",
    ),
    "createPostingBoostDescription": MessageLookupByLibrary.simpleMessage(
      "Tērē monētas, lai izceltu šo sludinājumu meklēšanas rezultātos.",
    ),
    "createPostingBoostInsufficientCoins": MessageLookupByLibrary.simpleMessage(
      "Nepietiek monētu izvēlētajam boost.",
    ),
    "createPostingBoostNone": MessageLookupByLibrary.simpleMessage("Bez boost"),
    "createPostingBoostTitle": MessageLookupByLibrary.simpleMessage(
      "Redzamības boost",
    ),
    "createPreferences": MessageLookupByLibrary.simpleMessage(
      "Saglabāt preferences",
    ),
    "createYourFirstWishlistItem": MessageLookupByLibrary.simpleMessage(
      "Izveidojiet savu pirmo vēlmju saraksta vienumu, lai saņemtu paziņojumus, kad parādās atbilstības",
    ),
    "currentWalletBalance": m10,
    "daily": MessageLookupByLibrary.simpleMessage("Ikdienas"),
    "dataExportEmailRequired": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, pievienojiet e-pastu paziņojumu preferencēs pirms datu eksporta pieprasījuma.",
    ),
    "dataExportRequestAccepted": MessageLookupByLibrary.simpleMessage(
      "Jūsu datu eksporta pieprasījums ir pieņemts.",
    ),
    "dataExportRequestFailed": MessageLookupByLibrary.simpleMessage(
      "Neizdevās pieprasīt datu eksportu.",
    ),
    "decryptingFile": m11,
    "defaultSettings": MessageLookupByLibrary.simpleMessage(
      "Noklusējuma iestatījumi",
    ),
    "delete": MessageLookupByLibrary.simpleMessage("Dzēst"),
    "deleteAll": MessageLookupByLibrary.simpleMessage("Dzēst visu"),
    "deleteAllMatchesConfirmation": MessageLookupByLibrary.simpleMessage(
      "Vai tiešām vēlaties dzēst visu atbilstību vēsturi? Šo darbību nevar atsaukt.",
    ),
    "deleteConversation": MessageLookupByLibrary.simpleMessage("Dzēst sarunu"),
    "deleteConversationConfirmation": MessageLookupByLibrary.simpleMessage(
      "Vai tiešām vēlaties dzēst šo sarunu? Visi ziņojumi tiks neatgriezeniski noņemti.",
    ),
    "deletePosting": MessageLookupByLibrary.simpleMessage("Dzēst sludinājumu"),
    "deletePostingConfirmation": MessageLookupByLibrary.simpleMessage(
      "Vai tiešām vēlaties dzēst šo sludinājumu?",
    ),
    "deletePreference": MessageLookupByLibrary.simpleMessage(
      "Dzēst preferenci",
    ),
    "deletePreferenceConfirmation": MessageLookupByLibrary.simpleMessage(
      "Vai tiešām vēlaties dzēst šo preferenci?",
    ),
    "deleteProfile": MessageLookupByLibrary.simpleMessage("Dzēst profilu"),
    "deleteProfileConfirmation": MessageLookupByLibrary.simpleMessage(
      "Vai tiešām vēlaties dzēst savu profilu? Šo darbību nevar atsaukt. Visi jūsu dati, sludinājumi un sarunas tiks neatgriezeniski noņemti.",
    ),
    "deleteWishlistItem": MessageLookupByLibrary.simpleMessage(
      "Dzēst vēlmju saraksta vienumu",
    ),
    "deleteWishlistItemConfirmation": MessageLookupByLibrary.simpleMessage(
      "Vai tiešām vēlaties dzēst šo vēlmju saraksta vienumu?",
    ),
    "deny": MessageLookupByLibrary.simpleMessage("Aizliegt"),
    "dismiss": MessageLookupByLibrary.simpleMessage("Noraidīt"),
    "dismissMatch": MessageLookupByLibrary.simpleMessage("Noraidīt atbilstību"),
    "dismissMatchConfirmation": MessageLookupByLibrary.simpleMessage(
      "Vai tiešām vēlaties noraidīt šo atbilstību?",
    ),
    "dismissed": MessageLookupByLibrary.simpleMessage("Noraidīts"),
    "done": MessageLookupByLibrary.simpleMessage("Gatavs"),
    "downloadFailed": m12,
    "downloadStarted": MessageLookupByLibrary.simpleMessage(
      "Lejupielāde sākta! Pārbaudiet savu lejupielāžu mapi",
    ),
    "downloadingFile": m13,
    "drawer_menu_complementary_users": MessageLookupByLibrary.simpleMessage(
      "Atrast papildinošus lietotājus",
    ),
    "drawer_menu_favorite_users": MessageLookupByLibrary.simpleMessage(
      "Atrast iecienītākos lietotājus",
    ),
    "drawer_menu_similar_users": MessageLookupByLibrary.simpleMessage(
      "Atrast līdzīgus lietotājus",
    ),
    "edit": MessageLookupByLibrary.simpleMessage("Rediģēt"),
    "editKeywords": MessageLookupByLibrary.simpleMessage(
      "Rediģēt savas vispārējās intereses",
    ),
    "editLocation": MessageLookupByLibrary.simpleMessage(
      "Rediģēt atrašanās vietu",
    ),
    "editPosting": MessageLookupByLibrary.simpleMessage("Rediģēt sludinājumu"),
    "editPreference": MessageLookupByLibrary.simpleMessage(
      "Rediģēt preferenci",
    ),
    "editWishlistItem": MessageLookupByLibrary.simpleMessage(
      "Rediģēt vēlmju saraksta vienumu",
    ),
    "emailAddress": MessageLookupByLibrary.simpleMessage("E-pasta adrese"),
    "emailHint": MessageLookupByLibrary.simpleMessage("piemers@epasts.lv"),
    "emailInvalid": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, ievadiet derīgu e-pasta adresi",
    ),
    "emailNotificationPreferences": MessageLookupByLibrary.simpleMessage(
      "E-pasta iestatījumi",
    ),
    "emailRequired": MessageLookupByLibrary.simpleMessage(
      "E-pasta adrese ir obligāta",
    ),
    "emailSaved": MessageLookupByLibrary.simpleMessage(
      "E-pasta adrese veiksmīgi saglabāta",
    ),
    "emailUnsubscribe": MessageLookupByLibrary.simpleMessage(
      "Atteikties no abonēšanas",
    ),
    "emailUnsubscribed": MessageLookupByLibrary.simpleMessage(
      "Atteikšanās veiksmīga",
    ),
    "emailUpdated": MessageLookupByLibrary.simpleMessage("E-pasts atjaunināts"),
    "enableNotifications": MessageLookupByLibrary.simpleMessage(
      "Ieslēgt paziņojumus",
    ),
    "enableNotificationsDescription": MessageLookupByLibrary.simpleMessage(
      "Saņemt paziņojumus par atbilstībām un atjauninājumiem",
    ),
    "endTime": MessageLookupByLibrary.simpleMessage("Beigu laiks"),
    "enterBonusAmount": MessageLookupByLibrary.simpleMessage(
      "Ievadiet bonusa summu",
    ),
    "enterNewPinDescription": MessageLookupByLibrary.simpleMessage(
      "Ievadiet jaunu 5 ciparu PIN kodu",
    ),
    "enterPinDescription": MessageLookupByLibrary.simpleMessage(
      "Ievadiet savu PIN kodu, lai atbloķētu lietotni",
    ),
    "enterPinTitle": MessageLookupByLibrary.simpleMessage("Ievadiet PIN kodu"),
    "enterYourAnswer": MessageLookupByLibrary.simpleMessage(
      "Ievadiet savu atbildi",
    ),
    "enterYourPin": MessageLookupByLibrary.simpleMessage(
      "Ievadiet savu PIN kodu",
    ),
    "error": MessageLookupByLibrary.simpleMessage("Kļūda"),
    "errorCreatingTransaction": m14,
    "errorCreatingWishlistItem": MessageLookupByLibrary.simpleMessage(
      "Kļūda vēlmju saraksta vienuma izveidē",
    ),
    "errorDeletingConversation": MessageLookupByLibrary.simpleMessage(
      "Kļūda sarunas dzēšanā",
    ),
    "errorDeletingProfile": MessageLookupByLibrary.simpleMessage(
      "Kļūda profila dzēšanā",
    ),
    "errorDeletingWishlistItem": MessageLookupByLibrary.simpleMessage(
      "Kļūda vēlmju saraksta vienuma dzēšanā",
    ),
    "errorDuringInitialization": MessageLookupByLibrary.simpleMessage(
      "Kļūda inicializācijas laikā.",
    ),
    "errorFindingLocation": m15,
    "errorLoadingAttributes": MessageLookupByLibrary.simpleMessage(
      "Kļūda atribūtu ielādē",
    ),
    "errorLoadingChats": MessageLookupByLibrary.simpleMessage(
      "Kļūda sarunu ielādē",
    ),
    "errorLoadingPostings": MessageLookupByLibrary.simpleMessage(
      "Kļūda sludinājumu ielādē",
    ),
    "errorLoadingWishlist": MessageLookupByLibrary.simpleMessage(
      "Kļūda vēlmju saraksta ielādē",
    ),
    "errorOpeningFile": m16,
    "errorUpdatingFavorite": MessageLookupByLibrary.simpleMessage(
      "Kļūda iecienītā lietotāja atjaunināšanā",
    ),
    "errorUpdatingTransaction": m17,
    "errorUpdatingWishlistItem": MessageLookupByLibrary.simpleMessage(
      "Kļūda vēlmju saraksta vienuma atjaunināšanā",
    ),
    "errorVerifyingPin": MessageLookupByLibrary.simpleMessage(
      "Kļūda, pārbaudot PIN",
    ),
    "errorWithException": m18,
    "errorWithMessage": m19,
    "expirationDate": MessageLookupByLibrary.simpleMessage("Derīguma termiņš"),
    "expired": MessageLookupByLibrary.simpleMessage("Beidzies"),
    "expires": MessageLookupByLibrary.simpleMessage("Derīgs līdz"),
    "expiresIn": m20,
    "expiresPrefix": MessageLookupByLibrary.simpleMessage("Derīgs līdz"),
    "eyes": MessageLookupByLibrary.simpleMessage("Acis"),
    "failedToBlockUser": MessageLookupByLibrary.simpleMessage(
      "Neizdevās bloķēt lietotāju",
    ),
    "failedToJoinMigration": MessageLookupByLibrary.simpleMessage(
      "Neizdevās pievienoties pārcelšanas sesijai",
    ),
    "failedToProcessMigration": MessageLookupByLibrary.simpleMessage(
      "Neizdevās apstrādāt pārcelšanas datus",
    ),
    "failedToSendCode": MessageLookupByLibrary.simpleMessage(
      "Neizdevās nosūtīt atjaunošanas kodu",
    ),
    "failedToSendMigration": MessageLookupByLibrary.simpleMessage(
      "Neizdevās nosūtīt pārcelšanas datus",
    ),
    "failedToSubmitAppeal": MessageLookupByLibrary.simpleMessage(
      "Neizdevās iesniegt apelāciju",
    ),
    "failedToSubmitReport": MessageLookupByLibrary.simpleMessage(
      "Neizdevās iesniegt ziņojumu. Lūdzu, mēģiniet vēlreiz.",
    ),
    "failedToSubmitReview": MessageLookupByLibrary.simpleMessage(
      "Neizdevās iesniegt atsauksmi",
    ),
    "failedToUnblockUser": MessageLookupByLibrary.simpleMessage(
      "Neizdevās atbloķēt lietotāju",
    ),
    "falseReportsWarning": MessageLookupByLibrary.simpleMessage(
      "Viltus ziņojumi var izraisīt soda sankcijas jūsu kontam.",
    ),
    "fileDecryptKeyMissing": MessageLookupByLibrary.simpleMessage(
      "Šo failu vēl nevar atšifrēt. Mēģiniet vēlreiz, kad čata atslēgas būs sinhronizētas.",
    ),
    "fileDownloadFailed": MessageLookupByLibrary.simpleMessage(
      "Šobrīd failu lejupielādēt neizdevās. Lūdzu, mēģiniet vēlreiz.",
    ),
    "fileNotFound": m21,
    "fileReadFailed": MessageLookupByLibrary.simpleMessage(
      "Neizdevās nolasīt izvēlēto failu. Lūdzu, izvēlieties citu failu.",
    ),
    "fileSavedAt": m22,
    "fileSendFailed": MessageLookupByLibrary.simpleMessage(
      "Šobrīd failu nosūtīt neizdevās. Lūdzu, mēģiniet vēlreiz.",
    ),
    "fileSentSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Fails veiksmīgi nosūtīts!",
    ),
    "finishOnboarding": MessageLookupByLibrary.simpleMessage("Pabeigt"),
    "finishTransaction": MessageLookupByLibrary.simpleMessage(
      "Pabeigt transakciju",
    ),
    "finishTransactionConfirmation": MessageLookupByLibrary.simpleMessage(
      "Vai tiešām vēlaties atzīmēt šo transakciju kā pabeigtu?",
    ),
    "forgotPin": MessageLookupByLibrary.simpleMessage("Aizmirsi PIN kodu?"),
    "forgotPinSubtitle": MessageLookupByLibrary.simpleMessage(
      "Ievadiet savu e-pasta adresi, lai saņemtu PIN koda atiestatīšanas saiti.",
    ),
    "frequency": MessageLookupByLibrary.simpleMessage("Biežums"),
    "gallery": MessageLookupByLibrary.simpleMessage("Iekārta"),
    "gdprConsentAccept": MessageLookupByLibrary.simpleMessage(
      "Turpināt (Piekrītot lietošanas noteikumiem)",
    ),
    "gdprConsentAiDescription": MessageLookupByLibrary.simpleMessage(
      "Analizē profilu un iestatījumus, lai uzlabotu ieteikumus un atbilstību.",
    ),
    "gdprConsentAiLabel": MessageLookupByLibrary.simpleMessage(
      "Neobligāti: MI palīdzēta atbilstība",
    ),
    "gdprConsentDecline": MessageLookupByLibrary.simpleMessage("Ne tagad"),
    "gdprConsentIntro": MessageLookupByLibrary.simpleMessage(
      "Pirms turpināt, lūdzu, pārskatiet un izvēlieties, kā tiek apstrādāti jūsu dati.",
    ),
    "gdprConsentLocationDescription": MessageLookupByLibrary.simpleMessage(
      "Izmantojiet atrašanās vietu, lai atrastu atbilstošākos lietotājus tuvumā",
    ),
    "gdprConsentLocationLabel": MessageLookupByLibrary.simpleMessage(
      "Neobligāti: atrašanās vietas apstrāde",
    ),
    "gdprConsentManageLater": MessageLookupByLibrary.simpleMessage(
      "Šīs izvēles varēsiet mainīt vēlāk iestatījumos.",
    ),
    "gdprConsentRequiredDescription": MessageLookupByLibrary.simpleMessage(
      "Nepieciešams konta izveidei, lietotāju atbilstībām un drošai saziņai.",
    ),
    "gdprConsentRequiredLabel": MessageLookupByLibrary.simpleMessage(
      "Obligāti: pamatpakalpojuma apstrāde",
    ),
    "gdprConsentTitle": MessageLookupByLibrary.simpleMessage(
      "Privātuma un datu piekrišana",
    ),
    "gdprCookiesAnalyticsDescription": MessageLookupByLibrary.simpleMessage(
      "Palīdz saprast lietojumu un uzlabot veiktspēju. Tās tiek izmantotas tikai ar jūsu piekrišanu.",
    ),
    "gdprCookiesAnalyticsLabel": MessageLookupByLibrary.simpleMessage(
      "Neobligātās analītikas sīkdatnes",
    ),
    "gdprCookiesRequiredDescription": MessageLookupByLibrary.simpleMessage(
      "Nepieciešamas pamatfunkcijām: drošībai, sesiju uzturēšanai un būtisko iestatījumu saglabāšanai.",
    ),
    "gdprCookiesRequiredLabel": MessageLookupByLibrary.simpleMessage(
      "Obligātās sīkdatnes",
    ),
    "gdprCookiesSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Sīkdatnes (Web)",
    ),
    "generateAvatar": MessageLookupByLibrary.simpleMessage("Ģenerēt avatāru"),
    "generateCryptoWallet": MessageLookupByLibrary.simpleMessage(
      "Ģenerēt kriptomaciņu",
    ),
    "generateMigrationCode": MessageLookupByLibrary.simpleMessage(
      "Ģenerēt pārcelšanas kodu",
    ),
    "generateNewCode": MessageLookupByLibrary.simpleMessage(
      "Ģenerēt jaunu kodu",
    ),
    "generateWallet": MessageLookupByLibrary.simpleMessage("Ģenerēt maciņu"),
    "generating": MessageLookupByLibrary.simpleMessage("Ģenerē..."),
    "getStarted": MessageLookupByLibrary.simpleMessage("Sākt"),
    "goBack": MessageLookupByLibrary.simpleMessage("Atpakaļ"),
    "googleSignInNotImplemented": MessageLookupByLibrary.simpleMessage(
      "Google pierakstīšanās nav ieviesta.",
    ),
    "gpsLocationDisabled": MessageLookupByLibrary.simpleMessage(
      "GPS atrašanās vieta ir atspējota. Iespējojiet to iestatījumos, lai izmantotu šo funkciju.",
    ),
    "guideline90Days": MessageLookupByLibrary.simpleMessage(
      "Jums ir 90 dienas, lai iesniegtu atsauksmi",
    ),
    "guidelineFalseReports": MessageLookupByLibrary.simpleMessage(
      "Viltus ziņojumi var izraisīt konta apturēšanu",
    ),
    "guidelineFocusExperience": MessageLookupByLibrary.simpleMessage(
      "Fokusējieties uz savu faktisko pieredzi",
    ),
    "guidelineHonest": MessageLookupByLibrary.simpleMessage(
      "Esiet godīgs un taisnīgs",
    ),
    "guidelineVisibility": MessageLookupByLibrary.simpleMessage(
      "Atsauksmes kļūst redzamas pēc abu pušu iesniegšanas",
    ),
    "hairColor": MessageLookupByLibrary.simpleMessage("Matu krāsa"),
    "hairStyle": MessageLookupByLibrary.simpleMessage("Matu stils"),
    "howDidItGo": MessageLookupByLibrary.simpleMessage("Kā gāja? *"),
    "howItWorks": MessageLookupByLibrary.simpleMessage("Kā tas darbojas"),
    "importAccount": MessageLookupByLibrary.simpleMessage("Ievietot kontu"),
    "importAccountDescription": MessageLookupByLibrary.simpleMessage(
      "Ievadiet 10 rakstzīmju pārcelšanas kodu no savas citas ierīces, lai importētu konta datus.",
    ),
    "importExistingAccount": MessageLookupByLibrary.simpleMessage(
      "Importēt eksistējošu kontu",
    ),
    "inAppFailedToInitializePurchases": MessageLookupByLibrary.simpleMessage(
      "Neizdevās inicializēt pirkumus",
    ),
    "inAppFailedToLoadOfferings": MessageLookupByLibrary.simpleMessage(
      "Neizdevās ielādēt piedāvājumus",
    ),
    "inAppNoActivePremiumPurchasesToRestore":
        MessageLookupByLibrary.simpleMessage(
          "Nav atrasti aktīvi Premium pirkumi atjaunošanai.",
        ),
    "inAppNoPremiumPackagesAvailable": MessageLookupByLibrary.simpleMessage(
      "Pašlaik nav pieejamu Premium paku.",
    ),
    "inAppPremiumActivatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Premium veiksmīgi aktivizēts.",
    ),
    "inAppPremiumRestoredSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Premium veiksmīgi atjaunots.",
    ),
    "inAppPurchaseCancelled": MessageLookupByLibrary.simpleMessage(
      "Pirkums atcelts.",
    ),
    "inAppPurchaseCompletedEntitlementNotActiveYet":
        MessageLookupByLibrary.simpleMessage(
          "Pirkums pabeigts, bet piekļuve vēl nav aktivizēta.",
        ),
    "inAppPurchaseFailed": MessageLookupByLibrary.simpleMessage(
      "Pirkums neizdevās",
    ),
    "inAppRestoreFailed": MessageLookupByLibrary.simpleMessage(
      "Atjaunošana neizdevās",
    ),
    "inAppRevenueCatApiKeyMissing": MessageLookupByLibrary.simpleMessage(
      "Trūkst RevenueCat API atslēgas.",
    ),
    "instant": MessageLookupByLibrary.simpleMessage("Tūlītējs"),
    "interest": MessageLookupByLibrary.simpleMessage("Interese"),
    "invalidCode": MessageLookupByLibrary.simpleMessage(
      "Nederīgs atjaunošanas kods",
    ),
    "inviteMessageShare": m23,
    "inviteMessageSubject": MessageLookupByLibrary.simpleMessage(
      "Pievienojies man BarterApp!",
    ),
    "keep": MessageLookupByLibrary.simpleMessage("Paturēt"),
    "languageEnglish": MessageLookupByLibrary.simpleMessage("English"),
    "languageFrench": MessageLookupByLibrary.simpleMessage("Français"),
    "languageGerman": MessageLookupByLibrary.simpleMessage("Deutsch"),
    "languageLatvian": MessageLookupByLibrary.simpleMessage("Latviešu"),
    "languageSpanish": MessageLookupByLibrary.simpleMessage("Español"),
    "lastOnlineDaysAgo": m24,
    "lastOnlineHoursAgo": m25,
    "lastOnlineJustNow": MessageLookupByLibrary.simpleMessage("tikko"),
    "lastOnlineMinutesAgo": m26,
    "lastOnlinePrefix": MessageLookupByLibrary.simpleMessage(
      "Pēdējoreiz tiešsaistē:",
    ),
    "lastOnlineUnknown": MessageLookupByLibrary.simpleMessage("Nezināms"),
    "linkCopiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "Saite nokopēta starpliktuvē!",
    ),
    "loading": MessageLookupByLibrary.simpleMessage("Notiek ielāde..."),
    "loadingWalletBalance": MessageLookupByLibrary.simpleMessage(
      "Ielādē maka atlikumu...",
    ),
    "locationNotFound": MessageLookupByLibrary.simpleMessage(
      "Atrašanās vieta nav atrasta.",
    ),
    "locationPermissionRequiredDescription": MessageLookupByLibrary.simpleMessage(
      "Atrašanās vietas atļauja ir nepieciešama, lai izmantotu GPS atrašanās vietas izsekošanu. Lūdzu, iespējojiet atrašanās vietas atļauju ierīces iestatījumos.",
    ),
    "locationSaved": MessageLookupByLibrary.simpleMessage(
      "Atrašanās vieta saglabāta!",
    ),
    "locationSetAtMarkerInfo": MessageLookupByLibrary.simpleMessage(
      "Jūsu atrašanās vieta tiks iestatīta marķiera atrašanās vietā",
    ),
    "locations": MessageLookupByLibrary.simpleMessage("Atrašanās vietas"),
    "lookingFor": MessageLookupByLibrary.simpleMessage("Meklē"),
    "managePostings": MessageLookupByLibrary.simpleMessage(
      "Pārvaldīt sludinājumus",
    ),
    "manageSecurityQuestion": MessageLookupByLibrary.simpleMessage(
      "Pārvaldīt drošības jautājumu",
    ),
    "manual": MessageLookupByLibrary.simpleMessage("Manuāls"),
    "markAsFulfilled": MessageLookupByLibrary.simpleMessage(
      "Atzīmēt kā izpildītu",
    ),
    "markAsViewed": MessageLookupByLibrary.simpleMessage(
      "Atzīmēt kā apskatītu",
    ),
    "marketingConsentDescription": MessageLookupByLibrary.simpleMessage(
      "Mēs reizēm varam jums nosūtīt e-pastus par mūsu pakalpojumiem. Jūs jebkurā laikā varat atteikties no abonēšanas.",
    ),
    "marketingConsentLabel": MessageLookupByLibrary.simpleMessage(
      "Piekrītu saņemt e-pastus par jauniem piedāvājumiem, iespējām un atjauninājumiem",
    ),
    "match": MessageLookupByLibrary.simpleMessage("Atbilstība"),
    "matchDismissed": MessageLookupByLibrary.simpleMessage(
      "Atbilstība noraidīta",
    ),
    "matchHistory": MessageLookupByLibrary.simpleMessage("Atbilstību vēsture"),
    "matchLabel": MessageLookupByLibrary.simpleMessage("Atbilstība:"),
    "matchScore": MessageLookupByLibrary.simpleMessage("Atbilstības rādītājs"),
    "matches": MessageLookupByLibrary.simpleMessage("Atbilstības"),
    "matchingPostingsFound": m27,
    "matchingUsersFound": m28,
    "maxImagesReached": MessageLookupByLibrary.simpleMessage(
      "Maksimums 3 attēli atļauti",
    ),
    "migrateToNewDevice": MessageLookupByLibrary.simpleMessage(
      "Pārcelt uz jaunu ierīci",
    ),
    "migrateYourAccount": MessageLookupByLibrary.simpleMessage(
      "Pārcelt savu kontu",
    ),
    "migrationCodeDescription": MessageLookupByLibrary.simpleMessage(
      "Ģenerējiet pārcelšanas kodu, lai pārsūtītu konta datus uz jaunu ierīci. Kods būs derīgs 15 minūtes.",
    ),
    "migrationCodeExpired": MessageLookupByLibrary.simpleMessage(
      "Pārcelšanas kods ir beidzies. Lūdzu, ģenerējiet jaunu.",
    ),
    "migrationCompleted": MessageLookupByLibrary.simpleMessage(
      "Pārcelšana pabeigta veiksmīgi!",
    ),
    "migrationDenied": MessageLookupByLibrary.simpleMessage(
      "Pārcelšana aizliegta lietotāja",
    ),
    "migrationStep1": MessageLookupByLibrary.simpleMessage(
      "Ģenerējiet pārcelšanas kodu",
    ),
    "migrationStep2": MessageLookupByLibrary.simpleMessage(
      "Atveriet lietotni jaunajā ierīcē",
    ),
    "migrationStep3": MessageLookupByLibrary.simpleMessage(
      "Sākumekrānā pieskarieties \"Ievietot esošo kontu\"",
    ),
    "migrationStep4": MessageLookupByLibrary.simpleMessage(
      "Ievadiet šo kodu jaunajā ierīcē",
    ),
    "migrationTimedOut": MessageLookupByLibrary.simpleMessage(
      "Pārcelšanas laiks beidzies. Lūdzu, mēģiniet vēlreiz ar jaunu kodu.",
    ),
    "minMatchScore": MessageLookupByLibrary.simpleMessage(
      "Min. atbilstības rādītājs",
    ),
    "mockPoiNotFound": m29,
    "mockPoiNotFoundForUpdate": m30,
    "mouth": MessageLookupByLibrary.simpleMessage("Mute"),
    "myWishlist": MessageLookupByLibrary.simpleMessage("Mans vēlmju saraksts"),
    "nearbyUsersAlertCheckboxSubtitle": MessageLookupByLibrary.simpleMessage(
      "Nosūtīsim paziņojumu, kad jūsu apkārtnē parādīsies pietiekami daudz lietotāju.",
    ),
    "nearbyUsersAlertCheckboxTitle": m31,
    "nearbyUsersAlertDisabled": MessageLookupByLibrary.simpleMessage(
      "Tuvumā esošo lietotāju paziņojums izslēgts.",
    ),
    "nearbyUsersAlertEnabled": MessageLookupByLibrary.simpleMessage(
      "Tuvumā esošo lietotāju paziņojums ieslēgts.",
    ),
    "nearbyUsersAlertLoading": MessageLookupByLibrary.simpleMessage(
      "Pārbaudām paziņojuma iestatījumu...",
    ),
    "nearbyUsersAlertManageDelivery": MessageLookupByLibrary.simpleMessage(
      "Pārvaldiet, kur tiek nosūtīti tuvumā esošo lietotāju paziņojumi.",
    ),
    "nearbyUsersAlertSaveError": MessageLookupByLibrary.simpleMessage(
      "Pašlaik neizdevās atjaunināt tuvumā esošo lietotāju paziņojumu.",
    ),
    "need": MessageLookupByLibrary.simpleMessage("Vajadzība"),
    "newBadge": MessageLookupByLibrary.simpleMessage("JAUNS"),
    "newDeviceDetected": MessageLookupByLibrary.simpleMessage(
      "Jauna ierīce konstatēta",
    ),
    "newDeviceDetectedMessage": MessageLookupByLibrary.simpleMessage(
      "Jauna ierīce vēlas importēt jūsu konta datus. Vai vēlaties to atļaut?",
    ),
    "newPostings": MessageLookupByLibrary.simpleMessage("Jauni sludinājumi"),
    "newUsers": MessageLookupByLibrary.simpleMessage("Jauni lietotāji"),
    "ninetyNinePlus": MessageLookupByLibrary.simpleMessage("99+"),
    "noActivePostings": MessageLookupByLibrary.simpleMessage(
      "Nav aktīvu sludinājumu",
    ),
    "noAppToOpenFile": MessageLookupByLibrary.simpleMessage(
      "Nav atrasta lietotne, lai atvērtu šo faila tipu",
    ),
    "noAttributePreferences": MessageLookupByLibrary.simpleMessage(
      "Nav atribūtu preferenču",
    ),
    "noAttributesInProfile": MessageLookupByLibrary.simpleMessage(
      "Vispirms pievienojiet intereses un prasmes savam profilam",
    ),
    "noAttributesToDisplay": MessageLookupByLibrary.simpleMessage(
      "Nav atribūtu, ko parādīt.",
    ),
    "noBadgesEarnedYet": MessageLookupByLibrary.simpleMessage(
      "Vēl nav nopelnītu nozīmīšu. Turpiniet veikt maiņas, lai tās iegūtu.",
    ),
    "noChatsYet": MessageLookupByLibrary.simpleMessage("Vēl nav sarunu"),
    "noContactsFound": MessageLookupByLibrary.simpleMessage(
      "Nav atrasti kontakti",
    ),
    "noMatchesYet": MessageLookupByLibrary.simpleMessage("Vēl nav atbilstību"),
    "noMessagesYet": MessageLookupByLibrary.simpleMessage("Vēl nav ziņojumu"),
    "noPostingsFound": MessageLookupByLibrary.simpleMessage(
      "Nav atrasti sludinājumi",
    ),
    "noPushTokens": MessageLookupByLibrary.simpleMessage(
      "Nav reģistrētu push paziņojumu marķieru",
    ),
    "noSecurityQuestion": MessageLookupByLibrary.simpleMessage(
      "Nav konfigurēts drošības jautājums",
    ),
    "noSecurityQuestionSet": MessageLookupByLibrary.simpleMessage(
      "Nav iestatīts drošības jautājums",
    ),
    "noUnviewedMatches": MessageLookupByLibrary.simpleMessage(
      "Nav neapskatītu atbilstību",
    ),
    "noUsersFound": MessageLookupByLibrary.simpleMessage(
      "Nav atrasti lietotāji",
    ),
    "noUsersNearbyMessage": MessageLookupByLibrary.simpleMessage(
      "Jūsu apkārtne vēl attīstās. Uzaicini paziņas un veido kopienu — nopelni 50 monētas par pirmo ieteikumu!",
    ),
    "noUsersNearbyTitle": MessageLookupByLibrary.simpleMessage(
      "Nav lietotāju tuvumā",
    ),
    "noWishlistItems": MessageLookupByLibrary.simpleMessage(
      "Vēl nav vēlmju saraksta vienumu",
    ),
    "nose": MessageLookupByLibrary.simpleMessage("Deguns"),
    "notSet": MessageLookupByLibrary.simpleMessage("Nav iestatīts"),
    "notVerified": MessageLookupByLibrary.simpleMessage("Nav verificēts"),
    "notificationEmailConfigured": m32,
    "notificationEmailInvalid": MessageLookupByLibrary.simpleMessage(
      "Ievadiet derīgu e-pasta adresi.",
    ),
    "notificationEmailLabel": MessageLookupByLibrary.simpleMessage(
      "E-pasta adrese",
    ),
    "notificationEmailRequired": MessageLookupByLibrary.simpleMessage(
      "Ievadiet e-pasta adresi.",
    ),
    "notificationEmailSave": MessageLookupByLibrary.simpleMessage(
      "Saglabāt e-pastu",
    ),
    "notificationEmailSaveError": MessageLookupByLibrary.simpleMessage(
      "Pašlaik neizdevās saglabāt paziņojumu e-pastu.",
    ),
    "notificationEmailSaved": MessageLookupByLibrary.simpleMessage(
      "Paziņojumu e-pasts saglabāts.",
    ),
    "notificationEmailSubtitle": MessageLookupByLibrary.simpleMessage(
      "Pievienojiet e-pasta adresi, lai mēs varētu paziņot arī tad, ja push paziņojumi nav pieejami.",
    ),
    "notificationEmailTitle": MessageLookupByLibrary.simpleMessage(
      "Pievienojiet e-pastu paziņojumiem",
    ),
    "notificationPreferences": MessageLookupByLibrary.simpleMessage(
      "Paziņojumu preferences",
    ),
    "notificationSettings": MessageLookupByLibrary.simpleMessage(
      "Paziņojumu iestatījumi",
    ),
    "notifyOnNewPostings": MessageLookupByLibrary.simpleMessage(
      "Paziņot par jauniem sludinājumiem",
    ),
    "notifyOnNewUsers": MessageLookupByLibrary.simpleMessage(
      "Paziņot par jauniem lietotājiem",
    ),
    "offer": MessageLookupByLibrary.simpleMessage("Piedāvājums"),
    "offering": MessageLookupByLibrary.simpleMessage("Piedāvā"),
    "offers": MessageLookupByLibrary.simpleMessage("Piedāvājumi"),
    "ok": MessageLookupByLibrary.simpleMessage("Labi"),
    "onboardingScreenQuestion": MessageLookupByLibrary.simpleMessage(
      "Cik ļoti jūs tas interesē?",
    ),
    "onboardingScreenTitle": MessageLookupByLibrary.simpleMessage(
      "Ievadapmācība",
    ),
    "openSettings": MessageLookupByLibrary.simpleMessage("Atvērt iestatījumus"),
    "optionalField": MessageLookupByLibrary.simpleMessage("Neobligāti"),
    "or": MessageLookupByLibrary.simpleMessage("VAI"),
    "other": MessageLookupByLibrary.simpleMessage("Cits"),
    "pauseWishlist": MessageLookupByLibrary.simpleMessage("Apturēt"),
    "permissionDeniedOpenFile": MessageLookupByLibrary.simpleMessage(
      "Atļauja liegta faila atvēršanai",
    ),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Tālruņa numurs"),
    "phoneUpdated": MessageLookupByLibrary.simpleMessage(
      "Tālrunis atjaunināts",
    ),
    "pickYourLocation": MessageLookupByLibrary.simpleMessage(
      "Izvēlieties savu atrašanās vietu",
    ),
    "pinErrorEmpty": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, ievadiet PIN kodu",
    ),
    "pinErrorIncorrect": m33,
    "pinErrorMismatch": MessageLookupByLibrary.simpleMessage(
      "PIN kodi nesakrīt",
    ),
    "pinErrorTooShort": MessageLookupByLibrary.simpleMessage(
      "PIN kodam jābūt vismaz 4 cipariem",
    ),
    "pinHint": MessageLookupByLibrary.simpleMessage("Ievadiet 4-6 ciparus"),
    "pinLabel": MessageLookupByLibrary.simpleMessage("PIN kods"),
    "pinResetSuccess": MessageLookupByLibrary.simpleMessage(
      "Jūsu PIN kods ir veiksmīgi atiestatīts.",
    ),
    "pinResetSuccessfully": MessageLookupByLibrary.simpleMessage(
      "PIN kods veiksmīgi atiestatīts",
    ),
    "pinSetSuccessfully": MessageLookupByLibrary.simpleMessage(
      "PIN kods veiksmīgi iestatīts",
    ),
    "pinSetupDescription": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, iestatiet 5 ciparu PIN kodu drošībai",
    ),
    "pleaseEnter5DigitPin": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, ievadiet 5 ciparu PIN kodu.",
    ),
    "pleaseEnterAnswer": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, ievadiet savu atbildi",
    ),
    "pleaseEnterTitle": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, ievadiet nosaukumu",
    ),
    "pleaseEnterValidEmail": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, ievadiet derīgu e-pasta adresi.",
    ),
    "pleaseEnterValidEmailAddress": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, ievadiet derīgu e-pasta adresi",
    ),
    "pleaseSelectAtLeastOneInterest": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, izvēlieties vismaz vienu interesi vai pievienojiet pielāgotu atslēgvārdu",
    ),
    "pleaseSelectAtLeastOneOffer": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, izvēlieties vismaz vienu piedāvājumu vai pievienojiet pielāgotu atslēgvārdu",
    ),
    "pleaseSelectLocationFirst": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, vispirms izvēlieties atrašanās vietu.",
    ),
    "pleaseSelectQuestion": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, izvēlieties drošības jautājumu",
    ),
    "pointsOfInterest": MessageLookupByLibrary.simpleMessage("Interešu punkti"),
    "postedPrefix": MessageLookupByLibrary.simpleMessage("Publicēts"),
    "posting": MessageLookupByLibrary.simpleMessage("Sludinājums"),
    "postingCreatedSuccess": MessageLookupByLibrary.simpleMessage(
      "Sludinājums veiksmīgi izveidots!",
    ),
    "postingDeleted": MessageLookupByLibrary.simpleMessage(
      "Sludinājums veiksmīgi dzēsts",
    ),
    "postingDescription": MessageLookupByLibrary.simpleMessage("Apraksts"),
    "postingDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "Detalizēts apraksts par to, ko piedāvājat vai meklējat",
    ),
    "postingDescriptionRequired": MessageLookupByLibrary.simpleMessage(
      "Apraksts ir obligāts",
    ),
    "postingDescriptionTooShort": MessageLookupByLibrary.simpleMessage(
      "Aprakstam jābūt vismaz 10 rakstzīmēm",
    ),
    "postingImages": MessageLookupByLibrary.simpleMessage("Attēli"),
    "postingImagesHint": MessageLookupByLibrary.simpleMessage(
      "Pievienojiet līdz 3 attēliem (neobligāti)",
    ),
    "postingMatch": MessageLookupByLibrary.simpleMessage(
      "Sludinājuma atbilstība",
    ),
    "postingTitle": MessageLookupByLibrary.simpleMessage("Nosaukums"),
    "postingTitleHint": MessageLookupByLibrary.simpleMessage(
      "Īss sludinājuma nosaukums",
    ),
    "postingTitleRequired": MessageLookupByLibrary.simpleMessage(
      "Nosaukums ir obligāts",
    ),
    "postingTitleTooShort": MessageLookupByLibrary.simpleMessage(
      "Nosaukumam jābūt vismaz 3 rakstzīmēm",
    ),
    "postingUpdatedSuccess": MessageLookupByLibrary.simpleMessage(
      "Sludinājums veiksmīgi atjaunināts",
    ),
    "postingValue": MessageLookupByLibrary.simpleMessage(
      "Vērtība (Neobligāti)",
    ),
    "postingValueHint": MessageLookupByLibrary.simpleMessage(
      "Aptuvena vērtība",
    ),
    "postingValueInvalid": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, ievadiet derīgu pozitīvu skaitli",
    ),
    "postings": MessageLookupByLibrary.simpleMessage("Sludinājumi"),
    "preferenceDeleted": MessageLookupByLibrary.simpleMessage(
      "Preference dzēsta",
    ),
    "preferenceUpdated": MessageLookupByLibrary.simpleMessage(
      "Preference atjaunināta",
    ),
    "preferencesCreated": MessageLookupByLibrary.simpleMessage(
      "Paziņojumu iestatījumi saglabātas",
    ),
    "premiumProfileEditorAddImage": MessageLookupByLibrary.simpleMessage(
      "Pievienot attēlu",
    ),
    "premiumProfileEditorAvatarSvg": MessageLookupByLibrary.simpleMessage(
      "Avatars (.svg)",
    ),
    "premiumProfileEditorDescription": MessageLookupByLibrary.simpleMessage(
      "Šeit varat atjaunināt savu vārdu, aprakstu, darba atsauces un avatara SVG.",
    ),
    "premiumProfileEditorDescriptionOptional":
        MessageLookupByLibrary.simpleMessage("Apraksts (neobligāti)"),
    "premiumProfileEditorDisplayNameOptional":
        MessageLookupByLibrary.simpleMessage("Parādāmais vārds (neobligāti)"),
    "premiumProfileEditorHeader": MessageLookupByLibrary.simpleMessage(
      "Pielāgojiet savu Premium profilu",
    ),
    "premiumProfileEditorNoAvatarSvgSelected":
        MessageLookupByLibrary.simpleMessage("Nav atlasīts avatara SVG."),
    "premiumProfileEditorNoWorkReferenceImages":
        MessageLookupByLibrary.simpleMessage("Vēl nav darbu atsauču attēlu."),
    "premiumProfileEditorRemoveSvg": MessageLookupByLibrary.simpleMessage(
      "Noņemt SVG",
    ),
    "premiumProfileEditorReplace": MessageLookupByLibrary.simpleMessage(
      "Aizvietot",
    ),
    "premiumProfileEditorSaving": MessageLookupByLibrary.simpleMessage(
      "Saglabā...",
    ),
    "premiumProfileEditorSelectedFile": m34,
    "premiumProfileEditorTitle": MessageLookupByLibrary.simpleMessage(
      "Premium profila redaktors",
    ),
    "premiumProfileEditorUploadSvg": MessageLookupByLibrary.simpleMessage(
      "Augšupielādēt SVG",
    ),
    "premiumProfileEditorWorkReferenceDescription":
        MessageLookupByLibrary.simpleMessage(
          "Pievienojiet un pārvaldiet savus atsauču attēlus.",
        ),
    "premiumProfileEditorWorkReferenceImages":
        MessageLookupByLibrary.simpleMessage("Darbu atsauču attēli"),
    "premiumUserBenefitsMessage": MessageLookupByLibrary.simpleMessage(
      "Atbloķējiet Premium, lai iegūtu šīs priekšrocības:\n• Rediģēt savu vārdu\n• Rediģēt profila aprakstu\n• Rediģēt savu profila ikonu\n• Pievienot darba atsauču attēlus\n• Izcelties kartē\n• Atļauti vairāk nekā 3 aktīvi sludinājumi",
    ),
    "premiumUserBenefitsTitle": MessageLookupByLibrary.simpleMessage(
      "Premium lietotāja priekšrocības",
    ),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privātuma politika"),
    "privacyPolicyChangesContent": MessageLookupByLibrary.simpleMessage(
      "Mēs laiku pa laikam varam atjaunināt šo politiku. Būtiskas izmaiņas jākomunicē lietotnē vai citā atbilstošā kanālā, norādot atjauninātus spēkā stāšanās datumus.",
    ),
    "privacyPolicyChangesTitle": MessageLookupByLibrary.simpleMessage(
      "Izmaiņas šajā politikā",
    ),
    "privacyPolicyContactContent": MessageLookupByLibrary.simpleMessage(
      "Privātuma un GDPR pieprasījumiem: info@bartering.app",
    ),
    "privacyPolicyContactTitle": MessageLookupByLibrary.simpleMessage(
      "Kontakti",
    ),
    "privacyPolicyDataCollectionContent": MessageLookupByLibrary.simpleMessage(
      "Mēs varam apstrādāt konta/autentifikācijas datus (t.sk. paraksta metadatus), profila datus, sludinājumu un čata datus, paziņojumu datus (e-pasts, push tokeni, piekrišanu karogi), drošības/compliance ierakstus un tehniskos pieprasījumu metadatus.",
    ),
    "privacyPolicyDataCollectionTitle": MessageLookupByLibrary.simpleMessage(
      "Kādus datus mēs apstrādājam",
    ),
    "privacyPolicyDataSecurityContent": MessageLookupByLibrary.simpleMessage(
      "Mēs izmantojam pasākumus, piemēram, autentificētu pieprasījumu parakstu pārbaudes, piekļuves kontroli, transporta drošību un audita žurnālus. Tiek izmantotas glabāšanas kontroles un plānota tīrīšana operacionālajiem/compliance ierakstiem, ar legal hold saderīgu apstrādi, kur nepieciešams.",
    ),
    "privacyPolicyDataSecurityTitle": MessageLookupByLibrary.simpleMessage(
      "Drošība, glabāšana un dzēšana",
    ),
    "privacyPolicyDataSharingContent": MessageLookupByLibrary.simpleMessage(
      "Pašreizējās integrācijas var ietvert PostgreSQL, Mailjet, Firebase/FCM, Ollama, kā arī Nginx + Docker infrastruktūru. Izvēles federācijas mezgli tiek izmantoti tikai tad, ja tie ir ieslēgti un uzticami. Ja dati tiek apstrādāti ārpus jūsu valsts/EEZ, tiek piemērotas juridiski prasītās garantijas (piemēram, SCC).",
    ),
    "privacyPolicyDataSharingTitle": MessageLookupByLibrary.simpleMessage(
      "Apstrādātāji, infrastruktūra un pārsūtīšana",
    ),
    "privacyPolicyDataUsageContent": MessageLookupByLibrary.simpleMessage(
      "Apstrāde nodrošina pakalpojuma sniegšanu (GDPR 6(1)(b)), drošību un ļaunprātīgas izmantošanas novēršanu (GDPR 6(1)(f)), kā arī juridiskos/compliance pienākumus (GDPR 6(1)(c), 6(1)(f)). Ja piemērojams, izvēles funkcijas un piekrišanas tiek apstrādātas saskaņā ar GDPR 6(1)(a).",
    ),
    "privacyPolicyDataUsageTitle": MessageLookupByLibrary.simpleMessage(
      "Mērķi un GDPR juridiskie pamati",
    ),
    "privacyPolicyIntroContent": MessageLookupByLibrary.simpleMessage(
      "Šī politika skaidro, kā Barter backend pakalpojumi un saistītie mobilie/tīmekļa klienti apstrādā personas datus. Tā aptver backend API, klienta lietotnes, admin/compliance rīkus un izvēles federācijas funkcijas, ja tās ir ieslēgtas.",
    ),
    "privacyPolicyIntroTitle": MessageLookupByLibrary.simpleMessage(
      "Pārzinis, tvērums un kontakti",
    ),
    "privacyPolicyLastUpdated": MessageLookupByLibrary.simpleMessage(
      "Pēdējoreiz atjaunots: 2026-04-13",
    ),
    "privacyPolicyThirdPartyContent": MessageLookupByLibrary.simpleMessage(
      "Šis lietotnē redzamais teksts apkopo backend-centrisku apstrādi un jālasa kopā ar klienta lietotnes paziņojumiem (atļaujas, identifikatori, push UX un lokālā glabātuve/sīkdatnes, kur piemērojams).",
    ),
    "privacyPolicyThirdPartyTitle": MessageLookupByLibrary.simpleMessage(
      "Backend un klienta privātuma paziņojums",
    ),
    "privacyPolicyUserRightsContent": MessageLookupByLibrary.simpleMessage(
      "Ievērojot piemērojamos tiesību aktus, varat pieprasīt piekļuvi, labošanu, dzēšanu, ierobežošanu, pārnesamību, iebildumus un piekrišanas atsaukšanu. Autentificētas dzēšanas/eksporta plūsmas ietver legal hold pārbaudes, DSAR uzskaiti un compliance notikumu žurnalēšanu.",
    ),
    "privacyPolicyUserRightsTitle": MessageLookupByLibrary.simpleMessage(
      "Jūsu tiesības, dzēšana un pārnesamība",
    ),
    "privateKey": MessageLookupByLibrary.simpleMessage("Privātā atslēga"),
    "profileDeleted": MessageLookupByLibrary.simpleMessage(
      "Profils veiksmīgi dzēsts",
    ),
    "profilePanelTitle": MessageLookupByLibrary.simpleMessage("Profils"),
    "provideMoreContext": MessageLookupByLibrary.simpleMessage(
      "Sniedziet vairāk konteksta...",
    ),
    "publicKey": MessageLookupByLibrary.simpleMessage("Publiskā atslēga"),
    "purchaseCoins": MessageLookupByLibrary.simpleMessage("Pirkt monētas"),
    "purchaseCoinsFlowComingSoon": MessageLookupByLibrary.simpleMessage(
      "Monētu pirkšanas plūsma drīzumā",
    ),
    "pushNotifications": MessageLookupByLibrary.simpleMessage(
      "Push paziņojumi",
    ),
    "pushTokenRemoved": MessageLookupByLibrary.simpleMessage(
      "Push marķieris noņemts",
    ),
    "questionsAnswered": m35,
    "quietHours": MessageLookupByLibrary.simpleMessage("Klusās stundas"),
    "quietHoursDescription": MessageLookupByLibrary.simpleMessage(
      "Nesūtīt paziņojumus šajā laikā",
    ),
    "randomize": MessageLookupByLibrary.simpleMessage("Nejauši"),
    "ratingAndReviews": MessageLookupByLibrary.simpleMessage(
      "Reputācija un Atsauksmes",
    ),
    "ratingExcellent": MessageLookupByLibrary.simpleMessage("Izcils"),
    "ratingGood": MessageLookupByLibrary.simpleMessage("Labs"),
    "ratingOkay": MessageLookupByLibrary.simpleMessage("Labi"),
    "ratingPoor": MessageLookupByLibrary.simpleMessage("Vāji"),
    "ratingRequired": MessageLookupByLibrary.simpleMessage("Vērtējums *"),
    "ratingVeryBad": MessageLookupByLibrary.simpleMessage("Ļoti slikti"),
    "recommendations": MessageLookupByLibrary.simpleMessage("Ieteikumi:"),
    "recoverAccount": MessageLookupByLibrary.simpleMessage("Atjaunot kontu"),
    "recoverAccountDescription": MessageLookupByLibrary.simpleMessage(
      "Ievadiet savu e-pasta adresi, lai saņemtu atjaunošanas kodu un atjaunotu savu kontu šajā ierīcē.",
    ),
    "recoverViaEmail": MessageLookupByLibrary.simpleMessage(
      "Atjaunot pa e-pastu",
    ),
    "recoveryFailed": MessageLookupByLibrary.simpleMessage(
      "Konta atjaunošana neizdevās",
    ),
    "recoverySuccess": MessageLookupByLibrary.simpleMessage(
      "Atjaunošana veiksmīga!",
    ),
    "recoverySuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Jūsu konts ir veiksmīgi atjaunots šajā ierīcē.",
    ),
    "relevancy": MessageLookupByLibrary.simpleMessage("Atbilstība"),
    "remove": MessageLookupByLibrary.simpleMessage("Noņemt"),
    "removePushToken": MessageLookupByLibrary.simpleMessage(
      "Noņemt Push marķieri",
    ),
    "removePushTokenConfirmation": MessageLookupByLibrary.simpleMessage(
      "Vai tiešām vēlaties noņemt šo push marķieri?",
    ),
    "report": MessageLookupByLibrary.simpleMessage("Ziņot"),
    "reportReason": MessageLookupByLibrary.simpleMessage(
      "Ziņošanas iemesls (neobligāti)",
    ),
    "reportReasonFakeProfile": MessageLookupByLibrary.simpleMessage(
      "Viltots profils",
    ),
    "reportReasonHarassment": MessageLookupByLibrary.simpleMessage(
      "Uzmākšanās",
    ),
    "reportReasonImpersonation": MessageLookupByLibrary.simpleMessage(
      "Uzdošanās par citu",
    ),
    "reportReasonInappropriateContent": MessageLookupByLibrary.simpleMessage(
      "Nepiemērots saturs",
    ),
    "reportReasonOther": MessageLookupByLibrary.simpleMessage("Cits"),
    "reportReasonScam": MessageLookupByLibrary.simpleMessage("Krāpšana"),
    "reportReasonSpam": MessageLookupByLibrary.simpleMessage("Spam"),
    "reportReasonThreateningBehavior": MessageLookupByLibrary.simpleMessage(
      "Draudoša uzvedība",
    ),
    "reportScam": MessageLookupByLibrary.simpleMessage("Ziņot par krāpšanu"),
    "reportScamConfirmation": MessageLookupByLibrary.simpleMessage(
      "Vai tiešām vēlaties ziņot par šo lietotāju kā krāpnieku?",
    ),
    "reportScamConsequence1": MessageLookupByLibrary.simpleMessage(
      "• Šī transakcija tiks atzīmēta moderatora pārskatīšanai",
    ),
    "reportScamConsequence2": MessageLookupByLibrary.simpleMessage(
      "• Iespējams, otra lietotāja profils tiks apturēts",
    ),
    "reportScamConsequence3": MessageLookupByLibrary.simpleMessage(
      "• Jums būs jāsniedz pierādījumi",
    ),
    "reportScamConsequencesTitle": MessageLookupByLibrary.simpleMessage(
      "Tas nozīmē:",
    ),
    "reportSubmittedOfferBlock": MessageLookupByLibrary.simpleMessage(
      "Paldies, ka palīdzat uzturēt kopienu drošu. Vai vēlaties arī bloķēt šo lietotāju?",
    ),
    "reportUser": MessageLookupByLibrary.simpleMessage("Ziņot par lietotāju"),
    "reportUserConfirmation": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, norādiet iemeslu ziņošanai par šo lietotāju.",
    ),
    "reportUserTitle": m36,
    "requestCollectedDataExport": MessageLookupByLibrary.simpleMessage(
      "Pieprasīt savākto datu eksportu",
    ),
    "resendCode": MessageLookupByLibrary.simpleMessage("Nosūtīt kodu vēlreiz"),
    "resendCodeIn": m37,
    "resetLinkSentMessage": MessageLookupByLibrary.simpleMessage(
      "Ja konts eksistē, atiestatīšanas saite ir nosūtīta.",
    ),
    "resetYourPin": MessageLookupByLibrary.simpleMessage("Atiestatīt PIN kodu"),
    "restorePurchases": MessageLookupByLibrary.simpleMessage(
      "Atjaunot pirkumus",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Mēģināt vēlreiz"),
    "review": MessageLookupByLibrary.simpleMessage("Atsauksme"),
    "reviewGuidelines": MessageLookupByLibrary.simpleMessage(
      "Atsauksmju vadlīnijas",
    ),
    "reviewSubmitted": MessageLookupByLibrary.simpleMessage(
      "Atsauksme iesniegta!",
    ),
    "reviewUser": m38,
    "reviewVisibilityNotice": MessageLookupByLibrary.simpleMessage(
      "Jūsu atsauksme būs redzama pēc tam, kad otrs lietotājs iesniegs savu atsauksmi, vai pēc 14 dienām.",
    ),
    "reviewsCount": m39,
    "save": MessageLookupByLibrary.simpleMessage("Saglabāt"),
    "saveAndContinue": MessageLookupByLibrary.simpleMessage(
      "Saglabāt un turpināt",
    ),
    "saveEmail": MessageLookupByLibrary.simpleMessage("Saglabāt e-pastu"),
    "saveLocation": MessageLookupByLibrary.simpleMessage(
      "Saglabāt atrašanās vietu",
    ),
    "saveSecurityQuestion": MessageLookupByLibrary.simpleMessage(
      "Saglabāt drošības jautājumu",
    ),
    "searchForAKeyword": MessageLookupByLibrary.simpleMessage(
      "Meklēt atslēgvārdu",
    ),
    "searchForALocation": MessageLookupByLibrary.simpleMessage(
      "Meklēt atrašanās vietu",
    ),
    "securityAnswerIncorrect": m40,
    "securityAnswerNote": MessageLookupByLibrary.simpleMessage(
      "Piezīme: Atbildes nav reģistrjutīgas",
    ),
    "securityCheck": MessageLookupByLibrary.simpleMessage("Drošības pārbaude"),
    "securityCheckMessage": MessageLookupByLibrary.simpleMessage(
      "Viss izskatās labi!",
    ),
    "securityNotice": MessageLookupByLibrary.simpleMessage(
      "Drošības paziņojums",
    ),
    "securityNoticeMessage": MessageLookupByLibrary.simpleMessage(
      "Mēs esam konstatējuši dažus neparastus modeļus. Jūsu pārskatam var piemērot papildu verifikāciju.",
    ),
    "securityQuestion1": MessageLookupByLibrary.simpleMessage(
      "Kā sauca jūsu pirmo mājdzīvnieku?",
    ),
    "securityQuestion2": MessageLookupByLibrary.simpleMessage(
      "Kurā pilsētā jūs piedzimat?",
    ),
    "securityQuestion3": MessageLookupByLibrary.simpleMessage(
      "Kāds ir jūsu mātes uzvārds pirms laulības?",
    ),
    "securityQuestion4": MessageLookupByLibrary.simpleMessage(
      "Kā sauca jūsu pamatskolu?",
    ),
    "securityQuestion5": MessageLookupByLibrary.simpleMessage(
      "Kāda ir jūsu iecienītākā grāmata?",
    ),
    "securityQuestionDescription": MessageLookupByLibrary.simpleMessage(
      "Iestatiet drošības jautājumu, lai palīdzētu atgūt PIN kodu, ja to aizmirstat",
    ),
    "securityQuestionSaved": MessageLookupByLibrary.simpleMessage(
      "Drošības jautājums veiksmīgi saglabāts",
    ),
    "securityQuestionSet": MessageLookupByLibrary.simpleMessage(
      "Drošības jautājums ir iestatīts",
    ),
    "securityWarning": MessageLookupByLibrary.simpleMessage(
      "Drošības brīdinājums",
    ),
    "securityWarningMessage": MessageLookupByLibrary.simpleMessage(
      "Ir konstatēta neparasta aktivitāte. Var būt nepieciešama papildu verifikācija.",
    ),
    "selectAttributes": MessageLookupByLibrary.simpleMessage(
      "Izvēlēties atribūtus",
    ),
    "selectCoinPackage": MessageLookupByLibrary.simpleMessage(
      "Izvēlieties monētu pakotni:",
    ),
    "selectLocation": MessageLookupByLibrary.simpleMessage(
      "Izvēlēties atrašanās vietu",
    ),
    "selectSecurityQuestion": MessageLookupByLibrary.simpleMessage(
      "Izvēlieties jautājumu",
    ),
    "selectTheInterestsThatMatchYourPreferences":
        MessageLookupByLibrary.simpleMessage(
          "Izvēlieties atslēgvārdus, kas atbilst Jūsu vēlmēm",
        ),
    "selectTheOffersThatYouCanProvide": MessageLookupByLibrary.simpleMessage(
      "Izvēlieties piedāvājumus/lietas, ko varat sniegt",
    ),
    "selectYourInterests": MessageLookupByLibrary.simpleMessage(
      "Ko Jūs meklējat?",
    ),
    "selectYourOffers": MessageLookupByLibrary.simpleMessage(
      "Ko Jūs piedāvājat?",
    ),
    "selectedCoinPackage": m41,
    "sendRecoveryCode": MessageLookupByLibrary.simpleMessage(
      "Nosūtīt atjaunošanas kodu",
    ),
    "sendResetLink": MessageLookupByLibrary.simpleMessage(
      "Nosūtīt atiestatīšanas saiti",
    ),
    "setPinButton": MessageLookupByLibrary.simpleMessage("Iestatīt PIN"),
    "setPinDescription": MessageLookupByLibrary.simpleMessage(
      "Izveidojiet 4-6 ciparu PIN kodu, lai aizsargātu lietotni",
    ),
    "setPinTitle": MessageLookupByLibrary.simpleMessage("Iestatīt PIN kodu"),
    "setUpAccount": MessageLookupByLibrary.simpleMessage("Iestatīt kontu"),
    "settingsChangePinButton": MessageLookupByLibrary.simpleMessage(
      "Mainīt PIN kodu",
    ),
    "settingsChangePinDescription": MessageLookupByLibrary.simpleMessage(
      "Atjaunināt drošības PIN kodu",
    ),
    "settingsGpsLocationDescription": MessageLookupByLibrary.simpleMessage(
      "Kad iespējots, varat pietuvināt karti līdz pašreizējai GPS atrašanās vietai. Lietotne pieprasīs atrašanās vietas atļaujas, kad nepieciešams.",
    ),
    "settingsGpsLocationDisabledDescription":
        MessageLookupByLibrary.simpleMessage(
          "GPS atrašanās vietas izsekošana ir atspējota",
        ),
    "settingsGpsLocationEnabledDescription":
        MessageLookupByLibrary.simpleMessage(
          "GPS atrašanās vietas izsekošana ir iespējota",
        ),
    "settingsGpsLocationTitle": MessageLookupByLibrary.simpleMessage(
      "Iespējot GPS atrašanās vietu",
    ),
    "settingsKeywordSearchRadiusDescription":
        MessageLookupByLibrary.simpleMessage(
          "Meklēšanas rādiuss, izmantojot atslēgvārdu meklēšanu",
        ),
    "settingsKeywordSearchRadiusTitle": MessageLookupByLibrary.simpleMessage(
      "Atslēgvārdu meklēšanas rādiuss",
    ),
    "settingsKeywordSearchWeightDescription":
        MessageLookupByLibrary.simpleMessage(
          "Svara parametrs atslēgvārdu meklēšanas atbilstībai (10-100)",
        ),
    "settingsKeywordSearchWeightTitle": MessageLookupByLibrary.simpleMessage(
      "Atslēgvārdu meklēšanas svars",
    ),
    "settingsLanguageDescription": MessageLookupByLibrary.simpleMessage(
      "Izvēlieties vēlamo lietotnes valodu",
    ),
    "settingsLanguageRestartMessage": MessageLookupByLibrary.simpleMessage(
      "Lūdzu, restartējiet lietotni, lai lietotu valodas izmaiņas",
    ),
    "settingsLanguageSection": MessageLookupByLibrary.simpleMessage("Valoda"),
    "settingsLanguageTitle": MessageLookupByLibrary.simpleMessage(
      "Lietotnes valoda",
    ),
    "settingsNearbyUsersRadiusDescription":
        MessageLookupByLibrary.simpleMessage(
          "Cik tālu meklēt lietotājus tuvumā",
        ),
    "settingsNearbyUsersRadiusTitle": MessageLookupByLibrary.simpleMessage(
      "Tuvumā esošo lietotāju meklēšanas rādiuss",
    ),
    "settingsPinDisabledDescription": MessageLookupByLibrary.simpleMessage(
      "Ieslēgt PIN kodu papildu drošībai",
    ),
    "settingsPinEnabledDescription": MessageLookupByLibrary.simpleMessage(
      "Lietotne ir aizsargāta ar PIN kodu",
    ),
    "settingsPinTitle": MessageLookupByLibrary.simpleMessage("PIN aizsardzība"),
    "settingsSaved": MessageLookupByLibrary.simpleMessage(
      "Iestatījumi veiksmīgi saglabāti",
    ),
    "settingsSearchCenterMapCenter": MessageLookupByLibrary.simpleMessage(
      "Kartes centrs",
    ),
    "settingsSearchCenterMapCenterDescription":
        MessageLookupByLibrary.simpleMessage(
          "Meklēt no pašreizējā kartes centra",
        ),
    "settingsSearchCenterPointDescription":
        MessageLookupByLibrary.simpleMessage(
          "Izvēlieties centrālo punktu lietotāju meklēšanai tuvumā",
        ),
    "settingsSearchCenterPointTitle": MessageLookupByLibrary.simpleMessage(
      "Meklēšanas centrālais punkts",
    ),
    "settingsSearchCenterUserLocation": MessageLookupByLibrary.simpleMessage(
      "Lietotāja atrašanās vieta",
    ),
    "settingsSearchCenterUserLocationDescription":
        MessageLookupByLibrary.simpleMessage(
          "Meklēt no jūsu saglabātās atrašanās vietas",
        ),
    "settingsSearchSection": MessageLookupByLibrary.simpleMessage(
      "Meklēšanas iestatījumi",
    ),
    "settingsSecuritySection": MessageLookupByLibrary.simpleMessage("Drošība"),
    "settingsShowResultsAsListDescription": MessageLookupByLibrary.simpleMessage(
      "Rādīt atslēgvārdu un tuvumā esošo lietotāju meklēšanas rezultātus saraksta skatā, nevis uz kartes",
    ),
    "settingsShowResultsAsListTitle": MessageLookupByLibrary.simpleMessage(
      "Rādīt meklēšanas rezultātus kā sarakstu",
    ),
    "settingsShowResultsAsListViewDescription":
        MessageLookupByLibrary.simpleMessage(
          "Rādīt meklēšanas rezultātus saraksta skatā",
        ),
    "settingsShowResultsOnMapDescription": MessageLookupByLibrary.simpleMessage(
      "Rādīt meklēšanas rezultātus uz kartes (noklusējums)",
    ),
    "settingsTitle": MessageLookupByLibrary.simpleMessage("Iestatījumi"),
    "setupAttributeNotifications": MessageLookupByLibrary.simpleMessage(
      "Iestatīt paziņojumus",
    ),
    "setupAttributeNotificationsHint": MessageLookupByLibrary.simpleMessage(
      "Ieslēdziet paziņojumus savām interesēm un prasmēm, lai saņemtu brīdinājumus, kad tiek atrastas atbilstības",
    ),
    "setupEmailDescription": MessageLookupByLibrary.simpleMessage(
      "Ievadiet savu e-pasta adresi, lai saņemtu paziņojumus",
    ),
    "setupEmailTitle": MessageLookupByLibrary.simpleMessage("Iestatīt e-pastu"),
    "setupSecurityQuestion": MessageLookupByLibrary.simpleMessage(
      "Iestatīt drošības jautājumu",
    ),
    "setupSecurityQuestionButton": MessageLookupByLibrary.simpleMessage(
      "Iestatīt drošības jautājumu",
    ),
    "shareApp": MessageLookupByLibrary.simpleMessage("Dalīties ar lietotni"),
    "shareYourExperience": MessageLookupByLibrary.simpleMessage(
      "Dalieties ar savu pieredzi...",
    ),
    "shareYourInterestsToFindBestMatches": MessageLookupByLibrary.simpleMessage(
      "Dalieties ar savām interesēm, lai atrastu labākās atbilstības ar citiem!",
    ),
    "showLess": MessageLookupByLibrary.simpleMessage("Rādīt mazāk"),
    "showMore": MessageLookupByLibrary.simpleMessage("Rādīt vairāk"),
    "showPath": MessageLookupByLibrary.simpleMessage("Rādīt ceļu"),
    "similar": MessageLookupByLibrary.simpleMessage("Līdzīgs"),
    "skin": MessageLookupByLibrary.simpleMessage("Āda"),
    "skip": MessageLookupByLibrary.simpleMessage("Izlaist"),
    "skipForNow": MessageLookupByLibrary.simpleMessage("Pagaidām izlaist"),
    "skipPinButton": MessageLookupByLibrary.simpleMessage("Pagaidām izlaist"),
    "skipReviewMessage": MessageLookupByLibrary.simpleMessage(
      "Jūs varat atsauksmēt šo lietotāju vēlāk no savas transakciju vēstures. Atsauksmes palīdz veidot uzticību kopienā.",
    ),
    "skipReviewTitle": MessageLookupByLibrary.simpleMessage(
      "Izlaist atsauksmi?",
    ),
    "startConversationFromMap": MessageLookupByLibrary.simpleMessage(
      "Sāciet sarunu no kartes",
    ),
    "startTime": MessageLookupByLibrary.simpleMessage("Sākuma laiks"),
    "styleNumber": m42,
    "submitReport": MessageLookupByLibrary.simpleMessage("Iesniegt ziņojumu"),
    "submitReview": MessageLookupByLibrary.simpleMessage("Iesniegt atsauksmi"),
    "submitting": MessageLookupByLibrary.simpleMessage("Notiek iesniegšana..."),
    "submittingOffers": MessageLookupByLibrary.simpleMessage(
      "Notiek piedāvājumu iesniegšana...",
    ),
    "takePhoto": MessageLookupByLibrary.simpleMessage("Uzņemt fotogrāfiju"),
    "tapToChat": MessageLookupByLibrary.simpleMessage(
      "Pieskarieties, lai tērzētu",
    ),
    "tapToExpandMainCluster": MessageLookupByLibrary.simpleMessage(
      "Pieskarieties, lai izvērstu galveno grupu",
    ),
    "tapToExpandSubCluster": MessageLookupByLibrary.simpleMessage(
      "Pieskarieties, lai izvērstu apakšgrupu",
    ),
    "tapToRate": MessageLookupByLibrary.simpleMessage(
      "Pieskarieties, lai vērtētu",
    ),
    "tapToSelectDate": MessageLookupByLibrary.simpleMessage(
      "Pieskarieties, lai izvēlētos derīguma termiņu (neobligāti)",
    ),
    "targetDeviceTimeout": MessageLookupByLibrary.simpleMessage(
      "Mērķa ierīce nepievienojās laikā",
    ),
    "targetStep1": MessageLookupByLibrary.simpleMessage(
      "Atveriet lietotni savā citā ierīcē",
    ),
    "targetStep2": MessageLookupByLibrary.simpleMessage(
      "Dodieties uz Iestatījumi → Konts → Pārcelt ierīci",
    ),
    "targetStep3": MessageLookupByLibrary.simpleMessage(
      "Ievadiet kodu, kas redzams uz šīs ierīces",
    ),
    "tellUsMore": MessageLookupByLibrary.simpleMessage(
      "Pastāstiet vairāk (neobligāti)",
    ),
    "termsConditionsSectionAccountRestrictionContent":
        MessageLookupByLibrary.simpleMessage(
          "Mēs varam ierobežot vai dzēst kontus par noteikumu pārkāpumiem vai drošības riskiem.",
        ),
    "termsConditionsSectionAccountRestrictionTitle":
        MessageLookupByLibrary.simpleMessage(
          "5. Konta ierobežošana vai dzēšana",
        ),
    "termsConditionsSectionAccountUseContent": MessageLookupByLibrary.simpleMessage(
      "Jūs esat atbildīgs par sava konta drošību un par aktivitātēm, kas notiek, izmantojot jūsu kontu. Jums jāieveda jūsu e-pasta adrese Profila sadaļā - Paziņojumu iestatījumos lai varētu atjaunot profilu, vai pieprasīt tā dzēšanu, ja zaudējat piekļuvi ierīcei.",
    ),
    "termsConditionsSectionAccountUseTitle":
        MessageLookupByLibrary.simpleMessage(
          "3. Konta lietošana, atjaunošana un dzēšana",
        ),
    "termsConditionsSectionChangesContent": MessageLookupByLibrary.simpleMessage(
      "Mēs varam periodiski atjaunināt šos noteikumus. Turpinot lietot lietotni pēc izmaiņām, jūs piekrītat atjauninātajiem noteikumiem.",
    ),
    "termsConditionsSectionChangesTitle": MessageLookupByLibrary.simpleMessage(
      "8. Izmaiņas noteikumos",
    ),
    "termsConditionsSectionKidsSafetyContent": MessageLookupByLibrary.simpleMessage(
      "Mums ir nulles tolerance pret bērnu seksuālu izmantošanu un vardarbību (CSAE), tostarp bērnu seksuālas izmantošanas materiāliem (CSAM), pavedināšanu, cilvēku tirdzniecību un jebkādu nepilngadīgo seksuālu ekspluatāciju.\n\nŠajā platformā ir stingri aizliegts:\n- publicēt, pieprasīt, izplatīt vai glabāt CSAM\n- seksualizēta saziņa ar nepilngadīgajiem\n- pavedināšana, piespiešana, cilvēku tirdzniecība vai nepilngadīgo ekspluatācija\n- jebkāds mēģinājums izmantot šo pakalpojumu, lai apdraudētu bērnu\n\nMēs varam dzēst saturu, ierobežot vai dzēst kontus, un likumā noteiktajos gadījumos ziņot kompetentajām iestādēm. Lietotāji var ziņot par pārkāpumiem lietotnē vai rakstot uz info@bartering.app.\n\nMēs drošības ziņojumus izskatām pēc iespējas ātri un sadarbojamies ar iestādēm to likumīgo pieprasījumu ietvaros, kas saistīti ar CSAE pārkāpumiem.",
    ),
    "termsConditionsSectionKidsSafetyTitle":
        MessageLookupByLibrary.simpleMessage(
          "7. Bērnu drošības un CSAE standarti",
        ),
    "termsConditionsSectionLiabilityDisputesContent":
        MessageLookupByLibrary.simpleMessage(
          "Lietotāji ir atbildīgi par savām vienošanām un mijiedarbību. Platforma sniedz starpniecības vidi, cik to atļauj tiesību akti.",
        ),
    "termsConditionsSectionLiabilityDisputesTitle":
        MessageLookupByLibrary.simpleMessage("6. Atbildība un strīdi"),
    "termsConditionsSectionMinimumAgeContent": MessageLookupByLibrary.simpleMessage(
      "Lietotne paredzēta personām no 16 gadu vecuma. Reģistrējoties, jūs apliecināt, ka jums ir vismaz 16 gadi.",
    ),
    "termsConditionsSectionMinimumAgeTitle":
        MessageLookupByLibrary.simpleMessage("Minimālais vecums"),
    "termsConditionsSectionProhibitedConductContent":
        MessageLookupByLibrary.simpleMessage(
          "Aizliegta krāpniecība, uzmākšanās, nelikumīgs saturs, citu lietotāju datu ļaunprātīga izmantošana un jebkāda pretlikumīga darbība.",
        ),
    "termsConditionsSectionProhibitedConductTitle":
        MessageLookupByLibrary.simpleMessage("4. Aizliegtā rīcība"),
    "termsConditionsSectionScopeContent": MessageLookupByLibrary.simpleMessage(
      "Šie noteikumi attiecas uz Bartering App lietošanu un nosaka lietotāja tiesības un pienākumus.",
    ),
    "termsConditionsSectionScopeTitle": MessageLookupByLibrary.simpleMessage(
      "1. Piemērošana",
    ),
    "termsConditionsTitle": MessageLookupByLibrary.simpleMessage(
      "Lietošanas noteikumi",
    ),
    "thankYouForFeedback": MessageLookupByLibrary.simpleMessage(
      "Paldies par atsauksmēm!",
    ),
    "today": MessageLookupByLibrary.simpleMessage("Šodien"),
    "tradeMatch": MessageLookupByLibrary.simpleMessage("Atbilstība"),
    "transactionBlocked": MessageLookupByLibrary.simpleMessage(
      "Transakcija bloķēta",
    ),
    "transactionBlockedMessage": MessageLookupByLibrary.simpleMessage(
      "Šī transakcija ir bloķēta aizdomīgu darbību modeļu dēļ. Lūdzu, sazinieties ar atbalsta dienestu, ja uzskatāt, ka tā ir kļūda.",
    ),
    "transactionCompleted": MessageLookupByLibrary.simpleMessage(
      "Transakcija atzīmēta kā pabeigta",
    ),
    "transactionCreated": MessageLookupByLibrary.simpleMessage(
      "Transakcija veiksmīgi izveidota",
    ),
    "transactionStatusCancelled": MessageLookupByLibrary.simpleMessage(
      "Atcelts",
    ),
    "transactionStatusNoDeal": MessageLookupByLibrary.simpleMessage(
      "Runāts, bet nav vienošanās",
    ),
    "transactionStatusScam": MessageLookupByLibrary.simpleMessage(
      "🚩 Ziņot par krāpšanu",
    ),
    "transactionStatusSuccessful": MessageLookupByLibrary.simpleMessage(
      "Veiksmīga maiņa",
    ),
    "transactionWillBeReviewed": MessageLookupByLibrary.simpleMessage(
      "Šo transakciju pārbaudīs mūsu drošības komanda.",
    ),
    "typeAMessage": MessageLookupByLibrary.simpleMessage(
      "Ierakstiet ziņojumu...",
    ),
    "unableToReviewUser": MessageLookupByLibrary.simpleMessage(
      "Šobrīd nav iespējams atsauksmēt šo lietotāju",
    ),
    "unableToShareAtThisTime": MessageLookupByLibrary.simpleMessage(
      "Šobrīd nevar dalīties",
    ),
    "unableToSubmitAppealNow": MessageLookupByLibrary.simpleMessage(
      "Pašlaik nevar iesniegt apelāciju",
    ),
    "unblock": MessageLookupByLibrary.simpleMessage("Atbloķēt"),
    "unblockUser": MessageLookupByLibrary.simpleMessage("Atbloķēt lietotāju"),
    "unblockUserConfirmation": MessageLookupByLibrary.simpleMessage(
      "Vai tiešām vēlaties atbloķēt šo lietotāju? Viņi varēs atkal ar jums sazināties.",
    ),
    "unblockUserConfirmationDetailed": m43,
    "unknownUser": MessageLookupByLibrary.simpleMessage("Nezināms lietotājs"),
    "unlockButton": MessageLookupByLibrary.simpleMessage("Atbloķēt"),
    "unviewed": MessageLookupByLibrary.simpleMessage("Neapskatīts"),
    "unviewedOnly": MessageLookupByLibrary.simpleMessage("Tikai neapskatītie"),
    "updateEmail": MessageLookupByLibrary.simpleMessage("Atjaunināt e-pastu"),
    "updatePhone": MessageLookupByLibrary.simpleMessage("Atjaunināt tālruni"),
    "updatePosting": MessageLookupByLibrary.simpleMessage(
      "Atjaunināt sludinājumu",
    ),
    "uploadingFile": MessageLookupByLibrary.simpleMessage(
      "Notiek faila augšupielāde...",
    ),
    "userBlocked": MessageLookupByLibrary.simpleMessage(
      "Lietotājs veiksmīgi bloķēts",
    ),
    "userDetails": MessageLookupByLibrary.simpleMessage(
      "Lietotāja informācija",
    ),
    "userId": MessageLookupByLibrary.simpleMessage("Lietotāja ID"),
    "userInterestedIn": MessageLookupByLibrary.simpleMessage("Interesē:"),
    "userLocation": MessageLookupByLibrary.simpleMessage("Atrašanās vieta:"),
    "userMatch": MessageLookupByLibrary.simpleMessage("Lietotāja atbilstība"),
    "userOffers": MessageLookupByLibrary.simpleMessage("Piedāvā:"),
    "userPrefix": MessageLookupByLibrary.simpleMessage("Lietotājs"),
    "userReported": MessageLookupByLibrary.simpleMessage(
      "Lietotājs veiksmīgi ziņots",
    ),
    "userUnblocked": MessageLookupByLibrary.simpleMessage(
      "Lietotājs veiksmīgi atbloķēts",
    ),
    "username": MessageLookupByLibrary.simpleMessage("Lietotājvārds"),
    "users": MessageLookupByLibrary.simpleMessage("Lietotāji"),
    "valuePrefix": MessageLookupByLibrary.simpleMessage("Vērtība"),
    "verified": MessageLookupByLibrary.simpleMessage("Verificēts"),
    "verifyAndRecover": MessageLookupByLibrary.simpleMessage(
      "Verificēt un atjaunot",
    ),
    "verifyAndResetPin": MessageLookupByLibrary.simpleMessage(
      "Verificēt un atiestatīt PIN",
    ),
    "viewMatches": MessageLookupByLibrary.simpleMessage("Skatīt atbilstības"),
    "viewProfile": MessageLookupByLibrary.simpleMessage("Skatīt profilu"),
    "weekly": MessageLookupByLibrary.simpleMessage("Iknedēļas"),
    "welcomeStep1Description": MessageLookupByLibrary.simpleMessage(
      "Izveidojiet anonīmu profilu ar savām interesēm un to, ko piedāvājat",
    ),
    "welcomeStep1Title": MessageLookupByLibrary.simpleMessage(
      "Izveidojiet savu profilu",
    ),
    "welcomeStep2Description": MessageLookupByLibrary.simpleMessage(
      "Atrodiet līdzīgus vai papildinošus cilvēkus, meklējiet pēc atslēgvārdiem",
    ),
    "welcomeStep2Title": MessageLookupByLibrary.simpleMessage(
      "Atklāj, meklē, publicē",
    ),
    "welcomeStep3Description": MessageLookupByLibrary.simpleMessage(
      "Savienojieties ar citiem, izmantojot pilnībā šifrētu tērzēšanu",
    ),
    "welcomeStep3Title": MessageLookupByLibrary.simpleMessage("Sāciet tērzēt"),
    "welcomeStep4Description": MessageLookupByLibrary.simpleMessage(
      "Mainiet zināšanas, pakalpojumus, priekšmetus vai vienkārši savienojieties ar savu kopienu",
    ),
    "welcomeStep4Title": MessageLookupByLibrary.simpleMessage(
      "Veiciet apmaiņas",
    ),
    "welcomeTagline": MessageLookupByLibrary.simpleMessage(
      "Savienojies. Mainies. Veido kopienu.",
    ),
    "whyReportingUser": MessageLookupByLibrary.simpleMessage(
      "Kāpēc jūs ziņojat par šo lietotāju?",
    ),
    "wishlist": MessageLookupByLibrary.simpleMessage("Vēlmju saraksts"),
    "wishlistItemCreated": MessageLookupByLibrary.simpleMessage(
      "Vēlmju saraksta vienums izveidots",
    ),
    "wishlistItemDeleted": MessageLookupByLibrary.simpleMessage(
      "Vēlmju saraksta vienums dzēsts",
    ),
    "wishlistItemDescription": MessageLookupByLibrary.simpleMessage("Apraksts"),
    "wishlistItemKeywords": MessageLookupByLibrary.simpleMessage(
      "Atslēgvārdi (atdalīti ar komatu)",
    ),
    "wishlistItemLocation": MessageLookupByLibrary.simpleMessage(
      "Atrašanās vieta",
    ),
    "wishlistItemMaxPrice": MessageLookupByLibrary.simpleMessage("Maks. cena"),
    "wishlistItemMinPrice": MessageLookupByLibrary.simpleMessage("Min. cena"),
    "wishlistItemNotifications": MessageLookupByLibrary.simpleMessage(
      "Ieslēgt paziņojumus",
    ),
    "wishlistItemPriceRange": MessageLookupByLibrary.simpleMessage(
      "Cenu diapazons",
    ),
    "wishlistItemRadius": MessageLookupByLibrary.simpleMessage(
      "Meklēšanas rādiuss (km)",
    ),
    "wishlistItemTitle": MessageLookupByLibrary.simpleMessage("Nosaukums"),
    "wishlistItemUpdated": MessageLookupByLibrary.simpleMessage(
      "Vēlmju saraksta vienums atjaunināts",
    ),
    "wishlistMatches": MessageLookupByLibrary.simpleMessage("Atbilstības"),
    "wishlistStatusActive": MessageLookupByLibrary.simpleMessage("Aktīvs"),
    "wishlistStatusArchived": MessageLookupByLibrary.simpleMessage("Arhivēts"),
    "wishlistStatusFulfilled": MessageLookupByLibrary.simpleMessage(
      "Izpildīts",
    ),
    "wishlistStatusPaused": MessageLookupByLibrary.simpleMessage("Apturēts"),
    "yesterday": MessageLookupByLibrary.simpleMessage("Vakar"),
    "yourAnswer": MessageLookupByLibrary.simpleMessage("Jūsu atbilde"),
    "yourMigrationCode": MessageLookupByLibrary.simpleMessage(
      "Jūsu pārcelšanas kods",
    ),
  };
}
