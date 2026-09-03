import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/auth_provider.dart';
import '../widgets/button.dart';
import '../widgets/input.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOut,
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    FocusScope.of(context).unfocus();
    ref.read(authProvider.notifier).login(
          _emailController.text,
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Listen to authentication outcome for toast feedback
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF18181B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Color(0xFF22C55E), width: 1.0),
            ),
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E), size: 18.0),
                const SizedBox(width: 10.0),
                Text(
                  'Signed in successfully.',
                  style: GoogleFonts.inter(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Stack(
        children: [
          // 1. Satin Metallic Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Subtle Dark Overlay for contrast & readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.45),
            ),
          ),

          // 3. Login Content with Frosted Glass Surface
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28.0,
                              vertical: 32.0,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xE60D0D10), // 90% semi-opaque dark surface
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(
                                color: const Color(0x2EFFFFFF), // Subtle crisp glass hairline border
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Title
                                Text(
                                  'Welcome Back',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 26.0,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.6,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6.0),

                                // Subtitle
                                Text(
                                  'Enter your credentials to sign in',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFA1A1AA),
                                  ),
                                ),
                                const SizedBox(height: 24.0),

                                // Error Banner (Positioned directly at the top of Email Address)
                                if (authState.errorMessage != null) ...[
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 10.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1C0D11),
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: const Color(0x66F43F5E),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.error_outline_rounded,
                                          size: 16.0,
                                          color: Color(0xFFFB7185),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Expanded(
                                          child: Text(
                                            authState.errorMessage!,
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFFFECDD3),
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 18.0),
                                ],

                                // Email Field
                                CustomInputField(
                                  controller: _emailController,
                                  label: 'Email Address',
                                  hint: 'don.juan@gmail.com',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icons.mail_outline_rounded,
                                ),
                                const SizedBox(height: 18.0),

                                // Password Field
                                CustomInputField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  hint: '••••••••••••',
                                  obscureText: true,
                                  prefixIcon: Icons.lock_outline_rounded,
                                ),
                                const SizedBox(height: 10.0),

                                // Forgot Password link (right-aligned)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 0),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'Forgot Password?',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFFA1A1AA),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),

                                // Primary Sign In Button
                                CustomButton(
                                  text: 'Sign In',
                                  isLoading: authState.isLoading,
                                  onPressed: _onLoginPressed,
                                ),
                                const SizedBox(height: 28.0),

                                // Hairline Divider
                                const Divider(
                                  color: Color(0x1FFFFFFF),
                                  height: 1.0,
                                  thickness: 1.0,
                                ),
                                const SizedBox(height: 24.0),

                                // Sign Up Footer
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account? ",
                                      style: GoogleFonts.inter(
                                        fontSize: 13.0,
                                        color: const Color(0xFF71717A),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        'Sign Up',
                                        style: GoogleFonts.inter(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
