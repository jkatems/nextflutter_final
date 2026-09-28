# Accessibilité — implémentation et preuves

## Éléments réellement implémentés

| Surface | Comportement | Emplacement |
| --- | --- | --- |
| Cocher / rouvrir une tâche | Libellé FR/EN avec titre de la tâche, état coché exposé par `Checkbox` | `lib/ui/widgets/task_tile.dart` |
| Ouvrir un détail | Nœud `Semantics` de type bouton, libellé « Ouvrir : titre » | `lib/ui/widgets/task_tile.dart` |
| Ajouter, modifier, revenir, supprimer | Boutons Material, textes ou tooltips localisés | `lib/ui/app_shell.dart`, `lib/ui/screens/` |
| Erreur de sauvegarde | Annonce `liveRegion` du bandeau, fermeture avec tooltip natif localisé | `lib/ui/app_shell.dart` |
| Formulaire | `labelText`, erreurs de validation natives, sélecteur de date localisé | `lib/ui/screens/task_editor_screen.dart` |
| Progression | Libellé explicite et valeur numérique compatible avec les lecteurs d’écran | `lib/ui/screens/stats_screen.dart` |
| Navigation | Destinations nommées, état sélectionné, barre mobile et navigation bureau | `lib/ui/app_shell.dart` |
| Photos et décorations | Images décoratives exclues des annonces ; le texte du bouton reste lisible | `lib/ui/screens/home_screen.dart` |
| Texte agrandi | Mise en page flexible, retours à la ligne, formulaire défilant | Écrans et widgets partagés |

Les labels des composants Material sont exposés par les composants eux-mêmes : les envelopper tous dans un second `Semantics` produirait des annonces dupliquées. Les labels personnalisés sont ajoutés aux interactions dont le contexte métier doit être annoncé.

## Contrôles automatiques

`test/widgets/accessibility_test.dart` exécute quatre combinaisons **FR/EN × clair/sombre**. Chaque combinaison visite l’accueil, les tâches, les statistiques, les paramètres, le détail et l’éditeur. Les vérifications portent sur les éléments présents dans le viewport à ce moment :

- `labeledTapTargetGuideline` : chaque cible interactive expose un nom accessible.
- `androidTapTargetGuideline` : taille minimale Android de 48 × 48 pixels logiques.
- `iOSTapTargetGuideline` : taille minimale iOS de 44 × 44 pixels logiques.
- `textContrastGuideline` : estimation de contraste fournie par le moteur de test Flutter (seuils 4,5:1 pour texte normal, 3:1 pour texte large).
- Changement du libellé « Terminer » en « Rouvrir » après validation d’une tâche.

`test/widgets/app_test.dart` vérifie également les quatre destinations principales sur **320 × 800, texte à 200 %**, ainsi que la validation du formulaire et le dialogue de suppression.

Exécution ciblée :

```sh
flutter test test/widgets/accessibility_test.dart test/widgets/app_test.dart
```

Les noms, résultats et fichiers exacts des tests sont exportés depuis le reporter Flutter dans [quality/summary.json](quality/summary.json), [quality/junit.xml](quality/junit.xml) et [quality/tests.jsonl](quality/tests.jsonl). Voir le [résumé de l’exécution](quality/SUMMARY.md).

## Recette manuelle restant à effectuer sur mobile

Ces tests ne certifient pas WCAG, TalkBack ou VoiceOver. Sur les versions Android/iOS cibles :

1. Activer le lecteur d’écran ; parcourir chaque écran par balayages, vérifier le nom, le rôle, l’état et l’ordre des contrôles.
2. Créer une tâche sans titre, vérifier l’annonce de l’erreur, compléter le titre et enregistrer.
3. Ouvrir, modifier, terminer, rouvrir et supprimer une tâche ; vérifier le focus au retour et le dialogue de confirmation.
4. Passer en anglais et en thème sombre ; refaire le parcours avec texte agrandi et mode contraste du système.
5. Brancher un clavier : vérifier Tab / Maj+Tab, Entrée/Espace, focus visible, fermeture des dialogues et absence de piège au clavier.
6. Faire défiler le contenu hors viewport, notamment les cartes d’espaces et les champs du formulaire.

Consigner appareil, OS, lecteur d’écran, version de l’application, résultat et anomalies. Ne pas présenter ces étapes manuelles comme déjà validées.
