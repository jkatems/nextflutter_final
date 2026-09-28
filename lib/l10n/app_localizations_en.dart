// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'FocusFlow';

  @override
  String get home => 'Overview';

  @override
  String get tasks => 'My tasks';

  @override
  String get stats => 'Insights';

  @override
  String get settings => 'Settings';

  @override
  String get greeting => 'A little clarity,\na world of possibilities.';

  @override
  String get welcome => 'YOUR PERSONAL SPACE';

  @override
  String get subtitle => 'Make room for what truly matters.';

  @override
  String get newTask => 'New task';

  @override
  String get today => 'Your next step';

  @override
  String get seeAll => 'View all';

  @override
  String get heroTitle => 'One thing at a time.';

  @override
  String get heroBody =>
      'Big ideas start with small steps.\nChoose your next action.';

  @override
  String get heroAction => 'Plan my day';

  @override
  String get total => 'Total tasks';

  @override
  String get pending => 'To do';

  @override
  String get completed => 'Completed';

  @override
  String get progress => 'Your progress';

  @override
  String get spaces => 'A space for everything';

  @override
  String get work => 'Work';

  @override
  String get personal => 'Personal';

  @override
  String get wellbeing => 'Wellbeing';

  @override
  String get all => 'All';

  @override
  String get search => 'Search tasks';

  @override
  String get emptyTitle => 'A little breathing room.';

  @override
  String get emptyBody => 'No tasks here. Create your next small win.';

  @override
  String get noResults => 'No results';

  @override
  String get noResultsBody => 'Try another word or change your filters.';

  @override
  String get title => 'Title';

  @override
  String get notes => 'Notes';

  @override
  String get category => 'Space';

  @override
  String get priority => 'Priority';

  @override
  String get low => 'Low';

  @override
  String get medium => 'Normal';

  @override
  String get high => 'High';

  @override
  String get dueDate => 'Due date';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get requiredTitle => 'Add a title to continue.';

  @override
  String get longTitle => '100 characters maximum.';

  @override
  String get longNotes => '2,000 characters maximum.';

  @override
  String get editTask => 'Edit task';

  @override
  String get taskDetail => 'Details matter';

  @override
  String get markDone => 'Mark as completed';

  @override
  String get markPending => 'Mark as to do';

  @override
  String get delete => 'Delete';

  @override
  String get deleteTitle => 'Delete this task?';

  @override
  String get deleteBody =>
      'This action is permanent. Your other tasks will be kept.';

  @override
  String get noNotes => 'No notes just yet.';

  @override
  String get overdue => 'Overdue';

  @override
  String get language => 'Language';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get localFirst => 'Your day belongs to you.';

  @override
  String get privacyBody =>
      'Your tasks are saved on this device. No account, no ads, no data transfers. Keep a copy of important information: uninstalling the app or clearing browser data deletes this local backup.';

  @override
  String get about => 'About';

  @override
  String get version => 'Version 1.2.0 · A little more focused';

  @override
  String get settingsSubtitle => 'Make yourself at home.';

  @override
  String get statsSubtitle => 'Every small step deserves a little recognition.';

  @override
  String get completionRate => 'Completion rate';

  @override
  String get byCategory => 'Your balance';

  @override
  String get statsNote =>
      'These numbers reflect all currently saved tasks, regardless of their due dates.';

  @override
  String get loadError =>
      'Your data could not be read. It has been preserved. Check storage and try again.';

  @override
  String get saveError =>
      'Could not save. Your change was not applied. Check storage and try again.';

  @override
  String get retry => 'Try again';

  @override
  String get offline => 'Offline, and at ease';

  @override
  String get back => 'Back';

  @override
  String get taskMissing => 'This task no longer exists.';

  @override
  String get demoNotice =>
      'A few example tasks to get started. Make them your own.';

  @override
  String get taskSaved => 'Task saved';

  @override
  String get taskDeleted => 'Task deleted';

  @override
  String get themeHint => 'A softer display when the light fades.';

  @override
  String countTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '1 task',
      zero: 'No tasks',
    );
    return '$_temp0';
  }

  @override
  String completeTask(String title) {
    return 'Complete: $title';
  }

  @override
  String reopenTask(String title) {
    return 'Reopen: $title';
  }

  @override
  String openTask(String title) {
    return 'Open: $title';
  }
}
