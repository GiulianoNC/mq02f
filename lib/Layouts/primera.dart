import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Herramientas/global.dart';
import '../Herramientas/variables_globales.dart';
import '../Parseo/mq0203a.dart';

String baseUrl = "http://quantumconsulting.servehttp.com:925/";
String ordenTipo = "";
String estado = "";
String ordenN = "";

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
      "EMISOR":"3",
      "ESTADO": "MA",
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
          Mq0203ADatareq(item["Nro_Orden"],item["Nro_Orden"],item["Descripcion"],item["Fecha"]),);

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
   // final double drawerWidth = MediaQuery.of(context).size.width * 0.3;
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: <Color>[
                  Color.fromRGBO(255, 255, 255, 30),
                  Color.fromRGBO(255, 255, 255, 50),
                ],
              ),
            ),
            width: MediaQuery.of(context).size.width / 8, // Define el ancho deseado (1/4 de la pantalla)
            child: ListView(
              children: [
                DrawerHeader(
                  child: Text(
                    'Menú',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
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
                ListTile(
                  title: Text('Configuración',
                    style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),),
                  selected: _selectedIndex == 0,
                  onTap: () {
                    _onMenuItemSelected(0);
                  },
                ),
                ListTile(
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
                  title: Text('Nuevo Correctivo',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,),),
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
          padding: const EdgeInsets.only(bottom: 80),
          child: PageView(
            controller: controller,
            children: [
              Container(
                child: Center(child:
                FutureBuilder(
                    future:_Listado,
                    builder:(context, snapshot) {
                      if (snapshot.hasData){
                        return GridView.count(
                          crossAxisCount: 2,
                          scrollDirection: Axis.vertical,
                          children: _listaOrdenes( snapshot.data ),
                        );
                      } else if (!snapshot.hasData) {
                        Text("No hay datos");
                      } else if( snapshot.hasError);{
                        Center (child :Text ("Estas al día con las ordenes OR "));
                      }
                      return  Center( child : CircularProgressIndicator(),
                      );
                    }
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List  <Widget> _listaOrdenes( data){
  List<Widget> ordenes = [];
  for  (var orden in data!){
    ordenes.add(
        Card(
          child: Center(
              child : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0.0),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                      onPressed: () {

                      },
                      child:Ink(
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  //colors: [Color.fromRGBO(212, 20, 90, 10), Color.fromRGBO(102, 45, 145, 50)],
                                  colors: [Color.fromRGBO(212, 20, 90, 10), Color.fromRGBO(212, 20, 90, 10)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: const EdgeInsets.all(10),
                            constraints: const BoxConstraints(minWidth: 88.0),
                            child: Text(
                              orden.nroOrden != null ? orden.nroOrden.toString() : 'N/A',
                              textAlign: TextAlign.center,
                            ),
                          )
                      )
                  ),
                  RichText(
                    text: TextSpan(
                        text:   orden.fecha.toString() + " || " + orden.tipoOrden.toString() +   '\n',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(102, 45, 145, 30),
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text:   orden.descripcion.toString()+ "  " +  '\n',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(102, 45, 145, 30),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ]
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
          ),
        )
    );
  }
  return ordenes;
}

