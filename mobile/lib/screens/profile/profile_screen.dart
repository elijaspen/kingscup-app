import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import '../../theme.dart';
import 'favorites_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "King's Cup Coffee",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 120), // Added bottom padding to ensure FAB/BottomNav don't block content
        child: Column(
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.outlineVariant),
                          image: const DecorationImage(
                            image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCQvriKg6xIMCeiS1B68NoQTIG-kKF_UIPMRQDKd58kTJJSu58TwFj5XEGi8we3xBGCXiMNIVTadQu6Ao2Hv4rRPPkx_qPv32VwN-dgg-v4AB0TsH4i9Fy6ifCW3H6enzvjhcRuM7JBCg9vx2r-HJkyLHbdmBX-5rQK9DlltYZJ7g66FgxNUqRMeekgGM6WcqeMysAWa_42gSCEXsT7dcbToA4co5mbzr1lUMBJ-4yhcbZ2bjrvy3OvVbfkOxSg8bwBqsYVYbQcYywC'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.surface, width: 2),
                          ),
                          child: const Icon(Icons.verified, size: 16, color: AppColors.onPrimary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'Guest User',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                  Text(
                    user?.email ?? 'Not signed in',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.workspace_premium, size: 14, color: AppColors.onPrimary),
                        const SizedBox(width: 4),
                        Text(
                          'Coffee Connoisseur',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.onPrimary,
                                letterSpacing: 1,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Bento Grid
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "SIGNATURE CIRCLE",
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppColors.onPrimaryContainer.withValues(alpha: 0.8),
                                    letterSpacing: 2,
                                  ),
                            ),
                            const Icon(Icons.stars, color: AppColors.onPrimaryContainer, size: 20),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "4,850",
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Colors.white,
                                    fontSize: 32,
                                  ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Points",
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.75,
                            backgroundColor: Colors.white.withValues(alpha: 0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryFixed),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "150 points until next reward",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 160,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Active Order",
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Barako Double Shot Latte",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Brewing at San Jose",
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.secondary,
                                    ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Addresses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Addresses",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primary,
                        fontSize: 20,
                      ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Add New", style: TextStyle(decoration: TextDecoration.underline)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _AddressCard(
              title: "Home",
              isDefault: true,
              addressLine1: "Purok 4, Barangay Funda-Dalipe",
              addressLine2: "San Jose de Buenavista, Antique, 5700",
              icon: Icons.home,
              isActive: true,
            ),
            const SizedBox(height: 8),
            _AddressCard(
              title: "Office",
              isDefault: false,
              addressLine1: "Level 2, Provincial Capitol Bldg.",
              addressLine2: "San Jose, Antique, 5700",
              icon: Icons.work,
              isActive: false,
            ),
            const SizedBox(height: 32),

            // Payment Methods
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment Methods",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primary,
                        fontSize: 20,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Column(
                children: [
                  _PaymentCard(title: "Visa ending in 4242", subtitle: "Expires 12/25", badge: "VISA"),
                  const Divider(height: 1, color: AppColors.outlineVariant),
                  _PaymentCard(title: "GCash Wallet", subtitle: "Linked: 0917 •••• 123", badge: "GCash"),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Navigation Links
            _ActionLink(title: "Settings", icon: Icons.settings),
            const SizedBox(height: 8),
            _ActionLink(title: "Help & Support", icon: Icons.help),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                auth.logout();
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: AppColors.error),
                    const SizedBox(width: 16),
                    Text(
                      "Logout",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.error,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String title;
  final bool isDefault;
  final String addressLine1;
  final String addressLine2;
  final IconData icon;
  final bool isActive;

  const _AddressCard({
    required this.title,
    required this.isDefault,
    required this.addressLine1,
    required this.addressLine2,
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isActive ? AppColors.primary : AppColors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: isActive ? AppColors.primary : AppColors.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "DEFAULT",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.primary,
                                fontSize: 10,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(addressLine1, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
                Text(addressLine2, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          const Icon(Icons.edit, size: 20, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badge;

  const _PaymentCard({required this.title, required this.subtitle, required this.badge});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Center(
                child: Text(
                  badge,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primaryContainer,
                        fontSize: 10,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _ActionLink extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ActionLink({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary)),
            ),
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
