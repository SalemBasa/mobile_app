import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_mobile/features/cart/services/cart_service.dart';
import 'package:trash_track_mobile/features/garbage/screens/add-garbage.dart';
import 'package:trash_track_mobile/features/garbage/services/garbages_service.dart';
import 'package:trash_track_mobile/features/notifications/services/notification_provider.dart';
import 'package:trash_track_mobile/features/order/services/order_service.dart';
import 'package:trash_track_mobile/features/products/screens/product_screen.dart';
import 'package:trash_track_mobile/features/products/services/product_service.dart';
import 'package:trash_track_mobile/features/quiz/screens/quizzes_screen.dart';
import 'package:trash_track_mobile/features/quiz/services/quiz_service.dart';
import 'package:trash_track_mobile/features/report/screens/add_report.dart';
import 'package:trash_track_mobile/features/report/screens/garbage_map.dart';
import 'package:trash_track_mobile/features/report/services/reports_service.dart';
import 'package:trash_track_mobile/features/reservation/screens/add-reservation.dart';
import 'package:trash_track_mobile/features/reservation/services/reservation_service.dart';
import 'package:trash_track_mobile/features/schedules/service/schedule_service.dart';
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
        ChangeNotifierProvider(create: (context) => QuizService()),
        ChangeNotifierProvider(create: (context) => ScheduleService()),
        ChangeNotifierProvider(create: (context) => ProductService()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderService()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
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
