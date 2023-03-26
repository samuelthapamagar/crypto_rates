import 'package:http/http.dart' as http;
import 'dart:convert';

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

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
// const apiKey = '0D57C00E-7CC9-4394-8623-75CB61138454';
const apiKey = 'BF71C80F-954F-4E5D-8D60-8CB584462263';

class CoinData {
  Future<dynamic> getCoinData(String? selectedCurrency) async {
    Map<String, String> cryptoPrices = {};

    for (String Crypto in cryptoList) {
      String requestURL =
          '$coinAPIURL/$Crypto/$selectedCurrency?apikey=$apiKey';

      http.Response response = await http.get(Uri.parse(requestURL));

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        // return lastPrice;
        cryptoPrices[Crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print('Status Code : ${response.statusCode} ');
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
