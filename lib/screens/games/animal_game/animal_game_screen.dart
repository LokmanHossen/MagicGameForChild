import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'animal_game_controller.dart';

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
