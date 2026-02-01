import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../services/storage_service.dart';
import '../../routes/app_routes.dart';

class NameInputController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final StorageService _storageService = StorageService();
  
  final RxString selectedAvatar = ''.obs;

  @override
  void onInit() {
    super.onInit();
    selectedAvatar.value = Get.arguments ?? '👦';
  }

  void startPlaying() async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        'Oops!',
        'Please enter your name 😊',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (name.length < 2) {
      Get.snackbar(
        'Oops!',
        'Name should be at least 2 characters 😊',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Create new user
    final user = UserModel(
      name: name,
      avatar: selectedAvatar.value,
    );

    // Save user
    await _storageService.saveUser(user);

    // Show welcome message
    Get.snackbar(
      'Welcome!',
      'Hello $name! Let\'s start learning! 🎉',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    // Navigate to home
    Get.offAllNamed(AppRoutes.HOME);
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
