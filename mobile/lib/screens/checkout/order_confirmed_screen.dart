import 'package:flutter/material.dart';
import '../../theme.dart';
import '../main_screen.dart';

class OrderConfirmedScreen extends StatelessWidget {
  final String orderId;
  final String total;

  const OrderConfirmedScreen({super.key, required this.orderId, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              // Success Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.check_circle, size: 48, color: Colors.green[800]),
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                "Order Confirmed!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your coffee is being prepared by our royal baristas.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // ETA & Progress
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Column(
                  children: [
                    Text(
                      "Estimated Pick-up Time",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "10-15 minutes",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    // Progress Bar
                    Row(
                      children: [
                        _buildProgressStep(context, "Confirmed", true, true),
                        Expanded(child: Container(height: 2, color: AppColors.primary)),
                        _buildProgressStep(context, "Preparing", true, false),
                        Expanded(child: Container(height: 2, color: AppColors.outlineVariant)),
                        _buildProgressStep(context, "Ready", false, false),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Order Summary
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Order ID", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                        Text(orderId, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount Paid", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                        Text("₱$total", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Promo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: AppColors.onPrimaryContainer, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Join the Royal Circle", style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.onPrimaryContainer, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("Earn points on this order and unlock exclusive rewards.", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onPrimaryContainer)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              // Back to Home
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to MainScreen and pop all previous routes
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const MainScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Back to Home"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStep(BuildContext context, String label, bool isCompleted, bool isActive) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? AppColors.primary : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: isCompleted ? AppColors.primary : AppColors.outlineVariant),
          ),
          child: isCompleted
              ? const Icon(Icons.check, size: 16, color: AppColors.onPrimary)
              : null,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isCompleted || isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ],
    );
  }
}
