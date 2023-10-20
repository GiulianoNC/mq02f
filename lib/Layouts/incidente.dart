import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mq02f/Herramientas/boton.dart';
import 'package:http/http.dart' as http;
import '../Herramientas/global.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:http_parser/http_parser.dart';

import '../Herramientas/variables_globales.dart';

class Incidente extends StatefulWidget {
  const Incidente({Key? key}) : super(key: key);

  @override
  State<Incidente> createState() => _IncidenteState();
}

class _IncidenteState extends State<Incidente> {

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      print("imagen agregada");
    }
  }

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

  String baseUrl = direc;
  late String api = "jderest/v2/file/upload";

  String obtenerContenidoArchivo(String fileName) {
    try {
      final file = File(fileName);
      return file.readAsStringSync();
    } catch (e) {
      print('Error al leer el archivo: $e');
      return '';
    }
  }

  Future<void> enviarSolicitud() async {
    if (_image != null) {
      var url = Uri.parse(baseUrl + api);
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = autorizacionGlobal;
      request.headers['Content-Type'] = "multipart/related";

      try {
        var jsonTemplatePath = 'assets/MANTENIMIENTO.json';
        var extension = path.extension(jsonTemplatePath);

        if (extension == '.json') {
          var jsonString = await rootBundle.loadString(jsonTemplatePath);
          var jsonData = json.decode(jsonString);
          jsonData["moStructure"] = "GT4801A";
          jsonData["moKey"] = nroOrdenGlobal;
          jsonData["file"]["fileName"] = path.basename(_image!.path);
          jsonData["file"]["fileLocation"] = _image!.path;
          jsonData["file"]["sequence"] = 1;

          var jsonPart = http.MultipartFile.fromString('moAdd', json.encode(jsonData),
              filename: 'MANTENIMIENTO.json', contentType: MediaType('application', 'json'));
          request.files.add(jsonPart);

          var imagePart = await http.MultipartFile.fromPath('file', _image!.path);
          request.files.add(imagePart);

          var response = await request.send();

          if (response.statusCode == 200) {
            print('Solicitud exitosa');
            var responseString = await response.stream.bytesToString();
            print(responseString);
          } else {
            var responseString = await response.stream.bytesToString();
            print('Fallo en la solicitud: ${response.reasonPhrase}');
            print('Detalles: $responseString');
          }
        } else {
          print('El archivo no tiene la extensión .json');
          return;
        }
      } catch (e) {
        print('Error al enviar la solicitud: $e');
      }
    } else {
      print('No se seleccionó ninguna imagen');
    }
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
        body:
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/fondogris_solo.png'),
              fit: BoxFit.cover, // Ajusta la imagen al contenedor
          ),
        ),
        child:
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Center(
                  child:Text(
                    "INCIDENTE",
                    style: TextStyle(
                      color: Color.fromRGBO(102, 45, 145, 30),
                      fontSize: 30,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                )
              ),
              SizedBox(height: 20),
              Container(
                child: Center(
                  child:  Text(
                    "N° DE ORDEN",
                    style: TextStyle(
                      color: Color.fromRGBO(102, 45, 145, 30),
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                )
              ),
              SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Establece el color de fondo del contenedor como blanco
                  ),
                  child: Center(
                      child: Text(
                        nroOrdenGlobal, // Aquí se muestra la variable global nroOrden
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                  )
              ),
              SizedBox(height: 40),
              Container(
                child: Center(
                  child: ElevatedButton.icon(
                  onPressed: () {
                    getImage(); // Llama a la función para obtener la imagen
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text("AGREGAR IMÁGENES"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent, // Color del botón
                    onPrimary: Colors.blueGrey, // Color del texto del botón
                  ),
                ),
                )
              ),
              SizedBox(height: 20),
              Container(
                  child: Center(
                      child:MyElevatedButton(
                        onPressed: () {
                          // Lógica para finalizar
                          enviarSolicitud(); // Llama a la función para enviar la solicitud
                        },
                        child: Text("FINALIZAR"),
                      ),
                  )
              )
            ],
          ),
        ),
      )
    ));
  }
}
