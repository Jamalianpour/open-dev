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

  /// Generates a password with the specified length and character types.
  ///
  /// Parameters:
  /// - `length` (optional): The length of the password. Default is 12.
  /// - `includeUppercase` (optional): Whether to include uppercase letters in the password. Default is true.
  /// - `includeLowercase` (optional): Whether to include lowercase letters in the password. Default is true.
  /// - `includeNumbers` (optional): Whether to include numbers in the password. Default is true.
  /// - `includeSpecialCharacters` (optional): Whether to include special characters in the password. Default is true.
  ///
  /// Returns:
  /// A string representing the generated password.
  ///
  /// Throws:
  /// - `ArgumentError` if the password length is less than or equal to 0.
  /// - `ArgumentError` if no character types are included.
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

  /// Generates a memorable password with a specified number of words, including optional numbers and special characters.
  ///
  /// The generated password consists of a list of words, which are randomly selected from a predefined list.
  /// If [includeNumbers] is true, a random number between 0 and 99 is added to the password.
  /// If [includeSpecialCharacters] is true, a random special character is added to the password.
  /// The components of the password are shuffled to add randomness.
  ///
  /// Parameters:
  /// - [numberOfWords]: The number of words in the generated password. Default is 4.
  /// - [includeNumbers]: A boolean indicating whether to include a random number in the password. Default is true.
  /// - [includeSpecialCharacters]: A boolean indicating whether to include a random special character in the password. Default is true.
  ///
  /// Returns:
  /// A string representing the generated memorable password.
  String generateMemorablePassword({
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

  /// Generates a passphrase with a specified number of words, separated by hyphens.
  ///
  /// Parameters:
  /// - [numberOfWords]: The number of words in the generated passphrase. Default is 5.
  ///
  /// Returns:
  /// A string representing the generated passphrase, with words separated by hyphens.
  String generatePassphrase({
    int numberOfWords = 5,
  }) {
    List<String> passwordComponents = List.generate(numberOfWords, (_) => _getRandomElement(_words));

    passwordComponents.shuffle(); // Shuffle the components to add randomness

    return passwordComponents.join('-');
  }
}
