import 'package:flutter/material.dart';
import 'package:skill_swap/core/services/auth_service.dart';
import 'package:skill_swap/features/auth/screens/login_screen.dart';
import 'package:skill_swap/features/home/home_screen.dart';
import '../../../core/theme/app_theme.dart';
import 'package:skill_swap/features/auth/widgets/auth_widgets.dart';



/// SignupScreen — Registration flow for new users.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Logo ────────────────────────────────────────────────────────
              const Center(child: AppLogo()),
              const SizedBox(height: 32),

              // ── Heading ─────────────────────────────────────────────────────
              const Text(
                'Create an account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Join SkillSwap and start exchanging skills',
                style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 32),

              // ── Full Name ────────────────────────────────────────────────────
              const _FieldLabel(text: 'Full name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'Ankit Sharma'),
              ),
              const SizedBox(height: 18),

              // ── Email ────────────────────────────────────────────────────────
              const _FieldLabel(text: 'Email address'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration:
                const InputDecoration(hintText: 'you@example.com'),
              ),
              const SizedBox(height: 18),

              // ── Password ─────────────────────────────────────────────────────
              const _FieldLabel(text: 'Password'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Min. 8 characters',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // ── Confirm Password ─────────────────────────────────────────────
              const _FieldLabel(text: 'Confirm password'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Re-enter your password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => setState(() =>
                    _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ── Signup button ────────────────────────────────────────────────
              ElevatedButton(
                onPressed: () async {
                  // 1. Show a loading indicator (optional but recommended)
                  final user = await AuthService().signUp(
                    _nameController.text.trim(),
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );

                  if (user != null) {
                    // SUCCESS: Notify the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Account created successfully! 🎉")),
                    );

                    // Direct login: Clear the backstack and jump straight to the HomeScreen widget
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (route) => false, // This removes all previous screens (Login/Signup) from memory
                    );
                  } else {
                    // FAILURE: Give the user feedback!
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Signup failed. Please check your details.")),
                    );
                  }
                },
                child: const Text('Create account'),
              ),
              const SizedBox(height: 26),

              // ── OR divider ───────────────────────────────────────────────────
              const DividerWithText(text: 'OR'),
              const SizedBox(height: 20),

              // ── Google button ────────────────────────────────────────────────
              GoogleButton(label: 'Sign up with Google', onPressed: () {
                showComingSoon(context);
              }),
              const SizedBox(height: 36),

              // ── Navigate to Login ────────────────────────────────────────────
              _BottomAuthPrompt(
                question: 'Already have an account?',
                actionText: 'Log in',
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Private helpers ───────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppTheme.textPrimary,
      ),
    );
  }
}

class _BottomAuthPrompt extends StatelessWidget {
  final String question;
  final String actionText;
  final VoidCallback onTap;
  const _BottomAuthPrompt(
      {required this.question, required this.actionText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(question,
            style: const TextStyle(
                fontSize: 14, color: AppTheme.textSecondary)),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}