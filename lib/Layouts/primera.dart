import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

//import '../Herramientas/global.dart';
import '../Herramientas/global.dart';
import '../Herramientas/variables_globales.dart';
import '../Parseo/mq0203a.dart';
import 'package:image_picker/image_picker.dart';

import 'Incidente.dart';

String baseUrl = direc;
String ordenTipo = "";
String estado = "";
String ordenN = "";
int? selectedOrderNumber;

class Primera extends StatefulWidget {
  @override
  State<Primera> createState() => _PrimeraState();
}

class _PrimeraState extends State<Primera> {
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

  late String api = "jderest/v3/orchestrator/MQ0203A_ORCH";

  late Future<List <Mq0203ADatareq>?>   _Listado;
  final controller = PageController();

  @override
  void disponse(){
    controller.dispose();
    super.dispose();
  }

  Future<List <Mq0203ADatareq>?> _getListado() async {
    var url = Uri.parse(baseUrl + api);
    var _payload = json.encode({
      "EMISOR": emisor,
      "ESTADO": estado,
    });
    var _headers = {
      "Authorization": autorizacionGlobal,
      'Content-Type': 'application/json',
    };

    List <Mq0203ADatareq> list = [];

    var response = await http.post(url, body: _payload, headers: _headers).timeout(Duration(seconds: 60));
    respuesta =response.body.toString();


    if (response.statusCode == 200 ) {
      final jsonData = jsonDecode(response.body);
      int numero = 0;

      for ( var item in jsonData["MQ0203A_DATAREQ"]){
        list.add(
          Mq0203ADatareq(item["Nro_Orden"],item["Tipo_Orden"],item["Descripcion"],item["Fecha"]),);

       // datos = (jsonData["MQ0203A_DATAREQ"] [numero]  ["ORDEN_NRO"]).toString();

        if (jsonData["MQ0203A_DATAREQ"][numero]["Nro_Orden"] != null) {
          datos = jsonData["MQ0203A_DATAREQ"][numero]["Nro_Orden"].toString();
        } else {
          datos = ''; // Otra cadena vacía o un valor predeterminado según tus necesidades.
        }
        lista.add(datos + "\n");
        numero ++;
        datos = "";
        item = "";
      }
      return list;
    } else {

      debugPrint("error");
    }

  }
  

  @override
  void initState() {
    super.initState();
    _Listado = _getListado();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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


        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/fondogris_solo.png'),
                fit: BoxFit.cover, // Ajusta la imagen al contenedor
              ),
            ),
            child: CupertinoScrollbar(
              isAlwaysShown: true, // Asegura que la barra de desplazamiento siempre se muestre
              thickness: 11.0, // Ajusta el grosor de la barra de desplazamiento
              radius: Radius.circular(7.0), // Ajusta el radio de las esquinas de la barra de desplazamiento
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "PENDIENTES",
                        style: TextStyle(
                          color: Color.fromRGBO(102, 45, 145, 30),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: _Listado,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        } else if (snapshot.hasData) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowHeight: 50,
                              columns: [
                                DataColumn(
                                  label: Text("TIPO N°"),
                                  numeric: true,
                                ),
                                DataColumn(
                                  label: Text("N°"),
                                  numeric: true,
                                ),
                                DataColumn(
                                  label: Text("INCONVENIENTE"),
                                  numeric: true,
                                ),
                                DataColumn(
                                  label: Text("FECHA"),
                                  numeric: true,
                                ),
                                DataColumn(
                                  label: Text("ADJUNTO"),
                                  numeric: true,
                                ),
                              ],
                              rows: _listaOrdenes(context, snapshot.data), // Asegúrate de pasar el contexto aquí
                            ),
                          );
                        } else {
                          return Center(child: Text("No hay datos"));
                        }
                      },
                    ),
                  ],
                ),  ),
            ),
        ),
      ),
    );
  }
}

List<DataRow> _listaOrdenes( BuildContext context ,data) {
  List<DataRow> ordenes = [];
  for (var orden in data) {
    ordenes.add(
      DataRow(
        cells: [
          DataCell(
            Container(
              padding: EdgeInsets.all(10), // Ajusta el padding a 0
              child: Text(
                orden.tipoOrden != null ? orden.tipoOrden.toString() : 'N/A',
                style: TextStyle(
                  fontSize: 9,
                  color: Color.fromRGBO(0, 0, 0, 30),
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.start, // Alinea el texto al principio del margen
              ),
            ),
          ),
          DataCell(
            Container(
              padding: EdgeInsets.all(10), // Ajusta el padding a 0
              child: Text(
                orden.nroOrden != null ? orden.nroOrden.toString() : 'N/A',
                style: TextStyle(
                  fontSize: 10, // Ajusta el tamaño del texto aquí
                  color: Color.fromRGBO(0, 0, 0, 30),
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                ),              textAlign: TextAlign.start,
              ),
            )
          ),
          DataCell(
              Container(
              padding: EdgeInsets.all(10), // Ajusta el padding a 0
                child: Text(
              orden.descripcion != null ? orden.descripcion.toString() : 'N/A',
              style: TextStyle(
                fontSize: 10, // Ajusta el tamaño del texto aquí
                color: Color.fromRGBO(0, 0, 0, 30),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
              ), textAlign: TextAlign.start,
            ), ),
          ),
          DataCell(
            Container(child :Text(
              orden.fecha != null ? orden.fecha.toString() : 'N/A',
              style: TextStyle(
                fontSize: 10, // Ajusta el tamaño del texto aquí
                color: Color.fromRGBO(0, 0, 0, 30),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
              ),              textAlign: TextAlign.center,
            ),)
          ),
          DataCell(IconButton(
                icon: Icon(
                  Icons.camera_alt,
                 color: Colors.grey, // Cambia el color del icono a azul (puedes ajustarlo a tu color preferido)
                   ),
            onPressed: () async {
              // Aquí capturas el número de orden al presionar el botón de la cámara
              final capturedOrderNumber = orden.nroOrden;
              print('El número de orden capturado es: $capturedOrderNumber');
              navigateToIncidenteScreen(context);
              nroOrdenGlobal = capturedOrderNumber.toString();

            },
              color: Colors.transparent, // Establece el fondo del botón como transparente
                )
            )
        ],
          ),
    );
  }
  return ordenes;
}

void navigateToIncidenteScreen(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Incidente()));
}





