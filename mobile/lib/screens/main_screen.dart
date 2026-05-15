import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme.dart';
import 'home/home_screen.dart';
import 'menu/menu_screen.dart';
import 'orders/order_history_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1; // Default to Menu as per HTML request context

  final List<Widget> _screens = [
    const HomeScreen(),
    const MenuScreen(),
    const OrderHistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.95),
              border: Border(
                top: BorderSide(
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: SizedBox(
                  height: 60, // Explicit height for the items row
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NavBarItem(
                        icon: Icons.home_outlined,
                        activeIcon: Icons.home,
                        label: 'Home',
                        isActive: _currentIndex == 0,
                        onTap: () => setState(() => _currentIndex = 0),
                      ),
                      _NavBarItem(
                        icon: Icons.restaurant_menu,
                        activeIcon: Icons.restaurant_menu,
                        label: 'Menu',
                        isActive: _currentIndex == 1,
                        onTap: () => setState(() => _currentIndex = 1),
                      ),
                      _NavBarItem(
                        icon: Icons.receipt_long_outlined,
                        activeIcon: Icons.receipt_long,
                        label: 'Orders',
                        isActive: _currentIndex == 2,
                        onTap: () => setState(() => _currentIndex = 2),
                      ),
                      _NavBarItem(
                        icon: Icons.person_outline,
                        activeIcon: Icons.person,
                        label: 'Profile',
                        isActive: _currentIndex == 3,
                        onTap: () => setState(() => _currentIndex = 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(0, isActive ? -4 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              size: 26,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

