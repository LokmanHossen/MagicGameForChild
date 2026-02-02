import 'package:get/get.dart';
import 'package:magic_learning_world/services/storage_service.dart';

class PuzzleGameController extends GetxController {
  final StorageService _storageService = StorageService();

  // Game State
  final RxInt score = 0.obs;
  final RxInt currentPuzzle = 0.obs;
  final RxBool isAnswered = false.obs;
  final RxString selectedAnswer = ''.obs;
  final RxString correctAnswer = ''.obs;
  final RxString gameMode = 'shape'.obs; // 'shape', 'pattern', 'shadow'

  // Animation States
  final RxBool showCorrectAnimation = false.obs;
  final RxBool showWrongAnimation = false.obs;

  // Shape Puzzle Data
  final RxString targetShape = '⬜'.obs;
  final RxList<String> shapePieces = <String>[].obs;

  // Pattern Puzzle Data
  final RxList<String> currentPattern = <String>[].obs;
  final RxList<String> patternOptions = <String>[].obs;

  // Shadow Puzzle Data
  final RxString targetShadow = '⬛'.obs;
  final RxList<String> shadowOptions = <String>[].obs;

  final int totalPuzzles = 12; // 4 puzzles per mode

  // Shape database
  final List<Map<String, dynamic>> shapePuzzles = [
    {
      'target': '🔺',
      'name': 'Triangle',
      'pieces': ['🔺', '⬜', '🔶', '🔷', '⭐', '💠'],
      'correct': '🔺',
    },
    {
      'target': '⬜',
      'name': 'Square',
      'pieces': ['🔺', '⬜', '🔶', '🔷', '⭐', '💠'],
      'correct': '⬜',
    },
    {
      'target': '🔵',
      'name': 'Circle',
      'pieces': ['🔺', '⬜', '🔵', '🔷', '⭐', '💠'],
      'correct': '🔵',
    },
    {
      'target': '⭐',
      'name': 'Star',
      'pieces': ['🔺', '⬜', '🔶', '🔷', '⭐', '💠'],
      'correct': '⭐',
    },
    {
      'target': '💠',
      'name': 'Diamond',
      'pieces': ['🔺', '⬜', '🔶', '🔷', '💠', '🟦'],
      'correct': '💠',
    },
    {
      'target': '🟥',
      'name': 'Red Square',
      'pieces': ['🟥', '🟩', '🟦', '🟨', '🟪', '🟧'],
      'correct': '🟥',
    },
  ];

  // Pattern database
  final List<Map<String, dynamic>> patternPuzzles = [
    {
      'pattern': ['🍎', '🍌', '🍎'],
      'options': ['🍌', '🍎', '🍓', '🍇', '🍊', '🍒'],
      'correct': '🍌',
    },
    {
      'pattern': ['🔴', '🟡', '🔴'],
      'options': ['🟡', '🔴', '🟢', '🔵', '🟣', '🟠'],
      'correct': '🟡',
    },
    {
      'pattern': ['🐱', '🐶', '🐱'],
      'options': ['🐶', '🐱', '🐰', '🐻', '🐼', '🦊'],
      'correct': '🐶',
    },
    {
      'pattern': ['🔺', '🔺', '⬜'],
      'options': ['🔺', '⬜', '🔶', '🔷', '⭐', '💠'],
      'correct': '🔺',
    },
    {
      'pattern': ['1', '2', '3'],
      'options': ['4', '1', '2', '3', '5', '6'],
      'correct': '4',
    },
    {
      'pattern': ['A', 'B', 'C'],
      'options': ['D', 'A', 'B', 'C', 'E', 'F'],
      'correct': 'D',
    },
  ];

  // Shadow database
  final List<Map<String, dynamic>> shadowPuzzles = [
    {
      'shadow': '🐱',
      'name': 'Cat Shadow',
      'options': ['🐱', '🐶', '🐰', '🐻', '🐼', '🦊'],
      'correct': '🐱',
    },
    {
      'shadow': '🏠',
      'name': 'House Shadow',
      'options': ['🏠', '🌳', '🚗', '🌞', '☁️', '🌺'],
      'correct': '🏠',
    },
    {
      'shadow': '🚗',
      'name': 'Car Shadow',
      'options': ['🚗', '✈️', '🚂', '🚢', '🚲', '🛵'],
      'correct': '🚗',
    },
    {
      'shadow': '🌳',
      'name': 'Tree Shadow',
      'options': ['🌳', '🌺', '🌻', '🍎', '🍌', '🍇'],
      'correct': '🌳',
    },
    {
      'shadow': '⭐',
      'name': 'Star Shadow',
      'options': ['⭐', '🌙', '☀️', '🌈', '☁️', '⚡'],
      'correct': '⭐',
    },
    {
      'shadow': '🍎',
      'name': 'Apple Shadow',
      'options': ['🍎', '🍌', '🍇', '🍓', '🍊', '🍒'],
      'correct': '🍎',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    generatePuzzle();
  }

  void generatePuzzle() {
    // Cycle through game modes: 0-3 shape, 4-7 pattern, 8-11 shadow
    if (currentPuzzle.value < 4) {
      gameMode.value = 'shape';
      generateShapePuzzle();
    } else if (currentPuzzle.value < 8) {
      gameMode.value = 'pattern';
      generatePatternPuzzle();
    } else {
      gameMode.value = 'shadow';
      generateShadowPuzzle();
    }

    isAnswered.value = false;
    selectedAnswer.value = '';
    hideCorrectAnimation();
    hideWrongAnimation();
  }

  void generateShapePuzzle() {
    // Get random shape puzzle
    shapePuzzles.shuffle();
    final puzzle = shapePuzzles.first;

    targetShape.value = puzzle['target'];
    correctAnswer.value = puzzle['correct'];

    // Get pieces and shuffle
    final pieces = List<String>.from(puzzle['pieces']);
    pieces.shuffle();
    shapePieces.value = pieces;
  }

  void generatePatternPuzzle() {
    // Get random pattern puzzle
    patternPuzzles.shuffle();
    final puzzle = patternPuzzles.first;

    currentPattern.value = List<String>.from(puzzle['pattern']);
    correctAnswer.value = puzzle['correct'];

    // Get options and shuffle
    final options = List<String>.from(puzzle['options']);
    options.shuffle();
    patternOptions.value = options;
  }

  void generateShadowPuzzle() {
    // Get random shadow puzzle
    shadowPuzzles.shuffle();
    final puzzle = shadowPuzzles.first;

    // Create shadow version (using filled black emoji or similar)
    targetShadow.value = puzzle['shadow'];
    correctAnswer.value = puzzle['correct'];

    // Get options and shuffle
    final options = List<String>.from(puzzle['options']);
    options.shuffle();
    shadowOptions.value = options;
  }

  void checkAnswer(String answer) {
    if (isAnswered.value) return;

    selectedAnswer.value = answer;
    isAnswered.value = true;

    if (answer == correctAnswer.value) {
      score.value += 15; // More points for puzzles
      showCorrectAnimation.value = true;
    } else {
      showWrongAnimation.value = true;
    }

    Future.delayed(const Duration(seconds: 1), () {
      nextPuzzle();
    });
  }

  void nextPuzzle() {
    if (currentPuzzle.value < totalPuzzles - 1) {
      currentPuzzle.value++;
      generatePuzzle();
    } else {
      finishGame();
    }
  }

  void finishGame() {
    final user = _storageService.getUser();
    if (user != null) {
      user.addStars(score.value);
      user.updateGameProgress(
        'puzzle',
        ((currentPuzzle.value + 1) / totalPuzzles * 100).toInt(),
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
    // Save partial progress if user quits
    if (currentPuzzle.value > 0 || score.value > 0) {
      final user = _storageService.getUser();
      if (user != null) {
        user.addStars(score.value);
        int partialProgress =
            ((currentPuzzle.value) / totalPuzzles * 100).toInt();
        final currentProgress = user.gameProgress['puzzle'] ?? 0;
        if (partialProgress > currentProgress) {
          user.updateGameProgress('puzzle', partialProgress);
        }
        _storageService.updateUser(user);
      }
    }

    Get.back();
  }
}
