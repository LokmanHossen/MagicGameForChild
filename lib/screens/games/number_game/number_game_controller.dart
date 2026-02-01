// import 'dart:async';
// import 'package:flutter/material.dart';
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
//     showHint.value = false; // Reset hint when starting new level

//     // Generate random numbers
//     final count = 4 + (currentLevel.value - 1) * 2; // More numbers per level
//     final tempNumbers = <int>[];
//     for (int i = 1; i <= count; i++) {
//       tempNumbers.add(i);
//     }

//     // Shuffle numbers
//     tempNumbers.shuffle();
//     numbers.assignAll(tempNumbers);

//     // Reset target number
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
//         // Time's up!
//         timer.cancel();
//         Get.snackbar(
//           'Time\'s Up! ⏰',
//           'Level ${currentLevel.value} completed!',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//         );
//         _levelComplete();
//       }
//     });
//   }

//   void selectNumber(int number) {
//     if (selectedNumbers.contains(number)) return;

//     // If hint was active and correct number tapped, turn off hint
//     if (showHint.value && number == targetNumber.value) {
//       showHint.value = false;
//     }

//     if (number == targetNumber.value) {
//       // Correct number in sequence
//       selectedNumbers.add(number);
//       targetNumber.value++;
//       score.value += 10;

//       // Update progress
//       progress.value = selectedNumbers.length / numbers.length;

//       // Check if level complete
//       if (selectedNumbers.length == numbers.length) {
//         _levelComplete();
//       }
//     } else {
//       // Wrong number - penalty
//       score.value -= 5;
//       if (score.value < 0) score.value = 0;

//       // Show error feedback
//       Get.snackbar(
//         'Oops!',
//         'Wrong number! Tap $targetNumber first',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 1),
//       );
//     }
//   }

//   bool isCorrectNumberOrder(int number) {
//     if (!selectedNumbers.contains(number)) return false;
//     return number == selectedNumbers.indexOf(number) + 1;
//   }

//   void _levelComplete() {
//     _gameTimer?.cancel();
//     _hintTimer?.cancel();
//     score.value += 50; // Bonus for completing level
//     Get.snackbar(
//       'Level Complete! 🎉',
//       'Great job! You earned 50 bonus points!',
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 2),
//     );

//     // Auto-advance after delay
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
//       Get.snackbar(
//         'Not Finished Yet!',
//         'Complete all numbers first!',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//       );
//     }
//   }

//   void provideHint() {
//     if (score.value >= 20 && !showHint.value) {
//       score.value -= 20; // Cost for hint
//       showHint.value = true;

//       // Automatically turn off hint after 10 seconds
//       _hintTimer?.cancel();
//       _hintTimer = Timer(const Duration(seconds: 10), () {
//         showHint.value = false;
//       });

//       Get.snackbar(
//         'Hint Activated! 💡',
//         'Look for the glowing number!',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.amber,
//         colorText: Colors.black,
//       );
//     } else if (showHint.value) {
//       // Hint already active
//       Get.snackbar(
//         'Hint Already Active',
//         'Find the glowing number!',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.amber,
//         colorText: Colors.black,
//       );
//     } else {
//       Get.snackbar(
//         'Not Enough Points!',
//         'You need at least 20 points for a hint',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   void resetGame() {
//     selectedNumbers.clear();
//     targetNumber.value = 1;
//     progress.value = 0.0;
//     showHint.value = false;
//     _hintTimer?.cancel();
//     _startGame();
//     _startTimer();
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
import 'package:get/get.dart';

class NumberGameController extends GetxController {
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

  Timer? _gameTimer;
  Timer? _hintTimer;

  @override
  void onInit() {
    super.onInit();
    _startGame();
    _startTimer();
  }

  void _startGame() {
    // Initialize numbers for the level
    numbers.clear();
    selectedNumbers.clear();
    showHint.value = false;
    hideWrongAnimation();
    hideCorrectAnimation();

    // Generate random numbers
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
    score.value += 50;

    showCorrectAnimation.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      currentLevel.value++;
      _startGame();
      _startTimer();
    });
  }

  void completeLevel() {
    if (selectedNumbers.length == numbers.length) {
      _levelComplete();
    } else {
      showWrongAnimation.value = true;
    }
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
      // Hint already active - show a quick feedback
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
    _gameTimer?.cancel();
    _hintTimer?.cancel();
    Get.back();
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    _hintTimer?.cancel();
    super.onClose();
  }
}
