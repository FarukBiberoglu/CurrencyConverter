import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String fromCurrency = 'USD';
  String toCurrency = 'EUR';
  double rate = 0.0;
  double total = 0.0;

  TextEditingController amountController = TextEditingController();
  List<String> currencies = [];

  @override
  void initState() {
    super.initState();
    getCurrencies();
  }

  Future<void> getCurrencies() async {
    var response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));
    var data = json.decode(response.body);
    setState(() {
      currencies = (data['rates'] as Map<String, dynamic>).keys.toList();
      rate = data['rates'][toCurrency];
    });
  }

  Future<void> getRate() async {
    var response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/$fromCurrency'));
    var data = json.decode(response.body);
    setState(() {
      rate = data['rates'][toCurrency];
    });
  }

  void swapCurrencies() {
    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
      getRate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text('Currency Converter',
          style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(40),
                child: Image.asset(
                  'assets/currency_converter-removebg.png',
                  width: MediaQuery.of(context).size.width / 2,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value != '') {
                      setState(() {
                        double amount = double.parse(value);
                        total = amount * rate;
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      child: DropdownButton<String>(
                        value: fromCurrency,
                        isExpanded: true,
                        style: TextStyle(color: Colors.white,fontSize: 19,fontWeight: FontWeight.bold),
                        dropdownColor: Colors.teal[800],
                        items: currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            fromCurrency = newValue!;
                            getRate();
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: swapCurrencies,
                      icon: Icon(
                        Icons.swap_horiz,
                        size: 41,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: DropdownButton<String>(
                        value: toCurrency,
                        isExpanded: true,
                        style: TextStyle(color: Colors.white,fontSize: 19,fontWeight: FontWeight.bold),
                        dropdownColor: Colors.teal[800],
                        items: currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            toCurrency = newValue!;
                            getRate();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Rate: $rate',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '${total.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
