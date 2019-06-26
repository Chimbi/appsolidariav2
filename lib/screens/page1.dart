import 'dart:convert';

import 'package:appsolidariav2/model/user.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:http/http.dart' as http;

List<User> users = new List<User>();

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> with AutomaticKeepAliveClientMixin {
  String dropdownValue = null;

  DateFormat
      dateFormat; //DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"); //DateFormat('dd-MM-yyyy'); DateFormat.yMMMd()

  TextEditingController initialDate = TextEditingController();
  TextEditingController finalDate = TextEditingController();
  TextEditingController prueba = TextEditingController();
  TextEditingController periodoController = TextEditingController();
  TextEditingController cupoController = TextEditingController();

  DateTime _fromDate = DateTime.now();
  DateTime _fromDate1;
  DateTime _fechaEmision = DateTime.now();
  DateTime minDate;

  List<String> tipoNeg1 = [
    "Particular",
    "Estatal",
    "Servicios Publicos",
    "Poliza Ecopetrol",
    "E.Publicas R.Privado"
  ];
  bool loading = true;
  final _user = User();
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

  @override
  void initState() {
    getUsers();
    initializeDateFormatting();
    dateFormat = new DateFormat('dd-MM-yyyy'); //new DateFormat.yMMMMd('es');
    minDate = DateTime(_fromDate.year - 1, _fromDate.month, _fromDate.day);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            ExpansionTile(
              title: Text("Basic Data"),
              initiallyExpanded: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        labelText: "Type of business", icon: Icon(Icons.store)),
                    value: dropdownValue,
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        prueba.text = newValue;
                      });
                    },
                    validator: (String value) {
                      if (value?.isEmpty ?? true) {
                        return 'Favor ingrese el tipo de negocio';
                      }
                    },
                    items:
                        tipoNeg1.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onSaved: (val) => setState(() => _user.typeNeg = val),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: loading
                        ? CircularProgressIndicator()
                        : SimpleAutocompleteFormField<User>(
                            decoration: InputDecoration(
                                labelText: 'User/ Afianzado',
                                icon: Icon(Icons.person)),
                            suggestionsHeight: 80.0,
                            itemBuilder: (context, user) => Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(user.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
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
                                    user.name.toLowerCase() ==
                                    string.toLowerCase(),
                                orElse: () => null),
                            onChanged: (value) {
                              setState(() {
                                selectedUser = value;
                                cupoController.text = value.email;
                              });
                            },
                            onSaved: (value) => setState(() {
                                  selectedUser = value;
                                  _user.name = value.name;
                                  print(
                                      "Selected user email ${selectedUser.email}");
                                }),
                            validator: (user) =>
                                user == null ? 'El Afianzado no existe.' : null,
                          ),
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
                    },
                    onSaved: (val) =>
                        setState(() => _user.periodo = int.parse(val)),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              initiallyExpanded: true,
              title: Text("Informacion del contrato"),
              children: <Widget>[
                TextFormField(
                  controller: periodoController,
                  decoration: InputDecoration(
                      labelText: 'Period /Período en años',
                      icon: Icon(Icons.access_time)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Período inválido';
                    }
                  },
                  onSaved: (val) =>
                      setState(() => _user.periodo = int.parse(val)),
                ),
                DateTimePickerFormField(
                  decoration: InputDecoration(labelText: 'Fecha inicio /From'),
                  controller: initialDate,
                  format: dateFormat,
                  enabled: true,
                  dateOnly: true,
                  validator: (value) {
                    if (value == null) {
                      return 'Debe ingresar una fecha valida de contrato';
                    } else if (minDate.isAfter(value)) {
                      return 'Retroactividad máxima superada';
                    }
                  },
                  onChanged: (DateTime date) {
                    setState(() {
                      _fromDate1 = date;
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
                    });
                  },
                  onFieldSubmitted: (DateTime date) {
                    setState(() {
                      _fromDate1 = date;
                    });
                  },
                ),
                DateTimePickerFormField(
                  decoration: InputDecoration(labelText: 'Fecha final /To'),
                  //firstDate: _fromDate1,
                  controller: finalDate,
                  initialDate: (_fromDate1 != null &&
                          periodoController.text != "")
                      ? DateTime(
                          _fromDate1.year + int.parse(periodoController.text),
                          _fromDate1.month,
                          _fromDate1.day)
                      : DateTime.now(),
                  initialValue:
                      (finalDate.text != "" && periodoController.text != "")
                          ? DateTime.parse(
                              (int.parse(finalDate.text.substring(6, 10)) +
                                          int.parse(periodoController.text))
                                      .toString() +
                                  finalDate.text.substring(3, 5) +
                                  finalDate.text.substring(0, 2))
                          : DateTime.now(),
                  format: dateFormat,
                  enabled: true,
                  dateOnly: true,
                  validator: (value) {
                    if (value == null) {
                      return 'Debe ingresar una fecha valida de contrato';
                    } else if (minDate.isAfter(value)) {
                      return 'Retroactividad máxima superada';
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
