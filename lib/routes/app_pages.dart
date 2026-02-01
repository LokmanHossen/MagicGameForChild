import 'package:get/get.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/splash/splash_controller.dart';
import '../screens/avatar_select/avatar_select_screen.dart';
import '../screens/avatar_select/avatar_select_controller.dart';
import '../screens/name_input/name_input_screen.dart';
import '../screens/name_input/name_input_controller.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/home_controller.dart';
import '../screens/games/abc_game/abc_game_screen.dart';
import '../screens/games/abc_game/abc_game_controller.dart';
import '../screens/games/number_game/number_game_screen.dart';
import '../screens/games/number_game/number_game_controller.dart';
import '../screens/games/animal_game/animal_game_screen.dart';
import '../screens/games/animal_game/animal_game_controller.dart';
import '../screens/games/color_game/color_game_screen.dart';
import '../screens/games/color_game/color_game_controller.dart';
import '../screens/games/puzzle_game/puzzle_game_screen.dart';
import '../screens/games/puzzle_game/puzzle_game_controller.dart';
import '../screens/parent_area/parent_area_screen.dart';
import '../screens/parent_area/parent_area_controller.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(
      name: AppRoutes.AVATAR_SELECT,
      page: () => const AvatarSelectScreen(),
      binding: BindingsBuilder(() {
        Get.put(AvatarSelectController());
      }),
    ),
    GetPage(
      name: AppRoutes.NAME_INPUT,
      page: () => const NameInputScreen(),
      binding: BindingsBuilder(() {
        Get.put(NameInputController());
      }),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
      }),
    ),
    GetPage(
      name: AppRoutes.ABC_GAME,
      page: () => const AbcGameScreen(),
      binding: BindingsBuilder(() {
        Get.put(AbcGameController());
      }),
    ),
    GetPage(
      name: AppRoutes.NUMBER_GAME,
      page: () => const NumberGameScreen(),
      binding: BindingsBuilder(() {
        Get.put(NumberGameController());
      }),
    ),
    GetPage(
      name: AppRoutes.ANIMAL_GAME,
      page: () => const AnimalGameScreen(),
      binding: BindingsBuilder(() {
        Get.put(AnimalGameController());
      }),
    ),
    GetPage(
      name: AppRoutes.COLOR_GAME,
      page: () => const ColorGameScreen(),
      binding: BindingsBuilder(() {
        Get.put(ColorGameController());
      }),
    ),
    GetPage(
      name: AppRoutes.PUZZLE_GAME,
      page: () => const PuzzleGameScreen(),
      binding: BindingsBuilder(() {
        Get.put(PuzzleGameController());
      }),
    ),
    GetPage(
      name: AppRoutes.PARENT_AREA,
      page: () => const ParentAreaScreen(),
      binding: BindingsBuilder(() {
        Get.put(ParentAreaController());
      }),
    ),
  ];
}
