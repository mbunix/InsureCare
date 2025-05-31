import 'dart:async';
import 'package:autoflex/presentation/core/autoflixApp.dart';
import 'package:provider/provider.dart' as provider;
import 'package:async_redux/async_redux.dart';
import 'package:autoflex/application/services/helpers.dart';
import 'package:autoflex/domain/value_objects/app_setup_data.dart';
import 'package:autoflex/domain/value_objects/global_keys.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:autoflex/infranstructure/repositories/databasestatePersistor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app_service.dart';
import '../../domain/value_objects/app_enums.dart';
import '../../infranstructure/repositories/database_base.dart';
import '../../presentation/core/widgets/unrecovable_error_widget.dart';
import '../redux/state/app_state.dart';

Future<void> initApp(AppContext appContext) async {
  WidgetsFlutterBinding.ensureInitialized();
  late Store<AppState> store;

  await dotenv.load();
  await SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[DeviceOrientation.portraitUp],
  );

  final autoflexStateDatabase stateDB =
      autoflexStateDatabase(dataBaseName: DatabaseName);

  await stateDB.init();
  final AppState initialState = await stateDB.readState();
  // initialize a new state if the [initialState] == null
  // and populate the database with the default values
  if (initialState == AppState.initial()) {
    await stateDB.saveInitialState(initialState);
  }
  store = Store<AppState>(
    initialState: initialState,
    persistor: PersistorPrinterDecorator<AppState>(stateDB),
    defaultDistinct: true,
  );
  // navigation state

  NavigateAction.setNavigatorKey(appGlobalNavigatorKey);

  final AppSetupData appSetupData = getAppSetupData(AppContext.AppTest);

  // Configure the error message to show whether in debug or release mode
  ErrorWidget.builder = (FlutterErrorDetails details) {
    bool isInDebug = false;
    assert(() {
      isInDebug = true;
      return true;
    }());
    // in debug mode show normal error details to the stack trace
    if (isInDebug) {
      return ErrorWidget(details.exception);
    }
    // otherwise in release mode show error image
    return const UnrecovarableErrorWidget();
  };
  await Supabase.initialize(
    url: 'https://yfweoucbazcfpmjqqucg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlmd2VvdWNiYXpjZnBtanFxdWNnIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzYyNTc5MjksImV4cCI6MTk5MTgzMzkyOX0.hiAy9OpMwpPfwuHfBEgmDmCMeQKc3bVtDj7PSv7tzLo',
  );

  runZonedGuarded(
    () async {
      await SentryFlutter.init(
        (SentryFlutterOptions options) {
          options
            ..dsn = appSetupData.sentryDsn
            ..diagnosticLevel = SentryLevel.error;
        },
        appRunner: () => runApp(
          provider.MultiProvider(
            providers: <SingleChildWidget>[
              provider.ChangeNotifierProvider<AppService>(
                create: (_) => AppService(),
              ),
            ],
            child: AutoflexApp(
              store: store,
              appSetupData: appSetupData,
              // TODO: Firebase analytics, stream chat flutter
              // streamClient: streamClient,
              // analyticsObserver: AnalyticsService().getAnalyticsObserver(),
            ),
          ),
        ),
      );

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        Sentry.captureException(details.exceptionAsString());
      };
    },
    (Object exception, StackTrace stackTrace) async {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    },
  );
}
