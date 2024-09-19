import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ConverterCubit.dart';

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
      home: BlocProvider(
        create: (_) => ConverterCubit(),
        child: const ConverterHomePage(),
      ),
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
                      context.read<ConverterCubit>().resetValues();
                      _inputController.clear();
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
                  _buildButton('°F to °C', () {
                    context.read<ConverterCubit>().convertTemperature(_inputController.text, true);
                  }),
                  _buildButton('°C to °F', () {
                    context.read<ConverterCubit>().convertTemperature(_inputController.text, false);
                  }),
                  _buildButton('Lb to Kg', () {
                    context.read<ConverterCubit>().convertWeight(_inputController.text, true);
                  }),
                  _buildButton('Kg to Lb', () {
                    context.read<ConverterCubit>().convertWeight(_inputController.text, false);
                  }),
                ],
              ),
              const SizedBox(height: 20),
              BlocBuilder<ConverterCubit, ConverterState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Text(
                        'Input: ${state.inputValueWithUnits}',
                        style: const TextStyle(fontSize: 32), // Increase font size
                      ),
                      Text(
                        'Output: ${state.outputValue}',
                        style: const TextStyle(fontSize: 32), // Increase font size
                      ),
                      if (state.errorMessage.isNotEmpty)
                        Text(
                          state.errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

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
      _inputController.text += value;
    });
  }

  void _toggleSign() {
    setState(() {
      if (_inputController.text.startsWith('-')) {
        _inputController.text = _inputController.text.substring(1);
      } else {
        _inputController.text = '-${_inputController.text}';
      }
    });
  }
}