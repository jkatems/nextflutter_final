import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../state/app_controller.dart';
import '../widgets/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller});
  final AppController controller;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return PageBody(
      children: [
        PageHeader(title: l.settings, subtitle: l.settingsSubtitle),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.language, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  children: [
                    for (final language in ['fr', 'en'])
                      ChoiceChip(
                        key: Key('language-$language'),
                        label: Text(language == 'fr' ? 'Français' : 'English'),
                        selected: controller.snapshot.language == language,
                        onSelected: controller.busy
                            ? null
                            : (_) => controller.setLanguage(language),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  l.appearance,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SwitchListTile(
                  key: const Key('darkMode'),
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.darkMode),
                  subtitle: Text(l.themeHint),
                  value: controller.snapshot.dark,
                  onChanged: controller.busy ? null : controller.setDark,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lock_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  l.localFirst,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(l.privacyBody),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(l.about, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Text(l.version),
      ],
    );
  }
}
