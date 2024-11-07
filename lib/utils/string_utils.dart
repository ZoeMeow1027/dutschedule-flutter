class StringUtils {
  static String formatString(String format, List<String> args) {
    return format.replaceAllMapped(RegExp(r"\{(\d+)\}"), (match) {
      int index = int.parse(match[1]!);
      return args[index];
    });
  }

  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }
}
