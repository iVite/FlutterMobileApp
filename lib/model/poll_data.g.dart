// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollData _$PollDataFromJson(Map<String, dynamic> json) {
  return PollData(
    json['eventName'] as String,
    json['time'] == null ? null : DateTime.parse(json['time'] as String),
    json['address'] as String,
    (json['responses'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}

Map<String, dynamic> _$PollDataToJson(PollData instance) => <String, dynamic>{
      'eventName': instance.eventName,
      'time': instance.time?.toIso8601String(),
      'address': instance.address,
      'responses': instance.responses,
    };
