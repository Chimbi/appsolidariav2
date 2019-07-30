import 'dart:convert';
import 'package:appsolidariav2/model/afianzaModel.dart';
import 'package:appsolidariav2/model/amparoModel.dart';
import 'package:appsolidariav2/model/intermedModel.dart';
import 'package:flutter/foundation.dart';

Poliza polizaFromJson(String str) {
  final jsonData = json.decode(str);
  return Poliza.fromMap(jsonData);
}

String polizaToJson(Poliza data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Poliza with ChangeNotifier{
  ///NOT in the Form  Informacion del punto de venta de emisión
  String descAgencia = "Agencia Bogota";
  String descPuntoVenta = "AC Seguros Ltda";

  ///NOT IN THE FORM
  Intermediario intermediarios = Intermediario(auxiliar: 1,descClasificacion: "Intermediario",);
  //version 1: 1 Intermediario version2: varios intermediarios
  double comision;  //Porcentaje de comisión
  //Ramo comercial
  String descRamo = "Cumplimiento";


  //Tipo de movimiento: Tipos de anexos. Espedicion
  //TODO definir que campos van a nivel de anexo y separarlos en un objeto aparte

  ///title: Informacion del afianzado

  String tipoDocumento; // Comes from the Afianzado / Viene del afianzado
  ///Autocomplete Afianzado search for numeroDocumento/id and apellidoRazonSocial/name
  int numeroDocumento; // Autocomplete form
  String apellidoRazonSocial; //Autocomplete form Primer apellido
  ///CupoOperativo and cumulo actual are in the form as text when you get the info of the afianzado
  int cupoOperativo; // Comes from the Afianzado
  int cumuloActual;  //Comes from the Afianzado
  int cupoDisponible; // = cupoOperativo - cumuloActual;

  //Afianzado afianzado;
  //version 1: 1 Afianzado version2: varios afianzados
  

//TODO Añadir mas tomadores para Consorcio o temporal. el de mayor participacion es el tomador si no hay nit ni nombre

  ///title: Caracteristicas de la póliza
  String fechaEmision = DateTime.now().toString(); //Not in the form
  String vigDesde; //In the form as Date field Vigencia desde hora desde 00:00
  String vigHasta;  //Not in the form TODO Calcular con la máxima fecha de los amparos
  String tipoCambio = "Pesos"; //Not in the form
  //Cobra iva siempre
  String productoClausulado; //Dropdown in the form "Clausulado1: "Lorem ipsum", "Clausulado2":"Lorem ipsum2", "Clausuado3":"Lorem ipsum3"
  String textoClausulado;
  String descTipoOperacion = "100% Compañia";  //NOT IN THE FORM 100% Compañia, Coaseguro Cedido, Coaseguro Aceptado //Incluir en el modelo List<CiasSeguros>
  String descTipoPoliza;  // DropdownFormField "Particular, Estatal, Servicios Publicos Domiciliarios, Poliza Ecopetrol, Empresas públicas con régimen privado"
  String descTipoNegocio;
  //Tipo de Negocio: Contrato, contrato de arrendamiento, contrato de consultoria,
  //contrato de ejecucion de obra, contrato de interventoria, contrato de prestacion de servicios

//--------  Se notifica el temporario con esta informacion ---------------------------------------

  int temporario = 5678; //TODO Revisar la cantidad the caracteres
  int numPoliza = 1234; //TODO Revisar la cantidad the caracteres

  ///Información del riesgo
  int nitContratante;
  String numeroContrato;
  double valorContrato;  //Nivel anexo
  int plazoEjecucion; //En años
  String fechaFinContrato;  //Asignar a vigDesde
  String objetoSeguro;  //Contrato, Orden compra, Orden servicio, Orden suministro, Factura venta, Pliego condiciones
  String textoAclaratorio; //Ver como funciona con un texto largo

  ///Coberturas

  List<Amparo> amparos = [];


  //int poliza;  //Consecutivo sistema, revisar si se necesita
  int estado = 1; //1 Borrador 2. Revision 3. Emision

  
  //int retroactividad;

  ///Valores totales de la póliza
  int valAsegTotal;
  double primaTotal;
  double valComision;

  Poliza({this.descAgencia, this.descPuntoVenta, this.intermediarios,
      this.comision, this.descRamo, this.tipoDocumento, this.numeroDocumento,
      this.apellidoRazonSocial, this.cupoOperativo, this.cumuloActual, this.cupoDisponible,
      this.fechaEmision, this.vigDesde, this.vigHasta,
      this.tipoCambio, this.productoClausulado, this.textoClausulado, this.descTipoOperacion,
      this.descTipoPoliza, this.descTipoNegocio, this.temporario,
      this.numPoliza, this.nitContratante, this.numeroContrato,
      this.valorContrato, this.plazoEjecucion, this.fechaFinContrato,
      this.objetoSeguro, this.textoAclaratorio, this.amparos, this.estado,
      this.valAsegTotal, this.primaTotal, this.valComision});

  factory Poliza.fromMap(Map<String, dynamic> json) => new Poliza(
    descAgencia: json["descAgencia"], descPuntoVenta: json["descPuntoVenta"], intermediarios: json["intermediarios"],
    comision: json["comision"], descRamo: json["descRamo"], tipoDocumento: json["tipoDocumento"], numeroDocumento: json["numeroDocumento"],
    apellidoRazonSocial: json["apellidoRazonSocial"], cupoOperativo: json["cupoOperativo"], cumuloActual: json["cumuloActual"],cupoDisponible: json["cupoDisponible"],
    fechaEmision: json["fechaEmision"], vigDesde: json["vigDesde"], vigHasta: json["vigHasta"],
    tipoCambio: json["tipoCambio"], productoClausulado: json["productoClausulado"],textoClausulado: json["textoClausulado"], descTipoOperacion: json["descTipoOperacion"],
    descTipoPoliza: json["descTipoPoliza"], descTipoNegocio: json["descTipoNegocio"], temporario: json["temporario"],
    numPoliza: json["numPoliza"], nitContratante: json["nitContratante"], numeroContrato: json["numeroContrato"],
    valorContrato: json["valorContrato"], plazoEjecucion: json["plazoEjecucion"], fechaFinContrato: json["fechaFinContrato"],
    objetoSeguro: json["objetoSeguro"], textoAclaratorio: json["textoAclaratorio"], amparos: json["amparos"], estado: json["estado"],
    valAsegTotal: json["valAsegTotal"], primaTotal: json["primaTotal"], valComision: json["valComision"]
  );

  Map<String, dynamic> toMap() => {

  "descAgencia": descAgencia , "descPuntoVenta": descPuntoVenta , "intermediarios" : intermediarios,
  "comision": comision, "descRamo" : descRamo , "tipoDocumento" : tipoDocumento , "numeroDocumento" : numeroDocumento,
  "apellidoRazonSocial" : apellidoRazonSocial, "cupoOperativo" : cupoOperativo, "cumuloActual" : cumuloActual, "cupoDisponible":cupoDisponible,
  "fechaEmision": fechaEmision, "vigDesde": vigDesde, "vigHasta": vigHasta,
  "tipoCambio": tipoCambio, "productoClausulado": productoClausulado, "textoClausulado":textoClausulado, "descTipoOperacion": descTipoOperacion,
  "descTipoPoliza": descTipoPoliza, "descTipoNegocio": descTipoNegocio, "temporario": temporario,
  "numPoliza": numPoliza, "nitContratante": nitContratante, "numeroContrato": numeroContrato,
  "valorContrato": valorContrato, "plazoEjecucion": plazoEjecucion, "fechaFinContrato": fechaFinContrato,
  "objetoSeguro": objetoSeguro, "textoAclaratorio": textoAclaratorio, "amparos": amparos, "estado": estado,
  "valAsegTotal": valAsegTotal, "primaTotal": primaTotal, "valComision": valComision,
  };
}

