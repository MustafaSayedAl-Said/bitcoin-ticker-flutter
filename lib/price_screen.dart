import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  dynamic rate = List<dynamic>.filled(cryptoList.length, '?');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ForInitial();
  }

  @override
  void updateUI(dynamic coinInfo) {
    setState(() {
      int k = 0;
      for (var i in coinInfo) {
        double exchangeRate = i['rate'];
        rate[k++] = exchangeRate.toInt();
      }
    });
  }

  void ForInitial() async {
    var coinData = await CoinData().fetchRate(selectedCurrency);
    updateUI(coinData);
  }

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: 19),
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) async {
        selectedCurrency = currenciesList[selectedIndex];
        var coinData = await CoinData().fetchRate(selectedCurrency);
        updateUI(coinData);
      },
      children: [
        for (var i in currenciesList) Text(i),
      ],
    );
  }

  DropdownButton<String> androidDropdown() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: [
        for (var i in currenciesList)
          DropdownMenuItem(
            child: Text(i),
            value: i,
          ),
      ],
      onChanged: (value) async {
        selectedCurrency = value.toString();
        var coinData = await CoinData().fetchRate(selectedCurrency);
        updateUI(coinData);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < cryptoList.length; i++)
                CoinCard(
                    cryptoCoin: cryptoList[i],
                    rate: rate[i],
                    selectedCurrency: selectedCurrency),
            ],
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iOSPicker() : androidDropdown()),
        ],
      ),
    );
  }
}

class CoinCard extends StatelessWidget {
  const CoinCard({
    super.key,
    required this.cryptoCoin,
    required this.rate,
    required this.selectedCurrency,
  });
  final cryptoCoin;
  final rate;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCoin = $rate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
