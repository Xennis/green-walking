String androidAppID = 'org.xennis.apps.green_walking';
String appVersion = '3.4.0';
String appAuthor = 'Xennis';
String supportMail = 'code@xennis.org';
Uri privacyPolicyUrl =
    Uri.https('raw.githubusercontent.com', '/Xennis/green-walking/main/web/privacy/privacy-policy.md');
Uri appPlayStoreUrl = Uri.https('play.google.com', '/store/apps/details', {'id': androidAppID});

class CustomMapboxStyles {
  static const String outdoor = 'mapbox://styles/xennis/ckfbioyul1iln1ap0pm5hrcgy';
  static const String satellite = 'mapbox://styles/xennis/ckfc5mxh33tjg19qvk6m5f5hj';
}
