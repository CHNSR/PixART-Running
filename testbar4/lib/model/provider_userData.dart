import 'package:flutter/material.dart';
import 'package:testbar4/database/Fire_User.dart'; // ตรวจสอบให้แน่ใจว่าพาธนี้ถูกต้อง

class UserDataPV extends ChangeNotifier {
  PixARTUser pixARTUser = PixARTUser();

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;

  UserDataPV() {
    _initializeUserData();
  }

  // เริ่มต้นข้อมูลผู้ใช้และตรวจสอบสถานะผู้ดูแล
  Future<void> _initializeUserData() async {
    await _fetchUserData(); // ดึงข้อมูลผู้ใช้ก่อน
    _checkAdminStatus();
    print("[Provider] Userdata :$userData"); // ตรวจสอบว่าผู้ใช้เป็นผู้ดูแลหรือไม่ตามข้อมูลที่ดึงมา
  }

  // ดึงข้อมูลผู้ใช้จาก Firestore
  Future<void> _fetchUserData() async {
    try {
      _userData = await PixARTUser.fetchUserData();
      print("[Provider][_fetchUserData:]----_userdata:$_userData");
      _checkAdminStatus(); // ตรวจสอบสถานะผู้ดูแลหลังจากดึงข้อมูล
      notifyListeners(); // แจ้งเตือนผู้ฟังหลังจากดึงข้อมูลผู้ใช้
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // อัปเดตข้อมูลผู้ใช้
  Future<void> updateUserData({
    String? email,
    String? password,
    String? name,
    String? weight,
    String? height,
    // String? birthday,
    String? weeklyGoal,
  }) async {
    try {
      // แปลงสตริงเป็นประเภทที่ถูกต้อง
      final double? weightValue = weight != null ? double.tryParse(weight) : null;
      final double? heightValue = height != null ? double.tryParse(height) : null;
      /*
      final DateTime? birthdayValue = birthday != null ? DateTime.tryParse(birthday) : null;
      */
      final int? weeklyGoalValue = weeklyGoal != null ? int.tryParse(weeklyGoal) : null;

      // เรียก PixARTUser เพื่ออัปเดตฐานข้อมูล
      await PixARTUser.updateUserData(
        email: email,
        password: password,
        name: name,
        weight: weightValue,
        height: heightValue,
        // birthday: birthdayValue,
        weeklyGoal: weeklyGoalValue,
      );

      // ดึงข้อมูลผู้ใช้ที่อัปเดตแล้ว
      await _fetchUserData();
      _checkAdminStatus(); // ตรวจสอบสถานะผู้ดูแลอีกครั้งหลังจากอัปเดตข้อมูล
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  // รีเฟรชข้อมูลผู้ใช้
  Future<void> refreshUserData() async {
    try {
      await _fetchUserData(); // ดึงและอัปเดต _userData
      print("[Provider][refreshUserData:] Refresh successful");
    } catch (e) {
      print('[Provider][refreshUserData:] Error refreshing user data: $e');
    }
  }

  // ตรวจสอบว่าผู้ใช้เป็นผู้ดูแลหรือไม่
  void _checkAdminStatus() {
    if (_userData != null && _userData?['role'] == 'admin') {
      _isAdmin = true;
    } else {
      _isAdmin = false;
    }
    notifyListeners(); // แจ้งเตือนผู้ฟังหลังจากตรวจสอบสถานะผู้ดูแล
    print("[Provider][_checkAdminStatus:] _isAdmin: $_isAdmin");
  }

  // เมธอดล้างข้อมูลผู้ใช้เมื่อออกจากระบบ
  void clearUserData() {
    _userData = null;
    _isAdmin = false;
    notifyListeners(); // แจ้งเตือนผู้ฟังเพื่ออัปเดต UI
    print("[UserProvider][clearUserData]-----> userData: $_userData, isAdmin: $isAdmin");
  }
}
