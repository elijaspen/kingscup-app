import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'providers/providers.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/landing_screen.dart';
import 'screens/menu/menu_screen.dart';
import 'screens/checkout/cart_screen.dart';
import 'screens/barista/barista_dashboard_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const KcsApp(),
    ),
  );
}

class KcsApp extends StatelessWidget {
  const KcsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KCS Coffee',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/menu': (context) => const MenuScreen(),
        '/cart': (context) => const CartScreen(),
        '/barista': (context) => const BaristaDashboardScreen(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().checkAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    
    if (auth.isAuthenticated) {
      if (auth.user?.isBarista ?? false) {
        return const BaristaDashboardScreen();
      }
      return const MainScreen();
    }
    
    return const LandingScreen();
  }
}
