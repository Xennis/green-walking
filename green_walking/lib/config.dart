const androidAppID = 'org.xennis.apps.green_walking';
const appVersion = '3.6.1';
const appAuthor = 'Xennis';
const supportMail = 'code@xennis.org';
Uri privacyPolicyUrl = Uri.https('fabian-rosenthal.notion.site', '/2b25e9c9e03380608b6febeb39636d21');
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
