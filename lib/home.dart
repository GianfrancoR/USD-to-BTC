import 'package:flutter/material.dart';
import 'main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final dolarController = TextEditingController();
  final bitcoinController = TextEditingController();

  double dolar;
  double bitcoin;

  void _clearAll(){
    dolarController.text = "";
    bitcoinController.text = "";
  }
  void _dolarChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    bitcoinController.text = (dolar * this.dolar / bitcoin).toStringAsFixed(6);
  }
  void _bitcoinChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double bitcoin = double.parse(text);
    dolarController.text = (bitcoin * this.bitcoin / dolar).toStringAsFixed(6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("USD to BTC"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch(snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text("Cargando Datos...",
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 25.0),
                        textAlign: TextAlign.center,)
                  );
                default:
                  if(snapshot.hasError){
                    return Center(
                        child: Text("Error al cargar los Datos...",
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 25.0),
                          textAlign: TextAlign.center,)
                    );
                  } else {
                    dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    bitcoin = snapshot.data["results"]["currencies"]["BTC"]["buy"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(Icons.monetization_on, size: 150, color: Colors.amber),
                          buildTextField("Dolares: ", "US\$", dolarController, _dolarChanged),
                          Divider(),
                          buildTextField("Bitcoin: ", "₿", bitcoinController, _bitcoinChanged),
                        ],
                      ),
                    );
                  }
              }
            })
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix
    ),
    style: TextStyle(
        color: Colors.amber, fontSize: 25.0
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}