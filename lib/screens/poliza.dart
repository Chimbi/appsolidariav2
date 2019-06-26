import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:appsolidariav2/model/user.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

List<User> users = new List<User>();

class PolizaForm extends StatefulWidget {
  @override
  _PolizaFormState createState() => _PolizaFormState();
}

class _PolizaFormState extends State<PolizaForm> {
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<PolizaFormState>
  final _formKey = GlobalKey<FormState>();

  //Use Form.of() to acces the form within nested widgets
  final _user = User();
  TextEditingController mycontroller = TextEditingController();

  DateTime _fromDate = DateTime.now();
  DateTime _fromDate1;
  DateTime _fechaEmision = DateTime.now();
  DateTime minDate;
  TimeOfDay _fromTime = const TimeOfDay(hour: 7, minute: 28);

  //DateTime _toDate = DateTime.now();
  TimeOfDay _toTime = const TimeOfDay(hour: 23, minute: 59);

  //final List<String> _allActivities = <String>['hiking', 'swimming', 'boating', 'fishing'];
  //String _activity = 'fishing';

  DateFormat
      dateFormat; //DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"); //DateFormat('dd-MM-yyyy'); DateFormat.yMMMd()

  TextEditingController initialDate = TextEditingController();
  TextEditingController finalDate = TextEditingController();
  TextEditingController prueba = TextEditingController();
  TextEditingController periodoController = TextEditingController();
  TextEditingController cupoController = TextEditingController();

  List<String> typeNeg = [
    "One",
    "Two",
    "Three",
  ];
  List<String> tipoNeg1 = [
    "Particular",
    "Estatal",
    "Servicios Publicos",
    "Poliza Ecopetrol",
    "E.Publicas R.Privado"
  ];
  String dropdownValue = null;

  List<String> added = [];
  String currentText = "";

  bool isSearchFieldEmpty = true;
  bool isValidatorClicked = false;

  //Autocomplete variables

  User selectedUser;

  bool loading = true;

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

  //Widget used to display results in the AutoComplete Widget
  Widget row(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          user.name,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          user.email,
          style: TextStyle(color: Colors.blueAccent),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Poliza nueva'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: UserSearch())
                      .then((user) => print("${user.name}"));
                })
          ],
        ),
        body: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Builder(
                builder: (context) => Form(
                    key: _formKey,
                    child: ListView(children: [
                      //Center(child: Text("Fecha emision: ${dateFormat.format(_fechaEmision)}")),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                            "Bienvenido al modulo de emisión, por favor ingrese los siguientes datos:"),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            labelText: "Type of business",
                            icon: Icon(Icons.store)),
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
                        items: tipoNeg1
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onSaved: (val) => setState(() => _user.typeNeg = val),
                      ),
                      Center(
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
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                validator: (user) => user == null
                                    ? 'El Afianzado no existe.'
                                    : null,
                              ),
                      ),
                      TextFormField(
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
                        decoration:
                            InputDecoration(labelText: 'Fecha inicio /From'),
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
                                    (int.parse(initialDate.text
                                                .substring(6, 10)) +
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
                        decoration:
                            InputDecoration(labelText: 'Fecha final /To'),
                        //firstDate: _fromDate1,
                        controller: finalDate,
                        initialDate:
                            (_fromDate1 != null && periodoController.text != "")
                                ? DateTime(
                                    _fromDate1.year +
                                        int.parse(periodoController.text),
                                    _fromDate1.month,
                                    _fromDate1.day)
                                : DateTime.now(),
                        initialValue: (finalDate.text != "" &&
                                periodoController.text != "")
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
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                          child: RaisedButton(
                              onPressed: () {
                                final form = _formKey.currentState;
                                if (form.validate()) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('Processing Data')));
                                  form.save();
                                  _user.save();
                                  _showDialog(context);
                                }
                              },
                              child: Text('Save'))),
                      /*
                          //Money text form field
                          MoneyTextFormField(
                              settings: MoneyTextFormFieldSettings(
                                appearanceSettings: AppearanceSettings(
                                  labelText: 'Valor Contrato',
                                 ),
                                  moneyFormatSettings: MoneyFormatSettings(
                                    fractionDigits: 2,
                                  ),
                                  controller: mycontroller,
                                validator: (value){
                                  if(value.isEmpty) {
                                    return 'Please enter a valid contract value.';
                                  }
                                }
                              ),
                          ),
*/
/*
                      DateTimePickerFormField(
                        format: dateFormat,
                        onChanged: (date) {
                          Scaffold
                              .of(context)
                              .showSnackBar(SnackBar(content: Text('$date')));
                        },
                      ),
*/
                    ])))));
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }
}

/*
onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/terceros');
            }),
 */
class UserSearch extends SearchDelegate<User> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    final results = users.where((a) => a.name.toLowerCase().contains(query));

    return ListView(
      children: results.map<ListTile>((a) {
        return ListTile(
          title: Text(a.name),
          leading: Icon(Icons.book),
          subtitle: Text(a.email),
          onTap: () {
            close(context, a);
          },
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    final results = users.where((a) => a.name.toLowerCase().contains(query));

    return ListView(
      children: results.map<ListTile>((a) {
        return ListTile(
          title: Text(a.name),
          leading: Icon(Icons.book),
          subtitle: Text(a.email),
          onTap: () {
            close(context, a);
          },
        );
      }).toList(),
    );
  }
}
