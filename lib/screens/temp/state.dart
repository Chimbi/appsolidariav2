import 'dart:convert';

import 'package:appsolidariav2/model/user.dart';
import 'package:appsolidariav2/shared/state/app.dart';
import 'package:flutter/material.dart'
    show FormState, GlobalKey, TextEditingController, TimeOfDay;
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

class Page1FormState {
  // Registration response
  final bool registrationError;
  final String registrationMessage;
  final bool registrationOnGoing;
  String dropdownValue;

  final GlobalKey<FormState> formKey;

  final TextEditingController initialDateController;
  final TextEditingController finalDateController;
  final TextEditingController pruebaController;
  final TextEditingController periodoController;
  final TextEditingController cupoController;
  final List<String> tipoNeg1;
  User selectedUser;
  List<User> users;
  bool loading;
  DateFormat dateFormat;
  DateTime minDate;
  DateTime fromDate;
  DateTime fromDate1;
  Page1FormState({
    this.registrationOnGoing,
    this.registrationError,
    this.registrationMessage,
    this.initialDateController,
    this.finalDateController,
    this.pruebaController,
    this.periodoController,
    this.cupoController,
    this.formKey,
    this.dropdownValue,
    this.tipoNeg1,
    this.users,
    this.loading,
    this.selectedUser,
    this.dateFormat,
    this.minDate,
    this.fromDate,
    this.fromDate1,
  });

  factory Page1FormState.initial({DateTime fromDate}) {
    print("Initial called");
    return Page1FormState(
      registrationOnGoing: false,
      registrationError: false,
      registrationMessage: "",
      cupoController: TextEditingController(),
      finalDateController: TextEditingController(),
      initialDateController: TextEditingController(),
      periodoController: TextEditingController(),
      pruebaController: TextEditingController(),
      formKey: GlobalKey<FormState>(debugLabel: "page-one-form-key"),
      tipoNeg1: <String>[
        "Particular",
        "Estatal",
        "Servicios Publicos",
        "Poliza Ecopetrol",
        "E.Publicas R.Privado"
      ],
      users: List<User>(),
      loading: true,
      selectedUser: User(),
      dateFormat: new DateFormat('dd-MM-yyyy'),
      minDate: DateTime(fromDate.year - 1, fromDate.month, fromDate.day),
      fromDate: DateTime.now(),
      fromDate1: null,
    );
  }

  Page1FormState copyWith({
    bool registrationOnGoing,
    bool registrationError,
    String registrationMessage,
    TextEditingController initialDateController,
    TextEditingController finalDateController,
    TextEditingController pruebaController,
    TextEditingController periodoController,
    TextEditingController cupoController,
    String dropdownValue,
    List<User> users,
    bool loading,
    DateFormat dateFormat,
    DateTime minDate,
    DateTime fromDate,
    DateTime fromDate1,
    User selectedUser,
  }) {
    return Page1FormState(
      formKey: this.formKey,
      initialDateController: this.initialDateController,
      finalDateController: this.finalDateController,
      periodoController: this.periodoController,
      cupoController: this.cupoController,
      pruebaController: this.pruebaController,

      // Registration response,
      registrationOnGoing: registrationOnGoing ?? this.registrationOnGoing,
      registrationError: registrationError ?? this.registrationError,
      registrationMessage: registrationMessage ?? this.registrationMessage,
      dropdownValue: dropdownValue ?? this.dropdownValue,
      users: users ?? this.users,
      fromDate1: fromDate1 ?? this.fromDate1,
      fromDate: fromDate ?? this.fromDate,
      minDate: minDate ?? this.minDate,
      selectedUser: selectedUser ?? this.selectedUser,
      loading: loading ?? this.loading,
      tipoNeg1: this.tipoNeg1, dateFormat: this.dateFormat,
    );
  }

  void getUsers() async {
    try {
      final response =
          await http.get("https://jsonplaceholder.typicode.com/users");
      if (response.statusCode == 200) {
        users = loadUsers(response.body);
        print('Users: ${users.length}');

        loading = false;
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

  User toUser() {
    return User(
        email: cupoController.text,
        id: 1,
        name: selectedUser.name,
        typeNeg: selectedUser.typeNeg);
  }
}

final page1FormStateReducer = combineReducers<AppState>([
  TypedReducer<AppState, RegistrationCompleteResponseAction>(
      registrationComplete),
  TypedReducer<AppState, BusinessTypeChanged>(_businessTypeIndexChanged),
  TypedReducer<AppState, UserChanged>(_userIndexChanged),
  TypedReducer<AppState, FromDateChanged>(_fromDateChanged),
  TypedReducer<AppState, FromDate1Changed>(_fromDate1Changed),
  TypedReducer<AppState, LoadingChanged>(_loadingChanged),
  TypedReducer<AppState, PeriodChanged>(_periodChanged),
]);

class RegistrationCompleteResponseAction {
  final String message;
  final bool error;

  RegistrationCompleteResponseAction(this.message, this.error);
}

class BusinessTypeChanged {
  final String selectedBusinessType;
  BusinessTypeChanged(this.selectedBusinessType);
}

AppState _businessTypeIndexChanged(AppState state, BusinessTypeChanged action) {
  return state.copyWith(
      page1formState: state.page1formState.copyWith(
    dropdownValue: action.selectedBusinessType,
  ));
}

class LoadingChanged {
  final bool loading;
  LoadingChanged(this.loading);
}

AppState _loadingChanged(AppState state, LoadingChanged action) {
  return state.copyWith(
      page1formState: state.page1formState.copyWith(
    loading: action.loading,
  ));
}

class UserChanged {
  final User selectedUser;
  UserChanged(this.selectedUser);
}

AppState _userIndexChanged(AppState state, UserChanged action) {
  return state.copyWith(
      page1formState: state.page1formState.copyWith(
    selectedUser: action.selectedUser,
  ));
}

class FromDateChanged {
  final DateTime date;
  FromDateChanged(this.date);
}

AppState _fromDateChanged(AppState state, FromDateChanged action) {
  return state.copyWith(
      page1formState: state.page1formState.copyWith(
    fromDate: action.date,
  ));
}

class FromDate1Changed {
  final DateTime date;
  FromDate1Changed(this.date);
}

AppState _fromDate1Changed(AppState state, FromDate1Changed action) {
  return state.copyWith(
      page1formState: state.page1formState.copyWith(
    fromDate1: action.date,
  ));
}

class PeriodChanged {
  final String period;
  PeriodChanged(this.period);
}

AppState _periodChanged(AppState state, PeriodChanged action) {
  return state.copyWith(
      page1formState: state.page1formState.copyWith(
    periodoController: TextEditingController(text: action.period),
  ));
}

AppState registrationComplete(
    AppState state, RegistrationCompleteResponseAction action) {
  return state.copyWith(
      page1formState: state.page1formState.copyWith(
    registrationError: action.error,
    registrationMessage: action.message,
    registrationOnGoing: false,
  ));
}
