import 'dart:convert';

import 'proto/client.pb.dart' as proto;

class PrivateSubEvent {
  PrivateSubEvent(this.clientID, this.channel);

  final String clientID;
  final String channel;

  @override
  String toString() {
    return 'PrivateSubEvent{clientID: $clientID, channel: $channel}';
  }
}

class ConnectEvent {
  ConnectEvent(this.client, this.version, this.data);

  final String client;
  final String version;
  final List<int> data;

  static ConnectEvent from(proto.ConnectResult result) =>
      ConnectEvent(result.client, result.version, result.data);

  @override
  String toString() {
    return 'ConnectEvent{client: $client, version: $version, data: ${utf8.decode(data, allowMalformed: true)}}';
  }
}

class DisconnectEvent {
  DisconnectEvent(this.reason, this.reconnect);

  final String reason;

  ///
  /// If [reconnect] is true, the client will retry to reconnect.
  ///
  final bool reconnect;

  @override
  String toString() {
    return 'DisconnectEvent{reason: $reason, reconnect: $reconnect}';
  }
}

class MessageEvent {
  MessageEvent(this.data);

  final List<int> data;

  @override
  String toString() {
    return 'MessageEvent{data: ${utf8.decode(data, allowMalformed: true)}';
  }
}

class PublishEvent {
  PublishEvent(this.uid, this.data);

  final String uid;
  final List<int> data;

  static PublishEvent from(proto.Publication pub) =>
      PublishEvent(pub.uid, pub.data);

  @override
  String toString() {
    return 'PublishEvent{uid: $uid, data: $data}';
  }
}

class JoinEvent {
  JoinEvent(this.user, this.client);

  final String user;
  final String client;

  static JoinEvent from(proto.ClientInfo clientInfo) =>
      JoinEvent(clientInfo.user, clientInfo.client);

  @override
  String toString() {
    return 'JoinEvent{user: $user, client: $client}';
  }
}

class LeaveEvent {
  LeaveEvent(this.user, this.client);

  final String user;
  final String client;

  static LeaveEvent from(proto.ClientInfo clientInfo) =>
      LeaveEvent(clientInfo.user, clientInfo.client);

  @override
  String toString() {
    return 'LeaveEvent{user: $user, client: $client}';
  }
}

class SubscribeSuccessEvent {
  const SubscribeSuccessEvent(this.isResubscribed, this.isRecovered);

  final bool isResubscribed;
  final bool isRecovered;

  static SubscribeSuccessEvent from(
          proto.SubscribeResult result, bool resubscribed) =>
      SubscribeSuccessEvent(resubscribed, result.recovered);

  @override
  String toString() {
    return 'SubscribeSuccessEvent{isResubscribed: $isResubscribed, isRecovered: $isRecovered}';
  }
}

class SubscribeErrorEvent {
  const SubscribeErrorEvent(this.message, this.code);

  final String message;
  final int code;

  static SubscribeErrorEvent from(proto.Error error) =>
      SubscribeErrorEvent(error.message, error.code);

  @override
  String toString() {
    return 'SubscribeErrorEvent{message: $message, code: $code}';
  }
}

class UnsubscribeEvent {
  const UnsubscribeEvent();

  @override
  String toString() {
    return 'UnsubscribeEvent{}';
  }
}
