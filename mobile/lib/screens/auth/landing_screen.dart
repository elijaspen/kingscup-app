import 'package:flutter/material.dart';
import '../../theme.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main Scrollable Content
          SingleChildScrollView(
            child: Column(
              children: [
                // Section 1: Hero
                _buildHeroSection(context),
                
                // Section 2: Quality
                _buildInfoSection(
                  context,
                  title: "Premium Excellence",
                  subtitle: "Every bean is hand-selected and roasted to perfection by our master baristas in San Jose.",
                  imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=2670&auto=format&fit=crop',
                  isReversed: false,
                ),

                // Section 3: The Experience
                _buildInfoSection(
                  context,
                  title: "Signature Atmosphere",
                  subtitle: "Step into a space where coffee meets luxury. Experience the finest roasts in a setting fit for connoisseurs.",
                  imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=2694&auto=format&fit=crop',
                  isReversed: true,
                ),

                // Section 4: Join the Circle
                _buildRewardSection(context),

                const SizedBox(height: 120), // Padding for the fixed bottom CTA
              ],
            ),
          ),

          // Top Branding (Logo) - Floating
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logo.webp',
                    height: 56,
                    width: 56,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Fixed Bottom CTA
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.background,
                    AppColors.background.withValues(alpha: 0.9),
                    AppColors.background.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                    ),
                    child: const Text(
                      "Order Now",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No account yet?",
                        style: TextStyle(color: AppColors.onSurfaceVariant),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/register'),
                        child: const Text(
                          "Register Here",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
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
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1447933601403-0c6688de566e?q=80&w=2561&auto=format&fit=crop'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.4),
              Colors.black.withValues(alpha: 0.9),
            ],
          ),
        ),
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "THE\nMORNING\nRITUAL",
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 72,
                    height: 0.9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -2,
                  ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 60,
              height: 4,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 24),
            Text(
              "Experience the signature standard of coffee roasts, delivered straight to your door.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 20,
                  ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, {
    required String title,
    required String subtitle,
    required String imageUrl,
    required bool isReversed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Column(
        crossAxisAlignment: isReversed ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.network(
              imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.secondary,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: isReversed ? TextAlign.right : TextAlign.left,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          const Icon(Icons.stars, color: Colors.white, size: 48),
          const SizedBox(height: 24),
          Text(
            "The Signature Circle",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            "Earn points with every sip. Unlock exclusive rewards, member-only blends, and faster delivery.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
