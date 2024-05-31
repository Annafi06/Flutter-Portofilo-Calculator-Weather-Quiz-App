import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  late SharedPreferences _prefs;
  String equation = "";
  String result = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _saveEquation(String equation) {
    List<String>? equations = _prefs.getStringList('equations');
    if (equations == null) {
      equations = [];
    }
    if (!equations.contains(equation)) {
      equations.add(equation);
      _prefs.setStringList('equations', equations);
    }
  }

  void _loadEquations() {
    List<String>? equations = _prefs.getStringList('equations');
    if (equations != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Saved Equations"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: equations.map((eq) => Text(eq)).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "";
        result = "";
      } else if (buttonText == "⌫") {
        equation = equation.substring(0, equation.length - 1);
      } else if (buttonText == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(equation);
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          _saveEquation(equation); // Save equation
        } catch (e) {
          result = "Error";
        }
      } else if (buttonText == "√") {
        equation += "sqrt(";
      } else if (buttonText == "^") {
        equation += "^";
      } else if (buttonText == "π") {
        equation += math.pi.toString();
      } else {
        equation += buttonText;
      }
    });
  }

  void showUnitConversionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Unit Conversion"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Length"),
                onTap: () {
                  Navigator.pop(context);
                  performLengthConversion();
                },
              ),
              ListTile(
                title: const Text("Weight"),
                onTap: () {
                  Navigator.pop(context);
                  performWeightConversion();
                },
              ),
              ListTile(
                title: const Text("Temperature"),
                onTap: () {
                  Navigator.pop(context);
                  performTemperatureConversion();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void performLengthConversion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Length Conversion"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter value'),
            onChanged: (value) {
              double inputValue = double.tryParse(value) ?? 0.0;
              double meterValue = inputValue; // Assuming input is in meters
              double kilometerValue = meterValue / 1000;
              double inchValue = meterValue * 39.3701;
              double footValue = meterValue * 3.28084;

              setState(() {
                result = """
                  Meter: $meterValue m
                  Kilometer: $kilometerValue km
                  Inch: $inchValue in
                  Foot: $footValue ft
                """;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void performWeightConversion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Weight Conversion"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter value'),
            onChanged: (value) {
              double inputValue = double.tryParse(value) ?? 0.0;
              double kilogramValue = inputValue; // Assuming input is in kilograms
              double poundValue = inputValue * 2.20462;
              double ounceValue = inputValue * 35.274;

              setState(() {
                result = """
                  Kilogram: $kilogramValue kg
                  Pound: $poundValue lb
                  Ounce: $ounceValue oz
                """;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void performTemperatureConversion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Temperature Conversion"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter value'),
            onChanged: (value) {
              double inputValue = double.tryParse(value) ?? 0.0;
              double celsiusValue = inputValue; // Assuming input is in Celsius
              double fahrenheitValue = (inputValue * 9 / 5) + 32;
              double kelvinValue = inputValue + 273.15;

              setState(() {
                result = """
                  Celsius: $celsiusValue °C
                  Fahrenheit: $fahrenheitValue °F
                  Kelvin: $kelvinValue K
                """;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget buildButton(String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
            side: BorderSide(
              color: Colors.white,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
          padding: EdgeInsets.all(16.0),
        ),
        onPressed: () {
          if (buttonText == "Unit Conversion") {
            showUnitConversionDialog();
          } else if (buttonText == "Save Equation") {
            _saveEquation(equation);
          } else if (buttonText == "Load Equations") {
            _loadEquations();
          } else {
            buttonPressed(buttonText);
          }
        },
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              equation,
              style: TextStyle(fontSize: equationFontSize),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Text(
              result,
              style: TextStyle(fontSize: resultFontSize),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      buildButton("C", 1, Colors.redAccent),
                      buildButton("⌫", 1, Colors.blue),
                      buildButton("√", 1, Colors.blue),
                      buildButton("^", 1, Colors.blue),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      buildButton("7", 1, Colors.black54),
                      buildButton("8", 1, Colors.black54),
                      buildButton("9", 1, Colors.black54),
                      buildButton("/", 1, Colors.blue),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      buildButton("4", 1, Colors.black54),
                      buildButton("5", 1, Colors.black54),
                      buildButton("6", 1, Colors.black54),
                      buildButton("*", 1, Colors.blue),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      buildButton("1", 1, Colors.black54),
                      buildButton("2", 1, Colors.black54),
                      buildButton("3", 1, Colors.black54),
                      buildButton("-", 1, Colors.blue),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      buildButton(".", 1, Colors.black54),
                      buildButton("0", 1, Colors.black54),
                      buildButton("π", 1, Colors.black54),
                      buildButton("+", 1, Colors.blue),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      buildButton("(", 1, Colors.blue),
                      buildButton(")", 1, Colors.blue),
                      buildButton("=", 1, Colors.redAccent),
                      buildButton("Unit Conversion", 1, Colors.blue),
                      buildButton("Save Equation", 1, Colors.blue),
                      buildButton("Load Equations", 1, Colors.blue),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Scientific Calculator',
    home: CalculatorPage(),
  ));
}

