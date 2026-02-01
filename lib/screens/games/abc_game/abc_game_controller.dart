import 'package:get/get.dart';
import '../../../services/storage_service.dart';

class AbcGameController extends GetxController {
  final StorageService _storageService = StorageService();

  final RxString currentLetter = 'A'.obs;
  final RxList<Map<String, String>> options = <Map<String, String>>[].obs;
  final RxString correctAnswer = ''.obs;
  final RxInt score = 0.obs;
  final RxInt currentQuestion = 0.obs;
  final RxBool isAnswered = false.obs;
  final RxString selectedAnswer = ''.obs;

  // Animation States
  final RxBool showCorrectAnimation = false.obs;
  final RxBool showWrongAnimation = false.obs;

  final int totalQuestions = 10;

  final Map<String, List<Map<String, String>>> letterData = {
    'A': [
      {'name': 'Apple', 'emoji': '🍎'},
      {'name': 'Ant', 'emoji': '🐜'},
      {'name': 'Airplane', 'emoji': '✈️'},
    ],
    'B': [
      {'name': 'Ball', 'emoji': '⚽'},
      {'name': 'Banana', 'emoji': '🍌'},
      {'name': 'Bear', 'emoji': '🐻'},
    ],
    'C': [
      {'name': 'Cat', 'emoji': '🐱'},
      {'name': 'Car', 'emoji': '🚗'},
      {'name': 'Cake', 'emoji': '🎂'},
    ],
    'D': [
      {'name': 'Dog', 'emoji': '🐶'},
      {'name': 'Duck', 'emoji': '🦆'},
      {'name': 'Donut', 'emoji': '🍩'},
    ],
    'E': [
      {'name': 'Elephant', 'emoji': '🐘'},
      {'name': 'Egg', 'emoji': '🥚'},
      {'name': 'Eagle', 'emoji': '🦅'},
    ],
    'F': [
      {'name': 'Fish', 'emoji': '🐟'},
      {'name': 'Frog', 'emoji': '🐸'},
      {'name': 'Flower', 'emoji': '🌸'},
    ],
    'G': [
      {'name': 'Goat', 'emoji': '🐐'},
      {'name': 'Grapes', 'emoji': '🍇'},
      {'name': 'Guitar', 'emoji': '🎸'},
    ],
    'H': [
      {'name': 'Hat', 'emoji': '🎩'},
      {'name': 'Horse', 'emoji': '🐎'},
      {'name': 'House', 'emoji': '🏠'},
    ],
    'I': [
      {'name': 'Ice Cream', 'emoji': '🍨'},
      {'name': 'Igloo', 'emoji': '🏠'},
      {'name': 'Island', 'emoji': '🏝️'},
    ],
    'J': [
      {'name': 'Juice', 'emoji': '🧃'},
      {'name': 'Jaguar', 'emoji': '🐆'},
      {'name': 'Jet', 'emoji': '✈️'},
    ],
    'K': [
      {'name': 'Kite', 'emoji': '🪁'},
      {'name': 'Key', 'emoji': '🔑'},
      {'name': 'Koala', 'emoji': '🐨'},
    ],
    'L': [
      {'name': 'Lion', 'emoji': '🦁'},
      {'name': 'Lamp', 'emoji': '💡'},
      {'name': 'Leaf', 'emoji': '🍃'},
    ],
    'M': [
      {'name': 'Monkey', 'emoji': '🐵'},
      {'name': 'Moon', 'emoji': '🌙'},
      {'name': 'Milk', 'emoji': '🥛'},
    ],
    'N': [
      {'name': 'Nest', 'emoji': '🪺'},
      {'name': 'Nurse', 'emoji': '🧑‍⚕️'},
      {'name': 'Notebook', 'emoji': '📓'},
    ],
    'O': [
      {'name': 'Orange', 'emoji': '🍊'},
      {'name': 'Owl', 'emoji': '🦉'},
      {'name': 'Octopus', 'emoji': '🐙'},
    ],
    'P': [
      {'name': 'Parrot', 'emoji': '🦜'},
      {'name': 'Pencil', 'emoji': '✏️'},
      {'name': 'Pizza', 'emoji': '🍕'},
    ],
    'Q': [
      {'name': 'Queen', 'emoji': '👑'},
      {'name': 'Quilt', 'emoji': '🛏️'},
      {'name': 'Question', 'emoji': '❓'},
    ],
    'R': [
      {'name': 'Rabbit', 'emoji': '🐰'},
      {'name': 'Rainbow', 'emoji': '🌈'},
      {'name': 'Robot', 'emoji': '🤖'},
    ],
    'S': [
      {'name': 'Sun', 'emoji': '☀️'},
      {'name': 'Star', 'emoji': '⭐'},
      {'name': 'Ship', 'emoji': '🚢'},
    ],
    'T': [
      {'name': 'Tiger', 'emoji': '🐯'},
      {'name': 'Tree', 'emoji': '🌳'},
      {'name': 'Train', 'emoji': '🚆'},
    ],
    'U': [
      {'name': 'Umbrella', 'emoji': '☂️'},
      {'name': 'Unicorn', 'emoji': '🦄'},
      {'name': 'Uniform', 'emoji': '👕'},
    ],
    'V': [
      {'name': 'Van', 'emoji': '🚐'},
      {'name': 'Violin', 'emoji': '🎻'},
      {'name': 'Vegetable', 'emoji': '🥕'},
    ],
    'W': [
      {'name': 'Watch', 'emoji': '⌚'},
      {'name': 'Whale', 'emoji': '🐳'},
      {'name': 'Window', 'emoji': '🪟'},
    ],
    'X': [
      {'name': 'Xylophone', 'emoji': '🎼'},
      {'name': 'X-ray', 'emoji': '🩻'},
      {'name': 'Xmas Tree', 'emoji': '🎄'},
    ],
    'Y': [
      {'name': 'Yacht', 'emoji': '🛥️'},
      {'name': 'Yak', 'emoji': '🐂'},
      {'name': 'Yo-yo', 'emoji': '🪀'},
    ],
    'Z': [
      {'name': 'Zebra', 'emoji': '🦓'},
      {'name': 'Zoo', 'emoji': '🦒'},
      {'name': 'Zip', 'emoji': '🤐'},
    ],
  };

  @override
  void onInit() {
    super.onInit();
    generateQuestion();
  }

  void generateQuestion() {
    // Get random letter
    final letters = letterData.keys.toList();
    letters.shuffle();
    final letter = letters.first;
    currentLetter.value = letter;

    // Get correct answer
    final correctItems = letterData[letter]!;
    correctItems.shuffle();
    correctAnswer.value = correctItems.first['emoji']!;

    // Generate wrong answers from other letters
    final wrongOptions = <Map<String, String>>[];
    for (var l in letters.skip(1)) {
      if (letterData[l] != null) {
        final items = letterData[l]!;
        items.shuffle();
        wrongOptions.add(items.first);
      }
    }

    // Combine and shuffle
    final allOptions = [
      correctItems.first,
      ...wrongOptions.take(2),
    ];
    allOptions.shuffle();

    options.value = allOptions;
    isAnswered.value = false;
    selectedAnswer.value = '';
    hideCorrectAnimation();
    hideWrongAnimation();
  }

  void checkAnswer(String emoji) {
    if (isAnswered.value) return;

    selectedAnswer.value = emoji;
    isAnswered.value = true;

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
    final user = _storageService.getUser();
    if (user != null) {
      user.addStars(score.value);
      user.updateGameProgress(
          'abc', ((currentQuestion.value + 1) / totalQuestions * 100).toInt());
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
    if (currentQuestion.value > 0 || score.value > 0) {
      final user = _storageService.getUser();
      if (user != null) {
        user.addStars(score.value);
        int partialProgress =
            ((currentQuestion.value) / totalQuestions * 100).toInt();
        final currentProgress = user.gameProgress['abc'] ?? 0;
        if (partialProgress > currentProgress) {
          user.updateGameProgress('abc', partialProgress);
        }
        _storageService.updateUser(user);
      }
    }

    Get.back();
  }
}
