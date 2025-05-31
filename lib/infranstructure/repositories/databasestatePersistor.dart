import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_graphql_client/graph_sqlite.dart';

import 'package:autoflex/application/redux/state/app_state.dart';
import 'package:autoflex/application/redux/state/connectivity_state.dart';
import 'package:autoflex/application/redux/state/onboarding_state.dart';
import 'package:autoflex/domain/entities/core/auth_credentials.dart';
import 'package:autoflex/infranstructure/repositories/database_base.dart';
import 'package:autoflex/infranstructure/repositories/database_mobile.dart';
import 'package:autoflex/infranstructure/repositories/initializedb.dart';

import '../../application/redux/state/bottom_nav_state.dart';
import '../../application/redux/state/client_state.dart';
import '../../application/redux/state/content_state.dart';
import '../../application/redux/state/misc_state.dart';

/// [autoflexStateDatabase] is the middleware that interacts with the database on behalf
/// of the application. From the apps perspective, it doesn't care which database
/// its saving its state on. MyAfyaHubStateDatabase therefore offers different implementations
/// for its method.

class autoflexStateDatabase implements PersistorPrinterDecorator<AppState> {
  autoflexStateDatabase({
    Duration throttle = const Duration(seconds: 3),
    Duration saveDuration = Duration.zero,
    required this.dataBaseName,
  })  : _throttle = throttle,
        _saveDuration = saveDuration;

  // ignore: prefer_typing_uninitialized_variables
  final String dataBaseName;
  final Duration _saveDuration;
  final Duration _throttle;

  @override
  Future<void> deleteState() async {
    await autoflexDatabaseMobile<Database>(
      initializeDB: InitializeDB<Database>(dbName: dataBaseName),
    ).clearDatabase();
  }

  @override
  Future<void> persistDifference({
    AppState? lastPersistedState,
    required AppState newState,
  }) async {
    await Future<dynamic>.delayed(saveDuration);

    if (lastPersistedState == null ||
        lastPersistedState.credentials != newState.credentials ||
        lastPersistedState.clientState != newState.clientState ||
        lastPersistedState.onboardingState != newState.onboardingState ||
        lastPersistedState.bottomNavigationState !=
            newState.bottomNavigationState ||
        lastPersistedState.connectivityState != newState.connectivityState ||
        lastPersistedState.miscState != newState.miscState ||
        lastPersistedState.contentState != newState.contentState) {
      await persistState(
        newState,
        autoflexDatabaseMobile<Database>(
          initializeDB: InitializeDB<Database>(dbName: this.dataBaseName),
        ),
      );
    }
  }

  /// we first check whether the database is empty
  ///
  /// - if the database is empty, we return null
  /// - else, we retrieve the state from the database

  @override
  Future<AppState> readState() async {
    if (await autoflexDatabaseMobile<Database>(
      initializeDB: InitializeDB<Database>(dbName: dataBaseName),
    ).isDatabaseEmpty()) {
      return AppState.initial();
    } else {
      return retrieveState(
        autoflexDatabaseMobile<Database>(
          initializeDB: InitializeDB<Database>(dbName: dataBaseName),
        ),
      );
    }
  }

  @override
  Future<void> saveInitialState(AppState state) async =>
      persistDifference(newState: state);
  @override
  Duration get throttle => _throttle;

  Duration get saveDuration => _saveDuration;

  Future<void> init() async {
    await autoflexDatabaseMobile<Database>(
      initializeDB: InitializeDB<Database>(dbName: dataBaseName),
    ).database;
  }

// saves the Appstate to the database
  @visibleForTesting
  Future<void> persistState(
    AppState newState,
    autoflexDatabaseBase<dynamic> database,
  ) async {
    //save credentials state
    await database.saveState(
      data: newState.credentials!.toJson(),
      table: Tables.credentials,
    );
    // save client state
    await database.saveState(
      data: newState.clientState!.toJson(),
      table: Tables.clientState,
    );
    //save onboarding state
    await database.saveState(
      data: newState.onboardingState!.toJson(),
      table: Tables.onboardingState,
    );
    // save bottomNavigation state
    await database.saveState(
      data: newState.bottomNavigationState!.toJson(),
      table: Tables.bottomNavigationState,
    );
    // save connectivity state
    await database.saveState(
      data: newState.connectivityState!.toJson(),
      table: Tables.connectivityState,
    );
    //saving content state
    await database.saveState(
      data: newState.contentState!.toJson(),
      table: Tables.contentState,
    );
    //saving Misc state
    await database.saveState(
      data: newState.miscState!.toJson(),
      table: Tables.miscState,
    );
  }

// retrieves appstate to the database
  @visibleForTesting
  Future<AppState> retrieveState(
    autoflexDatabaseBase<dynamic> database,
  ) async {
    return AppState().copyWith(
      // retrieve user state
      credentials: AuthCredentials.fromJson(
        await database.retrieveState(Tables.credentials),
      ),
      clientState: ClientState.fromJson(
        await database.retrieveState(Tables.clientState),
      ),
      onboardingState: OnboardingState.fromJson(
        await database.retrieveState(Tables.onboardingState),
      ),
      bottomNavigationState: BottomNavigationState.fromJson(
        await database.retrieveState(Tables.bottomNavigationState),
      ),
      connectivityState: ConnectivityState.fromJson(
        await database.retrieveState(Tables.connectivityState),
      ),

      contentState: ContentState.fromJson(
        await database.retrieveState(Tables.contentState),
      ),

      miscState: MiscState.fromJson(
        await database.retrieveState(Tables.miscState),
      ),

      wait: Wait(),
    );
  }
}
