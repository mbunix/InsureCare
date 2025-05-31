import 'package:flutter/material.dart';
import 'package:flutter_graphql_client/graph_client.dart';
import 'package:http/http.dart';

class CustomClient extends IGraphQlClient {
  CustomClient(
    String idTocken,
    String endpoint, {
    required this.context,
    required this.refreshTokenEndpoint,
    required this.userID,
    Client? client,
  }) : _client = client ?? Client() {
    super.idToken =  idTocken;
    super.endpoint = endpoint;
  }
  final String refreshTokenEndpoint;
  final String userID;
  final BuildContext context;
  final Client _client;
  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    request.headers.addAll(this.requestHeaders);

    return request.send();
  }
}
