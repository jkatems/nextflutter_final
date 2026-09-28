# Rapport de validation — 28 septembre 2026

Environnement : Linux x64, Flutter **3.41.9**, Dart **3.11.5**, Chromium / ChromeDriver **152.0.7977.82**.

| Contrôle | Résultat observé |
| --- | --- |
| Analyse Flutter avec `--fatal-infos` | Aucun problème, warning ou info |
| Tests unitaires | 32 réussis |
| Tests widgets | 13 réussis |
| Couverture métier | 150 / 152 lignes, **98,7 %** |
| Intégration web, bureau | 2 scénarios réussis, `failureDetails: []` |
| Intégration web, mobile 430 × 932 | Les mêmes 2 scénarios réussis, captures dans `screenshots/mobile` |
| Captures réelles | Six écrans, français clair et paramètres anglais sombre, inspectés visuellement |
| Construction web release | Réussie, CanvasKit embarqué sans CDN |
| Benchmark Linux natif profile | Réussi : 411 frames, p99 build 2,064 ms / raster 2,474 ms, zéro dépassement des deux budgets |
| YAML des workflows | Deux fichiers parsés, quatre jobs CI et deux jobs de déploiement |
| Parité des traductions | 76 messages dans chaque langue, pluriels ICU et dates localisées |

Commandes utilisées :

```sh
flutter analyze --no-pub --fatal-infos
flutter test --no-pub --coverage
python3 scripts/check_coverage.py
CHROME_BINARY=/usr/lib64/chromium-browser/chromium-browser \
CHROMEDRIVER=/tmp/focusflow-webdriver/chromedriver-linux64/chromedriver \
./scripts/test_web.sh
flutter build web --release --no-pub --no-web-resources-cdn
```

Le rechargement vérifié par intégration détruit le widget racine et le contrôleur, recharge SharedPreferences puis recrée l’application. Il valide la lecture de la sauvegarde réelle ; ce n’est pas un arrêt/redémarrage du processus OS complet.

## Corrections issues des tests

- Texte agrandi : accueil et marque contraints pour éviter les débordements à 320 px / 200 %.
- Indicateurs de progression : valeur sémantique numérique compatible avec le moteur Flutter.
- Retour localisé : le test d’intégration cible `BackButton`, sans dépendre du tooltip anglais `Back`.
- Racine de l’application : écoute séparée des préférences pour éviter les reconstructions de MaterialApp lors des mutations de tâches.
- Initialisation du stockage : déplacée dans le repository pour afficher une erreur récupérable même si l’accès initial aux préférences échoue.

## Limites explicites

Les workflows sont configurés mais n’ont pas été exécutés sur GitHub, aucun dépôt distant n’ayant été fourni. Pas de publication sur un store ni sur GitHub Pages. Les builds/signatures Android et iOS et la recette TalkBack/VoiceOver restent à vérifier sur leurs plateformes. Les tests de layout n’équivalent pas à une certification WCAG exhaustive.

Le scénario `integration_test/performance_test.dart` a passé sur Linux natif, avec ses résultats bruts dans `benchmarks/linux-profile.json`. La garantie de 60 FPS constants sur Android/iOS nécessite une mesure physique dédiée, selon [PERFORMANCE.md](PERFORMANCE.md).
