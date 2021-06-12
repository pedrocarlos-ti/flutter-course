import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

var request = Uri.parse("https://api.hgbrasil.com/finance?key=45e22870");

void main() {
  runApp(MaterialApp(home: Home()));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return jsonDecode(response.body)["results"]["currencies"];
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar = 0;
  double euro = 0;

  final TextEditingController realController = TextEditingController();
  final TextEditingController dolarController = TextEditingController();
  final TextEditingController euroController = TextEditingController();

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void onChangeText(String currency, String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double value = double.parse(text.replaceAll(',', '.'));

    switch (currency) {
      case "Reais":
        dolarController.text = (value / dolar).toStringAsFixed(2);
        euroController.text = (value / euro).toStringAsFixed(2);
        break;
      case "Dolares":
        realController.text = (value * this.dolar).toStringAsFixed(2);
        euroController.text = (value * this.dolar / euro).toStringAsFixed(2);
        break;
      case "Euros":
        realController.text = (value * this.euro).toStringAsFixed(2);
        dolarController.text = (value * this.euro / dolar).toStringAsFixed(2);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversor de Moedas \$'),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: Text('Carregando Dados..'));
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Erro ao Carregar os Dados :('));
              } else {
                dolar = snapshot.data?["USD"]["buy"];
                euro = snapshot.data?["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.monetization_on,
                          size: 150, color: Colors.amber),
                      buildTextField(
                          "Reais", "R\$", realController, onChangeText),
                      Divider(),
                      buildTextField(
                          "Dolares", "US\$", dolarController, onChangeText),
                      Divider(),
                      buildTextField(
                          "Euros", "€", euroController, onChangeText),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function onChanged) {
  return TextField(
    controller: controller,
    onChanged: (value) => onChanged(label, value),
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
  );
}
