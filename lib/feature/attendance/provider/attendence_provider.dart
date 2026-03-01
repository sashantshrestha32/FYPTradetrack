import 'package:flutter/material.dart';
import 'package:tradetrac/feature/attendance/service/attendence_service.dart';
import '../../../utils/storage/sharepref.dart';
import '../model/checkin.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendenceService _attendenceService = AttendenceService();
  final LocalStorage _localStorage = LocalStorage();
  static const String _checkInTimeKey = 'check_in_time';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DateTime? _checkInTime;
  DateTime? get checkInTime => _checkInTime;

  // Attendance summary data
  Map<String, dynamic>? _attendanceSummary;
  Map<String, dynamic>? get attendanceSummary => _attendanceSummary;

  // Attendance by date data
  List<dynamic> _attendanceByDate = [];
  List<dynamic> get attendanceByDate => _attendanceByDate;

  AttendanceProvider() {
    _loadAttendanceState();
  }

  Future<void> _loadAttendanceState() async {
    final timeStr = await _localStorage.getData(_checkInTimeKey);
    if (timeStr != null && timeStr.isNotEmpty) {
      _checkInTime = DateTime.parse(timeStr);
      notifyListeners();
    }
  }

  //check in
  Attendance? _attendance;
  Attendance? get attendance => _attendance;

  Future<bool> markAttendance(
    String latitude,
    String longitude,
    String locationAddress,
    int salesRepId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final attendance = await _attendenceService.markAttendance(
        latitude,
        longitude,
        locationAddress,
        salesRepId,
      );
      if (attendance != null) {
        _attendance = attendance;
      }
      final now = DateTime.now();
      _checkInTime = now;
      await _localStorage.setData(_checkInTimeKey, now.toIso8601String());
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // checkout
  Future<bool> checkout(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _attendenceService.checkout(id);
      _checkInTime = null;
      await _localStorage.setData(_checkInTimeKey, "");
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Get attendance by date
  Future<bool> getAttendanceByDate(String date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final data = await _attendenceService.getAttendancebydate(date);
      _attendanceByDate = data;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Get attendance summary
  Future<bool> getAttendanceSummary(int salesRepId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final data = await _attendenceService.getAttendanceSummary(salesRepId);
      _attendanceSummary = data;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // attendance by rep
  Future<bool> getAttendanceByRep(int salesRepId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final data = await _attendenceService.getAttendancebyrep(salesRepId);
      _attendanceByDate = data;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Clear attendance data
  void clearAttendanceData() {
    _attendanceByDate = [];
    _attendanceSummary = null;
    notifyListeners();
  }
}
