// import 'package:tflite_flutter/tflite_flutter.dart' as tf;
// import 'package:supabase/supabase.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

// class AIModel {
//   final SupabaseClient _supabaseClient;
//   final GraphQLClient _graphQLClient;

//   AIModel(this._supabaseClient, this._graphQLClient);

//   Future<String> recommendService(String vehicleId) async {
//     final response = await _supabaseClient
//         .from('mileage_data')
//         .select('*')
//         .order('id', ascending: false)
//         .limit(1)
//         .execute();
//     final mileageData = response.data.first;
//     final currentMileage = mileageData['mileage'] as int;
//     final make = mileageData['make'] as String;
//     final model = mileageData['model'] as String;
//     final year = mileageData['year'] as int;

//     final input = tf.tensor2d([
//       [currentMileage, year]
//     ]);

//     // Load the trained model from a file
//     final modelBytes = await rootBundle.load('assets/ai_model.bin');
//     final model = await tf.GraphModel.fromByteData(modelBytes);

//     // Run the model with the input data
//     final output = model.predict(<String, tf.Tensor>{
//       'input': input,
//     });

//     // Get the predicted service
//     final predictedService = output['output'].argMax().dataSync()[0];

//     // Query the GraphQL API to get the name of the service
//     final serviceResponse = await _graphQLClient.query(QueryOptions(
//       document: gql('''
//         query getServiceName(\$id: ID!) {
//           service(id: \$id) {
//             name
//           }
//         }
//       '''),
//       variables: {'id': predictedService},
//     ));

//     final serviceName = serviceResponse.data['service']['name'] as String;

//     return 'Based on your vehicle\'s current mileage (${currentMileage} miles), we recommend the following service: ${serviceName}';
//   }
// }
