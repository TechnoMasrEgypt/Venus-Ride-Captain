class MessageModel {
  final String id;
  final String message;
  final String userId;
  final String createdAt;

  MessageModel(
      {required this.id,
      required this.message,
      required this.userId,
      required this.createdAt});
}
