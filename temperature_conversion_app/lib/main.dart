import 'package:flutter/material.dart';
import 'dart:async'; // For the timer to update the clock

void main() {
  runApp(TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TemperatureConverter(),
    );
  }
}

class TemperatureConverter extends StatefulWidget {
  @override
  _TemperatureConverterState createState() {
    return _TemperatureConverterState();
  }
}

class _TemperatureConverterState extends State<TemperatureConverter> {
  String _selectedConversion = 'Fahrenheit to Celsius';
  final TextEditingController _inputController = TextEditingController();
  String _result = '';
  List<String> _conversionHistory = [];
  String _currentTime = '';

  // Timer to keep the current time updated every second
  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  // Method to get the current time
  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime =
      '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    });
  }

  // Conversion logic
  void _convert() {
    double input = double.tryParse(_inputController.text) ?? 0;
    double output;
    String conversionRecord;

    if (_selectedConversion == 'Fahrenheit to Celsius') {
      output = (input - 32) * 5 / 9;
      conversionRecord = '$input°F = ${output.toStringAsFixed(1)}°C';
    } else {
      output = (input * 9 / 5) + 32;
      conversionRecord = '$input°C = ${output.toStringAsFixed(1)}°F';
    }

    setState(() {
      _result = output.toStringAsFixed(1);
      _addToHistory(conversionRecord);
    });
  }

  // Method to add the conversion to history and limit to 5 items
  void _addToHistory(String conversionRecord) {
    if (_conversionHistory.length >= 5) {
      _conversionHistory.removeAt(0); // Remove the oldest entry
    }
    _conversionHistory.add(conversionRecord); // Add the new conversion
  }

  // Reset the input and result fields
  void _reset() {
    setState(() {
      _inputController.clear(); // Clear the input field
      _result = ''; // Clear the result
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Converter °C to °F',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 32,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Conversion:',
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<String>(
                  value: 'Fahrenheit to Celsius',
                  groupValue: _selectedConversion,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedConversion = value!;
                    });
                  },
                ),
                const Text('Fahrenheit to Celsius'),
                Radio<String>(
                  value: 'Celsius to Fahrenheit',
                  groupValue: _selectedConversion,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedConversion = value!;
                    });
                  },
                ),
                const Text('Celsius to Fahrenheit'),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter temperature',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _convert,
                  child: const Text('CONVERT'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _reset,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red), // Red color for reset
                  child: const Text(
                    'RESET',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _result.isNotEmpty ? 'Result: $_result' : '',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            // Display history of conversions
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'History (Last 5 items):',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _conversionHistory.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_conversionHistory[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Display current time at the bottom
            Text(
              'Current Time: $_currentTime',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}