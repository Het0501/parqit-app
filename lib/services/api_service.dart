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

  // ==========================================================================
  // Screen 2 — Auth  (🔄 MOCK — connect when API is marked ✅ Ready)
  // ==========================================================================

  /// POST /auth/login
  ///
  /// Sends an OTP to the given phone number.
  /// Mock: simulates a 1-second network delay and always succeeds.
  ///
  /// Throws a [String] error message on failure (for UI to display).
  Future<void> sendOtp(String phoneNumber) async {
    // TODO: replace with real API call when marked ✅ Ready
    // final response = await _dio.post('/auth/login', data: {'phone': phoneNumber});

    // MOCK — simulate network latency
    await Future.delayed(const Duration(milliseconds: 1000));

    // MOCK — validate phone length only (real validation happens server-side)
    if (phoneNumber.length != 10) {
      throw 'Please enter a valid 10-digit phone number.';
    }

    // MOCK success — OTP "sent"
  }

  /// POST /auth/verify-otp
  ///
  /// Verifies the OTP entered by the user.
  /// Mock: accepts '1234' as the valid OTP for any phone number.
  ///
  /// Returns a mock JWT token string on success.
  /// Throws a [String] error message on failure (for UI to display).
  Future<String> verifyOtp(String phoneNumber, String otp) async {
    // TODO: replace with real API call when marked ✅ Ready
    // final response = await _dio.post(
    //   '/auth/verify-otp',
    //   data: {'phone': phoneNumber, 'otp': otp},
    // );
    // return response.data['token'] as String;

    // MOCK — simulate network latency
    await Future.delayed(const Duration(milliseconds: 1000));

    // MOCK — fixed OTP for testing. Any phone, OTP must be '1234'.
    if (otp != '1234') {
      throw 'Invalid OTP. Please try again.';
    }

    // MOCK — return a fake JWT token
    return 'mock_jwt_token_parqit_user_${phoneNumber.substring(6)}';
  }

  // TODO (Screen 3): GET  /api/lots?lat=&lng=
  // ==========================================================================
  // Screen 4 — Slots (🔄 MOCK)
  // ==========================================================================

  /// GET /api/slots/:lotId
  ///
  /// Fetches the current grid of parking slots for a specific lot.
  /// Mock: Returns a static grid of 24 slots (mix of empty/occupied) after 1-second delay.
  Future<List<Map<String, dynamic>>> fetchSlots(String lotId) async {
    // TODO: replace with real API call when marked ✅ Ready
    // final response = await _dio.get('/api/slots/$lotId');
    // return List<Map<String, dynamic>>.from(response.data['slots']);

    // MOCK — simulate network latency
    await Future.delayed(const Duration(milliseconds: 1000));

    // MOCK DATA - static grid
    return [
      {"slotId": "A1", "status": "empty"},
      {"slotId": "A2", "status": "occupied"},
      {"slotId": "A3", "status": "empty"},
      {"slotId": "A4", "status": "empty"},
      {"slotId": "B1", "status": "occupied"},
      {"slotId": "B2", "status": "occupied"},
      {"slotId": "B3", "status": "empty"},
      {"slotId": "B4", "status": "empty"},
      {"slotId": "C1", "status": "empty"},
      {"slotId": "C2", "status": "empty"},
      {"slotId": "C3", "status": "occupied"},
      {"slotId": "C4", "status": "empty"},
      {"slotId": "D1", "status": "occupied"},
      {"slotId": "D2", "status": "empty"},
      {"slotId": "D3", "status": "empty"},
      {"slotId": "D4", "status": "empty"},
    ];
  }

  // TODO (Screen 5): POST /api/bookings
  // TODO (Screen 6): POST /api/payment/verify
}
