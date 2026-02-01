import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../services/storage_service.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
  final StorageService _storageService = StorageService();
  final Rxn<UserModel> user = Rxn<UserModel>();

  final List<Map<String, dynamic>> gameAreas = [
    {
      'title': 'ABC Land',
      'subtitle': 'Learn Alphabets',
      'icon': '🅰️',
      'color': 0xFFFF6B9D,
      'route': AppRoutes.ABC_GAME,
      'progress': 'abc',
    },
    {
      'title': 'Number Hills',
      'subtitle': 'Learn Counting',
      'icon': '🔢',
      'color': 0xFF4ECDC4,
      'route': AppRoutes.NUMBER_GAME,
      'progress': 'numbers',
    },
    {
      'title': 'Animal Forest',
      'subtitle': 'Meet Animals',
      'icon': '🐶',
      'color': 0xFF95E1D3,
      'route': AppRoutes.ANIMAL_GAME,
      'progress': 'animals',
    },
    {
      'title': 'Color Town',
      'subtitle': 'Learn Colors',
      'icon': '🎨',
      'color': 0xFFFFA07A,
      'route': AppRoutes.COLOR_GAME,
      'progress': 'colors',
    },
    {
      'title': 'Puzzle Zone',
      'subtitle': 'Brain Games',
      'icon': '🧩',
      'color': 0xFFAA96DA,
      'route': AppRoutes.PUZZLE_GAME,
      'progress': 'puzzle',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  void loadUser() {
    final userData = _storageService.getUser();
    if (userData != null) {
      user.value = userData;
    }
  }

  void navigateToGame(String route) {
    Get.toNamed(route)?.then((_) {
      // Reload user data after returning from game
      loadUser();
    });
  }

  void openParentArea() {
    Get.toNamed(AppRoutes.PARENT_AREA);
  }

  int getGameProgress(String gameKey) {
    final progress = user.value?.gameProgress[gameKey] ?? 0;
    // Ensure progress never exceeds 100%
    return progress > 100 ? 100 : progress;
  }

  // Get user stars
  int getUserStars() {
    return user.value?.stars ?? 0;
  }

  // Get user level
  int getUserLevel() {
    return user.value?.level ?? 1;
  }
}
