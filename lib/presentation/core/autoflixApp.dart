import 'package:async_redux/async_redux.dart';
import 'package:autoflex/domain/value_objects/app_setup_data.dart';
import 'package:autoflex/domain/value_objects/app_widget_keys.dart';
import 'package:autoflex/infranstructure/endpoints.dart';
import 'package:autoflex/presentation/core/app_wrapper.dart';
import 'package:autoflex/presentation/core/theme/theme.dart';
import 'package:autoflex/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../application/redux/state/app_state.dart';
import '../../application/redux/view_models/app_entry_point_factory_view_model.dart';
import '../../application/redux/view_models/app_entry_point_view_model.dart';
import '../../application/redux/view_models/initial_route_view_model.dart';
import '../../application/services/custom_client.dart';
import '../../domain/value_objects/global_keys.dart';
import '../router/routes.dart';

class AutoflexApp extends StatelessWidget {
  final Store<AppState> store;
  final AppSetupData appSetupData;
  const AutoflexApp({
    super.key,
    required this.store,
    required this.appSetupData,
  });

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      key: globalStoreProviderKey,
      store: store,
      child: StoreConnector<AppState, AppEntryPointViewModel>(
        vm: () => AppEntryPointViewModelFactory(),
        builder: (BuildContext context, AppEntryPointViewModel vm) {
          final String idToken = vm.idToken ?? '';
          final String userID = vm.userId ?? '';

          return StoreConnector<AppState, InitialRouteViewModel>(
            converter: (Store<AppState> store) =>
                InitialRouteViewModel.fromStore(store.state),
            builder: (BuildContext context, InitialRouteViewModel vm) {
              final String initialRoute = (vm.isSignedIn ?? false)
                  ? AppRoutes.homePage
                  : vm.initialRoute ?? AppRoutes.onboardingPage;

              return AppWrapper(
                appContext: appSetupData.appContext,
                baseContext: appSetupData.customContext,
                graphQLClient: CustomClient(
                  idToken,
                  kTestGraphqlEndpoint,
                  context: context,
                  refreshTokenEndpoint: '',
                  userID: userID,
                ),
                child: MaterialApp(
                  theme: AppTheme.getAppTheme(),
                  navigatorKey: appGlobalNavigatorKey,
                  navigatorObservers: <NavigatorObserver>[
                    SentryNavigatorObserver(),
                  ],
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: AppRouter.generateRoute,
                  initialRoute: initialRoute,
                  // initialRoute: AppRoutes.cookOnboardingPage,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
