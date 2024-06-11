// import 'dart:async';
// import 'dart:convert';
// import 'package:WebRtcSIR/call_model.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:messaging_core/core/app_states/app_global_data.dart';
// import 'package:messaging_core/core/enums/change_message_modes.dart';
// import 'package:messaging_core/core/enums/receiver_type.dart';
// import 'package:messaging_core/core/env/environment.dart';
// import 'package:messaging_core/core/services/network/websocket/messaging_client.dart';
// import 'package:messaging_core/features/chat/data/models/call_model.dart';
// import 'package:messaging_core/features/chat/data/models/change_message_model.dart';
// import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
// import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';
// import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
// import 'package:messaging_core/features/chat/presentation/manager/online_users_controller.dart';
// import 'package:messaging_core/locator.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:socket_io_client/socket_io_client.dart';
//
// class WebSocketConnection {
//   IO.Socket? channel;
//   bool isConnected = false;
//   bool settingSocketUp = false;
//
//   void initState() {
//     settingSocketUp = true;
//     initChannel();
//   }
//
//   void resetState() async {
//     channel = null;
//     isConnected = false;
//     // notifyListeners();
//   }
//
//   Future initChannel() async {
//     // Map<String , dynamic>  headers = HttpHeader.setHeaders(HttpHeaderType.webSocket);
//
//     channel = IO.io(Environment.websocketUrl,
//         IO.OptionBuilder().setTransports(["websocket"]).build());
//     channel?.onConnect((data) {
//       isConnected = true;
//       settingSocketUp = false;
//       print("Socket Id: ${channel!.id}");
//       locator<MessagingClient>().sendAddOnlineUser();
//
//       print(
//           "-----------------   Successful Connection   $data  -----------------");
//     });
//
//     channel?.onConnectError((data) {
//       settingSocketUp = false;
//       print("-----------------   Connection Error $data     -----------------");
//     });
//
//     channel?.onDisconnect((data) {
//       isConnected = false;
//       print("-----------------   Disconnected     -----------------");
//     });
//
//     channel?.onAny((event, data) {
//       print("$event : data");
//     });
//
//     // channel?.on("chat message", (data) {
//     //   print(data);
//     //   if (data["senderId"] != AppGlobalData.userId) {
//     //     ChatController controller = locator<ChatController>();
//     //     controller.handleReceivedMessages(data, data["roomIdentifier"]);
//     //   }
//     // });
//
//     channel?.on("signaling", (data) {
//       print(data);
//       if(data["signalType"] == SignalType.webRtc.toString()) {
//
//       }
//       // CallModel call = CallModel.fromJson(jsonDecode(data));
//       // locator<CallController>().receiveCallSignal(call);
//     });
//
//     // channel?.on("notification", (data) {
//     //   print(data);
//     //   ChatController controller = locator<ChatController>();
//     //   controller.handleNotificationSignal(
//     //       data["senderId"].runtimeType == int
//     //           ? data["senderId"]
//     //           : int.parse(data["senderId"]),
//     //       ReceiverType.fromString(data["receiverType"]));
//     // });
//     //
//     // channel?.on("onlineUsers", (data) {
//     //   print(data);
//     //   List<int> onlineUsers = [];
//     //   (data as List).forEach((element) {
//     //     if (element["categoryId"] == AppGlobalData.categoryId) {
//     //       onlineUsers.add(element["userId"]);
//     //     }
//     //   });
//     //   locator<OnlineUsersController>().setOnlineUsers(onlineUsers);
//     // });
//     //
//     // channel?.on("change message", (data) {
//     //   print(data);
//     //
//     //   ChangeMessageModel model = ChangeMessageModel.fromJson(data);
//     //   ChatController controller = locator<ChatController>();
//     //
//     //   if (model.mode == ChangeMessageEnum.edit) {
//     //     controller.editMessageFromSocket(
//     //         model.messageId, model.roomIdentifier, model.data ?? "");
//     //   } else {
//     //     controller.deleteMessageFromSocket(
//     //         model.messageId, model.roomIdentifier);
//     //   }
//     // });
//     //
//     // channel?.on("userTyping", (data) {
//     //   print(data);
//     //   ChatController controller = locator<ChatController>();
//     //   controller.handleUserTypingSignal(data["senderId"]);
//     // });
//     // channel?.on("userStoppedTyping", (data) {
//     //   print(data);
//     //   ChatController controller = locator<ChatController>();
//     //   controller.handleUserStoppedTypingSignal(data["senderId"]);
//     // });
//     channel?.on("ChatGroupChange", (data) {
//       print(data);
//     });
//
//     channel?.on("addOnlineUser", (data) {
//       print(data);
//     });
//   }
//
//   void sendMessage(String event, dynamic payload) {
//     print("----------   $event : $payload --------");
//     if (isConnected) {
//       channel?.emit(event, payload);
//     }
//   }
//
//   void closeConnection() {
//     channel?.disconnect();
//     channel?.close();
//     channel = null;
//     isConnected = false;
//     settingSocketUp = false;
//   }
//
//   Future retryConnection() async {
//     if (isConnected) return;
//     await initChannel();
//   }
// }
