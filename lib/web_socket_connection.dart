import 'dart:async';
import 'dart:convert';
import 'package:WebRtcSIR/call_model.dart';
import 'package:WebRtcSIR/signaling.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import 'app_global_data.dart';

class WebSocketConnection {
  IO.Socket? channel;
  bool isConnected = false;
  bool settingSocketUp = false;
  late Signaling signaling;

  void initState(Signaling sig) {
    settingSocketUp = true;
    signaling = sig;
    initChannel();
  }

  void resetState() async {
    channel = null;
    isConnected = false;
    // notifyListeners();
  }

  Future initChannel() async {
    // Map<String , dynamic>  headers = HttpHeader.setHeaders(HttpHeaderType.webSocket);

    channel = IO.io("https://socket.coopcor.com",
        IO.OptionBuilder().setTransports(["websocket"]).build());
    channel?.onConnect((data) async {
      isConnected = true;
      settingSocketUp = false;
      print("Socket Id: ${channel!.id}");

      Map deviceInfo = (await DeviceInfoPlugin().deviceInfo).data;
      String? brand = deviceInfo['brand'];
      if (brand == "samsung") {
        AppGlobalData.userId = 1;
        AppGlobalData.opponentUserId = 391;
      } else {
        AppGlobalData.userId = 391;
        AppGlobalData.opponentUserId = 1;
      }
      sendAddOnlineUser();

      print(
          "-----------------   Successful Connection   $data  -----------------");
    });

    channel?.onConnectError((data) {
      settingSocketUp = false;
      print("-----------------   Connection Error $data     -----------------");
    });

    channel?.onDisconnect((data) {
      isConnected = false;
      print("-----------------   Disconnected     -----------------");
    });

    channel?.onAny((event, data) {
      print("$event : data");
    });

    // channel?.on("chat message", (data) {
    //   print(data);
    //   if (data["senderId"] != AppGlobalData.userId) {
    //     ChatController controller = locator<ChatController>();
    //     controller.handleReceivedMessages(data, data["roomIdentifier"]);
    //   }
    // });

    channel?.on("signaling", (data) {
      print(data);
      CallModel call = CallModel.fromJson(jsonDecode(data));

      if (call.signalType.toJson() == SignalType.webRtc.toJson()) {
        if (call.webRtc!.webRtcSignal == WebRtcSignals.description) {
          signaling.manageSdp(call.webRtc!.webRtcConfig!);
        } else if (call.webRtc!.webRtcSignal == WebRtcSignals.candidate) {
          signaling.manageIce(call.webRtc!.webRtcConfig!);
        }
      } else {
        signaling.join(call.webRtc!.peers!);
      }
      // CallModel call = CallModel.fromJson(jsonDecode(data));
      // locator<CallController>().receiveCallSignal(call);
    });

    // channel?.on("notification", (data) {
    //   print(data);
    //   ChatController controller = locator<ChatController>();
    //   controller.handleNotificationSignal(
    //       data["senderId"].runtimeType == int
    //           ? data["senderId"]
    //           : int.parse(data["senderId"]),
    //       ReceiverType.fromString(data["receiverType"]));
    // });
    //
    // channel?.on("onlineUsers", (data) {
    //   print(data);
    //   List<int> onlineUsers = [];
    //   (data as List).forEach((element) {
    //     if (element["categoryId"] == AppGlobalData.categoryId) {
    //       onlineUsers.add(element["userId"]);
    //     }
    //   });
    //   locator<OnlineUsersController>().setOnlineUsers(onlineUsers);
    // });
    //
    // channel?.on("change message", (data) {
    //   print(data);
    //
    //   ChangeMessageModel model = ChangeMessageModel.fromJson(data);
    //   ChatController controller = locator<ChatController>();
    //
    //   if (model.mode == ChangeMessageEnum.edit) {
    //     controller.editMessageFromSocket(
    //         model.messageId, model.roomIdentifier, model.data ?? "");
    //   } else {
    //     controller.deleteMessageFromSocket(
    //         model.messageId, model.roomIdentifier);
    //   }
    // });
    //
    // channel?.on("userTyping", (data) {
    //   print(data);
    //   ChatController controller = locator<ChatController>();
    //   controller.handleUserTypingSignal(data["senderId"]);
    // });
    // channel?.on("userStoppedTyping", (data) {
    //   print(data);
    //   ChatController controller = locator<ChatController>();
    //   controller.handleUserStoppedTypingSignal(data["senderId"]);
    // });
    channel?.on("ChatGroupChange", (data) {
      print(data);
    });

    channel?.on("addOnlineUser", (data) {
      print(data);
    });
  }

  sendAddOnlineUser() async {
    sendMessage("addOnlineUser", {
      'userId': AppGlobalData.userId,
      'categoryId': AppGlobalData.categoryId,
    });
  }

  void sendMessage(String event, dynamic payload) {
    print("----------   $event : $payload --------");
    if (isConnected) {
      channel?.emit(event, payload);
    }
  }

  void closeConnection() {
    channel?.disconnect();
    channel?.close();
    channel = null;
    isConnected = false;
    settingSocketUp = false;
  }

  Future retryConnection() async {
    if (isConnected) return;
    await initChannel();
  }
}
