import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_mobile/features/garbage/screens/add-garbage.dart';
import 'package:trash_track_mobile/features/garbage/services/garbages_service.dart';
import 'package:trash_track_mobile/features/report/screens/add_report.dart';
import 'package:trash_track_mobile/features/report/screens/garbage_map.dart';
import 'package:trash_track_mobile/features/report/services/reports_service.dart';
import 'package:trash_track_mobile/features/reservation/services/reservation_service.dart';
import 'package:trash_track_mobile/features/services/services/services_service.dart';
import 'package:trash_track_mobile/features/user/screens/login_screen.dart';
import 'package:trash_track_mobile/features/user/screens/sign-up_screen.dart';
import 'package:trash_track_mobile/features/user/services/auth_service.dart';
import 'package:trash_track_mobile/shared/services/http-override.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => GarbageService()),
        ChangeNotifierProvider(create: (context) => ReportService()),
        ChangeNotifierProvider(create: (context) => ServicesService()),
        ChangeNotifierProvider(create: (context) => ReservationService()),

      ],
      child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Replace MyHomePage with your LoginScreen
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
