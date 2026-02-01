import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class AvatarSelectController extends GetxController {
  final RxString selectedAvatar = ''.obs;

  final List<Map<String, String>> avatars = [
    {'emoji': '👦', 'name': 'Boy', 'color': '0xFFFF6B9D'},
    {'emoji': '👧', 'name': 'Girl', 'color': '0xFF4ECDC4'},
    {'emoji': '🐼', 'name': 'Panda', 'color': '0xFF95E1D3'},
    {'emoji': '🦁', 'name': 'Lion', 'color': '0xFFFFA07A'},
    {'emoji': '🐯', 'name': 'Tiger', 'color': '0xFFFFD93D'},
    {'emoji': '🐻', 'name': 'Bear', 'color': '0xFFAA96DA'},
    {'emoji': '🦊', 'name': 'Fox', 'color': '0xFFFCAB10'},
    {'emoji': '🐰', 'name': 'Bunny', 'color': '0xFFFFB6C1'},
  ];

  void selectAvatar(String avatar) {
    selectedAvatar.value = avatar;
  }

  void continueToNameInput() {
    if (selectedAvatar.value.isEmpty) {
      Get.snackbar(
        'Oops!',
        'Please select an avatar first 😊',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    Get.toNamed(AppRoutes.NAME_INPUT, arguments: selectedAvatar.value);
  }
}
