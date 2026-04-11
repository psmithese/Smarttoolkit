import 'package:flutter/material.dart';

class UnitViewModel extends ChangeNotifier {
  String _currentCategory = "Length";
  String _fromUnit = "Meters";
  String _toUnit = "Kilometers";
  double _result = 0.001;

  final Map<String, List<String>> _categories = {
    "Length": ["Meters", "Kilometers", "Miles", "Feet", "Inches"],
    "Weight": ["Kilograms", "Grams", "Pounds", "Ounces"],
    "Temperature": ["Celsius", "Fahrenheit", "Kelvin"],
  };

  String get currentCategory => _currentCategory;
  String get fromUnit => _fromUnit;
  String get toUnit => _toUnit;
  double get result => _result;
  Map<String, List<String>> get categories => _categories;

  void setCategory(String category, String inputText) {
    _currentCategory = category;
    _fromUnit = _categories[category]![0];
    _toUnit = _categories[category]![1];
    calculate(inputText);
  }

  void setFromUnit(String unit, String inputText) {
    _fromUnit = unit;
    calculate(inputText);
  }

  void setToUnit(String unit, String inputText) {
    _toUnit = unit;
    calculate(inputText);
  }

  void calculate(String inputText) {
    double input = double.tryParse(inputText) ?? 0;
    
    if (_currentCategory == "Length") {
      _result = _convertLength(input, _fromUnit, _toUnit);
    } else if (_currentCategory == "Weight") {
      _result = _convertWeight(input, _fromUnit, _toUnit);
    } else if (_currentCategory == "Temperature") {
      _result = _convertTemp(input, _fromUnit, _toUnit);
    }
    notifyListeners();
  }

  double _convertLength(double val, String from, String to) {
    Map<String, double> toMeters = {
      "Meters": 1.0, "Kilometers": 1000.0, "Miles": 1609.34, "Feet": 0.3048, "Inches": 0.0254
    };
    double inMeters = val * toMeters[from]!;
    return inMeters / toMeters[to]!;
  }

  double _convertWeight(double val, String from, String to) {
    Map<String, double> toKg = {
      "Kilograms": 1.0, "Grams": 0.001, "Pounds": 0.453592, "Ounces": 0.0283495
    };
    double inKg = val * toKg[from]!;
    return inKg / toKg[to]!;
  }

  double _convertTemp(double val, String from, String to) {
    if (from == to) return val;
    double celsius;
    if (from == "Fahrenheit") {
      celsius = (val - 32) * 5 / 9;
    } else if (from == "Kelvin") {
      celsius = val - 273.15;
    } else {
      celsius = val;
    }

    if (to == "Fahrenheit") return (celsius * 9 / 5) + 32;
    if (to == "Kelvin") return celsius + 273.15;
    return celsius;
  }
}
