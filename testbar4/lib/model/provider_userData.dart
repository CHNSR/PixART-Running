import 'package:flutter/material.dart';
import 'package:testbar4/database/Fire_User.dart'; // ตรวจสอบให้แน่ใจว่าเส้นทางนี้ถูกต้อง

class UserDataPV extends ChangeNotifier {
  PixARTUser pixARTUser = PixARTUser();

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  UserDataPV() {
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      _userData = await PixARTUser.fetchUserData();
      notifyListeners();
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  //update date
  Future<void> updateUserData({
    String? email,
    String? password,
    String? name,
    String? weight,
    String? height,
    //String? birthday,
    String? weeklyGoal,
  }) async {
    try {
      // Parse strings to correct types
      final double? weightValue =
          weight != null ? double.tryParse(weight) : null;
      final double? heightValue =
          height != null ? double.tryParse(height) : null;
      /*
      final DateTime? birthdayValue =
          birthday != null ? DateTime.tryParse(birthday) : null;
      */
      final int? weeklyGoalValue =
          weeklyGoal != null ? int.tryParse(weeklyGoal) : null;

      // Call PixARTUser to update the database
      await PixARTUser.updateUserData(
        email: email,
        password: password,
        name: name,
        weight: weightValue,
        height: heightValue,
        //birthday: birthdayValue,
        weeklyGoal: weeklyGoalValue,
      );

      // Fetch updated user data
      _fetchUserData();
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  //refresh user data
  Future<void> refreshUserData() async {
    await _fetchUserData();
  }
}
