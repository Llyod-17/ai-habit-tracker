import 'package:ai_habit_tracker/controller/AuthController.dart';
import 'package:ai_habit_tracker/view/RegisterPage.dart';
import 'package:ai_habit_tracker/widget/InputWidget.dart';
import 'package:ai_habit_tracker/widget/socialButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE8),
      body: SafeArea(
        child: Stack(
          children: [
            // Lingkaran dekorasi kanan atas
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 130,
                height: 130,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5D9C3),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🐯', style: TextStyle(fontSize: 48)),
                ),
              ),
            ),

            Positioned(
              bottom: 100,
              left: -45,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFB8D8B8).withOpacity(0.45),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Konten utama
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 64),

                  const Text(
                    'Selamat datang,\nkembali! 👋',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Masuk untuk melanjutkan rutinmu',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF999999),
                    ),
                  ),

                  const SizedBox(height: 36),

                  const Text(
                    'EMAIL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InputWidget(
                    hintText: 'contoh@email.com',
                    controller: _emailController,
                    obscureText: false,
                  ),

                  const SizedBox(height: 20),

                  // Label PASSWORD
                  const Text(
                    'PASSWORD',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InputWidget(
                    hintText: 'Password',
                    controller: _passwordController,
                    obscureText: true,
                  ),

                  // Lupa password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Lupa password?',
                        style: TextStyle(
                          color: Color(0xFFE8611A),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tombol Masuk
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async{ await authController.login(email: _emailController.text.trim(), password: _passwordController.text.trim());},
                      child: Obx(() => (
                        authController.isLoading.value
                        ? LoadingAnimationWidget.bouncingBall(color: Colors.brown, size: 50)
                        : const Text("Masuk", style: TextStyle(color: Colors.white,),)
                      ))
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Divider
                  Row(
                    children: [
                      const Expanded(
                          child: Divider(color: Color(0xFFDDDDDD), thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'atau masuk dengan',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Expanded(
                          child: Divider(color: Color(0xFFDDDDDD), thickness: 1)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Tombol sosial
                  Row(
                    children: [
                      Expanded(
                        child: SocialButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDB4437),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    'G',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Google',
                                style: TextStyle(
                                  color: Color(0xFF1A1A1A),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: SocialButton(
                          onPressed: () {},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.apple, size: 22, color: Color(0xFF1A1A1A)),
                              SizedBox(width: 8),
                              Text(
                                'Apple',
                                style: TextStyle(
                                  color: Color(0xFF1A1A1A),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Daftar sekarang
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Belum punya akun? ',
                          style: TextStyle(color: Color(0xFF888888), fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(() => const RegisterPages()),
                          child: const Text(
                            'Daftar sekarang',
                            style: TextStyle(
                              color: Color(0xFFE8611A),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}