import 'package:flutter/material.dart';

class BMIViewModel extends ChangeNotifier {
  double? _bmi;
  String _message = "Enter your details";
  Color _statusColor = Colors.white54;

  double? get bmi => _bmi;
  String get message => _message;
  Color get statusColor => _statusColor;

  void calculateBMI(String heightText, String weightText) {
    double? height = double.tryParse(heightText);
    double? weight = double.tryParse(weightText);

    if (height != null && weight != null && height > 0) {
      double heightInMeters = height / 100;
      _bmi = weight / (heightInMeters * heightInMeters);
      _updateStatus();
      notifyListeners();
    } else {
      _bmi = null;
      _message = "Enter your details";
      _statusColor = Colors.white54;
      notifyListeners();
    }
  }

  void _updateStatus() {
    if (_bmi == null) return;
    if (_bmi! < 18.5) {
      _message = "Underweight";
      _statusColor = Colors.lightBlueAccent;
    } else if (_bmi! < 25) {
      _message = "Normal Weight";
      _statusColor = Colors.greenAccent;
    } else if (_bmi! < 30) {
      _message = "Overweight";
      _statusColor = Colors.orangeAccent;
    } else {
      _message = "Obese";
      _statusColor = Colors.redAccent;
    }
  }
}
