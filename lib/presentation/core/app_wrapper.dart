import 'package:autoflex/application/services/base_context.dart';
import 'package:autoflex/domain/value_objects/app_enums.dart';
import 'package:autoflex/presentation/core/app_wrapper_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_graphql_client/graph_client.dart';

/// - `appName` A required string that identifies your application
/// - `graphQLClient` An instance of [IGraphQlClient] which is the '
/// 'blueprint of a valid GraphQL client.
/// - `appContexts` [context] app running environments.
/// - `eventBus` Used to log events
///
class AppWrapper extends StatefulWidget {
  const AppWrapper({
    Key? key,
    required this.appContext,
    required this.child,
    required this.graphQLClient,
    this.baseContext,
    this.eventBus,
  }) : super(key: key);

  /// [child] the widget that will be wrappeed by the wrapper
  final Widget child;

  /// used to events to the backend
  final dynamic eventBus;

  ///[graphQLClient] is the 'blueprint of a valid GraphQL client.
  ///dynamic to avoid cyclic dependencies
  final IGraphQlClient graphQLClient;

  /// [context] is the environment which the app is running on. In app can run
  /// on multiple contexts, the intuition why [context] is a list.
  /// An app should have at least one context
  final AppContext appContext;

  /// [baseContext] is the context that the app is running in.
  /// An app should have at least one context
  final BaseContext? baseContext;

  @override
  AppWrapperState createState() => AppWrapperState();
}

class AppWrapperState extends State<AppWrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: const Key('sil_app_wrapper'),
      builder: (BuildContext context, BoxConstraints boxConstraints) {
        return AppWrapperBase(
          eventBus: widget.eventBus,
          graphQLClient: widget.graphQLClient,
          appContext: widget.appContext,
          customContext: widget.baseContext,
          child: widget.child,
        );
      },
    );
  }
}
