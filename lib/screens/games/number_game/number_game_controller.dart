// import 'dart:async';
// import 'package:get/get.dart';

// class NumberGameController extends GetxController {
//   // Game State
//   final RxInt score = 0.obs;
//   final RxInt currentLevel = 1.obs;
//   final RxInt timeRemaining = 60.obs;
//   final RxInt targetNumber = 1.obs;
//   final RxList<int> selectedNumbers = <int>[].obs;
//   final RxList<int> numbers = <int>[].obs;
//   final RxDouble progress = 0.0.obs;
//   final RxBool showHint = false.obs;

//   // Animation States
//   final RxBool showWrongAnimation = false.obs;
//   final RxBool showCorrectAnimation = false.obs;

//   Timer? _gameTimer;
//   Timer? _hintTimer;

//   @override
//   void onInit() {
//     super.onInit();
//     _startGame();
//     _startTimer();
//   }

//   void _startGame() {
//     // Initialize numbers for the level
//     numbers.clear();
//     selectedNumbers.clear();
//     showHint.value = false;
//     hideWrongAnimation();
//     hideCorrectAnimation();

//     // Generate random numbers
//     final count = 4 + (currentLevel.value - 1) * 2;
//     final tempNumbers = <int>[];
//     for (int i = 1; i <= count; i++) {
//       tempNumbers.add(i);
//     }

//     tempNumbers.shuffle();
//     numbers.assignAll(tempNumbers);

//     targetNumber.value = 1;
//     progress.value = 0.0;
//   }

//   void _startTimer() {
//     _gameTimer?.cancel();
//     timeRemaining.value = 60;

//     _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (timeRemaining.value > 0) {
//         timeRemaining.value--;
//       } else {
//         timer.cancel();
//         showWrongAnimation.value = true;
//         Future.delayed(const Duration(seconds: 2), () {
//           _levelComplete();
//         });
//       }
//     });
//   }

//   void selectNumber(int number) {
//     if (selectedNumbers.contains(number)) return;

//     if (showHint.value && number == targetNumber.value) {
//       showHint.value = false;
//     }

//     if (number == targetNumber.value) {
//       // Correct number
//       selectedNumbers.add(number);
//       targetNumber.value++;
//       score.value += 10;

//       // Show correct animation
//       showCorrectAnimation.value = true;

//       progress.value = selectedNumbers.length / numbers.length;

//       if (selectedNumbers.length == numbers.length) {
//         _levelComplete();
//       }
//     } else {
//       // Wrong number
//       score.value -= 5;
//       if (score.value < 0) score.value = 0;

//       // Show wrong animation
//       showWrongAnimation.value = true;
//     }
//   }

//   bool isCorrectNumberOrder(int number) {
//     if (!selectedNumbers.contains(number)) return false;
//     return number == selectedNumbers.indexOf(number) + 1;
//   }

//   void _levelComplete() {
//     _gameTimer?.cancel();
//     _hintTimer?.cancel();
//     score.value += 50;

//     showCorrectAnimation.value = true;

//     Future.delayed(const Duration(seconds: 2), () {
//       currentLevel.value++;
//       _startGame();
//       _startTimer();
//     });
//   }

//   void completeLevel() {
//     if (selectedNumbers.length == numbers.length) {
//       _levelComplete();
//     } else {
//       showWrongAnimation.value = true;
//     }
//   }

//   void provideHint() {
//     if (score.value >= 20 && !showHint.value) {
//       score.value -= 20;
//       showHint.value = true;

//       _hintTimer?.cancel();
//       _hintTimer = Timer(const Duration(seconds: 10), () {
//         showHint.value = false;
//       });
//     } else if (showHint.value) {
//       // Hint already active - show a quick feedback
//       showCorrectAnimation.value = true;
//       Future.delayed(const Duration(milliseconds: 800), () {
//         hideCorrectAnimation();
//       });
//     } else {
//       showWrongAnimation.value = true;
//     }
//   }

//   void resetGame() {
//     selectedNumbers.clear();
//     targetNumber.value = 1;
//     progress.value = 0.0;
//     showHint.value = false;
//     hideWrongAnimation();
//     hideCorrectAnimation();
//     _hintTimer?.cancel();
//     _startGame();
//     _startTimer();
//   }

//   // Animation control methods
//   void hideWrongAnimation() {
//     showWrongAnimation.value = false;
//   }

//   void hideCorrectAnimation() {
//     showCorrectAnimation.value = false;
//   }

//   void quitGame() {
//     _gameTimer?.cancel();
//     _hintTimer?.cancel();
//     Get.back();
//   }

//   @override
//   void onClose() {
//     _gameTimer?.cancel();
//     _hintTimer?.cancel();
//     super.onClose();
//   }
// }
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_learning_world/services/storage_service.dart';

class NumberGameController extends GetxController {
  final StorageService _storageService = StorageService();

  // Game State
  final RxInt score = 0.obs;
  final RxInt currentLevel = 1.obs;
  final RxInt timeRemaining = 60.obs;
  final RxInt targetNumber = 1.obs;
  final RxList<int> selectedNumbers = <int>[].obs;
  final RxList<int> numbers = <int>[].obs;
  final RxDouble progress = 0.0.obs;
  final RxBool showHint = false.obs;

  // Animation States
  final RxBool showWrongAnimation = false.obs;
  final RxBool showCorrectAnimation = false.obs;

  // Game completion tracking
  final RxInt totalStarsEarned = 0.obs;
  final RxInt levelsCompleted = 0.obs;

  // Constants
  final int maxLevels = 10; // Total levels in the game

  Timer? _gameTimer;
  Timer? _hintTimer;

  @override
  void onInit() {
    super.onInit();
    _loadGameState(); // Load saved state
    _startGame();
    _startTimer();
  }

  void _loadGameState() {
    final user = _storageService.getUser();
    if (user != null) {
      // Load saved level from user model
      // We need to store level separately in gameProgress
      final savedLevel = user.gameProgress['numbers_level'] ?? 1;

      // Ensure level doesn't exceed maxLevels
      if (savedLevel > maxLevels) {
        currentLevel.value = maxLevels;
      } else {
        currentLevel.value = savedLevel;
      }

      // Calculate how many levels have been completed
      levelsCompleted.value = currentLevel.value - 1;

      if (kDebugMode) {
        print('Loaded Number Game: Level ${currentLevel.value}');
      }
    }
  }

  void _startGame() {
    // Initialize numbers for the level
    numbers.clear();
    selectedNumbers.clear();
    showHint.value = false;
    hideWrongAnimation();
    hideCorrectAnimation();

    // Generate random numbers based on current level
    final count = 4 + (currentLevel.value - 1) * 2;
    final tempNumbers = <int>[];
    for (int i = 1; i <= count; i++) {
      tempNumbers.add(i);
    }

    tempNumbers.shuffle();
    numbers.assignAll(tempNumbers);

    targetNumber.value = 1;
    progress.value = 0.0;
  }

  void _saveGameState() {
    final user = _storageService.getUser();
    if (user != null) {
      // Save current level to storage
      user.gameProgress['numbers_level'] = currentLevel.value;

      // Calculate overall progress percentage
      int overallProgress =
          ((currentLevel.value - 1) / maxLevels * 100).toInt();
      user.updateGameProgress('numbers', overallProgress);

      // Save to storage
      _storageService.updateUser(user);

      if (kDebugMode) {
        print(
            'Saved Number Game: Level ${currentLevel.value}, Progress $overallProgress%');
      }
    }
  }

  void _startTimer() {
    _gameTimer?.cancel();
    timeRemaining.value = 60;

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
      } else {
        timer.cancel();
        showWrongAnimation.value = true;
        Future.delayed(const Duration(seconds: 2), () {
          _levelComplete();
        });
      }
    });
  }

  void selectNumber(int number) {
    if (selectedNumbers.contains(number)) return;

    if (showHint.value && number == targetNumber.value) {
      showHint.value = false;
    }

    if (number == targetNumber.value) {
      // Correct number
      selectedNumbers.add(number);
      targetNumber.value++;
      score.value += 10;

      // Show correct animation
      showCorrectAnimation.value = true;

      progress.value = selectedNumbers.length / numbers.length;

      if (selectedNumbers.length == numbers.length) {
        _levelComplete();
      }
    } else {
      // Wrong number
      score.value -= 5;
      if (score.value < 0) score.value = 0;

      // Show wrong animation
      showWrongAnimation.value = true;
    }
  }

  bool isCorrectNumberOrder(int number) {
    if (!selectedNumbers.contains(number)) return false;
    return number == selectedNumbers.indexOf(number) + 1;
  }

  void _levelComplete() {
    _gameTimer?.cancel();
    _hintTimer?.cancel();

    // Add bonus stars for completing level
    int levelBonus = 50;
    score.value += levelBonus;
    totalStarsEarned.value = score.value;
    levelsCompleted.value++;

    showCorrectAnimation.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      if (currentLevel.value < maxLevels) {
        // Save current state before advancing
        _saveGameState();

        // Advance to next level
        currentLevel.value++;

        // Start next level
        _startGame();
        _startTimer();
      } else {
        finishGame();
      }
    });
  }

  void completeLevel() {
    if (selectedNumbers.length == numbers.length) {
      _levelComplete();
    } else {
      showWrongAnimation.value = true;
    }
  }

  void finishGame() {
    // Save stars and progress to storage
    final user = _storageService.getUser();
    if (user != null) {
      // Add earned stars
      user.addStars(totalStarsEarned.value);

      // Mark game as completed (100%)
      user.updateGameProgress('numbers', 100);
      user.gameProgress['numbers_level'] = maxLevels;

      // Save to storage
      _storageService.updateUser(user);
    }

    Get.back();

    Get.snackbar(
      '🎊 Number Game Complete!',
      'You earned ${totalStarsEarned.value} stars! All levels completed!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4ECDC4),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void provideHint() {
    if (score.value >= 20 && !showHint.value) {
      score.value -= 20;
      showHint.value = true;

      _hintTimer?.cancel();
      _hintTimer = Timer(const Duration(seconds: 10), () {
        showHint.value = false;
      });
    } else if (showHint.value) {
      showCorrectAnimation.value = true;
      Future.delayed(const Duration(milliseconds: 800), () {
        hideCorrectAnimation();
      });
    } else {
      showWrongAnimation.value = true;
    }
  }

  void resetGame() {
    selectedNumbers.clear();
    targetNumber.value = 1;
    progress.value = 0.0;
    showHint.value = false;
    hideWrongAnimation();
    hideCorrectAnimation();
    _hintTimer?.cancel();
    _startGame();
    _startTimer();
  }

  // Animation control methods
  void hideWrongAnimation() {
    showWrongAnimation.value = false;
  }

  void hideCorrectAnimation() {
    showCorrectAnimation.value = false;
  }

  void quitGame() {
    // Save progress when quitting
    final user = _storageService.getUser();
    if (user != null) {
      // Save partial stars
      user.addStars(score.value);

      // Save current level
      _saveGameState();

      _storageService.updateUser(user);
    }

    _gameTimer?.cancel();
    _hintTimer?.cancel();
    Get.back();
  }

  @override
  void onClose() {
    // Save progress when controller closes
    final user = _storageService.getUser();
    if (user != null && currentLevel.value > 1) {
      _saveGameState();
      _storageService.updateUser(user);
    }

    _gameTimer?.cancel();
    _hintTimer?.cancel();
    super.onClose();
  }
}
