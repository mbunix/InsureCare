import 'package:autoflex/infranstructure/repositories/sqlite.dart';
import 'package:flutter_graphql_client/graph_sqlite.dart';

abstract class MyautoflexDatabase extends Database {}

class InitializeDB<T extends DatabaseExecutor> extends InitializeDBHelper<T> {
  InitializeDB({
    required super.dbName,
  });
}

abstract class InitializeDBHelper<T extends DatabaseExecutor> {
  final String dbName;
  InitializeDBHelper({required this.dbName});

  Future<T> database({T? preInitializedDB}) async {
    return preInitializedDB != null
        ? Future<T>.value(preInitializedDB)
        : initDatabase<T>(dbName);
  }
}
