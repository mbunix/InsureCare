class Message {
  final String id;
  final String content;
  final bool markAsRead;
  final String userFrom;
  final String userTo;
  final DateTime createAt;
  final bool isMine;

  Message({
    required this.id,
    required this.content,
    required this.markAsRead,
    required this.userFrom,
    required this.userTo,
    required this.createAt,
    required this.isMine,
  });

  Message.create({
    required this.content,
    required this.userFrom,
    required this.userTo,
  })  : id = '',
        markAsRead = false,
        isMine = true,
        createAt = DateTime.now();

  Message.fromJson(Map<dynamic, String> json, String userId)
    :content = json['content'] as String,
      userFrom = json['user_from'] as String,
      userTo = json['user_to'] as String,
      markAsRead = json['mark_as_read'] as bool,
      id = json['id'] as String,
      createAt = DateTime.parse(json['created_at'] as String),
      isMine = userId ==true ? true : false;


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'user_from': userFrom,
      'user_to': userTo,
      'mark_as_read': markAsRead,
    };
  }
}
