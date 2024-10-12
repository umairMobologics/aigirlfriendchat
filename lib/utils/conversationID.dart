import 'dart:math';

String generateUniqueString() {
  Random random = Random();

  // Define a string with possible characters (letters + special characters)
  const String characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()';

  // Generate a unique timestamp to ensure uniqueness
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

  // Build a random string from the characters
  String randomString =
      List.generate(6, (index) => characters[random.nextInt(characters.length)])
          .join();

  return '$randomString$timestamp';
}
