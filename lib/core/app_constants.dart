class AppConstants {
  static const String appName = "Smart Utility Toolkit";

  // API Config (Using a public free API for demo)
  static const String currencyApiUrl =
      "https://v6.exchangerate-api.com/v6/edea2dc2c5579c2020f58239/latest/";
  static const String defaultCurrency = "USD";

  // Unit Categories
  static const List<String> lengthUnits = [
    "Meters",
    "Kilometers",
    "Miles",
    "Feet",
    "Inches",
  ];
  static const List<String> weightUnits = [
    "Kilograms",
    "Grams",
    "Pounds",
    "Ounces",
  ];
  static const List<String> tempUnits = ["Celsius", "Fahrenheit", "Kelvin"];

  // Shared Prefs Keys
  static const String keyLastCurrencyRates = "last_currency_rates";
  static const String keyLastUpdate = "last_update_time";
}
