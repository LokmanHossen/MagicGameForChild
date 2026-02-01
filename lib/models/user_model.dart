class UserModel {
  String name;
  String avatar;
  int stars;
  int level;
  Map<String, int> gameProgress;

  UserModel({
    required this.name,
    required this.avatar,
    this.stars = 0,
    this.level = 1,
    Map<String, int>? gameProgress,
  }) : gameProgress = gameProgress ??
            {
              'abc': 0,
              'numbers': 0,
              'numbers_level': 1,
              'animals': 0,
              'colors': 0,
              'puzzle': 0,
            };

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatar': avatar,
      'stars': stars,
      'level': level,
      'gameProgress': gameProgress,
    };
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      stars: json['stars'] ?? 0,
      level: json['level'] ?? 1,
      gameProgress: Map<String, int>.from(json['gameProgress'] ?? {}),
    );
  }

  // Add stars
  void addStars(int count) {
    stars += count;
    // Level up every 50 stars
    if (stars >= level * 50) {
      level++;
    }
  }

  // Update game progress - ensures progress never exceeds 100%
  void updateGameProgress(String game, int progress) {
    // Clamp progress between 0 and 100
    final clampedProgress = progress.clamp(0, 100);

    // Only update if new progress is higher than current
    final currentProgress = gameProgress[game] ?? 0;
    if (clampedProgress > currentProgress) {
      gameProgress[game] = clampedProgress;
    }
  }
}
