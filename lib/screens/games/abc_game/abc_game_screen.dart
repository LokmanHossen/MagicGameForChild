import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'abc_game_controller.dart';

class AbcGameScreen extends StatelessWidget {
  const AbcGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AbcGameController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF6B9D),
              Color(0xFFFFB6C1),
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
    );
  }

  Widget _buildHeader(AbcGameController controller) {
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
                color: Color(0xFFFF6B9D),
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
                        color: Color(0xFFFF6B9D),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameContent(AbcGameController controller) {
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
          // Title
          const Text(
            'Find the letter',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),

          const SizedBox(height: 30),

          // Current Letter
          Obx(() => Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF6B9D),
                          Color(0xFFFFB6C1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B9D).withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        controller.currentLetter.value,
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Which one starts with "${controller.currentLetter.value}"?',
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
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 18,
                  ),
                  itemCount: controller.options.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final option = controller.options[index];
                    final emoji = option['emoji']!;
                    final isCorrect = emoji == controller.correctAnswer.value;
                    final isSelected = emoji == controller.selectedAnswer.value;

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
                              emoji,
                              style: const TextStyle(fontSize: 50),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              option['name']!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (controller.isAnswered.value && isCorrect)
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 5,
                                ),
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
