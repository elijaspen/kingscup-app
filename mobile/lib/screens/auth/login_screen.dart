import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import '../../theme.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Aesthetic
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=2787&auto=format&fit=crop',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    AppColors.background.withValues(alpha: 0.8),
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        // Back Button
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                        ),
                        const SizedBox(height: 32),
                        
                        // Header Group
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
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
                                child: Image.asset('assets/images/logo.webp', height: 80, width: 80),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                "Welcome Back",
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -1,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "The coffee is almost ready.",
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 64),

                        // Form Fields
                        _buildTextField(
                          controller: _emailController,
                          label: "EMAIL ADDRESS",
                          hint: "alex@coffee.ph",
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 24),
                        _buildTextField(
                          controller: _passwordController,
                          label: "PASSWORD",
                          hint: "••••••••",
                          icon: Icons.lock_outline,
                          obscureText: !_isPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: AppColors.primary.withValues(alpha: 0.5),
                              size: 20,
                            ),
                            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                          ),
                        ),
                        
                        const Spacer(),
                        const SizedBox(height: 48),

                        // Action Button
                        ElevatedButton(
                          onPressed: auth.isLoading
                              ? null
                              : () async {
                                  try {
                                    await auth.login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                    if (mounted) {
                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                    }
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Login failed: $e')),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 64),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 8,
                          ),
                          child: auth.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "Sign In",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
                                children: const [
                                  TextSpan(text: "No account yet? "),
                                  TextSpan(
                                    text: "Register Here",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.4)),
              prefixIcon: Icon(icon, color: AppColors.primary.withValues(alpha: 0.5)),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
