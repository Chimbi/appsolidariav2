import 'dart:convert';
import 'package:appsolidariav2/model/afianzaModel.dart';
import 'package:appsolidariav2/model/amparoModel.dart';
import 'package:appsolidariav2/model/intermedModel.dart';

Poliza polizaFromJson(String str) {
  final jsonData = json.decode(str);
  return Poliza.fromMap(jsonData);
}

String polizaToJson(Poliza data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Poliza {
  String descAgencia;
  String descPuntoVenta;
  String descRamo = "Cumplimiento";
  String descTipoPoliza;  // Particular, Estatal, Servicios Publicos Domiciliarios
  //Poliza Ecopetrol, Empresas públicas con régimen privado de contratación

  int poliza;  //Consecutivo sistema, revisar si se necesita
  String fechaEmision;
  int numPoliza;
  int temporario;
  int estado;

  Intermediario intermediarios;
  //version 1: 1 Intermediario version2: varios intermediarios
  double comision;
  int cupoOperativo;

  Afianzado afianzado;
  //version 1: 1 Afianzado version2: varios afianzados
  String clausulado;  //Texto parametrizable variable texto: texto

  int plazoEjecucion;
  int retroactividad;
  //divisa solo en pesos
  //cobra IVA: Siempre se cobra IVA
  String descTipoOperacion;  //100% Compañia, Coaseguro Cedido, Coaseguro Aceptado
  //Version 2: Permitir Coaseguro Cedido, Coaseguro Aceptado
  //Incluir en el modelo List<CiasSeguros>


  String descTipoNegocio;
  //Tipo de Negocio: Contrato, contrato de arrendamiento, contrato de consultoria,
  //contrato de ejecucion de obra, contrato de interventoria, contrato de prestacion de servicios
  int contratante;
  int objeto;
  String numeroContrato;
  double valorContrato;
  String fechaInicial;
  String fechaFinContrato;
  String fechaFinal;
  int sincronizar;
  List<Amparo> amparos;
  int valAsegTotal;
  double primaTotal;

  double valComision;


  Poliza({this.descAgencia, this.descPuntoVenta, this.descRamo,
      this.descTipoPoliza, this.poliza, this.fechaEmision, this.numPoliza,
      this.temporario, this.estado, this.intermediarios, this.comision,
      this.cupoOperativo, this.afianzado, this.clausulado, this.plazoEjecucion,
      this.retroactividad, this.descTipoOperacion, this.descTipoNegocio,
      this.contratante, this.objeto, this.numeroContrato, this.valorContrato,
      this.fechaInicial, this.fechaFinContrato, this.fechaFinal,
      this.sincronizar, this.amparos, this.valAsegTotal, this.primaTotal,
      this.valComision});

  factory Poliza.fromMap(Map<String, dynamic> json) => new Poliza(
    poliza: json["poliza"],
    descAgencia: json["descAgencia"],
    descPuntoVenta: json["descPuntoVenta"],
    descRamo: json["descRamo"],
    descTipoPoliza: json["descTipoPoliza"],
    fechaEmision: json["fechaEmision"],
    numPoliza: json["numero"],
    temporario: json["temporario"],
    estado: json["estado"],

    //intermediario: json["intermediario"],
    comision: json["comision"],
    cupoOperativo: json["cupoOperativo"],

    afianzado: json["afianzado"],
    clausulado: json["clausulado"],
    descTipoOperacion: json["descTipoOperacion"],
    descTipoNegocio: json["descTipoNegocio"],

    plazoEjecucion: json["periodoEmision"],
    retroactividad: json["retroactividad"],

    contratante: json["contratante"],
    objeto: json["objeto"],
    numeroContrato: json["numeroContrato"],
    valorContrato: json["valorContrato"],
    fechaInicial: json["fechaInicial"],
    fechaFinal: json["fechaFinal"],
    sincronizar: json["sincronizar"],

    valAsegTotal: json["valAsegTotal"],
    primaTotal: json["primaTotal"],
    valComision: json["valComision"],

  );

  Map<String, dynamic> toMap() => {

    "descAgencia": descAgencia,
    "descPuntoVenta": descPuntoVenta,
    "descRamo": descRamo,
    "descTipoPoliza": descTipoPoliza,

    "fechaEmision": fechaEmision,
    "numero": numPoliza,
    "temporario": temporario,
    "estado": estado,

    //"intermediario": intermediarios,
    "comision": comision,
    "cupoOperativo": cupoOperativo,

    "afianzado": afianzado,
    "clausulado": clausulado,
    "descTipoOperacion": descTipoOperacion,
    "descTipoNegocio": descTipoNegocio,

    "periodoEmision": plazoEjecucion,
    "retroactividad": retroactividad,

    "contratante": contratante,
    "objeto": objeto,
    "numeroContrato": numeroContrato,
    "valorContrato": valorContrato,
    "fechaInicial": fechaInicial,
    "fechaFinal": fechaFinal,
    "valAsegTotal": valAsegTotal,
    "primaTotal": primaTotal,
    "valComision": valComision,

  };
}

