import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:tradetrac/feature/auth/provider/auth_pod.dart';
import '../../core/faildialog.dart';
import 'provider/attendence_provider.dart';
import '../../utils/constant/color_constants.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isCheckedIn = false;
  String _currentTime = "";
  String _currentDate = "";
  String _currentLocationAddress = "Fetching location...";
  Position? _currentPosition;
  Timer? _timer;
  String _elapsedTime = "0 hr";
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _updateTime(),
    );
    context.read<AttendanceProvider>().attendance;
    _getCurrentLocation();
    _loadAttendanceData();
  }

  void _loadAttendanceData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final attendanceProvider = context.read<AttendanceProvider>();
      final salesRepId = authProvider.user?.data.user.id ?? 0;
      // Load attendance summary
      attendanceProvider.getAttendanceSummary(salesRepId);
      // Load attendance by rep
      attendanceProvider.getAttendanceByRep(salesRepId);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();

    // Calculate elapsed time if checked in
    String elapsedTimeStr = "0 hr";
    if (mounted) {
      final provider = context.read<AttendanceProvider>();
      if (provider.checkInTime != null) {
        final duration = now.difference(provider.checkInTime!);
        final hours = duration.inHours;
        final minutes = duration.inMinutes.remainder(60);
        final seconds = duration.inSeconds.remainder(60);
        elapsedTimeStr = "${hours}h ${minutes}m ${seconds}s";
      }
    }

    setState(() {
      _currentTime = DateFormat('hh:mm a').format(now);
      _currentDate = DateFormat('EEEE, d MMMM y').format(now);
      _elapsedTime = elapsedTimeStr;
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocationAddress = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentLocationAddress = "Location permissions are denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentLocationAddress =
            "Location permissions are permanently denied, we cannot request permissions.";
      });
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentPosition = position;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentLocationAddress =
              "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        });
      } else {
        setState(() {
          _currentLocationAddress = "Address not found";
        });
      }
    } catch (e) {
      setState(() {
        _currentLocationAddress = "Error getting location: $e";
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      context.read<AttendanceProvider>().getAttendanceByDate(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sync local state with provider state
    final provider = context.watch<AttendanceProvider>();
    if (provider.checkInTime != null && !_isCheckedIn) {
      _isCheckedIn = true;
    } else if (provider.checkInTime == null && _isCheckedIn) {
      _isCheckedIn = false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text(
          'Attendance',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Time and date display
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Text(
                  _currentTime,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentDate,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Main content area (white background)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Hours counter
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: _isCheckedIn
                              ? AppColors.primaryColor
                              : Colors.grey.shade300,
                          width: 8,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _elapsedTime,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _isCheckedIn
                                    ? AppColors.primaryColor
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Attendance Summary Section
                    _buildAttendanceSummary(provider),
                    const SizedBox(height: 20),

                    // Current location
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.location_on_outlined,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Current Location",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _currentLocationAddress,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: _getCurrentLocation,
                            child: const Text(
                              "Refresh",
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Check in/out button
                    Consumer<AttendanceProvider>(
                      builder: (context, provider, child) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: provider.isLoading
                                ? null
                                : () async {
                                    var inid = context
                                        .read<AuthProvider>()
                                        .user
                                        ?.data
                                        .user
                                        .id;
                                    var outid =
                                        context
                                            .read<AttendanceProvider>()
                                            .attendance
                                            ?.data
                                            .id ??
                                        0;
                                    if (_isCheckedIn) {
                                      // Check out
                                      final success = await provider.checkout(
                                        outid,
                                      );
                                      if (success) {
                                        setState(() {
                                          _isCheckedIn = false;
                                        });
                                        if (context.mounted) {
                                          MessagePresenter.show(
                                            context: context,
                                            message:
                                                "Checked out successfully!",
                                            level: MessageLevel.success,
                                            mode: MessageMode.dialog,
                                          );
                                        }
                                      } else {
                                        if (context.mounted) {
                                          MessagePresenter.show(
                                            context: context,
                                            message:
                                                provider.errorMessage ??
                                                "Checkout failed",
                                            level: MessageLevel.error,
                                            mode: MessageMode.dialog,
                                          );
                                        }
                                      }
                                    } else {
                                      // Check in
                                      // Using real location
                                      final success = await provider
                                          .markAttendance(
                                            _currentPosition?.latitude
                                                    .toString() ??
                                                "0.0",
                                            _currentPosition?.longitude
                                                    .toString() ??
                                                "0.0",
                                            _currentLocationAddress,
                                            inid ?? 0,
                                          );
                                      if (success) {
                                        setState(() {
                                          _isCheckedIn = true;
                                        });
                                        if (context.mounted) {
                                          MessagePresenter.show(
                                            context: context,
                                            message: "Checked in successfully!",
                                            level: MessageLevel.success,
                                            mode: MessageMode.dialog,
                                          );
                                        }
                                      } else {
                                        if (context.mounted) {
                                          MessagePresenter.show(
                                            context: context,
                                            message:
                                                provider.errorMessage ??
                                                "Check-in failed",
                                            level: MessageLevel.error,
                                            mode: MessageMode.dialog,
                                          );
                                        }
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isCheckedIn
                                  ? Colors.red
                                  : AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: provider.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    _isCheckedIn ? "Check Out" : "Check In",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    // Attendance history header with date picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Attendance History",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _selectDate(context),
                          icon: const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: AppColors.primaryColor,
                          ),
                          label: Text(
                            DateFormat('MMM dd, yyyy').format(_selectedDate),
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Attendance history items from API
                    _buildAttendanceHistory(provider),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build attendance summary widget
  Widget _buildAttendanceSummary(AttendanceProvider provider) {
    final summary = provider.attendanceSummary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.1),
            AppColors.primaryColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: AppColors.primaryColor,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "Attendance Summary",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (provider.isLoading && summary == null)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
          else if (summary != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  icon: Icons.calendar_month,
                  label: "Total Days",
                  value:
                      "${summary['totalDays'] ?? summary['total_days'] ?? 0}",
                  color: Colors.blue,
                ),
                _buildSummaryItem(
                  icon: Icons.check_circle,
                  label: "Present",
                  value:
                      "${summary['presentDays'] ?? summary['present_days'] ?? 0}",
                  color: Colors.green,
                ),
                _buildSummaryItem(
                  icon: Icons.cancel,
                  label: "Absent",
                  value:
                      "${summary['absentDays'] ?? summary['absent_days'] ?? 0}",
                  color: Colors.red,
                ),
                _buildSummaryItem(
                  icon: Icons.access_time,
                  label: "Avg Hours",
                  value:
                      "${summary['avgHours'] ?? summary['average_hours'] ?? '0'}h",
                  color: Colors.orange,
                ),
              ],
            )
          else
            const Center(
              child: Text(
                "No summary data available",
                style: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // Build attendance history from API data
  Widget _buildAttendanceHistory(AttendanceProvider provider) {
    if (provider.isLoading && provider.attendanceByDate.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      );
    }
    if (provider.attendanceByDate.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(Icons.event_busy, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              "No attendance records found.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.attendanceByDate.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final attendance = provider.attendanceByDate[index];
        return _buildAttendanceHistoryItem(
          date: _formatDate(
            attendance['date'] ?? attendance['createdAt'] ?? '',
          ),
          checkInTime: _formatTime(
            attendance['checkInTime'] ?? attendance['check_in_time'] ?? '',
          ),
          checkOutTime: _formatTime(
            attendance['checkOutTime'] ?? attendance['check_out_time'] ?? '',
          ),
          isCompleted:
              attendance['checkOutTime'] != null ||
              attendance['check_out_time'] != null,
          location:
              attendance['locationAddress'] ??
              attendance['location_address'] ??
              '',
        );
      },
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEEE, d MMMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(String timeStr) {
    if (timeStr.isEmpty) return "--:--";
    try {
      final time = DateTime.parse(timeStr);
      return DateFormat('hh:mm a').format(time);
    } catch (e) {
      return timeStr;
    }
  }

  Widget _buildAttendanceHistoryItem({
    required String date,
    required String checkInTime,
    required String checkOutTime,
    required bool isCompleted,
    String location = '',
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isCompleted ? Icons.check_circle_outline : Icons.schedule,
              color: isCompleted ? Colors.green : Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Main Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        date,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isCompleted ? "Completed" : "In Progress",
                        style: TextStyle(
                          fontSize: 10,
                          color: isCompleted ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Times
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.login, size: 14, color: Colors.green[700]),
                          const SizedBox(width: 4),
                          Text(
                            checkInTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.logout, size: 14, color: Colors.red[700]),
                          const SizedBox(width: 4),
                          Text(
                            checkOutTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (location.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
