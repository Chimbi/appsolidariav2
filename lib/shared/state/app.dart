import 'package:appsolidariav2/screens/temp/state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';
import 'package:appsolidariav2/shared/state/state.dart';
import 'package:redux/redux.dart';

final stateReducers = combineReducers<AppState>([
  page1FormStateReducer,
]);

class AppState {
  //static final actionStream = BehaviorSubject<dynamic>();
  final bool developerMode;
  final BuildContext context;
  final Page1FormState page1formState;
  AppState({this.developerMode, this.context, this.page1formState});
  factory AppState.initial({bool developerMode = false}) {
    AppState state = AppState(
        developerMode: developerMode,
        page1formState: Page1FormState.initial(fromDate: DateTime(2019)));

    return state;
  }
  AppState copyWith({
    BuildContext context,
    Page1FormState page1formState,
    // all sub states

    dynamic error,
  }) {
    return AppState(
      context: context ?? this.context,
      page1formState: page1formState ?? this.page1formState,
      // All sub states
    );
  }
}
