/*import 'dart:convert';

Mq0203A mq0203AFromJson(String str) => Mq0203A.fromJson(json.decode(str));

String mq0203AToJson(Mq0203A data) => json.encode(data.toJson());

class Mq0203A {
  List<Mq0203ADatareq>? mq0203ADatareq;
  late var jdeStatus;

  Mq0203A({
    this.mq0203ADatareq,
    this.jdeStatus,
  });


  factory Mq0203A.fromJson(Map<String, dynamic> json) => Mq0203A(
    mq0203ADatareq: json["MQ0203A_DATAREQ"] == null ? [] : List<Mq0203ADatareq>.from(json["MQ0203A_DATAREQ"]!.map((x) => Mq0203ADatareq.fromJson(x))),
    jdeStatus: json["jde__status"],
  );

  Map<String, dynamic> toJson() => {
    "MQ0203A_DATAREQ": mq0203ADatareq == null ? [] : List<dynamic>.from(mq0203ADatareq!.map((x) => x.toJson())),
    "jde__status": jdeStatus,
  };

}

class Mq0203ADatareq {
  late var nroOrden;
  late var tipoOrden;
  late var descripcion;
  late var fecha;

  Mq0203ADatareq(nroOrden,tipoOrden,descripcion,fecha){
    this.nroOrden = nroOrden;
    this.tipoOrden = tipoOrden;
    this.descripcion =descripcion;
    this.fecha= fecha;
  }

   Mq0203ADatareq.fromJson(Map<String, dynamic> json){
     nroOrden =  json["Nro_Orden"];
     tipoOrden =  json["Tipo_Orden"];
     descripcion = json["Descripcion"];
     fecha =  json["Fecha"] ;
   }

}*/

import 'dart:convert';

Mq0203A mq0203AFromJson(String str) => Mq0203A.fromJson(json.decode(str));

String mq0203AToJson(Mq0203A data) => json.encode(data.toJson());

class Mq0203A {
  List<Mq0203ADatareq>? mq0203ADatareq;
  String? jdeStatus;

  Mq0203A({
    this.mq0203ADatareq,
    this.jdeStatus,
  });

  factory Mq0203A.fromJson(Map<String, dynamic> json) => Mq0203A(
    mq0203ADatareq: json["MQ0203A_DATAREQ"] == null ? [] : List<Mq0203ADatareq>.from(json["MQ0203A_DATAREQ"]!.map((x) => Mq0203ADatareq.fromJson(x))),
    jdeStatus: json["jde__status"],
  );

  Map<String, dynamic> toJson() => {
    "MQ0203A_DATAREQ": mq0203ADatareq == null ? [] : List<dynamic>.from(mq0203ADatareq!.map((x) => x.toJson())),
    "jde__status": jdeStatus,
  };
}

class Mq0203ADatareq {
  late var nroOrden;
  late var tipoOrden;
  late var descripcion;
  late var fecha;

  Mq0203ADatareq(nroOrden,tipoOrden,descripcion,fecha){
    this.nroOrden = nroOrden;
    this.tipoOrden = tipoOrden;
    this.descripcion =descripcion;
    this.fecha= fecha;
  }

  Mq0203ADatareq.fromJson(Map<String, dynamic> json){
    nroOrden =  json["Nro_Orden"];
    tipoOrden =  json["Tipo_Orden"];
    descripcion = json["Descripcion"];
    fecha =  json["Fecha"] ;
  }

  Map<String, dynamic> toJson() => {
    "Nro_Orden": nroOrden,
    "Tipo_Orden": tipoOrden,
    "Descripcion": descripcion,
    "Fecha": "${fecha!.year.toString().padLeft(4, '0')}-${fecha!.month.toString().padLeft(2, '0')}-${fecha!.day.toString().padLeft(2, '0')}",
  };
}
