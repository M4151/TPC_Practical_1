import 'package:flutter/material.dart';
import '/view/login.dart';
import '/view/application_form.dart';
import '/view/application_detail.dart';
import '/view/home_screen.dart';
import '/view/admin_dashboard.dart';
import '/model/models.dart'; // <-- Import ApplicationModel

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String applicationForm = '/applicationForm';
  static const String applicationDetail = '/applicationDetail';
  static const String adminDashboard = '/adminDashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case applicationForm:
        return MaterialPageRoute(builder: (_) => const ApplicationFormScreen());

      case applicationDetail:
        // Cast arguments to ApplicationModel
        final args = settings.arguments as ApplicationModel;
        return MaterialPageRoute(
          builder: (_) => ApplicationDetailScreen(application: args),
        );

      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
