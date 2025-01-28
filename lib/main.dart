import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/service_input_screen.dart';
import 'screens/realtime_tracking_screen.dart';
import 'providers/service_provider.dart';
import 'utils/constants.dart';

void main() {
  runApp(const BusTrackingApp());
}

class BusTrackingApp extends StatelessWidget {
  const BusTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
      ],
      child: MaterialApp(
        title: 'Bus Tracking',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            background: AppColors.background,
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => const ServiceInputScreen(),
              );
            case '/tracking':
              final serviceNumber = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => RealtimeTrackingScreen(
                  serviceNumber: serviceNumber,
                ),
              );
            default:
              return MaterialPageRoute(
                builder: (_) => const ServiceInputScreen(),
              );
          }
        },
      ),
    );
  }
} 