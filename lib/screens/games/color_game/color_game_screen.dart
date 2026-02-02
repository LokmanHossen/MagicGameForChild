// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'color_game_controller.dart';

class ColorGameScreen extends StatelessWidget {
  const ColorGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ColorGameController>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFA07A),
                  Color(0xFFFFB347),
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
                    child: Obx(() => controller.gameMode.value == 'match'
                        ? _buildMatchGame(controller)
                        : controller.gameMode.value == 'identify'
                            ? _buildIdentifyGame(controller)
                            : _buildMixGame(controller)),
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

  Widget _buildHeader(ColorGameController controller) {
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
                color: Color(0xFFFFA07A),
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
                      '${controller.getModeTitle()} ${controller.currentQuestion.value + 1}/${controller.totalQuestions}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                const SizedBox(height: 8),
                Obx(() => LinearProgressIndicator(
                      value: (controller.currentQuestion.value + 1) /
                          controller.totalQuestions,
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
                        color: Color(0xFFFFA07A),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Match Game: Color to object
  Widget _buildMatchGame(ColorGameController controller) {
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
            'Find objects of this color!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          Obx(() => Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: controller.currentColor.value,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: controller.currentColor.value
                              .withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white,
                        width: 5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        controller.getColorName(controller.currentColor.value),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 5,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Which object is this color?',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF34495E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),

          const SizedBox(height: 16),

          // Options
          Expanded(
            child: Obx(() => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: controller.options.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final option = controller.options[index];
                    final emoji = option['emoji'] ?? '';
                    final name = option['name'] ?? '';

                    // Find if this is the correct answer for current color
                    final currentColorName =
                        controller.getColorName(controller.currentColor.value);
                    final optionColorName = option['correctColor'] ?? '';
                    final isCorrect = optionColorName == currentColorName;

                    final isSelected = emoji == controller.selectedAnswer.value;

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
                      onTap: () => controller.checkAnswer(emoji),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              emoji,
                              style: const TextStyle(fontSize: 50),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (controller.isAnswered.value && isCorrect)
                              const Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF4CAF50),
                                  size: 24,
                                ),
                              ),
                          ],
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

  // Identify Game: Show color, choose name
  Widget _buildIdentifyGame(ColorGameController controller) {
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
            'What color is this?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),

          // Color Display
          Obx(() => Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: controller.currentColor.value,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: controller.currentColor.value.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white,
                        width: 5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Choose the correct color name!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF34495E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),

          const SizedBox(height: 30),

          // Color Name Options
          Expanded(
            child: Obx(() => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: controller.colorOptions.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final colorName = controller.colorOptions[index];
                    final isCorrect = colorName ==
                        controller.getColorName(controller.currentColor.value);
                    final isSelected =
                        colorName == controller.selectedAnswer.value;

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
                      onTap: () => controller.checkAnswer(colorName),
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
                            colorName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isCorrect && controller.isAnswered.value
                                  ? Colors.green
                                  : const Color(0xFF2C3E50),
                            ),
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

  Widget _buildMixGame(ColorGameController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
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
            'Color Mixing Magic!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Color Mixing Display
          Obx(() => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // First color
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: controller.mixColors[0],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '+',
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                      // Second color
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: controller.mixColors[1],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        size: 40,
                      ),
                      // Result color
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: controller.currentColor.value,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: controller.currentColor.value
                                  .withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            controller
                                .getColorName(controller.currentColor.value),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 2,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'What colors make ${controller.getColorName(controller.currentColor.value)}?',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF34495E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Choose the two colors that mix together!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7F8C8D),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),

          const SizedBox(height: 30),

          // Color Options for Mixing
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemCount: controller.mixOptions.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Obx(() {
                  final color = controller.mixOptions[index];
                  final isSelected = controller.selectedMixColors
                      .any((c) => c.value == color.value);
                  controller.correctMixColors
                      .any((c) => c.value == color.value);

                  return GestureDetector(
                    onTap: () => controller.selectMixColor(color),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.white,
                          width: isSelected ? 4 : 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 30,
                              )
                            : null,
                      ),
                    ),
                  );
                });
              },
            ),
          ),

          // Submit button for mix game
          const SizedBox(height: 20),
          Obx(() => ElevatedButton(
                onPressed: controller.selectedMixColors.length == 2 &&
                        !controller.isAnswered.value
                    ? controller.checkMixAnswer
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA07A),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  controller.selectedMixColors.length == 2
                      ? 'Mix Colors!'
                      : 'Select 2 Colors',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
