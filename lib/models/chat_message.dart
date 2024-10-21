class ChatMessage {
  final String id;
  final String userId;
  final String userName;
  final String message;
  final String? imageUrl;
  final String? fileUrl;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.userName,
    required this.message,
    this.imageUrl,
    this.fileUrl,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'],
      userId: json['userId'],
      userName: json['userName'],
      message: json['message'] ?? '',
      imageUrl: json['imageUrl'],
      fileUrl: json['fileUrl'],
      timestamp: DateTime.parse(json['createdAt']),
    );
  }
}
