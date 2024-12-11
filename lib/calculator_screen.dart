import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; // First number entered by the user
  String operand = ""; // Operator entered by the user
  String number2 = ""; // Second number entered by the user
  @override
  Widget build(BuildContext context) {
    final screenSize =
        MediaQuery.of(context).size; // Get screen size for layout

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Display output area
            Expanded(
              child: SingleChildScrollView(
                reverse: true, // Start from the bottom of the scroll view
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0" // Display "0" if no input, otherwise show the current input
                        : "$number1$operand$number2",
                    style: const TextStyle(
                      fontSize: 48, // Large font size for display
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end, // Align text to the right
                  ),
                ),
              ),
            ),

            // Display buttons area
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2 // Wider button for "0"
                          : (screenSize.width / 4), // Regular button size
                      height: screenSize.width / 5, // Height of each button
                      child: buildButton(value), // Build each button
                    ),
                  )
                  .toList(), // Convert the mapped values to a list of widgets
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0), // Adds padding around each button
      child: Material(
        color: getBtnColor(value), // Sets the color based on button type
        clipBehavior: Clip.hardEdge, // Clips the button shape to its boundaries
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white24, // Sets a light border color for the button
          ),
          borderRadius: BorderRadius.circular(100), // Makes the button circular
        ),
        child: InkWell(
          onTap: () => onBtnTap(value), // Defines action when button is tapped
          child: Center(
            child: Text(
              value, // Displays the button's text (e.g., numbers, operators)
              style: const TextStyle(
                fontWeight: FontWeight.bold, // Bold font for button text
                fontSize: 24, // Sets font size of button text
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    // If "Delete" button is tapped, call the delete function
    if (value == Btn.del) {
      delete();
      return;
    }
// If "Clear" button is tapped, call the clearAll function
    if (value == Btn.clr) {
      clearAll();
      return;
    }

// If "Percentage" button is tapped, call the convertToPercentage function
    if (value == Btn.per) {
      convertToPercentage();
      return;
    }
// If "Calculate" button (equals sign) is tapped, call the calculate function
    if (value == Btn.calculate) {
      calculate();
      return;
    }
// For all other values (numbers and operators), call the appendValue function
    appendValue(value);
  }

  // calculates the result
  void calculate() {
    // Check if number1 is empty; if so, exit the function (no calculation possible)
    if (number1.isEmpty) return;

    // Check if operand is empty; if so, exit the function (no operator provided)
    if (operand.isEmpty) return;

     // Check if number2 is empty; if so, exit the function (no second number to calculate with)
    if (number2.isEmpty) return;

//  number1 and number2 as doubles to perform arithmetic operations
    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2; // Addition operation
        break;
      case Btn.subtract:
        result = num1 - num2; // Subtraction operation
        break;
      case Btn.multiply:
        result = num1 * num2; // Multiplication operation
        break;
      case Btn.divide:
        result = num1 / num2; // Division operation
        break;
      default:
      // No operation if operand doesn't match any case
    }

    setState(() {
      // Convert result to a string, then remove unnecessary trailing zeros
      String resultStr = result.toString();

      // Remove trailing zeros and decimal point if it's a whole number
      if (resultStr.contains('.')) {
        resultStr =
            resultStr.replaceAll(RegExp(r'0*$'), ''); // Remove trailing zeros
        resultStr = resultStr.replaceAll(
            RegExp(r'\.$'), ''); // Remove trailing decimal point if any
      }

      number1 = resultStr;
      operand = "";
      number2 = "";
    });
  }

  // converts output to %
  void convertToPercentage() {
    // ex: 434+324
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      // calculate before conversion
      calculate();
    }

    if (operand.isNotEmpty) {
      // cannot be converted
      return;
    }

    final number = double.parse(number1);// Parse number1 as a double to perform the percentage calculation
    setState(() {

      // Divide number1 by 100 to convert it to a percentage
      number1 = "${(number / 100)}";

       // Clear the operand since we're only working with a single percentage value
      operand = "";

      // Clear number2 as well to reset any secondary input
      number2 = "";

    });
  }

  // clears all output
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  // delete one from the end
  void delete() {
    if (number2.isNotEmpty) {
      // If number2 has a value, remove the last character
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      // If there's an operand, clear it
      operand = "";
    } else if (number1.isNotEmpty) {
      // If number1 has a value, remove the last character
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {}); // Update the UI
  }

  // appends value to the end
  void appendValue(String value) {
    // If the value is an operand (e.g., +, -, *, /) and not a decimal
    if (value != Btn.dot && int.tryParse(value) == null) {
      // Process the operand only if the previous entry was a number
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operand = value;
    }
    // Assign value to number1 if operand is empty, indicating the first number
    else if (number1.isEmpty || operand.isEmpty) {
      // Prevent multiple leading zeros
      if (value == Btn.n0 && number1 == "0") return;

      // Check for decimal point only once
      if (value == Btn.dot && number1.contains(Btn.dot)) return;

      // Handle initial zero with decimal
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0.";
      }

      // Append value to the first number
      number1 += value;
    }
    // Assign value to number2 if operand is present, indicating the second number
    else if (number2.isEmpty || operand.isNotEmpty) {
      // Prevent multiple leading zeros in the second number
      if (value == Btn.n0 && number2 == "0") return;

      // Check for decimal point only once
      if (value == Btn.dot && number2.contains(Btn.dot)) return;

      // Handle initial zero with decimal
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = "0.";
      }

      // Append value to the second number
      number2 += value;
    }

    setState(() {});
  }

  Color getBtnColor(value) {
    // If the button is "Delete" (D) or "Clear" (C), use blue-grey color
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        // If the button is an operator (% × + - ÷ =) use orange color
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
          ].contains(value)
            ? Colors.orange
            // Otherwise, use black87 color for number buttons
            : Colors.black87;
  }
}
