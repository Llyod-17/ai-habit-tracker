import 'package:ai_habit_tracker/controller/HabitController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_habit_tracker/widget/dataInput.dart';

class addHabit extends StatefulWidget {
  const addHabit({super.key});

  @override
  State<addHabit> createState() => _addHabitState();
}

class _addHabitState extends State<addHabit> {
  final HabitController habitController = Get.put(HabitController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController targetPerDayController = TextEditingController();
  final TextEditingController preferredTimeController = TextEditingController();
  final TextEditingController timeZoneController = TextEditingController();

  String? selectedCategory;
  bool reminderEnabled = true;

  List<bool> selectedDays = [false, false, false, true, false, false, false];
  final List<String> dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<String> fullDayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  final List<String> categoryOptions = ['low', 'mid', 'high'];

  List<String> get selectedDayNames {
    List<String> result = [];
    for (int i = 0; i < selectedDays.length; i++) {
      if (selectedDays[i]) result.add(fullDayNames[i]);
    }
    return result;
  }

  bool _validate() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Oops',
        'Habit name cannot be empty',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return false;
    }
    if (selectedCategory == null) {
      Get.snackbar(
        'Oops',
        'Please select a category',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return false;
    }
    if (targetPerDayController.text.trim().isEmpty ||
        int.tryParse(targetPerDayController.text.trim()) == null) {
      Get.snackbar(
        'Oops',
        'Target per day must be a valid number',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return false;
    }
    if (preferredTimeController.text.trim().isEmpty) {
      Get.snackbar(
        'Oops',
        'Preferred time cannot be empty',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return false;
    }
    if (timeZoneController.text.trim().isEmpty) {
      Get.snackbar(
        'Oops',
        'Time zone cannot be empty',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return false;
    }
    if (selectedDayNames.isEmpty) {
      Get.snackbar(
        'Oops',
        'Please select at least one repeat day',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  void _onSave() {
  if (!_validate()) return;

  String rawTime = preferredTimeController.text.trim();

  final parts = rawTime.split(':');
  final hour = parts[0].padLeft(2, '0');
  final minute = parts.length > 1 ? parts[1].padLeft(2, '0') : '00';
  final second = parts.length > 2 ? parts[2].padLeft(2, '0') : '00';
  final formattedTime = '$hour:$minute:$second';

  debugPrint('FORMATTED TIME: $formattedTime');

  habitController.makeHabit(
    name: nameController.text.trim(),
    category: selectedCategory!,
    description: descriptionController.text.trim(),
    targetPerDay: int.parse(targetPerDayController.text.trim()),
    preferredTime: formattedTime, // ← pakai yang sudah diformat
    timeZone: timeZoneController.text.trim(),
    reminderEnabled: reminderEnabled,
    repeatDays: selectedDayNames,
  );
}

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    targetPerDayController.dispose();
    preferredTimeController.dispose();
    timeZoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "New habit",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2C2C2A),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 18,
                            color: Color(0xFF2C2C2A),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Image.asset("assets/images/Habit.png", width: 160),
                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Name your habit",
                        style: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      dataInputWidget(
                        hintText: "Morning Meditations",
                        controller: nameController,
                        obscureText: false,
                        keyboardType: TextInputType.name,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Description (optional)",
                        style: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      dataInputWidget(
                        hintText: "Add a short description...",
                        controller: descriptionController,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Category",
                        style: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            isExpanded: true,
                            hint: const Text(
                              "Select priority",
                              style: TextStyle(
                                color: Color(0xFF6E6A6A),
                                fontSize: 14,
                              ),
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF9E9E9E),
                            ),
                            items: categoryOptions.map((String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(
                                  val[0].toUpperCase() + val.substring(1),
                                  style: const TextStyle(
                                    color: Color(0xFF2C2C2A),
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setState(() => selectedCategory = val),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Target per day",
                        style: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      dataInputWidget(
                        hintText: "e.g. 3",
                        controller: targetPerDayController,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 20),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Preferred time",
                                  style: TextStyle(
                                    color: Color(0xFF9E9E9E),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                dataInputWidget(
                                  hintText: "08:00",
                                  controller: preferredTimeController,
                                  obscureText: false,
                                  keyboardType: TextInputType.datetime,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Time zone",
                                  style: TextStyle(
                                    color: Color(0xFF9E9E9E),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                dataInputWidget(
                                  hintText: "Asia/Jakarta",
                                  controller: timeZoneController,
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Repeat days",
                        style: TextStyle(
                          color: Color(0xFF2C2C2A),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (index) {
                          final isSelected = selectedDays[index];
                          return GestureDetector(
                            onTap: () => setState(
                              () => selectedDays[index] = !selectedDays[index],
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF2C2C2A)
                                    : Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  dayLabels[index],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF2C2C2A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Get reminders",
                            style: TextStyle(
                              color: Color(0xFF2C2C2A),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Switch(
                            value: reminderEnabled,
                            onChanged: (val) =>
                                setState(() => reminderEnabled = val),
                            activeColor: Colors.white,
                            activeTrackColor: const Color(0xFFE87D2B),
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: const Color(0xFFDDDBD6),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: habitController.isLoading.value
                                ? null
                                : _onSave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE87D2B),
                              disabledBackgroundColor: const Color(
                                0xFFE87D2B,
                              ).withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: habitController.isLoading.value
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    "Save Habit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
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
}
