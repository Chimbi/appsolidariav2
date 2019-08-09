import 'dart:convert';

import 'package:appsolidariav2/model/amparoModel.dart';
import 'package:appsolidariav2/model/auxiliarModel.dart';
import 'package:appsolidariav2/model/polizaModel.dart';
import 'package:appsolidariav2/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:http/http.dart' as http;

List<User> users = new List<User>();

class Clausulado {
  String prodClausulado;
  String textoClausulado;

  Clausulado(this.prodClausulado, this.textoClausulado);
}

class Page0 extends StatefulWidget {
  @override
  _Page0State createState() => _Page0State();
}

class _Page0State extends State<Page0> with AutomaticKeepAliveClientMixin {
  TextEditingController auxBasicoController = TextEditingController();
  TextEditingController asegBasicoController = TextEditingController();

  List<AuxBasico> afianzados = List();
  List<AuxBasico> contratantes = List();

  AuxBasico selectedAuxBasico;
  AuxBasico selectedAsegBasico;

  AuxBasico auxObj;

  //Se crea la instancia
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference terceroRef;
  DatabaseReference afianzadoRef;
  DatabaseReference contratanteRef;
  DatabaseReference afianzadoBasicoRef;
  DatabaseReference contratanteBasicoRef;
  DatabaseReference rootRef;

  var loading = true;
  bool _isSelected = false;

  @override
  void initState() {
    //Inicializar objeto
    auxObj = AuxBasico();

    //Inicializar referencias de RealTimeDatabase firebase
    terceroRef = database.reference().child("terceros");
    afianzadoRef = database.reference().child("terceros").child("Afianzado");
    afianzadoBasicoRef =
        database.reference().child("terceroBasico").child("Afianzado");
    contratanteBasicoRef =
        database.reference().child("terceroBasico").child("Contratante");
    rootRef = database.reference();

    //Initialize the list of Afianzados from Firebase /auxCont/keys
    afianzadoBasicoRef.onChildAdded
        .listen(_onAddedAfianzado)
        .onDone(loadingFunc());
    contratanteBasicoRef.onChildAdded.listen(_onAddedContratante);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          elevation: 8.0,
          child: Column(
            children: <Widget>[
              CheckboxListTile(
                value: _isSelected,
                title: Text("Asegurado = Beneficiario"),
                onChanged: (bool newValue) {
                  setState(() {
                    _isSelected = newValue;
                  });
                },
              ),
              loading
                  ? CircularProgressIndicator()
                  : SimpleAutocompleteFormField<AuxBasico>(
                      controller: auxBasicoController,
                      decoration: InputDecoration(
                          labelText: 'Afianzado', icon: Icon(Icons.search)),
                      suggestionsHeight: 120.0,
                      itemBuilder: (context, auxbasico) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(auxbasico.primerApellido,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(auxbasico.identificacion.toString())
                            ]),
                      ),
                      //Bug solved.
                      //Can't search for primerNombre because Nit don't have primerNombre
                      onSearch: (search) async => afianzados
                          .where((aux) =>
                              aux.primerApellido
                                  .toLowerCase()
                                  .contains(search.toLowerCase()) ||
                              aux.identificacion.toString().contains(search))
                          .toList(),
                      itemFromString: (string) => afianzados.singleWhere(
                          (auxbasico) =>
                              auxbasico.primerApellido.toLowerCase() ==
                              string.toLowerCase(),
                          orElse: () => null),
                      onChanged: (value) {
                        setState(() {
                          selectedAuxBasico = value;
                          if (value != null) {
                            auxBasicoController.text = value.primerApellido;
                            //print("Selected ubicacion departamento: ${auxObj.departamento},municipio: ${auxObj.municipio}");
                          }
                        });
                      },
                      onSaved: (value) => setState(() {
                        selectedAuxBasico = value;
                        //auxObj.municipio = value.municipio;
                        //auxObj.departamento = value.departamento;
                        //auxObj.c_digo_dane_del_municipio = int.parse(value.c_digo_dane_del_municipio);
                        //auxObj.c_digo_dane_del_departamento = int.parse(value.c_digo_dane_del_departamento);
                      }),
                      autofocus: false,
                      validator: (user) =>
                          user == null ? 'Campo obligatorio.' : null,
                    ),
              loading
                  ? CircularProgressIndicator()
                  : SimpleAutocompleteFormField<AuxBasico>(
                      controller: asegBasicoController,
                      decoration: InputDecoration(
                          labelText: 'Tomador/Asegurado', icon: Icon(Icons.search)),
                      suggestionsHeight: 120.0,
                      itemBuilder: (context, auxbasico) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(auxbasico.primerApellido,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(auxbasico.identificacion.toString())
                            ]),
                      ),
                      //Bug solved.
                      //Can't search for primerNombre because Nit don't have primerNombre
                      onSearch: (search) async => contratantes
                          .where((aux) =>
                              aux.primerApellido
                                  .toLowerCase()
                                  .contains(search.toLowerCase()) ||
                              aux.identificacion.toString().contains(search))
                          .toList(),
                      itemFromString: (string) => contratantes.singleWhere(
                          (auxbasico) =>
                              auxbasico.primerApellido.toLowerCase() ==
                              string.toLowerCase(),
                          orElse: () => null),
                      onChanged: (value) {
                        setState(() {
                          selectedAsegBasico = value;
                          if (value != null) {
                            auxBasicoController.text = value.primerApellido;
                            //print("Selected ubicacion departamento: ${auxObj.departamento},municipio: ${auxObj.municipio}");
                          }
                        });
                      },
                      onSaved: (value) => setState(() {
                        selectedAsegBasico = value;
                        //auxObj.municipio = value.municipio;
                        //auxObj.departamento = value.departamento;
                        //auxObj.c_digo_dane_del_municipio = int.parse(value.c_digo_dane_del_municipio);
                        //auxObj.c_digo_dane_del_departamento = int.parse(value.c_digo_dane_del_departamento);
                      }),
                      autofocus: false,
                      validator: (user) =>
                          user == null ? 'Campo obligatorio.' : null,
                    ),
              _isSelected == false ? loading
                  ? CircularProgressIndicator()
                  : SimpleAutocompleteFormField<AuxBasico>(
                controller: asegBasicoController,
                decoration: InputDecoration(
                    labelText: 'Beneficiario', icon: Icon(Icons.search)),
                suggestionsHeight: 120.0,
                itemBuilder: (context, auxbasico) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(auxbasico.primerApellido,
                            style:
                            TextStyle(fontWeight: FontWeight.bold)),
                        Text(auxbasico.identificacion.toString())
                      ]),
                ),
                //Bug solved.
                //Can't search for primerNombre because Nit don't have primerNombre
                onSearch: (search) async => contratantes
                    .where((aux) =>
                aux.primerApellido
                    .toLowerCase()
                    .contains(search.toLowerCase()) ||
                    aux.identificacion.toString().contains(search))
                    .toList(),
                itemFromString: (string) => contratantes.singleWhere(
                        (auxbasico) =>
                    auxbasico.primerApellido.toLowerCase() ==
                        string.toLowerCase(),
                    orElse: () => null),
                onChanged: (value) {
                  setState(() {
                    selectedAsegBasico = value;
                    if (value != null) {
                      auxBasicoController.text = value.primerApellido;
                      //print("Selected ubicacion departamento: ${auxObj.departamento},municipio: ${auxObj.municipio}");
                    }
                  });
                },
                onSaved: (value) => setState(() {
                  selectedAsegBasico = value;
                  //auxObj.municipio = value.municipio;
                  //auxObj.departamento = value.departamento;
                  //auxObj.c_digo_dane_del_municipio = int.parse(value.c_digo_dane_del_municipio);
                  //auxObj.c_digo_dane_del_departamento = int.parse(value.c_digo_dane_del_departamento);
                }),
                autofocus: false,
                validator: (user) =>
                user == null ? 'Campo obligatorio.' : null,
              ) : Container(),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _onAddedAfianzado(Event event) {
    setState(() {
      afianzados.add(AuxBasico.fromMapObject(
          event.snapshot.value.cast<String, dynamic>()));
      print("Add ${event.snapshot.key}");
    });
  }

  _onAddedContratante(Event event) {
    setState(() {
      contratantes.add(AuxBasico.fromMapObject(
          event.snapshot.value.cast<String, dynamic>()));
      print("Add ${event.snapshot.key}");
    });
  }

  void Function() loadingFunc() {
    loading = false;
  }
}

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> with AutomaticKeepAliveClientMixin {
  //Se crea la instancia
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference terceroRef;
  DatabaseReference afianzadoRef;
  DatabaseReference contratanteRef;
  DatabaseReference rootRef;

  String tipoPolizaValue;
  String tipoNegocioValue;
  Clausulado clausuladoValue;

  DateFormat
      dateFormat; //DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"); //DateFormat('dd-MM-yyyy'); DateFormat.yMMMd()

  TextEditingController initialDate = TextEditingController();
  TextEditingController finalDate = TextEditingController();
  TextEditingController prueba = TextEditingController();
  TextEditingController periodoController = TextEditingController();
  TextEditingController cupoController = TextEditingController();

  DateTime _fechaEmision = DateTime.now();
  DateTime _fromDate1;
  DateTime minDate;

  ///Listado Producto Clausulado
  List<Clausulado> prodClausulado = <Clausulado>[
    Clausulado("Decreto123", "Lorem ipsum1"),
    Clausulado("Decreto456", "Lorem ipsum2")
  ];

  List<String> tipoPoliza = [
    "Particular",
    "Estatal",
    "Servicios Publicos",
    "Poliza Ecopetrol",
    "E.Publicas R.Privado"
  ];
  List<String> tipoNeg = [
    "Prestación de servicios",
    "Suministro",
    "Consultoría",
    "Interventoría",
    "Obra",
    "Suministro Repuestos",
  ];

  bool loading = true;
  final _user = User();
  final _poliza = Poliza();
  User selectedUser;

  void getUsers() async {
    try {
      final response =
          await http.get("https://jsonplaceholder.typicode.com/users");
      if (response.statusCode == 200) {
        users = loadUsers(response.body);
        print('Users: ${users.length}');
        setState(() {
          loading = false;
        });
      } else {
        print("Error getting users.");
      }
    } catch (e) {
      print("Error getting users.");
    }
  }

  static List<User> loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  List<Amparo> amparos = List();
  DocumentSnapshot amparosMap;

  @override
  void initState() {
    getUsers();
    initializeDateFormatting();
    dateFormat = new DateFormat('dd-MM-yyyy'); //new DateFormat.yMMMMd('es');
    ///Define fecha mínima como control del sistema.
    minDate = DateTime(
        _fechaEmision.year, _fechaEmision.month - 5, _fechaEmision.day);
    periodoController.text = "1";

    //Inicializar referencias de RealTimeDatabase firebase
    terceroRef = database.reference().child("terceros");
    afianzadoRef = database.reference().child("terceros").child("Afianzado");
    contratanteRef =
        database.reference().child("terceros").child("Contratante");
    rootRef = database.reference();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var polizaObj = Provider.of<Poliza>(context);

    return Card(
      elevation: 8.0,
      child: Column(
        children: <Widget>[
          Center(
              child: Text(
            "Datos Básicos",
            style: TextStyle(fontSize: 16.0, color: Colors.blue),
          )),
          DateTimeField(
            format: dateFormat,
            controller: initialDate,
            //Lo agregue ver si es necesario
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
              /*
              Used to return time as well
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
              } else if (minDate.isAfter(value)) {
                return 'Retroactividad máxima superada';
              }
              return null;
            },
            initialValue:
                (polizaObj.vigDesde != null && polizaObj.vigDesde != "")
                    ? DateTime.parse((polizaObj.vigDesde.substring(6, 10) +
                        polizaObj.vigDesde.substring(3, 5) +
                        polizaObj.vigDesde.substring(0, 2)))
                    : null,
            //TODO Se cambia de "" a null 06 Agosto 2019
            onChanged: (DateTime date) {
              setState(() {
                //_fromDate1 = date;
                //initialDate.text = date.toString();
                //finalDate is the controller for the next date
                finalDate.text = initialDate.text != ""
                    ? initialDate.text.substring(0, 2) +
                        "-" +
                        initialDate.text.substring(3, 5) +
                        "-" +
                        (int.parse(initialDate.text.substring(6, 10)) +
                                int.parse(periodoController.text))
                            .toString()
                    : "";
                print("initialDate: ${initialDate.text}");
                polizaObj.vigDesde = initialDate.text;
                //polizaObj.notifyListeners();
              });
            },
            onSaved: (DateTime date) {
              setState(() {
                polizaObj.vigDesde = date.toString(); //TODO Revisar
              });
            },
            resetIcon: Icon(Icons.delete),
            readOnly: false,
            decoration: InputDecoration(
                icon: Icon(Icons.date_range),
                labelText: 'Vigencia Desde /From'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<Clausulado>(
              decoration: InputDecoration(
                  labelText: "Clausulado", icon: Icon(Icons.text_fields)),
              value: clausuladoValue,
              onChanged: (Clausulado newValue) {
                setState(() {
                  clausuladoValue = newValue;
                  print("clausulado value ${clausuladoValue.textoClausulado}");
                });
              },
              validator: (Clausulado value) {
                if (value == null ?? true) {
                  return 'Favor seleccione un clausulado';
                }
                return null;
              },
              items: prodClausulado.map((Clausulado value) {
                return DropdownMenuItem<Clausulado>(
                  value: value,
                  child: Text(value.prodClausulado),
                );
              }).toList(),
              onSaved: (val) => setState(() {
                polizaObj.textoClausulado = val.textoClausulado;
                polizaObj.productoClausulado = val.prodClausulado;
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  labelText: "Tipo de poliza", icon: Icon(Icons.book)),
              value: tipoPolizaValue,
              onChanged: (String newValue) {
                setState(() {
                  tipoPolizaValue = newValue;
                });
              },
              validator: (String value) {
                if (value?.isEmpty ?? true) {
                  return 'Favor ingrese el tipo de poliza';
                }
                return null;
              },
              items: tipoPoliza.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onSaved: (val) => setState(() => polizaObj.descTipoPoliza = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  labelText: "Tipo de negocio", icon: Icon(Icons.store)),
              value: tipoNegocioValue,
              onChanged: (String newValue) async {
                amparos = List();
                amparosMap = await getAmparos(newValue);
                amparosMap.data.forEach((key, value) {
                  amparos.add(Amparo.fromMap(value.cast<String, dynamic>()));
                });
                setState(() {
                  tipoNegocioValue = newValue;
                  polizaObj.amparos = amparos;
                  //Notify listeners updates the object and refresh all the UI
                  polizaObj.notifyListeners();
                });
              },
              validator: (String value) {
                if (value?.isEmpty ?? true) {
                  return 'Favor ingrese el tipo de negocio';
                }
                return null;
              },
              items: tipoNeg.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onSaved: (val) => setState(() => polizaObj.descTipoNegocio = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: cupoController,
              decoration: InputDecoration(
                  labelText: 'Budget /Cupo Disponible',
                  icon: Icon(Icons.attach_money)),
              enabled: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Debe verificarse el cupo';
                }
                return null;
              },
              onSaved: (val) =>
                  setState(() => polizaObj.cupoDisponible = int.parse(val)),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Future<DocumentSnapshot> getAmparos(String newValue) async {
    return Firestore.instance.collection("tipoNeg").document("$newValue").get();
  }
}
