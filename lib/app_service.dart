import 'package:autoflex/domain/entities/chat/messages.dart';
import 'package:flutter/material.dart';
import 'package:supabase/src/supabase_stream_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppService extends ChangeNotifier {
  static SupabaseClient supabaseClient = Supabase.instance.client;
  final String _password = 'PWQQW553GSAaasy';

  Future<void> _createUser(int i) async {
    final AuthResponse response = await supabaseClient.auth
        .signUp(password: _password, email: 'test_$i@test.com');
    await supabaseClient.from('contact').insert(<String, dynamic>{
      'id': response.user!.id,
      'username': 'User $i',
    }).execute();
  }

  Future<void> createUsers() async {
    await _createUser(1);
    await _createUser(2);
  }

  Future<Map<String, dynamic>> createNewUser(
    String email,
    String password,
    String username,
  ) async {
    final AuthResponse response =
        await supabaseClient.auth.signUp(password: password, email: email);

    final PostgrestResponse<dynamic> postgrestResponse =
        await supabaseClient.from('contact').insert(<String, dynamic>{
      'id': response.user!.id,
      'username': username,
    }).execute();

    return <String, dynamic>{
      'auth_response': response,
      'postgrest_response': postgrestResponse,
    };
  }

  Future<void> signIn(int i) async {
    await supabaseClient.auth
        .signInWithPassword(password: _password, email: 'test _$i@test.com');
    await supabaseClient.auth.signInWithApple();
  }

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  Future<String> _getUserTo() async {
    final PostgrestResponse<dynamic> response = await supabaseClient
        .from('contact')
        .select('id')
        .not('id', 'eq', getCurrentUserId())
        .execute();

    return response.data.first['id'] as String;
  }

  Stream<List<Message>> getMessages() {
    return supabaseClient
        .from('message')
        .stream(primaryKey: <String>['id'])
        .order('created_at')
        .execute()
        .map(
          (SupabaseStreamEvent maps) => maps
              .map(
                (Map<String, dynamic> item) => Message.fromJson(
                    item.cast<String, String>(), getCurrentUserId()),
              )
              .toList(),
        );
  }

  Future<void> saveMessage(String content) async {
    final String userTo = await _getUserTo();

    final Message message = Message.create(
      content: content,
      userFrom: getCurrentUserId(),
      userTo: userTo,
    );

    await supabaseClient.from('message').insert(message.toMap()).execute();
  }

  Future<void> markAsRead(String messageId) async {
    await supabaseClient
        .from('message')
        .update(<String, dynamic>{'mark_as_read': true})
        .eq('id', messageId)
        .execute();
  }

  bool isAuthentificated() => supabaseClient.auth.currentUser != null;

  String getCurrentUserId() =>
      isAuthentificated() ? supabaseClient.auth.currentUser!.id : '';

  String getCurrentUserEmail() =>
      isAuthentificated() ? supabaseClient.auth.currentUser!.email ?? '' : '';
}
