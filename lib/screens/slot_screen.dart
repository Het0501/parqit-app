import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/parking_lot.dart';
import '../models/parking_slot.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import 'booking_screen.dart';

class SlotScreen extends StatefulWidget {
  final ParkingLot lot;

  const SlotScreen({super.key, required this.lot});

  @override
  State<SlotScreen> createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen> {
  final ApiService _apiService = ApiService();
  
  List<ParkingSlot> _slots = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSlots();
  }

  Future<void> _fetchSlots() async {
    try {
      final rawSlots = await _apiService.fetchSlots(widget.lot.id);
      final slots = rawSlots.map((s) => ParkingSlot.fromJson(s)).toList();
      
      if (mounted) {
        setState(() {
          _slots = slots;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load slots. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  void _onSlotTap(ParkingSlot slot) {
    if (!slot.isAvailable) return;
    
    // Navigate to Booking Screen
    Navigator.of(context).pushNamed(
      '/booking',
      arguments: BookingScreenArgs(lot: widget.lot, slot: slot),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: Text(
          'Select a Slot',
          style: AppTextStyles.h2,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildGridContent()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.inputBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.lot.name,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.lot.address,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.currency_rupee, color: AppColors.accentCyan, size: 16),
              Text(
                '${widget.lot.pricePerHour} / hour',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentCyan,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.lot.availableSlots} slots left',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentCyan,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accentCyan),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: GoogleFonts.inter(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _fetchSlots();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _slots.length,
      itemBuilder: (context, index) {
        final slot = _slots[index];
        final isAvailable = slot.isAvailable;
        
        return GestureDetector(
          onTap: () => _onSlotTap(slot),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isAvailable ? AppColors.slotAvailable.withValues(alpha: 0.15) : AppColors.slotOccupied.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isAvailable ? AppColors.slotAvailable : AppColors.slotOccupied,
                width: 1.5,
              ),
              boxShadow: isAvailable ? [
                BoxShadow(
                  color: AppColors.slotAvailable.withValues(alpha: 0.2),
                  blurRadius: 8,
                )
              ] : [],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    slot.slotId,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isAvailable ? AppColors.textPrimary : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    isAvailable ? Icons.local_parking : Icons.block,
                    size: 16,
                    color: isAvailable ? AppColors.slotAvailable : AppColors.slotOccupied,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
