import 'dart:convert';

import 'package:flutter/foundation.dart';

Auxiliar auxiliarFromJson(String str) {
  final jsonData = json.decode(str);
  return Auxiliar.fromMap(jsonData);
}

String auxiliarToJson(Auxiliar data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Auxiliar with ChangeNotifier{
  int auxiliar;
  int clasificacion;
  String descClasificacion;
  int tipo;
  String descTipo;
  int identificacion;
  String primerNombre;
  String segundoNombre;
  String primerApellido;
  String segundoApellido;
  String favorito;

  String nacimiento;
  int c_digo_dane_del_departamento;
  String departamento;
  int genero;
  String descGenero;
  int estadoCivil;
  String descEstadoCivil;

  String direccion;
  int c_digo_dane_del_municipio;
  String municipio;
  int movil;
  int fijo;
  String correo;

  String documento;
  bool sincronizar;

  //Intermediario

  int agencia;
  String descAgencia;

  int puntoVenta;
  String descPuntoVenta;
  int clave;
  double comCumplimiento;
  int delegacionCumpl;

  //Afianzado

  int cupoOperativo;
  int cumuloActual;
  int cupoDisponible;

  Auxiliar(
      {this.auxiliar,
        this.clasificacion,
        this.descClasificacion,
        this.tipo,
        this.descTipo,
        this.identificacion,
        this.primerNombre,
        this.segundoNombre,
        this.primerApellido,
        this.segundoApellido,
        this.favorito,
        this.nacimiento,
        this.c_digo_dane_del_departamento,
        this.departamento,
        this.genero,
        this.descGenero,
        this.estadoCivil,
        this.descEstadoCivil,
        this.direccion,
        this.c_digo_dane_del_municipio,
        this.municipio,
        this.movil,
        this.fijo,
        this.correo,
        this.documento,
        this.sincronizar,
        this.agencia,
        this.descAgencia,
        this.puntoVenta,
        this.descPuntoVenta,
        this.clave,
        this.comCumplimiento,
        this.delegacionCumpl,
        this.cupoOperativo,
        this.cumuloActual,
        this.cupoDisponible});


  factory Auxiliar.fromMap(Map<String, dynamic> json) => new Auxiliar(
      auxiliar: json["auxiliar"],
      clasificacion: json["clasificacion"],
      descClasificacion: json["descClasificacion"],
      tipo: json["tipo"],
      descTipo: json["descTipo"],
      identificacion: json["identificacion"],
      primerNombre: json["primerNombre"],
      segundoNombre: json["segundoNombre"],
      primerApellido: json["primerApellido"],
      segundoApellido: json["segundoApellido"],
      favorito: json["favorito"],
      nacimiento: json["nacimiento"],
      c_digo_dane_del_departamento: json["c_digo_dane_del_departamento"],
      departamento: json["departamento"],
      genero: json["genero"],
      descGenero: json["descGenero"],
      estadoCivil: json["estadoCivil"],
      descEstadoCivil: json["descEstadoCivil"],
      direccion: json["direccion"],
      c_digo_dane_del_municipio: json["c_digo_dane_del_municipio"],
      municipio: json["municipio"],
      movil: json["movil"],
      fijo: json["fijo"],
      correo: json["correo"],
      documento: json["documento"],
      sincronizar: json["sincronizar"] == 1,
      agencia: json["agencia"],
      descAgencia: json["descAgencia"],
      puntoVenta: json["puntoVenta"],
      descPuntoVenta: json["descPuntoVenta"],
      clave: json["clave"],
      comCumplimiento: json["comCumplimiento"],
      delegacionCumpl: json["delegacionCumpl"],
      cupoOperativo: json["cupoOperativo"],
      cumuloActual: json["cumuloActual"],
      cupoDisponible: json["cupoDisponible"]);

  Map<String, dynamic> toMap() => {
    "clasificacion": clasificacion,
    "descClasificacion": descClasificacion,
    "tipo": tipo,
    "descTipo": descTipo,
    "auxiliar": auxiliar,
    "identificacion": identificacion,
    "primerNombre": primerNombre,
    "segundoNombre": segundoNombre,
    "primerApellido": primerApellido,
    "segundoApellido": segundoApellido,
    "favorito": favorito,
    "nacimiento": nacimiento,
    "c_digo_dane_del_departamento": c_digo_dane_del_departamento,
    "departamento": departamento,
    "genero": genero,
    "descGenero": descGenero,
    "estadoCivil": estadoCivil,
    "descEstadoCivil": descEstadoCivil,
    "direccion": direccion,
    "c_digo_dane_del_municipio": c_digo_dane_del_municipio,
    "municipio": municipio,
    "movil": movil,
    "fijo": fijo,
    "correo": correo,
    "documento": documento,
    "agencia": agencia,
    "descAgencia": descAgencia,
    "puntoVenta": puntoVenta,
    "descPuntoVenta": descPuntoVenta,
    "clave": clave,
    "comCumplimiento": comCumplimiento,
    "delegacionCumpl": delegacionCumpl,
    "cupoOperativo": cupoOperativo,
    "cumuloActual": cumuloActual,
    "cupoDisponible": cupoDisponible,
  };
}

class Genero {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  Genero.withId(this._registro, this._descripcion);

  Genero(this._descripcion);

  int get registro => _registro;

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert Genero Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  Genero.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}

class EstadoCivil {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  EstadoCivil.withId(this._registro, this._descripcion);

  EstadoCivil(this._descripcion);

  int get registro => _registro;

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert EstadoCivil Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  EstadoCivil.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}

class Tipo {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  Tipo.withId(this._registro, this._descripcion);

  Tipo(this._descripcion);

  int get registro => _registro;

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert Tipo Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  Tipo.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}

class Ubicacion {
  String c_digo_dane_del_departamento;
  String c_digo_dane_del_municipio;
  String departamento;
  String municipio;
  String region;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['c_digo_dane_del_departamento'] = c_digo_dane_del_departamento;
    map['c_digo_dane_del_municipio'] = c_digo_dane_del_municipio;
    map['departamento']=departamento;
    map['municipio']=municipio;
    map['region'] = region;
    return map;
  }

  Ubicacion.fromMapObject(Map<String, dynamic> map) {
    this.c_digo_dane_del_departamento = map['c_digo_dane_del_departamento'];
    this.c_digo_dane_del_municipio = map['c_digo_dane_del_municipio'];
    this.departamento = map['departamento'];
    this.municipio = map['municipio'];
    this.region = map['region'];
  }


}

class Clasificacion {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  Clasificacion.withId(this._registro, this._descripcion);

  Clasificacion(this._descripcion);

  //Clasificacion();

  int get registro {
    if(_registro == null){
      return _registro = 0;
    } else{
      return _registro;
    }
  }

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert Clasificacion Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  Clasificacion.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}

/*

class Agencia {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  Agencia.withId(this._registro, this._descripcion);

  Agencia(this._descripcion);

  int get registro => _registro;

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert Agencia Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  Agencia.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}
*/

class PuntoVenta {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  PuntoVenta.withId(this._registro, this._descripcion);

  PuntoVenta(this._descripcion);

  int get registro => _registro;

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert Agencia Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  PuntoVenta.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}




class Lugar {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  Lugar.withId(this._registro, this._descripcion);

  Lugar(this._descripcion);

  int get registro => _registro;

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert Lugar Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  Lugar.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}

class Municipio {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  Municipio.withId(this._registro, this._descripcion);

  Municipio(this._descripcion);

  int get registro {
    if(_registro == null){
      return _registro = 0;
    } else{
      return _registro;
    }
  }

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert Municipio Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  Municipio.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}

class Documento {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  Documento.withId(this._registro, this._descripcion);

  Documento(this._descripcion);

  int get registro {
    if(_registro == null){
      print("Registro en Documento = null $_registro");
      return _registro = 0;
    } else{
      return _registro;
    }
  }

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert Municipio Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  Documento.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}



