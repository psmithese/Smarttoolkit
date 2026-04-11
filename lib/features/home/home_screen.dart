import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../shared/widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient decoration
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryAccent.withOpacity(0.2),
              ),
            ),
          ).animate().fadeIn(duration: 1.seconds).scale(),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    "Utility Toolkit",
                    style: Theme.of(context).textTheme.displayLarge,
                  ).animate().fadeIn(duration: 600.ms).slideX(),
                  const SizedBox(height: 8),
                  Text(
                    "All your essential tools in one place",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ).animate().fadeIn(delay: 200.ms).slideX(),
                  const SizedBox(height: 40),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        _buildToolCard(
                          context,
                          title: "Unit Converter",
                          icon: Icons.sync_alt_rounded,
                          color: Colors.blue,
                          route: '/unit',
                        ),
                        _buildToolCard(
                          context,
                          title: "BMI Calc",
                          icon: Icons.monitor_weight_outlined,
                          color: Colors.green,
                          route: '/bmi',
                        ),
                        _buildToolCard(
                          context,
                          title: "Currency",
                          icon: Icons.currency_exchange_rounded,
                          color: Colors.amber,
                          route: '/currency',
                        ),
                        _buildToolCard(
                          context,
                          title: "Tip Calc",
                          icon: Icons.account_balance_wallet_outlined,
                          color: Colors.purple,
                          route: '/tip',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: GlassCard(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 400.ms).scale(curve: Curves.easeOutBack),
    );
  }
}
