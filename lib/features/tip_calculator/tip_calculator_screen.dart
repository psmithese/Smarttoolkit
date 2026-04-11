import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/custom_text_field.dart';
import 'tip_view_model.dart';

class TipCalculatorScreen extends StatefulWidget {
  const TipCalculatorScreen({super.key});

  @override
  State<TipCalculatorScreen> createState() => _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends State<TipCalculatorScreen> {
  final TextEditingController _billController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController(text: "1");

  @override
  void dispose() {
    _billController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tip Calculator")),
      body: Consumer<TipViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                GlassCard(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _billController,
                        label: "Bill Amount",
                        prefixIcon: Icons.receipt_long_rounded,
                        onChanged: (v) => viewModel.calculate(_billController.text, _peopleController.text),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Text("Tip Percentage", style: TextStyle(color: Colors.white70)),
                          const Spacer(),
                          Text("${viewModel.tipPercentage.toInt()}%", 
                            style: const TextStyle(color: AppTheme.primaryAccent, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Slider(
                        value: viewModel.tipPercentage,
                        min: 0,
                        max: 40,
                        divisions: 8,
                        onChanged: (val) {
                          viewModel.setTipPercentage(val, _billController.text, _peopleController.text);
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _peopleController,
                        label: "Number of People",
                        prefixIcon: Icons.people_outline_rounded,
                        onChanged: (v) => viewModel.calculate(_billController.text, _peopleController.text),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Row(
                  children: [
                    _buildResultBox("Tip Amount", "\$${viewModel.tipAmount.toStringAsFixed(2)}"),
                    const SizedBox(width: 16),
                    _buildResultBox("Total / Person", "\$${viewModel.totalPerPerson.toStringAsFixed(2)}", isPrimary: true),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultBox(String title, String value, {bool isPrimary = false}) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: isPrimary ? AppTheme.primaryAccent : Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
