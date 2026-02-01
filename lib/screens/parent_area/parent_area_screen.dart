import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'parent_area_controller.dart';
import '../../services/storage_service.dart';

class ParentAreaScreen extends StatelessWidget {
  const ParentAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ParentAreaController>();
    final storageService = StorageService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Area'),
      ),
      body: Obx(() => controller.isAuthenticated.value
          ? _buildParentDashboard(controller, storageService)
          : _buildPinEntry(controller)),
    );
  }

  Widget _buildPinEntry(ParentAreaController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock,
              size: 80,
              color: Color(0xFF2C3E50),
            ),
            const SizedBox(height: 30),
            const Text(
              'Enter Parent PIN',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Default PIN: 1234',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 200,
              child: TextField(
                controller: controller.pinController,
                textAlign: TextAlign.center,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10,
                ),
                decoration: InputDecoration(
                  hintText: '••••',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  counterText: '',
                ),
                onSubmitted: (_) => controller.verifyPin(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.verifyPin,
              child: const Text('Unlock'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParentDashboard(
      ParentAreaController controller, StorageService storageService) {
    final user = storageService.getUser();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),

          // User info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user?.avatar ?? '👦',
                        style: const TextStyle(fontSize: 50),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'No user',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Level ${user?.level ?? 0}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  _buildStatRow('Total Stars', '${user?.stars ?? 0} ⭐'),
                  _buildStatRow('Current Level', '${user?.level ?? 1}'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Progress card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Learning Progress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildProgressRow('🅰️ ABC', user?.gameProgress['abc'] ?? 0),
                  _buildProgressRow(
                      '🔢 Numbers', user?.gameProgress['numbers'] ?? 0),
                  _buildProgressRow(
                      '🐶 Animals', user?.gameProgress['animals'] ?? 0),
                  _buildProgressRow(
                      '🎨 Colors', user?.gameProgress['colors'] ?? 0),
                  _buildProgressRow(
                      '🧩 Puzzle', user?.gameProgress['puzzle'] ?? 0),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ListTile(
                    leading:
                        const Icon(Icons.refresh, color: Color(0xFFE91E63)),
                    title: const Text('Reset Progress'),
                    subtitle: const Text('Clear all user data and start fresh'),
                    onTap: controller.resetProgress,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String game, int progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              game,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$progress%',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
