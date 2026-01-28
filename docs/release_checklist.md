# Store release checklist (Android + iOS)

## Legal / Compliance

- Provide a **Privacy Policy** URL in Play Console/App Store Connect.
- Ensure your privacy policy matches actual data collection (camera, photos, notifications, storage).
- In-app: expose **Open-source licenses** (this project uses Flutter's built-in `showLicensePage`).

## Versioning

- Update `version:` in `pubspec.yaml` (e.g. `1.2.0+34`).
- Ensure iOS `CFBundleShortVersionString` and `CFBundleVersion` map to Flutter build name/number (default).

## Android (Play Store)

- Set a unique `applicationId` in `android/app/build.gradle.kts`.
- Configure **release signing** (keystore) and keep keys out of git.
- Verify `AndroidManifest.xml` permissions are minimal and justified.
- Build: `flutter build appbundle --release`.

## iOS (App Store)

- Set a unique Bundle ID in Xcode.
- Ensure `ios/Runner/Info.plist` contains required usage descriptions.
- Configure signing/teams in Xcode.
- Build: `flutter build ipa --release`.

## Security

- Sensitive data: store secrets in `flutter_secure_storage` (Keychain/Keystore).
- Local DB: use encrypted storage (Hive encrypted box wired in `lib/core/storage/hive_bootstrap.dart`).

## QA

- Run: `flutter test` and `flutter analyze`.
- Verify permissions flows on real devices.
- Verify notifications permission prompt and a test notification.
