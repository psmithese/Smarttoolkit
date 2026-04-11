import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/custom_text_field.dart';
import 'unit_view_model.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController _inputController = TextEditingController(
    text: "1",
  );

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Unit Converter")),
      body: Consumer<UnitViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Category Selector
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: viewModel.categories.keys.map((cat) {
                      bool isSelected = viewModel.currentCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (val) {
                            viewModel.setCategory(cat, _inputController.text);
                          },
                          selectedColor: AppTheme.primaryAccent.withOpacity(
                            0.3,
                          ),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.white54,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 32),
                GlassCard(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _inputController,
                        label: "Value to Convert",
                        onChanged: (v) =>
                            viewModel.calculate(_inputController.text),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildUnitDropdown(
                              viewModel.categories[viewModel.currentCategory]!,
                              viewModel.fromUnit,
                              (v) {
                                if (v != null) {
                                  viewModel.setFromUnit(
                                    v,
                                    _inputController.text,
                                  );
                                }
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white24,
                            ),
                          ),
                          Expanded(
                            child: _buildUnitDropdown(
                              viewModel.categories[viewModel.currentCategory]!,
                              viewModel.toUnit,
                              (v) {
                                if (v != null) {
                                  viewModel.setToUnit(v, _inputController.text);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text("Result", style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text(
                  viewModel.result.toStringAsFixed(4),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppTheme.primaryAccent,
                    fontSize: 48,
                  ),
                ),
                Text(
                  viewModel.toUnit,
                  style: const TextStyle(color: Colors.white54, fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnitDropdown(
    List<String> items,
    String value,
    Function(String?) onChanged,
  ) {
    if (!items.contains(value)) {
      if (items.isNotEmpty) {
        value = items.first;
      }
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : null,
          dropdownColor: AppTheme.surfaceColor,
          isExpanded: true,
          items: items.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(
                unit,
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
