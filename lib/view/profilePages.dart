import 'package:ai_habit_tracker/controller/AuthController.dart';
import 'package:ai_habit_tracker/view/editProfile.dart';
import 'package:ai_habit_tracker/view/performance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final authController = Get.put(AuthController());
    final String name = box.read('name') ?? 'User';
    final String email = box.read('email') ?? '-';
    final String initial = name[0].toUpperCase();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EE),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2C2A),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_back_ios_new_rounded,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 38),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: -50,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFFFAC775),
                        child: Text(
                          initial,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE87D2B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit_rounded,
                              size: 15, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 62),
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9E9E9E),
              ),
            ),

            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [

                  _menuCard(children: [
                    _menuItem(
                      icon: Icons.person_outline_rounded,
                      iconColor: const Color(0xFFE87D2B),
                      label: 'Edit Profile',
                      onTap: () {Get.to(()=>Editprofile());},
                    ),
                    _divider(),
                    _menuItem(
                      icon: Icons.bar_chart_rounded,
                      iconColor: const Color(0xFFE87D2B),
                      label: 'Performance',
                      onTap: () {Get.to(()=> PerformancePages());},
                    ),
                    _divider(),
                    _menuItem(
                      icon: Icons.settings_outlined,
                      iconColor: const Color(0xFFE87D2B),
                      label: 'Settings',
                      onTap: () {},
                    ),
                  ]),

                  const SizedBox(height: 16),

                  _menuCard(children: [
                    _menuItem(
                      icon: Icons.logout_rounded,
                      iconColor: Colors.red,
                      label: 'Log Out',
                      labelColor: Colors.red,
                      onTap: () {
                        Get.dialog(
                          AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text('Log Out',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            content: const Text('Apakah kamu yakin ingin keluar?'),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Batal',
                                    style: TextStyle(color: Colors.grey)),
                              ),
                              TextButton(
                                onPressed: () {
                                   authController.logout();
                                },
                                child: const Text('Keluar',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 32),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _menuCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    Color? labelColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: labelColor ?? const Color(0xFF1A1A1A),
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14,
                color: labelColor ?? const Color(0xFF9E9E9E)),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 68,
      color: Color(0xFFF0EEEA),
    );
  }
}