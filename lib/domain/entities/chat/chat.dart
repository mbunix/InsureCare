import 'package:autoflex/domain/value_objects/constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
class Chat with _$Chat {
  factory Chat({
    String? from,
    String? to,
    String? message,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  factory Chat.initial() => Chat(
        from: UNKNOWN,
        to: UNKNOWN,
        message: UNKNOWN,
      );
}
