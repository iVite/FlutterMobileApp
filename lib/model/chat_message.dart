import 'package:json_annotation/json_annotation.dart';
part 'chat_message.g.dart';

enum MessageType {
  text,
  poll
}
// look at https://flutter.dev/docs/development/data-and-backend/json
// for info on JsonSerializable classes
// to generate the mapping code run "flutter pub run build_runner build"
// in root directory of the project
@JsonSerializable()
class ChatMessage {
  final MessageType type;
  final String content;

  ChatMessage(this.type, this.content);

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

}