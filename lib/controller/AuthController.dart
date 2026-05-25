import 'dart:convert';
import 'package:ai_habit_tracker/constant/constant.dart';
import 'package:ai_habit_tracker/view/HomePages.dart';
import 'package:ai_habit_tracker/view/LoginPages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  final isLoading = false.obs;
  final token = ''.obs;
  final box = GetStorage();

  Future register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {'name': name, 'email': email, 'password': password};

      var response = await http.post(
        Uri.parse('${url}auth/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      debugPrint('REGISTER STATUS: ${response.statusCode}');
      debugPrint('REGISTER BODY: ${response.body}');

      if (response.statusCode == 201) {
        Get.offAll(() => LoginPages());
        Get.snackbar(
          'Sukses',
          'Registrasi berhasil! Silakan login.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[400],
          colorText: Colors.white,
        );
      } else {
        final json = jsonDecode(response.body);
        Get.snackbar(
          'Registrasi Gagal',
          json['message'] ?? 'Periksa kembali data diri Anda', 
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('REGISTER ERROR: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan koneksi.',
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false; 
    }
  }

  void logout() {
    box.remove('token');
    token.value = '';
    Get.offAll(() => LoginPages());
  }

  Future login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      var data = {'email': email, 'password': password};

      var response = await http.post(
        Uri.parse('${url}auth/login'),
        headers: {
          'Accept': 'application/json', 
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      debugPrint('LOGIN STATUS: ${response.statusCode}');
      debugPrint('LOGIN BODY: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        token.value = json['token'];
        box.write('token', token.value);
        
        Get.offAll(() => HomePages());
      } else {
        final json = jsonDecode(response.body);
        
        Get.snackbar(
          'Login Gagal',
          json['message'] ?? 'Email atau password salah.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('LOGIN ERROR: $e');
      Get.snackbar(
        'Error',
        'Gagal terhubung ke server.',
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false; 
    }
  }
}