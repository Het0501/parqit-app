import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/splash_screen.dart';
import 'screens/slot_screen.dart';
import 'screens/booking_screen.dart';
import 'models/parking_lot.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Use edge-to-edge display so splash fills the status bar area
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ParqitApp());
}

class ParqitApp extends StatelessWidget {
  const ParqitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parqit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/slots') {
          final lot = settings.arguments as ParkingLot;
          return MaterialPageRoute(
            builder: (context) => SlotScreen(lot: lot),
          );
        } else if (settings.name == '/booking') {
          final args = settings.arguments as BookingScreenArgs;
          return MaterialPageRoute(
            builder: (context) => BookingScreen(args: args),
          );
        }
        return null;
      },
    );
  }
}
