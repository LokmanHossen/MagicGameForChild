import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'puzzle_game_controller.dart';

class PuzzleGameScreen extends StatelessWidget {
  const PuzzleGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PuzzleGameController>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFAA96DA),
                  Color(0xFFC5FAD5),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(controller),

                  // Game content based on mode
                  Expanded(
                    child: Obx(() => controller.gameMode.value == 'shape'
                        ? _buildShapePuzzle(controller)
                        : controller.gameMode.value == 'pattern'
                            ? _buildPatternPuzzle(controller)
                            : _buildShadowPuzzle(controller)),
                  ),
                ],
              ),
            ),
          ),

          // Correct Emoji Animation
          Obx(() => controller.showCorrectAnimation.value
              ? Positioned.fill(
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value,
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Text(
                                '🎉',
                                style: TextStyle(fontSize: 80),
                              ),
                            ),
                          ),
                        );
                      },
                      onEnd: () {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          controller.hideCorrectAnimation();
                        });
                      },
                    ),
                  ),
                )
              : const SizedBox()),

          // Wrong Emoji Animation
          Obx(() => controller.showWrongAnimation.value
              ? Positioned.fill(
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value,
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Text(
                                '😢',
                                style: TextStyle(fontSize: 80),
                              ),
                            ),
                          ),
                        );
                      },
                      onEnd: () {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          controller.hideWrongAnimation();
                        });
                      },
                    ),
                  ),
                )
              : const SizedBox()),
        ],
      ),
    );
  }

  Widget _buildHeader(PuzzleGameController controller) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: controller.quitGame,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFFAA96DA),
                size: 28,
              ),
            ),
          ),

          const SizedBox(width: 15),

          // Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                      'Puzzle ${controller.currentPuzzle.value + 1}/${controller.totalPuzzles}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                const SizedBox(height: 8),
                Obx(() => LinearProgressIndicator(
                      value: (controller.currentPuzzle.value + 1) /
                          controller.totalPuzzles,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(10),
                    )),
              ],
            ),
          ),

          const SizedBox(width: 15),

          // Score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('⭐', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 5),
                Obx(() => Text(
                      '${controller.score.value}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFAA96DA),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Shape Matching Puzzle
  Widget _buildShapePuzzle(PuzzleGameController controller) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Title
          const Text(
            'Complete the Shape!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),

          // Target Shape
          Obx(() => Column(
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFAA96DA).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFAA96DA),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        controller.targetShape.value,
                        style: const TextStyle(fontSize: 80),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Which piece completes the shape?',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF34495E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),

          const SizedBox(height: 30),

          // Shape Pieces
          Expanded(
            child: Obx(() => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1,
                  ),
                  itemCount: controller.shapePieces.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final piece = controller.shapePieces[index];
                    final isCorrect = piece == controller.correctAnswer.value;
                    final isSelected = piece == controller.selectedAnswer.value;

                    Color borderColor = const Color(0xFFE0E0E0);
                    Color bgColor = Colors.white;

                    if (controller.isAnswered.value) {
                      if (isCorrect) {
                        borderColor = const Color(0xFF4CAF50);
                        bgColor = const Color(0xFF4CAF50).withOpacity(0.1);
                      } else if (isSelected) {
                        borderColor = const Color(0xFFE91E63);
                        bgColor = const Color(0xFFE91E63).withOpacity(0.1);
                      }
                    }

                    return GestureDetector(
                      onTap: () => controller.checkAnswer(piece),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: borderColor,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: borderColor.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            piece,
                            style: const TextStyle(fontSize: 60),
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }

  // Pattern Matching Puzzle
  Widget _buildPatternPuzzle(PuzzleGameController controller) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Title
          const Text(
            'Complete the Pattern!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),

          // Pattern Display
          Obx(() => Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFAA96DA).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: controller.currentPattern
                              .map((emoji) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      emoji,
                                      style: const TextStyle(fontSize: 40),
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '...',
                          style: TextStyle(fontSize: 40),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'What comes next in the pattern?',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF34495E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),

          const SizedBox(height: 30),

          // Pattern Options
          Expanded(
            child: Obx(() => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: controller.patternOptions.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final option = controller.patternOptions[index];
                    final isCorrect = option == controller.correctAnswer.value;
                    final isSelected =
                        option == controller.selectedAnswer.value;

                    Color borderColor = const Color(0xFFE0E0E0);
                    Color bgColor = Colors.white;

                    if (controller.isAnswered.value) {
                      if (isCorrect) {
                        borderColor = const Color(0xFF4CAF50);
                        bgColor = const Color(0xFF4CAF50).withOpacity(0.1);
                      } else if (isSelected) {
                        borderColor = const Color(0xFFE91E63);
                        bgColor = const Color(0xFFE91E63).withOpacity(0.1);
                      }
                    }

                    return GestureDetector(
                      onTap: () => controller.checkAnswer(option),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: borderColor,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: borderColor.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }

  // Shadow Matching Puzzle
  Widget _buildShadowPuzzle(PuzzleGameController controller) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Title
          const Text(
            'Match the Shadow!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),

          // Shadow Display
          Obx(() => Column(
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.shade500,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        controller.targetShadow.value,
                        style: TextStyle(
                          fontSize: 80,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Which object matches this shadow?',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF34495E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),

          const SizedBox(height: 30),

          // Object Options
          Expanded(
            child: Obx(() => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: controller.shadowOptions.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final option = controller.shadowOptions[index];
                    final isCorrect = option == controller.correctAnswer.value;
                    final isSelected =
                        option == controller.selectedAnswer.value;

                    Color borderColor = const Color(0xFFE0E0E0);
                    Color bgColor = Colors.white;

                    if (controller.isAnswered.value) {
                      if (isCorrect) {
                        borderColor = const Color(0xFF4CAF50);
                        bgColor = const Color(0xFF4CAF50).withOpacity(0.1);
                      } else if (isSelected) {
                        borderColor = const Color(0xFFE91E63);
                        bgColor = const Color(0xFFE91E63).withOpacity(0.1);
                      }
                    }

                    return GestureDetector(
                      onTap: () => controller.checkAnswer(option),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: borderColor,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: borderColor.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
