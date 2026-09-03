# Flutter App Foundation

![Flutter](https://img.shields.io/badge/Flutter-3.x-54C5F8?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.12%2B-0175C2?logo=dart&logoColor=white)
![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS-20232A)

Reusable Flutter mobile application foundation with a feature-based structure, typed
API generation, localization, environment configuration, persistence, connectivity
handling, and centralized error logging. It is intended to give new Flutter projects
a practical starting point instead of a blank scaffold.

## Contents

- [English](#english)
- [Türkçe](#türkçe)

## English

### Highlights

- Feature-based organization under `lib/features`
- Riverpod and Hooks Riverpod for state management
- GoRouter for navigation
- Easy Localization with Turkish, English, and Arabic resources
- Dio-based networking with generated Swagger models and services
- Envied-powered environment configuration
- Secure Storage, Shared Preferences, and Drift/SQLite persistence options
- Connectivity monitoring and centralized exception handling
- Responsive layouts with Flutter ScreenUtil
- Light and dark theme definitions, with dark mode currently selected by default

### Requirements

- Flutter SDK compatible with Dart `3.12.2` or newer
- Android Studio and an Android SDK for Android builds
- Xcode and CocoaPods for iOS builds on macOS

Check the local toolchain before starting:

```bash
flutter doctor
```

### Getting started

```bash
git clone <repository-url>
cd flutter_foundation
flutter pub get
```

Create the environment files expected by the app:

```bash
touch .env.dev .env.prod
```

Set the private values in both files:

```dotenv
BASE_URL=https://your-api.example.com
SWAGGER_URL=https://your-api.example.com/openapi.json
```

Run the development application:

```bash
flutter run
```

`lib/env.dart` loads `.env.dev` in debug mode and `.env.prod` otherwise. Keep these
files out of version control and never commit URLs containing credentials or secrets.

### Common commands

```bash
flutter analyze
flutter test
dart format lib test
flutter build apk
flutter build ios
```

### API code generation

Generated API output lives in `lib/generated`. The repository includes a local Swagger
document at `lib/generated/swagger/common.swagger`, so model generation works without
access to the internal API server:

```bash
dart run lib/core/tools/generate_models.dart
```

The generated files are project-specific. Review the output before using it in another
project, and do not delete `lib/generated` unless you can regenerate it first. To use
a different API definition, provide `SWAGGER_URL` in the selected environment file and
run the same command.

### Project layout

```text
lib/
├── core/          Shared infrastructure, services, widgets, theme, and routing
├── features/      Feature-specific logic and presentation layers
├── generated/     Swagger models and generated API code
├── env.dart       Environment variable access
└── main.dart      Application bootstrap
assets/
├── lang/          en, tr, and ar localization files
└── logo/          Application branding assets
```

### Adding a feature

1. Create a folder under `lib/features/<feature_name>`.
2. Keep feature state and domain logic in `logic`, and screens/widgets in
	`presentation`.
3. Add navigation through the centralized GoRouter configuration.
4. Add user-facing strings to every supported localization file.
5. Run `dart format`, `flutter analyze`, and `flutter test` before opening a PR.

### Resources

- [Flutter documentation](https://docs.flutter.dev/)
- [Dart documentation](https://dart.dev/guides)
- [Riverpod documentation](https://riverpod.dev/)
- [GoRouter package](https://pub.dev/packages/go_router)

## Türkçe

### Genel bakış

Flutter mobil uygulamaları için hazırlanmış, özellik bazlı klasör yapısına sahip bir
başlangıç altyapısıdır. Tip güvenli API üretimi, çoklu dil desteği, ortam değişkenleri,
yerel veri saklama, bağlantı takibi ve merkezi hata loglama gibi ortak ihtiyaçları hazır
hale getirir.

### Öne çıkanlar

- `lib/features` altında özellik bazlı mimari
- Durum yönetimi için Riverpod ve Hooks Riverpod
- Sayfa yönlendirme için GoRouter
- Türkçe, İngilizce ve Arapça Easy Localization kaynakları
- Dio tabanlı ağ katmanı ve Swagger'dan üretilen API modelleri
- Envied ile debug/release ortam yapılandırması
- Secure Storage, Shared Preferences ve Drift/SQLite seçenekleri
- Bağlantı durumu takibi ve merkezi exception yönetimi
- Flutter ScreenUtil ile responsive arayüz desteği
- Light/dark tema tanımları; varsayılan olarak dark tema seçili

### Gereksinimler

- Dart `3.12.2` veya üzeriyle uyumlu Flutter SDK
- Android derlemeleri için Android Studio ve Android SDK
- macOS üzerinde iOS derlemeleri için Xcode ve CocoaPods

Kurulumdan önce araç zincirini kontrol edin:

```bash
flutter doctor
```

### Kurulum ve çalıştırma

```bash
git clone <repository-url>
cd flutter_foundation
flutter pub get
touch .env.dev .env.prod
flutter run
```

`.env.dev` ve `.env.prod` dosyalarına kendi API bilgilerinizi ekleyin:

```dotenv
BASE_URL=https://your-api.example.com
SWAGGER_URL=https://your-api.example.com/openapi.json
```

Debug modunda `lib/env.dart` `.env.dev`, diğer modlarda `.env.prod` dosyasını okur.
Bu dosyaları repoya eklemeyin; kimlik bilgisi veya gizli anahtar içeren URL'leri asla
commit etmeyin.

### Sık kullanılan komutlar

```bash
flutter analyze
flutter test
dart format lib test
flutter build apk
flutter build ios
```

### API kod üretimi

Üretilen API dosyaları `lib/generated` altında bulunur. Yerel Swagger dosyası repoda
mevcut olduğu için aşağıdaki komut dahili API sunucusuna erişmeden çalışabilir:

```bash
dart run lib/core/tools/generate_models.dart
```

Üretilen dosyalar projeye özeldir. Başka bir projede kullanmadan önce çıktıyı inceleyin
ve yeniden üretmeden `lib/generated` klasörünü silmeyin. Farklı bir API tanımı için
`SWAGGER_URL` değerini ilgili ortam dosyasına ekleyip aynı komutu çalıştırabilirsiniz.

### Yeni özellik ekleme

1. `lib/features/<özellik_adi>` altında yeni bir klasör oluşturun.
2. Durum ve iş kurallarını `logic`, ekran ve widget'ları `presentation` altında tutun.
3. Sayfa yönlendirmelerini merkezi GoRouter yapılandırmasına ekleyin.
4. Kullanıcıya gösterilen metinleri tüm dil dosyalarına ekleyin.
5. PR öncesinde format, analiz ve test komutlarını çalıştırın.

### Proje kaynakları

- [Flutter dokümantasyonu](https://docs.flutter.dev/)
- [Dart dokümantasyonu](https://dart.dev/guides)
- [Riverpod dokümantasyonu](https://riverpod.dev/)
