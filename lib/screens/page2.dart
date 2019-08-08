import 'dart:convert';

import 'package:appsolidariav2/model/amparoModel.dart';
import 'package:appsolidariav2/model/polizaModel.dart';
import 'package:appsolidariav2/model/user.dart';
import 'package:appsolidariav2/screens/page1.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> with AutomaticKeepAliveClientMixin {
  TextEditingController periodoController = TextEditingController();

  String objetoValue;

  bool loading = false;
  final _user = User();
  final _poliza = Poliza();
  User selectedUser;

  List<String> objetoSeg = [
    "Contrato",
    "Orden compra",
    "Orden servicio",
    "Orden suministro",
    "Factura venta",
    "Pliego condiciones",
  ];

  @override
  Widget build(BuildContext context) {
    var polizaObj = Provider.of<Poliza>(context);

    return Container(
      child: Card(
          child: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: loading
                  ? CircularProgressIndicator()
                  : SimpleAutocompleteFormField<User>(
                      decoration: InputDecoration(
                          labelText: 'Contratante', icon: Icon(Icons.person)),
                      suggestionsHeight: 80.0,
                      itemBuilder: (context, user) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(user.email)
                            ]),
                      ),
                      onSearch: (search) async => users
                          .where((user) =>
                              user.name
                                  .toLowerCase()
                                  .contains(search.toLowerCase()) ||
                              user.email
                                  .toLowerCase()
                                  .contains(search.toLowerCase()))
                          .toList(),
                      itemFromString: (string) => users.singleWhere(
                          (user) =>
                              user.name.toLowerCase() == string.toLowerCase(),
                          orElse: () => null),
                      onChanged: (value) {
                        setState(() {
                          selectedUser = value;
                        });
                      },
                      onSaved: (value) => setState(() {
                        selectedUser = value;
                        polizaObj.apellidoRazonSocial = value.name;
                        print("Selected user email ${selectedUser.email}");
                      }),
                      validator: (user) =>
                          user == null ? 'El Contratante no existe.' : null,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              //controller: cupoController,
              decoration: InputDecoration(
                  labelText: 'Numero de contrato',
                  icon: Icon(Icons.folder_shared)),
              enabled: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Favor ingresar numero de contrato';
                }
                return null;
              },
              onSaved: (val) => setState(() {
                polizaObj.numeroContrato = val;
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              //controller: cupoController,
              onChanged: (val) {
                setState(() => polizaObj.valorContrato = double.parse(val));
                polizaObj.notifyListeners();
              },
              decoration: InputDecoration(
                  labelText: 'Valor del contrato',
                  icon: Icon(Icons.attach_money)),
              enabled: true,
              onEditingComplete: () {
                print("Termine de editar");
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Favor ingresar valor del contrato";
                }
                return null;
              },
              onSaved: (val) =>
                  setState(() => polizaObj.valorContrato = double.parse(val)),
            ),
          ),
          Padding(
            //TODO Make it optional
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: periodoController,
              decoration: InputDecoration(
                  labelText: 'Plazo de ejecución',
                  icon: Icon(Icons.folder_shared)),
              enabled: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingresar plazo de ejecución';
                }
                return null;
              },
              onChanged: (val) {
                setState(() {
                  polizaObj.plazoEjecucion = int.parse(val);
                  polizaObj.notifyListeners();
                });
              },
              onSaved: (val) =>
                  setState(() => polizaObj.plazoEjecucion = int.parse(val)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  labelText: "Objeto del seguro", icon: Icon(Icons.store)),
              value: objetoValue,
              onChanged: (String newValue) {
                setState(() {
                  objetoValue = newValue;
                });
              },
              validator: (String value) {
                if (value?.isEmpty ?? true) {
                  return 'Favor ingrese el tipo de negocio';
                }
                return null;
              },
              items: objetoSeg.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onSaved: (val) => setState(() => polizaObj.objetoSeguro = val),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> with AutomaticKeepAliveClientMixin {
  TextEditingController porcentajeTEC;
  TextEditingController initialDateTEC;
  TextEditingController finalDateTEC;
  DateFormat dateFormat;

  DateTime _fechaEmision = DateTime.now();
  DateTime minDate;

  @override
  void initState() {
    initializeDateFormatting();
    dateFormat = new DateFormat('dd-MM-yyyy'); //new DateFormat.yMMMMd('es');
    ///Define fecha mínima como control del sistema.
    minDate = DateTime(
        _fechaEmision.year, _fechaEmision.month - 5, _fechaEmision.day);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var polizaObj = Provider.of<Poliza>(context);
    Poliza poliza = Poliza();
    setState(() {
      polizaObj.amparos = polizaObj.amparos;
    });
    return Container(
      child: Card(
          margin: const EdgeInsets.all(10.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      polizaObj.amparos != null ? polizaObj.amparos.length : 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                        key: UniqueKey(),
                        //confirmDismiss: ,
                        background: Container(
                          padding: EdgeInsets.all(12.0),
                          color: Colors.green,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              Padding(padding: EdgeInsets.all(4.0)),
                              Text(
                                "Confirmar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        secondaryBackground: Container(
                          padding: EdgeInsets.all(12.0),
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              Padding(padding: EdgeInsets.all(4.0)),
                              Text(
                                "Eliminar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            if (direction == DismissDirection.endToStart) {
                              polizaObj.amparos.removeAt(index);
                            } else {
                              print("Amparo confirmado");
                            }
                          });
                        },
                        child: ExpansionTile(
                          initiallyExpanded: false,
                          title: Text(polizaObj.amparos[index].concepto),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Porcentaje:",
                                    icon: Icon(Icons.assessment)),
                                initialValue: polizaObj
                                    .amparos[index].porcentaje
                                    .toString(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Vlr. Asegurado amparo:",
                                    icon: Icon(Icons.assessment)),
                                initialValue: polizaObj.valorContrato != null
                                    ? (polizaObj.amparos[index].porcentaje *
                                            polizaObj.valorContrato)
                                        .toString()
                                    : "",
                              ),
                            ),
                            DateTimeField(
                              format: dateFormat,
                              controller: initialDateTEC,
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
                                    initialTime: TimeOfDay.fromDateTime(
                                        currentValue ?? DateTime.now()),
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
                              initialValue: polizaObj.vigDesde != null
                                  ? DateTime.parse(
                                      (polizaObj.vigDesde.substring(6, 10) +
                                          polizaObj.vigDesde.substring(3, 5) +
                                          polizaObj.vigDesde.substring(0, 2)))
                                  : "",
                              onChanged: (date) => setState(() {
                                initialDateTEC.text = date.toString();
                              }),
                              onSaved: (DateTime date) {
                                setState(() {
                                  polizaObj.amparos[index].fechaInicial =
                                      date.toString();
                                });
                              },
                              resetIcon: Icon(Icons.delete),
                              readOnly: false,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.date_range),
                                  labelText: 'Vigencia Desde amparo'),
                            ),
                            DateTimeField(
                              format: dateFormat,
                              controller: finalDateTEC,
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
                                    initialTime: TimeOfDay.fromDateTime(
                                        currentValue ?? DateTime.now()),
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
                              initialValue: polizaObj.vigDesde != null
                                  ? DateTime.parse(((int.parse(polizaObj
                                                  .vigDesde
                                                  .substring(6, 10)) +
                                              polizaObj.plazoEjecucion +
                                              polizaObj
                                                  .amparos[index].plazoAdic)
                                          .toString() +
                                      polizaObj.vigDesde.substring(3, 5) +
                                      polizaObj.vigDesde.substring(0, 2)))
                                  : null,
                              onChanged: (date) => setState(() {
                                initialDateTEC.text = date.toString();
                                polizaObj.amparos[index].fechaInicial =
                                    initialDateTEC.text;
                              }),
                              onSaved: (DateTime date) {
                                setState(() {
                                  polizaObj.amparos[index].fechaInicial =
                                      date.toString();
                                });
                              },
                              resetIcon: Icon(Icons.delete),
                              readOnly: false,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.date_range),
                                  labelText: 'Vigencia Hasta amparo'),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ));
                  }),
            ],
          )
          ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
