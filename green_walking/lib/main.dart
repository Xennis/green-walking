import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'provider/prefs_provider.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(const GreenWalkingApp());
}

class GreenWalkingApp extends StatelessWidget {
  const GreenWalkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppPrefsProvider>(
        create: (_) => AppPrefsProvider(true),
        child: Builder(builder: (context) {
          final AppPrefsProvider prefsProvider = Provider.of<AppPrefsProvider>(context);
          return MaterialApp(
            onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.blue,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.blue,
            ),
            themeMode: prefsProvider.themeMode,
            initialRoute: Routes.map,
            routes: () {
              final Map<String, WidgetBuilder> routes = getRoutes(context);
              return routes;
            }(),
            locale: prefsProvider.locale,
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        }));
  }
}
