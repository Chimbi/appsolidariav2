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

  List<Ubicacion> ubicaciones = List();

  var _genero = null;
  var _estadoCivil = null;
  var _tipo;
  var _clasificacion = null;
  var _tercero = null;

  Auxiliar auxObj = Auxiliar();

  //---AutoComplete variables

  var intermedList = <String>[];
  String _intermediario = '';

  GlobalKey<AutoCompleteTextFieldState<String>> autoCompKey = new GlobalKey();

  AutoCompleteTextField searchTextField;

  //Se crea la instancia
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ubicacionRef;
  DatabaseReference rootRef;

  int _auxiliar;
  var _id = TextEditingController();
  var _nombres = TextEditingController();
  var _apellidos = TextEditingController();
  final _favorito = TextEditingController();
  File _foto = null; // FOTO: Variable

  var _direccion = TextEditingController();
  var _movil = TextEditingController();
  var _fijo = TextEditingController();
  var _correo = TextEditingController();
  var _documento = TextEditingController();
  var birthDateTEC = TextEditingController();
  var _ubicacion = TextEditingController();

  final FocusNode _idFocus = FocusNode();
  final FocusNode _nombresFocus = FocusNode();
  final FocusNode _apellidosFocus = FocusNode();
  final FocusNode _favoritoFocus = FocusNode();

  final FocusNode _movilFocus = FocusNode();
  final FocusNode _fijoFocus = FocusNode();
  final FocusNode _correoFocus = FocusNode();
  final FocusNode _documentoFocus = FocusNode();

  bool editable = false;
  DateTime nacimiento;

  DateFormat dateFormat;
  DateTime initialBirth = DateTime(2000);

  //bool loading = true;

  Ubicacion selectedPlace;

  @override
  void initState() {
    initializeDateFormatting();
    dateFormat = new DateFormat('dd-MM-yyyy'); //new DateFormat.yMMMMd('es');

    ubicacionRef = database.reference().child("ubicacion");

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

          /*
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DateTimePickerFormField(
              decoration: InputDecoration(
                  icon: Icon(Icons.date_range),
                  labelText: 'Fecha de nacimiento'),
              initialDate: initialBirth,
              controller: birthDateTEC,
              format: dateFormat,
              enabled: true,
              dateOnly: true,
              validator: (value) {
                if (value == null) {
                  return 'Debe ingresar una fecha inicial valida';
                }
                /*
                else if (minDate.isAfter(value)) {
                  return 'Retroactividad máxima superada';
                }
                */
                return null;
              },
              onChanged: (DateTime date) {
                setState(() {
                  auxObj.nacimiento = date.toString();
                });
              },
            ),
          ),
          */

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
                print("Nuevo genero seleccionado ${newValue.descripcion}");
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
            }),
          ),
        ),

        _tipo != null
            ? (_tipo.descripcion != "Nit" ? datosPersonaNatural : Container())
            : Container(),

        SizedBox(
          height: 30,
        ),

        //datosAdicional,
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
        SimpleAutocompleteFormField<Ubicacion>(
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
                auxObj.municipio = value.municipio;
                auxObj.departamento = value.departamento;
                _ubicacion.text = value.municipio;
                print(
                    "Selected ubicacion departamento: ${auxObj.departamento},municipio: ${auxObj.municipio}");
              }
            });
          },
          onSaved: (value) => setState(() {
            selectedPlace = value;
          }),
          autofocus: false,
          validator: (user) => user == null ? 'Campo obligatorio.' : null,
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
            onSaved: (val) => setState(() {
              auxObj.movil = int.parse(val);
            }),
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
            ],
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );

    return new Scaffold(
      appBar: new AppBar(title: Text("Creación de terceros")),
      body: new Container(
        // Antes SafeArea
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          children: <Widget>[
            SizedBox(height: 12.0),
            datosIdentificacion,

            SizedBox(height: 18.0),
            datosContacto,

            SizedBox(height: 74.0),

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
          print("OnPressed FloatingActionButton");
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
