// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimalGameController extends GetxController {
  void quitGame() => Get.back();
}

// Animal Game Screen

class AnimalGameScreen extends StatelessWidget {
  const AnimalGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AnimalGameController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐶 Animal Forest'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.quitGame,
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🐶', style: TextStyle(fontSize: 100)),
            SizedBox(height: 20),
            Text('Animal Game',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            Text('Coming Soon!',
                style: TextStyle(fontSize: 20, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// Color Game Controller

class ColorGameController extends GetxController {
  void quitGame() => Get.back();
}

// Color Game Screen

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

// Puzzle Game Controller

class PuzzleGameController extends GetxController {
  void quitGame() => Get.back();
}

// Puzzle Game Screen

class PuzzleGameScreen extends StatelessWidget {
  const PuzzleGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PuzzleGameController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧩 Puzzle Zone'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.quitGame,
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🧩', style: TextStyle(fontSize: 100)),
            SizedBox(height: 20),
            Text('Puzzle Game',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            Text('Coming Soon!',
                style: TextStyle(fontSize: 20, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
