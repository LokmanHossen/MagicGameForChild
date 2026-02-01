import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'animal_game_controller.dart';

class AnimalGameScreen extends StatelessWidget {
  const AnimalGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AnimalGameController>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF95E1D3),
                  Color(0xFF4ECDC4),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(controller),

                  // Game content
                  Expanded(
                    child: _buildGameContent(controller),
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
                                    color: Colors.green.withValues(alpha: 0.5),
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
                                    color: Colors.red.withValues(alpha: 0.5),
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

  Widget _buildHeader(AnimalGameController controller) {
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
                color: Color(0xFF4ECDC4),
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
                      'Question ${controller.currentQuestion.value + 1}/${controller.totalQuestions}',
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
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
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
                        color: Color(0xFF4ECDC4),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameContent(AnimalGameController controller) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Title based on game mode
          Obx(() => Text(
                controller.gameMode.value == 'sound'
                    ? 'Which animal makes this sound?'
                    : 'Where does this animal live?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
                textAlign: TextAlign.center,
              )),

          const SizedBox(height: 30),

          // Current Animal or Question
          Obx(() => Column(
                children: [
                  Container(
                    // width: 200,
                    // height: 200,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF95E1D3),
                          Color(0xFF4ECDC4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: controller.gameMode.value == 'sound'
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Speaker emoji
                                const Text(
                                  '🔊',
                                  style: TextStyle(fontSize: 60),
                                ),
                                const SizedBox(height: 10),
                                // Sound text
                                Text(
                                  controller.currentQuestionSound.value,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.currentAnimal.value,
                                  style: const TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  controller.animalData[controller
                                          .currentAnimal.value]?['name'] ??
                                      '',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),

                  // Sound play button (only for sound mode)
                  if (controller.gameMode.value == 'sound') ...[
                    const SizedBox(height: 20),

                    // Sound play button
                    Obx(() => GestureDetector(
                          onTap: controller.playAnimalSound,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: controller.isPlayingSound.value
                                  ? Colors.red
                                  : const Color(0xFF4ECDC4),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  controller.isPlayingSound.value
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  controller.isPlayingSound.value
                                      ? 'Stop Sound'
                                      : 'Play Sound',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],

                  const SizedBox(height: 20),

                  // Instruction text
                  Text(
                    controller.gameMode.value == 'sound'
                        ? 'Tap the button to hear the sound!'
                        : 'Find where this animal belongs!',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF34495E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),

          const SizedBox(height: 30),

          // Options
          Expanded(
            child: Obx(() => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: controller.options.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final option = controller.options[index];
                    final isCorrect =
                        option['emoji'] == controller.correctAnswer.value;
                    final isSelected =
                        option['emoji'] == controller.selectedAnswer.value;

                    Color borderColor = const Color(0xFFE0E0E0);
                    Color bgColor = Colors.white;

                    if (controller.isAnswered.value) {
                      if (isCorrect) {
                        borderColor = const Color(0xFF4CAF50);
                        bgColor =
                            const Color(0xFF4CAF50).withValues(alpha: 0.1);
                      } else if (isSelected) {
                        borderColor = const Color(0xFFE91E63);
                        bgColor =
                            const Color(0xFFE91E63).withValues(alpha: 0.1);
                      }
                    }

                    return GestureDetector(
                      onTap: () => controller.checkAnswer(option['emoji']!),
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
                              color: borderColor.withValues(alpha: 0.2),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              option['emoji']!,
                              style: const TextStyle(fontSize: 50),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              option['name']!,
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
}
