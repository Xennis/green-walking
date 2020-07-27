import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'intl.dart';
import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((_) {
    // Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(GreenWalkingApp());
  });
}

class GreenWalkingApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GreenWalkingAppState();
}

class _GreenWalkingAppState extends State<GreenWalkingApp> {
  AppLocalizationsDelegate _localeOverrideDelegate =
      const AppLocalizationsDelegate(Locale('de', ''));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).title,
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Routes.map,
      routes: () {
        final Map<String, WidgetBuilder> routes = Routes.get(context);
        return routes;
      }(),
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        _localeOverrideDelegate
      ],
      supportedLocales: const <Locale>[
        Locale('de', ''),
        Locale('en', ''),
      ],
    );
  }
}
