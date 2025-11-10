# Lorcana Counter

Compteur de points pour le jeu de cartes Disney Lorcana. L'application est conçue en Flutter (Material 3) et optimisée pour une utilisation en mode portrait.

## Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.19 ou supérieur)
- [Android Studio](https://developer.android.com/studio) ou [Visual Studio Code](https://code.visualstudio.com/) avec l'extension Flutter
- Pour la compilation Linux : dépendances GTK et clang décrites dans la [documentation officielle Linux](https://docs.flutter.dev/platform-integration/linux/building)
- Pour la compilation Web : navigateur moderne compatible WebAssembly

## Lancer l'application

### Mobile / Desktop générique

```bash
flutter pub get
flutter run
```

### Construction Linux

```bash
flutter pub get
flutter build linux
./build/linux/x64/release/bundle/lorcana_counter
```

### Construction Web

```bash
flutter pub get
flutter build web
flutter run -d chrome  # pour tester rapidement dans un navigateur
```

## Structure du projet

- `lib/` : écran principal et composants.
- `assets/images/` : ressources graphiques (logo temporaire Flutter).
- `test/` : tests unitaires Flutter.

## Licence

Projet éducatif – aucune affiliation avec Disney ou Ravensburger.
