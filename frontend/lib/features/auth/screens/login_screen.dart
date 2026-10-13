import 'package:flutter/material.dart';
import 'package:skill_swap/core/navigation/main_navigation_screen.dart';
import 'package:skill_swap/core/services/auth_service.dart';
import '../../../core/theme/app_theme.dart';
import 'signup_screen.dart';
import 'package:skill_swap/features/auth/widgets/auth_widgets.dart';

/// LoginScreen — Entry point for returning users.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// Coming soon for features
void showComingSoon(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Feature Coming Soon!... 🚀'),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Logo ────────────────────────────────────────────────────────
              const Center(child: AppLogo()),
              const SizedBox(height: 40),

              // ── Heading ─────────────────────────────────────────────────────
              const Text(
                'Welcome back 👋',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Sign in to continue to SkillSwap',
                style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 32),

              // ── Email ────────────────────────────────────────────────────────
              const _FieldLabel(text: 'Email address'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'you@example.com'),
              ),
              const SizedBox(height: 18),

              // ── Password ─────────────────────────────────────────────────────
              const _FieldLabel(text: 'Password'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: '••••••••',
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
              const SizedBox(height: 10),

              // ── Forgot password ──────────────────────────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    showComingSoon(context);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: AppTheme.primary,
                  ),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 26),

              // ── Login button ─────────────────────────────────────────────────
              ElevatedButton(
                onPressed: () async {
                  final user = await AuthService().login(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );
                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login successful 🚀")),
                    );
                    Future.delayed(const Duration(milliseconds: 800), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login failed ❌")),
                    );
                  }
                },
                child: const Text('Log in'),
              ),
              const SizedBox(height: 26),

              // ── OR divider ───────────────────────────────────────────────────
              const DividerWithText(text: 'OR'),
              const SizedBox(height: 20),

              // ── Google button ────────────────────────────────────────────────
              GoogleButton(label: 'Continue with Google', onPressed: () {
                showComingSoon(context);
              }),
              const SizedBox(height: 40),

              // ── Navigate to Signup ───────────────────────────────────────────
              _BottomAuthPrompt(
                question: "Don't have an account?",
                actionText: 'Sign up',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                ),
              ),
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