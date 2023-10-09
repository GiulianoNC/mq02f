import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Herramientas/variables_globales.dart';

class MantenimientoScreen extends StatefulWidget {
  @override
  _MantenimientoScreenState createState() => _MantenimientoScreenState();
}

class _MantenimientoScreenState extends State<MantenimientoScreen> {
  String unidad = '';
  String serie = '';
  String nroEquipo = '';
  String tipoMantenimiento = '';
  String selectedVersion = '';

  List<Map<String, String>> mantenimientoOptions = [];

  @override
  void initState() {
    super.initState();
    _fetchMantenimientoOptions();
  }

  Future<void> _fetchMantenimientoOptions() async {
    final url = Uri.parse("http://quantumconsulting.servehttp.com:925/jderest/v3/orchestrator/MQ0200A_ORCH");

    var _headers = {
      "Authorization": autorizacionGlobal,
      'Content-Type': 'application/json',
    };
    var response = await http.post(url, headers: _headers).timeout(Duration(seconds: 60));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final formreq1 = jsonData["MQ0200A_FORMREQ_1"];

      for (final option in formreq1) {
        final descripcion = option["Descripcion"];
        final version = option["Version"];
        mantenimientoOptions.add({"Descripcion": descripcion, "Version": version});
      }

      setState(() {});
    } else {
      throw Exception("Error al cargar las opciones de mantenimiento");
    }
  }

  Future<void> _scanBarcode() async {
    // Implementa la lógica para escanear códigos de barras aquí
    // Luego, actualiza los valores de unidad, serie y nroEquipo según el escaneo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mantenimiento"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: "Unidad"),
              onChanged: (value) {
                setState(() {
                  unidad = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Serie"),
              onChanged: (value) {
                setState(() {
                  serie = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Nro Equipo"),
              onChanged: (value) {
                setState(() {
                  nroEquipo = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              items: mantenimientoOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option["Version"],
                  child: Text(option["Descripcion"]!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedVersion = value ?? '';
                });
              },
              decoration: InputDecoration(labelText: "Tipo de Mantenimiento"),
            ),
            ElevatedButton(
              onPressed: _scanBarcode,
              child: Text("Escanear Código de Barras"),
            ),
            ElevatedButton(
              onPressed: () {
                // Realiza la lógica para enviar los datos a través de un POST request
                // Puedes acceder a las variables unidad, serie, nroEquipo y selectedVersion aquí
              },
              child: Text("CONTINUAR"),
            ),
          ],
        ),
      ),
    );
  }
}
