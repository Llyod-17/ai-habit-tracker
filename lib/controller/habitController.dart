import 'dart:convert';
import 'package:ai_habit_tracker/view/HomePages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ai_habit_tracker/constant/constant.dart';

class HabitController extends GetxController {
  final isLoading = false.obs;
  final habits = [].obs;

  final isLoadingRecap = false.obs;
  final aiRecapData = Rxn<Map<String, dynamic>>();

  final currentPage = 1.obs;
  final totalPage = 1.obs;
  final totalData = 0.obs;

  final box = GetStorage();

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      };

  @override
  void onInit() {
    super.onInit();
    fetchHabits();
  }

  
  Future fetchHabits({int page = 1, int limit = 10}) async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse('${url}habits?page=$page&limit=$limit'),
        headers: _headers,
      );

      debugPrint('HABITS STATUS: ${response.statusCode}');
      debugPrint('HABITS BODY: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        habits.value = json['data'] ?? [];
        currentPage.value = json['page'] ?? 1;
        totalPage.value = json['total_page'] ?? 1;
        totalData.value = json['total_data'] ?? 0;

        debugPrint('Total habits: ${totalData.value}');
      } else {
        Get.snackbar(
          'Error',
          jsonDecode(response.body)['message'] ?? 'Gagal mengambil data',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('FETCH HABITS ERROR: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // CHECK HABIT
  // ─────────────────────────────────────────────
  Future checkHabit(int id) async {
    try {
      final response = await http.post(
        Uri.parse('${url}check-habit/$id'),
        headers: _headers,
      );

      debugPrint('CHECK HABIT STATUS: ${response.statusCode}');
      debugPrint('CHECK HABIT BODY: ${response.body}');

      if (response.statusCode == 200) {
        await fetchHabits();
      } else {
        Get.snackbar(
          'Error',
          jsonDecode(response.body)['error'] ?? 'Gagal check habit',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('CHECK HABIT ERROR: $e');
    }
  }

  // ─────────────────────────────────────────────
  // MAKE / CREATE HABIT
  // ─────────────────────────────────────────────
  Future makeHabit({
    required String name,
    required String category,
    required String description,
    required int targetPerDay,
    required String preferredTime,
    required String timeZone,
    required bool reminderEnabled,
    required List<String> repeatDays,
  }) async {
    isLoading.value = true;
    try {
      final data = {
        'name': name,
        'category': category,
        'description': description,
        'target_per_day': targetPerDay,
        'preferred_time': preferredTime,
        'time_zone': timeZone,
        'reminder_enabled': reminderEnabled,
        'repeat_days': repeatDays,
      };

      final response = await http.post(
        Uri.parse('${url}habits'),
        headers: _headers,
        body: jsonEncode(data),
      );

      debugPrint('MAKE HABIT STATUS: ${response.statusCode}');
      debugPrint('MAKE HABIT BODY: ${response.body}');

      if (response.statusCode == 201) {
        isLoading.value = false;
        Get.offAll(() => HomePages());
      } else {
        isLoading.value = false;
        final json = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          json['message'] ?? 'Pembuatan gagal',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint('MAKE HABIT ERROR: $e');
    }
  }

  // ─────────────────────────────────────────────
  // DELETE HABIT
  // ─────────────────────────────────────────────
  Future deleteHabit(int habitId) async {
    try {
      isLoading.value = true;

      final response = await http.delete(
        Uri.parse('${url}habits/$habitId'),
        headers: _headers,
      );

      debugPrint('DELETE STATUS: ${response.statusCode}');
      debugPrint('DELETE BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        aiRecapData.value = null;
        await fetchHabits();

        Get.snackbar(
          'Sukses',
          'Habit berhasil dihapus!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[400],
          colorText: Colors.white,
        );
      } else {
        final json = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          json['message'] ?? 'Gagal menghapus habit',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error Delete Habit: $e');
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> fetchRecap(int habitId) async {
    try {
      isLoadingRecap.value = true;

      final token = box.read('token');
      final uri = Uri.parse('${url}ai/recommendation/$habitId/recap');

      debugPrint('RECAP URL: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('RECAP STATUS: ${response.statusCode}');
      debugPrint('RECAP BODY: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        aiRecapData.value = jsonResponse['data'];
      } else {
        aiRecapData.value = null;
      }
    } catch (e) {
      debugPrint('RECAP ERROR: $e');
      aiRecapData.value = null;
    } finally {
      isLoadingRecap.value = false;
    }
  }

  // ── Helpers ──
  bool isCompletedToday(dynamic habit) => habit['is_completed_today'] ?? false;
  int getStreak(dynamic habit) => habit['habit_stats']?['streak'] ?? 0;
  double getSuccessRate(dynamic habit) =>
      (habit['habit_stats']?['success_rate'] ?? 0.0).toDouble();
}