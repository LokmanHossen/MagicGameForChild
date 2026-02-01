import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_learning_world/services/storage_service.dart';

class ColorGameController extends GetxController {
  final StorageService _storageService = StorageService();

  // Game State
  final RxInt score = 0.obs;
  final RxInt currentQuestion = 0.obs;
  final RxBool isAnswered = false.obs;
  final RxString selectedAnswer = ''.obs;
  final RxString gameMode = 'match'.obs; // 'match', 'identify', 'mix'
  final RxList<Map<String, String>> options = <Map<String, String>>[].obs;
  final RxList<String> colorOptions = <String>[].obs;
  final RxList<Color> mixOptions = <Color>[].obs;
  final RxList<Color> selectedMixColors = <Color>[].obs;
  final RxList<Color> correctMixColors = <Color>[].obs;
  final RxList<Color> mixColors = <Color>[Colors.red, Colors.blue].obs;
  final Rx<Color> currentColor = Colors.red.obs;

  // Animation States
  final RxBool showCorrectAnimation = false.obs;
  final RxBool showWrongAnimation = false.obs;

  final int totalQuestions = 12; // 4 questions per mode

  // Color database - Store Color objects directly
  final List<Map<String, dynamic>> colors = [
    {
      'color': Colors.red,
      'name': 'Red',
      'objects': [
        {'emoji': '🍎', 'name': 'Apple'},
        {'emoji': '🚗', 'name': 'Car'},
        {'emoji': '❤️', 'name': 'Heart'},
        {'emoji': '🍓', 'name': 'Strawberry'},
      ],
    },
    {
      'color': Colors.blue,
      'name': 'Blue',
      'objects': [
        {'emoji': '🌊', 'name': 'Ocean'},
        {'emoji': '💙', 'name': 'Blue Heart'},
        {'emoji': '🦋', 'name': 'Butterfly'},
        {'emoji': '🔵', 'name': 'Blue Circle'},
      ],
    },
    {
      'color': Colors.green,
      'name': 'Green',
      'objects': [
        {'emoji': '🌳', 'name': 'Tree'},
        {'emoji': '🐸', 'name': 'Frog'},
        {'emoji': '🥦', 'name': 'Broccoli'},
        {'emoji': '💚', 'name': 'Green Heart'},
      ],
    },
    {
      'color': Colors.yellow,
      'name': 'Yellow',
      'objects': [
        {'emoji': '☀️', 'name': 'Sun'},
        {'emoji': '🍌', 'name': 'Banana'},
        {'emoji': '⭐', 'name': 'Star'},
        {'emoji': '💛', 'name': 'Yellow Heart'},
      ],
    },
    {
      'color': Colors.orange,
      'name': 'Orange',
      'objects': [
        {'emoji': '🍊', 'name': 'Orange'},
        {'emoji': '🎃', 'name': 'Pumpkin'},
        {'emoji': '🦊', 'name': 'Fox'},
        {'emoji': '🧡', 'name': 'Orange Heart'},
      ],
    },
    {
      'color': Colors.purple,
      'name': 'Purple',
      'objects': [
        {'emoji': '🍇', 'name': 'Grapes'},
        {'emoji': '👾', 'name': 'Alien'},
        {'emoji': '💜', 'name': 'Purple Heart'},
        {'emoji': '🟣', 'name': 'Purple Circle'},
      ],
    },
    {
      'color': Colors.pink,
      'name': 'Pink',
      'objects': [
        {'emoji': '🌸', 'name': 'Flower'},
        {'emoji': '🐷', 'name': 'Pig'},
        {'emoji': '💖', 'name': 'Sparkling Heart'},
        {'emoji': '🩷', 'name': 'Pink Heart'},
      ],
    },
    {
      'color': Colors.brown,
      'name': 'Brown',
      'objects': [
        {'emoji': '🐻', 'name': 'Bear'},
        {'emoji': '🍫', 'name': 'Chocolate'},
        {'emoji': '🌰', 'name': 'Chestnut'},
        {'emoji': '🪵', 'name': 'Wood'},
      ],
    },
  ];

  // Color mixing combinations
  final Map<String, List<Color>> colorMixes = {
    'Orange': [Colors.red, Colors.yellow],
    'Green': [Colors.blue, Colors.yellow],
    'Purple': [Colors.red, Colors.blue],
    'Brown': [Colors.red, Colors.green],
    'Pink': [Colors.red, Colors.white],
  };

  @override
  void onInit() {
    super.onInit();
    generateQuestion();
  }

  String getModeTitle() {
    switch (gameMode.value) {
      case 'match':
        return 'Match';
      case 'identify':
        return 'Identify';
      case 'mix':
        return 'Mix';
      default:
        return 'Color';
    }
  }

  void generateQuestion() {
    // Cycle through game modes: 0-3 match, 4-7 identify, 8-11 mix
    if (currentQuestion.value < 4) {
      gameMode.value = 'match';
      generateMatchQuestion();
    } else if (currentQuestion.value < 8) {
      gameMode.value = 'identify';
      generateIdentifyQuestion();
    } else {
      gameMode.value = 'mix';
      generateMixQuestion();
    }

    isAnswered.value = false;
    selectedAnswer.value = '';
    selectedMixColors.clear();
    hideCorrectAnimation();
    hideWrongAnimation();
  }

  void generateMatchQuestion() {
    // Get random color
    colors.shuffle();
    final colorData = colors.first;
    currentColor.value = colorData['color'] as Color;

    // Get correct object
    final objects = List<Map<String, dynamic>>.from(colorData['objects']);
    objects.shuffle();
    final correctObject = Map<String, String>.from(objects.first);

    // Add color info to correct object
    correctObject['correctColor'] = colorData['name'] as String;

    // Get wrong objects from other colors
    final wrongObjects = <Map<String, String>>[];
    for (var otherColor in colors.skip(1)) {
      final wrongColorObjects =
          List<Map<String, dynamic>>.from(otherColor['objects']);
      wrongColorObjects.shuffle();
      final wrongObject = Map<String, String>.from(wrongColorObjects.first);
      wrongObject['correctColor'] = otherColor['name'] as String;
      wrongObjects.add(wrongObject);
    }

    // Combine and shuffle options
    final allOptions = [correctObject, ...wrongObjects.take(3)];
    allOptions.shuffle();

    options.value = allOptions;

    print('Match Question:');
    print('Current Color: ${colorData['name']}');
    print(
        'Correct Object: ${correctObject['emoji']} - ${correctObject['name']}');
    print('Options:');
    for (var opt in allOptions) {
      print('  ${opt['emoji']} - ${opt['name']} (${opt['correctColor']})');
    }
  }

  void generateIdentifyQuestion() {
    // Get random color
    colors.shuffle();
    final colorData = colors.first;
    currentColor.value = colorData['color'] as Color;

    // Get correct color name
    final correctName = colorData['name'] as String;

    // Get wrong color names
    final wrongNames = <String>[];
    for (var color in colors.skip(1)) {
      wrongNames.add(color['name'] as String);
    }

    // Combine and shuffle options
    final allOptions = [correctName, ...wrongNames.take(3)];
    allOptions.shuffle();

    colorOptions.value = allOptions;

    print('Identify Question:');
    print('Current Color: ${colorData['name']}');
    print('Options: $allOptions');
  }

  void generateMixQuestion() {
    // Get a mixable color
    final mixableColors = colorMixes.keys.toList();
    mixableColors.shuffle();
    final targetColorName = mixableColors.first;

    // Find the color object
    final targetColorData = colors.firstWhere(
      (c) => c['name'] == targetColorName,
      orElse: () => colors.first,
    );

    currentColor.value = targetColorData['color'] as Color;
    correctMixColors.value =
        colorMixes[targetColorName] ?? [Colors.red, Colors.blue];
    mixColors[0] = correctMixColors[0];
    mixColors[1] = correctMixColors[1];

    // Generate mix options (6 colors including the correct ones)
    final allColors = colors.map((c) => c['color'] as Color).toList();
    allColors.shuffle();

    // Ensure correct colors are included
    final optionColors = <Color>[...correctMixColors];
    for (var color in allColors) {
      if (!correctMixColors.contains(color) && optionColors.length < 6) {
        optionColors.add(color);
      }
    }

    mixOptions.value = optionColors;

    print('Mix Question:');
    print('Target Color: $targetColorName');
    print(
        'Correct Mix Colors: ${correctMixColors.map((c) => getColorName(c)).toList()}');
  }

  void checkAnswer(String answer) {
    if (isAnswered.value) return;

    selectedAnswer.value = answer;
    isAnswered.value = true;

    bool isCorrect = false;

    if (gameMode.value == 'match') {
      // Find the selected option
      final selectedOption = options.firstWhere(
        (opt) => opt['emoji'] == answer,
        orElse: () => {},
      );

      // Get the current color name
      final currentColorName = getColorName(currentColor.value);

      // Check if the selected object's color matches current color
      isCorrect = selectedOption['correctColor'] == currentColorName;

      print('Match Answer Check:');
      print(
          '  Selected: ${selectedOption['emoji']} - ${selectedOption['name']}');
      print('  Selected Color: ${selectedOption['correctColor']}');
      print('  Current Color: $currentColorName');
      print('  Is Correct: $isCorrect');
    } else if (gameMode.value == 'identify') {
      isCorrect = answer == getColorName(currentColor.value);

      print('Identify Answer Check:');
      print('  Selected: $answer');
      print('  Current Color: ${getColorName(currentColor.value)}');
      print('  Is Correct: $isCorrect');
    }

    if (isCorrect) {
      score.value += 10;
      showCorrectAnimation.value = true;
      print('Correct! Score: ${score.value}');
    } else {
      showWrongAnimation.value = true;
      print('Wrong! Score: ${score.value}');
    }

    Future.delayed(const Duration(seconds: 1), () {
      nextQuestion();
    });
  }

  void selectMixColor(Color color) {
    if (isAnswered.value || selectedMixColors.length >= 2) return;

    if (selectedMixColors.contains(color)) {
      selectedMixColors.remove(color);
    } else {
      selectedMixColors.add(color);
    }
    selectedMixColors.refresh();

    print(
        'Selected Mix Colors: ${selectedMixColors.map((c) => getColorName(c)).toList()}');
  }

  void checkMixAnswer() {
    if (isAnswered.value || selectedMixColors.length != 2) return;

    isAnswered.value = true;

    // Check if selected colors match the correct mix colors (order doesn't matter)
    final containsAll = selectedMixColors
        .every((color) => correctMixColors.any((c) => c.value == color.value));

    if (containsAll && selectedMixColors.length == 2) {
      score.value += 15; // Extra points for mixing!
      showCorrectAnimation.value = true;
      print('Mix Correct! Score: ${score.value}');
    } else {
      showWrongAnimation.value = true;
      print(
          'Mix Wrong! Selected: ${selectedMixColors.map((c) => getColorName(c)).toList()}');
      print(
          'Mix Wrong! Expected: ${correctMixColors.map((c) => getColorName(c)).toList()}');
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
    final user = _storageService.getUser();
    if (user != null) {
      user.addStars(score.value);
      user.updateGameProgress(
        'colors',
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

  // Helper methods
  String getColorName(Color color) {
    try {
      final colorData = colors.firstWhere(
        (c) => (c['color'] as Color).value == color.value,
      );
      return colorData['name'] as String;
    } catch (e) {
      // For white color in mixing
      if (color == Colors.white) return 'White';
      return 'Unknown';
    }
  }

  // Animation control methods
  void hideCorrectAnimation() {
    showCorrectAnimation.value = false;
  }

  void hideWrongAnimation() {
    showWrongAnimation.value = false;
  }

  void quitGame() {
    // Save partial progress if user quits
    if (currentQuestion.value > 0 || score.value > 0) {
      final user = _storageService.getUser();
      if (user != null) {
        user.addStars(score.value);
        int partialProgress =
            ((currentQuestion.value) / totalQuestions * 100).toInt();
        final currentProgress = user.gameProgress['colors'] ?? 0;
        if (partialProgress > currentProgress) {
          user.updateGameProgress('colors', partialProgress);
        }
        _storageService.updateUser(user);
      }
    }

    Get.back();
  }
}
