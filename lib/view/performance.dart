import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_habit_tracker/controller/HabitController.dart'; // Sesuaikan path controller-mu

class PerformancePages extends StatelessWidget {
  const PerformancePages({super.key});

  @override
  Widget build(BuildContext context) {
    final HabitController habitController = Get.find<HabitController>();

    final List<Color> barColors = [
      const Color(0xFF4A3525), // Cokelat Tua
      const Color(0xFFB05312), // Cokelat Muda/Oren
      const Color(0xFF8FA842), // Hijau
      const Color(0xFFE580C9), // Pink
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      body: SafeArea(
        // Mencegah overflow di layar kecil dengan scrollview
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER SECTION ---
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

                // --- CHART SECTION (VERTICAL PROGRESS BARS) ---
                // Menggunakan Container dengan tinggi statis agar bar aman ter-render
                SizedBox(
                  height: 280, 
                  child: Obx(() {
                    if (habitController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (habitController.habits.isEmpty) {
                      return const Center(
                        child: Text('Belum ada data habit untuk dihitung.'),
                      );
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        habitController.habits.length.clamp(0, 4),
                        (index) {
                          final habit = habitController.habits[index];
                          
                          int completedDays = habit['completed_days_count'] ?? 0;
                          int streak = habit['current_streak'] ?? 0;
                          int missedDays = habit['missed_days_count'] ?? 0;

                          double calculatedScore = (completedDays * 0.4) + (streak * 0.4) - (missedDays * 0.2);
                          if (calculatedScore < 0) calculatedScore = 0;

                          double displayPercentage = (calculatedScore * 10).clamp(0, 100); 
                          Color barColor = barColors[index % barColors.length];

                          return _buildVerticalProgressBar(
                            label: habit['name'] ?? 'Habit',
                            percentage: displayPercentage,
                            color: barColor,
                          );
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),

                // --- BOTTOM CARD SECTION (POINTS EARNED) ---
                // Menghilangkan Expanded diganti tinggi dinamis wrap-content
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Biar pas seukuran konten di dalamnya
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Points Earned',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'For this week',
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                          Obx(() {
                            double totalAllScore = 0;
                            for (var habit in habitController.habits) {
                              int comp = habit['completed_days_count'] ?? 10;
                              int strk = habit['current_streak'] ?? 0;
                              int miss = habit['missed_days_count'] ?? 0;
                              double score = (comp * 0.4) + (strk * 0.4) - (miss * 0.2);
                              if (score > 0) totalAllScore += score;
                            }
                            int totalPoints = (totalAllScore * 10).toInt();

                            return Text(
                              '$totalPoints Points',
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
                      
                      // --- SUB-METRICS ROW ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSubMetric('Post', '440 lb'),
                          _buildVerticalDivider(),
                          _buildSubMetric('Forest area', '200 ft²'),
                          _buildVerticalDivider(),
                          _buildSubMetric('Time', '7h 30m'),
                        ],
                      ),
                      const SizedBox(height: 32), // Menggantikan Spacer() yang bikin crash

                      // --- BUTTON SHARE PROGRESS ---
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            // Aksi share
                          },
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
                      )
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

  // --- WIDGET HELPER: VERTICAL PROGRESS BAR ---
  Widget _buildVerticalProgressBar({
    required String label,
    required double percentage,
    required Color color,
  }) {
    double progressValue = (percentage / 100).clamp(0.0, 1.0);

    return Column(
      children: [
        Expanded(
          child: Container(
            width: 65, // Disesuaikan sedikit agar pas di space Row layar kecil
            decoration: BoxDecoration(
              color: const Color(0xFFEFECE6),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.05,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.black, Colors.transparent],
                          stops: [0.5, 0.5],
                          transform: GradientRotation(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: progressValue,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: Text(
                    '${percentage.toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSubMetric(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 25,
      width: 1,
      color: Colors.black12,
    );
  }
}