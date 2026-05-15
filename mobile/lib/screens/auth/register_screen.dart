import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import '../../theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await context.read<AuthProvider>().register(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            passwordConfirmation: _confirmPasswordController.text,
            role: 'customer',
          );
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=2670&auto=format&fit=crop'),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Image.asset('assets/images/logo.webp', height: 120),
                ),
                const SizedBox(height: 24),
                Text(
                  "Join the Circle",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 40),
                _buildField("FULL NAME", _nameController, Icons.person_outline),
                const SizedBox(height: 16),
                _buildField("EMAIL ADDRESS", _emailController, Icons.email_outlined),
                const SizedBox(height: 16),
                _buildField("PASSWORD", _passwordController, Icons.lock_outline, obscure: true),
                const SizedBox(height: 16),
                _buildField("CONFIRM", _confirmPasswordController, Icons.lock_reset, obscure: true),
                const SizedBox(height: 48),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _handleRegister,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text("Create Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: AppColors.secondary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: AppColors.primary.withValues(alpha: 0.5)),
            fillColor: Colors.white.withValues(alpha: 0.8),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      ],
    );
  }
}
