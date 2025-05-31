import 'package:async_redux/async_redux.dart';
import 'package:autoflex/application/redux/state/bottom_nav_state.dart';
import 'package:autoflex/application/redux/state/client_state.dart';
import 'package:autoflex/application/redux/state/connectivity_state.dart';
import 'package:autoflex/application/redux/state/content_state.dart';
import 'package:autoflex/application/redux/state/home_state.dart';
import 'package:autoflex/application/redux/state/misc_state.dart';
import 'package:autoflex/application/redux/state/onboarding_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/core/auth_credentials.dart';
part 'app_state.freezed.dart';
part 'app_state.g.dart';

@freezed
class AppState with _$AppState {
  factory AppState({
    AuthCredentials? credentials,
    OnboardingState? onboardingState,
    HomeState? homeState,
    BottomNavigationState? bottomNavigationState,
    MiscState? miscState,
    ClientState? clientState,
    ConnectivityState? connectivityState,
    ContentState? contentState,
    @JsonKey(ignore: true) Wait? wait,
  }) = _AppState;

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  factory AppState.initial() => AppState(
        credentials: AuthCredentials.initial(),
        clientState: ClientState.initial(),
        onboardingState: OnboardingState.initial(),
        homeState: HomeState.initial(),
        miscState: MiscState.initial(),
        bottomNavigationState: BottomNavigationState.initial(),
        connectivityState: ConnectivityState.initial(),
        contentState: ContentState.initial(),
        wait: Wait(),
      );
}

class UpdateOnboardingState {}
