import 'package:autoflex/presentation/router/routes.dart';
import 'package:flutter/material.dart';
import '../views/screens/onboarding/onboarding_page.dart';
import '../views/screens/phone_verification/phone_verification.dart';

class AppRouter {
  // gets the current route based on the route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboardingPage:
        return MaterialPageRoute<OnboardingPage>(
          builder: (_) => const OnboardingPage(),
        );
      case AppRoutes.phoneVerificationPage:
        return MaterialPageRoute<PhoneVerificationPage>(
          builder: (_) => const PhoneVerificationPage(),
        );
      default:
        return MaterialPageRoute<OnboardingPage>(
          builder: (_) => const OnboardingPage(),
        );
    }
  }
}
