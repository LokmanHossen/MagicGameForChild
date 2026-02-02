import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'number_game_controller.dart';

class NumberGameScreen extends StatelessWidget {
  const NumberGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NumberGameController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔢 Number Hills'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.quitGame,
        ),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 5),
                    Text(
                      '${controller.score.value}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFA1C4FD),
              Color(0xFFC2E9FB),
            ],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatBox(
                              'Level',
                              '${controller.currentLevel.value}',
                              Icons.flag,
                              Colors.green,
                            ),
                            _buildStatBox(
                              'Time',
                              '${controller.timeRemaining.value}s',
                              Icons.timer,
                              Colors.orange,
                            ),
                            Obx(() => _buildStatBox(
                                  'Target',
                                  '${controller.targetNumber.value}',
                                  Icons.track_changes,
                                  Colors.purple,
                                )),
                          ],
                        )),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 300,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF8BC34A),
                                  Color(0xFF689F38),
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                            child: CustomPaint(
                              painter: _HillPainter(),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            Obx(() => Text(
                                  'Tap number ${controller.targetNumber.value} next!',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.orange,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 1,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Obx(() => GridView.builder(
                                    padding: const EdgeInsets.all(20),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15,
                                      childAspectRatio: 1,
                                    ),
                                    itemCount: controller.numbers.length,
                                    itemBuilder: (context, index) {
                                      return Obx(() {
                                        final number =
                                            controller.numbers[index];
                                        final isSelected = controller
                                            .selectedNumbers
                                            .contains(number);
                                        final isCorrectOrder = controller
                                            .isCorrectNumberOrder(number);
                                        final targetNumber =
                                            controller.targetNumber.value;
                                        final isHintNumber =
                                            controller.showHint.value &&
                                                number == targetNumber;

                                        return GestureDetector(
                                          onTap: () =>
                                              controller.selectNumber(number),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? isCorrectOrder
                                                      ? Colors.green
                                                      : Colors.red
                                                  : isHintNumber
                                                      ? Colors.yellow
                                                      : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                color: isHintNumber
                                                    ? Colors.orange
                                                    : Colors.blue.shade800,
                                                width: isHintNumber ? 4 : 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(
                                                          alpha: isHintNumber
                                                              ? 0.4
                                                              : 0.2),
                                                  blurRadius:
                                                      isHintNumber ? 8 : 5,
                                                  spreadRadius:
                                                      isHintNumber ? 2 : 1,
                                                ),
                                              ],
                                            ),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    '$number',
                                                    style: TextStyle(
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isSelected
                                                          ? Colors.white
                                                          : isHintNumber
                                                              ? Colors.orange
                                                                  .shade900
                                                              : Colors.blue
                                                                  .shade800,
                                                    ),
                                                  ),
                                                ),
                                                if (isHintNumber)
                                                  Positioned(
                                                    top: 5,
                                                    right: 5,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.orange,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: const Icon(
                                                        Icons.lightbulb,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                  )),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 50,
                          left: 20,
                          right: 20,
                          child: Obx(() => LinearProgressIndicator(
                                value: controller.progress.value,
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.amber),
                                minHeight: 15,
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.resetGame,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.restart_alt,
                              color: Colors.white),
                          label: const Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Hint Button
                        Obx(() => ElevatedButton.icon(
                              onPressed: controller.provideHint,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: controller.showHint.value
                                    ? Colors.amber.shade700
                                    : Colors.purple,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: Icon(
                                controller.showHint.value
                                    ? Icons.visibility
                                    : Icons.lightbulb,
                                color: Colors.white,
                              ),
                              label: Text(
                                controller.showHint.value ? 'Hint ON' : 'Hint',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )),

                        // Next Level Button
                        ElevatedButton.icon(
                          onPressed: controller.completeLevel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_forward,
                              color: Colors.white),
                          label: const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

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
                                      color:
                                          Colors.green.withValues(alpha: 0.5),
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
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _HillPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.shade700
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.4, size.width * 0.5, size.height);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.6, size.width, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    final sunPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.8, 30), 25, sunPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
