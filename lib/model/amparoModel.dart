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

  String concepto; //Nombre del amparo
  String fechaInicial;
  String fechaFinal;
  int plazoAdic; //Plazo adicional del amparo en años

  double porcentaje;
  double valorAsegurado;
  double tasaAmparo;
  double tasaMinima;
  double prima;

  String descripcion;

  @override
  String toString() {
    return 'Amparo{concepto: $concepto}';
  }

  Amparo({
    this.amparo,
    this.orden,
    this.poliza,

    this.concepto,
    this.fechaInicial,
    this.fechaFinal,
    this.plazoAdic,

    this.porcentaje,
    this.valorAsegurado,
    this.tasaAmparo,
    this.tasaMinima,
    this.prima,

    this.descripcion,
  });

  factory Amparo.fromMap(Map<String, dynamic> json) => new Amparo(
    amparo: json["amparo"],
    orden: json["orden"],
    poliza: json["poliza"],

    concepto: json["concepto"],
    fechaInicial: json["fechaInicial"],
    fechaFinal: json["fechaFinal"],
    plazoAdic: json["plazoAdic"],

    porcentaje: json["porcentaje"],
    valorAsegurado: json["valorAsegurado"],
    tasaAmparo: json["tasaAmparo"],
    tasaMinima: json["tasaMinima"],
    prima: json["prima"],

    descripcion: json["descripcion"],
  );

  Map<String, dynamic> toMap() => {
    "concepto": concepto,
    "fechaInicial": fechaInicial,
    "fechaFinal": fechaFinal,
    "plazoAdic" :plazoAdic,

    "porcentaje": porcentaje,
    "valorAsegurado": valorAsegurado,
    "tasaAmparo": tasaAmparo,
    "tasaMinima": tasaMinima,
    "prima": prima,
  };
}
