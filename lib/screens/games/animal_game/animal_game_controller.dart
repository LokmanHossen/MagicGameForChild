import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:magic_learning_world/services/storage_service.dart';

class AnimalGameController extends GetxController {
  final StorageService _storageService = StorageService();
  final FlutterTts flutterTts = FlutterTts();

  final RxString currentAnimal = ''.obs;
  final RxString currentQuestionSound = '🔊'.obs;
  final RxList<Map<String, dynamic>> options = <Map<String, dynamic>>[].obs;
  final RxString correctAnswer = ''.obs;
  final RxInt score = 0.obs;
  final RxInt currentQuestion = 0.obs;
  final RxBool isAnswered = false.obs;
  final RxString selectedAnswer = ''.obs;
  final RxString gameMode = 'sound'.obs;
  final RxBool isPlayingSound = false.obs;

  // Animation States
  final RxBool showCorrectAnimation = false.obs;
  final RxBool showWrongAnimation = false.obs;

  final int totalQuestions = 10;

  final Map<String, Map<String, dynamic>> animalData = {
    '🐶': {
      'name': 'Dog',
      'sound': 'Woof Woof',
      'soundText': 'Woof Woof!',
      'home': '🏠',
      'homeName': 'House',
    },
    '🐱': {
      'name': 'Cat',
      'sound': 'Meow',
      'soundText': 'Meow!',
      'home': '🛏️',
      'homeName': 'Bed',
    },
    '🐮': {
      'name': 'Cow',
      'sound': 'Moo',
      'soundText': 'Moo!',
      'home': '🏞️',
      'homeName': 'Farm',
    },
    '🐷': {
      'name': 'Pig',
      'sound': 'Oink Oink',
      'soundText': 'Oink Oink!',
      'home': '🐖',
      'homeName': 'Pig Pen',
    },
    '🐔': {
      'name': 'Chicken',
      'sound': 'Cluck Cluck',
      'soundText': 'Cluck Cluck!',
      'home': '🐣',
      'homeName': 'Coop',
    },
    '🦁': {
      'name': 'Lion',
      'sound': 'Roar',
      'soundText': 'Roar!',
      'home': '🌍',
      'homeName': 'Savanna',
    },
    '🐘': {
      'name': 'Elephant',
      'sound': 'Trumpet',
      'soundText': 'Trumpet!',
      'home': '🌳',
      'homeName': 'Jungle',
    },
    '🐼': {
      'name': 'Panda',
      'sound': 'Squeak',
      'soundText': 'Squeak!',
      'home': '🎋',
      'homeName': 'Bamboo Forest',
    },
    '🐸': {
      'name': 'Frog',
      'sound': 'Ribbit',
      'soundText': 'Ribbit!',
      'home': '🌊',
      'homeName': 'Pond',
    },
    '🐦': {
      'name': 'Bird',
      'sound': 'Tweet',
      'soundText': 'Tweet!',
      'home': '🌿',
      'homeName': 'Nest',
    },
    '🐝': {
      'name': 'Bee',
      'sound': 'Buzz',
      'soundText': 'Buzz!',
      'home': '🐝',
      'homeName': 'Hive',
    },
    '🐬': {
      'name': 'Dolphin',
      'sound': 'Click',
      'soundText': 'Click!',
      'home': '🌊',
      'homeName': 'Ocean',
    },
    '🐢': {
      'name': 'Turtle',
      'sound': '...',
      'soundText': '...',
      'home': '🐢',
      'homeName': 'Shell',
    },
    '🦊': {
      'name': 'Fox',
      'sound': 'Yap',
      'soundText': 'Yap!',
      'home': '🦊',
      'homeName': 'Den',
    },
    '🦉': {
      'name': 'Owl',
      'sound': 'Hoot',
      'soundText': 'Hoot!',
      'home': '🌲',
      'homeName': 'Tree',
    },
    '🦒': {
      'name': 'Giraffe',
      'sound': 'Hum',
      'soundText': 'Hum!',
      'home': '🌍',
      'homeName': 'Savanna',
    },
    '🦘': {
      'name': 'Kangaroo',
      'sound': 'Chortle',
      'soundText': 'Chortle!',
      'home': '🌾',
      'homeName': 'Outback',
    },
    '🐧': {
      'name': 'Penguin',
      'sound': 'Honk',
      'soundText': 'Honk!',
      'home': '❄️',
      'homeName': 'Ice',
    },
    '🦈': {
      'name': 'Shark',
      'sound': '...',
      'soundText': '...',
      'home': '🌊',
      'homeName': 'Sea',
    },
    '🦓': {
      'name': 'Zebra',
      'sound': 'Bray',
      'soundText': 'Bray!',
      'home': '🌍',
      'homeName': 'Grasslands',
    },
  };

  @override
  void onInit() {
    super.onInit();
    _initializeTts();
    generateQuestion();
  }

  Future<void> _initializeTts() async {
    // Configure TTS settings
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.5); // Slower for children
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    // Set completion handler
    flutterTts.setCompletionHandler(() {
      isPlayingSound.value = false;
    });

    // Set error handler
    flutterTts.setErrorHandler((msg) {
      if (kDebugMode) {
        print('TTS Error: $msg');
      }
      isPlayingSound.value = false;
    });
  }

  void generateQuestion() {
    // Stop any playing sound
    if (isPlayingSound.value) {
      flutterTts.stop();
      isPlayingSound.value = false;
    }

    // Alternate between sound and home modes
    final modes = ['sound', 'home'];
    gameMode.value = modes[currentQuestion.value % 2];

    // Get random animal
    final animals = animalData.keys.toList();
    animals.shuffle();
    final animal = animals.first;
    currentAnimal.value = animal;

    final animalInfo = animalData[animal]!;

    if (gameMode.value == 'sound') {
      // Sound mode: Find animal by sound
      currentQuestionSound.value = animalInfo['soundText']!;
      correctAnswer.value = animal;
    } else {
      // Home mode: Find animal's home
      correctAnswer.value = animalInfo['home']!;
    }

    // Generate wrong answers
    final wrongOptions = <Map<String, String>>[];
    for (var a in animals.skip(1)) {
      if (animalData[a] != null) {
        final info = animalData[a]!;
        if (gameMode.value == 'sound') {
          wrongOptions.add({
            'emoji': a,
            'name': info['name']!,
          });
        } else {
          wrongOptions.add({
            'emoji': info['home']!,
            'name': info['homeName']!,
          });
        }
      }
    }

    // Combine and shuffle
    final allOptions = [
      gameMode.value == 'sound'
          ? {'emoji': animal, 'name': animalInfo['name']!}
          : {'emoji': animalInfo['home']!, 'name': animalInfo['homeName']!},
      ...wrongOptions.take(3),
    ];
    allOptions.shuffle();

    options.value = allOptions;
    isAnswered.value = false;
    selectedAnswer.value = '';
    hideCorrectAnimation();
    hideWrongAnimation();
  }

  Future<void> playAnimalSound() async {
    if (gameMode.value != 'sound' || isAnswered.value) return;

    if (isPlayingSound.value) {
      await flutterTts.stop();
      isPlayingSound.value = false;
    } else {
      final animalInfo = animalData[currentAnimal.value];
      if (animalInfo != null) {
        final soundText = animalInfo['sound'] as String;
        if (soundText != '...') {
          try {
            isPlayingSound.value = true;
            await flutterTts.speak(soundText);
          } catch (e) {
            if (kDebugMode) {
              print('TTS Error: $e');
            }
            isPlayingSound.value = false;
            Get.snackbar(
              'Sound Error',
              'Cannot play sound right now',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          }
        }
      }
    }
  }

  void checkAnswer(String emoji) {
    if (isAnswered.value) return;

    selectedAnswer.value = emoji;
    isAnswered.value = true;

    // Stop sound if playing
    if (isPlayingSound.value) {
      flutterTts.stop();
      isPlayingSound.value = false;
    }

    if (emoji == correctAnswer.value) {
      score.value += 10;
      showCorrectAnimation.value = true;
    } else {
      showWrongAnimation.value = true;
    }

    Future.delayed(const Duration(seconds: 1), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (currentQuestion.value < totalQuestions - 1) {
      currentQuestion.value++;
      generateQuestion();
    } else {
      finishGame();
    }
  }

  void finishGame() {
    // Stop any playing sound
    if (isPlayingSound.value) {
      flutterTts.stop();
      isPlayingSound.value = false;
    }

    final user = _storageService.getUser();
    if (user != null) {
      user.addStars(score.value);
      user.updateGameProgress(
        'animals',
        ((currentQuestion.value + 1) / totalQuestions * 100).toInt(),
      );
      _storageService.updateUser(user);
    }

    Get.back();

    showCorrectAnimation.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      hideCorrectAnimation();
    });
  }

  // Animation control methods
  void hideCorrectAnimation() {
    showCorrectAnimation.value = false;
  }

  void hideWrongAnimation() {
    showWrongAnimation.value = false;
  }

  void quitGame() {
    // Stop any playing sound
    if (isPlayingSound.value) {
      flutterTts.stop();
      isPlayingSound.value = false;
    }

    // Save partial progress if user quits
    if (currentQuestion.value > 0 || score.value > 0) {
      final user = _storageService.getUser();
      if (user != null) {
        user.addStars(score.value);
        int partialProgress =
            ((currentQuestion.value) / totalQuestions * 100).toInt();
        final currentProgress = user.gameProgress['animals'] ?? 0;
        if (partialProgress > currentProgress) {
          user.updateGameProgress('animals', partialProgress);
        }
        _storageService.updateUser(user);
      }
    }

    Get.back();
  }

  @override
  void onClose() {
    flutterTts.stop();

    // Use empty functions instead of null
    flutterTts.setCompletionHandler(() {});
    flutterTts.setErrorHandler((message) {});
    flutterTts.setCancelHandler(() {});

    super.onClose();
  }
}
