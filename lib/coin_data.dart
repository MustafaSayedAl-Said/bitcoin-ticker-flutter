import 'dart:convert';

import 'package:bitcoin_ticker_flutter/networking.dart';
import 'package:http/http.dart' as http;
import 'networking.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR',
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
const coinUrl = 'https://rest.coinapi.io/v1/exchangerate/';
const apikey = '607A5087-5015-4D18-9CEB-C80531962DC2';

class CoinData {
  Future<dynamic> fetchRate(String selectedCurrency) async {
    List<dynamic> rateDatas = [];
    for(var i in cryptoList) {
      NetworkHelper networkHelper = NetworkHelper(
          '${coinUrl}$i/${selectedCurrency}?apikey=$apikey');
      var rateData = await networkHelper.getData();
      rateDatas.add(rateData);
    }
    return rateDatas;
  }
  // factory CoinData.fromJson(Map <String, dynamic> json){
  //   return CoinData(
  //       currency: json['asset_id_quote'],
  //       rate: json['rate']
  //   );
  // }
}