import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_habit_tracker/controller/HabitController.dart';

class PerformancePages extends StatelessWidget {
  const PerformancePages({super.key});

  @override
  Widget build(BuildContext context) {
    final HabitController habitController = Get.find<HabitController>();

    final List<Color> barColors = [
      const Color(0xFF4A3525),
      const Color(0xFFB05312),
      const Color(0xFF8FA842),
      const Color(0xFFE580C9),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your progress\nand insights',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // ── Chart: success_rate per habit ──
                SizedBox(
                  height: 280,
                  child: Obx(() {
                    if (habitController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (habitController.habits.isEmpty) {
                      return const Center(
                        child: Text('Belum ada data habit.'),
                      );
                    }

                    final habits = habitController.habits
                        .take(4)
                        .toList();

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(habits.length, (index) {
                        final habit = habits[index];
                        final String name = habit['name'] ?? 'Habit';

                        // FIX: Konversi successRate dari dinamis/double secara aman ke double
                        final double successRate =
                            (habit['habit_stats']?['success_rate'] ?? 0).toDouble();
                        final double percentage = successRate.clamp(0.0, 100.0);

                        // FIX: Bungkus dengan Expanded agar width bar terbagi rata di dalam Row
                        return Expanded(
                          child: _buildVerticalProgressBar(
                            label: name,
                            percentage: percentage,
                            color: barColors[index % barColors.length],
                          ),
                        );
                      }),
                    );
                  }),
                ),
                const SizedBox(height: 32),

                // ── Bottom card ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Success Rate',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Average all habits',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                          Obx(() {
                            if (habitController.habits.isEmpty) {
                              return const Text('0%',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFE66E19)));
                            }
                            final habits =
                                habitController.habits.take(4).toList();
                            
                            // FIX: Perhitungan fold menggunakan double agar tidak terkena TypeError
                            final double totalSuccessRate = habits.fold<double>(
                              0.0,
                              (sum, h) => sum + (h['habit_stats']?['success_rate'] ?? 0).toDouble(),
                            );
                            final int avg = (totalSuccessRate / habits.length).round();

                            return Text(
                              '$avg%',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE66E19),
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.black12, height: 1),
                      const SizedBox(height: 20),

                      // Sub-metrics: streak tiap habit
                      Obx(() {
                        final habits =
                            habitController.habits.take(3).toList();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (int i = 0; i < habits.length; i++) ...[
                              // FIX: Bungkus submetric dengan Expanded agar flexibel jika nama habit terlalu panjang
                              Expanded(
                                child: _buildSubMetric(
                                  habits[i]['name'] ?? 'Habit',
                                  '🔥 ${habits[i]['habit_stats']?['streak'] ?? 0}d',
                                ),
                              ),
                              if (i < habits.length - 1)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: _buildVerticalDivider(),
                                ),
                            ],
                          ],
                        );
                      }),

                      const SizedBox(height: 32),

                      // Share button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7A1A),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Share Progress',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalProgressBar({
    required String label,
    required double percentage,
    required Color color,
  }) {
    final double progressValue = (percentage / 100).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Memberikan batasan tinggi tetap untuk bar di dalam Column
        SizedBox(
          height: 180, 
          width: 50, // Dipersempit sedikit dari 65 agar pas di screen kecil
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEFECE6),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Fill bar
                FractionallySizedBox(
                  heightFactor: progressValue,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                ),
                // Persentase label
                Positioned(
                  bottom: 16,
                  child: Text(
                    '${percentage.toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 60,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubMetric(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.grey, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 25, width: 1, color: Colors.black12);
  }
}