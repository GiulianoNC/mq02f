import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Herramientas/boton.dart';
import '../Herramientas/global.dart';
import '../Herramientas/variables_globales.dart';

void main() => runApp(MaterialApp(home: motivo()));

class motivo extends StatefulWidget {
  const motivo({Key? key}) : super(key: key);

  @override
  State<motivo> createState() => _motivoState();
}

class _motivoState extends State<motivo> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionFocusNode = FocusNode();

  int _selectedIndex = 0;

  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Cierra el menú lateral
    // Agrega la lógica para navegar a las pantallas correspondientes aquí
    switch (index) {
      case 0:
        Navigator.pushNamed(context, "/login");
        break;
      case 1:
        Navigator.pushNamed(context, "/congrats");
        break;
      case 2:
        Navigator.pushNamed(context, "/correctivo");
        break;
    }
  }

  void _showSnackBar(BuildContext context) {
    _descripcionFocusNode.requestFocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Por favor, complete el campo de descripción'),
      ),
    );
  }

  @override
  void dispose() {
    _descripcionFocusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: <Color>[
                  Color.fromRGBO(102, 45, 145, 30),
                  Color.fromRGBO(212, 20, 90, 50),
                ],
              ),
            ),
          ),
          title: Container(
            margin: EdgeInsets.fromLTRB(5, 22, 20, 10),
            child: Image.asset(
              "images/nombre.png",
              width: 150,
              height: 50,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20.0),
            child: const SizedBox(),
          ),
        ),
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent, // Establece el fondo del Drawer como transparente
            ),
            width: MediaQuery.of(context).size.width / 8, // Define el ancho deseado (1/4 de la pantalla)
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: <Color>[
                        Color.fromRGBO(102, 45, 145, 30),
                        Color.fromRGBO(212, 20, 90, 50),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/nombre2.png',
                        width: 150,
                        height: 70,
                      ),
                      Text(
                        '\nQTM - MANTENIMIENTO\n          CORRECTIVO\n\n',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.settings,
                    color: Colors.grey, // Cambia el color del icono
                  ),
                  title: Text('Configuración',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  selected: _selectedIndex == 0,
                  onTap: () {
                    _onMenuItemSelected(0);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.checklist),
                  title: Text('Pendientes',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),),
                  selected: _selectedIndex == 1,
                  onTap: () {
                    _onMenuItemSelected(1);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.library_add_check_rounded),
                  title: Text('Nuevo Correctivo',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  selected: _selectedIndex == 2,
                  onTap: () {
                    _onMenuItemSelected(2);
                  },
                ),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/fondogris_solo.png'),
              fit: BoxFit.cover, // Ajusta la imagen al contenedor
            ),
          ),
          child: Builder(
            builder: (BuildContext context){
              return Center(
                child: CupertinoScrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            "CARGA DE INCONVENIENTE",
                            style: TextStyle(
                              color: Color.fromRGBO(102, 45, 145, 30),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity, // Ocupa  el ancho disponible
                                child: Center(
                                  child : Text(
                                    "DESCRIPCIÓN",
                                    style: TextStyle(
                                      color: Color.fromRGBO(102, 45, 145, 30),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),

                              TextFormField(
                                maxLength: 30,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingrese una descripción';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white, // Establece el color de fondo a blanco
                                  hintText: "MÁXIMO 30 CARACTERES",
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: double.infinity, // Ocupa  el ancho disponible
                                child: Center(
                                  child:  Text(
                                    "FALLO",
                                    style: TextStyle(
                                      color: Color.fromRGBO(102, 45, 145, 30),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                maxLines: 5, // Ajusta el número máximo de líneas que el campo puede tener
                                minLines: 5 ,// Ajusta el número mínimo de líneas que el campo puede tener
                                maxLength: 80,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white, // Establece el color de fondo a blanc
                                  hintText: "MÁXIMO 80 CARACTERES",
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: double.infinity, // Ocupa  el ancho disponible
                                child: Center(
                                  child:  Text(
                                    "COMENTARIOS",
                                    style: TextStyle(
                                      color: Color.fromRGBO(102, 45, 145, 30),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                maxLines: 15, // Ajusta el número máximo de líneas que el campo puede tener
                                minLines: 10, // Ajusta el número mínimo de líneas que el campo puede tener
                                maxLength: 200,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white, // Establece el color de fondo a blanc
                                  hintText: "MÁXIMO 200 CARACTERES",
                                ),
                              ),
                              Container(
                                width: double.infinity, // Ocupa  el ancho disponible
                                child: Center(
                                  child: MyElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        var baseUrl =  direc;
                                        late var api = "/jderest/v3/orchestrator/MQ0201A_ORCH";
                                        var url = Uri.parse(baseUrl + api);
                                        var _payload = json.encode({
                                          "Nro_Activo": " NroActivo",
                                          "Descripcion1": "DESCRPCION",
                                          "Descripcion2": "FALLO",
                                          "Comentario": "COMENTARIO",
                                          "P48201_Version": version,
                                        });
                                        var _headers = {
                                          "Authorization": autorizacionGlobal,
                                          'Content-Type': 'application/json',
                                        };
                                        var response = await http.post(url, body: _payload, headers: _headers).timeout(Duration(seconds: 60));
                                        respuesta =response.body.toString();

                                        // Navigator.pushNamed(context, "/motivo");
                                      }else {
                                        _showSnackBar(context);
                                      }
                                    },
                                    child: Text("CONTINUAR"),
                                  ),
                                ),
                              )

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              );
            },
          ),
        ),
      ),
    );
  }
}
