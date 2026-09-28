# Architecture et injection des dépendances

```text
bootstrap.dart ── choisit l’adaptateur et les données initiales
       │
       ├── data/PreferencesRepository ── implémente domain/AppRepository
       └── state/AppController ──────── dépend de domain/AppRepository
                     ↑
               ui/screens/ ── transmet des données et callbacks à ui/widgets/
```

## Responsabilités

- **domain/** : modèle immuable `Task`, règles de validation/filtrage/statistiques, snapshot immuable et contrat de persistance. Aucun import de Flutter, de l’adaptateur ou de l’UI.
- **data/** : adaptateur SharedPreferences et données d’exemple. Le namespace de stockage est injectable, ce qui isole intégration et performance des données de l’utilisateur.
- **state/** : commandes asynchrones et notifications ; dépend exclusivement du domaine et de `foundation`. Pas d’import d’écran, de `BuildContext` ni de plugin de stockage.
- **ui/screens/** : un fichier par écran ; les contrôleurs de champs et filtres temporaires sont locaux aux écrans.
- **ui/widgets/** : widgets réutilisables, sans import du contrôleur ni de navigation. `TaskTile` reçoit `Task`, `DateTime`, `busy`, `onToggle`, `onOpen`.
- **ui/theme/** : thème ; **ui/navigation.dart** : transitions entre écrans ; **ui/formatters.dart** : labels et dates localisés.
- **bootstrap.dart** : point de composition ; `createAppController(repository: ..., clock: ...)` peut remplacer les dépendances sans service locator global.

`python3 scripts/check_architecture.py` fait échouer la CI si le domaine importe une couche externe, si le contrôleur dépend de l’adaptateur/UI ou si un widget partagé dépend du contrôleur/des écrans.

## Encapsulation et concurrence

`loading`, `busy` et `error` sont des getters ; l’UI n’a pas de setters. `AppFailure` distingue lecture et écriture. `dismissError()` notifie les observateurs et ne peut pas effacer une erreur de lecture bloquante. Les préférences sont exposées via `ValueListenable`, pas via un notifier publiquement modifiable.

Le contrôleur attend la réussite de l’écriture avant de publier le nouvel état. Les mutations concurrentes sont refusées pendant une écriture ; une initialisation ne peut pas concurrencer une sauvegarde. Une fin de requête après `dispose` ne notifie pas un écouteur détruit. Les tâches et snapshots sont immuables ; la liste de tâches est non modifiable.

Les tests de ces contrats se trouvent dans `test/unit/controller_test.dart`, `state_boundaries_test.dart` et `storage_isolation_test.dart`.

## Génération de code

Les traductions et pluriels sont **générés par `flutter gen-l10n`** à partir des ARB. Les classes `app_localizations*.dart` sont générées, jamais éditées manuellement.

Le schéma JSON local est petit et versionné. Sa validation explicite conserve le contrôle du refus des schémas inconnus, données corrompues et identifiants dupliqués ; elle est testée. Un générateur JSON n’est pas ajouté uniquement pour augmenter les dépendances. Si le nombre de modèles augmente, un passage à `json_serializable` peut être fait en préservant ces tests et migrations.
