# App Icon Instructions

Place the provided AIR24 logo file here as `app_icon.png`.

Guidelines:
- Recommended size: 1024x1024 px PNG
- No rounded corners; fill the square canvas fully
- Transparent background is allowed; avoid large transparent padding
- Keep the airplane/wordmark centered for best results

After saving `assets/icons/app_icon.png`, run:

```
flutter pub get
dart run flutter_launcher_icons
```

This generates icons for Android, iOS, macOS, Windows, and Web using the configuration in `pubspec.yaml` (`flutter_launcher_icons` section).
