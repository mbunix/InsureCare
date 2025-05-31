import 'package:async_redux/async_redux.dart';
import 'package:autoflex/app_service.dart';
import 'package:autoflex/application/redux/actions/flags/app_flags.dart';
import 'package:autoflex/application/redux/state/app_state.dart';
import 'package:flutter/animation.dart';

/// [PhoneLoginAction] is a Redux Action whose job is to verify a user signed
/// in using valid credentials that match those stored in the backend
///
/// Otherwise delightfully notify user of a Login Error or credentials mismatch
///
/// should initiate phone login process

class PhoneLoginAction extends ReduxAction<AppState> {
  PhoneLoginAction({
    required this.email,
    required this.password,
    this.errorCallBack,
    this.successCallBack,
    required this.appService,
  });

  final void Function(String? reason)? errorCallBack;
  final VoidCallback? successCallBack;
  final String email;
  final String password;
  final AppService appService;

  @override
  void after() {
    dispatch(WaitAction<AppState>.remove(phoneLoginFlag));
    super.after();
  }

  /// [wrapError] used to wrap error thrown during execution of the `reduce()` method
  /// returns a bottom sheet that gives the user a friendly message and an option to create an account
  @override
  void before() {
    super.before();
    dispatch(WaitAction<AppState>.add(phoneLoginFlag));
  }

  @override
  Future<AppState?> reduce() async {
    return null;
  }
}
