import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  bool isLoading = false;

  // Warna dari config Stitch
  static const Color primaryContainer = Color(0xFF0C4A3E);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onSurfaceVariant = Color(0xFF404945);
  static const Color surfaceContainerLow = Color(0xFFFBF2ED);
  static const Color outline = Color(0xFF707975);
  static const Color outlineVariant = Color(0xFFBFC9C4);
  static const Color background = Color(0xFFFFF8F5);
  static const Color onSurface = Color(0xFF1E1B18);
  static const Color primary = Color(0xFF003229);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void handleLogin() {
    // Nanti sambungkan ke AuthController:
    // Get.find<AuthController>().login(emailController.text, passwordController.text);
    setState(() => isLoading = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative icons
            Positioned(
              bottom: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Icon(
                  Icons.bakery_dining,
                  size: 120,
                  color: primary.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Transform.rotate(
                  angle: 0.78,
                  child: Icon(
                    Icons.coffee,
                    size: 120,
                    color: primary.withValues(alpha: 0.1),
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/title
                    Column(
                      children: [
                        Text(
                          'Crust & Co.',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: primary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aroma kehangatan roti segar menantimu.',
                          style: TextStyle(
                            fontSize: 16,
                            color: onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Login card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Email field
                          _buildLabel('Email'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: emailController,
                            hint: 'nama@email.com',
                            icon: Icons.mail_outline,
                          ),
                          const SizedBox(height: 16),

                          // Password field
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildLabel('Kata Sandi'),
                              GestureDetector(
                                onTap: () {
                                  // navigasi ke forgot password kalau ada
                                },
                                child: Text(
                                  'Lupa?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: primaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: passwordController,
                            hint: '••••••••',
                            icon: Icons.lock_outline,
                            obscureText: obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: outline,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryContainer,
                                foregroundColor: onTertiary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 2,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Divider "Atau"
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: outlineVariant.withValues(alpha: 0.3),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  'Atau',
                                  style: TextStyle(color: outline),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: outlineVariant.withValues(alpha: 0.3),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Google login button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // integrasi Google login kalau nanti diperlukan
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: outlineVariant),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.g_mobiledata, size: 24),
                              label: Text(
                                'Lanjutkan dengan Google',
                                style: TextStyle(
                                  color: onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Footer link ke Register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: TextStyle(color: onSurfaceVariant),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Nanti: Get.toNamed('/register');
                          },
                          child: Text(
                            'Daftar',
                            style: TextStyle(
                              color: primaryContainer,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: onSurfaceVariant,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: outline, size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 12,
          ),
        ),
      ),
    );
  }
}
