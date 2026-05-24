import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ai_habit_tracker/constant/constant.dart';

class HabitController extends GetxController {
  final isLoading = false.obs;
  final habits = [].obs;
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

  Future fetchHabits() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('${url}habits?page=1&limit=10'),
        headers: _headers,
      );

      debugPrint('HABITS STATUS: ${response.statusCode}');
      debugPrint('HABITS BODY: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        habits.value = json['data'] ?? [];
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

  Future checkHabit(int id) async {
    try {
      final response = await http.post(
        Uri.parse('${url}check-habit/$id'),
        headers: _headers,
      );

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
}