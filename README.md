# catalog_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## For Building Android APK
- Need to run "flutter build apk --release"
- keystore file to be used for app signing

## For Building IOS IPA
- Needs Xcode to build ipa file
- Could be signed through xcode by logging in developers account email
- Could be deployed on testflight for testing or could create ipa through archive.

## For CI/CD Android
- .yml file has been added to .github/workflows
- when push on 'main' branch the workflow run could be viewd in 'Actions' tab and the apk could be downloaded from 'Artifacts'

## For CI/CD IOS
- Not tested

## Scalability
- API Rate Limiting -> 
    1. Server-Side pagination could be added to limit data size.
    2. If data is not changed then the api should return any error code so cached data can be displayed, Hence received response is limited upto error code only and no data has to be returned everytime.
- Caching ->
    1. Data caching to be done on application side to show cached data when api returns error or network is not available.
- Modularization ->
    1. Separaring the UI, Notifiers, Providers and Data Layers
    2. Code Reusability and better understanding of layers
    3. Better testing for each module

## Monitoring
- Add Log Files
- Handling exceptions and record exception logs for better understanding
- Add firebase crashlytics and user analytics
- CI/CD monitoring