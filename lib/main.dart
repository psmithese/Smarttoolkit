import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'features/home/home_screen.dart';
import 'features/unit_converter/unit_converter_screen.dart';
import 'features/unit_converter/unit_view_model.dart';
import 'features/bmi_calculator/bmi_calculator_screen.dart';
import 'features/bmi_calculator/bmi_view_model.dart';
import 'features/currency_converter/currency_converter_screen.dart';
import 'features/currency_converter/currency_repository.dart';
import 'features/currency_converter/currency_view_model.dart';
import 'features/tip_calculator/tip_calculator_screen.dart';
import 'features/tip_calculator/tip_view_model.dart';
import 'features/task_manager/task_screen.dart';
import 'features/task_manager/task_view_model.dart';
import 'features/task_manager/task_repository.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BMIViewModel()),
        ChangeNotifierProvider(create: (_) => UnitViewModel()),
        ChangeNotifierProvider(create: (_) => TipViewModel()),
        Provider(create: (_) => TaskRepository()),
        ChangeNotifierProxyProvider<TaskRepository, TaskViewModel>(
          create: (context) => TaskViewModel(Provider.of<TaskRepository>(context, listen: false)),
          update: (context, repo, previous) => previous ?? TaskViewModel(repo),
        ),
        Provider(create: (_) => CurrencyRepository()),
        ChangeNotifierProxyProvider<CurrencyRepository, CurrencyViewModel>(
          create: (context) => CurrencyViewModel(Provider.of<CurrencyRepository>(context, listen: false)),
          update: (context, repo, previous) => previous ?? CurrencyViewModel(repo),
        ),
      ],
      child: const SmartToolkitApp(),
    ),
  );
}

class SmartToolkitApp extends StatelessWidget {
  const SmartToolkitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Utility Toolkit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/': (context) => const HomeScreen(),
        '/unit': (context) => const UnitConverterScreen(),
        '/bmi': (context) => const BMICalculatorScreen(),
        '/currency': (context) => const CurrencyConverterScreen(),
        '/tip': (context) => const TipCalculatorScreen(),
        '/tasks': (context) => const TaskScreen(),
      },
    );
  }
}
