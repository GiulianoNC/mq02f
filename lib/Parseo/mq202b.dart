// To parse this JSON data, do
//
//     final mq0202BDatareq = mq0202BDatareqFromJson(jsonString);

import 'dart:convert';

Mq0202BDatareq mq0202BDatareqFromJson(String str) => Mq0202BDatareq.fromJson(json.decode(str));

String mq0202BDatareqToJson(Mq0202BDatareq data) => json.encode(data.toJson());

class Mq0202BDatareq {
  List<Mq0202BDatareqElement>? mq0202BDatareq;
  String? jdeStatus;

  Mq0202BDatareq({
    this.mq0202BDatareq,
    this.jdeStatus,
  });

  factory Mq0202BDatareq.fromJson(Map<String, dynamic> json) => Mq0202BDatareq(
    mq0202BDatareq: json["MQ0202B_DATAREQ"] == null ? [] : List<Mq0202BDatareqElement>.from(json["MQ0202B_DATAREQ"]!.map((x) => Mq0202BDatareqElement.fromJson(x))),
    jdeStatus: json["jde__status"],
  );

  Map<String, dynamic> toJson() => {
    "MQ0202B_DATAREQ": mq0202BDatareq == null ? [] : List<dynamic>.from(mq0202BDatareq!.map((x) => x.toJson())),
    "jde__status": jdeStatus,
  };
}

class Mq0202BDatareqElement {
  late var nroActivo;

  Mq0202BDatareqElement(nroActivo){
    this.nroActivo = nroActivo;
  }

   Mq0202BDatareqElement.fromJson(Map<String, dynamic> json) {
    nroActivo = json["NroActivo"];
  }


  Map<String, dynamic> toJson() => {
    "NroActivo": nroActivo,
  };
}
