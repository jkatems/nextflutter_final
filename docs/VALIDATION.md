# Rapport de validation — FocusFlow 1.3.0

Ce rapport décrit la correction locale du 28 septembre 2026. Environnement : Linux x64, Flutter **3.41.9**, Dart **3.11.5**, Chromium / ChromeDriver **152.0.7977.82**.

## Résultats de la version corrigée

| Contrôle | Résultat / preuve |
| --- | --- |
| Analyse stricte | Aucun problème — [log](quality/analyze.txt) |
| Tests unitaires | **40 réussis** dans `test/unit/` |
| Tests widgets | **19 réussis** dans `test/widgets/` |
| Internationalisation | **76 messages FR et 76 EN**, parité des clés et arguments validée — [rapport](quality/localizations.json) |
| Couverture métier | **165 / 167 lignes, 98,8 %**, contrôleur **100 %** |
| Accessibilité | Six écrans FR/EN × clair/sombre : libellés, tailles Android/iOS et contraste ; [détails](ACCESSIBILITY.md) |
| Texte agrandi | Quatre destinations principales en 320 × 800, texte à 200 % |
| Lazy loading | 1 000 tâches : moins de 25 `TaskTile` montés avant et après défilement |
| Intégration web | **2 parcours réussis** sur véritable SharedPreferences isolé — [log](quality/integration-web.txt) |
| APK de démonstration | Non produit : téléchargements Gradle en échec (`No route to host`, résolution DNS, timeout) — [log](quality/build-android-demo.txt) |
| Build web release | Réussi, moteur sans CDN — [log](quality/build-web.txt) |
| Benchmark natif profile | **476 frames**, p99 build **5,844 ms**, raster **5,02 ms**, budgets p99 respectés |
| Architecture | Contrôleur indépendant du stockage concret, widgets partagés sans contrôleur ; contrôle Python passé |
| CI/CD | YAML vérifiés : 5 jobs CI et 2 jobs de déploiement ; badge réel ; [diagnostic de la panne Android](CI.md) |

## Preuves exportées

- [Résumé généré](quality/SUMMARY.md), [résultats et empreinte des sources](quality/summary.json).
- [Flux brut Flutter JSON](quality/tests.jsonl), [JUnit XML](quality/junit.xml).
- [LCOV brut](quality/lcov.info), [couverture HTML par fichier et ligne](quality/coverage.html).
- [Captures](screenshots/01-overview-fr.png) : six écrans bureau régénérés après correction ; captures mobiles disponibles depuis la validation précédente.
- [Benchmark profile natif et détails](PERFORMANCE.md), [données brutes](benchmarks/linux-profile.json).

Le rapport automatique répertorie chaque test exécuté : les nombres ne sont pas obtenus en comptant les fonctions du code. L’archive source refuse des sources dont l’empreinte a changé depuis ces tests.

## Ce qui a changé en réponse à l’évaluation

Les tests, le CHANGELOG et le premier benchmark existaient dans Git. Aucune preuve ne permet d’affirmer quels fichiers avaient été soumis à l’évaluateur. Une archive web compilée ne contient pas les sources/tests Flutter. La remise inclut maintenant explicitement une archive source avec manifeste, matrice des exigences, rapports exportés et test de présence des éléments obligatoires.

Le contrôleur n’importe plus le dossier data ; le contrat est dans domain. L’UI ne modifie plus directement `error`, les erreurs sont typées, chaque écran a son fichier, et les widgets partagés ont leurs callbacks. Les tests couvrent aussi la destruction du contrôleur pendant une écriture et la prévention d’une course entre chargement et sauvegarde.

## Limites

Le rechargement d’intégration détruit widgets et contrôleur, recharge le vrai stockage puis recrée l’application ; ce n’est pas un arrêt complet du processus OS. Les mesures natives Linux ne certifient pas 60 FPS constants sur les téléphones Android/iOS. La recette TalkBack/VoiceOver, le build iOS et les signatures de distribution mobile nécessitent leurs environnements dédiés.

Les corrections sont locales. L’état distant actuel reste celui du dernier commit poussé ; le badge GitHub changera après un nouveau run. Aucun déploiement ni message externe n’est effectué par cette correction.
