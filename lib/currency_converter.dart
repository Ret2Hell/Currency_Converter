import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forex_conversion/forex_conversion.dart';

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  double myPriceInTND = 0;
  final TextEditingController textEditingController = TextEditingController();
  final fx = Forex();
  double exchangeRate = 0;
  bool showExchangeRate = false;

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(_handleTextChanged);
  }

  void _handleTextChanged() {
    if (textEditingController.text.isNotEmpty) {
      setState(() {
        showExchangeRate = false;
      });
    }
  }

  Future<void> _fetchExchangeRate() async {
    double rate = await fx.getCurrencyConverted(
      sourceCurrency: "EUR",
      destinationCurrency: "TND",
      sourceAmount: 1,
      numberOfDecimals: 2,
    );
    setState(() {
      exchangeRate = rate;
      showExchangeRate = true;
    });
  }

  void convert() async {
    if (textEditingController.text.isNotEmpty) {
      await _fetchExchangeRate();
      setState(() {
        myPriceInTND = double.parse(textEditingController.text) * exchangeRate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.circular(5),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 212, 212, 212),
      appBar: AppBar(
        title: const Text(
          'Currency Converter',
          style: TextStyle(
            color: Color.fromARGB(255, 238, 238, 238),
            fontWeight: FontWeight.w500,
            fontSize: 27,
          ),
        ),
        leading: const Icon(
          Icons.currency_exchange,
          color: Color.fromARGB(255, 238, 238, 238),
          size: 32,
        ),
        backgroundColor: const Color.fromARGB(255, 66, 66, 66),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${myPriceInTND.toStringAsFixed(3)} TND",
              style: const TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 66, 66, 66),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: textEditingController,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Please enter the amount in Euro',
                  hintStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  prefixIcon: const Icon(
                    Icons.euro_symbol_rounded,
                  ),
                  prefixIconColor: Colors.black,
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: convert,
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 66, 66, 66),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Convert",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            if (showExchangeRate)
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color.fromARGB(255, 66, 66, 66),
                    width: 2.0,
                  ),
                ),
                child: Text(
                  "Exchange rate: 1 EUR = $exchangeRate TND",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 66, 66, 66),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.removeListener(_handleTextChanged);
    textEditingController.dispose();
    super.dispose();
  }
}
