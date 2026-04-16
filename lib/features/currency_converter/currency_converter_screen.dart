import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/custom_text_field.dart';
import 'currency_view_model.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController(text: "1");

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Currency Converter")),
      body: Consumer<CurrencyViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                GlassCard(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _amountController,
                        label: "Amount to Convert",
                        prefixIcon: Icons.attach_money_rounded,
                        onChanged: (v) => viewModel.calculate(_amountController.text),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCurrencyDropdown(
                              viewModel.rates,
                              viewModel.fromCurrency,
                              (v) {
                                if (v != null) {
                                  viewModel.setFromCurrency(v, _amountController.text);
                                }
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.swap_horiz_rounded, color: Colors.white24),
                          ),
                          Expanded(
                            child: _buildCurrencyDropdown(
                              viewModel.rates,
                              viewModel.toCurrency,
                              (v) {
                                if (v != null) {
                                  viewModel.setToCurrency(v, _amountController.text);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Text("Result", style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text(
                  viewModel.result.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppTheme.primaryAccent,
                        fontSize: 56,
                      ),
                ),
                Text(
                  viewModel.toCurrency,
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Real-time data powered by Currency API",
                  style: TextStyle(color: Colors.white24, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrencyDropdown(
      Map<String, double> rates, String value, Function(String?) onChanged) {
    if (!rates.containsKey(value)) {
      // In case the fetched rates don't contain the currently selected currency during loading/switching
      if (rates.isNotEmpty) {
        value = rates.keys.first;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: rates.containsKey(value) ? value : null,
          dropdownColor: AppTheme.surfaceColor,
          isExpanded: true,
          items: rates.keys.map((code) {
            return DropdownMenuItem(
              value: code,
              child: Text(code, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
