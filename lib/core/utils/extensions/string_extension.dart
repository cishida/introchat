extension StringExtension on String {
  String capitalizeDomain() {
    return "${this[0]}${this[1].toUpperCase()}${this.substring(2)}";
  }
}
