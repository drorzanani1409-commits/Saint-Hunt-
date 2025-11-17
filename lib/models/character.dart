class Character {
  final String id;
  final String name;
  final String description;
  final String imagePath;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
    };
  }

  static List<Character> getDefaultCharacters() {
    return [
      Character(
        id: 'skull_pirate',
        name: 'Skull Pirate',
        description: 'A fearsome undead captain with a burning gaze and a blade ready for adventure.',
        imagePath: 'assets/images/characters/skull_pirate.png',
      ),
      Character(
        id: 'quartermaster',
        name: 'Quartermaster',
        description: 'A rugged pirate with a hook for a hand, he keeps the crew in line and the ship shipshape.',
        imagePath: 'assets/images/characters/quartermaster.png',
      ),
      Character(
        id: 'ghost_captain',
        name: 'Ghost Captain',
        description: 'A spectral pirate with a spooky grin, he haunts the high seas in search of riches.',
        imagePath: 'assets/images/characters/ghost_captain.png',
      ),
      Character(
        id: 'salty_turtle',
        name: 'Salty Turtle',
        description: 'This old sea turtle prefers to take things slow and steady when searching for treasure.',
        imagePath: 'assets/images/characters/salty_turtle.png',
      ),
      Character(
        id: 'vampire_pirate',
        name: 'Vampire Pirate',
        description: 'An undead bloodsucker with fangs and a fiery blade, he thirsts for excitement.',
        imagePath: 'assets/images/characters/vampire_pirate.png',
      ),
      Character(
        id: 'elf_swashbuckler',
        name: 'Elf Swashbuckler',
        description: 'A daring elf with painted ears and a quick wit, she\'s always ready for a duel.',
        imagePath: 'assets/images/characters/elf_swashbuckler.png',
      ),
    ];
  }
}

