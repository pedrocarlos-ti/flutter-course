import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Informe seus dados!";

  // Minimize the keyboard
  void _hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void _resetFields() {
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _infoText = "Informe seus dados!";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);

      if (imc < 18.6) {
        _infoText = "Abaixo do Peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 18.6 && imc < 24.9) {
        _infoText = "Peso Ideal (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 24.9 && imc < 29.9) {
        _infoText = "Levemente Acima do Peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 29.9 && imc < 34.9) {
        _infoText = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 34.9 && imc < 39.9) {
        _infoText = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 40) {
        _infoText = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _hideKeyboard(context),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Calculadora IMC'),
          backgroundColor: Colors.green,
          actions: [
            IconButton(onPressed: _resetFields, icon: Icon(Icons.refresh))
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(
                  Icons.person_outline,
                  size: 120,
                  color: Colors.green,
                ),
                TextFormField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ensira seu Peso!";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Peso (kg)',
                    labelStyle: TextStyle(color: Colors.green),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
                TextFormField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ensira sua altura!";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Altura (cm)',
                    labelStyle: TextStyle(color: Colors.green),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _calculate();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text('Calcular'),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                  ),
                ),
                Text(
                  _infoText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
