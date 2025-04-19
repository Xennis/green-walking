String androidAppID = 'org.xennis.apps.green_walking';
String appVersion = '3.6.0';
String appAuthor = 'Xennis';
String supportMail = 'code@xennis.org';
Uri privacyPolicyUrl =
    Uri.https('raw.githubusercontent.com', '/Xennis/green-walking/main/web/privacy/privacy-policy.md');
Uri appPlayStoreUrl = Uri.https('play.google.com', '/store/apps/details', {'id': androidAppID});

class CustomMapboxStyles {
  static const String outdoor = 'mapbox://styles/xennis/ckfbioyul1iln1ap0pm5hrcgy';
  static const String satellite = 'mapbox://styles/xennis/ckfc5mxh33tjg19qvk6m5f5hj';
}

// env
const mapboxAccessToken = String.fromEnvironment("MAPBOX_ACCESS_TOKEN");
const firebaseApiKey = String.fromEnvironment("FIREBASE_API_KEY");
const firebaseAppId = String.fromEnvironment("FIREBASE_APP_ID");
const firebaseMessagingSenderId = String.fromEnvironment("FIREBASE_MESSAGING_SENDER_ID");
const firebaseProjectId = String.fromEnvironment("FIREBASE_PROJECT_ID");
