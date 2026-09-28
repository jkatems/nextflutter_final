import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../domain/task.dart';
import '../l10n/app_localizations.dart';

String categoryLabel(AppLocalizations l, TaskCategory c) => switch (c) {
  TaskCategory.work => l.work,
  TaskCategory.personal => l.personal,
  TaskCategory.wellbeing => l.wellbeing,
};
String priorityLabel(AppLocalizations l, TaskPriority p) => switch (p) {
  TaskPriority.low => l.low,
  TaskPriority.medium => l.medium,
  TaskPriority.high => l.high,
};
IconData categoryIcon(TaskCategory c) => switch (c) {
  TaskCategory.work => Icons.work_outline_rounded,
  TaskCategory.personal => Icons.auto_awesome_outlined,
  TaskCategory.wellbeing => Icons.spa_outlined,
};
String dateLabel(BuildContext context, DateTime date) =>
    DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(date);
