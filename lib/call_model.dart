class CallModel {
  CallCommand callCommand;
  String? reason;
  String? callName;
  String? callerName;
  String? calleeName;
  String? initiatorName;
  String? token;
  int? calleeId;
  int? initiatorId;
  int? receiverId;
  bool? enableVideo;
  Map<String, dynamic>? webRtcConfig;
  SignalType signalType;

  // ChatParentClass? chat;

  CallModel({
    required this.callCommand,
    this.reason,
    this.callName,
    this.calleeId,
    this.initiatorId,
    this.initiatorName,
    this.token,
    this.calleeName,
    this.callerName,
    this.receiverId,
    this.enableVideo,
    this.webRtcConfig,
    this.signalType = SignalType.call,
    // this.chat,
  });

  static CallModel fromJson(Map<String, dynamic> json) {
    return CallModel(
      callCommand: CallCommand.fromJson(json['callCommand']),
      reason: json['reason'],
      callName: json['callName'],
      token: json['token'],
      calleeId: json['userId'],
      calleeName: json['calleeName'],
      callerName: json["callerName"],
      initiatorId: json['initiatorId'],
      initiatorName: json['initiatorName'],
      receiverId: json['receiverId'],
      enableVideo: json['enableVideo'],
      webRtcConfig: json['webRtcConfig'],
      signalType: SignalType.fromJson(json['signalType']),
      // chat: json['chat'] != null
      //     ? ChatParentClass().fromCallJson(json['chat'])
      //     : null
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['callCommand'] = callCommand.toJson();
    data['reason'] = reason;
    data['callName'] = callName;
    data['token'] = token;
    data['userId'] = calleeId;
    data['calleeName'] = calleeName;
    data['callerName'] = callerName;
    data['initiatorId'] = initiatorId;
    data['initiatorName'] = initiatorName;
    data['receiverId'] = receiverId;
    data['enableVideo'] = enableVideo;
    data['webRtcConfig'] = webRtcConfig;
    data['signalType'] = signalType.toJson();
    // data['chat'] = chat?.toJsonCall();
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

enum CallCommand {
  incoming,
  accept,
  reject,
  join,
  hangup;

  static CallCommand fromJson(String name) {
    switch (name) {
      case 'incoming':
        return CallCommand.incoming;
      case 'accept':
        return CallCommand.accept;
      case 'reject':
        return CallCommand.reject;
      case 'hangup':
        return CallCommand.hangup;
      case 'join':
        return CallCommand.join;
      default:
        throw Exception('Unknown CallCommand: $name');
    }
  }

  String toJson() {
    switch (this) {
      case CallCommand.incoming:
        return 'incoming';
      case CallCommand.accept:
        return 'accept';
      case CallCommand.reject:
        return 'reject';
      case CallCommand.hangup:
        return 'hangup';
      case CallCommand.join:
        return 'join';
      default:
        return '';
    }
  }
}

enum SignalType {
  call,
  webRtc;

  static SignalType fromJson(String name) {
    switch (name) {
      case 'call':
        return SignalType.call;
      case 'webRtc':
        return SignalType.webRtc;
      default:
        throw Exception('Unknown SignalType: $name');
    }
  }

  String toJson() {
    switch (this) {
      case SignalType.call:
        return 'call';
      case SignalType.webRtc:
        return 'webRtc';
      default:
        return '';
    }
  }
}
