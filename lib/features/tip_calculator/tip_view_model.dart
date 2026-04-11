import 'package:flutter/material.dart';

class TipViewModel extends ChangeNotifier {
  double _tipPercentage = 15.0;
  double _tipAmount = 0.0;
  double _totalPerPerson = 0.0;

  double get tipPercentage => _tipPercentage;
  double get tipAmount => _tipAmount;
  double get totalPerPerson => _totalPerPerson;

  void setTipPercentage(double value, String billText, String peopleText) {
    _tipPercentage = value;
    calculate(billText, peopleText);
  }

  void calculate(String billText, String peopleText) {
    double? bill = double.tryParse(billText);
    int? people = int.tryParse(peopleText);

    if (bill != null && people != null && people > 0) {
      _tipAmount = bill * (_tipPercentage / 100);
      _totalPerPerson = (bill + _tipAmount) / people;
      notifyListeners();
    } else {
      _tipAmount = 0.0;
      _totalPerPerson = 0.0;
      notifyListeners();
    }
  }
}
