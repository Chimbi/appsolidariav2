import 'dart:convert';

Amparo amparoFromJson(String str) {
  final jsonData = json.decode(str);
  return Amparo.fromMap(jsonData);
}

String amparoToJson(Amparo data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Amparo {
  int amparo;
  int orden;
  int poliza;

  int concepto;
  int dias;
  String fechaInicial;
  String fechaFinal;

  double porcentaje;
  double valorAsegurado;
  double tasaAmparo;
  double prima;

  String descripcion;

  Amparo({
    this.amparo,
    this.orden,
    this.poliza,

    this.concepto,
    this.dias,
    this.fechaInicial,
    this.fechaFinal,

    this.porcentaje,
    this.valorAsegurado,
    this.tasaAmparo,
    this.prima,

    this.descripcion,
  });

  factory Amparo.fromMap(Map<String, dynamic> json) => new Amparo(
    amparo: json["amparo"],
    orden: json["orden"],
    poliza: json["poliza"],

    concepto: json["concepto"],
    dias: json["dias"],
    fechaInicial: json["fechaInicial"],
    fechaFinal: json["fechaFinal"],

    porcentaje: json["porcentaje"],
    valorAsegurado: json["valorAsegurado"],
    tasaAmparo: json["tasaAmparo"],
    prima: json["prima"],

    descripcion: json["descripcion"],
  );

  Map<String, dynamic> toMap() => {
    "concepto": concepto,
    "dias": dias,
    "fechaInicial": fechaInicial,
    "fechaFinal": fechaFinal,

    "porcentaje": porcentaje,
    "valorAsegurado": valorAsegurado,
    "tasaAmparo": tasaAmparo,
    "prima": prima,
  };
}
