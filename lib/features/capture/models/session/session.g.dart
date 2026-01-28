// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
  username: json['username'] as String,
  password: json['password'] as String,
  userId: (json['userId'] as num).toInt(),
  token: json['token'] as String,
  orderIds: (json['orderIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  loggedInAt: DateTime.parse(json['loggedInAt'] as String),
);

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
  'username': instance.username,
  'password': instance.password,
  'userId': instance.userId,
  'token': instance.token,
  'orderIds': instance.orderIds,
  'loggedInAt': instance.loggedInAt.toIso8601String(),
};
