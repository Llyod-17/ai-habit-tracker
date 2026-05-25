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

  Future makeHabit({
    required String name,
    required String category,
    required String description,
    required int targetPerDay,
    required String preferredTime,
    required String timeZone,
    required bool reminderEnabled,
    required List<String> repeatDays

  }) async {
    isLoading.value = true;
    try {
      var data = {'name': name, 'category': category, 'description': description, 'target_per_day': targetPerDay, 'preferred_time': preferredTime, 'time_zone': timeZone, 'reminder_enabled': reminderEnabled, 'repeat_days': repeatDays};
      var response = await http.post(
        Uri.parse('${url}habits'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: jsonEncode(data),
      );
      if(response.statusCode == 201) {
        isLoading.value = false;
        final json = jsonDecode(response.body);
        Get.offAll(() => HomePages());
      } else {
        isLoading.value = false;
        debugPrint('STATUS: ${response.statusCode}');
        debugPrint('BODY: ${response.body}'); 

        final json = jsonDecode(response.body);
        Get.snackbar(
          'error',
          json['message'] ?? 'Pembuatan gagal',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
      }
    } catch(e) {
      isLoading.value = false; 
    debugPrint(e.toString());
    }
  }

  //   Future updateHabit({
//     required int habitId, 
//     required String title,
//     required String description,
//   }) async {
//     try {
//       isLoading.value = true;

//       String? savedToken = box.read('token') ?? token.value;

//       var data = {
//         'title': title,
//         'description': description,
//       };

//       var response = await http.put(
//         Uri.parse('${url}habit/$habitId'), 
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $savedToken', // Menyertakan token agar diizinkan backend
//         },
//         body: jsonEncode(data),
//       );

//       if (response.statusCode == 200 || response.statusCode == 202) {
//         isLoading.value = false;
        
//         Get.snackbar(
//           'Sukses',
//           'Habit berhasil diperbarui!',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.green[400],
//           colorText: Colors.white,
//         );

//         Get.back(); 
//       } else {
//         isLoading.value = false;
//         debugPrint('EDIT STATUS: ${response.statusCode}');
//         debugPrint('EDIT BODY: ${response.body}');

//         final json = jsonDecode(response.body);
//         Get.snackbar(
//           'Error',
//           json['message'] ?? 'Gagal memperbarui habit',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.red[400],
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       isLoading.value = false;
//       debugPrint('Error Update Habit: ${e.toString()}');
//     }
//   }
// }

  Future deleteHabit(int habitId) async {
    try {
      isLoading.value = true;
      
      var response = await http.delete(
        Uri.parse('${url}habits/$habitId'),
        headers: _headers,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        await fetchHabits(); 

        Get.snackbar(
          'Sukses',
          'Habit berhasil dihapus!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[400],
          colorText: Colors.white,
        );
      } else {
        debugPrint('DELETE STATUS: ${response.statusCode}');
        debugPrint('DELETE BODY: ${response.body}');

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
      debugPrint('Error Delete Habit: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
  
}