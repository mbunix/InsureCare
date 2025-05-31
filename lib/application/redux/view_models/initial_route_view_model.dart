import 'package:async_redux/async_redux.dart';

import '../state/app_state.dart';

class InitialRouteViewModel extends Vm {
  InitialRouteViewModel({
    this.initialRoute,
    this.isSignedIn,
  }) : super(
          equals: <Object?>[
            initialRoute,
            isSignedIn,
          ],
        );
  final String? initialRoute;
  final bool? isSignedIn;

  factory InitialRouteViewModel.fromStore(AppState state) {
    return InitialRouteViewModel(
      initialRoute: state.miscState?.initialRoute,
      isSignedIn: state.miscState?.isSignedIn,
    );
  }
}
