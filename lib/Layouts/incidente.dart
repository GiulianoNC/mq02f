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

  //PARA MOSTRAR MENSAJE EXITOSO
  OverlayEntry? _overlayEntry;

  void showCustomMessage(BuildContext context, String message) {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 180,
          left: 50,
          right: 50,
          child: Material(
            color: Colors.transparent,
            child: Container(
              alignment: Alignment.center,
              child: Card(
                color: Colors.grey, // Color de fondo del mensaje
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context)!.insert(_overlayEntry!);

    // Cierra el mensaje después de un tiempo (por ejemplo, 2 segundos)
    Future.delayed(Duration(seconds: 2), () {
      _overlayEntry?.remove();
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }


  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      showCustomMessage(context, 'AGREGADO EXITOSAMENTE');

    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      showCustomMessage(context, 'AGREGADO EXITOSAMENTE');
    }
  }

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

  String baseUrl =direc;
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

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Envío Exitoso", style: TextStyle(
          color: Color.fromRGBO(102, 45, 145, 30), // Color RGB (rojo, verde, azul, opacidad)
          fontSize: 20.0, // Puedes ajustar el tamaño de la fuente según tus preferencias
        ),),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(212 , 20, 90, 50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            child: Text('OK'),
            onPressed: () {
              Navigator.pushNamed(context, "/congrats");
            },
          ),
          ],
        );
      },
    );
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
          title: Row(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        getImage();
                      },
                      icon: Icon(Icons.photo_camera_back_rounded),
                      label: Text("ABRIR GALERIA"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onPrimary: Colors.blueGrey,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        getImageFromCamera();
                      },
                      icon: Icon(Icons.camera_alt),
                      label: Text("ABRIR CAMARA"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onPrimary: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                  child: Center(
                      child:MyElevatedButton(
                        onPressed: () async {
                          try{
                            setState(() {
                              loading = true; // Restablece loading a false después de que la tarea esté completa
                            });
                          await  enviarSolicitud(); // Llama a la función para enviar la solicitud
                          showConfirmationDialog(context); // Muestra el diálogo de confirmación
                          }catch(e){
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
                              Text("FINALIZAR"), // Botón "CONTINUAR"
                              if (loading)
                                CircularProgressIndicator(), // Indicador de progreso (visible cuando loading es true)
                            ],)
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
