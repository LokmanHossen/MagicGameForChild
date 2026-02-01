import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'puzzle_game_controller.dart';

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
