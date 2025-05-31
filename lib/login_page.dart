import 'package:async_redux/async_redux.dart';
import 'package:autoflex/app_service.dart';
import 'package:autoflex/application/redux/actions/auth/login_action.dart';
import 'package:autoflex/application/redux/actions/flags/app_flags.dart';
import 'package:autoflex/application/redux/view_models/app_state_view_model.dart';
import 'package:autoflex/application/services/asset_strings.dart';
import 'package:autoflex/application/services/helpers.dart';
import 'package:autoflex/authentication_scaffold.dart';
import 'package:autoflex/domain/value_objects/app_strings.dart';
import 'package:autoflex/domain/value_objects/constants.dart';
import 'package:autoflex/presentation/core/theme/text_theme.dart';
import 'package:autoflex/presentation/core/theme/theme.dart';
import 'package:autoflex/presentation/core/widgets/custom_input_text_fields.dart';
import 'package:autoflex/presentation/core/widgets/platform_loader.dart';
import 'package:autoflex/presentation/core/widgets/spaces.dart';
import 'package:autoflex/presentation/router/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'application/redux/state/app_state.dart';
import 'presentation/core/widgets/buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  final TextEditingController emailInputController = TextEditingController();

  String? pin;
  TextEditingController pinController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool rememberMe = false;

  // Future<void> _loginUser(AppService appService, int i) async {
  //   await appService.signIn(i);

  //   setState(() {});
  // }

  // Future<void> _signOut(AppService appService) async {
  //   await appService.signOut();

  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final AppService appService = context.read<AppService>();
    final bool activateActionButton =
        pin != null && pin!.isNotEmpty && email != null && email!.isNotEmpty;
    return Form(
      key: _formKey,
      child: AuthScaffold(
        title: 'Hi, Welcome Back! 👋',
        message: "Hello again, we  missed you !it's time to log in.",
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Username or email',
              style: boldSize14Text(Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
            smallVerticalSizedBox,
            CustomTextInputField(
              // customFillColor: AppColors.inputFillColor,
              // borderColor: AppColors.lightGreyColor,
              // focusedBorderColor: AppColors.greyTextColor,
              validator: (String? val) {
                final String value = val as String;
                if (value.isEmpty) {
                  return 'Field is required';
                }
                return null;
              },
              hintText: 'Please Enter Your Username or Email',
              autovalidateMode: AutovalidateMode.disabled,
              onChanged: (String? val) {
                setState(() {
                  email = val;
                });
              },
            ),
            largeVerticalSizedBox,
            Text(
              'Password',
              style: boldSize14Text(Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
            smallVerticalSizedBox,
            CustomTextInputField(
              // customFillColor: AppColors.inputFillColor,
              // borderColor: AppColors.lightGreyColor,
              // focusedBorderColor: AppColors.greyTextColor,
              obscureText: true,
              validator: (String? value) {
                if (value?.isEmpty ?? true) {
                  return 'Password is required';
                }

                if ((value?.length ?? 0) < 5) {
                  return 'Password should be more than 4 characters';
                }
                return null;
              },
              hintText: 'Please Enter Your Password',
              autovalidateMode: AutovalidateMode.disabled,
              onChanged: (String? val) {
                setState(() {
                  pin = val;
                });
              },
            ),
            largeVerticalSizedBox,
          ],
        ),
        actionButton: StoreConnector<AppState, AppStateViewModel>(
          converter: (Store<AppState> store) =>
              AppStateViewModel.fromStore(store),
          builder: (BuildContext context, AppStateViewModel vm) {
            return vm.wait.isWaitingFor(phoneLoginFlag)
                ? const PlatformLoader()
                : PrimaryButton(
                    text: 'Login',
                    borderColor: Colors.transparent,
                    onPressed: !activateActionButton
                        ? null
                        : () {
                            final bool? isFormValid =
                                _formKey.currentState?.validate();

                            if (isFormValid != null &&
                                isFormValid &&
                                pin != null &&
                                email != null) {
                              StoreProvider.dispatch<AppState>(
                                context,
                                PhoneLoginAction(
                                  appService: appService,
                                  successCallBack: () {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          content:
                                              const Text('Login Successful'),
                                          duration: const Duration(
                                            seconds: kShortSnackBarDuration,
                                          ),
                                          action: dismissSnackBar(
                                            closeString,
                                            AppColors.whiteColor,
                                            context,
                                          ),
                                        ),
                                      );
                                  },
                                  errorCallBack: (String? reason) {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            reason ??
                                                defaultUserFriendlyMessage,
                                          ),
                                          duration: const Duration(
                                            seconds: kShortSnackBarDuration,
                                          ),
                                          action: dismissSnackBar(
                                            closeString,
                                            AppColors.whiteColor,
                                            context,
                                          ),
                                        ),
                                      );
                                  },
                                  password: pin ?? '',
                                  email: email ?? '',
                                ),
                              );
                            }
                          },
                    buttonColor: activateActionButton
                        ? null
                        : AppColors.greyTextColor.withOpacity(0.6),
                  );
          },
        ),
        actionDescription: RichText(
          text: TextSpan(
            text: "Don't have an account?",
            style: normalSize13Text(
              AppColors.greyTextColor,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' Sign Up',
                style: normalSize13Text(
                  Theme.of(context).primaryColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).pushReplacementNamed(
                      AppRoutes.registerPage,
                      arguments: email,
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
