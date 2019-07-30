import 'dart:convert';

import 'package:appsolidariav2/model/polizaModel.dart';
import 'package:appsolidariav2/screens/page1.dart';
import 'package:appsolidariav2/screens/page2.dart';
import 'package:appsolidariav2/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:appsolidariav2/model/user.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

class PolizaForm extends StatefulWidget {
  @override
  _PolizaFormState createState() => _PolizaFormState();
}

class _PolizaFormState extends State<PolizaForm> {
  final GlobalKey<FormState> formKey = GlobalKey();

  // Step Counter
  int current_step = 0;

  List<Step> steps = [
    Step(
      title: Text('Validación Terceros'),
      content: Page0(),
      isActive: true,
    ),
    Step(
      title: Text('Datos básicos'),
      content: Page1(),
      isActive: true,
    ),
    Step(
      title: Text('Datos del contrato'),
      content: Page2(),
      isActive: true,
    ),
    Step(
      title: Text('Amparos'),
      content: Page3(),
      isActive: true,
    ),
    Step(
      title: Text('Guardar'),
      content: Page3(),
      state: StepState.complete,
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        // Title
        title: Text("Datos Básicos"),
      ),
      // Body
      body: Form(
        key: formKey,
        child: Stepper(
          controlsBuilder: (BuildContext context,
              {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(10.0)),
                        color: azulSolidaria2,
                        onPressed: onStepContinue,
                        child: const Text(
                          'SIGUIENTE',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      OutlineButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(10.0)),
                        onPressed: onStepCancel,
                        child: const Text('CANCELAR'),
                      ),
                    ],
                  ),
                  current_step == 3
                      ? RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadiusDirectional.circular(10.0)),
                    color: amarilloSolidaria1,
                    onPressed: () =>                   showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Formulario incompleto'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(
                                    'Con el fin de calcular los amparos correctamente'),
                                Text('debe diligenciarse el formulario en su'),
                                Text('totalidad. Muchas gracias.')
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Aceptar'),
                              onPressed: () {
                                current_step = 0;
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    child: const Text(
                      'NUEVO AMPARO',
                      style: TextStyle(color: azulSolidaria1),
                    ),
                  )
                      : Container(),
                ],
              ),
            );
          },
          currentStep: this.current_step,
          steps: steps,
          type: StepperType.vertical,
          onStepTapped: (step) {
            setState(() {
              current_step = step;
            });
          },
          onStepContinue: () {
            setState(() {
              final form = formKey.currentState;
              if (current_step < steps.length - 1) {
                current_step = current_step + 1;
              } else {
                current_step = 0;
                if (form.validate()) {
                  //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                  form.save();
                  //Navigator.pop(context);
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
                                  'Con el fin de calcular los amparos correctamente'),
                              Text('debe diligenciarse el formulario en su'),
                              Text('totalidad. Muchas gracias.')
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Aceptar'),
                            onPressed: () {
                              current_step = 0;
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (current_step > 0) {
                current_step = current_step - 1;
              } else {
                current_step = 0;
              }
            });
          },
        ),
      ),
    );
  }
}
