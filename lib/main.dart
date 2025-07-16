// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:igmp/presentation/providers/app_providers.dart';
import 'package:igmp/shared/routes/app_routes.dart';
import 'package:igmp/shared/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        title: 'igmp',
        theme: AppThemes.mainTheme,
        localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
        supportedLocales: const [Locale('pt')],
        routes: appRoutes,
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
