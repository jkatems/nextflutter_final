# Performance : budgets et protocole

## Choix implémentés

- `SliverList.builder` pour les tâches ; `ListView.builder` pour les sections de l’accueil. Aucun chargement de mille lignes en widgets simultanés.
- Deux photos WebP de 640 × 400 (~138 Kio au total), locales, `cacheWidth: 640`, créées à l’approche de leur section. Pas de réseau ni d’animation d’image.
- Widgets immuables avec constructeurs `const` ; la racine MaterialApp écoute un notifier distinct de langue/thème, et ne se reconstruit pas à chaque modification d’une tâche.
- Aucun polling, flou coûteux, `IntrinsicHeight`, calcul synchrone réseau ou animation permanente. Les sections hors de la navigation active ne sont pas montées.
- Filtrage en mémoire, tri O(n log n), sauvegarde d’un snapshot : adaptés à un petit gestionnaire local. Pour de très gros volumes, passer à une base paginée.

Ces choix suivent les [bonnes pratiques Flutter](https://docs.flutter.dev/perf/best-practices). Ils ne prouvent pas à eux seuls 60 FPS constants.

## Mesure reproductible sur appareil physique

Utiliser un appareil de test, avec une copie de ses données. Le scénario sauvegarde et restaure le snapshot existant dans un bloc `finally`, mais un arrêt forcé du processus peut empêcher cette restauration.

```sh
flutter devices
flutter drive --profile -d DEVICE_ID \
  --driver=test_driver/performance.dart \
  --target=integration_test/performance_test.dart
```

Le scénario génère 1 000 tâches, chauffe le défilement, effectue 12 gestes et exporte `scroll_1000_tasks` dans `build/integration_response_data.json`. Il échoue si aucun frame timing n’est disponible ou si le p99 de construction/rasterisation dépasse 16,67 ms. Ce seuil est un budget à 60 Hz ; même un p99 conforme ne garantit pas absolument zéro frame lent.

Répéter trois fois en mode **profile**, puis inspecter la timeline dans DevTools et confirmer visuellement en release. Documenter modèle, OS, fréquence d’écran, nombre de frames, p50/p99, frames ratées et mémoire. Mesurer aussi ouverture à froid, première apparition des images, saisie et navigation. Ne jamais utiliser des timings debug comme preuve de production.

## Mesure réalisée : Linux natif, mode profile

Le 28 septembre 2026, le benchmark a été exécuté avec succès sur Linux x64, CPU **Intel(R) Core(TM) i5-6300U CPU @ 2.40GHz**, noyau **7.2.5-200.fc44.x86_64**, Flutter 3.41.9. Un seul passage mesuré, après chauffe, sur la liste de 1 000 tâches :

| Mesure | Valeur |
| --- | --- |
| Frames collectées | 411 |
| Construction moyenne / p99 / pire | 0,682 / 2,064 / 5,371 ms |
| Rasterisation moyenne / p99 / pire | 0,865 / 2,474 / 11,175 ms |
| Dépassements du budget construction | 0 |
| Dépassements du budget rasterisation | 0 |

Les deux assertions p99 < 16,67 ms ont passé. [Résultat brut complet](benchmarks/linux-profile.json), avec les temps de chaque frame. Ces temps moteur ne mesurent pas la latence d’entrée complète ni la fréquence de présentation de l’écran. Ils ne certifient pas les performances des téléphones Android/iOS.

Commande : `flutter drive --no-pub --profile -d linux --driver=test_driver/performance.dart --target=integration_test/performance_test.dart`.

Le pilote Flutter a bien reçu les résultats et écrit le JSON. Le runner Linux a également émis un avertissement de canal natif « integration_test plugin was not detected » en fin de suite ; la transmission par le driver VM a abouti (`All tests passed`).

## État de validation

Les tests de mise en page, les parcours de navigateur et le build release sont consignés dans `VALIDATION.md`. Aucun téléphone physique n’était utilisé pour ce livrable : **la garantie de 60 FPS constants reste à mesurer**, et n’est pas revendiquée à partir des seuls tests automatisés.
