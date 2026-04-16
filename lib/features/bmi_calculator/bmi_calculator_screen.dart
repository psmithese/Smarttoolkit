import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/custom_text_field.dart';
import 'bmi_view_model.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BMI Calculator")),
      body: Consumer<BMIViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                GlassCard(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _heightController,
                        label: "Height (cm)",
                        prefixIcon: Icons.height,
                        onChanged: (v) => viewModel.calculateBMI(_heightController.text, _weightController.text),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _weightController,
                        label: "Weight (kg)",
                        prefixIcon: Icons.monitor_weight_outlined,
                        onChanged: (v) => viewModel.calculateBMI(_heightController.text, _weightController.text),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                if (viewModel.bmi != null) ...[
                  Text(
                    "Your BMI",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.bmi!.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppTheme.primaryAccent,
                          fontSize: 64,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: viewModel.statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: viewModel.statusColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      viewModel.message,
                      style: TextStyle(
                        color: viewModel.statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Visual Scale
                  _buildBMIScale(),
                ] else 
                  const Opacity(
                    opacity: 0.5,
                    child: Column(
                      children: [
                        Icon(Icons.calculate_outlined, size: 80, color: Colors.white24),
                        SizedBox(height: 16),
                        Text("Result will appear here", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBMIScale() {
    return Column(
      children: [
        Row(
          children: [
            _scaleSegment("Under", Colors.lightBlueAccent, 18.5),
            _scaleSegment("Normal", Colors.greenAccent, 25),
            _scaleSegment("Over", Colors.orangeAccent, 30),
            _scaleSegment("Obese", Colors.redAccent, 40),
          ],
        ),
      ],
    );
  }

  Widget _scaleSegment(String label, Color color, double val) {
    return Expanded(
      child: Column(
        children: [
          Container(height: 8, color: color),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
          Text("<$val", style: const TextStyle(fontSize: 10, color: Colors.white54)),
        ],
      ),
    );
  }
}
