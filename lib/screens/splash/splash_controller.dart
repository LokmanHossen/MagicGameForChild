// import 'package:get/get.dart';
// import '../../services/storage_service.dart';
// import '../../routes/app_routes.dart';

// class SplashController extends GetxController {
//   final StorageService _storageService = StorageService();

//   @override
//   void onInit() {
//     super.onInit();
//     _navigateToNextScreen();
//   }

//   void _navigateToNextScreen() async {
//     await Future.delayed(const Duration(seconds: 3));

//     if (_storageService.hasUser()) {
//       // User already registered, go to home
//       Get.offAllNamed(AppRoutes.HOME);
//     } else {
//       // New user, go to avatar selection
//       Get.offAllNamed(AppRoutes.AVATAR_SELECT);
//     }
//   }
// }

import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final StorageService _storageService = StorageService();

  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    // Check if user exists in storage
    if (_storageService.hasUser()) {
      // User already registered, go to home
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      // New user, go to avatar selection
      Get.offAllNamed(AppRoutes.AVATAR_SELECT);
    }
  }
}
