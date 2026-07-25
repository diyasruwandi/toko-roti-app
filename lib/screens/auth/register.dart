import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool agreedToTerms = false;
  bool isLoading = false;

  // Warna dari config Stitch
  static const Color primary = Color(0xFF003229);
  static const Color primaryContainer = Color(0xFF0C4A3E);
  static const Color onSurfaceVariant = Color(0xFF404945);
  static const Color surfaceContainerLow = Color(0xFFFBF2ED);
  static const Color background = Color(0xFFF5F0E8);
  static const Color outlineVariant = Color(0xFFBFC9C4);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void handleRegister() {
    if (!agreedToTerms) {
      Get.snackbar(
        'Perhatian',
        'Kamu harus menyetujui Syarat & Ketentuan terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Perhatian',
        'Konfirmasi kata sandi tidak cocok',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    // Nanti sambungkan ke AuthController:
    // Get.find<AuthController>().register(
    //   name: nameController.text,
    //   email: emailController.text,
    //   phone: phoneController.text,
    //   password: passwordController.text,
    // );
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
              top: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Icon(
                  Icons.bakery_dining,
                  size: 100,
                  color: primary.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Icon(
                  Icons.coffee,
                  size: 100,
                  color: primary.withValues(alpha: 0.05),
                ),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                children: [
                  // Header logo
                  Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuD4Vbv8bDOFTZu72jbf938W6GR9jZPFFFGAT2d4m8d9Uwj7FBy3wNrX7Yq6eGPtiqUwojaPBb3ycEd_8P5iZgSM82Qjqcv0L2LFrYs6-PEFTLkPZWIBh_znQiJiDngrK68qmAgNdgOTZFI3tFADkZ_KbB5bFLTwBq0-KPullvjwRzqdZsAxwpmvAXCSarkWk9kufSAkk-bRb87CFK6Lm2_8tC5Bcetg4kmr7A_L8XMWQvPVTQ3-40ZbWKi-1ymle4M9NE7R0acRSXFu',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.bakery_dining,
                                  size: 60,
                                  color: primary,
                                ),
                          ),
                        ),
                      ),
                      Text(
                        'Buat Akun Baru',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Bergabunglah dengan komunitas pecinta roti premium kami.',
                        style: TextStyle(fontSize: 15, color: onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Form card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: primaryContainer.withValues(alpha: 0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildLabel('Nama Lengkap'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: nameController,
                          hint: 'John Doe',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Email'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: emailController,
                          hint: 'contoh@email.com',
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Nomor Telepon'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: phoneController,
                          hint: '0812 3456 7890',
                          icon: Icons.call_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),

                        // Password & Confirm Password
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Kata Sandi'),
                                  const SizedBox(height: 8),
                                  _buildTextField(
                                    controller: passwordController,
                                    hint: '••••••••',
                                    icon: Icons.lock_outline,
                                    obscureText: obscurePassword,
                                    onToggleObscure: () {
                                      setState(() {
                                        obscurePassword = !obscurePassword;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Konfirmasi Kata Sandi'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: confirmPasswordController,
                              hint: '••••••••',
                              icon: Icons.lock_reset_outlined,
                              obscureText: obscureConfirmPassword,
                              onToggleObscure: () {
                                setState(() {
                                  obscureConfirmPassword =
                                      !obscureConfirmPassword;
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Terms checkbox
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: agreedToTerms,
                              activeColor: primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  agreedToTerms = value ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: onSurfaceVariant,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Saya setuju dengan ',
                                      ),
                                      TextSpan(
                                        text: 'Syarat & Ketentuan',
                                        style: TextStyle(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const TextSpan(
                                        text:
                                            ' serta Kebijakan Privasi Crust & Co.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Register button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryContainer,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
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
                                    'Daftar',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Footer link ke Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun? ',
                        style: TextStyle(color: onSurfaceVariant),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back(); // atau Get.toNamed('/login');
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onToggleObscure,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: onSurfaceVariant.withValues(alpha: 0.6),
            size: 20,
          ),
          suffixIcon: onToggleObscure != null
              ? IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  onPressed: onToggleObscure,
                )
              : null,
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
