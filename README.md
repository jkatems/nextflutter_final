# FocusFlow

**Un peu de clarté, beaucoup de possibilités.** Une application Flutter de gestion de tâches personnelle, en français et en anglais, avec sauvegarde locale et interface adaptative.

[![Flutter CI](https://github.com/jkatems/nextflutter_final/actions/workflows/ci.yml/badge.svg)](https://github.com/jkatems/nextflutter_final/actions/workflows/ci.yml)
![Flutter 3.41.9](https://img.shields.io/badge/Flutter-3.41.9-02569B?logo=flutter)
![Version 1.3.0](https://img.shields.io/badge/version-1.3.0-254D3F)

Le badge affiche l’état réel du workflow GitHub. Les résultats locaux détaillés sont fournis dans [docs/quality/SUMMARY.md](docs/quality/SUMMARY.md).

## Livrable à remettre pour évaluation

Consulter d’abord la [matrice des exigences et preuves](docs/REQUIREMENTS.md). Pour produire l’archive source complète :

```sh
./scripts/verify.sh
# Puis intégration web et benchmark comme indiqué plus bas.
python3 scripts/package_source.py
```

Le fichier **`dist/focusflow-source-1.3.0.zip`** inclut `lib/`, `test/`, `integration_test/`, les workflows, le CHANGELOG, les captures et les rapports. Son manifeste contient le SHA-256 de chaque fichier. Le script refuse une remise sans tests, sans rapports ou dont les sources ont changé depuis les tests. Une archive `build/web` sert à exécuter l’application ; les sources et tests Flutter sont dans l’archive source.

## Aperçu

![Accueil FocusFlow, capture réelle de l’application](docs/screenshots/01-overview-fr.png)

| Créer une tâche | Retrouver ses tâches |
| --- | --- |
| ![Création](docs/screenshots/02-create-fr.png) | ![Recherche](docs/screenshots/03-tasks-fr.png) |

| Détail | Statistiques | Anglais et thème sombre |
| --- | --- | --- |
| ![Détail](docs/screenshots/04-detail-fr.png) | ![Statistiques](docs/screenshots/05-insights-fr.png) | ![Paramètres](docs/screenshots/06-settings-en-dark.png) |

### Sur mobile

<img src="docs/screenshots/mobile/01-overview-fr.png" alt="Accueil mobile FocusFlow" width="250"> <img src="docs/screenshots/mobile/03-tasks-fr.png" alt="Tâches sur mobile" width="250"> <img src="docs/screenshots/mobile/06-settings-en-dark.png" alt="Paramètres en anglais sur mobile" width="250">

Captures produites par les tests d’intégration sur un navigateur réel, et non par des maquettes.

## Fonctionnalités

1. **Accueil** : prochaines tâches, compteurs, accès aux espaces.
2. **Mes tâches** : recherche dans les titres/notes, filtres par état et catégorie, liste paresseuse.
3. **Détail** : notes, échéance, priorité, validation/réouverture et suppression confirmée.
4. **Création / modification** : validation, date native localisée, conservation des saisies en cas d’erreur.
5. **Statistiques** : taux de réalisation et répartition par espace, calculés sur les données présentes.
6. **Paramètres** : français/anglais et thème clair/sombre persistants, explication du stockage.

Travail, Personnel, Bien-être ; états vide, chargement, aucun résultat et erreur ; navigation latérale sur bureau et barre inférieure sur mobile. Les tâches d’exemple sont créées uniquement au premier lancement. Les contenus saisis ne sont pas traduits automatiquement.

## Installation

Prérequis : **Flutter 3.41.9 / Dart 3.11.5**, Chrome/Chromium pour le web ; Android SDK et JDK 17 pour Android ; macOS/Xcode pour iOS.

```sh
flutter pub get --enforce-lockfile
flutter gen-l10n
flutter run -d chrome
# ou : flutter run -d <identifiant-appareil>
```

Aucun compte, secret API ou backend n’est nécessaire. `pubspec.lock` est inclus pour reproduire les versions. Vérifier l’environnement avec `flutter doctor -v`.

## Architecture

```text
lib/
  bootstrap.dart            Composition et injection des dépendances
  domain/                   Task, AppSnapshot, contrat AppRepository
  data/                     Adaptateur SharedPreferences, données d’exemple
  state/app_controller.dart Commandes, état encapsulé, erreurs typées
  ui/app.dart               Racine localisée de l’application
  ui/app_shell.dart         Navigation adaptative et états globaux
  ui/screens/               Un fichier par écran (six écrans)
  ui/widgets/               Widgets partagés, données et callbacks uniquement
  ui/theme/                 Thèmes clair/sombre
  ui/navigation.dart        Ouverture des détails et du formulaire
  ui/formatters.dart        Labels et dates localisés
  l10n/app_{fr,en}.arb       Sources générées avec Flutter gen-l10n
```

Les [frontières architecturales](docs/ARCHITECTURE.md) sont vérifiées en CI. Les widgets d’écran appellent le contrôleur, qui valide puis écrit via le repository. Le nouvel état n’est publié qu’après réussite de la sauvegarde. Une écriture échouée conserve le dernier état validé ; une lecture invalide conserve les données et affiche un réessai. Les tests utilisent une horloge injectée et un repository mémoire ; l’intégration utilise le véritable adaptateur SharedPreferences.

`ChangeNotifier` suffit à cet état local, sans framework supplémentaire. Un `ValueNotifier` distinct limite les reconstructions de `MaterialApp` aux changements de langue/thème. Les constructeurs `const` et les listes `builder` limitent le travail du rendu.

## Tests et qualité

```sh
flutter analyze --no-pub --fatal-infos
flutter test --no-pub --coverage
python3 scripts/check_coverage.py
# Analyse, tests et build web regroupés :
./scripts/verify.sh
```

- **40 tests unitaires** : modèles, validation, filtres, statistiques, repository, corruption, erreurs et concurrence des sauvegardes.
- **19 tests widgets** : navigation, formulaire, recherche, filtres, langue, thème, confirmation, erreurs, écran de 320 px et texte à 200 %, accessibilité.
- **2 tests d’intégration** : création → validation → rechargement du stockage ; édition → langue/thème → redémarrage du contrôleur → suppression confirmée.
- **1 scénario de performance** : 1 000 tâches en mode profile, avec export des temps de construction et de rasterisation.
- Seuil CI : **90 % de couverture des lignes métier** (`domain`, `data`, `state`), sans gonfler le résultat avec les fichiers de traduction générés.

### Intégration web

Installer Chrome et le ChromeDriver de version correspondante, puis :

```sh
CHROME_BINARY=/chemin/vers/chrome \
CHROMEDRIVER=/chemin/vers/chromedriver \
./scripts/test_web.sh
```

Le script démarre et arrête ChromeDriver, exécute les deux parcours et régénère les captures. Utiliser un profil/appareil de test : la suite utilise une clé de test séparée des données utilisateur. Sur Android : `flutter test integration_test/app_test.dart -d DEVICE_ID` (sans l’option `SCREENSHOTS`).

Les rapports [JSON/JUnit/LCOV et couverture HTML](docs/quality/SUMMARY.md) sont inclus. La couverture métier actuelle est de **98,8 %** (165/167 lignes), avec **100 % des lignes du contrôleur** couvertes. Les preuves et limites de validation sont consignées dans [docs/VALIDATION.md](docs/VALIDATION.md).

Les catalogues [`app_fr.arb`](lib/l10n/app_fr.arb) et [`app_en.arb`](lib/l10n/app_en.arb) contiennent chacun **76 messages**. `python3 scripts/check_localizations.py` vérifie leurs clés, textes et arguments ICU en CI ; son [rapport](docs/quality/localizations.json) complète les tests de bascule de langue et les tests widgets des six écrans dans les deux langues.

## Performance et accessibilité

Photos **WebP 640 × 400**, embarquées et décodées à la demande avec `cacheWidth`, liste de tâches paresseuse et police locale. Voir les [sources des assets](docs/ASSETS.md).

Les boutons natifs exposent leurs libellés ; les cases de validation, liens de tâche et indicateurs ont une sémantique explicite. Les tests vérifient les cibles tactiles Android/iOS, les libellés et le contraste sur les six écrans dans les quatre variantes FR/EN × clair/sombre. Voir [le détail de l’accessibilité](docs/ACCESSIBILITY.md). Le texte à 200 % est testé sur les quatre destinations de navigation. Une recette TalkBack/VoiceOver sur appareil reste nécessaire.

Le benchmark Linux natif de cette version a mesuré **476 frames**, avec un p99 de **5,844 ms** en construction et **5,02 ms** en rasterisation. Le projet est optimisé pour viser 60 FPS, mais **60 FPS constants ne sont pas certifiés sans profilage physique**. Le [protocole et le benchmark](docs/PERFORMANCE.md) sont fournis, avec un budget p99 de 16,67 ms.

## CI/CD et livraison

[Flutter CI](.github/workflows/ci.yml) exécute sur push/PR : formatage, analyse stricte, tests, couverture, intégration Chrome, puis produit l’archive web release, un bundle Android non signé et une archive source complète. Les rapports JSON, JUnit, LCOV et HTML sont publiés comme artefacts CI. Aucun secret n’est requis pour ces contrôles.

[Deploy web to GitHub Pages](.github/workflows/deploy.yml) permet une publication manuelle, précédée des mêmes validations. Activer GitHub Pages avec la source GitHub Actions avant son premier lancement.

```sh
flutter build web --release --no-pub --no-web-resources-cdn
flutter build appbundle --release
# APK installable de démonstration, signé avec la clé de développement :
flutter build apk --debug
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

La génération locale de l’APK a échoué lors du téléchargement des dépendances Gradle ; aucun APK n’est inclus dans cette remise ([log](docs/quality/build-android-demo.txt)). La CI est configurée pour joindre l’APK sous l’artefact **`focusflow-android-demo`**. Cet APK sert à la démonstration ; la distribution en boutique nécessite la signature release décrite ci-dessous. Un IPA nécessite macOS, Xcode et une identité de signature Apple.

Consulter [la procédure de production](docs/PRODUCTION.md) pour la signature Android, iOS, l’hébergement, le stockage et les contrôles avant publication. La version web fonctionne sans réseau après chargement, mais sa réouverture hors ligne n’est pas garantie. Les ressources natives sont embarquées.

## Historique

[CHANGELOG.md](CHANGELOG.md) documente les incréments **1.0.0**, **1.1.0**, **1.2.0** et **1.3.0** réalisés pour ce projet. Ils ne correspondent pas à des publications déjà effectuées sur les stores.
