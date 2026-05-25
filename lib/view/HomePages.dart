import 'package:ai_habit_tracker/controller/HabitController.dart';
import 'package:ai_habit_tracker/view/addHabit.dart';
import 'package:ai_habit_tracker/view/editHabit.dart';
import 'package:ai_habit_tracker/view/profilePages.dart';
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

  void _showAllHabits() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 400),
      ),
      builder: (context) => _AllHabitsSheet(
        habitController: habitController,
        categoryColor: _categoryColor,
      ),
    );
  }

  void _showHabitOptions(BuildContext context, dynamic habit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _HabitOptionsSheet(habit: habit, habitController: habitController),
    );
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
                    // ── Header ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Morning, ${box.read('name') ?? 'User'} 👋',
                              style: const TextStyle(
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

                    // ── Week strip ──
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

                    // ── Reminder banner ──
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
                              children: const [
                                Text(
                                  'Set the reminder',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF412402),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Never miss your morning routine!\nSet a reminder to stay on track',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF854F0B),
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(height: 12),
                              ],
                            ),
                          ),
                          const Text('🔔', style: TextStyle(fontSize: 48)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ── Daily routine header ──
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
                          onTap: _showAllHabits,
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

                    // ── Habit list ──
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
                          final bool isCompletedToday =
                              habit['is_completed_today'] ?? false;
                          final int id = habit['id'];
                          final String name = habit['name'] ?? '';
                          final int streak =
                              habit['habit_stats']?['streak'] ?? 0;
                          final String time = habit['preferred_time'] ?? '';
                          final String category = habit['category'] ?? '';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onLongPress: () =>
                                  _showHabitOptions(context, habit),
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
                                      onTap: () =>
                                          habitController.checkHabit(id),
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: isCompletedToday
                                              ? const Color(0xFFE05A38)
                                              : Colors.transparent,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isCompletedToday
                                                ? const Color(0xFFE05A38)
                                                : const Color(0xFFD3D1C7),
                                            width: 2,
                                          ),
                                        ),
                                        child: isCompletedToday
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
                                          Row(
                                            children: [
                                              Text(
                                                name,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF2C2C2A),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              if (category.isNotEmpty)
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        _categoryColor(category),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                      color: category == 'high'
                                                          ? const Color(
                                                                  0xFFE05A38)
                                                              .withOpacity(0.2)
                                                          : const Color(
                                                                  0xFF888780)
                                                              .withOpacity(0.2),
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    category.toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: category == 'high'
                                                          ? const Color(
                                                              0xFFE05A38)
                                                          : category == 'mid'
                                                              ? const Color(
                                                                  0xFFD97706)
                                                              : const Color(
                                                                  0xFF0F766E),
                                                    ),
                                                  ),
                                                ),
                                            ],
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
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // ── FAB ──
            Positioned(
              bottom: 24,
              right: 0,
              child: FloatingActionButton(
                onPressed: () => Get.to(() => const addHabit()),
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

// ════════════════════════════════════════
// All Habits Sheet
// ════════════════════════════════════════
class _AllHabitsSheet extends StatelessWidget {
  final HabitController habitController;
  final Color Function(String?) categoryColor;

  const _AllHabitsSheet({
    required this.habitController,
    required this.categoryColor,
  });

  void _showHabitOptions(BuildContext context, dynamic habit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _HabitOptionsSheet(habit: habit, habitController: habitController),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F3EE),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD3D1C7),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'All Habits',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2C2C2A),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (habitController.habits.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada habit.',
                      style:
                          TextStyle(color: Color(0xFF888780), fontSize: 14),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: habitController.habits.length,
                  itemBuilder: (context, index) {
                    final habit = habitController.habits[index];
                    final String name = habit['name'] ?? '';
                    final int streak =
                        habit['habit_stats']?['streak'] ?? 0;
                    final String time = habit['preferred_time'] ?? '';
                    final String category = habit['category'] ?? '';

                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration:
                          Duration(milliseconds: 300 + (index * 60)),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _showHabitOptions(context, habit),
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
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: _categoryColorStatic(category),
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
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.more_vert_rounded,
                                      size: 18,
                                      color: Color(0xFF888780),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Helper static agar bisa dipakai di StatelessWidget
  static Color _categoryColorStatic(String? category) {
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
}

// ════════════════════════════════════════
// Habit Options Sheet
// ════════════════════════════════════════
class _HabitOptionsSheet extends StatefulWidget {
  final dynamic habit;
  final HabitController habitController;

  const _HabitOptionsSheet({
    required this.habit,
    required this.habitController,
  });

  @override
  State<_HabitOptionsSheet> createState() => _HabitOptionsSheetState();
}

class _HabitOptionsSheetState extends State<_HabitOptionsSheet> {
  bool _showInsight = false;

  Future<void> _loadInsight() async {
    // Toggle tutup jika sudah ada data
    if (widget.habitController.aiRecapData.value != null && _showInsight) {
      setState(() => _showInsight = false);
      return;
    }

    setState(() => _showInsight = true);

    await widget.habitController.fetchRecap(widget.habit['id']);
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.habit['name'] ?? '';
    

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F3EE),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD3D1C7),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2C2C2A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pilih aksi',
                style: TextStyle(fontSize: 13, color: Color(0xFF888780)),
              ),
              const SizedBox(height: 20),

              // ── Edit Habit ──
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.to(() => const Edithabit());
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, color: Colors.grey[700]),
                      const SizedBox(width: 12),
                      const Text(
                        'Edit Habit',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // ── AI Insight Toggle Button ──
              GestureDetector(
                onTap: _loadInsight,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.amber[700]),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'AI Recap & Insight',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Obx(() => widget.habitController.isLoadingRecap.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF2C2C2A),
                              ),
                            )
                          : Icon(
                              _showInsight
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            )),
                    ],
                  ),
                ),
              ),

              if (_showInsight) ...[
                const SizedBox(height: 10),
                Obx(() {
                  if (widget.habitController.isLoadingRecap.value) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F1FB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }

                  final recapData = widget.habitController.aiRecapData.value;

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F1FB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      
                      recapData != null
                          ? recapData['insight'] ??
                              'Tidak ada data insight.'
                          : 'Gagal memuat insight AI.',
                      style: const TextStyle(
                          color: Color(0xFF1E3A8A), fontSize: 13),
                    ),
                  );
                }),
              ],

              const SizedBox(height: 10),

              // ── Hapus Habit ──
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.dialog(
                    AlertDialog(
                      backgroundColor: const Color(0xFFF5F3EE),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: const Text(
                        'Hapus Habit?',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2C2C2A)),
                      ),
                      content: Text(
                        'Apakah kamu yakin ingin menghapus habit "$name"?',
                        style:
                            const TextStyle(color: Color(0xFF5F5E5A)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Batal',
                              style: TextStyle(
                                  color: Color(0xFF888780),
                                  fontWeight: FontWeight.w600)),
                        ),
                        TextButton(
                          onPressed: () {
                            widget.habitController
                                .deleteHabit(widget.habit['id']);
                            Get.back();
                          },
                          child: const Text('Hapus',
                              style: TextStyle(
                                  color: Color(0xFFE05A38),
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBEAF0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.delete_outline_rounded,
                          color: Color(0xFFE05A38), size: 20),
                      SizedBox(width: 12),
                      Text(
                        'Hapus Habit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE05A38),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}