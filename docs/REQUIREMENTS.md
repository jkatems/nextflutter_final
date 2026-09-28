# Matrice de conformité pour l’évaluation

Le livrable à évaluer est **l’archive source** `focusflow-source-1.3.0.zip`, générée par `python3 scripts/package_source.py`. Elle inclut les tests et les preuves. `build/web` est un artefact d’exécution compilé : il ne permet pas d’évaluer les sources et les tests Flutter.

| Exigence | Réalisation / preuve vérifiable |
| --- | --- |
| Au moins 5 écrans | 6 fichiers dans `lib/ui/screens/`, captures bureau et mobile dans `docs/screenshots/` |
| Au moins 10 tests unitaires | 40 tests exécutés dans `test/unit/`, inventaire généré dans `quality/summary.json` |
| Au moins 5 tests widgets | 19 tests exécutés dans `test/widgets/`, dont accessibilité et liste de 1 000 tâches |
| Au moins 2 tests d’intégration | `integration_test/app_test.dart`, vrai stockage avec namespace isolé, log dans `quality/integration-web.txt` |
| Performance | Benchmark natif **profile**, 1 000 tâches, résultats bruts dans `benchmarks/linux-profile.json`, protocole dans `PERFORMANCE.md` |
| 60 FPS constants | Budget testé sur Linux ; garantie Android/iOS à mesurer sur appareil physique cible |
| Images optimisées / lazy | WebP 640 × 400, `cacheWidth: 640`, sections en `ListView.builder` ; tâches en `SliverList.builder` |
| Rebuilds | Widgets `const`, séparation du notifier des préférences ; test d’absence de notification de thème/langue lors d’une mutation |
| Accessibilité | `Semantics`, libellés, cibles tactiles Android/iOS et contraste testés sur 6 écrans × 4 variantes ; détails dans `ACCESSIBILITY.md` |
| FR + EN | 76 messages par langue dans `lib/l10n/`, génération Flutter et pluriels ICU, tests de bascule ; rapport `quality/localizations.json` |
| CI/CD | `.github/workflows/ci.yml`, lint/tests/rapports/builds/archives, `.github/workflows/deploy.yml` pour Pages |
| Analyse statique propre | Résultat intégral dans `quality/analyze.txt` |
| README professionnel | Architecture, setup, commandes, captures, badge lié au dépôt GitHub réel, liens vers les preuves |
| APK / IPA de démonstration | APK configuré en CI ; build local bloqué par les téléchargements Gradle, log `quality/build-android-demo.txt`. IPA non généré (macOS/signature Apple requis). |
| CHANGELOG ≥ 3 versions | `CHANGELOG.md`, versions 1.0.0, 1.1.0, 1.2.0, 1.3.0 |

Les nombres de tests de cette matrice sont contrôlables dans [le résumé généré](quality/SUMMARY.md). Le [rapport de validation](VALIDATION.md) distingue les vérifications locales, les workflows configurés et les limites de validation sur mobile.

L’archive contient `SUBMISSION_MANIFEST.json`, avec le SHA-256 de chaque fichier inclus, et le packaging échoue si les tests ou preuves obligatoires manquent. Le rapport qualité porte aussi une empreinte des sources qu’il décrit.
