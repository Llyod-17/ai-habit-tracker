import 'dart:convert';

import 'package:ai_habit_tracker/constant/constant.dart';
import 'package:ai_habit_tracker/view/HomePages.dart';
import 'package:ai_habit_tracker/view/LoginPages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class Authcontroller extends GetxController {
  final isLoading = false.obs;
  final token = ''.obs;

  final box = GetStorage();

  Future register (
    {
    required String name,
    required String email,
    required String password,
  }
  ) async {
    try {
      isLoading.value = true;
      var data = {
        'name': name,
        'email': email,
        'password': password,
      };

      var response = await http.post(
        Uri.parse('${url}register'),
          headers: {
            'Accept': 'application/json',
          },
          body: data,     
      );

      if(response.statusCode == 201) {
        isLoading.value = false;
        final json = jsonDecode(response.body);
        token.value = json['token'];
        box.write('token', token.value);
        Get.offAll(()=> Loginpages());
      } else {
        isLoading.value = false;
        Get.snackbar('error', jsonDecode(response.body)['message'], snackPosition: SnackPosition.TOP, backgroundColor: Colors.red[400] , colorText: Colors.white);
        debugPrint(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void logout() {
  box.remove('token'); 
  token.value = '';

  Get.offAll(() => Loginpages()); 
}

  Future login (
    {
    required String email,
    required String password
  }
  ) async {
    try {
      isLoading.value = true; 
      var data = {
        'email': email,
        'password': password,
      };

      var response = await http.post(
        Uri.parse('${url}login'),
        headers: {
          'Accept': 'application/json',
        },
        body: data
      );

      if(response.statusCode == 200) {
        isLoading.value = false;
        final json = jsonDecode(response.body);
        token.value = json['token'];
        box.write('token', token.value);
        Get.offAll(()=> Homepages());
      } else {
        isLoading.value = false;
        Get.snackbar('error', jsonDecode(response.body)['message'], snackPosition: SnackPosition.TOP, backgroundColor: Colors.red[400], colorText: Colors.white);
        debugPrint(response.body);
      }
    } catch (e) {
      print(e.toString());
    }

    
  }
}