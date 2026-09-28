// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'FocusFlow';

  @override
  String get home => 'Vue d’ensemble';

  @override
  String get tasks => 'Mes tâches';

  @override
  String get stats => 'Statistiques';

  @override
  String get settings => 'Paramètres';

  @override
  String get greeting => 'Un peu de clarté,\nbeaucoup de possibilités.';

  @override
  String get welcome => 'VOTRE ESPACE PERSONNEL';

  @override
  String get subtitle => 'Faites de la place à ce qui compte vraiment.';

  @override
  String get newTask => 'Nouvelle tâche';

  @override
  String get today => 'Votre prochain pas';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get heroTitle => 'Une chose à la fois.';

  @override
  String get heroBody =>
      'Les grandes idées commencent par de petits pas.\nChoisissez votre prochaine action.';

  @override
  String get heroAction => 'Organiser ma journée';

  @override
  String get total => 'Au total';

  @override
  String get pending => 'À faire';

  @override
  String get completed => 'Terminées';

  @override
  String get progress => 'Votre progression';

  @override
  String get spaces => 'À chacun son espace';

  @override
  String get work => 'Travail';

  @override
  String get personal => 'Personnel';

  @override
  String get wellbeing => 'Bien-être';

  @override
  String get all => 'Toutes';

  @override
  String get search => 'Rechercher une tâche';

  @override
  String get emptyTitle => 'L’esprit libre.';

  @override
  String get emptyBody =>
      'Aucune tâche ici. Créez votre prochaine petite victoire.';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get noResultsBody => 'Essayez un autre mot ou modifiez vos filtres.';

  @override
  String get title => 'Titre';

  @override
  String get notes => 'Notes';

  @override
  String get category => 'Espace';

  @override
  String get priority => 'Priorité';

  @override
  String get low => 'Douce';

  @override
  String get medium => 'Normale';

  @override
  String get high => 'Haute';

  @override
  String get dueDate => 'Échéance';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get requiredTitle => 'Ajoutez un titre pour continuer.';

  @override
  String get longTitle => '100 caractères maximum.';

  @override
  String get longNotes => '2 000 caractères maximum.';

  @override
  String get editTask => 'Modifier la tâche';

  @override
  String get taskDetail => 'Le détail compte';

  @override
  String get markDone => 'Marquer comme terminée';

  @override
  String get markPending => 'Remettre à faire';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteTitle => 'Supprimer cette tâche ?';

  @override
  String get deleteBody =>
      'Cette action est définitive. Vos autres tâches seront conservées.';

  @override
  String get noNotes => 'Aucune note pour le moment.';

  @override
  String get overdue => 'En retard';

  @override
  String get language => 'Langue';

  @override
  String get appearance => 'Apparence';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get localFirst => 'Votre quotidien reste le vôtre.';

  @override
  String get privacyBody =>
      'Vos tâches sont enregistrées sur cet appareil. Aucun compte, aucune publicité, aucun transfert de données. Pensez à conserver une copie de vos informations importantes : désinstaller l’application ou effacer les données du navigateur supprime cette sauvegarde.';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version 1.2.0 · Fait pour avancer sereinement';

  @override
  String get settingsSubtitle => 'Un espace qui vous ressemble.';

  @override
  String get statsSubtitle => 'Chaque petit pas mérite d’être remarqué.';

  @override
  String get completionRate => 'Taux de réalisation';

  @override
  String get byCategory => 'Votre équilibre';

  @override
  String get statsNote =>
      'Ces chiffres reflètent les tâches actuellement enregistrées, toutes échéances confondues.';

  @override
  String get loadError =>
      'Impossible de lire vos données. Elles ont été conservées. Réessayez après avoir vérifié le stockage.';

  @override
  String get saveError =>
      'Enregistrement impossible. Votre modification n’a pas été appliquée. Vérifiez le stockage et réessayez.';

  @override
  String get retry => 'Réessayer';

  @override
  String get offline => 'Hors ligne, l’esprit tranquille';

  @override
  String get back => 'Retour';

  @override
  String get taskMissing => 'Cette tâche n’existe plus.';

  @override
  String get demoNotice =>
      'Quelques tâches d’exemple pour commencer. Adaptez-les à votre quotidien.';

  @override
  String get taskSaved => 'Tâche enregistrée';

  @override
  String get taskDeleted => 'Tâche supprimée';

  @override
  String get themeHint => 'Un affichage plus doux quand la lumière baisse.';

  @override
  String countTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tâches',
      one: '1 tâche',
      zero: 'Aucune tâche',
    );
    return '$_temp0';
  }

  @override
  String completeTask(String title) {
    return 'Terminer : $title';
  }

  @override
  String reopenTask(String title) {
    return 'Rouvrir : $title';
  }

  @override
  String openTask(String title) {
    return 'Ouvrir : $title';
  }
}
