import 'package:flutter/material.dart';
import 'package:appsolidariav2/model/user.dart';
import 'package:appsolidariav2/widgets/datetime.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:intl/date_symbol_data_local.dart';

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

  DateFormat dateFormat;//DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"); //DateFormat('dd-MM-yyyy'); DateFormat.yMMMd()

  TextEditingController initialDate = TextEditingController();
  TextEditingController prueba = TextEditingController();
  TextEditingController periodoController = TextEditingController();

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
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  _FirstPageState() {
    textField = SimpleAutoCompleteTextField(
      key: key,
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      textSubmitted: (text) => setState(() {
            added.add(text);
          }),
    );
  }

  List<String> suggestions = [
    "Apple",
    "Armidillo",
    "Actual",
    "Actuary",
    "America",
    "Argentina",
    "Australia",
    "Antarctica",
    "Blueberry",
    "Cheese",
    "Danish",
    "Eclair",
    "Fudge",
    "Granola",
    "Hazelnut",
    "Ice Cream",
    "Jely",
    "Kiwi Fruit",
    "Lamb",
    "Macadamia",
    "Nachos",
    "Oatmeal",
    "Palm Oil",
    "Quail",
    "Rabbit",
    "Salad",
    "T-Bone Steak",
    "Urid Dal",
    "Vanilla",
    "Waffles",
    "Yam",
    "Zest"
  ];

  SimpleAutoCompleteTextField textField;

  @override
  void initState() {
    initializeDateFormatting();
    dateFormat = new DateFormat.yMMMMd('es'); //new DateFormat('dd-MM-yyyy','es');
    minDate = DateTime(_fromDate.year - 1, _fromDate.month, _fromDate.day);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Poliza nueva')),
        body: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Builder(
                builder: (context) => Form(
                    key: _formKey,
                    child: ListView(children: [
                      //Center(child: Text("Fecha emision: ${dateFormat.format(_fechaEmision)}")),
                      /*
                      SimpleAutoCompleteTextField(
                        key: key,
                        suggestions: suggestions,
                        textChanged: (text) => currentText = text,
                        textSubmitted: (text) => setState(() {
                              added.add(text);
                            }),
                      ),
                      //https://flutterawesome.com/an-autocomplete-textfield-for-flutter/
                      //https://github.com/felixlucien/flutter-autocomplete-textfield/blob/master/example/lib/main.dart
*/
                      DropdownButtonFormField<String>(
                        value: dropdownValue,
                        hint: Text("Type of business"),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                            prueba.text = newValue;
                          });
                        },
                        validator: (String value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter a valid type of business';
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



/*
                      DropdownButton<String>(
                        value: dropdownValue,
                        hint: Text("Tipo de negocio"),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: tipoNeg1
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      */
                      TextFormField(
                        decoration: InputDecoration(labelText: 'First name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your first name';
                          }
                        },
                        onSaved: (val) => setState(() => _user.name = val),
                      ),
                      TextFormField(
                        controller: periodoController,
                        decoration: InputDecoration(labelText: 'Periodo'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Ingrese un periodo valido';
                          }
                        },
                        onSaved: (val) => setState(() => _user.periodo = int.parse(val)),
                      ),
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
                      DateTimePickerFormField(
                        controller: initialDate,
                        format: dateFormat,
                        enabled: true,
                        dateOnly: true,
                        validator: (value) {
                          if (value == null) {
                            return 'Debe ingresar una fecha valida de contrato';
                          } else if (minDate.isAfter(value)){
                            return 'Retroactividad máxima superada';
                          }
                        },
                        onChanged: (DateTime date) {
                          setState(() {
                            _fromDate1 = date;
                          });
                        },
                        onFieldSubmitted: (DateTime date) {
                          setState(() {
                            _fromDate1 = date;
                          });
                        },
                      ),

                      DateTimePickerFormField(
                        //firstDate: _fromDate1,
                        initialDate: (_fromDate1 != null && periodoController.text  != null) ? DateTime(_fromDate1.year - int.parse(periodoController.text), _fromDate1.month, _fromDate1.day) : null,
                        //initialValue: DateTime.parse(initialDate.text),
                        format: dateFormat,
                        enabled: true,
                        dateOnly: true,
                        validator: (value) {
                          if (value == null) {
                            return 'Debe ingresar una fecha valida de contrato';
                          } else if (minDate.isAfter(value)){
                            return 'Retroactividad máxima superada';
                          }
                        },
                      ),

                      DateTimePicker(
                        labelText: 'From',
                        selectedDate: _fromDate,
                        selectedTime: _fromTime,
                        selectDate: (DateTime date) {
                          setState(() {
                            _fromDate = date;
                          });
                        },
                        selectTime: (TimeOfDay time) {
                          setState(() {
                            _fromTime = time;
                          });
                        },
                      ),
                      DateTimePicker(
                        labelText: 'To',
                        selectedDate: DateTime(
                            _fromDate.year + 1, _fromDate.month, _fromDate.day),
                        selectedTime: _toTime,
                        selectDate: (DateTime date) {
                          setState(() {
                            _fromDate = date;
                          });
                        },
                        selectTime: (TimeOfDay time) {
                          setState(() {
                            _fromTime = time;
                          });
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
