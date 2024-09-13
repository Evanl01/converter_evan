class Converter {
  bool isValidDecimal(String input) {
    return double.tryParse(input) != null;
  }

  String convertTemperature(String input, bool toCelsius) {
    if (!isValidDecimal(input)) {
      throw ArgumentError('Invalid input. Please enter a valid decimal number.');
    }
    double value = double.tryParse(input) ?? 0.0;
    double result = toCelsius ? (value - 32) * 5 / 9 : (value * 9 / 5) + 32;
    return result.toStringAsFixed(2);
  }

  String convertWeight(String input, bool toKilograms) {
    if (!isValidDecimal(input)) {
      throw ArgumentError('Invalid input. Please enter a valid decimal number.');
    }
    double value = double.tryParse(input) ?? 0.0;
    double result = toKilograms ? value * 0.453592 : value / 0.453592;
    return result.toStringAsFixed(2);
  }
}