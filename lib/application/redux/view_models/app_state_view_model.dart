import 'package:async_redux/async_redux.dart';
import 'package:autoflex/application/redux/state/app_state.dart';

class AppStateViewModel extends Vm {
  AppStateViewModel({
    required this.appState,
    required this.wait,
  }) : super(equals: <Object?>[appState, wait]);

  final AppState appState;
  final Wait wait;

  static AppStateViewModel fromStore(Store<AppState> store) {
    return AppStateViewModel(
      appState: store.state,
      wait: store.state.wait ?? Wait(),
    );
  }
}
