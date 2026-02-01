import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'avatar_select_controller.dart';

class AvatarSelectScreen extends StatelessWidget {
  const AvatarSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AvatarSelectController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF9E6),
              Color(0xFFFFE5EC),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Title
              const Text(
                '🌟 Choose Your Avatar 🌟',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              const Text(
                'Pick your favorite character!',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF34495E),
                ),
              ),

              const SizedBox(height: 40),

              // Avatar Grid - Fixed Obx usage
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: controller.avatars.length,
                    itemBuilder: (context, index) {
                      return Obx(() {
                        final avatar = controller.avatars[index];
                        final isSelected =
                            controller.selectedAvatar.value == avatar['emoji'];

                        return GestureDetector(
                          onTap: () =>
                              controller.selectAvatar(avatar['emoji']!),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isSelected
                                    ? [
                                        Color(int.parse(avatar['color']!)),
                                        Color(int.parse(avatar['color']!))
                                            .withValues(alpha: 0.7),
                                      ]
                                    : [
                                        Colors.white,
                                        Colors.white,
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Color(int.parse(avatar['color']!))
                                    : Colors.grey.shade300,
                                width: isSelected ? 4 : 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? Color(int.parse(avatar['color']!))
                                          .withValues(alpha: 0.3)
                                      : Colors.grey.withValues(alpha: 0.2),
                                  blurRadius: isSelected ? 15 : 8,
                                  spreadRadius: isSelected ? 2 : 0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Avatar emoji
                                TweenAnimationBuilder(
                                  tween: Tween<double>(
                                    begin: 1.0,
                                    end: isSelected ? 1.2 : 1.0,
                                  ),
                                  duration: const Duration(milliseconds: 300),
                                  builder: (context, double scale, child) {
                                    return Transform.scale(
                                      scale: scale,
                                      child: Text(
                                        avatar['emoji']!,
                                        style: const TextStyle(fontSize: 80),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 10),

                                // Avatar name
                                Text(
                                  avatar['name']!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF2C3E50),
                                  ),
                                ),

                                if (isSelected) ...[
                                  const SizedBox(height: 5),
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ),

              // Continue button
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.continueToNameInput,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward, size: 28),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
