// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Latvian (`lv`).
class AppLocalizationsLv extends AppLocalizations {
  AppLocalizationsLv([String locale = 'lv']) : super(locale);

  @override
  String get appTitle => 'Barters.lv';

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
      'Sarunas, sabiedriskas aktivitātes, ikdienas sarunas, vietējie pasākumi, jauni kontakti, komunikācija';

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
  String get apiErrorAuthSessionExpired =>
      'Sesija beidzās. Lūdzu, autorizējieties vēlreiz.';

  @override
  String get apiErrorTimeout =>
      'Pieprasījums aizņēma pārāk ilgu laiku. Lūdzu, mēģiniet vēlreiz.';

  @override
  String get apiErrorNoInternet =>
      'Nav savienojuma ar internetu. Pārbaudiet tīklu un mēģiniet vēlreiz.';

  @override
  String get apiErrorBadRequest =>
      'Pieprasījumā ir kļūda. Lūdzu, pārbaudiet datus un mēģiniet vēlreiz.';

  @override
  String get apiErrorForbidden => 'Jums nav piekļuves šai darbībai.';

  @override
  String get apiErrorNotFound => 'Pieprasītais resurss nav atrasts.';

  @override
  String get apiErrorConflict =>
      'Konflikts ar esošiem datiem. Lūdzu, atjaunojiet un mēģiniet vēlreiz.';

  @override
  String get apiErrorValidation => 'Daži ievadītie dati nav derīgi.';

  @override
  String get apiErrorServer => 'Servera kļūda. Lūdzu, mēģiniet vēlreiz vēlāk.';

  @override
  String get apiErrorNearbyUsersFallback =>
      'Pašlaik neizdodas ielādēt tuvumā esošos lietotājus.';

  @override
  String get apiErrorSearchUsersFallback =>
      'Pašlaik neizdodas meklēt lietotājus.';

  @override
  String get apiErrorSimilarUsersFallback =>
      'Pašlaik neizdodas ielādēt līdzīgus lietotājus.';

  @override
  String get apiErrorMatchingUsersFallback =>
      'Pašlaik neizdodas ielādēt atbilstošus lietotājus.';

  @override
  String get apiErrorFavoriteUsersFallback =>
      'Pašlaik neizdodas ielādēt iecienītos lietotājus.';

  @override
  String get selectYourInterests => 'Ko Jūs meklējat?';

  @override
  String get selectYourOffers => 'Ko Jūs piedāvājat?';

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
  String get locationSetAtMarkerInfo =>
      'Jūsu atrašanās vieta tiks iestatīta marķiera atrašanās vietā';

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
  String get termsConditionsTitle => 'Lietošanas noteikumi';

  @override
  String get termsConditionsSectionScopeTitle => '1. Piemērošana';

  @override
  String get termsConditionsSectionScopeContent =>
      'Šie noteikumi attiecas uz Bartering App lietošanu un nosaka lietotāja tiesības un pienākumus.';

  @override
  String get termsConditionsSectionMinimumAgeTitle => 'Minimālais vecums';

  @override
  String get termsConditionsSectionMinimumAgeContent =>
      'Lietotne paredzēta personām no 16 gadu vecuma. Reģistrējoties, jūs apliecināt, ka jums ir vismaz 16 gadi.';

  @override
  String get termsConditionsSectionAccountUseTitle =>
      '3. Konta lietošana, atjaunošana un dzēšana';

  @override
  String get termsConditionsSectionAccountUseContent =>
      'Jūs esat atbildīgs par sava konta drošību un par aktivitātēm, kas notiek, izmantojot jūsu kontu. Jums jāieveda jūsu e-pasta adrese Profila sadaļā - Paziņojumu iestatījumos lai varētu atjaunot profilu, vai pieprasīt tā dzēšanu, ja zaudējat piekļuvi ierīcei.';

  @override
  String get termsConditionsSectionProhibitedConductTitle =>
      '4. Aizliegtā rīcība';

  @override
  String get termsConditionsSectionProhibitedConductContent =>
      'Aizliegta krāpniecība, uzmākšanās, nelikumīgs saturs, citu lietotāju datu ļaunprātīga izmantošana un jebkāda pretlikumīga darbība.';

  @override
  String get termsConditionsSectionAccountRestrictionTitle =>
      '5. Konta ierobežošana vai dzēšana';

  @override
  String get termsConditionsSectionAccountRestrictionContent =>
      'Mēs varam ierobežot vai dzēst kontus par noteikumu pārkāpumiem vai drošības riskiem.';

  @override
  String get termsConditionsSectionLiabilityDisputesTitle =>
      '6. Atbildība un strīdi';

  @override
  String get termsConditionsSectionLiabilityDisputesContent =>
      'Lietotāji ir atbildīgi par savām vienošanām un mijiedarbību. Platforma sniedz starpniecības vidi, cik to atļauj tiesību akti.';

  @override
  String get termsConditionsSectionKidsSafetyTitle =>
      '7. Bērnu drošības un CSAE standarti';

  @override
  String get termsConditionsSectionKidsSafetyContent =>
      'Mums ir nulles tolerance pret bērnu seksuālu izmantošanu un vardarbību (CSAE), tostarp bērnu seksuālas izmantošanas materiāliem (CSAM), pavedināšanu, cilvēku tirdzniecību un jebkādu nepilngadīgo seksuālu ekspluatāciju.\n\nŠajā platformā ir stingri aizliegts:\n- publicēt, pieprasīt, izplatīt vai glabāt CSAM\n- seksualizēta saziņa ar nepilngadīgajiem\n- pavedināšana, piespiešana, cilvēku tirdzniecība vai nepilngadīgo ekspluatācija\n- jebkāds mēģinājums izmantot šo pakalpojumu, lai apdraudētu bērnu\n\nMēs varam dzēst saturu, ierobežot vai dzēst kontus, un likumā noteiktajos gadījumos ziņot kompetentajām iestādēm. Lietotāji var ziņot par pārkāpumiem lietotnē vai rakstot uz info@bartering.app.\n\nMēs drošības ziņojumus izskatām pēc iespējas ātri un sadarbojamies ar iestādēm to likumīgo pieprasījumu ietvaros, kas saistīti ar CSAE pārkāpumiem.';

  @override
  String get termsConditionsSectionChangesTitle => '8. Izmaiņas noteikumos';

  @override
  String get termsConditionsSectionChangesContent =>
      'Mēs varam periodiski atjaunināt šos noteikumus. Turpinot lietot lietotni pēc izmaiņām, jūs piekrītat atjauninātajiem noteikumiem.';

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
  String get attr_animation => 'Animācija';

  @override
  String get attr_baking => 'Cepšana';

  @override
  String get attr_beekeeping => 'Biškopība';

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
  String get attr_software_development => 'Programmatūras izstrāde';

  @override
  String get attr_cooking => 'Gatavošana';

  @override
  String get attr_couponing => 'Kuponu izmantošana';

  @override
  String get attr_crocheting => 'Tamborēšana';

  @override
  String get attr_cross_stitch => 'Krustdūriena izšūšana';

  @override
  String get attr_digital_arts => 'Digitālā māksla';

  @override
  String get attr_dj_ing => 'DJing';

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
  String get attr_fashion_design => 'Modes dizains';

  @override
  String get attr_flower_arranging => 'Ziedu kompozīcijas';

  @override
  String get attr_furniture_assembly => 'Furniture assembly';

  @override
  String get attr_gaming => 'Spēles';

  @override
  String get attr_hacking => 'Hakings';

  @override
  String get attr_home_improvement => 'Mājas uzlabošana';

  @override
  String get attr_homebrewing => 'Alus darīšana mājās';

  @override
  String get attr_houseplant_care => 'Istabas augu kopšana';

  @override
  String get attr_home_decor => 'Mājas dekors';

  @override
  String get attr_jewelry => 'Juvelierizstrādājumi';

  @override
  String get attr_knitting => 'Adīšana';

  @override
  String get attr_kombucha => 'Kombuča';

  @override
  String get attr_leather_crafting => 'Ādas apstrāde';

  @override
  String get attr_machining => 'Metālveidošana';

  @override
  String get attr_magic => 'Maģija';

  @override
  String get attr_makeup => 'Grims';

  @override
  String get attr_massage => 'Masāža';

  @override
  String get attr_metalworking => 'Metāla apstrāde';

  @override
  String get attr_painting => 'Gleznošana';

  @override
  String get attr_photography => 'Fotogrāfija';

  @override
  String get attr_pottery => 'Podnieku māksla';

  @override
  String get attr_workout_planning => 'Treniņu plānošana';

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
  String get attr_social_media => 'Sociālie mediji';

  @override
  String get attr_stand_up_comedy => 'Stendup komēdija';

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
  String get attr_gardening => 'Dārzkopība';

  @override
  String get attr_music_production => 'Mūzikas producēšana';

  @override
  String get attr_dancing => 'Dejas';

  @override
  String get attr_traveling => 'Ceļošana';

  @override
  String get attr_coding => 'Programmēšana';

  @override
  String get attr_movies => 'Filmas';

  @override
  String get attr_volunteering => 'Brīvprātīgais darbs';

  @override
  String get attr_meditation => 'Meditācija';

  @override
  String get attr_crafting => 'Amatniecība';

  @override
  String get attr_sales => 'Pārdošana';

  @override
  String get attr_networking => 'Tīklošanās';

  @override
  String get attr_bookkeeping => 'Grāmatvedība';

  @override
  String get attr_administrative_work => 'Administratīvais darbs';

  @override
  String get attr_astronomy => 'Astronomija';

  @override
  String get attr_backpacking => 'Backpacking';

  @override
  String get attr_camping => 'Kempings';

  @override
  String get attr_canyoning => 'Kanjonu tūrisms';

  @override
  String get attr_car_restoration => 'Auto restaurācija';

  @override
  String get attr_cryptocurrency => 'Kriptovalūta';

  @override
  String get attr_culinary_arts => 'Kulinārijas māksla';

  @override
  String get attr_cycling => 'Riteņbraukšana';

  @override
  String get attr_drones => 'Droni';

  @override
  String get attr_filmmaking => 'Filmu veidošana';

  @override
  String get attr_financial_investing => 'Finanšu investīcijas';

  @override
  String get attr_fishing => 'Makšķerēšana';

  @override
  String get attr_foraging => 'Pārtikas meklēšana dabā';

  @override
  String get attr_martial_arts => 'Cīņas mākslas';

  @override
  String get attr_mindfulness => 'Apzinātība';

  @override
  String get attr_pc_building => 'Datoru būvēšana';

  @override
  String get attr_personal_finance => 'Personīgās finanses';

  @override
  String get attr_rock_climbing => 'Klinšu kāpšana';

  @override
  String get attr_sustainable_living => 'Ilgtspējīga dzīvesveida';

  @override
  String get attr_urban_exploration => 'Urbānā pētīšana';

  @override
  String get attr_alternative_medicine => 'Alternatīvā medicīna';

  @override
  String get attr_biohacking => 'Biohakings';

  @override
  String get attr_community_gardening => 'Kopienas dārzkopība';

  @override
  String get attr_cybersecurity => 'Kiberdrošība';

  @override
  String get attr_day_trading => 'Dienas tirdzniecība';

  @override
  String get attr_web_development => 'Tīmekļa izstrāde';

  @override
  String get attr_deep_cleaning => 'Dziļā tīrīšana';

  @override
  String get attr_recipes => 'Receptes';

  @override
  String get attr_bodybuilding => 'Bodibildings';

  @override
  String get attr_metal_detecting => 'Metāla meklēšana';

  @override
  String get attr_pet_grooming => 'Mājdzīvnieku kopšana';

  @override
  String get attr_record_collecting => 'Ierakstu kolekcionēšana';

  @override
  String get attr_marketing => 'Mārketings';

  @override
  String get attr_upcycling => 'Pārstrāde';

  @override
  String get attr_virtual_reality => 'Virtuālā realitāte';

  @override
  String get attr_babysitting => 'Bērnu pieskatīšana';

  @override
  String get attr_bicycles => 'Velosipēdi';

  @override
  String get attr_billiards => 'Biljards';

  @override
  String get attr_canned_goods => 'Konservēti produkti';

  @override
  String get attr_car_detailing => 'Auto tjūnings';

  @override
  String get attr_carpentry => 'Namdaru darbi';

  @override
  String get attr_code_review => 'Koda pārskats';

  @override
  String get attr_comic_books => 'Komiksi';

  @override
  String get attr_computer_repair => 'Datoru remonts';

  @override
  String get attr_concert_tickets => 'Koncerta biļetes';

  @override
  String get attr_co_op_gaming => 'Multi-player spēles';

  @override
  String get attr_brainstorming => 'Brainstorming';

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
  String get attr_chicken_eggs => 'Vistu olas';

  @override
  String get attr_nutrition_advice => 'Uztura konsultācijas';

  @override
  String get attr_gardening_advice => 'Dārzkopības padomi';

  @override
  String get attr_handmade_items => 'Rokdarbi';

  @override
  String get attr_handyman_services => 'Santehniķa pakalpojumi';

  @override
  String get attr_hauling_services => 'Transporta pakalpojumi';

  @override
  String get attr_herbal_remedies => 'Zāļu līdzekļi';

  @override
  String get attr_interview_practice => 'Intervijas prakse';

  @override
  String get attr_language_exchange => 'Valodu apmaiņa';

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
  String get attr_pet_sitting => 'Mājdzīvnieku pieskatīšana';

  @override
  String get attr_photo_restoration => 'Foto restaurācija';

  @override
  String get attr_piano_lessons => 'Klavieru nodarbības';

  @override
  String get attr_proofreading => 'Korektūra';

  @override
  String get attr_multiplayer_games => 'Multiplayer games';

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
  String get attr_used_electronics => 'Lietota elektronika';

  @override
  String get attr_homemade_goods => 'Pašdarinātas preces';

  @override
  String get attr_vehicle_repair => 'Transportlīdzekļu remonts';

  @override
  String get attr_video_game_hardware => 'Videospēļu aparatūra';

  @override
  String get attr_voice_lessons => 'Vokālās nodarbības';

  @override
  String get attr_ux_design => 'UX dizains';

  @override
  String get attr_graphic_design => 'Grafiskais dizains';

  @override
  String get attr_music_performance => 'Mūzikas uzstāšanās';

  @override
  String get attr_transport_service => 'Transporta pakalpojums';

  @override
  String get attr_ai_consulting => 'MI konsultācijas';

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
  String get attr_fruits => 'Augļi';

  @override
  String get attr_fresh_herbs => 'Svaigi garšaugi';

  @override
  String get attr_tea => 'Tēja';

  @override
  String get attr_legal_advice => 'Juridiskā palīdzība';

  @override
  String get attr_cats => 'Kaķi';

  @override
  String get attr_dogs => 'Suņi';

  @override
  String get attr_poker => 'Pokers';

  @override
  String get attr_socializing => 'Socializēšanās';

  @override
  String get attr_plants => 'Augi';

  @override
  String get attr_farm_animals => 'Lauksaimniecības dzīvnieki';

  @override
  String get attr_organic_food => 'Bioloģiskā pārtika';

  @override
  String get attr_mechanisms => 'Mehānismi';

  @override
  String get attr_farm_machinery => 'Lauksaimniecības tehnika';

  @override
  String get attr_driving => 'Vadīšana';

  @override
  String get attr_machinery_operation => 'Smagā tehnika';

  @override
  String get attr_animal_care => 'Dzīvnieku aprūpe';

  @override
  String get attr_horses => 'Zirgi';

  @override
  String get attr_self_sufficiency => 'Pašpietiekamība';

  @override
  String get attr_ridesharing => 'Braucienu koplietošana';

  @override
  String get attr_vegetables => 'Dārzeņi';

  @override
  String get attr_car_cleaning => 'Auto tīrīšana';

  @override
  String get attr_farmstay => 'Uzturēšanās lauku sētā';

  @override
  String get attr_house_maintenance => 'Mājas apkope';

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
  String get attr_pet_supplies => 'Mājdzīvnieku piederumi';

  @override
  String get attr_kids_toys => 'Bērnu rotaļlietas';

  @override
  String get attr_power_tools => 'Elektroinstrumenti';

  @override
  String get attr_camping_gear => 'Kempinga aprīkojums';

  @override
  String get attr_kitchen_appliances => 'Virtuves tehnika';

  @override
  String get attr_device_lending => 'Ierīču aizdošana';

  @override
  String get attr_computer_accessories => 'Datoru aksesuāri';

  @override
  String get attr_clothing => 'Apģērbs';

  @override
  String get attr_sports_equipment => 'Sporta aprīkojums';

  @override
  String get attr_bicycle_parts => 'Velosipēdu detaļas';

  @override
  String get attr_errand_running => 'Uzdevumu veikšana';

  @override
  String get attr_phone_repair => 'Tālruņu remonts';

  @override
  String get attr_lawn_care => 'Zāliena kopšana';

  @override
  String get attr_digital_products => 'Digitālie produkti';

  @override
  String get attr_software_accounts => 'Programmatūras konti';

  @override
  String get attr_reviewing => 'Vērtēšana';

  @override
  String get attr_virtual_assistance => 'Virtuālā asistēšana';

  @override
  String get attr_hair_styling => 'Frizēšana';

  @override
  String get attr_beauty_products => 'Skaistumkopšanas produkti';

  @override
  String get attr_audio_equipment => 'Audio aprīkojums';

  @override
  String get attr_health_supplements => 'Uztura bagātinātāji';

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
  String get chooseFromGallery => 'Izvēlēties no iekārtas';

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
  String get userDetails => 'Lietotāja informācija';

  @override
  String matchingUsersFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'atbilstoši',
      one: 'atbilstošs',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'lietotāji',
      one: 'lietotājs',
    );
    return '$count $_temp0 $_temp1';
  }

  @override
  String matchingPostingsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'atbilstoši',
      one: 'atbilstošs',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'sludinājumi',
      one: 'sludinājumi',
    );
    return '$count $_temp0 $_temp1';
  }

  @override
  String get today => 'Šodien';

  @override
  String get yesterday => 'Vakar';

  @override
  String get notSet => 'Nav iestatīts';

  @override
  String get errorUpdatingFavorite => 'Kļūda iecienītā lietotāja atjaunināšanā';

  @override
  String get noAttributesToDisplay => 'Nav atribūtu, ko parādīt.';

  @override
  String get errorLoadingPostings => 'Kļūda sludinājumu ielādē';

  @override
  String get errorLoadingAttributes => 'Kļūda atribūtu ielādē';

  @override
  String get userPrefix => 'Lietotājs';

  @override
  String get activePostings => 'Aktīvie sludinājumi';

  @override
  String get posting => 'Sludinājums';

  @override
  String get postings => 'Sludinājumi';

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
      'Mainiet zināšanas, pakalpojumus, priekšmetus vai vienkārši savienojieties ar savu kopienu';

  @override
  String get gdprConsentTitle => 'Privātuma un datu piekrišana';

  @override
  String get gdprConsentIntro =>
      'Pirms turpināt, lūdzu, pārskatiet un izvēlieties, kā tiek apstrādāti jūsu dati.';

  @override
  String get gdprConsentRequiredLabel => 'Obligāti: pamatpakalpojuma apstrāde';

  @override
  String get gdprConsentRequiredDescription =>
      'Nepieciešams konta izveidei, lietotāju atbilstībām un drošai saziņai.';

  @override
  String get gdprConsentLocationLabel =>
      'Neobligāti: atrašanās vietas apstrāde';

  @override
  String get gdprConsentLocationDescription =>
      'Izmantojiet atrašanās vietu, lai atrastu atbilstošākos lietotājus tuvumā';

  @override
  String get gdprConsentAiLabel => 'Neobligāti: MI palīdzēta atbilstība';

  @override
  String get gdprConsentAiDescription =>
      'Analizē profilu un iestatījumus, lai uzlabotu ieteikumus un atbilstību.';

  @override
  String get gdprCookiesSectionTitle => 'Sīkdatnes (Web)';

  @override
  String get gdprCookiesRequiredLabel => 'Obligātās sīkdatnes';

  @override
  String get gdprCookiesRequiredDescription =>
      'Nepieciešamas pamatfunkcijām: drošībai, sesiju uzturēšanai un būtisko iestatījumu saglabāšanai.';

  @override
  String get gdprCookiesAnalyticsLabel => 'Neobligātās analītikas sīkdatnes';

  @override
  String get gdprCookiesAnalyticsDescription =>
      'Palīdz saprast lietojumu un uzlabot veiktspēju. Tās tiek izmantotas tikai ar jūsu piekrišanu.';

  @override
  String get gdprConsentManageLater =>
      'Šīs izvēles varēsiet mainīt vēlāk iestatījumos.';

  @override
  String get gdprConsentDecline => 'Ne tagad';

  @override
  String get gdprConsentAccept => 'Turpināt (Piekrītot lietošanas noteikumiem)';

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
  String get pleaseSelectAtLeastOneInterest =>
      'Lūdzu, izvēlieties vismaz vienu interesi vai pievienojiet pielāgotu atslēgvārdu';

  @override
  String get pleaseSelectAtLeastOneOffer =>
      'Lūdzu, izvēlieties vismaz vienu piedāvājumu vai pievienojiet pielāgotu atslēgvārdu';

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
  String get matchLabel => 'Atbilstība:';

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
  String get preferencesCreated => 'Paziņojumu iestatījumi saglabātas';

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
      'Visiem atribūtiem no jūsu profila jau ir paziņojumu iestatījumi';

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
  String get emailNotificationPreferences => 'E-pasta iestatījumi';

  @override
  String get emailUnsubscribe => 'Atteikties no abonēšanas';

  @override
  String get emailUnsubscribed => 'Atteikšanās veiksmīga';

  @override
  String get emailInvalid => 'Lūdzu, ievadiet derīgu e-pasta adresi';

  @override
  String get saveEmail => 'Saglabāt e-pastu';

  @override
  String get emailSaved => 'E-pasta adrese veiksmīgi saglabāta';

  @override
  String get marketingConsentLabel =>
      'Piekrītu saņemt e-pastus par jauniem piedāvājumiem, iespējām un atjauninājumiem';

  @override
  String get marketingConsentDescription =>
      'Mēs reizēm varam jums nosūtīt e-pastus par mūsu pakalpojumiem. Jūs jebkurā laikā varat atteikties no abonēšanas.';

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
  String get ratingAndReviews => 'Reputācija un Atsauksmes';

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
  String get reviewVisibilityNotice =>
      'Jūsu atsauksme būs redzama pēc tam, kad otrs lietotājs iesniegs savu atsauksmi, vai pēc 14 dienām.';

  @override
  String get ok => 'Labi';

  @override
  String get premiumUserBenefitsTitle => 'Premium lietotāja priekšrocības';

  @override
  String get premiumUserBenefitsMessage =>
      'Atbloķējiet Premium, lai iegūtu šīs priekšrocības:\n• Rediģēt savu vārdu\n• Rediģēt profila aprakstu\n• Rediģēt savu profila ikonu\n• Pievienot darba atsauču attēlus\n• Izcelties kartē\n• Atļauti vairāk nekā 3 aktīvi sludinājumi';

  @override
  String get buyPremium => 'Pirkt Premium';

  @override
  String get restorePurchases => 'Atjaunot pirkumus';

  @override
  String get inAppRevenueCatApiKeyMissing => 'Trūkst RevenueCat API atslēgas.';

  @override
  String get inAppFailedToInitializePurchases =>
      'Neizdevās inicializēt pirkumus';

  @override
  String get inAppFailedToLoadOfferings => 'Neizdevās ielādēt piedāvājumus';

  @override
  String get inAppNoPremiumPackagesAvailable =>
      'Pašlaik nav pieejamu Premium paku.';

  @override
  String get inAppPremiumActivatedSuccessfully =>
      'Premium veiksmīgi aktivizēts.';

  @override
  String get inAppPurchaseCompletedEntitlementNotActiveYet =>
      'Pirkums pabeigts, bet piekļuve vēl nav aktivizēta.';

  @override
  String get inAppPurchaseCancelled => 'Pirkums atcelts.';

  @override
  String get inAppPurchaseFailed => 'Pirkums neizdevās';

  @override
  String get inAppPremiumRestoredSuccessfully => 'Premium veiksmīgi atjaunots.';

  @override
  String get inAppNoActivePremiumPurchasesToRestore =>
      'Nav atrasti aktīvi Premium pirkumi atjaunošanai.';

  @override
  String get inAppRestoreFailed => 'Atjaunošana neizdevās';

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
  String get bonusTipOptional => 'Bonuss / dzeramnauda (neobligāti)';

  @override
  String get other => 'Cits';

  @override
  String get enterBonusAmount => 'Ievadiet bonusa summu';

  @override
  String get loadingWalletBalance => 'Ielādē maka atlikumu...';

  @override
  String currentWalletBalance(String amount) {
    return 'Pašreizējais maka atlikums: $amount';
  }

  @override
  String get failedToSubmitReview => 'Neizdevās iesniegt atsauksmi';

  @override
  String get appealReviewTitle => 'Apstrīdēt atsauksmi';

  @override
  String get appealReviewReasonHint =>
      'Aprakstiet, kāpēc šī atsauksme būtu jāpārskata';

  @override
  String get appealReasonRequired => 'Apelācijas iemesls ir obligāts';

  @override
  String get failedToSubmitAppeal => 'Neizdevās iesniegt apelāciju';

  @override
  String get unableToSubmitAppealNow => 'Pašlaik nevar iesniegt apelāciju';

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
  String get barterCoinsTitle => 'Bartera monētas';

  @override
  String get barterCoinsInfoMessage =>
      'Monētas var nopelnīt, sniedzot pakalpojumu vai aktīvi lietojot lietotni.\n\nMonētas var tērēt: izcelšanās kartē, sludinājumu izcelšana, speciālas avatara ikonas';

  @override
  String get purchaseCoins => 'Pirkt monētas';

  @override
  String get selectCoinPackage => 'Izvēlieties monētu pakotni:';

  @override
  String selectedCoinPackage(String amount) {
    return 'Izvēlētā monētu pakotne: $amount';
  }

  @override
  String get purchaseCoinsFlowComingSoon => 'Monētu pirkšanas plūsma drīzumā';

  @override
  String get avatarShopTitle => 'Avatāru veikals';

  @override
  String get avatarShopDescription =>
      'Nopērc un uzreiz uzliec pielāgotu avatāra ikonu.';

  @override
  String get avatarShopRefresh => 'Atjaunot';

  @override
  String avatarShopBalance(String amount) {
    return 'Bilance: $amount ₿';
  }

  @override
  String avatarShopEachAvatarPrice(String price) {
    return 'Katrs avatārs: $price ₿';
  }

  @override
  String avatarShopLoadFailed(String error) {
    return 'Neizdevās ielādēt avatāru veikalu: $error';
  }

  @override
  String get avatarShopUnableToProcessPurchase =>
      'Šobrīd pirkumu nevar apstrādāt.';

  @override
  String get avatarShopAvatarAlreadySelected => 'Šis avatārs jau ir atlasīts.';

  @override
  String avatarShopNotEnoughCoins(int coins) {
    return 'Nepietiek monētu. Nepieciešamas $coins monētas.';
  }

  @override
  String avatarShopPurchaseFailed(String error) {
    return 'Pirkums neizdevās: $error';
  }

  @override
  String get avatarShopPurchaseSuccess =>
      'Avatārs veiksmīgi nopirkts un uzlikts.';

  @override
  String get avatarShopSelected => 'Atlasīts';

  @override
  String get avatarShopEquip => 'Aprīkot';

  @override
  String avatarShopBuyButton(String coins) {
    return 'Pirkt par $coins ₿';
  }

  @override
  String avatarShopNeedCoins(String coins) {
    return '$coins ₿';
  }

  @override
  String get createPostingBoostTitle => 'Redzamības boost';

  @override
  String get createPostingBoostDescription =>
      'Tērē monētas, lai izceltu šo sludinājumu meklēšanas rezultātos.';

  @override
  String get createPostingBoostNone => 'Bez boost';

  @override
  String get createPostingBoost3Days => '3 dienas (20 monētas)';

  @override
  String get createPostingBoost7Days => '7 dienas (50 monētas)';

  @override
  String get createPostingBoostInsufficientCoins =>
      'Nepietiek monētu izvēlētajam boost.';

  @override
  String get cannotSendFileNoRecipientKey =>
      'Nevar nosūtīt failu: Saņēmēja publiskā atslēga nav pieejama';

  @override
  String get chatOpenFailed =>
      'Šobrīd nevar atvērt šo čatu. Lūdzu, mēģiniet vēlreiz.';

  @override
  String get fileReadFailed =>
      'Neizdevās nolasīt izvēlēto failu. Lūdzu, izvēlieties citu failu.';

  @override
  String get fileSendFailed =>
      'Šobrīd failu nosūtīt neizdevās. Lūdzu, mēģiniet vēlreiz.';

  @override
  String get fileDownloadFailed =>
      'Šobrīd failu lejupielādēt neizdevās. Lūdzu, mēģiniet vēlreiz.';

  @override
  String get fileDecryptKeyMissing =>
      'Šo failu vēl nevar atšifrēt. Mēģiniet vēlreiz, kad čata atslēgas būs sinhronizētas.';

  @override
  String get couldNotOpenFileGeneric =>
      'Neizdevās atvērt šo failu. Lūdzu, mēģiniet citu lietotni vai pārbaudiet faila ceļu.';

  @override
  String get gallery => 'Iekārta';

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
  String decryptingFile(String filename) {
    return 'Atšifrē $filename...';
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
      'Jūsu apkārtne vēl attīstās. Uzaicini paziņas un veido kopienu — nopelni 50 monētas par pirmo ieteikumu!';

  @override
  String nearbyUsersAlertCheckboxTitle(int count) {
    return 'Paziņot, kad tuvumā ir $count+ lietotāji';
  }

  @override
  String get nearbyUsersAlertCheckboxSubtitle =>
      'Nosūtīsim paziņojumu, kad jūsu apkārtnē parādīsies pietiekami daudz lietotāju.';

  @override
  String get nearbyUsersAlertLoading => 'Pārbaudām paziņojuma iestatījumu...';

  @override
  String get nearbyUsersAlertEnabled =>
      'Tuvumā esošo lietotāju paziņojums ieslēgts.';

  @override
  String get nearbyUsersAlertDisabled =>
      'Tuvumā esošo lietotāju paziņojums izslēgts.';

  @override
  String get nearbyUsersAlertSaveError =>
      'Pašlaik neizdevās atjaunināt tuvumā esošo lietotāju paziņojumu.';

  @override
  String get nearbyUsersAlertManageDelivery =>
      'Pārvaldiet, kur tiek nosūtīti tuvumā esošo lietotāju paziņojumi.';

  @override
  String get notificationEmailTitle => 'Pievienojiet e-pastu paziņojumiem';

  @override
  String get notificationEmailSubtitle =>
      'Pievienojiet e-pasta adresi, lai mēs varētu paziņot arī tad, ja push paziņojumi nav pieejami.';

  @override
  String get notificationEmailLabel => 'E-pasta adrese';

  @override
  String get notificationEmailSave => 'Saglabāt e-pastu';

  @override
  String get notificationEmailSaved => 'Paziņojumu e-pasts saglabāts.';

  @override
  String get notificationEmailSaveError =>
      'Pašlaik neizdevās saglabāt paziņojumu e-pastu.';

  @override
  String get notificationEmailRequired => 'Ievadiet e-pasta adresi.';

  @override
  String get notificationEmailInvalid => 'Ievadiet derīgu e-pasta adresi.';

  @override
  String notificationEmailConfigured(String email) {
    return 'Paziņojumus var nosūtīt uz $email';
  }

  @override
  String get shareApp => 'Dalīties ar lietotni';

  @override
  String get copyLink => 'Kopēt saiti';

  @override
  String get close => 'Aizvērt';

  @override
  String get badgesTitle => 'Nozīmītes';

  @override
  String get noBadgesEarnedYet =>
      'Vēl nav nopelnītu nozīmīšu. Turpiniet veikt maiņas, lai tās iegūtu.';

  @override
  String get badgeEarnedStatus => 'Nopelnīta';

  @override
  String get badgeNotEarnedStatus => 'Nav nopelnīta';

  @override
  String get badgeIdentityVerifiedTitle => 'Identitāte verificēta';

  @override
  String get badgeIdentityVerifiedDescription =>
      'Lietotājs ir pabeidzis identitātes verifikāciju.';

  @override
  String get badgeVeteranTraderTitle => 'Pieredzējis tirgotājs';

  @override
  String get badgeVeteranTraderDescription =>
      'Lietotājs ir pabeidzis 100+ veiksmīgas maiņas.';

  @override
  String get badgeTopRatedTitle => 'Top vērtēts';

  @override
  String get badgeTopRatedDescription =>
      'Vidējais vērtējums 4.8+ ar vismaz 50 atsauksmēm.';

  @override
  String get badgeQuickResponderTitle => 'Ātrs atbildētājs';

  @override
  String get badgeQuickResponderDescription =>
      'Parasti atbild 24 stundu laikā.';

  @override
  String get badgeCommunityConnectorTitle => 'Kopienas savienotājs';

  @override
  String get badgeCommunityConnectorDescription =>
      'Augsta dažādība sadarbības partneros.';

  @override
  String get badgeVerifiedBusinessTitle => 'Verificēts bizness';

  @override
  String get badgeVerifiedBusinessDescription =>
      'Biznesa reģistrācija ir verificēta.';

  @override
  String get badgeDisputeFreeTitle => 'Bez strīdiem';

  @override
  String get badgeDisputeFreeDescription => 'Nav bijuši strīdīgi darījumi.';

  @override
  String get badgeFastTraderTitle => 'Ātrs un uzticams';

  @override
  String get badgeFastTraderDescription => 'Pabeidz maiņas ātrāk nekā vidēji.';

  @override
  String get badgePremiumUserTitle => 'Premium lietotājs';

  @override
  String get badgePremiumUserDescription =>
      'Lietotājam ir aktīvs Premium abonements.';

  @override
  String get badgeTop1000Title => 'Agrīnais lietotājs - pirmie 1000';

  @override
  String get badgeTop1000Description =>
      'Lietotājs bija starp pirmajiem 1000 reģistrētajiem lietotājiem.';

  @override
  String get showMore => 'Rādīt vairāk';

  @override
  String get showLess => 'Rādīt mazāk';

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
  String get viewProfile => 'Skatīt profilu';

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
  String get privacyPolicyIntroTitle => 'Pārzinis, tvērums un kontakti';

  @override
  String get privacyPolicyIntroContent =>
      'Šī politika skaidro, kā Barter backend pakalpojumi un saistītie mobilie/tīmekļa klienti apstrādā personas datus. Tā aptver backend API, klienta lietotnes, admin/compliance rīkus un izvēles federācijas funkcijas, ja tās ir ieslēgtas.';

  @override
  String get privacyPolicyDataCollectionTitle => 'Kādus datus mēs apstrādājam';

  @override
  String get privacyPolicyDataCollectionContent =>
      'Mēs varam apstrādāt konta/autentifikācijas datus (t.sk. paraksta metadatus), profila datus, sludinājumu un čata datus, paziņojumu datus (e-pasts, push tokeni, piekrišanu karogi), drošības/compliance ierakstus un tehniskos pieprasījumu metadatus.';

  @override
  String get privacyPolicyDataUsageTitle => 'Mērķi un GDPR juridiskie pamati';

  @override
  String get privacyPolicyDataUsageContent =>
      'Apstrāde nodrošina pakalpojuma sniegšanu (GDPR 6(1)(b)), drošību un ļaunprātīgas izmantošanas novēršanu (GDPR 6(1)(f)), kā arī juridiskos/compliance pienākumus (GDPR 6(1)(c), 6(1)(f)). Ja piemērojams, izvēles funkcijas un piekrišanas tiek apstrādātas saskaņā ar GDPR 6(1)(a).';

  @override
  String get privacyPolicyDataSharingTitle =>
      'Apstrādātāji, infrastruktūra un pārsūtīšana';

  @override
  String get privacyPolicyDataSharingContent =>
      'Pašreizējās integrācijas var ietvert PostgreSQL, Mailjet, Firebase/FCM, Ollama, kā arī Nginx + Docker infrastruktūru. Izvēles federācijas mezgli tiek izmantoti tikai tad, ja tie ir ieslēgti un uzticami. Ja dati tiek apstrādāti ārpus jūsu valsts/EEZ, tiek piemērotas juridiski prasītās garantijas (piemēram, SCC).';

  @override
  String get privacyPolicyDataSecurityTitle => 'Drošība, glabāšana un dzēšana';

  @override
  String get privacyPolicyDataSecurityContent =>
      'Mēs izmantojam pasākumus, piemēram, autentificētu pieprasījumu parakstu pārbaudes, piekļuves kontroli, transporta drošību un audita žurnālus. Tiek izmantotas glabāšanas kontroles un plānota tīrīšana operacionālajiem/compliance ierakstiem, ar legal hold saderīgu apstrādi, kur nepieciešams.';

  @override
  String get privacyPolicyUserRightsTitle =>
      'Jūsu tiesības, dzēšana un pārnesamība';

  @override
  String get privacyPolicyUserRightsContent =>
      'Ievērojot piemērojamos tiesību aktus, varat pieprasīt piekļuvi, labošanu, dzēšanu, ierobežošanu, pārnesamību, iebildumus un piekrišanas atsaukšanu. Autentificētas dzēšanas/eksporta plūsmas ietver legal hold pārbaudes, DSAR uzskaiti un compliance notikumu žurnalēšanu.';

  @override
  String get privacyPolicyThirdPartyTitle =>
      'Backend un klienta privātuma paziņojums';

  @override
  String get privacyPolicyThirdPartyContent =>
      'Šis lietotnē redzamais teksts apkopo backend-centrisku apstrādi un jālasa kopā ar klienta lietotnes paziņojumiem (atļaujas, identifikatori, push UX un lokālā glabātuve/sīkdatnes, kur piemērojams).';

  @override
  String get privacyPolicyChangesTitle => 'Izmaiņas šajā politikā';

  @override
  String get privacyPolicyChangesContent =>
      'Mēs laiku pa laikam varam atjaunināt šo politiku. Būtiskas izmaiņas jākomunicē lietotnē vai citā atbilstošā kanālā, norādot atjauninātus spēkā stāšanās datumus.';

  @override
  String get privacyPolicyContactTitle => 'Kontakti';

  @override
  String get privacyPolicyContactContent =>
      'Privātuma un GDPR pieprasījumiem: info@bartering.app';

  @override
  String get privacyPolicyLastUpdated => 'Pēdējoreiz atjaunots: 2026-04-13';

  @override
  String get chats => 'Čati';

  @override
  String get gpsLocationDisabled =>
      'GPS atrašanās vieta ir atspējota. Iespējojiet to iestatījumos, lai izmantotu šo funkciju.';

  @override
  String get recommendations => 'Ieteikumi:';

  @override
  String get transactionWillBeReviewed =>
      'Šo transakciju pārbaudīs mūsu drošības komanda.';

  @override
  String get continueAnyway => 'Turpināt tik un tā';

  @override
  String get transactionBlocked => 'Transakcija bloķēta';

  @override
  String get securityWarning => 'Drošības brīdinājums';

  @override
  String get securityNotice => 'Drošības paziņojums';

  @override
  String get securityCheck => 'Drošības pārbaude';

  @override
  String get transactionBlockedMessage =>
      'Šī transakcija ir bloķēta aizdomīgu darbību modeļu dēļ. Lūdzu, sazinieties ar atbalsta dienestu, ja uzskatāt, ka tā ir kļūda.';

  @override
  String get securityWarningMessage =>
      'Ir konstatēta neparasta aktivitāte. Var būt nepieciešama papildu verifikācija.';

  @override
  String get securityNoticeMessage =>
      'Mēs esam konstatējuši dažus neparastus modeļus. Jūsu pārskatam var piemērot papildu verifikāciju.';

  @override
  String get securityCheckMessage => 'Viss izskatās labi!';

  @override
  String get downloadStarted =>
      'Lejupielāde sākta! Pārbaudiet savu lejupielāžu mapi';

  @override
  String get showPath => 'Rādīt ceļu';

  @override
  String get users => 'Lietotāji';

  @override
  String get tradeMatch => 'Atbilstība';

  @override
  String get similar => 'Līdzīgs';

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
    return 'Kļūda: $exception';
  }

  @override
  String get errorVerifyingPin => 'Kļūda, pārbaudot PIN';

  @override
  String get deleteAll => 'Dzēst visu';

  @override
  String get deleteAllMatchesConfirmation =>
      'Vai tiešām vēlaties dzēst visu atbilstību vēsturi? Šo darbību nevar atsaukt.';

  @override
  String get allMatchesDeleted => 'Visas atbilstības ir dzēstas';

  @override
  String get selectTheInterestsThatMatchYourPreferences =>
      'Izvēlieties atslēgvārdus, kas atbilst Jūsu vēlmēm';

  @override
  String get selectTheOffersThatYouCanProvide =>
      'Izvēlieties piedāvājumus/lietas, ko varat sniegt';

  @override
  String get shareYourInterestsToFindBestMatches =>
      'Dalieties ar savām interesēm, lai atrastu labākās atbilstības ar citiem!';

  @override
  String get migrateToNewDevice => 'Pārcelt uz jaunu ierīci';

  @override
  String get migrateYourAccount => 'Pārcelt savu kontu';

  @override
  String get migrationCodeDescription =>
      'Ģenerējiet pārcelšanas kodu, lai pārsūtītu konta datus uz jaunu ierīci. Kods būs derīgs 15 minūtes.';

  @override
  String get generateMigrationCode => 'Ģenerēt pārcelšanas kodu';

  @override
  String get generating => 'Ģenerē...';

  @override
  String get yourMigrationCode => 'Jūsu pārcelšanas kods';

  @override
  String expiresIn(String time) {
    return 'Derīgs vēl: $time';
  }

  @override
  String get copyCode => 'Kopēt kodu';

  @override
  String get codeCopied => 'Pārcelšanas kods nokopēts starpliktuvē';

  @override
  String get generateNewCode => 'Ģenerēt jaunu kodu';

  @override
  String get migrationStep1 => 'Ģenerējiet pārcelšanas kodu';

  @override
  String get migrationStep2 => 'Atveriet lietotni jaunajā ierīcē';

  @override
  String get migrationStep3 =>
      'Sākumekrānā pieskarieties \"Ievietot esošo kontu\"';

  @override
  String get migrationStep4 => 'Ievadiet šo kodu jaunajā ierīcē';

  @override
  String get newDeviceDetected => 'Jauna ierīce konstatēta';

  @override
  String get newDeviceDetectedMessage =>
      'Jauna ierīce vēlas importēt jūsu konta datus. Vai vēlaties to atļaut?';

  @override
  String get deny => 'Aizliegt';

  @override
  String get allow => 'Atļaut';

  @override
  String get migrationDenied => 'Pārcelšana aizliegta lietotāja';

  @override
  String get migrationCompleted => 'Pārcelšana pabeigta veiksmīgi!';

  @override
  String get failedToSendMigration => 'Neizdevās nosūtīt pārcelšanas datus';

  @override
  String get migrationCodeExpired =>
      'Pārcelšanas kods ir beidzies. Lūdzu, ģenerējiet jaunu.';

  @override
  String get targetDeviceTimeout => 'Mērķa ierīce nepievienojās laikā';

  @override
  String get expired => 'Beidzies';

  @override
  String get importAccount => 'Ievietot kontu';

  @override
  String get importAccountDescription =>
      'Ievadiet 10 rakstzīmju pārcelšanas kodu no savas citas ierīces, lai importētu konta datus.';

  @override
  String get failedToJoinMigration =>
      'Neizdevās pievienoties pārcelšanas sesijai';

  @override
  String get failedToSendCode => 'Neizdevās nosūtīt atjaunošanas kodu';

  @override
  String get migrationTimedOut =>
      'Pārcelšanas laiks beidzies. Lūdzu, mēģiniet vēlreiz ar jaunu kodu.';

  @override
  String get failedToProcessMigration =>
      'Neizdevās apstrādāt pārcelšanas datus';

  @override
  String get clear => 'Notīrīt';

  @override
  String get importExistingAccount => 'Importēt eksistējošu kontu';

  @override
  String get targetStep1 => 'Atveriet lietotni savā citā ierīcē';

  @override
  String get targetStep2 => 'Dodieties uz Iestatījumi → Konts → Pārcelt ierīci';

  @override
  String get targetStep3 => 'Ievadiet kodu, kas redzams uz šīs ierīces';

  @override
  String get recoverViaEmail => 'Atjaunot pa e-pastu';

  @override
  String get recoverAccount => 'Atjaunot kontu';

  @override
  String get recoverAccountDescription =>
      'Ievadiet savu e-pasta adresi, lai saņemtu atjaunošanas kodu un atjaunotu savu kontu šajā ierīcē.';

  @override
  String get sendRecoveryCode => 'Nosūtīt atjaunošanas kodu';

  @override
  String codeSentTo(Object email) {
    return 'Atjaunošanas kods nosūtīts uz $email';
  }

  @override
  String get resendCode => 'Nosūtīt kodu vēlreiz';

  @override
  String resendCodeIn(Object seconds) {
    return 'Nosūtīt kodu pēc ${seconds}s';
  }

  @override
  String get verifyAndRecover => 'Verificēt un atjaunot';

  @override
  String get invalidCode => 'Nederīgs atjaunošanas kods';

  @override
  String get recoveryFailed => 'Konta atjaunošana neizdevās';

  @override
  String get recoverySuccess => 'Atjaunošana veiksmīga!';

  @override
  String get recoverySuccessMessage =>
      'Jūsu konts ir veiksmīgi atjaunots šajā ierīcē.';

  @override
  String get noUsersFound => 'Nav atrasti lietotāji';

  @override
  String get noPostingsFound => 'Nav atrasti sludinājumi';

  @override
  String get settingsGpsLocationTitle => 'Iespējot GPS atrašanās vietu';

  @override
  String get settingsGpsLocationEnabledDescription =>
      'GPS atrašanās vietas izsekošana ir iespējota';

  @override
  String get settingsGpsLocationDisabledDescription =>
      'GPS atrašanās vietas izsekošana ir atspējota';

  @override
  String get settingsGpsLocationDescription =>
      'Kad iespējots, varat pietuvināt karti līdz pašreizējai GPS atrašanās vietai. Lietotne pieprasīs atrašanās vietas atļaujas, kad nepieciešams.';

  @override
  String get locationPermissionRequiredDescription =>
      'Atrašanās vietas atļauja ir nepieciešama, lai izmantotu GPS atrašanās vietas izsekošanu. Lūdzu, iespējojiet atrašanās vietas atļauju ierīces iestatījumos.';

  @override
  String get openSettings => 'Atvērt iestatījumus';

  @override
  String get profilePanelTitle => 'Profils';

  @override
  String get requestCollectedDataExport => 'Pieprasīt savākto datu eksportu';

  @override
  String get dataExportRequestAccepted =>
      'Jūsu datu eksporta pieprasījums ir pieņemts.';

  @override
  String get dataExportRequestFailed => 'Neizdevās pieprasīt datu eksportu.';

  @override
  String get dataExportEmailRequired =>
      'Lūdzu, pievienojiet e-pastu paziņojumu preferencēs pirms datu eksporta pieprasījuma.';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'atsauksmes',
      one: 'atsauksme',
    );
    return '$count $_temp0';
  }

  @override
  String get premiumProfileEditorTitle => 'Premium profila redaktors';

  @override
  String get premiumProfileEditorHeader => 'Pielāgojiet savu Premium profilu';

  @override
  String get premiumProfileEditorDescription =>
      'Šeit varat atjaunināt savu vārdu, aprakstu, darba atsauces un avatara SVG.';

  @override
  String get premiumProfileEditorSaving => 'Saglabā...';

  @override
  String get premiumProfileEditorDisplayNameOptional =>
      'Parādāmais vārds (neobligāti)';

  @override
  String get premiumProfileEditorDescriptionOptional => 'Apraksts (neobligāti)';

  @override
  String get premiumProfileEditorAvatarSvg => 'Avatars (.svg)';

  @override
  String get premiumProfileEditorNoAvatarSvgSelected =>
      'Nav atlasīts avatara SVG.';

  @override
  String premiumProfileEditorSelectedFile(String fileName) {
    return 'Atlasīts: $fileName';
  }

  @override
  String get premiumProfileEditorUploadSvg => 'Augšupielādēt SVG';

  @override
  String get premiumProfileEditorRemoveSvg => 'Noņemt SVG';

  @override
  String get premiumProfileEditorWorkReferenceImages => 'Darbu atsauču attēli';

  @override
  String get premiumProfileEditorWorkReferenceDescription =>
      'Pievienojiet un pārvaldiet savus atsauču attēlus.';

  @override
  String get premiumProfileEditorNoWorkReferenceImages =>
      'Vēl nav darbu atsauču attēlu.';

  @override
  String get premiumProfileEditorReplace => 'Aizvietot';

  @override
  String get premiumProfileEditorAddImage => 'Pievienot attēlu';

  @override
  String get accountDeletionTitle => 'Dzēst kontu';

  @override
  String get accountDeletionHeader => 'Pieprasīt konta dzēšanu';

  @override
  String get accountDeletionInfo =>
      'Izmantojiet šo lapu, lai pieprasītu neatgriezenisku konta dzēšanu. Pēc procesa pabeigšanas jūsu profils un saistītie konta dati tiks dzēsti saskaņā ar mūsu datu glabāšanas politiku.';

  @override
  String get accountDeletionTokenInfo =>
      'Konta dzēšanas pieprasījums apstiprināts. Šī darbība ir neatgriezeniska un to nevar atsaukt.';

  @override
  String get accountDeletionSteps =>
      'Soļi:\n1. Ievadiet sava konta e-pastu\n2. Iesniedziet pieprasījumu, lai saņemtu verifikācijas kodu\n3. Ievadiet kodu, lai apstiprinātu dzēšanu';

  @override
  String get accountDeletionEmailLabel => 'Konta e-pasts';

  @override
  String get accountDeletionCodeLabel => 'Verifikācijas kods';

  @override
  String get accountDeletionCodeHint => 'Ievadiet kodu no e-pasta';

  @override
  String get accountDeletionSendCodeButton => 'Nosūtīt verifikācijas kodu';

  @override
  String get accountDeletionConfirmButton => 'Apstiprināt konta dzēšanu';

  @override
  String get accountDeletionCodeSent =>
      'Verifikācijas kods nosūtīts. Lūdzu, pārbaudiet savu e-pastu.';

  @override
  String get accountDeletionCodeInvalid =>
      'Lūdzu, ievadiet derīgu verifikācijas kodu.';

  @override
  String get accountDeletionSuccessMessage =>
      'Dzēšanas pieprasījums veiksmīgi iesniegts. Mūsu komanda apstrādās jūsu pieprasījumu, un konts tiks dzēsts pēc verifikācijas.';

  @override
  String get accountDeletionDataDeletedTitle =>
      'Pēc apstiprinājuma mēs neatgriezeniski dzēsīsim:';

  @override
  String get accountDeletionDataDeletedTitleAfterConfirmed =>
      'Jūsu lietotāja profils ir dzēsts, ar šādiem datiem:';

  @override
  String get accountDeletionDataDeletedItems =>
      '- Konta reģistrācijas datus un profilu\n- Ierīču atslēgas un migrācijas/atjaunošanas sesijas\n- Sludinājumus un saistītos augšupielādētos attēlus\n- Atribūtus, saites, ziņojumus un favorītu/atbilstību vēsturi\n- Ziņojumus, izlasīšanas statusus, šifrēto failu metadatus un čata atbilžu statistiku\n- Atsauksmes, reputāciju, darījumus, moderēšanas/apelāciju un atsauksmju audita datus\n- Paziņojumu kontaktus un paziņojumu iestatījumus\n- Klātbūtnes/aktivitātes keša ierakstus un saistītās analītikas/atrašanās vietas izsekošanas rindas';

  @override
  String get lastOnlinePrefix => 'Pēdējoreiz tiešsaistē:';

  @override
  String get lastOnlineUnknown => 'Nezināms';

  @override
  String get lastOnlineJustNow => 'tikko';

  @override
  String lastOnlineMinutesAgo(int count) {
    return 'pirms $count min';
  }

  @override
  String lastOnlineHoursAgo(int count) {
    return 'pirms $count st';
  }

  @override
  String lastOnlineDaysAgo(int count) {
    return 'pirms $count d';
  }
}
