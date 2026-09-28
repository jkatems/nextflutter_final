# Préparer une livraison

## Web

```sh
./scripts/verify.sh
python3 -m http.server 8080 --directory build/web
```

Servir tout `build/web` en HTTPS. `--no-web-resources-cdn` embarque CanvasKit : aucune dépendance au CDN du moteur. La police et les photos sont locales. Les tâches fonctionnent sans réseau une fois l’application chargée ; la réouverture d’une page web hors ligne n’est pas garantie (pas de service worker applicatif). Les applications natives embarquent toutes les ressources.

Pour GitHub Pages : pousser ce dossier dans un dépôt, activer **Settings → Pages → GitHub Actions**, puis lancer **Deploy web to GitHub Pages**. Le workflow relance analyse, tests, couverture et intégration avant publication. Il calcule le chemin de base pour le dépôt. Aucune publication distante n’a été effectuée pendant la préparation de ce livrable.

Ne pas mettre en cache durablement `index.html`, `flutter_bootstrap.js` et `main.dart.js` sans invalidation à chaque version.

## Android

```sh
flutter build appbundle --release
```

Sans `android/key.properties`, le bundle est **non signé** et n’est pas installable/publiable tel quel. Aucune clé debug n’est utilisée pour une release. Créer sa clé d’upload, copier `android/key.properties.example` vers `android/key.properties` et renseigner les quatre valeurs localement, puis relancer la commande. Pour une CI signée, injecter le keystore et les mots de passe depuis les secrets de l’environnement de livraison. Les fichiers de clés sont ignorés par Git.

Confirmer que `dev.focusflow.focus_flow` est bien l’identifiant définitif avant la première publication. Incrémenter `version` dans `pubspec.yaml`. Tester le bundle via un canal de test Play Console avant promotion.

## iOS

Sur macOS avec Xcode : `flutter build ipa --release`, sélectionner son équipe Apple et configurer certificats/provisioning. La compilation iOS n’a pas été vérifiée dans cet environnement Linux.

## Données et confidentialité

Stockage JSON local sous la clé `focusflow.snapshot.v1`, schéma 1. Une version inconnue ou des données corrompues produisent un écran d’erreur avec réessai, sans écrasement. Une mutation n’est rendue définitive qu’après réussite de l’adaptateur de stockage. Les écritures simultanées sont refusées pendant une sauvegarde pour éviter l’écrasement d’une modification.

SharedPreferences convient à ce petit gestionnaire personnel, sans données critiques : le plugin ne garantit pas une écriture durable en cas de coupure brutale de l’OS. Pas de synchronisation entre appareils/onglets, de chiffrement applicatif ni d’export automatisé. La désinstallation ou l’effacement du stockage supprime les données. Android Auto Backup est désactivé. Les sauvegardes système iOS restent régies par les réglages de l’appareil.

Pour une évolution vers des données critiques ou un gros volume : base transactionnelle locale, migrations testées, sauvegarde/export et conflits de synchronisation explicites.

## Validation avant store

- Exécuter les parcours sur les versions Android/iOS cibles avec TalkBack/VoiceOver et navigation clavier.
- Exécuter le profilage physique décrit dans `PERFORMANCE.md`.
- Vérifier les captures, icônes, formulaire de confidentialité, signature et restauration après arrêt du processus.
- Les tests de navigateur ne constituent pas une certification de performance mobile ni une validation native iOS.
