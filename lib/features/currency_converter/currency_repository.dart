import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyRepository {
  // Using a test API key for demonstration. 
  // In a real app, this should be in an environment variable.
  final String _apiKey = "f60f64483984d436a107386c"; // Sample key for ExchangeRate-API
  
  Future<Map<String, double>> fetchRates(String baseCurrency) async {
    final url = "https://v6.exchangerate-api.com/v6/$_apiKey/latest/$baseCurrency";
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['result'] == 'success') {
          Map<String, dynamic> rates = data['conversion_rates'];
          return rates.map((key, value) => MapEntry(key, value.toDouble()));
        }
      }
      throw Exception("Failed to load currency rates");
    } catch (e) {
      // Return basic mock rates if API fails or No Internet
      return {
        "USD": 1.0,
        "EUR": 0.92,
        "GBP": 0.79,
        "NGN": 1500.0,
        "JPY": 151.0,
      };
    }
  }
}
