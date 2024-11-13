import 'dart:io';

class PersonalChatMessageModel {
  final String text;
  final bool isMe;
  final File? image;
  final String? fileName;

  PersonalChatMessageModel({
    required this.text,
    required this.isMe,
    this.image,
    this.fileName,
  });

  factory PersonalChatMessageModel.fromJson(
      Map<String, dynamic> json, String currentUserId) {
    return PersonalChatMessageModel(
      text: json['message'],
      isMe: json['sender'] == currentUserId,
      image: null,
      fileName: null,
    );
  }
}