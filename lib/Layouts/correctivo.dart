import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Herramientas/boton.dart';
import '../Herramientas/global.dart';
import '../Herramientas/variables_globales.dart';
import '../Parseo/mq202b.dart';
import 'Incidente.dart';

void main() => runApp(MaterialApp(home: MantenimientoScreen()));

class MantenimientoScreen extends StatefulWidget {
  @override
  _MantenimientoScreenState createState() => _MantenimientoScreenState();
}

class _MantenimientoScreenState extends State<MantenimientoScreen> {
  String selectedOption = "";
  List<Map<String, String>> options = [];
  String baseUrl = direc;

  // Lista de estados de los checkboxes
  List<bool> checkboxStates = [false, false, false];


  // Declarar los controladores aquí
  TextEditingController textControllerUnidad = TextEditingController();
  TextEditingController textControllerSerie = TextEditingController();
  TextEditingController textControllerNumeroEquipo = TextEditingController();
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
  @override
  void initState() {
    super.initState();
    _fetchOptions();
  }

  //para el tipo de mantenimiento de menu desplegable
  Future<void> _fetchOptions() async {

    late String api = "jderest/v3/orchestrator/MQ0200A_ORCH";

    var url = Uri.parse(baseUrl + api);

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
        options.add({"Descripcion": descripcion, "Version": version});
      }

      setState(() {});
    } else {
      throw Exception("Error al cargar las opciones de mantenimiento");
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home :  Scaffold(
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
            Container(
              margin: EdgeInsets.fromLTRB(5, 22, 20, 10),
              //padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              // alignment: Alignment.center,
              child: Image.asset("images/nombre.png",
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

          body:Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/fondogris_solo.png'),
                  fit: BoxFit.cover,
                )
            ),
            constraints: BoxConstraints.expand(), // Hacer que el Container ocupe todo el espacio disponible
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "SELECCIONAR UNA OPCIÓN",
                      style: TextStyle(
                        color: Color.fromRGBO(102, 45, 145, 30),
                        fontSize: 20, // Tamaño de fuente del título
                        fontWeight: FontWeight.bold, // Fuente en negrita
                      ),
                    ),
                  ),
                  OptionRow(
                    checkpointName: 'UNIDAD',
                    textController: textControllerUnidad,
                    onSelected: (value) {
                      _onCheckboxSelected(0, value);
                    },
                    isChecked: checkboxStates[0], // Agrega el estado del primer checkbox
                  ),
                  OptionRow(
                    checkpointName: 'SERIE',
                    textController: textControllerSerie,
                    onSelected: (value) {
                      _onCheckboxSelected(1, value);
                    },      isChecked: checkboxStates[1], // Agrega el estado del segundo checkbox
                  ),
                  OptionRow(
                    checkpointName: 'N° DE EQUIPO',
                    textController: textControllerNumeroEquipo,
                    onSelected: (value) {
                      _onCheckboxSelected(2, value);
                    },      isChecked: checkboxStates[2], // Agrega el estado del tercer checkbox

                  ),

                  DropdownButtonFormField<String>(
                    items: options
                        .map((option) => DropdownMenuItem<String>(
                      value: option["Version"],
                      child: Text(
                        option["Descripcion"]!,
                        style: TextStyle(color: Colors.grey), // Color del texto del elemento del menú
                      ),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value ?? '';
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Tipo de Mantenimiento",
                      labelStyle: TextStyle(color: Colors.deepPurple), // Color del texto del label
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple), // Color del borde cuando no está enfocado
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey), // Color del borde cuando está enfocado
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down, // Icono de flechita
                      color: Colors.grey, // Cambia el color de la flechita
                    ),
                  ),

                  MyElevatedButton(
                    onPressed: () async {
                      version = selectedOption;


                      Future<void> _fetchData(String endpoint, Map<String, dynamic> body) async {
                        var url = Uri.parse(direc + endpoint);
                        print(direc + endpoint);
                        var _headers = {
                          "Authorization": autorizacionGlobal,
                          'Content-Type': 'application/json',
                        };

                        var response = await http.post(url, headers: _headers, body: jsonEncode(body));

                        var jsonData = json.decode(response.body);
                        print(jsonData);


                           if (jsonData != null) {
                          var dataReq = jsonData[endpoint + '_DATAREQ'];
                          if (dataReq != null && dataReq.length > 0) {
                            var nroActivo = dataReq[0]['NroActivo'];
                            if (nroActivo != null) {
                              print('NroActivo: $nroActivo');
                              nroOrdenGlobal = nroActivo.toString();
                              navigateToIncidenteScreen(context);
                            } else {
                              throw Exception("Error: El campo 'NroActivo' es nulo");
                            }
                          } else {
                            navigateToIncidenteScreen(context);
                            throw Exception("Error: La lista 'DATAREQ' está vacía o nula");
                          }
                        } else {
                          throw Exception("Error: El objeto jsonData es nulo");
                        }
                      }

                      if (checkboxStates[0]) {
                        await _fetchData('jderest/v3/orchestrator/MQ0202B_ORCH', {"UNIDAD": textControllerUnidad.text});
                        nroActivoGlobal = textControllerUnidad.text.toString();
                      } else if (checkboxStates[1]) {
                        await _fetchData('jderest/v3/orchestrator/MQ0202C_ORCH', {"SERIE": textControllerSerie.text});
                        nroActivoGlobal = textControllerSerie.text.toString();
                      } else if (checkboxStates[2]) {
                        await _fetchData('jderest/v3/orchestrator/MQ0202D_ORCH', {"NRO_EQUIPO": textControllerNumeroEquipo.text});
                        nroActivoGlobal = textControllerNumeroEquipo.text.toString();

                      }
                    },
                    child: Text("CONTINUAR"),
                  ),
                ],
              ),
            ),
          )
      )
    );
  }



  // Método para manejar los cambios en los checkboxes
  void _onCheckboxSelected(int index, String value) {
    setState(() {
      // Cambia el estado del checkbox seleccionado y limpia el texto si está desmarcado
      for (var i = 0; i < checkboxStates.length; i++) {
        if (i == index) {
          checkboxStates[i] = true;
        } else {
          checkboxStates[i] = false;
          // Limpia el texto en los campos de texto correspondientes
          if (i == 0) {
            textControllerUnidad.text = '';
          } else if (i == 1) {
            textControllerSerie.text = '';
          } else if (i == 2) {
            textControllerNumeroEquipo.text = '';
          }
        }
      }
      // Asigna la opción seleccionada
      selectedOption = value;
    });
  }
}

//PARA LO DEL CHECKBOX
class OptionRow extends StatefulWidget {
  final String checkpointName;
  final TextEditingController textController;
  final ValueChanged<String> onSelected;
  final bool isChecked; // Añade el parámetro isChecked

  OptionRow({
    required this.checkpointName,
    required this.textController,
    required this.onSelected,
    required this.isChecked, // Añade el parámetro isChecked

  });


  @override
  _OptionRowState createState() => _OptionRowState();
}

class _OptionRowState extends State<OptionRow> {
  bool isChecked = false;
  void scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color personalizado de la barra de escaneo
      'Cancelar', // Texto del botón para cancelar el escaneo
      true, // Muestra una ventana de escaneo con flash
      ScanMode.DEFAULT, // Modo de escaneo predeterminado
    );

    if (barcodeScanRes != '-1') {
      setState(() {
        widget.textController.text = barcodeScanRes;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;
              widget.onSelected(isChecked ? widget.checkpointName : '');
            });
          },
          side: BorderSide(color: Colors.grey),
          activeColor: Colors.grey,
          checkColor: Colors.deepPurple,
        ),
        Expanded(
          child: TextField(
            controller: widget.textController,
            enabled: isChecked,
            decoration: InputDecoration(
              labelText: widget.checkpointName,
              labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            style: TextStyle(color: Colors.black),
          ),
        ),
        if (isChecked)
          ElevatedButton.icon(
            onPressed: () {
              // Agrega la lógica de escaneo aquí
              scanBarcode();
            },
            icon: Icon(Icons.barcode_reader),
            label: Text("Escanear"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
            ),
          ),
      ],
    );
  }
}



void navigateToIncidenteScreen(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Incidente()));
}

