# CI/CD et diagnostic Android

Le dépôt est [jkatems/nextflutter_final](https://github.com/jkatems/nextflutter_final). Le README pointe vers son badge GitHub Actions réel, sans badge de réussite simulé.

## Échec distant identifié

Sur le [run 36442332118](https://github.com/jkatems/nextflutter_final/actions/runs/36442332118), les jobs `quality`, `integration` et `release-web` ont réussi. Le job `android` a échoué dans `:app:compileReleaseJavaWithJavac` avec :

```text
package dev.flutter.plugins.integration_test does not exist
```

Cause : après `flutter pub get`, `flutter build appbundle --release --no-pub` laisse une référence au plugin de test dans `GeneratedPluginRegistrant.java`, alors que Gradle exclut les dépendances de développement en release. Cette interaction est documentée dans [flutter/flutter#169336](https://github.com/flutter/flutter/issues/169336).

Correction : conserver la résolution initiale verrouillée, puis utiliser **`flutter build appbundle --release`**, ce qui laisse Flutter régénérer ses fichiers pour la release. Aucun fichier généré n’est édité manuellement et `integration_test` reste une dépendance de développement. `setup-java` utilise désormais la version majeure 5.

Le badge distant ne change qu’après un push suivi d’un nouveau run ; les modifications de cette correction sont locales tant qu’elles n’ont pas été poussées.

## Artefacts et critères bloquants

- `quality-evidence` : analyse, résultats machine Flutter, JUnit, LCOV, résumé JSON avec empreinte des sources, couverture HTML.
- `integration-evidence` : captures et log des deux parcours sur stockage réel isolé.
- `focusflow-web-release` : build release, après tests et intégration.
- `focusflow-android-unsigned` : bundle Android non signé, après les tests.
- `focusflow-complete-source` : archive de remise avec manifeste ; télécharge les rapports frais des jobs précédents.

La CI échoue si l’analyse ou le formatage échoue, si les frontières architecturales sont violées, si un test échoue ou est ignoré, si les minima de tests ne sont pas satisfaits, ou si la couverture métier descend sous 90 %.

Le déploiement Pages reste manuel, avec les validations avant publication. Les signatures mobiles et la recette physique restent décrites dans [PRODUCTION.md](PRODUCTION.md).
