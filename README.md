# README — CEO · Flutter Frontend Layer
> **PARQIT · Smart Parking Reimagined for India · Consumer App**

---

## ROLE

You are the **Consumer Face**. You own everything the end user sees and touches:
the login flow, the map-based slot discovery, the booking experience, the payment
screen, and the QR code that opens the barrier gate.

You are the **first thing a real user interacts with**. Your screens must feel
fast, clean, and trustworthy. A driver who books a slot in under 60 seconds
without confusion is the demo. Make every tap feel obvious.

---

## OWNERSHIP — FILES YOU MAY TOUCH

```
parqit-app/
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── slot_screen.dart
│   │   ├── booking_screen.dart
│   │   ├── payment_screen.dart
│   │   └── qr_screen.dart
│   ├── widgets/          ← reusable UI components
│   ├── models/           ← data models matching API responses
│   ├── services/
│   │   └── api_service.dart   ← ALL API calls live here and nowhere else
│   └── utils/            ← constants, helpers, theme
├── assets/               ← images, icons, fonts
└── pubspec.yaml
```

---

## YOU ONLY HAVE ACCESS TO THIS REPO

Do not attempt to access or modify any other codebase.
You cannot see the backend code. You cannot see the hardware code.
You do not need to. Everything you need to connect to the backend
is in the API Docs Google Doc below.

---

## YOUR EXTERNAL REFERENCE — READ THIS BEFORE EVERY SCREEN

**PARQIT API Docs Google Doc — [paste Google Doc link here]**

This is the only place you check for:
- What APIs exist and what they are called
- What input each API expects (exact field names)
- What output each API returns (exact field names)
- Whether an API is ✅ Ready to connect or still 🔄 In Progress

**Rules for using the API Doc:**
- Never assume a field name. Always check the doc.
- Never connect a screen to an API marked 🔄 In Progress or ⏳ Not Started.
- Use mock data that matches the doc's output shape while an API is not ready.
- If a field name in the doc says "slotId" — your Flutter model uses "slotId".
  Not "slot_id". Not "id". Exact match always.

---

## YOUR DELIVERABLE — 7 SCREENS

Build these screens in this exact order. Finish one completely before starting the next.

### Screen 1 — Splash Screen
- PARQIT logo centered on screen
- 2 second delay then navigate to Login
- No logic. Just brand.

### Screen 2 — Login Screen
- Phone number input field
- "Send OTP" button
- OTP input field (appears after OTP is sent)
- "Verify" button
- Calls: `POST /auth/login` then `POST /auth/verify-otp`
- On success: navigate to Home Screen

### Screen 3 — Home Screen
- Google Maps widget showing user's current location
- Nearby parking lots shown as map markers
- List of nearby lots below the map (lot name, distance, price/hour, slots available)
- Calls: `GET /api/lots?lat=&lng=`
- Tap on a lot → navigate to Slot Screen

### Screen 4 — Slot Screen
- Grid of parking slots for the selected lot
- Green tile = empty slot, Red tile = occupied slot
- Lot name, address, price/hour shown at top
- Calls: `GET /api/slots/:lotId`
- Tap on a green slot → navigate to Booking Screen

### Screen 5 — Booking Screen
- Selected slot shown (Lot name + Slot ID)
- Start time picker
- End time picker
- Auto-calculated fare shown
- "Confirm Booking" button
- Calls: `POST /api/bookings`
- On success: navigate to Payment Screen

### Screen 6 — Payment Screen
- Booking summary (lot, slot, time, fare)
- "Pay via UPI" button → Razorpay SDK
- "Pay via Card" button → Razorpay SDK
- On payment success: navigate to QR Screen
- Calls: `POST /api/payment/verify` after Razorpay callback

### Screen 7 — QR Screen
- Large QR code centered on screen (generated from booking token)
- Booking details below: lot name, slot ID, time window
- "My Bookings" button → navigate to booking history
- QR data comes from booking API response
- Uses: `qr_flutter` package

---

## TECH STACK — NO DEVIATIONS

| Component | Library |
|---|---|
| Framework | Flutter (Dart) |
| API calls | `dio` package |
| Maps | `google_maps_flutter` |
| Payments | `razorpay_flutter` |
| QR generation | `qr_flutter` |
| State management | `provider` or `setState` (keep it simple) |

Do **not** introduce new packages without checking with the team.
Do **not** switch to a different maps provider.
Do **not** build your own payment UI — use Razorpay SDK only.

---

## HOW YOU CONNECT TO THE BACKEND

All API calls go through `lib/services/api_service.dart`. Never call APIs
directly from a screen file.

```dart
// lib/services/api_service.dart

import 'package:dio/dio.dart';

class ApiService {
  // DURING DEVELOPMENT — CFO runs backend on his laptop
  // He will give you his laptop IP when you are on the same WiFi
  static const String baseUrl = "http://CFO_LAPTOP_IP:3000";

  // AFTER DEPLOYMENT — CFO gives you the Railway URL
  // static const String baseUrl = "https://parqit-backend.railway.app";

  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
}
```

Two phases:
- **Development:** CFO gives you his laptop IP. You put it here. All on same WiFi.
- **Deployment:** CFO deploys to Railway. He gives you the public URL. You update here.

One line change. That is the only connection update ever needed.

---

## MOCK DATA PATTERN — USE WHILE API IS NOT READY

While CFO is building an API, use mock data that matches the shape shown in the API Doc.
Switch to real API call the moment CFO marks it ✅ Ready.

```dart
// Example: use this while GET /api/slots/:lotId is not ready
final mockSlots = [
  {"slotId": "A1", "status": "empty"},
  {"slotId": "A2", "status": "occupied"},
  {"slotId": "A3", "status": "empty"},
];

// The moment CFO marks it ✅ Ready — replace with:
final response = await _dio.get('/api/slots/$lotId');
final slots = response.data['slots'];
```

---

## AI AGENT RULES

> You are an AI coding agent building this Flutter app.
> Follow these rules at all times — no exceptions.

```
HARD RULES — FLUTTER FRONTEND:

1. NEVER put API calls directly in screen files.
   ALL network calls go through lib/services/api_service.dart only.

2. NEVER hardcode the backend URL anywhere except api_service.dart.
   One place. One change. Done.

3. NEVER build screens out of order.
   Splash → Login → Home → Slot → Booking → Payment → QR.
   Finish each completely before starting the next.

4. NEVER connect a screen to an API that is not marked ✅ Ready
   in the API Docs Google Doc. Use mock data until then.

5. NEVER assume a field name. Always check the API Docs Google Doc.
   If doc says "slotId" — use "slotId". Not "slot_id". Not "id".

6. NEVER attempt to access or modify parqit-backend or parqit-hardware.
   You only have access to this repo.

7. NEVER use raw user PII in API calls beyond the auth screens.
   User is identified by JWT token after login everywhere else.

8. ALWAYS handle API errors gracefully.
   Show a user-friendly error message. Never show raw error strings to the user.

9. ALWAYS test each screen with mock data before connecting to real API.

10. If you are unsure about an API field name or response shape, STOP.
    Check the PARQIT API Docs Google Doc. Do not guess.
```

---

## GIT RULES

- Work exclusively in the `parqit-app/` repository.
- Branch naming: `ceo/screen-name` (e.g. `ceo/login-screen`, `ceo/home-screen`)
- One branch per screen. Complete the screen, then Pull Request → dev.
- Commit after every meaningful piece of UI — not just at the end of the day.
- Do **not** push directly to `main`.
- Do **not** commit API keys or secrets.

### Daily git routine:
```bash
# Morning — get latest code
git pull origin dev

# Create branch for today's screen
git checkout -b ceo/slot-screen

# Build the screen...

# Evening — save and push
git add .
git commit -m "built slot grid UI with green/red tiles"
git push origin ceo/slot-screen

# When screen is complete → GitHub → Pull Request → dev
```

---

## INTEGRATION CHECKPOINTS

| Milestone | You must deliver |
|---|---|
| Week 1 End | Splash + Login + Home screens UI complete with mock data |
| Week 2 End | Slot + Booking + Payment + QR screens UI complete with mock data |
| Week 3 Start | Connect Login screen to auth API — real OTP working |
| Week 3 Mid | Connect Home + Slot screens to lots and slots APIs |
| Week 3 End | Connect Booking + Payment + QR screens to remaining APIs |
| Month 2 | **FULL DEMO READY** — all screens connected, real booking flow working |

---

## TESTING RESPONSIBILITIES

Before each checkpoint, verify:

- [ ] Splash screen shows and navigates to Login after 2 seconds
- [ ] Login screen sends OTP and verifies on a real phone number
- [ ] Home screen loads nearby lots from API and shows on map
- [ ] Slot screen shows correct green/red grid for a real lot
- [ ] Booking screen calculates fare correctly for selected time window
- [ ] Payment screen triggers Razorpay and handles success/failure
- [ ] QR screen shows scannable QR code after successful payment
- [ ] All screens handle API errors without crashing

---

## DEFINITION OF DONE

You are done when **all of the following are true**:

- [ ] All 7 screens built and connected to live APIs
- [ ] Real OTP login working on a real phone number
- [ ] Real parking lot slots loading from database
- [ ] Real booking created and stored in database
- [ ] Real Razorpay payment processed in test mode
- [ ] Real QR code generated and scannable by CTO's hardware camera
- [ ] App does not crash on any API error
- [ ] Full flow works: Login → Find Lot → Select Slot → Book → Pay → QR → Scan → Gate Opens

---

*API Docs Google Doc is LAW. If in doubt, check the doc. Do not guess.*
