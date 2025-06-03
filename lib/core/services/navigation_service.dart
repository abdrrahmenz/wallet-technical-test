import '../../app/modules.dart';
import '../../features/auth/auth.dart';

/// A global service for navigation that can be used outside of widget context
class NavigationService {
  /// Navigate to a named route
  static Future<dynamic>? navigateTo(String routeName, {Object? arguments}) {
    return navigationKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  /// Navigate to a named route and remove all previous routes
  static Future<dynamic>? navigateToAndClearStack(String routeName,
      {Object? arguments}) {
    return navigationKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Navigate to the login page and clear the navigation stack
  static Future<dynamic>? forceNavigateToLogin() {
    return navigateToAndClearStack(LoginPage.routeName);
  }
}
