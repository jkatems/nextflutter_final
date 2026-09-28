# Changelog

Les versions ci-dessous documentent les incréments fonctionnels réalisés pour ce livrable. Elles ne représentent pas des publications historiques sur les stores.

## [1.3.0] — 2026-09-28

### Corrigé
- Contrat de persistance placé dans le domaine ; contrôleur indépendant de l’adaptateur SharedPreferences.
- État en lecture seule, erreurs typées et effacement d’erreur via commande ; notification sûre après une sauvegarde terminée après `dispose`.
- Stockage d’intégration et de benchmark isolé des données utilisateur.
- Build Android CI : retrait de `--no-pub` pour régénérer le registre de plugins de release (flutter/flutter#169336).
- Badge CI relié au dépôt réel `jkatems/nextflutter_final`.

### Ajouté
- Contrôle CI des 76 messages FR/EN et de leurs arguments ICU ; rapport de localisation joint à la remise.
- Génération CI d’un APK de démonstration installable, distinct du bundle de distribution non signé.
- Un fichier par écran, répertoire de widgets partagés sans dépendance au contrôleur, thème séparé et point de composition pour injecter les dépendances.
- Tests des frontières d’état, de l’isolation du stockage, du chargement paresseux et de l’accessibilité sur six écrans en FR/EN et clair/sombre.
- Exports de preuves : résultats Flutter JSON, JUnit, LCOV, couverture HTML, empreintes SHA-256 des sources.
- Archive de remise complète avec sources, tests, documentation, workflows et manifeste vérifié, disponible également comme artefact CI.
- Matrice des exigences et documentation d’accessibilité détaillée.

## [1.2.0] — 2026-09-28

### Ajouté
- Tests unitaires, widgets, intégration sur stockage réel et scénario de profilage de 1 000 tâches.
- CI GitHub Actions : analyse stricte, formatage, couverture métier ≥ 90 %, intégration Chrome et builds de livraison.
- Déploiement GitHub Pages déclenché manuellement après validation.
- Documentation, captures réelles, procédure de signature Android.

### Amélioré
- Listes paresseuses, images WebP de 640 px et décodage borné.
- Police embarquée et reconstruction de MaterialApp limitée aux changements de langue/thème.
- Petits écrans, texte à 200 %, sémantique des actions et des indicateurs.
- Échec de sauvegarde sans perte du formulaire ni modification de l’état validé.

## [1.1.0] — 2026-09-28

### Ajouté
- Traductions FR/EN via ARB et génération Flutter.
- Thèmes clair/sombre persistants, mise en page mobile et bureau.
- Recherche, filtres par état et espace, statistiques calculées.
- Étiquettes d’accessibilité et confirmation de suppression.

## [1.0.0] — 2026-09-28

### Ajouté
- Six écrans : accueil, tâches, détail, création/édition, statistiques, paramètres.
- Création, modification, validation, réouverture et suppression des tâches.
- Stockage local versionné, repository injectable et modèles immuables.
- Exemples au premier lancement, espaces Travail, Personnel et Bien-être.
