import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/parking_lot.dart';
import '../models/parking_slot.dart';
import '../utils/app_colors.dart';
import '../widgets/primary_button.dart';

class PaymentScreenArgs {
  final ParkingLot lot;
  final ParkingSlot slot;
  final DateTime date;
  final String time;
  final int durationHours;
  final double baseFare;
  final double taxAmount;
  final double convenienceFee;
  final double totalFare;

  PaymentScreenArgs({
    required this.lot,
    required this.slot,
    required this.date,
    required this.time,
    required this.durationHours,
    required this.baseFare,
    required this.taxAmount,
    required this.convenienceFee,
    required this.totalFare,
  });
}

class PaymentScreen extends StatefulWidget {
  final PaymentScreenArgs args;

  const PaymentScreen({super.key, required this.args});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with SingleTickerProviderStateMixin {
  // Payment methods selection
  String _selectedMethod = 'upi'; // 'upi', 'card', 'wallet'
  
  // Promo code
  final TextEditingController _promoController = TextEditingController();
  double _promoDiscount = 0.0;
  String? _appliedPromo;
  String? _promoError;

  // Processing state
  bool _isProcessing = false;
  bool _isSuccess = false;

  // Animation controller for checkmark success
  late AnimationController _successAnimController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _successAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _successAnimController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _promoController.dispose();
    _successAnimController.dispose();
    super.dispose();
  }

  double get _discountedTotal {
    final double total = widget.args.totalFare - _promoDiscount;
    return total < 0 ? 0.0 : total;
  }

  void _applyPromo() {
    final code = _promoController.text.trim().toUpperCase();
    setState(() {
      _promoError = null;
      if (code == 'PARQIT50') {
        _promoDiscount = 50.0;
        _appliedPromo = code;
      } else if (code == 'PARQIT20') {
        _promoDiscount = widget.args.baseFare * 0.20;
        _appliedPromo = code;
      } else if (code.isEmpty) {
        _promoError = 'Please enter a promo code';
      } else {
        _promoError = 'Invalid promo code';
        _promoDiscount = 0.0;
        _appliedPromo = null;
      }
    });
  }

  void _removePromo() {
    setState(() {
      _promoController.clear();
      _promoDiscount = 0.0;
      _appliedPromo = null;
      _promoError = null;
    });
  }

  Future<void> _startPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment transaction latency
    await Future.delayed(const Duration(milliseconds: 2200));

    if (!mounted) return;
    setState(() {
      _isProcessing = false;
      _isSuccess = true;
    });

    // Run checkmark animation
    _successAnimController.forward();

    // Transition to QR Ticket Screen after success animation
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/qr', (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: Text(
          'Payment Info',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryCard(),
                      const SizedBox(height: 20),
                      _buildPromoSection(),
                      const SizedBox(height: 20),
                      _buildPaymentMethods(),
                      const SizedBox(height: 24),
                      _buildFareSummary(),
                      const SizedBox(height: 32),
                      _buildPayButton(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isProcessing) _buildProcessingOverlay(),
          if (_isSuccess) _buildSuccessOverlay(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final dateStr = "${widget.args.date.day.toString().padLeft(2, '0')}/${widget.args.date.month.toString().padLeft(2, '0')}/${widget.args.date.year}";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_parking, color: AppColors.accentCyan, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.args.lot.name,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      widget.args.lot.address,
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.inputBorder, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(Icons.calendar_today, 'Date', dateStr),
              _buildSummaryItem(Icons.access_time, 'Time', widget.args.time),
              _buildSummaryItem(Icons.hourglass_empty, 'Duration', '${widget.args.durationHours} hrs'),
              _buildSummaryItem(Icons.pin, 'Slot', widget.args.slot.slotId),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPromoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Promo Code',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _promoError != null ? AppColors.error : AppColors.inputBorder,
                      ),
                    ),
                    child: TextField(
                      controller: _promoController,
                      enabled: _appliedPromo == null,
                      style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Enter Promo Code (e.g. PARQIT50)',
                        hintStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (_promoError != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _promoError!,
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.error),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _appliedPromo != null ? _removePromo : _applyPromo,
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: _appliedPromo != null ? AppColors.error.withValues(alpha: 0.15) : AppColors.accentCyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _appliedPromo != null ? AppColors.error : AppColors.accentCyan,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  _appliedPromo != null ? 'Remove' : 'Apply',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _appliedPromo != null ? AppColors.error : AppColors.accentCyan,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Methods',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        _buildMethodTile('upi', 'UPI (Google Pay, PhonePe, etc.)', Icons.account_balance_wallet_outlined),
        const SizedBox(height: 10),
        _buildMethodTile('card', 'Credit or Debit Card', Icons.credit_card_outlined),
        const SizedBox(height: 10),
        _buildMethodTile('wallet', 'Wallets (Paytm, Amazon Pay)', Icons.wallet_outlined),
      ],
    );
  }

  Widget _buildMethodTile(String method, String title, IconData icon) {
    final isSelected = _selectedMethod == method;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentCyan.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.accentCyan : AppColors.inputBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.accentCyan : AppColors.textSecondary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.accentCyan : AppColors.textMuted,
                  width: isSelected ? 5.5 : 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFareSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        children: [
          _buildFareRow('Subtotal', widget.args.baseFare),
          const SizedBox(height: 10),
          _buildFareRow('Convenience Fee', widget.args.convenienceFee),
          const SizedBox(height: 10),
          _buildFareRow('GST (18%)', widget.args.taxAmount),
          if (_promoDiscount > 0) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Promo Discount (${_appliedPromo})',
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.success),
                ),
                Text(
                  '-₹${_promoDiscount.toStringAsFixed(1)}',
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.success, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: AppColors.inputBorder, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              Text(
                '₹${_discountedTotal.toStringAsFixed(1)}',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.accentCyan),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFareRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          '₹${amount.toStringAsFixed(1)}',
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentCyan.withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: PrimaryButton(
        label: 'Pay ₹${_discountedTotal.toStringAsFixed(1)}',
        onPressed: _startPayment,
      ),
    );
  }

  Widget _buildProcessingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.accentCyan),
          const SizedBox(height: 20),
          Text(
            'Processing Payment...',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Please do not press back or close the app',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      alignment: Alignment.center,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success,
              ),
              child: const Icon(Icons.check, color: Colors.black, size: 48),
            ),
            const SizedBox(height: 24),
            Text(
              'Payment Successful!',
              style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Generating your ticket...',
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
