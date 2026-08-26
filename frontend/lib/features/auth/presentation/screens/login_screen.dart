import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../widgets/button.dart';
import '../widgets/input.dart';

/// The main login screen UI composing the form, reusable widgets, and Riverpod state.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Controllers to capture user input
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers to free memory
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    // Unfocus any active keyboard
    FocusScope.of(context).unfocus();

    // Call the login logic from AuthNotifier using ref.read
    ref
        .read(authProvider.notifier)
        .login(_emailController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    // Watch the authentication state to rebuild the UI when it changes
    final authState = ref.watch(authProvider);

    // Listen to state changes for one-off side effects like showing a SnackBar
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 64,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Please sign in to continue',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
              const SizedBox(height: 32.0),

              // Reusable Email Input Field
              CustomInputField(
                controller: _emailController,
                label: 'Email',
                hint: 'test@example.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 16.0),

              // Reusable Password Input Field
              CustomInputField(
                controller: _passwordController,
                label: 'Password',
                hint: 'password123',
                obscureText: true,
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: 16.0),

              // Inline Error Message if any
              if (authState.errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    authState.errorMessage!,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 13.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16.0),
              ],

              // Reusable Login Button
              CustomButton(
                text: 'Login',
                isLoading: authState.isLoading,
                onPressed: _onLoginPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
