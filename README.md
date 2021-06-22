# flutter_sandbox

A new Flutter sandbox application to experiment in flutter

## Getting Started

This project is a starting point for a Flutter application.

### Choose your preferred development tools to write, build and run flutter apps.
For all tools, install Flutter SDK from <https://flutter.dev/docs/get-started/install>.
For in-depth instructions please visit <https://flutter.dev/docs/get-started/test-drive?tab=terminal>.
#### Android Studio
- Install Flutter and Dart plugins.
- Select your device from the target selector.
- Press Run to see your app.

#### Visual Studio Code
- Install Flutter and Dart extensions.
- Select a device from the device selector at the bottom or select 'No Devices' and launch a simulator.
- Press Run>Start Debugging or press F5 to see your app.

#### Terminal & editor
- Check that Android devices are running using `flutter devices`.
- Run the app with using the command `flutter run` to see your app.

## Additional files that needs to be modified to include private data.
### Firebase
- Add your `google-services.json` in `android/app` folder.
- Add your Firebase config variable for web support in `web/index.html`.

### Google Maps

Get an API key at <https://cloud.google.com/maps-platform/>.

Please enable `Maps SDK for Android`, `Maps SDK for iOS` and `Maps JavaScript API` at your project in Google Cloud Platform.

Then, specify your API key in the application manifest `android/app/src/main/res/AndroidManifest.xml` for Android, and specify your API key in the application delegate `ios/Runner/AppDelegate.swift` for iOS.

Modify `web/index.html` to specify your API key for Web.

## Commands that needs to be run from terminal
### For Flutter Native Splash run the following to generate relevant files
`flutter pub run flutter_native_splash:create`
### For Flutter Launcher Icons run the following to generate relevant files when flutter icons configurations were saved in (pubspec.yaml) or (flutter_launcher_icons.yaml)
`flutter pub run flutter_launcher_icons:main`
### For Flutter Launcher Icons run the following to generate relevant files when flutter icons configurations were saved in another file with different name than (pubspec.yaml) or (flutter_launcher_icons.yaml)
`flutter pub run flutter_launcher_icons:main -f <your config file name here>`
### For Objectbox db run the following to generate relevant files
`flutter pub run build_runner build`

## Compile-time variables
To provide compile-time variables use `--dart-define` during `flutter run` or `flutter build`. To pass multiple key-value pairs just use `--dart-define` multiple times.
`flutter run --dart-define=ACCESS_TOKEN_MAPBOX --dart-define=VARIABLE=VARIABLE_VALUE`

## Quality Assurance
#### Run Unit Test
##### Android Studio
1. Right-click on pageNavigatorCustom_test.dart file
2. Press the Run `tests in pageNavigatorCustom_test.dart` option.

##### Visual Studio Code
1. Open the pageNavigatorCustom_test.dart file
2. Select the Run menu
3. Click the Start Debugging option

##### Terminal & editor
`flutter test`