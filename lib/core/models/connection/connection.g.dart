// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Connection _$ConnectionFromJson(Map json) {
  return Connection(
    conversationUid: json['conversationUid'] as String,
    mostRecentActivity:
        Connection._timestampFromEpochUs(json['mostRecentActivity'] as int),
    lastViewed: Connection._timestampFromEpochUs(json['lastViewed'] as int),
    lastMessage: json['lastMessage'] as String,
    status: _$enumDecodeNullable(_$ConnectionStatusEnumMap, json['status']),
    temporaryDisplayName: json['temporaryDisplayName'] as String,
    unseenNotificationCount: json['unseenNotificationCount'] as int,
  );
}

Map<String, dynamic> _$ConnectionToJson(Connection instance) =>
    <String, dynamic>{
      'conversationUid': instance.conversationUid,
      'lastMessage': instance.lastMessage,
      'unseenNotificationCount': instance.unseenNotificationCount,
      'status': _$ConnectionStatusEnumMap[instance.status],
      'temporaryDisplayName': instance.temporaryDisplayName,
      'mostRecentActivity':
          Connection._timestampToEpochUs(instance.mostRecentActivity),
      'lastViewed': Connection._timestampToEpochUs(instance.lastViewed),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ConnectionStatusEnumMap = {
  ConnectionStatus.pending: 'pending',
  ConnectionStatus.unaccepted: 'unaccepted',
  ConnectionStatus.accepted: 'accepted',
  ConnectionStatus.blocked: 'blocked',
};
