import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyRepository {
  Future<Map<String, double>> fetchRates(String baseCurrency) async {
    final code = baseCurrency.toLowerCase();
    final url =
        "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/$code.json";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data[code] != null) {
          Map<String, dynamic> rates = data[code];
          // Map keys to uppercase and ensure values are doubles
          return rates.map(
            (key, value) => MapEntry(key.toUpperCase(), value.toDouble()),
          );
        }
      }
      throw Exception("Failed to load currency rates");
    } catch (e) {
      // Improved fallback: provide a basic set of rates if network fails.
      // Note: In production, we might want to cache the last successful rates.
      return {
        "USD": 1.0,
        "EUR": 0.92,
        "GBP": 0.79,
        "NGN": 1550.0,
        "JPY": 151.0,
        "CAD": 1.36,
      };
    }
  }
}
