import 'package:async_redux/async_redux.dart';
import 'package:autoflex/presentation/core/autoflixApp.dart';
import '../../../domain/value_objects/constants.dart';
import '../state/app_state.dart';
import 'app_entry_point_view_model.dart';

class AppEntryPointViewModelFactory extends VmFactory<AppState,   AutoflexApp> {
  @override
  AppEntryPointViewModel fromStore() {
    return AppEntryPointViewModel(
      idToken: UNKNOWN,
      userId: UNKNOWN,
    );
  }
}
