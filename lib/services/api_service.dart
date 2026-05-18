import 'package:dio/dio.dart';

/// Central API service for the PARQIT app.
///
/// RULES (from README):
///  • ALL network calls go through this file — never from screen files.
///  • NEVER hardcode the base URL anywhere except this file.
///  • Use mock data for any endpoint not yet marked ✅ Ready in the API Docs.
///
/// Base URL:
///  Development  → CFO's laptop IP on the same WiFi network (see below).
///  Deployment   → Railway URL provided by CFO after deployment.
class ApiService {
  // ------------------------------------------------------------------
  // DEVELOPMENT: replace CFO_LAPTOP_IP with CFO's actual IP address
  // when working on the same WiFi network.
  // ------------------------------------------------------------------
  static const String baseUrl = 'http://CFO_LAPTOP_IP:3000';

  // ------------------------------------------------------------------
  // DEPLOYMENT: comment out the line above and uncomment this one
  // when CFO deploys to Railway:
  // static const String baseUrl = 'https://parqit-backend.railway.app';
  // ------------------------------------------------------------------

  // ignore: unused_field  — will be used when screens connect to the API
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // TODO (Screen 2): POST /auth/login
  // TODO (Screen 2): POST /auth/verify-otp
  // TODO (Screen 3): GET  /api/lots?lat=&lng=
  // TODO (Screen 4): GET  /api/slots/:lotId
  // TODO (Screen 5): POST /api/bookings
  // TODO (Screen 6): POST /api/payment/verify
}
