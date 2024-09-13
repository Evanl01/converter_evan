import 'package:flutter/material.dart';
void main() {
  runApp(const ConverterApp());
}

class ConverterApp extends StatelessWidget {
  const ConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ConverterHomePage(),
    );
  }
}

class ConverterHomePage extends StatefulWidget {
  const ConverterHomePage({super.key});

  @override
  _ConverterHomePageState createState() => _ConverterHomePageState();
}

class _ConverterHomePageState extends State<ConverterHomePage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  String _inputValue = '';
  String _outputValue = '';
  String _errorMessage = '';

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  Widget _buildKeypadButton(String text) {
    return ElevatedButton(
      onPressed: () => _appendInput(text),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(60, 60), // Set fixed size
        padding: EdgeInsets.zero, // Remove padding
      ),
      child: Text(text),
    );
  }

  void _appendInput(String value) {
    setState(() {
      _inputValue += value;
      _inputController.text = _inputValue;
    });
  }

  void _toggleSign() {
    setState(() {
      if (_inputValue.startsWith('-')) {
        _inputValue = _inputValue.substring(1);
      } else {
        _inputValue = '-$_inputValue';
      }
      _inputController.text = _inputValue;
    });
  }

  bool _isValidDecimal(String input) {
    return double.tryParse(input) != null;
  }

  String _convertTemperature(String input, bool toCelsius) {
    if (!_isValidDecimal(input)) {
      throw ArgumentError('Invalid input. Please enter a valid decimal number.');
    }
    double value = double.tryParse(input) ?? 0.0;
    double result = toCelsius ? (value - 32) * 5 / 9 : (value * 9 / 5) + 32;
    return '${result.toStringAsFixed(2)} ${toCelsius ? '°C' : '°F'}';
  }

  String _convertWeight(String input, bool toKilograms) {
    if (!_isValidDecimal(input)) {
      throw ArgumentError('Invalid input. Please enter a valid decimal number.');
    }
    double value = double.tryParse(input) ?? 0.0;
    double result = toKilograms ? value * 0.453592 : value / 0.453592;
    return '${result.toStringAsFixed(2)} ${toKilograms ? 'kg' : 'lb'}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Converter App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(flex: 1),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: TextField(
                      controller: _inputController,
                      decoration: const InputDecoration(
                        labelText: 'Input',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _inputValue = '';
                        _outputValue = '';
                        _inputController.clear();
                        _outputController.clear();
                        _errorMessage = '';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red, // Set button color to red
                    ),
                    child: const Text('Clear'),
                  ),
                  Spacer(flex: 1),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 300, // Set a fixed height for the GridView
                width: 220,
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  mainAxisSpacing: 10, // Add vertical spacing
                  crossAxisSpacing: 10, // Add horizontal spacing
                  children: [
                    for (var i = 1; i <= 9; i++) _buildKeypadButton('$i'),
                    _buildKeypadButton('0'),
                    _buildButton('+/-', _toggleSign),
                    _buildButton('.', () => _appendInput('.')),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton('F to C', () {
                    try {
                      final result = _convertTemperature(_inputValue, true);
                      setState(() {
                        _outputValue = result;
                        _outputController.text = _outputValue;
                        _errorMessage = '';
                      });
                      print('Converted $_inputValue°F to $result');
                    } catch (e) {
                      setState(() {
                        _errorMessage = e.toString();
                      });
                      print('Error: $e');
                    }
                  }),
                  _buildButton('C to F', () {
                    try {
                      final result = _convertTemperature(_inputValue, false);
                      setState(() {
                        _outputValue = result;
                        _outputController.text = _outputValue;
                        _errorMessage = '';
                      });
                      print('Converted $_inputValue°C to $result');
                    } catch (e) {
                      setState(() {
                        _errorMessage = e.toString();
                      });
                      print('Error: $e');
                    }
                  }),
                  _buildButton('Lb to Kg', () {
                    try {
                      final result = _convertWeight(_inputValue, true);
                      setState(() {
                        _outputValue = result;
                        _outputController.text = _outputValue;
                        _errorMessage = '';
                      });
                      print('Converted $_inputValue lb to $result');
                    } catch (e) {
                      setState(() {
                        _errorMessage = e.toString();
                      });
                      print('Error: $e');
                    }
                  }),
                  _buildButton('Kg to Lb', () {
                    try {
                      final result = _convertWeight(_inputValue, false);
                      setState(() {
                        _outputValue = result;
                        _outputController.text = _outputValue;
                        _errorMessage = '';
                      });
                      print('Converted $_inputValue kg to $result');
                    } catch (e) {
                      setState(() {
                        _errorMessage = e.toString();
                      });
                      print('Error: $e');
                    }
                  }),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Output: $_outputValue',
                style: const TextStyle(fontSize: 32), // Increase font size
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}