import 'package:flutter/material.dart';
import 'currency_repository.dart';

class CurrencyViewModel extends ChangeNotifier {
  final CurrencyRepository _repo;

  CurrencyViewModel(this._repo) {
    loadRates();
  }

  String _fromCurrency = "USD";
  String _toCurrency = "EUR";
  Map<String, double> _rates = {"USD": 1.0, "EUR": 0.92};
  double _result = 0.92;
  bool _isLoading = true;

  String get fromCurrency => _fromCurrency;
  String get toCurrency => _toCurrency;
  Map<String, double> get rates => _rates;
  double get result => _result;
  bool get isLoading => _isLoading;

  void setFromCurrency(String currency, String currentAmount) {
    _fromCurrency = currency;
    loadRates(amount: currentAmount);
  }

  void setToCurrency(String currency, String currentAmount) {
    _toCurrency = currency;
    calculate(currentAmount);
  }

  Future<void> loadRates({String? amount}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final rates = await _repo.fetchRates(_fromCurrency);
      _rates = rates;
      _isLoading = false;
      if (amount != null) {
        calculate(amount);
      } else {
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  void calculate(String amountText) {
    if (amountText.isEmpty) {
      _result = 0.0;
      notifyListeners();
      return;
    }
    
    double? amount = double.tryParse(amountText);
    if (amount != null && _rates.containsKey(_toCurrency)) {
      _result = amount * _rates[_toCurrency]!;
      notifyListeners();
    } else {
      _result = 0.0;
      notifyListeners();
    }
  }
}

