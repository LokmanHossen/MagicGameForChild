import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../../routes/app_routes.dart';

class ParentAreaController extends GetxController {
  final StorageService _storageService = StorageService();
  final TextEditingController pinController = TextEditingController();
  final RxBool isAuthenticated = false.obs;

  final String correctPin = '1234'; // Default PIN

  void verifyPin() {
    if (pinController.text == correctPin) {
      isAuthenticated.value = true;
      Get.snackbar(
        'Welcome',
        'Access granted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Incorrect PIN',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE91E63),
        colorText: Colors.white,
      );
      pinController.clear();
    }
  }

  void resetProgress() {
    Get.defaultDialog(
      title: 'Reset Progress',
      middleText:
          'Are you sure you want to reset all progress? This cannot be undone.',
      textConfirm: 'Reset',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        _storageService.clearUser();
        Get.back(); // Close dialog
        Get.offAllNamed(AppRoutes.SPLASH);
        Get.snackbar(
          'Reset Complete',
          'All progress has been reset',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
        );
      },
    );
  }

  @override
  void onClose() {
    pinController.dispose();
    super.onClose();
  }
}
