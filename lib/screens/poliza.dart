import 'dart:convert';

import 'package:appsolidariav2/model/amparoModel.dart';
import 'package:appsolidariav2/model/polizaModel.dart';
import 'package:appsolidariav2/screens/page1.dart';
import 'package:appsolidariav2/screens/page2.dart';
import 'package:appsolidariav2/utils/ui_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      title: Text('Revision'),
      content: Page3(),
      state: StepState.complete,
      isActive: true,
    ),
  ];
  //Lista de todos los Amparos
  List<Amparo> allAmparos = List();
  //Lista de amparos en el objeto polizaObj.amparos
  List<String> amparosObjList = List();
  //Lista de amparos que no estan en el objeto polizaObj.amparos
  List<Amparo> otherAmparos = List();
  DocumentSnapshot allAmparosMap;

  @override
  Widget build(BuildContext context) {
    var polizaObj = Provider.of<Poliza>(context);
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
                            borderRadius:
                            BorderRadiusDirectional.circular(10.0)),
                        color: azulSolidaria2,
                        onPressed: onStepContinue,
                        child: const Text(
                          'SIGUIENTE',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      OutlineButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadiusDirectional.circular(10.0)),
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
                          onPressed: () async {
                            otherAmparos = List();
                            allAmparosMap = await getAllAmparos();
                            if(polizaObj.amparos!=null){}
                            amparosObjList = polizaObj.amparos.map((amp){
                              return amp.concepto;
                            }).toList();
                            allAmparosMap.data.forEach((key,value){
                              if(!amparosObjList.contains(key)){
                               otherAmparos.add(Amparo.fromMap(value.cast<String,dynamic>()));
                              }
                            });
                            polizaObj.amparos.addAll(otherAmparos);
                            polizaObj.notifyListeners();
                            print("OtherAmparos: ${otherAmparos.toString()}");
                          },
                          child: const Text(
                            'OTROS AMPAROS',
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
            final form = formKey.currentState;
            setState(() {
              if (current_step < steps.length - 1) {
                current_step = current_step + 1;
              } else {
                if (form.validate()) {
                  //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                  form.save();
                  Navigator.pop(context);
                } else {
                  print("form.validate: ${form.validate()}");
                  print("form state: $form");
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
                                  'Para emitir la poliza correctamente'),
                              Text('agradecemos diligenciar el formulario en su totalidad'),
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
                current_step = 0;
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

  Future<DocumentSnapshot> getAllAmparos() async{
    return Firestore.instance
        .collection("tipoNeg")
        .document("All")
        .get();
  }

}
