import 'package:appsolidariav2/model/user.dart';
import 'package:appsolidariav2/screens/page1.dart';
import 'package:appsolidariav2/screens/page2.dart';
import 'package:appsolidariav2/shared/state/state.dart';
import 'package:appsolidariav2/utils/ui_utils.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:extended_tabs/extended_tabs.dart';

class _PageSelector extends StatefulWidget {
  @override
  __PageSelectorState createState() => __PageSelectorState();
}

class __PageSelectorState extends State<_PageSelector>
{
  bool loading = true;
  List<User> users = List<User>();

  static List<User> loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  void _handleArrowButtonPress(BuildContext context, int delta) {
    final TabController controller = DefaultTabController.of(context);
    final int controllerLength = 4;
    if (!controller.indexIsChanging)
      controller.animateTo((controller.index + delta).clamp(
          0, controllerLength - 1)); //2 se cambia por widget.icons.length
  }

  //TODO Inicializar el objeto con los campos que se traen del sistema por ahora que son:
  //poliza,sede,fechaEmision = now, numero,temporario,periodo, estado, intermediario, comision, cupoOperativo.
  //cuando se incluya inicializar tambien la variable cumulo.

  @override
  Widget build(BuildContext context) {
    final TabController controller = DefaultTabController.of(context);
    final Color color = Theme.of(context).accentColor;
    return StoreConnector<AppState, Page1ViewModel>(converter: (store) {
      return Page1ViewModel(
          page1formState: store.state.page1formState,
          onSave: () {
            //store.dispatch();
            User savedUser = store.state.page1formState.toUser();
            print("======================================");
            print("Id: ${savedUser.id}");
            print("Name: ${savedUser.name}");
            print("Email: ${savedUser.email}");
            print("TypeNeg: ${savedUser.typeNeg}");
            print("======================================");
          },
          onBusinessTypeChange: (selectedBusiness) {
            store.dispatch(BusinessTypeChanged(selectedBusiness));
          },
          onSaveFromDate: (DateTime date) {
            store.dispatch(FromDateChanged(date));
          },
          onChangeFromDate1: (DateTime date) {
            store.dispatch(FromDate1Changed(date));
          },
          onChangeSelectedUser: (selectedUser) {
            store.dispatch(UserChanged(selectedUser));
          },
          onChangeCupo: (cupo) {
            store.dispatch(CupoChanged(cupo));
          },
          resetForm: () => store.dispatch(ResetForm()));
    }, onInit: (store) async {
      // store.state.page1formState.getUsers();
      try {
        final response =
            await http.get("https://jsonplaceholder.typicode.com/users");
        if (response.statusCode == 200) {
          users = loadUsers(response.body);
          print('Users: ${users.length}');

          store.dispatch(LoadingChanged(false));
          loading = false;
        } else {
          print("Error getting users.");
        }
      } catch (e) {
        print("Error getting users.");
      }
      print(
          "tipoNeg1 : ${store.state.page1formState.tipoNeg1}   ${store.state.page1formState.tipoNeg1 == null}");
    },rebuildOnChange: true, builder: (BuildContext context, Page1ViewModel vm) {
      return SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    color: color,
                    onPressed: () {
                      _handleArrowButtonPress(context, -1);
                    },
                    tooltip: 'Atras',
                  ),
                  TabPageSelector(controller: controller),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    color: color,
                    onPressed: () {
                      _handleArrowButtonPress(context, 1);
                    },
                    tooltip: 'Adelante',
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
            Expanded(
              child: IconTheme(
                data: IconThemeData(
                  color: color,
                ),
                //TODO puse TabBarView dentro de form vamos a ver si funciona!!!
                child: ExtendedTabBarView(
                  //Aca se definen las ventanas _____________________________________
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Card(
                        margin: EdgeInsets.all(10.0),
                        child: Form(
                          key: vm.page1formState.formKey,
                          child: Column(
                            children: <Widget>[
                              ExpansionTile(
                                title: Text("Basic Data"),
                                initiallyExpanded: true,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                          labelText: "Type of business",
                                          icon: Icon(Icons.store)),
                                      value: vm.page1formState.dropdownValue,
                                      onChanged: (String newValue) {
                                        vm.onBusinessTypeChange(newValue);
                                      },
                                      validator: (String value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'Favor ingrese el tipo de negocio';
                                        }
                                      },
                                      items: vm.page1formState.tipoNeg1
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value ?? "null",
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onSaved: (val) {
                                        print("Onsave called");
                                        vm.page1formState.dropdownValue = val;
                                      },
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: loading
                                          ? CircularProgressIndicator()
                                          : SimpleAutocompleteFormField(
                                              decoration: InputDecoration(
                                                  labelText: 'User/ Afianzado',
                                                  icon: Icon(Icons.person)),
                                              suggestionsHeight: 80.0,
                                              controller: vm.page1formState
                                                  .userAutocompleteController,
                                              itemBuilder: (context, user) =>
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(user.name,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Text(user.email)
                                                        ]),
                                                  ),
                                              onSearch: (search) async => users
                                                  .where((user) =>
                                                      user.name
                                                          .toLowerCase()
                                                          .contains(search
                                                              .toLowerCase()) ||
                                                      user.email
                                                          .toLowerCase()
                                                          .contains(search
                                                              .toLowerCase()))
                                                  .toList(),
                                              itemFromString: (string) => users
                                                  .singleWhere(
                                                      (user) =>
                                                          user.name
                                                              .toLowerCase() ==
                                                          string.toLowerCase(),
                                                      orElse: () => null),
                                              onChanged: (value) {
                                                if (value == null) return;
                                                vm.onChangeSelectedUser(value);
                                                vm.onChangeCupo(value.email);
//                                                  vm.page1formState
//                                                      .selectedUser = value;
                                                vm.page1formState.cupoController
                                                    .text = value.email;
                                              },
                                              onSaved: (value) {
                                                vm.page1formState.selectedUser =
                                                    value;
                                                // _user.name = value.name;
                                                print(
                                                    "Selected user email ${vm.page1formState.selectedUser.email}");
                                              },
                                              validator: (user) => user == null
                                                  ? 'El Afianzado no existe.'
                                                  : null,
                                            ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller:
                                          vm.page1formState.cupoController,
                                      decoration: InputDecoration(
                                          labelText: 'Budget /Cupo Disponible',
                                          icon: Icon(Icons.attach_money)),
                                      enabled: true,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Debe verificarse el cupo';
                                        }
                                      },
                                      onSaved: (val) {
                                        vm.page1formState.cupoController.text =
                                            val;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                initiallyExpanded: true,
                                title: Text("Informacion del contrato"),
                                children: <Widget>[
                                  TextFormField(
                                    controller:
                                        vm.page1formState.periodoController,
                                    decoration: InputDecoration(
                                        labelText: 'Period /Período en años',
                                        icon: Icon(Icons.access_time)),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Período inválido';
                                      }
                                    },
                                    onSaved: (val) {
                                      vm.page1formState.periodoController.text =
                                          val;
                                    },
                                  ),
                                  DateTimePickerFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Fecha inicio /From'),
                                    controller:
                                        vm.page1formState.initialDateController,
                                    format: vm.page1formState.dateFormat,
                                    enabled: true,
                                    dateOnly: true,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Debe ingresar una fecha valida de contrato';
                                      } else if (vm.page1formState.minDate
                                          .isAfter(value)) {
                                        return 'Retroactividad máxima superada';
                                      }
                                    },
                                    onChanged: (DateTime date) {
                                      vm.onSaveFromDate(date);
                                      setState(() {
                                        vm.page1formState.fromDate = date;
                                        //initialDate.text = date.toString();
                                        //finalDate is the controller for the next date
                                        vm.page1formState.finalDateController.text = vm
                                                    .page1formState
                                                    .initialDateController
                                                    .text !=
                                                ""
                                            ? vm.page1formState.initialDateController.text
                                                    .substring(0, 2) +
                                                "-" +
                                                vm.page1formState.initialDateController.text
                                                    .substring(3, 5) +
                                                "-" +
                                                (int.parse(vm
                                                            .page1formState
                                                            .initialDateController
                                                            .text
                                                            .substring(6, 10)) +
                                                        int.parse(vm.page1formState.periodoController.text))
                                                    .toString()
                                            : "";
                                        print(
                                            "initialDate: ${vm.page1formState.initialDateController.text}");
                                        print(
                                            "Period: ${vm.page1formState.periodoController.text}");
                                      });
                                    },
                                    onFieldSubmitted: (DateTime date) {
                                      setState(() {
                                        vm.page1formState.fromDate1 = date;
                                      });
                                    },
                                    onSaved: (fromDate) {
                                      vm.page1formState.fromDate1 = fromDate;
                                    },
                                  ),
                                  DateTimePickerFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Fecha final /To'),
                                    //firstDate: _fromDate1,
                                    controller:
                                        vm.page1formState.finalDateController,
                                    initialDate:
                                        (vm.page1formState.fromDate1 != null &&
                                                vm.page1formState
                                                        .periodoController.text !=
                                                    "")
                                            ? DateTime(
                                                vm.page1formState.fromDate1.year +
                                                    int.parse(vm.page1formState
                                                        .periodoController.text),
                                                vm.page1formState.fromDate1.month,
                                                vm.page1formState.fromDate1.day)
                                            : DateTime.now(),
                                    initialValue: (vm.page1formState.finalDateController.text != "" &&
                                            vm.page1formState.periodoController.text !=
                                                "")
                                        ? DateTime.parse(
                                            (int.parse(vm.page1formState.finalDateController.text.substring(6, 10)) +
                                                        int.parse(vm
                                                            .page1formState
                                                            .periodoController
                                                            .text))
                                                    .toString() +
                                                vm.page1formState
                                                    .finalDateController.text
                                                    .substring(3, 5) +
                                                vm.page1formState
                                                    .finalDateController.text
                                                    .substring(0, 2))
                                        : DateTime.now(),
                                    format: vm.page1formState.dateFormat,
                                    enabled: true,
                                    dateOnly: true,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Debe ingresar una fecha valida de contrato';
                                      } else if (vm.page1formState.minDate
                                          .isAfter(value)) {
                                        return 'Retroactividad máxima superada';
                                      }
                                    },
                                    onSaved: (toDate) {
                                      vm.page1formState.fromDate1 = toDate;
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                        margin: EdgeInsets.all(10.0),
                        child: Center(
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 16.0),
                                child: RaisedButton(
                                    onPressed: () {
                                      //  final form1 = vm
                                      //      .page1formState.formKey1.currentState;
                                      final form = vm
                                          .page1formState.formKey.currentState;
                                      //bool hasError = form.validate();
                                      //bool hasError1 = form1.validate();

                                      if (form.validate()) {
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text('Processing Data')));
                                        form.save();
                                        vm.onSave();
                                        vm.resetForm();
                                      }
                                    },
                                    child: Text('Save'))))),
                  ],
                  cacheExtent: 3,// How Many pages you want to save in cache
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

}

class PageSelectorDemo extends StatelessWidget {
  static const String routeName = '/material/page-selector';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Póliza'),
        actions: <Widget>[],
      ),
      body: DefaultTabController(
        length: 3,
        child: _PageSelector(),
      ),
    );
  }
}

class Page1ViewModel {
  Page1FormState page1formState;
  final Function() onSave;
  final Function() resetForm;
  final Function(DateTime date) onChangeFromDate;
  final Function(DateTime date) onChangeFromDate1;
  final Function(User selectedUser) onChangeSelectedUser;
  final Function(String cupo) onChangeCupo;
  final Function(String typeNeg) onSaveTypeNeg;
  final Function(User user) onSaveUser;
  final Function(String cupo) onSaveCupo;
  final Function(String period) onSavePeriod;
  final Function(DateTime fromDate) onSaveFromDate;
  final Function(DateTime toDate) onSaveToDate;
  final void Function(String selectedBusiness) onBusinessTypeChange;

  Page1ViewModel(
      {this.page1formState,
      this.onSave,
      this.onBusinessTypeChange,
      this.onChangeFromDate,
      this.onChangeFromDate1,
      this.onChangeSelectedUser,
      this.onChangeCupo,
      this.onSaveFromDate,
      this.onSaveCupo,
      this.onSavePeriod,
      this.onSaveToDate,
      this.onSaveTypeNeg,
      this.onSaveUser,
      this.resetForm});
}
