// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Latvian (`lv`).
class AppLocalizationsLv extends AppLocalizations {
  AppLocalizationsLv([String locale = 'lv']) : super(locale);

  @override
  String get appTitle => 'Bartera Lietotne';

  @override
  String get category_green =>
      'Daba, brīvdabas aktivitātes, dārzkopība, dzīvnieki, vide, pārgājieni, augi, ilgtspēja';

  @override
  String get category_red =>
      'Sports, fiziskās aktivitātes, aktīvs dzīvesstils, dejas, mehānismi, instrumenti, praktiski darbi';

  @override
  String get category_blue =>
      'Bizness, uzņēmējdarbība, algots darbs, kontaktu veidošana, naudas lietas, finanses, karjera';

  @override
  String get category_purple =>
      'Māksla, garīgums, filozofija, kultūra, mūzika, amatniecība, radošums, dizains, vēsture';

  @override
  String get category_yellow =>
      'Saruna, sabiedriskas aktivitātes, ikdienas sarunas, vietējie pasākumi, jauni kontakti, komunikācija';

  @override
  String get category_orange =>
      'Brīvprātīgais darbs, atbalsts, bezmaksas priekšmetu/prasmju apmaiņa, konsultācijas, palīdzība, kopiena';

  @override
  String get category_teal =>
      'Tehnoloģijas, mācīšanās, izglītība, inovācija, ideju ģenerēšana, zinātne, programmatūra';

  @override
  String get tapToChat => 'Pieskarieties, lai tērzētu';

  @override
  String get locations => 'Atrašanās vietas';

  @override
  String get tapToExpandMainCluster =>
      'Pieskarieties, lai izvērstu galveno grupu';

  @override
  String get closeLocations => 'Aizvērt atrašanās vietas';

  @override
  String get tapToExpandSubCluster => 'Pieskarieties, lai izvērstu apakšgrupu';

  @override
  String get pointsOfInterest => 'Interešu punkti';

  @override
  String get chat => 'Tērzēšana';

  @override
  String get typeAMessage => 'Ierakstiet ziņojumu...';

  @override
  String errorWithMessage(Object errorMessage) {
    return 'Kļūda: $errorMessage';
  }

  @override
  String get loading => 'Notiek ielāde...';

  @override
  String get errorDuringInitialization => 'Kļūda inicializācijas laikā.';

  @override
  String get selectYourInterests => 'Ko jūs meklējat/vajadzīgs?';

  @override
  String get selectYourOffers => 'Ko jums ir/piedāvājat?';

  @override
  String get userInterestedIn => 'Interesē:';

  @override
  String get userOffers => 'Piedāvā:';

  @override
  String get save => 'Saglabāt';

  @override
  String get username => 'Lietotājvārds';

  @override
  String get userId => 'Lietotāja ID';

  @override
  String get onboardingScreenTitle => 'Ievadapmācība';

  @override
  String get onboardingScreenQuestion => 'Cik ļoti jūs tas interesē?';

  @override
  String get finishOnboarding => 'Pabeigt';

  @override
  String questionsAnswered(Object count) {
    return '$count atbildēti jautājumi';
  }

  @override
  String get locationSaved => 'Atrašanās vieta saglabāta!';

  @override
  String get pleaseSelectLocationFirst =>
      'Lūdzu, vispirms izvēlieties atrašanās vietu.';

  @override
  String get locationNotFound => 'Atrašanās vieta nav atrasta.';

  @override
  String errorFindingLocation(Object error) {
    return 'Kļūda atrašanās vietas meklēšanā: $error';
  }

  @override
  String get selectLocation => 'Izvēlēties atrašanās vietu';

  @override
  String get pickYourLocation => 'Izvēlieties savu atrašanās vietu';

  @override
  String get searchForALocation => 'Meklēt atrašanās vietu';

  @override
  String get searchForAKeyword => 'Meklēt atslēgvārdu';

  @override
  String get saveLocation => 'Saglabāt atrašanās vietu';

  @override
  String get chatError_Offline => 'Lietotājs bezsaistē';

  @override
  String mockPoiNotFound(Object id) {
    return 'Testa POI ar id $id nav atrasts servisā';
  }

  @override
  String mockPoiNotFoundForUpdate(Object id) {
    return 'Testa POI ar id $id nav atrasts atjaunināšanai';
  }

  @override
  String get submitting => 'Notiek iesniegšana...';

  @override
  String get error => 'Kļūda';

  @override
  String get anUnknownErrorOccurred => 'Radās nezināma kļūda.';

  @override
  String get submittingOffers => 'Notiek piedāvājumu iesniegšana...';

  @override
  String get drawer_menu_similar_users => 'Atrast līdzīgus lietotājus';

  @override
  String get drawer_menu_complementary_users =>
      'Atrast papildinošus lietotājus';

  @override
  String get drawer_menu_favorite_users => 'Atrast iecienītākos lietotājus';

  @override
  String get settingsTitle => 'Iestatījumi';

  @override
  String get privacyPolicy => 'Privātuma politika';

  @override
  String get settingsSaved => 'Iestatījumi veiksmīgi saglabāti';

  @override
  String get settingsSearchSection => 'Meklēšanas iestatījumi';

  @override
  String get settingsSearchCenterPointTitle => 'Meklēšanas centrālais punkts';

  @override
  String get settingsSearchCenterPointDescription =>
      'Izvēlieties centrālo punktu lietotāju meklēšanai tuvumā';

  @override
  String get settingsSearchCenterUserLocation => 'Lietotāja atrašanās vieta';

  @override
  String get settingsSearchCenterUserLocationDescription =>
      'Meklēt no jūsu saglabātās atrašanās vietas';

  @override
  String get settingsSearchCenterMapCenter => 'Kartes centrs';

  @override
  String get settingsSearchCenterMapCenterDescription =>
      'Meklēt no pašreizējā kartes centra';

  @override
  String get settingsNearbyUsersRadiusTitle =>
      'Tuvumā esošo lietotāju meklēšanas rādiuss';

  @override
  String get settingsNearbyUsersRadiusDescription =>
      'Cik tālu meklēt lietotājus tuvumā';

  @override
  String get settingsKeywordSearchRadiusTitle =>
      'Atslēgvārdu meklēšanas rādiuss';

  @override
  String get settingsKeywordSearchRadiusDescription =>
      'Meklēšanas rādiuss, izmantojot atslēgvārdu meklēšanu';

  @override
  String get settingsKeywordSearchWeightTitle => 'Atslēgvārdu meklēšanas svars';

  @override
  String get settingsKeywordSearchWeightDescription =>
      'Svara parametrs atslēgvārdu meklēšanas atbilstībai (10-100)';

  @override
  String get settingsShowResultsAsListTitle =>
      'Rādīt meklēšanas rezultātus kā sarakstu';

  @override
  String get settingsShowResultsAsListDescription =>
      'Rādīt atslēgvārdu un tuvumā esošo lietotāju meklēšanas rezultātus saraksta skatā, nevis uz kartes';

  @override
  String get settingsShowResultsOnMapDescription =>
      'Rādīt meklēšanas rezultātus uz kartes (noklusējums)';

  @override
  String get settingsShowResultsAsListViewDescription =>
      'Rādīt meklēšanas rezultātus saraksta skatā';

  @override
  String get setPinTitle => 'Iestatīt PIN kodu';

  @override
  String get setPinDescription =>
      'Izveidojiet 4-6 ciparu PIN kodu, lai aizsargātu lietotni';

  @override
  String get setPinButton => 'Iestatīt PIN';

  @override
  String get skipPinButton => 'Pagaidām izlaist';

  @override
  String get pinLabel => 'PIN kods';

  @override
  String get pinHint => 'Ievadiet 4-6 ciparus';

  @override
  String get confirmPinLabel => 'Apstipriniet PIN kodu';

  @override
  String get pinErrorEmpty => 'Lūdzu, ievadiet PIN kodu';

  @override
  String get pinErrorTooShort => 'PIN kodam jābūt vismaz 4 cipariem';

  @override
  String get pinErrorMismatch => 'PIN kodi nesakrīt';

  @override
  String get pinSetSuccessfully => 'PIN kods veiksmīgi iestatīts';

  @override
  String get enterPinTitle => 'Ievadiet PIN kodu';

  @override
  String get enterPinDescription =>
      'Ievadiet savu PIN kodu, lai atbloķētu lietotni';

  @override
  String get unlockButton => 'Atbloķēt';

  @override
  String pinErrorIncorrect(int attempts) {
    return 'Nepareizs PIN kods (Mēģinājums $attempts)';
  }

  @override
  String get settingsSecuritySection => 'Drošība';

  @override
  String get settingsPinTitle => 'PIN aizsardzība';

  @override
  String get settingsPinEnabledDescription =>
      'Lietotne ir aizsargāta ar PIN kodu';

  @override
  String get settingsPinDisabledDescription =>
      'Ieslēgt PIN kodu papildu drošībai';

  @override
  String get settingsChangePinButton => 'Mainīt PIN kodu';

  @override
  String get settingsChangePinDescription => 'Atjaunināt drošības PIN kodu';

  @override
  String get settingsLanguageSection => 'Valoda';

  @override
  String get settingsLanguageTitle => 'Lietotnes valoda';

  @override
  String get settingsLanguageDescription =>
      'Izvēlieties vēlamo lietotnes valodu';

  @override
  String get settingsLanguageRestartMessage =>
      'Lūdzu, restartējiet lietotni, lai lietotu valodas izmaiņas';

  @override
  String get setupSecurityQuestion => 'Iestatīt drošības jautājumu';

  @override
  String get securityQuestionDescription =>
      'Iestatiet drošības jautājumu, lai palīdzētu atgūt PIN kodu, ja to aizmirstat';

  @override
  String get selectSecurityQuestion => 'Izvēlieties jautājumu';

  @override
  String get yourAnswer => 'Jūsu atbilde';

  @override
  String get answerHint => 'Ievadiet savu atbildi';

  @override
  String get pleaseSelectQuestion => 'Lūdzu, izvēlieties drošības jautājumu';

  @override
  String get pleaseEnterAnswer => 'Lūdzu, ievadiet savu atbildi';

  @override
  String get answerTooShort => 'Atbildei jābūt vismaz 2 rakstzīmēm';

  @override
  String get securityAnswerNote => 'Piezīme: Atbildes nav reģistrjutīgas';

  @override
  String get saveSecurityQuestion => 'Saglabāt drošības jautājumu';

  @override
  String get securityQuestionSaved => 'Drošības jautājums veiksmīgi saglabāts';

  @override
  String get securityQuestion1 => 'Kā sauca jūsu pirmo mājdzīvnieku?';

  @override
  String get securityQuestion2 => 'Kurā pilsētā jūs piedzimat?';

  @override
  String get securityQuestion3 => 'Kāds ir jūsu mātes uzvārds pirms laulības?';

  @override
  String get securityQuestion4 => 'Kā sauca jūsu pamatskolu?';

  @override
  String get securityQuestion5 => 'Kāda ir jūsu iecienītākā grāmata?';

  @override
  String get answerSecurityQuestion => 'Atbildēt uz drošības jautājumu';

  @override
  String get enterYourAnswer => 'Ievadiet savu atbildi';

  @override
  String get verifyAndResetPin => 'Verificēt un atiestatīt PIN';

  @override
  String securityAnswerIncorrect(int attempts) {
    return 'Nepareiza atbilde (Mēģinājums $attempts)';
  }

  @override
  String get pinResetSuccessfully => 'PIN kods veiksmīgi atiestatīts';

  @override
  String get noSecurityQuestionSet => 'Nav iestatīts drošības jautājums';

  @override
  String get contactSupportForPinReset =>
      'Lūdzu, sazinieties ar atbalstu PIN koda atiestatīšanas palīdzībai';

  @override
  String get manageSecurityQuestion => 'Pārvaldīt drošības jautājumu';

  @override
  String get securityQuestionSet => 'Drošības jautājums ir iestatīts';

  @override
  String get noSecurityQuestion => 'Nav konfigurēts drošības jautājums';

  @override
  String get setupSecurityQuestionButton => 'Iestatīt drošības jautājumu';

  @override
  String get changeSecurityQuestion => 'Mainīt drošības jautājumu';

  @override
  String get managePostings => 'Pārvaldīt sludinājumus';

  @override
  String get noActivePostings => 'Nav aktīvu sludinājumu';

  @override
  String get deletePosting => 'Dzēst sludinājumu';

  @override
  String get deletePostingConfirmation =>
      'Vai tiešām vēlaties dzēst šo sludinājumu?';

  @override
  String get postingDeleted => 'Sludinājums veiksmīgi dzēsts';

  @override
  String get offer => 'Piedāvājums';

  @override
  String get need => 'Vajadzība';

  @override
  String get expires => 'Derīgs līdz';

  @override
  String get editPosting => 'Rediģēt sludinājumu';

  @override
  String get postingUpdatedSuccess => 'Sludinājums veiksmīgi atjaunināts';

  @override
  String get updatePosting => 'Atjaunināt sludinājumu';

  @override
  String get continueButton => 'Turpināt';

  @override
  String get categoryNatureTitle => 'Daba un brīvdabas';

  @override
  String get categoryNatureDescription =>
      'Dārzkopība, brīvdabas, meži, kempings, vides aizsardzība, uzkopšana, dzīvnieki';

  @override
  String get categoryActiveTitle => 'Aktīvs un sabiedrisks';

  @override
  String get categoryActiveDescription =>
      'Sports, aktivitātes, dejas, skriešana, fizisk darbs, mehānismi';

  @override
  String get categoryBusinessTitle => 'Bizness un finanses';

  @override
  String get categoryBusinessDescription =>
      'Tikai bizness, algots darbs, tīklošanās, naudas lietas';

  @override
  String get categoryArtsTitle => 'Māksla un filozofija';

  @override
  String get categoryArtsDescription => 'Māksla, garīgums, filozofija';

  @override
  String get categoryCommTitle => 'Komunikācija un tērzēšana';

  @override
  String get categoryCommDescription => 'Dažādi/Komunikācija, Tērzēšana';

  @override
  String get categoryCommunityTitle => 'Kopiena un brīvprātīgais darbs';

  @override
  String get categoryCommunityDescription =>
      'Gatavs palīdzēt bez maksas/nespecifisku apmaiņu';

  @override
  String get categoryTechTitle => 'Tehnoloģijas un mācīšanās';

  @override
  String get categoryTechDescription => 'Tehnoloģijas, mācīšanās, inovācija';

  @override
  String get addYourOwnKeywords => 'Pievienojiet savus atslēgvārdus';

  @override
  String get enterYourPin => 'Ievadiet savu PIN kodu';

  @override
  String get pinSetupDescription =>
      'Lūdzu, iestatiet 5 ciparu PIN kodu drošībai';

  @override
  String get forgotPin => 'Aizmirsi PIN kodu?';

  @override
  String get pinResetSuccess => 'Jūsu PIN kods ir veiksmīgi atiestatīts.';

  @override
  String get resetYourPin => 'Atiestatīt PIN kodu';

  @override
  String get enterNewPinDescription => 'Ievadiet jaunu 5 ciparu PIN kodu';

  @override
  String get googleSignInNotImplemented =>
      'Google pierakstīšanās nav ieviesta.';

  @override
  String get pleaseEnterValidEmail => 'Lūdzu, ievadiet derīgu e-pasta adresi.';

  @override
  String get pleaseEnter5DigitPin => 'Lūdzu, ievadiet 5 ciparu PIN kodu.';

  @override
  String get accountSetupSuccess => 'Jūsu konts ir iestatīts!';

  @override
  String get setUpAccount => 'Iestatīt kontu';

  @override
  String get or => 'VAI';

  @override
  String get emailAddress => 'E-pasta adrese';

  @override
  String get create5DigitPin => 'Izveidojiet 5 ciparu PIN kodu';

  @override
  String get completeSetup => 'Pabeigt iestatīšanu';

  @override
  String get resetLinkSentMessage =>
      'Ja konts eksistē, atiestatīšanas saite ir nosūtīta.';

  @override
  String get forgotPinSubtitle =>
      'Ievadiet savu e-pasta adresi, lai saņemtu PIN koda atiestatīšanas saiti.';

  @override
  String get pleaseEnterValidEmailAddress =>
      'Lūdzu, ievadiet derīgu e-pasta adresi';

  @override
  String get sendResetLink => 'Nosūtīt atiestatīšanas saiti';

  @override
  String get generateAvatar => 'Ģenerēt avatāru';

  @override
  String get skin => 'Āda';

  @override
  String get hairStyle => 'Matu stils';

  @override
  String get hairColor => 'Matu krāsa';

  @override
  String get eyes => 'Acis';

  @override
  String get nose => 'Deguns';

  @override
  String get mouth => 'Mute';

  @override
  String styleNumber(Object number) {
    return 'Stils $number';
  }

  @override
  String get randomize => 'Nejauši';

  @override
  String get saveAndContinue => 'Saglabāt un turpināt';

  @override
  String get copiedToClipboard => 'Nokopēts starpliktuvē';

  @override
  String get generateCryptoWallet => 'Ģenerēt kriptomaciņu';

  @override
  String get generateWallet => 'Ģenerēt maciņu';

  @override
  String get publicKey => 'Publiskā atslēga';

  @override
  String get privateKey => 'Privātā atslēga';

  @override
  String get done => 'Gatavs';

  @override
  String get attr_3d_printing => '3D drukāšana';

  @override
  String get attr_artificial_intelligence => 'Mākslīgais intelekts';

  @override
  String get attr_acting => 'Aktierspēle';

  @override
  String get attr_amateur_radio => 'Amatierradio';

  @override
  String get attr_animation => 'Animācija';

  @override
  String get attr_baking => 'Cepšana';

  @override
  String get attr_beekeeping => 'Biškopība';

  @override
  String get attr_blogging => 'Blogošana';

  @override
  String get attr_board_games => 'Galda spēles';

  @override
  String get attr_books => 'Grāmatas';

  @override
  String get attr_bowling => 'Boulings';

  @override
  String get attr_breadmaking => 'Maizes cepšana';

  @override
  String get attr_construction => 'Celtniecība';

  @override
  String get attr_candle_making => 'Sveču darināšana';

  @override
  String get attr_car_maintenance => 'Auto apkope';

  @override
  String get attr_card_games => 'Kāršu spēles';

  @override
  String get attr_ceramics => 'Keramika';

  @override
  String get attr_charity_work => 'Labdarības darbs';

  @override
  String get attr_chess => 'Šahs';

  @override
  String get attr_cleaning => 'Tīrīšana';

  @override
  String get attr_clothesmaking => 'Apģērbu šūšana';

  @override
  String get attr_coffee => 'Kafija';

  @override
  String get attr_software_development => 'Programmatūras izstrāde';

  @override
  String get attr_cooking => 'Gatavošana';

  @override
  String get attr_couponing => 'Kuponu izmantošana';

  @override
  String get attr_creative_writing => 'Radošā rakstīšana';

  @override
  String get attr_crocheting => 'Adīšana ar āķi';

  @override
  String get attr_cross_stitch => 'Krustaduriena';

  @override
  String get attr_dance => 'Dejas';

  @override
  String get attr_digital_arts => 'Digitālā māksla';

  @override
  String get attr_djing => 'DJ darbs';

  @override
  String get attr_diy => 'Dari pats';

  @override
  String get attr_drawing => 'Zīmēšana';

  @override
  String get attr_electronics => 'Elektronika';

  @override
  String get attr_embroidery => 'Izšuvums';

  @override
  String get attr_engraving => 'Gravēšana';

  @override
  String get attr_event_hosting => 'Pasākumu organizēšana';

  @override
  String get attr_fashion => 'Mode';

  @override
  String get attr_fashion_design => 'Modes dizains';

  @override
  String get attr_flower_arranging => 'Ziedu kompozīcijas';

  @override
  String get attr_furniture_building => 'Mēbeļu būvniecība';

  @override
  String get attr_gaming => 'Spēles';

  @override
  String get attr_genealogy => 'Ģenealoģija';

  @override
  String get attr_graphic_design => 'Grafiskais dizains';

  @override
  String get attr_hacking => 'Hakings';

  @override
  String get attr_herp_keeping => 'Rāpuļu audzēšana';

  @override
  String get attr_home_improvement => 'Mājas uzlabošana';

  @override
  String get attr_homebrewing => 'Alus darīšana mājās';

  @override
  String get attr_houseplant_care => 'Istabas augu kopšana';

  @override
  String get attr_hydroponics => 'Hidroponika';

  @override
  String get attr_jewelry => 'Juvelierizstrādājumi';

  @override
  String get attr_knitting => 'Adīšana';

  @override
  String get attr_kombucha => 'Kombuča';

  @override
  String get attr_leather_crafting => 'Ādas apstrāde';

  @override
  String get attr_podcasts => 'Podkāsti';

  @override
  String get attr_machining => 'Metālveidošana';

  @override
  String get attr_magic => 'Burvība';

  @override
  String get attr_makeup => 'Grims';

  @override
  String get attr_massage => 'Masāža';

  @override
  String get attr_metalworking => 'Metāla apstrāde';

  @override
  String get attr_nail_art => 'Nagu dizains';

  @override
  String get attr_painting => 'Gleznošana';

  @override
  String get attr_photography => 'Fotogrāfija';

  @override
  String get attr_pottery => 'Podnieku māksla';

  @override
  String get attr_powerlifting => 'Spēka sports';

  @override
  String get attr_puzzles => 'Mīklas';

  @override
  String get attr_quilting => 'Segas šūšana';

  @override
  String get attr_gadgets => 'Ierīces';

  @override
  String get attr_robotics => 'Robotika';

  @override
  String get attr_sculpting => 'Tēlniecība';

  @override
  String get attr_sewing => 'Šūšana';

  @override
  String get attr_shoemaking => 'Kurpnieku darbs';

  @override
  String get attr_singing => 'Dziedāšana';

  @override
  String get attr_skateboarding => 'Skrituļošana';

  @override
  String get attr_sketching => 'Skicēšana';

  @override
  String get attr_soapmaking => 'Ziepju darināšana';

  @override
  String get attr_social_media => 'Sociālie mediji';

  @override
  String get attr_stand_up_comedy => 'Stendup komēdija';

  @override
  String get attr_storytelling => 'Stāstu stāstīšana';

  @override
  String get attr_sudoku => 'Sudoku';

  @override
  String get attr_table_tennis => 'Galda teniss';

  @override
  String get attr_thrifting => 'Lietotu lietu iepirkšanās';

  @override
  String get attr_video_editing => 'Video rediģēšana';

  @override
  String get attr_video_game_developing => 'Videospēļu izstrāde';

  @override
  String get attr_weaving => 'Aušana';

  @override
  String get attr_weight_training => 'Svarcelšana';

  @override
  String get attr_welding => 'Metināšana';

  @override
  String get attr_wood_carving => 'Koka griešana';

  @override
  String get attr_woodworking => 'Galdniecība';

  @override
  String get attr_writing => 'Rakstīšana';

  @override
  String get attr_yoga => 'Joga';

  @override
  String get attr_zumba => 'Zumba';

  @override
  String get attr_hiking => 'Pārgājieni';

  @override
  String get attr_reading => 'Lasīšana';

  @override
  String get attr_gardening => 'Dārzkopība';

  @override
  String get attr_music => 'Mūzika';

  @override
  String get attr_dancing => 'Dejas';

  @override
  String get attr_aerobics => 'Aerobika';

  @override
  String get attr_traveling => 'Ceļošana';

  @override
  String get attr_coding => 'Programmēšana';

  @override
  String get attr_sports => 'Sports';

  @override
  String get attr_movies => 'Filmas';

  @override
  String get attr_volunteering => 'Brīvprātīgais darbs';

  @override
  String get attr_meditation => 'Meditācija';

  @override
  String get attr_crafting => 'Amatniecība';

  @override
  String get attr_astronomy => 'Astronomija';

  @override
  String get attr_backpacking => 'Backpacking';

  @override
  String get attr_bird_watching => 'Putnu vērošana';

  @override
  String get attr_camping => 'Kempings';

  @override
  String get attr_canyoning => 'Kanjonu tūrisms';

  @override
  String get attr_car_restoration => 'Auto restaurācija';

  @override
  String get attr_climbing => 'Kāpšana';

  @override
  String get attr_cryptocurrency => 'Kriptovalūta';

  @override
  String get attr_culinary_arts => 'Kulinārijas māksla';

  @override
  String get attr_cycling => 'Riteņbraukšana';

  @override
  String get attr_drones => 'Droni';

  @override
  String get attr_fermentation => 'Fermentācija';

  @override
  String get attr_film_making => 'Filmu veidošana';

  @override
  String get attr_financial_investing => 'Finanšu investīcijas';

  @override
  String get attr_fishing => 'Makšķerēšana';

  @override
  String get attr_foraging => 'Pārtikas meklēšana dabā';

  @override
  String get attr_geocaching => 'Ģeoslēpšana';

  @override
  String get attr_kayaking => 'Airēšana ar kajaku';

  @override
  String get attr_martial_arts => 'Cīņas mākslas';

  @override
  String get attr_mindfulness => 'Apzinātība';

  @override
  String get attr_mushroom_hunting => 'Sēņošana';

  @override
  String get attr_personal_finance => 'Personīgās finanses';

  @override
  String get attr_rock_climbing => 'Klinšu kāpšana';

  @override
  String get attr_running => 'Skriešana';

  @override
  String get attr_sustainable_living => 'Ilgtspējīga dzīvesveida';

  @override
  String get attr_urban_exploration => 'Urbānā pētīšana';

  @override
  String get attr_alternative_medicine => 'Alternatīvā medicīna';

  @override
  String get attr_biohacking => 'Biohakings';

  @override
  String get attr_cold_plunging => 'Aukstā ūdens vannošana';

  @override
  String get attr_community_gardening => 'Kopienas dārzkopība';

  @override
  String get attr_cybersecurity => 'Kiberdrošība';

  @override
  String get attr_day_trading => 'Dienas tirdzniecība';

  @override
  String get attr_deep_cleaning => 'Dziļā tīrīšana';

  @override
  String get attr_digital_nomadism => 'Digitālais nomādisms';

  @override
  String get attr_recipes => 'Receptes';

  @override
  String get attr_bodybuilding => 'Bodibildings';

  @override
  String get attr_memes => 'Mēmi';

  @override
  String get attr_metal_detecting => 'Metāla meklēšana';

  @override
  String get attr_minimalism => 'Minimālisms';

  @override
  String get attr_pet_grooming => 'Mājdzīvnieku kopšana';

  @override
  String get attr_podcasting => 'Podkāstu veidošana';

  @override
  String get attr_record_collecting => 'Ierakstu kolekcionēšana';

  @override
  String get attr_tiny_homes => 'Mazās mājas';

  @override
  String get attr_upcycling => 'Pārstrāde';

  @override
  String get attr_virtual_reality => 'Virtuālā realitāte';

  @override
  String get attr_pc_building => 'Datoru būvēšana';

  @override
  String get attr_babysitting => 'Bērnu pieskatīšana';

  @override
  String get attr_backgammon => 'Nardi';

  @override
  String get attr_bicycles => 'Velosipēdi';

  @override
  String get attr_billiards => 'Biljards';

  @override
  String get attr_canned_goods => 'Konservēti produkti';

  @override
  String get attr_car_detailing => 'Auto detalizēta tīrīšana';

  @override
  String get attr_carpentry => 'Namdaru darbi';

  @override
  String get attr_code_review => 'Koda pārskats';

  @override
  String get attr_comic_books => 'Komiksi';

  @override
  String get attr_computer_hardware => 'Datoru aparatūra';

  @override
  String get attr_computer_repair => 'Datoru remonts';

  @override
  String get attr_concert_tickets => 'Koncerta biļetes';

  @override
  String get attr_co_op_gaming => 'Kooperatīvas spēles';

  @override
  String get attr_creative_brainstorming => 'Radoša ideju ģenerēšana';

  @override
  String get attr_dance_lessons => 'Deju nodarbības';

  @override
  String get attr_dog_walking => 'Suņu pastaigas';

  @override
  String get attr_elderly_care => 'Gados vecu cilvēku aprūpe';

  @override
  String get attr_electronic_components => 'Elektronikas komponentes';

  @override
  String get attr_exercise_partner => 'Treniņu partneris';

  @override
  String get attr_firewood => 'Malka';

  @override
  String get attr_fitness_coaching => 'Fitnesa trenēšana';

  @override
  String get attr_fresh_eggs => 'Svaigas olas';

  @override
  String get attr_furniture_repair => 'Mēbeļu remonts';

  @override
  String get attr_gardening_advice => 'Dārzkopības padomi';

  @override
  String get attr_graphic_novels => 'Grafiskas noveles';

  @override
  String get attr_guitar => 'Ģitāra';

  @override
  String get attr_handmade => 'Roku darbs';

  @override
  String get attr_handyman_services => 'Meistar pakalpojumi';

  @override
  String get attr_hauling_services => 'Transporta pakalpojumi';

  @override
  String get attr_herbal_remedies => 'Zāļu līdzekļi';

  @override
  String get attr_horseback_riding => 'Jāšana';

  @override
  String get attr_interview_practice => 'Intervijas prakse';

  @override
  String get attr_language_exchange => 'Valodu apmaiņa';

  @override
  String get attr_lawn_mowing => 'Zāliena pļaušana';

  @override
  String get attr_local_tours => 'Vietējās ekskursijas';

  @override
  String get attr_math_tutoring => 'Matemātikas mācīšana';

  @override
  String get attr_mentorship => 'Mentorings';

  @override
  String get attr_motorcycles => 'Motocikli';

  @override
  String get attr_moving_help => 'Pārcelšanās palīdzība';

  @override
  String get attr_musical_instruments => 'Mūzikas instrumenti';

  @override
  String get attr_pair_programming => 'Pāra programmēšana';

  @override
  String get attr_pet_sitting => 'Mājdzīvnieku pieskatīšana';

  @override
  String get attr_photo_restoration => 'Foto restaurācija';

  @override
  String get attr_piano_lessons => 'Klavieru nodarbības';

  @override
  String get attr_plant_cuttings => 'Augu spraudeņi';

  @override
  String get attr_proofreading => 'Korektūra';

  @override
  String get attr_resume_writing => 'CV rakstīšana';

  @override
  String get attr_rpg_games => 'RPG spēles';

  @override
  String get attr_scrap_metal => 'Lūžņu metāls';

  @override
  String get attr_event_tickets => 'Pasākumu biļetes';

  @override
  String get attr_sports_coaching => 'Sporta trenēšana';

  @override
  String get attr_study_partner => 'Studiju partneris';

  @override
  String get attr_technical_writing => 'Tehniskā rakstīšana';

  @override
  String get attr_tennis => 'Teniss';

  @override
  String get attr_tool_lending => 'Instrumentu aizdošana';

  @override
  String get attr_translation_services => 'Tulkošanas pakalpojumi';

  @override
  String get attr_used_books => 'Lietotas grāmatas';

  @override
  String get attr_used_electronics => 'Lietota elektronika';

  @override
  String get attr_used_furniture => 'Lietotas mēbeles';

  @override
  String get attr_vehicle_repair => 'Transportlīdzekļu remonts';

  @override
  String get attr_video_game_consoles => 'Videospēļu konsoles';

  @override
  String get attr_vintage_clothing => 'Vintage apģērbs';

  @override
  String get attr_voice_lessons => 'Vokālās nodarbības';

  @override
  String get attr_ux_design => 'UX dizains';

  @override
  String get attr_window_cleaning => 'Logu tīrīšana';

  @override
  String get attr_yard_work => 'Pagalma darbi';

  @override
  String get attr_drumming => 'Bungu spēle';

  @override
  String get attr_vocals => 'Vokāls';

  @override
  String get attr_permaculture => 'Permakultūra';

  @override
  String get attr_physical_work => 'Fizisks darbs';

  @override
  String get attr_business_mentorship => 'Biznesa mentorings';

  @override
  String get attr_spirituality => 'Garīgums';

  @override
  String get attr_natural_remedies => 'Dabīgie līdzekļi';

  @override
  String get attr_retreats => 'Retreats';

  @override
  String get attr_zen => 'Zen';

  @override
  String get attr_linux => 'Linux';

  @override
  String get attr_app_development => 'Lietotņu izstrāde';

  @override
  String get attr_android => 'Android';

  @override
  String get attr_ios => 'iOS';

  @override
  String get attr_backend_development => 'Backend izstrāde';

  @override
  String get attr_plumbing => 'Santehnika';

  @override
  String get attr_art_exhibitions => 'Mākslas izstādes';

  @override
  String get attr_environmentalism => 'Vides aizsardzība';

  @override
  String get attr_fresh_vegetables => 'Svaigas dārzeņi';

  @override
  String get attr_fresh_fruits => 'Svaigas augļi';

  @override
  String get attr_fresh_herbs => 'Svaigas garšaugi';

  @override
  String get attr_tea => 'Tēja';

  @override
  String get attr_legal_advice => 'Juridiskie padomi';

  @override
  String get attr_cats => 'Kaķi';

  @override
  String get attr_dogs => 'Suņi';

  @override
  String get attr_poker => 'Pokers';

  @override
  String get attr_trees => 'Koki';

  @override
  String get attr_plants => 'Augi';

  @override
  String get attr_farm_animals => 'Lauksaimniecības dzīvnieki';

  @override
  String get attr_organic_food => 'Bioloģiskā pārtika';

  @override
  String get attr_technician => 'Tehniķis';

  @override
  String get attr_tractor => 'Traktors';

  @override
  String get attr_driving => 'Vadīšana';

  @override
  String get attr_machinery_operation => 'Mašīnu vadīšana';

  @override
  String get attr_truck_driving => 'Kravas auto vadīšana';

  @override
  String get attr_assembly => 'Montāža';

  @override
  String get attr_animal_care => 'Dzīvnieku aprūpe';

  @override
  String get attr_horses => 'Zirgi';

  @override
  String get attr_goats => 'Kazas';

  @override
  String get attr_cows => 'Govis';

  @override
  String get attr_self_sufficiency => 'Pašpietiekamība';

  @override
  String get attr_ridesharing => 'Braucienu koplietošana';

  @override
  String get attr_fruit_harvesting => 'Augļu novākšana';

  @override
  String get attr_vegetable_harvesting => 'Dārzeņu novākšana';

  @override
  String get attr_car_cleaning => 'Auto tīrīšana';

  @override
  String get attr_farmstay => 'Uzturēšanās lauku sētā';

  @override
  String get attr_house_maintenance => 'Mājas apkope';

  @override
  String get attr_shepherding => 'Ganu darbs';

  @override
  String get attr_renovation => 'Renovācija';

  @override
  String get attr_landscaping => 'Ainavu dizains';

  @override
  String get attr_forestry => 'Mežsaimniecība';

  @override
  String get attr_academic_tutoring => 'Akadēmiskā mācīšana';

  @override
  String get attr_building_materials => 'Celtniecības materiāli';

  @override
  String get attr_spare_parts => 'Rezerves daļas';

  @override
  String get attr_alternative_healing => 'Alternatīvā dziedināšana';

  @override
  String get attr_socializing => 'Socializēšanās';

  @override
  String get userLocation => 'Atrašanās vieta:';

  @override
  String get editLocation => 'Rediģēt atrašanās vietu';

  @override
  String get editKeywords => 'Rediģēt savas vispārējās intereses';

  @override
  String get createOfferPosting => 'Izveidot piedāvājuma sludinājumu';

  @override
  String get createInterestPosting => 'Izveidot intereses sludinājumu';

  @override
  String get postingTitle => 'Nosaukums';

  @override
  String get postingTitleHint => 'Īss sludinājuma nosaukums';

  @override
  String get postingTitleRequired => 'Nosaukums ir obligāts';

  @override
  String get postingTitleTooShort => 'Nosaukumam jābūt vismaz 3 rakstzīmēm';

  @override
  String get postingDescription => 'Apraksts';

  @override
  String get postingDescriptionHint =>
      'Detalizēts apraksts par to, ko piedāvājat vai meklējat';

  @override
  String get postingDescriptionRequired => 'Apraksts ir obligāts';

  @override
  String get postingDescriptionTooShort =>
      'Aprakstam jābūt vismaz 10 rakstzīmēm';

  @override
  String get postingValue => 'Vērtība (Neobligāti)';

  @override
  String get postingValueHint => 'Aptuvena vērtība';

  @override
  String get postingValueInvalid => 'Lūdzu, ievadiet derīgu pozitīvu skaitli';

  @override
  String get optionalField => 'Neobligāti';

  @override
  String get expirationDate => 'Derīguma termiņš';

  @override
  String get tapToSelectDate =>
      'Pieskarieties, lai izvēlētos derīguma termiņu (neobligāti)';

  @override
  String get postingImages => 'Attēli';

  @override
  String get postingImagesHint => 'Pievienojiet līdz 3 attēliem (neobligāti)';

  @override
  String get addImage => 'Pievienot attēlu';

  @override
  String get takePhoto => 'Uzņemt fotogrāfiju';

  @override
  String get chooseFromGallery => 'Izvēlēties no galerijas';

  @override
  String get maxImagesReached => 'Maksimums 3 attēli atļauti';

  @override
  String get createPosting => 'Izveidot sludinājumu';

  @override
  String get postingCreatedSuccess => 'Sludinājums veiksmīgi izveidots!';

  @override
  String get addNewPosting => 'Pievienot sludinājumu';

  @override
  String get deleteConversation => 'Dzēst sarunu';

  @override
  String get deleteConversationConfirmation =>
      'Vai tiešām vēlaties dzēst šo sarunu? Visi ziņojumi tiks neatgriezeniski noņemti.';

  @override
  String get conversationDeleted => 'Saruna dzēsta';

  @override
  String get cancel => 'Atcelt';

  @override
  String get delete => 'Dzēst';

  @override
  String get errorLoadingChats => 'Kļūda sarunu ielādē';

  @override
  String get couldNotFindChatParticipant =>
      'Neizdevās atrast sarunas dalībnieku';

  @override
  String get errorDeletingConversation => 'Kļūda sarunas dzēšanā';

  @override
  String get unknownUser => 'Nezināms lietotājs';

  @override
  String get noMessagesYet => 'Vēl nav ziņojumu';

  @override
  String get ninetyNinePlus => '99+';

  @override
  String get userPrefix => 'Lietotājs';

  @override
  String get yesterday => 'Vakar';

  @override
  String get notSet => 'Nav iestatīts';

  @override
  String get errorUpdatingFavorite => 'Kļūda iecienītā atjaunināšanā';

  @override
  String get noAttributesToDisplay => 'Nav atribūtu, ko parādīt.';

  @override
  String get errorLoadingPostings => 'Kļūda sludinājumu ielādē';

  @override
  String get errorLoadingAttributes => 'Kļūda atribūtu ielādē';

  @override
  String get activePostings => 'Aktīvie sludinājumi';

  @override
  String get posting => 'sludinājums';

  @override
  String get postings => 'sludinājumi';

  @override
  String get offers => 'Piedāvājumi';

  @override
  String get lookingFor => 'Meklē';

  @override
  String get valuePrefix => 'Vērtība';

  @override
  String get expiresPrefix => 'Derīgs līdz';

  @override
  String get postedPrefix => 'Publicēts';

  @override
  String get noChatsYet => 'Vēl nav sarunu';

  @override
  String get startConversationFromMap => 'Sāciet sarunu no kartes';

  @override
  String get welcomeTagline => 'Savienojies. Mainies. Veido kopienu.';

  @override
  String get getStarted => 'Sākt';

  @override
  String get howItWorks => 'Kā tas darbojas';

  @override
  String get welcomeStep1Title => 'Izveidojiet savu profilu';

  @override
  String get welcomeStep1Description =>
      'Izveidojiet anonīmu profilu ar savām interesēm un to, ko piedāvājat';

  @override
  String get welcomeStep2Title => 'Atklāj, meklē, publicē';

  @override
  String get welcomeStep2Description =>
      'Atrodiet līdzīgus vai papildinošus cilvēkus, meklējiet pēc atslēgvārdiem';

  @override
  String get welcomeStep3Title => 'Sāciet tērzēt';

  @override
  String get welcomeStep3Description =>
      'Savienojieties ar citiem, izmantojot pilnībā šifrētu tērzēšanu';

  @override
  String get welcomeStep4Title => 'Veiciet apmaiņas';

  @override
  String get welcomeStep4Description =>
      'Mainiet prasmes, pakalpojumus, priekšmetus vai vienkārši savienojieties ar savu kopienu';

  @override
  String get wishlist => 'Vēlmju saraksts';

  @override
  String get myWishlist => 'Mans vēlmju saraksts';

  @override
  String get addWishlistItem => 'Pievienot vēlmju saraksta vienumu';

  @override
  String get editWishlistItem => 'Rediģēt vēlmju saraksta vienumu';

  @override
  String get wishlistItemTitle => 'Nosaukums';

  @override
  String get wishlistItemDescription => 'Apraksts';

  @override
  String get wishlistItemKeywords => 'Atslēgvārdi (atdalīti ar komatu)';

  @override
  String get wishlistItemPriceRange => 'Cenu diapazons';

  @override
  String get wishlistItemMinPrice => 'Min. cena';

  @override
  String get wishlistItemMaxPrice => 'Maks. cena';

  @override
  String get wishlistItemLocation => 'Atrašanās vieta';

  @override
  String get wishlistItemRadius => 'Meklēšanas rādiuss (km)';

  @override
  String get wishlistItemNotifications => 'Ieslēgt paziņojumus';

  @override
  String get noWishlistItems => 'Vēl nav vēlmju saraksta vienumu';

  @override
  String get createYourFirstWishlistItem =>
      'Izveidojiet savu pirmo vēlmju saraksta vienumu, lai saņemtu paziņojumus, kad parādās atbilstības';

  @override
  String get deleteWishlistItem => 'Dzēst vēlmju saraksta vienumu';

  @override
  String get deleteWishlistItemConfirmation =>
      'Vai tiešām vēlaties dzēst šo vēlmju saraksta vienumu?';

  @override
  String get wishlistItemDeleted => 'Vēlmju saraksta vienums dzēsts';

  @override
  String get errorDeletingWishlistItem =>
      'Kļūda vēlmju saraksta vienuma dzēšanā';

  @override
  String get wishlistItemCreated => 'Vēlmju saraksta vienums izveidots';

  @override
  String get wishlistItemUpdated => 'Vēlmju saraksta vienums atjaunināts';

  @override
  String get errorCreatingWishlistItem =>
      'Kļūda vēlmju saraksta vienuma izveidē';

  @override
  String get errorUpdatingWishlistItem =>
      'Kļūda vēlmju saraksta vienuma atjaunināšanā';

  @override
  String get errorLoadingWishlist => 'Kļūda vēlmju saraksta ielādē';

  @override
  String get wishlistStatusActive => 'Aktīvs';

  @override
  String get wishlistStatusPaused => 'Apturēts';

  @override
  String get wishlistStatusFulfilled => 'Izpildīts';

  @override
  String get wishlistStatusArchived => 'Arhivēts';

  @override
  String get wishlistMatches => 'Atbilstības';

  @override
  String get noMatchesYet => 'Vēl nav atbilstību';

  @override
  String get matchScore => 'Atbilstības rādītājs';

  @override
  String get viewMatches => 'Skatīt atbilstības';

  @override
  String get pauseWishlist => 'Apturēt';

  @override
  String get activateWishlist => 'Aktivizēt';

  @override
  String get markAsFulfilled => 'Atzīmēt kā izpildītu';

  @override
  String get archiveWishlist => 'Arhivēt';

  @override
  String get pleaseEnterTitle => 'Lūdzu, ievadiet nosaukumu';

  @override
  String get atLeastOneKeyword => 'Lūdzu, ievadiet vismaz vienu atslēgvārdu';

  @override
  String get notificationPreferences => 'Paziņojumu preferences';

  @override
  String get contacts => 'Kontakti';

  @override
  String get attributes => 'Atribūti';

  @override
  String get noContactsFound => 'Nav atrasti kontakti';

  @override
  String get verified => 'Verificēts';

  @override
  String get notVerified => 'Nav verificēts';

  @override
  String get updateEmail => 'Atjaunināt e-pastu';

  @override
  String get updatePhone => 'Atjaunināt tālruni';

  @override
  String get pushNotifications => 'Push paziņojumi';

  @override
  String get noPushTokens => 'Nav reģistrētu push paziņojumu marķieru';

  @override
  String get removePushToken => 'Noņemt Push marķieri';

  @override
  String get removePushTokenConfirmation =>
      'Vai tiešām vēlaties noņemt šo push marķieri?';

  @override
  String get remove => 'Noņemt';

  @override
  String get pushTokenRemoved => 'Push marķieris noņemts';

  @override
  String get emailUpdated => 'E-pasts atjaunināts';

  @override
  String get phoneUpdated => 'Tālrunis atjaunināts';

  @override
  String get noAttributePreferences => 'Nav atribūtu preferenču';

  @override
  String get attributePreferencesHint =>
      'Iestatiet paziņojumu preferences savām interesēm un piedāvājumiem';

  @override
  String get frequency => 'Biežums';

  @override
  String get minMatchScore => 'Min. atbilstības rādītājs';

  @override
  String get newPostings => 'Jauni sludinājumi';

  @override
  String get newUsers => 'Jauni lietotāji';

  @override
  String get instant => 'Tūlītējs';

  @override
  String get daily => 'Ikdienas';

  @override
  String get weekly => 'Iknedēļas';

  @override
  String get manual => 'Manuāls';

  @override
  String get edit => 'Rediģēt';

  @override
  String get deletePreference => 'Dzēst preferenci';

  @override
  String get deletePreferenceConfirmation =>
      'Vai tiešām vēlaties dzēst šo preferenci?';

  @override
  String get preferenceDeleted => 'Preference dzēsta';

  @override
  String get editPreference => 'Rediģēt preferenci';

  @override
  String get notifyOnNewPostings => 'Paziņot par jauniem sludinājumiem';

  @override
  String get notifyOnNewUsers => 'Paziņot par jauniem lietotājiem';

  @override
  String get preferenceUpdated => 'Preference atjaunināta';

  @override
  String get unviewed => 'Neapskatīts';

  @override
  String get unviewedOnly => 'Tikai neapskatītie';

  @override
  String get noUnviewedMatches => 'Nav neapskatītu atbilstību';

  @override
  String get newBadge => 'JAUNS';

  @override
  String get markAsViewed => 'Atzīmēt kā apskatītu';

  @override
  String get dismiss => 'Noraidīt';

  @override
  String get dismissed => 'Noraidīts';

  @override
  String get postingMatch => 'Sludinājuma atbilstība';

  @override
  String get userMatch => 'Lietotāja atbilstība';

  @override
  String get attributeMatch => 'Atribūta atbilstība';

  @override
  String get match => 'Atbilstība';

  @override
  String get dismissMatch => 'Noraidīt atbilstību';

  @override
  String get dismissMatchConfirmation =>
      'Vai tiešām vēlaties noraidīt šo atbilstību?';

  @override
  String get matchDismissed => 'Atbilstība noraidīta';

  @override
  String get phoneNumber => 'Tālruņa numurs';

  @override
  String get matches => 'Atbilstības';

  @override
  String get notificationSettings => 'Paziņojumu iestatījumi';

  @override
  String get enableNotifications => 'Ieslēgt paziņojumus';

  @override
  String get enableNotificationsDescription =>
      'Saņemt paziņojumus par atbilstībām un atjauninājumiem';

  @override
  String get quietHours => 'Klusās stundas';

  @override
  String get quietHoursDescription => 'Nesūtīt paziņojumus šajā laikā';

  @override
  String get startTime => 'Sākuma laiks';

  @override
  String get endTime => 'Beigu laiks';

  @override
  String get clearQuietHours => 'Notīrīt klusās stundas';

  @override
  String get noAttributesInProfile =>
      'Vispirms pievienojiet intereses un prasmes savam profilam';

  @override
  String get setupAttributeNotifications => 'Iestatīt paziņojumus';

  @override
  String get setupAttributeNotificationsHint =>
      'Ieslēdziet paziņojumus savām interesēm un prasmēm, lai saņemtu brīdinājumus, kad tiek atrastas atbilstības';

  @override
  String get defaultSettings => 'Noklusējuma iestatījumi';

  @override
  String get selectAttributes => 'Izvēlēties atribūtus';

  @override
  String get attributesSelected => 'izvēlēti';

  @override
  String get createPreferences => 'Saglabāt preferences';

  @override
  String get preferencesCreated => 'Paziņojumu preferences saglabātas';

  @override
  String get retry => 'Mēģināt vēlreiz';

  @override
  String get offering => 'Piedāvā';

  @override
  String get interest => 'Interese';

  @override
  String get category => 'Kategorija';

  @override
  String get relevancy => 'Atbilstība';

  @override
  String get matchHistory => 'Atbilstību vēsture';

  @override
  String get addAttributes => 'Pievienot atribūtus';

  @override
  String get allAttributesHavePreferences =>
      'Visiem atribūtiem no jūsu profila jau ir paziņojumu preferences';

  @override
  String get add => 'Pievienot';

  @override
  String get setupEmailTitle => 'Iestatīt e-pastu';

  @override
  String get setupEmailDescription =>
      'Ievadiet savu e-pasta adresi, lai saņemtu paziņojumus';

  @override
  String get emailHint => 'piemers@epasts.lv';

  @override
  String get emailRequired => 'E-pasta adrese ir obligāta';

  @override
  String get emailInvalid => 'Lūdzu, ievadiet derīgu e-pasta adresi';

  @override
  String get saveEmail => 'Saglabāt e-pastu';

  @override
  String get emailSaved => 'E-pasta adrese veiksmīgi saglabāta';

  @override
  String get deleteProfile => 'Dzēst profilu';

  @override
  String get deleteProfileConfirmation =>
      'Vai tiešām vēlaties dzēst savu profilu? Šo darbību nevar atsaukt. Visi jūsu dati, sludinājumi un sarunas tiks neatgriezeniski noņemti.';

  @override
  String get profileDeleted => 'Profils veiksmīgi dzēsts';

  @override
  String get errorDeletingProfile => 'Kļūda profila dzēšanā';

  @override
  String get review => 'Atsauksme';

  @override
  String get reportScam => 'Ziņot par krāpšanu';

  @override
  String get reportScamConfirmation =>
      'Vai tiešām vēlaties ziņot par šo lietotāju kā krāpnieku?';

  @override
  String get reportScamConsequencesTitle => 'Tas nozīmē:';

  @override
  String get reportScamConsequence1 =>
      '• Šī transakcija tiks atzīmēta moderatora pārskatīšanai';

  @override
  String get reportScamConsequence2 =>
      '• Iespējams, otra lietotāja profils tiks apturēts';

  @override
  String get reportScamConsequence3 => '• Jums būs jāsniedz pierādījumi';

  @override
  String get falseReportsWarning =>
      'Viltus ziņojumi var izraisīt soda sankcijas jūsu kontam.';

  @override
  String get report => 'Ziņot';

  @override
  String get reviewSubmitted => 'Atsauksme iesniegta!';

  @override
  String get thankYouForFeedback => 'Paldies par atsauksmēm!';

  @override
  String reviewVisibilityNotice(String otherUserName) {
    return 'Jūsu atsauksme būs redzama pēc tam, kad $otherUserName iesniegs savu atsauksmi, vai pēc 14 dienām.';
  }

  @override
  String get ok => 'Labi';

  @override
  String get skipReviewTitle => 'Izlaist atsauksmi?';

  @override
  String get skipReviewMessage =>
      'Jūs varat atsauksmēt šo lietotāju vēlāk no savas transakciju vēstures. Atsauksmes palīdz veidot uzticību kopienā.';

  @override
  String get goBack => 'Atpakaļ';

  @override
  String get skip => 'Izlaist';

  @override
  String reviewUser(String userName) {
    return 'Atsauksmēt $userName';
  }

  @override
  String get ratingRequired => 'Vērtējums *';

  @override
  String get ratingExcellent => 'Izcils';

  @override
  String get ratingGood => 'Labs';

  @override
  String get ratingOkay => 'Labi';

  @override
  String get ratingPoor => 'Vāji';

  @override
  String get ratingVeryBad => 'Ļoti slikti';

  @override
  String get tapToRate => 'Pieskarieties, lai vērtētu';

  @override
  String get howDidItGo => 'Kā gāja? *';

  @override
  String get transactionStatusSuccessful => 'Veiksmīga maiņa';

  @override
  String get transactionStatusCancelled => 'Atcelts';

  @override
  String get transactionStatusNoDeal => 'Runāts, bet nav vienošanās';

  @override
  String get transactionStatusScam => '🚩 Ziņot par krāpšanu';

  @override
  String get tellUsMore => 'Pastāstiet vairāk (neobligāti)';

  @override
  String get shareYourExperience => 'Dalieties ar savu pieredzi...';

  @override
  String get beSpecificAndConstructive => 'Esiet konkrēts un konstruktīvs';

  @override
  String get reviewGuidelines => 'Atsauksmju vadlīnijas';

  @override
  String get guidelineHonest => 'Esiet godīgs un taisnīgs';

  @override
  String get guidelineFocusExperience =>
      'Fokusējieties uz savu faktisko pieredzi';

  @override
  String get guidelineVisibility =>
      'Atsauksmes kļūst redzamas pēc abu pušu iesniegšanas';

  @override
  String get guideline90Days => 'Jums ir 90 dienas, lai iesniegtu atsauksmi';

  @override
  String get guidelineFalseReports =>
      'Viltus ziņojumi var izraisīt konta apturēšanu';

  @override
  String get submitReview => 'Iesniegt atsauksmi';

  @override
  String get skipForNow => 'Pagaidām izlaist';

  @override
  String get failedToSubmitReview => 'Neizdevās iesniegt atsauksmi';

  @override
  String get archiveConversationTitle => 'Arhivēt sarunu?';

  @override
  String get archiveConversationMessage =>
      'Vai vēlaties tagad arhivēt šo sarunu?';

  @override
  String get keep => 'Paturēt';

  @override
  String get archive => 'Arhivēt';

  @override
  String get unableToReviewUser =>
      'Šobrīd nav iespējams atsauksmēt šo lietotāju';

  @override
  String get cannotSendFileNoRecipientKey =>
      'Nevar nosūtīt failu: Saņēmēja publiskā atslēga nav pieejama';

  @override
  String get gallery => 'Galerija';

  @override
  String get camera => 'Kamera';

  @override
  String get uploadingFile => 'Notiek faila augšupielāde...';

  @override
  String get fileSentSuccessfully => 'Fails veiksmīgi nosūtīts!';

  @override
  String downloadingFile(String filename) {
    return 'Notiek $filename lejupielāde...';
  }

  @override
  String downloadFailed(String error) {
    return 'Lejupielāde neizdevās: $error';
  }

  @override
  String get noAppToOpenFile =>
      'Nav atrasta lietotne, lai atvērtu šo faila tipu';

  @override
  String fileSavedAt(String filePath) {
    return 'Fails saglabāts: $filePath';
  }

  @override
  String fileNotFound(String filePath) {
    return 'Fails nav atrasts: $filePath';
  }

  @override
  String get permissionDeniedOpenFile => 'Atļauja liegta faila atvēršanai';

  @override
  String errorOpeningFile(String message) {
    return 'Kļūda faila atvēršanā: $message';
  }

  @override
  String couldNotOpenFile(String error) {
    return 'Neizdevās atvērt failu: $error';
  }

  @override
  String get finishTransaction => 'Pabeigt transakciju';

  @override
  String get finishTransactionConfirmation =>
      'Vai tiešām vēlaties atzīmēt šo transakciju kā pabeigtu?';

  @override
  String get transactionCreated => 'Transakcija veiksmīgi izveidota';

  @override
  String get transactionCompleted => 'Transakcija atzīmēta kā pabeigta';

  @override
  String errorCreatingTransaction(String error) {
    return 'Kļūda transakcijas izveidē: $error';
  }

  @override
  String errorUpdatingTransaction(String error) {
    return 'Kļūda transakcijas atjaunināšanā: $error';
  }

  @override
  String get noUsersNearbyTitle => 'Nav lietotāju tuvumā';

  @override
  String get noUsersNearbyMessage =>
      'Šķiet, ka jūsu apkārtnē vēl nav lietotāju. Esiet pirmais, kas uzaicina draugus un sāk barterēšanos!';

  @override
  String get shareApp => 'Dalīties ar lietotni';

  @override
  String get copyLink => 'Kopēt saiti';

  @override
  String get close => 'Aizvērt';

  @override
  String get linkCopiedToClipboard => 'Saite nokopēta starpliktuvē!';

  @override
  String get unableToShareAtThisTime => 'Šobrīd nevar dalīties';

  @override
  String inviteMessageShare(String appLink) {
    return 'Čau! Pievienojies man BarterApp - lielisks veids, kā mainīt priekšmetus un pakalpojumus ar cilvēkiem tuvumā! 🔄\n\n$appLink';
  }

  @override
  String get inviteMessageSubject => 'Pievienojies man BarterApp!';

  @override
  String get reportUser => 'Ziņot par lietotāju';

  @override
  String get blockUser => 'Bloķēt lietotāju';

  @override
  String get unblockUser => 'Atbloķēt lietotāju';

  @override
  String get reportUserConfirmation =>
      'Lūdzu, norādiet iemeslu ziņošanai par šo lietotāju.';

  @override
  String get reportReason => 'Ziņošanas iemesls (neobligāti)';

  @override
  String get userReported => 'Lietotājs veiksmīgi ziņots';

  @override
  String get blockUserConfirmation =>
      'Vai tiešām vēlaties bloķēt šo lietotāju? Jūs vairs nevarēsiet ar viņiem sazināties.';

  @override
  String get unblockUserConfirmation =>
      'Vai tiešām vēlaties atbloķēt šo lietotāju? Viņi varēs atkal ar jums sazināties.';

  @override
  String get block => 'Bloķēt';

  @override
  String get unblock => 'Atbloķēt';

  @override
  String get userBlocked => 'Lietotājs veiksmīgi bloķēts';

  @override
  String get userUnblocked => 'Lietotājs veiksmīgi atbloķēts';

  @override
  String get failedToBlockUser => 'Neizdevās bloķēt lietotāju';

  @override
  String get failedToUnblockUser => 'Neizdevās atbloķēt lietotāju';

  @override
  String get failedToSubmitReport =>
      'Neizdevās iesniegt ziņojumu. Lūdzu, mēģiniet vēlreiz.';

  @override
  String get reportSubmittedOfferBlock =>
      'Paldies, ka palīdzat uzturēt kopienu drošu. Vai vēlaties arī bloķēt šo lietotāju?';

  @override
  String reportUserTitle(String userName) {
    return 'Ziņot par $userName';
  }

  @override
  String blockUserConfirmationDetailed(String userName) {
    return 'Bloķējot $userName, viņi nevarēs:\n• Sūtīt jums ziņojumus\n• Skatīt jūsu profilu\n• Komentēt jūsu sludinājumus';
  }

  @override
  String unblockUserConfirmationDetailed(String userName) {
    return 'Atbloķējot $userName, viņi varēs:\n• Sūtīt jums ziņojumus\n• Skatīt jūsu profilu\n• Komentēt jūsu sludinājumus';
  }

  @override
  String get whyReportingUser => 'Kāpēc jūs ziņojat par šo lietotāju?';

  @override
  String get reportReasonSpam => 'Spam';

  @override
  String get reportReasonHarassment => 'Uzmākšanās';

  @override
  String get reportReasonInappropriateContent => 'Nepiemērots saturs';

  @override
  String get reportReasonScam => 'Krāpšana';

  @override
  String get reportReasonFakeProfile => 'Viltots profils';

  @override
  String get reportReasonImpersonation => 'Uzdošanās par citu';

  @override
  String get reportReasonThreateningBehavior => 'Draudoša uzvedība';

  @override
  String get reportReasonOther => 'Cits';

  @override
  String get additionalDetails => 'Papildu informācija (neobligāti)';

  @override
  String get provideMoreContext => 'Sniedziet vairāk konteksta...';

  @override
  String get submitReport => 'Iesniegt ziņojumu';

  @override
  String get privacyPolicyIntroTitle => 'Ievads';

  @override
  String get privacyPolicyIntroContent =>
      'Šī Privātuma politika apraksta, kā mēs apkopojam, izmantojam un aizsargājam jūsu personisko informāciju, lietojot mūsu maiņas lietotni. Mēs apņemamies nodrošināt jūsu privātumu un aizsargāt jūsu datus.';

  @override
  String get privacyPolicyDataCollectionTitle =>
      'Informācija, ko mēs apkopojam';

  @override
  String get privacyPolicyDataCollectionContent =>
      'Mēs apkopojam informāciju, ko jūs sniedzat tieši, tostarp jūsu profila informāciju, intereses, piedāvājumus, atrašanās vietas datus un tērzēšanas ziņojumus. Mēs arī apkopojam lietošanas datus, piemēram, lietotnes mijiedarbību un ierīces informāciju, lai uzlabotu mūsu pakalpojumu.';

  @override
  String get privacyPolicyDataUsageTitle =>
      'Kā mēs izmantojam jūsu informāciju';

  @override
  String get privacyPolicyDataUsageContent =>
      'Mēs izmantojam jūsu informāciju, lai: veicinātu maiņas savienojumus starp lietotājiem, parādītu jūsu profilu citiem lietotājiem jūsu apkārtnē, nodrošinātu tērzēšanas funkcionalitāti, uzlabotu mūsu pakalpojumus un nosūtītu paziņojumus par atbilstībām un ziņojumiem.';

  @override
  String get privacyPolicyDataSharingTitle => 'Informācijas kopīgošana';

  @override
  String get privacyPolicyDataSharingContent =>
      'Jūsu profila informācija, intereses un piedāvājumi ir redzami citiem lietotnes lietotājiem, lai veicinātu maiņu. Mēs nepārdodam jūsu personisko informāciju trešajām personām. Mēs varam kopīgot datus ar pakalpojumu sniedzējiem, kuri palīdz darbināt mūsu lietotni, un mēs varam atklāt informāciju, ja to prasa likums.';

  @override
  String get privacyPolicyDataSecurityTitle => 'Datu drošība';

  @override
  String get privacyPolicyDataSecurityContent =>
      'Mēs īstenojam atbilstošus tehniskos un organizatoriskos pasākumus, lai aizsargātu jūsu personisko informāciju no nesankcionētas piekļuves, izmaiņām, izpaušanas vai iznīcināšanas. Tomēr neviens pārraides veids internetā nav 100% drošs.';

  @override
  String get privacyPolicyUserRightsTitle => 'Jūsu tiesības';

  @override
  String get privacyPolicyUserRightsContent =>
      'Jums ir tiesības jebkurā laikā piekļūt, atjaunināt vai dzēst savu personisko informāciju, izmantojot lietotnes iestatījumus. Jūs varat arī pieprasīt savu datu kopiju vai iebilst pret noteiktiem apstrādes veidiem.';

  @override
  String get privacyPolicyThirdPartyTitle => 'Trešo pušu pakalpojumi';

  @override
  String get privacyPolicyThirdPartyContent =>
      'Mūsu lietotnē var tikt izmantoti trešo pušu pakalpojumi analītikai, kartēm un paziņojumiem. Šiem pakalpojumiem ir savas privātuma politikas, un mēs iesakām tās pārskatīt.';

  @override
  String get privacyPolicyChangesTitle => 'Izmaiņas šajā politikā';

  @override
  String get privacyPolicyChangesContent =>
      'Mēs varam laiku pa laikam atjaunināt šo Privātuma politiku. Mēs paziņosim jums par jebkādām izmaiņām, publicējot jauno politiku lietotnē. Turpinot lietot lietotni pēc izmaiņām, tas nozīmē atjauninātās politikas pieņemšanu.';

  @override
  String get privacyPolicyContactTitle => 'Sazinieties ar mums';

  @override
  String get privacyPolicyContactContent =>
      'Ja jums ir kādi jautājumi par šo Privātuma politiku vai mūsu datu praksi, lūdzu, sazinieties ar mums uz help@barters.lv';

  @override
  String get privacyPolicyLastUpdated =>
      'Pēdējoreiz atjaunots: 2025. gada janvāris';
}
