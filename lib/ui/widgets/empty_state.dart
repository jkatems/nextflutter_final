import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.filtered});
  final bool filtered;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          Icon(
            filtered ? Icons.search_off_rounded : Icons.check_circle_outline,
            size: 52,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 20),
          Text(
            filtered ? l.noResults : l.emptyTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            filtered ? l.noResultsBody : l.emptyBody,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
