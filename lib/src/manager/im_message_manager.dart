import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class MessageManager {
  MethodChannel _channel;
  List<AdvancedMsgListener> advancedMsgListeners = List.empty(growable: true);
  MsgSendProgressListener? msgSendProgressListener;

  MessageManager(this._channel);

  /// Add a message listener
  Future addAdvancedMsgListener(AdvancedMsgListener listener) {
    advancedMsgListeners.add(listener);
    return _channel.invokeMethod(
        'addAdvancedMsgListener',
        _buildParam({
          'id': listener.id,
        }));
  }

  /// Remove a message listener
  @deprecated
  Future removeAdvancedMsgListener(AdvancedMsgListener listener) {
    advancedMsgListeners.remove(listener);
    return _channel.invokeMethod(
        'removeAdvancedMsgListener',
        _buildParam({
          'id': listener.id,
        }));
  }

  /// Set up message sending progress monitoring
  void setMsgSendProgressListener(MsgSendProgressListener listener) {
    msgSendProgressListener = listener;
  }

  /// Send a message to user or to group
  /// [userID] receiver's user ID
  Future<dynamic> sendMessage({
    required Message message,
    String? userID,
    String? groupID,
    bool onlineUserOnly = false,
  }) =>
      _channel.invokeMethod(
          'sendMessage',
          _buildParam({
            'message': message.toJson(),
            'receiver': userID ?? '',
            'groupID': groupID ?? '',
            'onlineUserOnly': onlineUserOnly,
          })) /*.then((value) => _toObj(value))*/;

  /// Find all history message
  Future<List<Message>> getHistoryMessageList({
    String? userID,
    String? groupID,
    Message? startMsg,
    int? count,
  }) =>
      _channel
          .invokeMethod(
              'getHistoryMessageList',
              _buildParam({
                'userID': userID ?? '',
                'startMsg': startMsg?.toJson() /*?? {}*/,
                'groupID': groupID ?? '',
                'count': count ?? 10,
              }))
          .then((value) => _toList(value));

  /// Revoke the sent information
  Future revokeMessage({required Message message}) =>
      _channel.invokeMethod('revokeMessage', _buildParam(message.toJson()));

  /// Delete message
  Future deleteMessageFromLocalStorage({required Message message}) =>
      _channel.invokeMethod(
          'deleteMessageFromLocalStorage', _buildParam(message.toJson()));

  ///
  @deprecated
  Future deleteMessages({required List<Message> msgList}) =>
      _channel.invokeMethod('deleteMessages',
          _buildParam({"msgList": msgList.map((e) => e.toJson()).toList()}));

  ///
  Future insertSingleMessageToLocalStorage({
    String? receiver,
    String? sender,
    Message? message,
  }) =>
      _channel.invokeMethod(
          'insertSingleMessageToLocalStorage',
          _buildParam({
            "userID": receiver,
            "message": message?.toJson(),
            "sender": sender,
          }));

  /// Query the message according to the message id
  Future findMessages({required List<String> messageIDList}) =>
      _channel.invokeMethod(
          'findMessages',
          _buildParam({
            "messageIDList": messageIDList,
          }));

  /// Mark c2c message as read
  Future markC2CMessageAsRead({
    required String userID,
    required List<String> messageIDList,
  }) =>
      _channel.invokeMethod(
          'markC2CMessageAsRead',
          _buildParam({
            "messageIDList": messageIDList,
            "userID": userID,
          }));

  /// Typing
  Future typingStatusUpdate({
    required String userID,
    bool typing = false,
  }) =>
      _channel.invokeMethod(
          'typingStatusUpdate',
          _buildParam({
            "typing": typing ? 'yes' : 'no',
            "userID": userID,
          }));

  /// Create text message
  Future<Message> createTextMessage({required String text}) => _channel
      .invokeMethod('createTextMessage', _buildParam({'text': text}))
      .then((value) => _toObj(value));

  /// Create @ message
  Future<Message> createTextAtMessage({
    required String text,
    required List<String> atUidList,
  }) =>
      _channel
          .invokeMethod(
            'createTextAtMessage',
            _buildParam({
              'text': text,
              'atUserList': atUidList,
            }),
          )
          .then((value) => _toObj(value));

  /// Create picture message
  Future<Message> createImageMessage({required String imagePath}) => _channel
      .invokeMethod(
        'createImageMessage',
        _buildParam({'imagePath': imagePath}),
      )
      .then((value) => _toObj(value));

  /// Create picture message
  Future<Message> createImageMessageFromFullPath({required String imagePath}) =>
      _channel
          .invokeMethod(
            'createImageMessageFromFullPath',
            _buildParam({'imagePath': imagePath}),
          )
          .then((value) => _toObj(value));

  /// Create sound message
  Future<Message> createSoundMessage({
    required String soundPath,
    required int duration,
  }) =>
      _channel
          .invokeMethod(
            'createSoundMessage',
            _buildParam({'soundPath': soundPath, "duration": duration}),
          )
          .then((value) => _toObj(value));

  /// Create sound message
  Future<Message> createSoundMessageFromFullPath({
    required String soundPath,
    required int duration,
  }) =>
      _channel
          .invokeMethod(
            'createSoundMessageFromFullPath',
            _buildParam({'soundPath': soundPath, "duration": duration}),
          )
          .then((value) => _toObj(value));

  /// Create video message
  Future<Message> createVideoMessage({
    required String videoPath,
    required String videoType,
    required int duration,
    required String snapshotPath,
  }) =>
      _channel
          .invokeMethod(
              'createVideoMessage',
              _buildParam({
                'videoPath': videoPath,
                'videoType': videoType,
                'duration': duration,
                'snapshotPath': snapshotPath,
              }))
          .then((value) => _toObj(value));

  /// Create video message
  Future<Message> createVideoMessageFromFullPath({
    required String videoPath,
    required String videoType,
    required int duration,
    required String snapshotPath,
  }) =>
      _channel
          .invokeMethod(
              'createVideoMessageFromFullPath',
              _buildParam({
                'videoPath': videoPath,
                'videoType': videoType,
                'duration': duration,
                'snapshotPath': snapshotPath,
              }))
          .then((value) => _toObj(value));

  /// Create file message
  Future<Message> createFileMessage({
    required String filePath,
    required String fileName,
  }) {
    return _channel
        .invokeMethod(
            'createFileMessage',
            _buildParam({
              'filePath': filePath,
              'fileName': fileName,
            }))
        .then((value) => _toObj(value));
  }

  /// Create file message
  Future<Message> createFileMessageFromFullPath({
    required String filePath,
    required String fileName,
  }) =>
      _channel
          .invokeMethod(
              'createFileMessageFromFullPath',
              _buildParam({
                'filePath': filePath,
                'fileName': fileName,
              }))
          .then((value) => _toObj(value));

  /// Create merger message
  Future<Message> createMergerMessage({
    required List<Message> messageList,
    required String title,
    required List<String> summaryList,
  }) =>
      _channel
          .invokeMethod(
              'createMergerMessage',
              _buildParam({
                'messageList': messageList.map((e) => e.toJson()).toList(),
                'title': title,
                'summaryList': summaryList,
              }))
          .then((value) => _toObj(value));

  /// Create forward message
  Future<Message> createForwardMessage({required Message message}) {
    return _channel
        .invokeMethod(
            'createForwardMessage',
            _buildParam({
              'message': message.toJson(),
            }))
        .then((value) => _toObj(value));
  }

  /// Create location message
  Future<Message> createLocationMessage({
    required double latitude,
    required double longitude,
    required String description,
  }) =>
      _channel
          .invokeMethod(
              'createLocationMessage',
              _buildParam({
                'latitude': latitude,
                'longitude': longitude,
                'description': description,
              }))
          .then((value) => _toObj(value));

  /// Create custom message
  Future<Message> createCustomMessage({
    required String data,
    required String extension,
    required String description,
  }) =>
      _channel
          .invokeMethod(
              'createCustomMessage',
              _buildParam({
                'data': data,
                'extension': extension,
                'description': description,
              }))
          .then((value) => _toObj(value));

  /// Create quote message
  Future<Message> createQuoteMessage({
    required String text,
    required Message quoteMsg,
  }) =>
      _channel
          .invokeMethod(
              'createQuoteMessage',
              _buildParam({
                'quoteText': text,
                'quoteMessage': quoteMsg.toJson(),
              }))
          .then((value) => _toObj(value));

  /// Create card message
  Future<Message> createCardMessage({
    required Map<String, dynamic> data,
  }) =>
      _channel
          .invokeMethod(
              'createCardMessage',
              _buildParam({
                'cardMessage': data,
              }))
          .then((value) => _toObj(value));

  ///
  Future<dynamic> clearC2CHistoryMessage({required String uid}) => _channel
      .invokeMethod('clearC2CHistoryMessage', _buildParam({"userID": uid}));

  ///
  Future<dynamic> clearGroupHistoryMessage({required String gid}) => _channel
      .invokeMethod('clearGroupHistoryMessage', _buildParam({"groupID": gid}));

  ///
  // void forceSyncMsg() {
  //   _channel.invokeMethod('forceSyncMsg', _buildParam({}));
  // }

  static Map _buildParam(Map param) {
    param["ManagerName"] = "messageManager";
    return param;
  }

  static List<Message> _toList(String value) =>
      (_formatJson(value) as List).map((e) => Message.fromJson(e)).toList();

  static Message _toObj(String value) => Message.fromJson(_formatJson(value));

  static dynamic _formatJson(value) => jsonDecode(_printValue(value));

  static String _printValue(value) {
    return value;
  }
}
