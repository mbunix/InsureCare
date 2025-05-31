import 'package:async_redux/async_redux.dart';
import 'package:autoflex/application/redux/actions/flags/app_flags.dart';
import 'package:autoflex/application/redux/state/app_state.dart';
import 'package:autoflex/application/redux/view_models/app_state_view_model.dart';
import 'package:autoflex/authentication_scaffold.dart';
import 'package:autoflex/presentation/core/widgets/buttons.dart';
import 'package:autoflex/presentation/core/widgets/platform_loader.dart';
import 'package:autoflex/presentation/core/widgets/spaces.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Welcome to autoflex, Please Register Your Account, Here',
      message:
          ' Your  new equipment experience is waiting for you.Please enter your  valid email address and password to register',
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                smallVerticalSizedBox,
                const Text(
                  'Getting Started',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                const Text(
                  'Create an account with us to continue',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                ),
                smallVerticalSizedBox,
              ],
            ),
          ],
        ),
      ),
      actionButton: StoreConnector<AppState, AppStateViewModel>(
        builder: (_, AppStateViewModel vm) {
          return vm.wait.isWaitingFor(registerFlag)
              ? const PlatformLoader()
              : PrimaryButton();
        },
      ),
    );
  }
}
