import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Herramientas/boton.dart';
import '../Herramientas/global.dart';
import '../Herramientas/variables_globales.dart';
import 'Incidente.dart';

void main() => runApp(MaterialApp(home: motivo()));

class motivo extends StatefulWidget {
  const motivo({Key? key}) : super(key: key);

  @override
  State<motivo> createState() => _motivoState();
}

class _motivoState extends State<motivo> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionFocusNode = FocusNode();

  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();

  var valueD ="";

  int _selectedIndex = 0;
  bool loading = false; // Nuevo estado para controlar la visibilidad del indicador de progreso

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
          title:
          Row(
              children:[
                Container(
                  margin: EdgeInsets.fromLTRB(5, 22, 20, 10),
                  //padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  // alignment: Alignment.center,
                  child: Image.asset("images/nombre.png",
                    width: 150,
                    height: 50,
                  ),
                ),
                Expanded(child: Container()), // Esto empujará el ícono hacia la derecha
                Padding(
                  padding: EdgeInsets.only(top: 10, right: 10), // Ajusta estos valores según tus preferencias
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.grey, // Cambia el color del ícono de flecha
                  ),
                ),
              ]
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

                              Form(
                                key: _formKey, // Asigna el _formKey al formulario
                                child: Column(
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
                                     controller: myController,
                                     maxLength: 30,
                                     decoration: InputDecoration(
                                       filled: true,
                                       fillColor: Colors.white, // Establece el color de fondo a blanco
                                       hintText: "MÁXIMO 30 CARACTERES",
                                     ),
                                     validator: (value) {
                                       myController.text = value!;
                                       if (value!.isEmpty) {
                                         return 'Por favor, complete el campo de descripción';
                                       }
                                       return null;
                                     },
                                   ),
                                 ],
                                )
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
                                controller: myController2,
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
                                controller: myController3,
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
                                      setState(() {
                                        loading = true; // Muestra el indicador de progreso al hacer clic
                                      });

                                      try{
                                        if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                                          var baseUrl =  direc;
                                          late var api = "/jderest/v3/orchestrator/MQ0201A_ORCH";
                                          var url = Uri.parse(baseUrl + api);
                                          var _payload = json.encode({
                                            "Nro_Activo": nroActivoGlobal,
                                            "Descripcion1": myController.text,
                                            "Descripcion2": myController2.text,
                                            "Comentario": myController3.text,
                                            "P48201_Version": version,
                                          });
                                          var _headers = {
                                            "Authorization": autorizacionGlobal,
                                            'Content-Type': 'application/json',
                                          };
                                          var response = await http.post(url, body: _payload, headers: _headers).timeout(Duration(seconds: 60));
                                          respuesta =response.body.toString();

                                          if (response.statusCode == 200) {
                                            Map<String, dynamic> responseData = json.decode(response.body);
                                            if (responseData.containsKey("Nro_Orden")) {
                                              nroOrdenGlobal = responseData["Nro_Orden"].toString();

                                              navigateToIncidenteScreen(context);

                                            }
                                            if (responseData.containsKey("jde__status") && responseData["jde__status"] == "SUCCESS") {
                                              // El servidor devolvió una respuesta exitosa, puedes navegar a "/incidente" aquí.
                                              Navigator.pushNamed(context, "/incidente");
                                            }
                                          } else {
                                            // Manejar el caso en el que no se pudo completar la solicitud (por ejemplo, un error de red).
                                            _showSnackBar(context);
                                          }


                                          Navigator.pushNamed(context, "/incidente");
                                        }else {
                                          _showSnackBar(context);

                                        }
                                      } catch(e){
                                        // Manejar errores
                                        print('Error: $e');
                                      }finally{
                                        // Asegúrate de restablecer loading a false después de completar la tarea, ya sea exitosa o con errores.
                                        setState(() {
                                          loading = false;
                                        });
                                      }

                                    },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Text("CONTINUAR"), // Botón "CONTINUAR"
                                          if (loading)
                                            CircularProgressIndicator(), // Indicador de progreso (visible cuando loading es true)
                                        ],)
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
void navigateToIncidenteScreen(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Incidente()));
}