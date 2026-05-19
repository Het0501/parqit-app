import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/slot_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/qr_screen.dart';
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
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/slots':
            final lot = settings.arguments as ParkingLot;
            return MaterialPageRoute(
              builder: (_) => SlotScreen(lot: lot),
            );
          case '/booking':
            final args = settings.arguments as BookingScreenArgs;
            return MaterialPageRoute(
              builder: (_) => BookingScreen(args: args),
            );
          case '/payment':
            final args = settings.arguments as PaymentScreenArgs;
            return MaterialPageRoute(
              builder: (_) => PaymentScreen(args: args),
            );
          case '/qr':
            return MaterialPageRoute(builder: (_) => const QRScreen());
          default:
            return null;
        }
      },
    );
  }
}
