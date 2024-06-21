import 'dart:math';

class PasswordUtils {
  final Random _random = Random();

  final List<String> _uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
  final List<String> _lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz'.split('');
  final List<String> _numbers = '0123456789'.split('');
  final List<String> _specialCharacters = '!@#\$%^&*()-_=+[]{}|;:,.<>?/`~'.split('');

  final List<String> _words = [
    'Apple',
    'Banana',
    'Cherry',
    'Dog',
    'Cat',
    'Dolphin',
    'Fish',
    'Grape',
    'Game',
    'Hippo',
    'Iguana',
    'Jellyfish',
    'Koala',
    'Lion',
    'Narwhal',
    'Elephant',
    'Frog',
    'Giraffe',
    'House',
    'Ice',
    'Jacket',
    'Kangaroo',
    'Lemon',
    'Monkey',
    'Notebook',
    'Orange',
    'Pencil',
    'Queen',
    'Rabbit',
    'Strawberry',
    'Tiger',
    'Umbrella',
    'Violin',
    'Watermelon',
    'Xylophone',
    'Yogurt',
    'Zebra',
    'Adventure',
    'Bicycle',
    'Computer',
    'Dragon',
    'Eagle',
    'Forest',
    'Galaxy',
    'Hero',
    'Island',
    'Jungle',
    'Kingdom',
    'Lamp',
    'Mountain',
    'Novel',
    'Ocean',
    'Pyramid',
    'Quasar',
    'Rainbow',
    'Sunshine',
    'Treasure',
    'universe',
    'Village',
    'Wizard',
    'Xenon',
    'Yacht',
    'Zephyr'
  ];

  String _getRandomElement(List<String> list) {
    return list[_random.nextInt(list.length)];
  }

  String generatePassword({
    int length = 12,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSpecialCharacters = true,
  }) {
    if (length <= 0) {
      throw ArgumentError('Password length must be greater than 0');
    }

    List<String> characterPool = [];

    if (includeUppercase) {
      characterPool.addAll(_uppercaseLetters);
    }
    if (includeLowercase) {
      characterPool.addAll(_lowercaseLetters);
    }
    if (includeNumbers) {
      characterPool.addAll(_numbers);
    }
    if (includeSpecialCharacters) {
      characterPool.addAll(_specialCharacters);
    }

    if (characterPool.isEmpty) {
      throw ArgumentError('At least one character type must be included');
    }

    return List.generate(length, (_) => _getRandomElement(characterPool)).join('');
  }

  String generateEasyPassword({
    int numberOfWords = 4,
    bool includeNumbers = true,
    bool includeSpecialCharacters = true,
  }) {
    List<String> passwordComponents = List.generate(numberOfWords, (_) => _getRandomElement(_words));

    if (includeNumbers) {
      String number = _random.nextInt(100).toString(); // Generate a random number between 0 and 99
      passwordComponents.add(number);
    }

    if (includeSpecialCharacters) {
      String specialCharacter = _getRandomElement(_specialCharacters);
      passwordComponents.add(specialCharacter);
    }

    passwordComponents.shuffle(); // Shuffle the components to add randomness

    return passwordComponents.join('');
  }

    String generatePassphrase({
    int numberOfWords = 5,
  }) {
    List<String> passwordComponents = List.generate(numberOfWords, (_) => _getRandomElement(_words));

    passwordComponents.shuffle(); // Shuffle the components to add randomness

    return passwordComponents.join('-');
  }
}
