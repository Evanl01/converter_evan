import 'package:bloc/bloc.dart';

class ConverterState {
  final String inputValue;
  final String inputValueWithUnits;
  final String outputValue;
  final String errorMessage;

  ConverterState({
    this.inputValue = '',
    this.inputValueWithUnits = '',
    this.outputValue = '',
    this.errorMessage = '',
  });

  ConverterState copyWith({
    String? inputValue,
    String? inputValueWithUnits,
    String? outputValue,
    String? errorMessage,
  }) {
    return ConverterState(
      inputValue: inputValue ?? this.inputValue,
      inputValueWithUnits: inputValueWithUnits ?? this.inputValueWithUnits,
      outputValue: outputValue ?? this.outputValue,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ConverterCubit extends Cubit<ConverterState> {
  ConverterCubit() : super(ConverterState());

  bool isValidDecimal(String input) {
    return double.tryParse(input) != null;
  }

  void convertTemperature(String inputValue, bool toCelsius) {
    try {
      if (!isValidDecimal(inputValue)) {
        throw ArgumentError('Invalid input. Please enter a valid decimal number.');
      }
      double value = double.tryParse(inputValue) ?? 0.0;
      double result = toCelsius ? (value - 32) * 5 / 9 : (value * 9 / 5) + 32;
      String resultString = result.toStringAsFixed(2);
      emit(state.copyWith(
        outputValue: '$resultString${toCelsius ? '°C' : '°F'}',
        inputValueWithUnits: '$inputValue${toCelsius ? '°F' : '°C'}',
        errorMessage: '',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void convertWeight(String inputValue, bool toKilograms) {
    try {
      if (!isValidDecimal(inputValue)) {
        throw ArgumentError('Invalid input. Please enter a valid decimal number.');
      }
      double value = double.tryParse(inputValue) ?? 0.0;
      double result = toKilograms ? value * 0.453592 : value / 0.453592;
      String resultString = result.toStringAsFixed(2);
      emit(state.copyWith(
        outputValue: '$resultString${toKilograms ? 'kg' : 'lb'}',
        inputValueWithUnits: '$inputValue ${toKilograms ? 'lb' : 'kg'}',
        errorMessage: '',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void resetValues() {
    emit(ConverterState());
  }
}