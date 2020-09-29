import 'package:json_annotation/json_annotation.dart';
part 'poll_data.g.dart';

@JsonSerializable()
class PollData {

  final String title;
  final String eventName;
  final DateTime time;
  final String address;
  final Map<String, String> responses;


  PollData(this.title, this.eventName, this.time, this.address, this.responses);

  factory PollData.fromJson(Map<String, dynamic> json) => _$PollDataFromJson(json);

  Map<String, dynamic> toJson() => _$PollDataToJson(this);
}
