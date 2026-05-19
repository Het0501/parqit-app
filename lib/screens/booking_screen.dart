import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/parking_lot.dart';
import '../models/parking_slot.dart';
import '../utils/app_colors.dart';
import '../widgets/primary_button.dart';
import 'payment_screen.dart';

class BookingScreenArgs {
  final ParkingLot lot;
  final ParkingSlot slot;

  BookingScreenArgs({required this.lot, required this.slot});
}

class BookingScreen extends StatefulWidget {
  final BookingScreenArgs args;

  const BookingScreen({super.key, required this.args});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Date and Time selection state
  late List<DateTime> _selectableDates;
  late int _selectedDateIndex;
  
  final List<String> _timeSlots = [
    '08:00 AM', '09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
    '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM', '05:00 PM',
    '06:00 PM', '07:00 PM', '08:00 PM', '09:00 PM'
  ];
  late int _selectedTimeIndex;
  TimeOfDay? _customTime;

  // Duration selection state
  int _durationHours = 1;

  // Pricing details
  static const double _taxRate = 0.18; // 18% GST
  static const double _convenienceFee = 10.0; // ₹10 convenience fee

  double get _baseFare => (_durationHours * widget.args.lot.pricePerHour).toDouble();
  double get _taxAmount => _baseFare * _taxRate;
  double get _totalFare => _baseFare + _taxAmount + _convenienceFee;

  // Day names for layout
  static const List<String> _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    // Generate dates dynamically (Today + next 6 days)
    _selectableDates = List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
    _selectedDateIndex = 0; // Today selected by default
    _selectedTimeIndex = 1; // Default to 9 AM slot
  }

  void _incrementDuration() {
    setState(() {
      if (_durationHours < 24) _durationHours++;
    });
  }

  void _decrementDuration() {
    setState(() {
      if (_durationHours > 1) _durationHours--;
    });
  }

  Future<void> _selectCustomTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accentCyan,
              onPrimary: AppColors.primaryDark,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accentCyan,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _customTime = picked;
        _selectedTimeIndex = -1; // Deselect slot-based time in favor of custom time
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: Text(
          'Confirm Booking',
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
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationCard(),
                  const SizedBox(height: 24),
                  _buildDateSelector(),
                  const SizedBox(height: 24),
                  _buildTimeSelector(),
                  const SizedBox(height: 24),
                  _buildDurationSelector(),
                  const SizedBox(height: 24),
                  _buildFareSummary(),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    label: 'Proceed to Payment',
                    onPressed: () {
                      final selectedDate = _selectableDates[_selectedDateIndex];
                      final selectedTime = _customTime != null 
                          ? _formatTimeOfDay(_customTime!) 
                          : _timeSlots[_selectedTimeIndex];

                      Navigator.of(context).pushNamed(
                        '/payment',
                        arguments: PaymentScreenArgs(
                          lot: widget.args.lot,
                          slot: widget.args.slot,
                          date: selectedDate,
                          time: selectedTime,
                          durationHours: _durationHours,
                          baseFare: _baseFare,
                          taxAmount: _taxAmount,
                          convenienceFee: _convenienceFee,
                          totalFare: _totalFare,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_parking,
              color: AppColors.accentCyan,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.args.lot.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.args.lot.address,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'Slot ${widget.args.slot.slotId}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        '₹${widget.args.lot.pricePerHour}/hr',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentCyan,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _selectableDates.length,
            itemBuilder: (context, index) {
              final date = _selectableDates[index];
              final isSelected = _selectedDateIndex == index;
              final isToday = index == 0;
              
              final dayStr = isToday ? 'Today' : _weekdays[date.weekday - 1];
              final dateStr = date.day.toString().padLeft(2, '0');

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDateIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accentCyan : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.accentCyan : AppColors.inputBorder,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.accentCyan.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayStr,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dateStr,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelector() {
    final customTimeLabel = _customTime != null ? _formatTimeOfDay(_customTime!) : 'Custom';
    final isCustomSelected = _selectedTimeIndex == -1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Arrival Time',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: _selectCustomTime,
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_filled,
                    color: isCustomSelected ? AppColors.accentCyan : AppColors.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    customTimeLabel,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isCustomSelected ? AppColors.accentCyan : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _timeSlots.length,
            itemBuilder: (context, index) {
              final slot = _timeSlots[index];
              final isSelected = _selectedTimeIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTimeIndex = index;
                    _customTime = null; // Reset custom time if slot selected
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.only(right: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accentCyan : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.accentCyan : AppColors.inputBorder,
                    ),
                  ),
                  child: Text(
                    slot,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDurationButton(Icons.remove, _decrementDuration),
              Column(
                children: [
                  Text(
                    '$_durationHours',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accentCyan,
                    ),
                  ),
                  Text(
                    _durationHours == 1 ? 'Hour' : 'Hours',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              _buildDurationButton(Icons.add, _incrementDuration),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDurationButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        splashColor: AppColors.accentCyan.withValues(alpha: 0.2),
        highlightColor: AppColors.accentCyan.withValues(alpha: 0.1),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.inputBorder, width: 1.5),
            color: AppColors.inputFill,
          ),
          child: Icon(
            icon,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildFareSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fare Breakdown',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Base Fare (${_durationHours}h × ₹${widget.args.lot.pricePerHour})',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '₹${_baseFare.toStringAsFixed(0)}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Convenience Fee',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '₹${_convenienceFee.toStringAsFixed(0)}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GST (18%)',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '₹${_taxAmount.toStringAsFixed(1)}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: AppColors.inputBorder, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Estimated Fare',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '₹${_totalFare.toStringAsFixed(1)}',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentCyan,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
