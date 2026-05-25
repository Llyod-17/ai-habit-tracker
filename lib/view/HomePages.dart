import 'package:ai_habit_tracker/controller/HabitController.dart';
import 'package:ai_habit_tracker/view/addHabit.dart';
import 'package:ai_habit_tracker/view/profilePages.dart';
import 'package:ai_habit_tracker/controller/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final box = GetStorage();
  final HabitController habitController = Get.put(HabitController());
  final DateTime today = DateTime.now();
  int selectedDay = DateTime.now().day;

  Color _categoryColor(String? category) {
    switch (category) {
      case 'high':
        return const Color(0xFFFBEAF0);
      case 'mid':
        return const Color(0xFFFAEEDA);
      case 'low':
        return const Color(0xFFE1F5EE);
      default:
        return const Color(0xFFE6F1FB);
    }
  }

  List<DateTime> _getWeekDays() {
    final monday = today.subtract(Duration(days: today.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = _getWeekDays();
    final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EE),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => habitController.fetchHabits(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Morning, Budi 👋',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2C2C2A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              DateFormat('EEEE, dd MMMM, yyyy').format(today),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF888780),
                              ),
                            ),
                          ],
                        ),

                        GestureDetector(
                          onTap: () => Get.to(() => const ProfilePage()),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: const Color(0xFFFAC775),
                            child: Text(
                              box.read('name') != null
                                  ? (box.read('name') as String)[0]
                                        .toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (i) {
                        final day = weekDays[i];
                        final isSelected = day.day == selectedDay;
                        return GestureDetector(
                          onTap: () => setState(() => selectedDay = day.day),
                          child: Column(
                            children: [
                              Text(
                                dayLabels[i],
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF888780),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF2C2C2A)
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${day.day}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF5F5E5A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 18),

                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAEEDA),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Set the reminder',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF412402),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Never miss your morning routine!\nSet a reminder to stay on track',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF854F0B),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2C2C2A),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 8,
                                    ),
                                    shape: const StadiumBorder(),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Set Now',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text('🔔', style: TextStyle(fontSize: 48)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily routine',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2C2C2A),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF888780),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Obx(() {
                      if (habitController.isLoading.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(
                              color: Color(0xFF2C2C2A),
                            ),
                          ),
                        );
                      }

                      if (habitController.habits.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Text(
                              'Belum ada habit.\nTambah habit baru!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF888780),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: habitController.habits.map((habit) {
                          final int id = habit['id'];
                          final String name = habit['name'] ?? '';
                          final int streak =
                              habit['habit_stats']?['streak'] ?? 0;
                          final String time = habit['preferred_time'] ?? '';
                          final String category = habit['category'] ?? '';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => habitController.checkHabit(id),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: streak > 0
                                            ? const Color(0xFFE05A38)
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: streak > 0
                                              ? const Color(0xFFE05A38)
                                              : const Color(0xFFD3D1C7),
                                          width: 2,
                                        ),
                                      ),
                                      child: streak > 0
                                          ? const Icon(
                                              Icons.check,
                                              size: 14,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: _categoryColor(category),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.star_outline,
                                      size: 22,
                                      color: Color(0xFF5F5E5A),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF2C2C2A),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Streak $streak days',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF888780),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: Color(0xFF888780),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        time.length >= 5
                                            ? time.substring(0, 5)
                                            : time,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF888780),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 24,
              right: 0,
              child: FloatingActionButton(
                onPressed: () {
                  Get.to(() => addHabit());
                },
                backgroundColor: const Color(0xFF2C2C2A),
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
