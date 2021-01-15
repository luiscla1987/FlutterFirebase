import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Lista de Compras",
    theme: ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      accentColor: Colors.purple,
    ),
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _compras = List();
  String _input = "";

  _createLista() {
    DocumentReference documentReference =
        Firestore.instance.collection("compras").document(_input);

    Map<String, String> compras = {"compraTitle": _input};

    documentReference
        .setData(compras)
        .whenComplete(() => {print("$_input criado")});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Compras"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _compras.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(_compras[index]),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(_compras[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _compras.removeAt(index);
                      });
                    },
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text("Adicione um item."),
                  content: TextField(
                    onChanged: (String value) {
                      _input = value;
                    },
                  ),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        _createLista();
                        Navigator.of(context).pop();
                      },
                      child: Text("Adicionar"),
                    ),
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
