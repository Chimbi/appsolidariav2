// Copyright 2020-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:appsolidariav2/model/auxiliarModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';


class AuxiliarPage extends StatefulWidget {
  Auxiliar actual;

  AuxiliarPage({Key key, @required this.actual})
      : super(
            key:
                key); // Manejo DB - Recibe en actual=datos(update) o actual=null(insert)

  @override
  _AuxiliarPageState createState() => _AuxiliarPageState();
}

class _AuxiliarPageState extends State<AuxiliarPage> {

  final formKey = GlobalKey<FormState>();

  Agencia agenciaValue;

  List<Genero> generos = [
    Genero.withId(1, "Femenino"),
    Genero.withId(2, "Masculino")
  ];

  List<EstadoCivil> estadoCiviles = [
    EstadoCivil.withId(1, "Soltero"),
    EstadoCivil.withId(2, "Casado"),
    EstadoCivil.withId(3, "Divorciado"),
    EstadoCivil.withId(4, "Unión Libre")
  ];
  List<Tipo> tipos = [
    Tipo.withId(1, "Nit"),
    Tipo.withId(2, "Nit Persona natural"),
    Tipo.withId(3, "Cédula de ciudadanía"),
    Tipo.withId(4, "Cédula de extranjería"),
  ];
  List<Clasificacion> clasificaciones = [
    Clasificacion.withId(1, "Persona natural"),
    Clasificacion.withId(2, "Persona jurídica"),
    Clasificacion.withId(3, "Consorcio"),
    Clasificacion.withId(4, "Unión Temporal"),
    Clasificacion.withId(5, "Cooperativa"),
    Clasificacion.withId(6, "PreCooperativa"),
    Clasificacion.withId(7, "Asociación")
  ];

  List<String> tipoTercero = ["Intermediario", "Afianzado", "Contratante"];

  List<Agencia> agencias = [
    Agencia.withId(1, "Agencia Bogota"),
    Agencia.withId(1, "Agencia Medellin"),
    Agencia.withId(2, "Agencia Cali"),
  ];

  List<Ubicacion> ubicaciones = List();

  var _genero = null;
  var _estadoCivil = null;
  var _tipo;
  var _clasificacion = null;
  var _tercero = null;

  Auxiliar auxObj = Auxiliar();
  AuxBasico auxBasicoObj = AuxBasico();

  //---AutoComplete variables

  var intermedList = <String>[];

  //GlobalKey<AutoCompleteTextFieldState<String>> autoCompKey = new GlobalKey();

  //AutoCompleteTextField searchTextField;

  //Se crea la instancia
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ubicacionRef;
  DatabaseReference terceroRef;
  DatabaseReference terceroBasicoRef;
  DatabaseReference rootRef;

  var birthDateTEC = TextEditingController();
  var _ubicacion = TextEditingController();
  var cupoOperativoTEC = TextEditingController();

  //TODO update the focus nodes
  final FocusNode _idFocus = FocusNode();
  final FocusNode _nombresFocus = FocusNode();
  final FocusNode _apellidosFocus = FocusNode();
  final FocusNode _favoritoFocus = FocusNode();

  final FocusNode _movilFocus = FocusNode();
  final FocusNode _fijoFocus = FocusNode();
  final FocusNode _correoFocus = FocusNode();
  final FocusNode _documentoFocus = FocusNode();

  DateTime nacimiento;

  DateFormat dateFormat;
  DateTime initialBirth = DateTime(2000);

  Ubicacion selectedPlace;


  @override
  void initState() {
    initializeDateFormatting();
    dateFormat = new DateFormat('dd-MM-yyyy'); //new DateFormat.yMMMMd('es');

    ubicacionRef = database.reference().child("ubicacion");

    terceroRef = database.reference().child("terceros");
    terceroBasicoRef = database.reference().child("terceroBasico");

    //Root ref
    rootRef = database.reference();

    //Initialize the list of nits from Firebase /auxCont/keys
    ubicacionRef.onChildAdded.listen(_onAdded);
  }

  @override
  Widget build(BuildContext context) {
    Widget datosPersonaNatural = Container(
      child: Column(
        children: [
          SizedBox(height: 12.0),
          Text("Datos persona natural",
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0)),
          //Segundo Apellido
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'Segundo Apellido',
                  icon: Icon(Icons.person_outline)),
              enabled: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Campo obligatorio';
                }
                return null;
              },
              onSaved: (val) => setState(() {
                auxObj.segundoApellido = val;
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'Primer Nombre', icon: Icon(Icons.call, color: Colors.orange,)),
              enabled: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Campo obligatorio';
                }
                return null;
              },
              onSaved: (val) => setState(() {
                auxObj.primerNombre = val;
                auxBasicoObj.primerNombre = val;
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'Segundo Nombre',
                  icon: Icon(Icons.person_outline)),
              enabled: true,
              onSaved: (val) => setState(() {
                auxObj.segundoNombre = val;
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<Genero>(
              decoration: InputDecoration(
                  labelText: 'Genero', icon: Icon(Icons.person_outline)),
              value: _genero,
              onChanged: (Genero newValue) {
                setState(() {
                  _genero = newValue;
                  //print("Nuevo genero seleccionado ${newValue.descripcion}");
                });
              },
              items: generos.map((Genero genero) {
                return DropdownMenuItem<Genero>(
                  value: genero,
                  child: Text(
                    genero.descripcion,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
          DateTimeField(
            format: dateFormat,
            controller: birthDateTEC,
            //Lo agregue ver si es necesario
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
              /*
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                );
                return DateTimeField.combine(date, time);
              } else {
                return currentValue;
              }
              */
              return date;
            },
            autovalidate: false,
            validator: (value) {
              if (value == null) {
                return 'Debe ingresar una fecha inicial valida';
              }
              return null;
            },
            initialValue: initialBirth,
            onChanged: (date) => setState(() {
              auxObj.nacimiento = date.toString();
            }),
            onSaved: (DateTime date) {
              setState(() {
                auxObj.nacimiento = date.toString();
              });
            },
            resetIcon: Icon(Icons.delete),
            readOnly: false,
            decoration: InputDecoration(
                icon: Icon(Icons.date_range),
                labelText: 'Fecha de nacimiento'),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<EstadoCivil>(
              decoration: InputDecoration(
                  labelText: 'Estado Civil', icon: Icon(Icons.person_outline)),
              value: _estadoCivil,
              onChanged: (EstadoCivil newValue) {
                setState(() {
                  _estadoCivil = newValue;
                  //print("Nuevo genero seleccionado ${newValue.descripcion}");
                });
              },
              items: estadoCiviles.map((EstadoCivil ecivil) {
                return DropdownMenuItem<EstadoCivil>(
                  value: ecivil,
                  child: Text(
                    ecivil.descripcion,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );

    Widget datosIdentificacion = ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Identificación",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        //Tipo de documento [Nit,Nit persona natural, cedula, cedula de extrangeria]
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
                labelText: "Tipo de tercero", icon: Icon(Icons.contact_mail)),
            value: _tercero,
            onChanged: (String newValue) {
              setState(() {
                _tercero = newValue;
                auxObj.tipoTercero = newValue;
                print("Nuevo tipo tercero seleccionado ${newValue}");
              });
            },
            items: tipoTercero.map((String tipo) {
              return new DropdownMenuItem<String>(
                value: tipo,
                child: Text(
                  tipo,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<Tipo>(
            decoration: InputDecoration(
                labelText: "Tipo Documento", icon: Icon(Icons.contact_mail)),
            value: _tipo,
            onChanged: (Tipo newValue) {
              setState(() {
                _tipo = newValue;
                auxObj.descTipo = newValue.descripcion;
                auxObj.tipo = newValue.registro;
                print("Nuevo genero seleccionado ${newValue.descripcion}");
              });
            },
            onSaved: (Tipo newValue) {
              setState(() {
                _tipo = newValue;
                auxObj.descTipo = newValue.descripcion;
                auxObj.tipo = newValue.registro;
                print("Nuevo genero guardado ${newValue.descripcion}");
              });
            },
            items: tipos.map((Tipo tipo) {
              return new DropdownMenuItem<Tipo>(
                value: tipo,
                child: new Text(
                  tipo.descripcion,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),
        //Número de identificación
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
                labelText: 'Número identificación',
                icon: Icon(Icons.person_outline)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onSaved: (val) => setState(() {
              auxObj.identificacion = int.parse(val);
              auxBasicoObj.identificacion = int.parse(val);
            }),
          ),
        ),
        //Tipo de cliente - Clasificaciones
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<Clasificacion>(
            decoration: InputDecoration(
                labelText: "Tipo de cliente", icon: Icon(Icons.contact_mail)),
            value: _clasificacion,
            onChanged: (Clasificacion newValue) {
              setState(() {
                _clasificacion = newValue;
                print("Nuevo genero seleccionado ${newValue.descripcion}");
              });
            },
            onSaved: (Clasificacion newValue) {
              setState(() {
                _clasificacion = newValue;
                auxObj.descClasificacion = newValue.descripcion;
                auxObj.clasificacion = newValue.registro;
              });
            },
            items: clasificaciones.map((Clasificacion clasificacion) {
              return new DropdownMenuItem<Clasificacion>(
                value: clasificacion,
                child: new Text(
                  clasificacion.descripcion,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),

        //Primer Apellido/Razon social

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
                labelText: 'Primer Apellido/Razón Social',
                icon: Icon(Icons.person)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onSaved: (val) => setState(() {
              auxObj.primerApellido = val;
              auxBasicoObj.primerApellido = val;
            }),
          ),
        ),

        _tipo != null
            ? (_tipo.descripcion != "Nit" ? datosPersonaNatural : Container())
            : Container(),

        SizedBox(
          height: 30,
        ),
      ], // children principal
    );

    Widget datosContacto = ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Contacto",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration:
                InputDecoration(labelText: 'Dirección', icon: Icon(Icons.home)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onSaved: (val) => setState(() {
              auxObj.direccion = val;
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SimpleAutocompleteFormField<Ubicacion>(
            controller: _ubicacion,
            decoration: InputDecoration(
                labelText: 'Ciudad/Municipio', icon: Icon(Icons.search)),
            suggestionsHeight: 120.0,
            itemBuilder: (context, ubicacion) => Padding(
              padding: EdgeInsets.all(8.0),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(ubicacion.municipio,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(ubicacion.departamento),
                Text(ubicacion.region)
              ]),
            ),
            onSearch: (search) async => ubicaciones
                .where((ubicacion) =>
                    ubicacion.municipio
                        .toLowerCase()
                        .contains(search.toLowerCase()) ||
                    ubicacion.departamento
                        .toLowerCase()
                        .contains(search.toLowerCase()) ||
                    ubicacion.region.toLowerCase().contains(search.toLowerCase()))
                .toList(),
            itemFromString: (string) => ubicaciones.singleWhere(
                (ubicacion) =>
                    ubicacion.municipio.toLowerCase() == string.toLowerCase(),
                orElse: () => null),
            onChanged: (value) {
              setState(() {
                selectedPlace = value;
                if (value != null) {
                  _ubicacion.text = value.municipio;
                  print(
                      "Selected ubicacion departamento: ${auxObj.departamento},municipio: ${auxObj.municipio}");
                }
              });
            },
            onSaved: (value) => setState(() {
              selectedPlace = value;
              auxObj.municipio = value.municipio;
              auxObj.departamento = value.departamento;
              //auxObj.c_digo_dane_del_municipio = int.parse(value.c_digo_dane_del_municipio);
              //auxObj.c_digo_dane_del_departamento = int.parse(value.c_digo_dane_del_departamento);
            }),
            autofocus: false,
            validator: (user) => user == null ? 'Campo obligatorio.' : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
                labelText: 'Telefono celular', icon: Icon(Icons.home)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onSaved: (val) => setState(() {
              auxObj.movil = int.parse(val);
            }),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
                labelText: 'Telefono fijo', icon: Icon(Icons.home)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onSaved: (val) => setState(() {
              auxObj.fijo = int.parse(val);
            }),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
                labelText: 'Correo electrónico', icon: Icon(Icons.home)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onSaved: (val){
              auxObj.correo = val;
            },
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );

    Widget datosIntermediario = ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Datos Intermediario",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<Agencia>(
            decoration: InputDecoration(
                labelText: "Agencia", icon: Icon(Icons.text_fields)),
            value: agenciaValue,
            onChanged: (Agencia newValue) {
              setState(() {
                agenciaValue = newValue;
                print("Agencia value ${agenciaValue.descripcion}");
              });
            },
            validator: (Agencia value) {
              if (value == null ?? true) {
                return 'Favor seleccione un clausulado';
              }
              return null;
            },
            items: agencias.map((Agencia value) {
              return DropdownMenuItem<Agencia>(
                value: value,
                child: Text(value.descripcion),
              );
            }).toList(),
            onSaved: (val) => setState(() {
              auxObj.descAgencia = val.descripcion;
              auxObj.agencia = val.registro;
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration:
            InputDecoration(labelText: 'Punto de venta', icon: Icon(Icons.home)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onSaved: (val) => setState(() {
              auxObj.descPuntoVenta = val;
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration:
            InputDecoration(labelText: 'Clave', icon: Icon(Icons.home)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onSaved: (val) => setState(() {
              auxObj.clave = int.parse(val);
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration:
            InputDecoration(labelText: 'Comision Cumplimiento %', icon: Icon(Icons.home)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onSaved: (val) => setState(() {
              auxObj.comCumplimiento = double.parse(val)/100;
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration:
            InputDecoration(labelText: 'Delegacion Cumplimiento', icon: Icon(Icons.home)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onSaved: (val) => setState(() {
              auxObj.delegacionCumpl = int.parse(val);
            }),
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );

    Widget datosAfianzado = ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Datos Afianzado",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: cupoOperativoTEC,
            keyboardType: TextInputType.number,
            decoration:
            InputDecoration(labelText: 'Cupo Operativo', icon: Icon(Icons.home)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onSaved: (val) => setState(() {
              auxObj.cupoOperativo = int.parse(val);
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration:
            InputDecoration(labelText: 'Cumulo Actual', icon: Icon(Icons.home)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onSaved: (val) => setState(() {
              auxObj.cumuloActual = int.parse(val);
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration:
            InputDecoration(labelText: 'Cupo Disponible', icon: Icon(Icons.home)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onSaved: (val) => setState(() {
              auxObj.cupoDisponible = int.parse(val);
            }),
          ),
        ),

        SizedBox(height: 12.0),
      ],
    );

    return new Scaffold(
      appBar: new AppBar(title: Text(_tercero != null ? "Creación $_tercero" : "Creacion de terceros")),
      body: Form(
        key: formKey,
        // Antes SafeArea
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          children: <Widget>[
            SizedBox(height: 12.0),
            datosIdentificacion,

            SizedBox(height: 18.0),
            datosContacto,

            SizedBox(height: 12.0),
            _tercero == "Intermediario" ? datosIntermediario : Container(),

            SizedBox(height: 12.0),
            _tercero == "Afianzado" ? datosAfianzado : Container(),


//            new Container(
//                padding: const EdgeInsets.only(left: 0.0, top: 0.0),
//                child: new RaisedButton(
//                  child: const Text('Grabar'),
//                  onPressed: null,
//                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        child: Icon(
          Icons.update,
          color: Colors.white,
        ),
        onPressed: () {
          final form = formKey.currentState;
          if(form.validate()){
            form.save();
            //Firestore.instance.collection("terceros").add({"Chao":"Andy"});
            //Firestore.instance.document("terceros/${auxObj.identificacion}").setData(auxObj.toMap());
            terceroRef.child("${auxObj.tipoTercero}").child("${auxObj.identificacion}").set(auxObj.toMap());
            terceroBasicoRef.child("${auxObj.tipoTercero}").child("${auxObj.identificacion}").set(auxBasicoObj.toMap());
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Tercero creado exitosamente!!'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                            'El ${auxObj.tipoTercero} ${auxObj.primerNombre != null ? auxObj.primerNombre : ""} ${auxObj.segundoApellido}'),
                        Text('con identificación ${auxObj.identificacion} ha sido creado exitosamente'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Aceptar'),
                      onPressed: () {
                        //Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/');
                      },
                    ),
                    FlatButton(
                      child: Text('Nueva Póliza'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/poliza');
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Formulario incompleto'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                            'Para crear el tercero correctamente'),
                        Text('agradecemos diligenciar el formulario en su totalidad'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Aceptar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }

        },
      ),
    );
  }

  _onAdded(Event event) {
    setState(() {
      ubicaciones.add(Ubicacion.fromMapObject(
          event.snapshot.value.cast<String, dynamic>()));
      print("Add ${event.snapshot.key}");
    });
  }
}

