import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'FocusFlow'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In fr, this message translates to:
  /// **'Vue d’ensemble'**
  String get home;

  /// No description provided for @tasks.
  ///
  /// In fr, this message translates to:
  /// **'Mes tâches'**
  String get tasks;

  /// No description provided for @stats.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get stats;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @greeting.
  ///
  /// In fr, this message translates to:
  /// **'Un peu de clarté,\nbeaucoup de possibilités.'**
  String get greeting;

  /// No description provided for @welcome.
  ///
  /// In fr, this message translates to:
  /// **'VOTRE ESPACE PERSONNEL'**
  String get welcome;

  /// No description provided for @subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Faites de la place à ce qui compte vraiment.'**
  String get subtitle;

  /// No description provided for @newTask.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle tâche'**
  String get newTask;

  /// No description provided for @today.
  ///
  /// In fr, this message translates to:
  /// **'Votre prochain pas'**
  String get today;

  /// No description provided for @seeAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout voir'**
  String get seeAll;

  /// No description provided for @heroTitle.
  ///
  /// In fr, this message translates to:
  /// **'Une chose à la fois.'**
  String get heroTitle;

  /// No description provided for @heroBody.
  ///
  /// In fr, this message translates to:
  /// **'Les grandes idées commencent par de petits pas.\nChoisissez votre prochaine action.'**
  String get heroBody;

  /// No description provided for @heroAction.
  ///
  /// In fr, this message translates to:
  /// **'Organiser ma journée'**
  String get heroAction;

  /// No description provided for @total.
  ///
  /// In fr, this message translates to:
  /// **'Au total'**
  String get total;

  /// No description provided for @pending.
  ///
  /// In fr, this message translates to:
  /// **'À faire'**
  String get pending;

  /// No description provided for @completed.
  ///
  /// In fr, this message translates to:
  /// **'Terminées'**
  String get completed;

  /// No description provided for @progress.
  ///
  /// In fr, this message translates to:
  /// **'Votre progression'**
  String get progress;

  /// No description provided for @spaces.
  ///
  /// In fr, this message translates to:
  /// **'À chacun son espace'**
  String get spaces;

  /// No description provided for @work.
  ///
  /// In fr, this message translates to:
  /// **'Travail'**
  String get work;

  /// No description provided for @personal.
  ///
  /// In fr, this message translates to:
  /// **'Personnel'**
  String get personal;

  /// No description provided for @wellbeing.
  ///
  /// In fr, this message translates to:
  /// **'Bien-être'**
  String get wellbeing;

  /// No description provided for @all.
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get all;

  /// No description provided for @search.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une tâche'**
  String get search;

  /// No description provided for @emptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'L’esprit libre.'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Aucune tâche ici. Créez votre prochaine petite victoire.'**
  String get emptyBody;

  /// No description provided for @noResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get noResults;

  /// No description provided for @noResultsBody.
  ///
  /// In fr, this message translates to:
  /// **'Essayez un autre mot ou modifiez vos filtres.'**
  String get noResultsBody;

  /// No description provided for @title.
  ///
  /// In fr, this message translates to:
  /// **'Titre'**
  String get title;

  /// No description provided for @notes.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @category.
  ///
  /// In fr, this message translates to:
  /// **'Espace'**
  String get category;

  /// No description provided for @priority.
  ///
  /// In fr, this message translates to:
  /// **'Priorité'**
  String get priority;

  /// No description provided for @low.
  ///
  /// In fr, this message translates to:
  /// **'Douce'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In fr, this message translates to:
  /// **'Normale'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In fr, this message translates to:
  /// **'Haute'**
  String get high;

  /// No description provided for @dueDate.
  ///
  /// In fr, this message translates to:
  /// **'Échéance'**
  String get dueDate;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @requiredTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez un titre pour continuer.'**
  String get requiredTitle;

  /// No description provided for @longTitle.
  ///
  /// In fr, this message translates to:
  /// **'100 caractères maximum.'**
  String get longTitle;

  /// No description provided for @longNotes.
  ///
  /// In fr, this message translates to:
  /// **'2 000 caractères maximum.'**
  String get longNotes;

  /// No description provided for @editTask.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la tâche'**
  String get editTask;

  /// No description provided for @taskDetail.
  ///
  /// In fr, this message translates to:
  /// **'Le détail compte'**
  String get taskDetail;

  /// No description provided for @markDone.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme terminée'**
  String get markDone;

  /// No description provided for @markPending.
  ///
  /// In fr, this message translates to:
  /// **'Remettre à faire'**
  String get markPending;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @deleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cette tâche ?'**
  String get deleteTitle;

  /// No description provided for @deleteBody.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est définitive. Vos autres tâches seront conservées.'**
  String get deleteBody;

  /// No description provided for @noNotes.
  ///
  /// In fr, this message translates to:
  /// **'Aucune note pour le moment.'**
  String get noNotes;

  /// No description provided for @overdue.
  ///
  /// In fr, this message translates to:
  /// **'En retard'**
  String get overdue;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @appearance.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode sombre'**
  String get darkMode;

  /// No description provided for @localFirst.
  ///
  /// In fr, this message translates to:
  /// **'Votre quotidien reste le vôtre.'**
  String get localFirst;

  /// No description provided for @privacyBody.
  ///
  /// In fr, this message translates to:
  /// **'Vos tâches sont enregistrées sur cet appareil. Aucun compte, aucune publicité, aucun transfert de données. Pensez à conserver une copie de vos informations importantes : désinstaller l’application ou effacer les données du navigateur supprime cette sauvegarde.'**
  String get privacyBody;

  /// No description provided for @about.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get about;

  /// No description provided for @version.
  ///
  /// In fr, this message translates to:
  /// **'Version 1.3.0 · Fait pour avancer sereinement'**
  String get version;

  /// No description provided for @settingsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Un espace qui vous ressemble.'**
  String get settingsSubtitle;

  /// No description provided for @statsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Chaque petit pas mérite d’être remarqué.'**
  String get statsSubtitle;

  /// No description provided for @completionRate.
  ///
  /// In fr, this message translates to:
  /// **'Taux de réalisation'**
  String get completionRate;

  /// No description provided for @byCategory.
  ///
  /// In fr, this message translates to:
  /// **'Votre équilibre'**
  String get byCategory;

  /// No description provided for @statsNote.
  ///
  /// In fr, this message translates to:
  /// **'Ces chiffres reflètent les tâches actuellement enregistrées, toutes échéances confondues.'**
  String get statsNote;

  /// No description provided for @loadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de lire vos données. Elles ont été conservées. Réessayez après avoir vérifié le stockage.'**
  String get loadError;

  /// No description provided for @saveError.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement impossible. Votre modification n’a pas été appliquée. Vérifiez le stockage et réessayez.'**
  String get saveError;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @offline.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne, l’esprit tranquille'**
  String get offline;

  /// No description provided for @back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// No description provided for @taskMissing.
  ///
  /// In fr, this message translates to:
  /// **'Cette tâche n’existe plus.'**
  String get taskMissing;

  /// No description provided for @demoNotice.
  ///
  /// In fr, this message translates to:
  /// **'Quelques tâches d’exemple pour commencer. Adaptez-les à votre quotidien.'**
  String get demoNotice;

  /// No description provided for @taskSaved.
  ///
  /// In fr, this message translates to:
  /// **'Tâche enregistrée'**
  String get taskSaved;

  /// No description provided for @taskDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Tâche supprimée'**
  String get taskDeleted;

  /// No description provided for @themeHint.
  ///
  /// In fr, this message translates to:
  /// **'Un affichage plus doux quand la lumière baisse.'**
  String get themeHint;

  /// No description provided for @countTasks.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune tâche} =1{1 tâche} other{{count} tâches}}'**
  String countTasks(int count);

  /// No description provided for @completeTask.
  ///
  /// In fr, this message translates to:
  /// **'Terminer : {title}'**
  String completeTask(String title);

  /// No description provided for @reopenTask.
  ///
  /// In fr, this message translates to:
  /// **'Rouvrir : {title}'**
  String reopenTask(String title);

  /// No description provided for @openTask.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir : {title}'**
  String openTask(String title);
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
