# Green Walking app

[![Flutter](https://github.com/Xennis/green-walking/actions/workflows/flutter.yml/badge.svg)](https://github.com/Xennis/green-walking/actions/workflows/flutter.yml)

<a href='https://play.google.com/store/apps/details?id=org.xennis.apps.green_walking'><img height="80px" alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png'/></a>

## App Development

Copy the [access token from the Mapbox console](https://console.mapbox.com/account/access-tokens/).

Run the app
```shell
flutter run --dart-define MAPBOX_ACCESS_TOKEN=...
```

Build the app
```shell
flutter build <platform> --dart-define MAPBOX_ACCESS_TOKEN=...
```

Copy the Firebase config from `https://console.firebase.google.com/project/<project-id>/settings/general/` and use it the same way:

```shell
--dart-define FIREBASE_API_KEY=...
--dart-define FIREBASE_APP_ID=...
--dart-define FIREBASE_MESSAGING_SENDER_ID=...
--dart-define FIREBASE_PROJECT_ID=...
```
