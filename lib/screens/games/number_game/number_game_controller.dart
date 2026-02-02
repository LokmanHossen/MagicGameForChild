import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_learning_world/services/storage_service.dart';

class NumberGameController extends GetxController {
  final StorageService _storageService = StorageService();

  final RxInt score = 0.obs;
  final RxInt currentLevel = 1.obs;
  final RxInt timeRemaining = 60.obs;
  final RxInt targetNumber = 1.obs;
  final RxList<int> selectedNumbers = <int>[].obs;
  final RxList<int> numbers = <int>[].obs;
  final RxDouble progress = 0.0.obs;
  final RxBool showHint = false.obs;

  final RxBool showWrongAnimation = false.obs;
  final RxBool showCorrectAnimation = false.obs;

  final RxInt totalStarsEarned = 0.obs;
  final RxInt levelsCompleted = 0.obs;

  final int maxLevels = 10;

  Timer? _gameTimer;
  Timer? _hintTimer;

  @override
  void onInit() {
    super.onInit();
    _loadGameState();
    _startGame();
    _startTimer();
  }

  void _loadGameState() {
    final user = _storageService.getUser();
    if (user != null) {
      final savedLevel = user.gameProgress['numbers_level'] ?? 1;

      if (savedLevel > maxLevels) {
        currentLevel.value = maxLevels;
      } else {
        currentLevel.value = savedLevel;
      }

      levelsCompleted.value = currentLevel.value - 1;

      if (kDebugMode) {
        print('Loaded Number Game: Level ${currentLevel.value}');
      }
    }
  }

  void _startGame() {
    numbers.clear();
    selectedNumbers.clear();
    showHint.value = false;
    hideWrongAnimation();
    hideCorrectAnimation();

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
      user.gameProgress['numbers_level'] = currentLevel.value;

      int overallProgress =
          ((currentLevel.value - 1) / maxLevels * 100).toInt();
      user.updateGameProgress('numbers', overallProgress);

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
      selectedNumbers.add(number);
      targetNumber.value++;
      score.value += 10;

      showCorrectAnimation.value = true;

      progress.value = selectedNumbers.length / numbers.length;

      if (selectedNumbers.length == numbers.length) {
        _levelComplete();
      }
    } else {
      score.value -= 5;
      if (score.value < 0) score.value = 0;
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

    int levelBonus = 50;
    score.value += levelBonus;
    totalStarsEarned.value = score.value;
    levelsCompleted.value++;

    showCorrectAnimation.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      if (currentLevel.value < maxLevels) {
        _saveGameState();

        currentLevel.value++;

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
    final user = _storageService.getUser();
    if (user != null) {
      user.addStars(totalStarsEarned.value);

      user.updateGameProgress('numbers', 100);
      user.gameProgress['numbers_level'] = maxLevels;

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
    if (score.value >= 0 && !showHint.value) {
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

  void hideWrongAnimation() {
    showWrongAnimation.value = false;
  }

  void hideCorrectAnimation() {
    showCorrectAnimation.value = false;
  }

  void quitGame() {
    final user = _storageService.getUser();
    if (user != null) {
      user.addStars(score.value);

      _saveGameState();

      _storageService.updateUser(user);
    }

    _gameTimer?.cancel();
    _hintTimer?.cancel();
    Get.back();
  }

  @override
  void onClose() {
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
