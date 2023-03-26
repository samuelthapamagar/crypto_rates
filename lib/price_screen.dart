import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String? selectedCurrency = 'USD';
  String? bitcoinValueInUSD = '?';
  String? ethValueInUSD = '?';
  String? ltcValueInUSD = '?';

  Widget getIOSPicker() {
    List<Widget> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      magnification: 1.1,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        getData();
      },
      children: pickerItems,
    );
  }

  Widget getAndroidDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(value: currency, child: Text(currency));
      dropdownItems.add(newItem);
    }
    return Container(
      height: 37,
      width: 80,
      decoration: BoxDecoration(
          color: Colors.deepPurple,
          border: Border.all(width: 2, color: Colors.black12),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: DropdownButton<String>(
            underline: Container(color: Colors.deepPurple),
            value: selectedCurrency,
            items: dropdownItems,
            onChanged: (value) {
              setState(() {
                selectedCurrency = value;
                getData();
                // print(value);
              });
            }),
      ),
    );
  }

  bool isWaiting = false;
  Map<String, String> coinPrices = {};
  void getData() async {
    isWaiting = true; //not used currently
    try {
      coinPrices = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        bitcoinValueInUSD = coinPrices['BTC'];
        ethValueInUSD = coinPrices['ETH'];
        ltcValueInUSD = coinPrices['LTC'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title:
            const Text('Crypto Rates', style: TextStyle(fontFamily: 'Anton')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
              cryptoCurrency: cryptoList[0],
              selectedCurrency: selectedCurrency,
              coinValue: bitcoinValueInUSD,
              color: Color(0xFFA9C1FF)),
          CryptoCard(
              cryptoCurrency: cryptoList[1],
              selectedCurrency: selectedCurrency,
              coinValue: ethValueInUSD,
              color: Color(0xFFB784F0)),
          CryptoCard(
              cryptoCurrency: cryptoList[2],
              selectedCurrency: selectedCurrency,
              coinValue: ethValueInUSD,
              color: Color(0xFFE5FF6E)),
          Container(
            height: 125.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            // color: Colors.deepPurple,
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            child: Platform.isIOS ? getIOSPicker() : getAndroidDropdownButton(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard(
      {super.key,
      required this.cryptoCurrency,
      required this.selectedCurrency,
      required this.coinValue,
      required this.color});

  final String? cryptoCurrency;
  final String? selectedCurrency;
  final String? coinValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Card(
          color: color,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Center(
              child: Text(
                '1 $cryptoCurrency = $coinValue ${selectedCurrency!}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
