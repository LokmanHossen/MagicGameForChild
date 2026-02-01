import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'color_game_controller.dart';

class ColorGameScreen extends StatelessWidget {
  const ColorGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ColorGameController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎨 Color Town'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.quitGame,
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🎨', style: TextStyle(fontSize: 100)),
            SizedBox(height: 20),
            Text('Color Game',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            Text('Coming Soon!',
                style: TextStyle(fontSize: 20, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
