import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../widgets/primary_button.dart';

class ParkingLot {
  final String id;
  final String name;
  final String address;
  final String distance;
  final int pricePerHour;
  final int totalSlots;
  final int availableSlots;

  ParkingLot({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.pricePerHour,
    required this.totalSlots,
    required this.availableSlots,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ParkingLot> mockLots = [
    ParkingLot(
      id: '1',
      name: 'REVA University Parking',
      address: 'Rukmini Knowledge Park, Bengaluru',
      distance: '0.2 km',
      pricePerHour: 20,
      totalSlots: 50,
      availableSlots: 12,
    ),
    ParkingLot(
      id: '2',
      name: 'Forum Mall Parking',
      address: 'Hosur Road, Koramangala',
      distance: '1.2 km',
      pricePerHour: 40,
      totalSlots: 200,
      availableSlots: 34,
    ),
    ParkingLot(
      id: '3',
      name: 'Orion Mall Parking',
      address: 'Dr. Rajkumar Road, Rajajinagar',
      distance: '3.5 km',
      pricePerHour: 50,
      totalSlots: 300,
      availableSlots: 87,
    ),
    ParkingLot(
      id: '4',
      name: 'Manipal Hospital Parking',
      address: 'Old Airport Road, Bengaluru',
      distance: '2.1 km',
      pricePerHour: 30,
      totalSlots: 100,
      availableSlots: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildMapPlaceholder(),
            _buildNearbyLotsHeader(),
            Expanded(child: _buildLotsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good morning 👋',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text('Find Parking',
                  style: AppTextStyles.headingLarge
                      .copyWith(color: AppColors.textPrimary)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.notifications_outlined,
                color: AppColors.textSecondary, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.surface,
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Grid pattern to simulate map
            CustomPaint(
              size: const Size(double.infinity, 200),
              painter: _MapGridPainter(),
            ),
            // Location markers
            Positioned(
              top: 70,
              left: 120,
              child: _buildMapMarker('REVA', true),
            ),
            Positioned(
              top: 100,
              left: 200,
              child: _buildMapMarker('Forum', false),
            ),
            Positioned(
              top: 50,
              left: 260,
              child: _buildMapMarker('Orion', false),
            ),
            Positioned(
              top: 130,
              left: 80,
              child: _buildMapMarker('Manipal', false),
            ),
            // Current location pin
            Positioned(
              top: 85,
              left: 155,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.accentCyan,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentCyan.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
            // Map label
            Positioned(
              bottom: 10,
              right: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on,
                        color: AppColors.accentCyan, size: 12),
                    const SizedBox(width: 4),
                    Text('Bengaluru, Karnataka',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapMarker(String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentCyan : AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.accentCyan : AppColors.surfaceLight,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10,
              color: isSelected ? Colors.black : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: 2,
          height: 8,
          color: isSelected ? AppColors.accentCyan : AppColors.surfaceLight,
        ),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentCyan : AppColors.surfaceLight,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyLotsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Nearby Parking',
              style: AppTextStyles.headingMedium
                  .copyWith(color: AppColors.textPrimary)),
          Text('${mockLots.length} found',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.accentCyan)),
        ],
      ),
    );
  }

  Widget _buildLotsList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: mockLots.length,
      itemBuilder: (context, index) {
        return _buildLotCard(mockLots[index]);
      },
    );
  }

  Widget _buildLotCard(ParkingLot lot) {
    final bool isAlmostFull = lot.availableSlots <= 10;
    final bool isFull = lot.availableSlots == 0;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/slots', arguments: lot);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceLight),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.local_parking,
                  color: AppColors.accentCyan, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lot.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(lot.address,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: AppColors.textSecondary, size: 12),
                      const SizedBox(width: 2),
                      Text(lot.distance,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textSecondary)),
                      const SizedBox(width: 12),
                      Icon(Icons.currency_rupee,
                          color: AppColors.accentCyan, size: 12),
                      Text('${lot.pricePerHour}/hr',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.accentCyan)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isFull
                        ? AppColors.error.withOpacity(0.1)
                        : isAlmostFull
                            ? Colors.orange.withOpacity(0.1)
                            : AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isFull ? 'Full' : '${lot.availableSlots} free',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isFull
                          ? AppColors.error
                          : isAlmostFull
                              ? Colors.orange
                              : AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Icon(Icons.chevron_right,
                    color: AppColors.textSecondary, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E2A3A)
      ..strokeWidth = 1;

    // Draw grid lines
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw some road-like lines
    final roadPaint = Paint()
      ..color = const Color(0xFF2A3A4A)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
        Offset(0, size.height * 0.4),
        Offset(size.width, size.height * 0.4),
        roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.35, 0),
        Offset(size.width * 0.35, size.height),
        roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.65, 0),
        Offset(size.width * 0.65, size.height),
        roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}