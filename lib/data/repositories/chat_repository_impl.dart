import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';
import '../../core/utils/encryption_helper.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepositoryImpl());

class ChatRepositoryImpl {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _getChatRoomId(String id1, String id2) {
    List<String> ids = [id1, id2];
    ids.sort();
    return ids.join('_');
  }

  Future<void> sendMessage(ChatMessage message) async {
    final encryptedContent = await EncryptionService.encryptText(message.content);
    final roomId = _getChatRoomId(message.senderId, message.receiverId);

    final messageData = message.toMap();
    messageData['content'] = encryptedContent;
    messageData['roomId'] = roomId;

    await _firestore.collection('messages').doc(message.id).set(messageData);

    final box = await Hive.openBox('chats');
    await box.put(message.id, message.toMap());
  }

  Stream<List<ChatMessage>> getMessages(String userId, String otherUserId) {
    final roomId = _getChatRoomId(userId, otherUserId);

    // Attempt to load from Hive first for "offline-first" (simplified)
    // In a real app, we'd merge local and remote streams.

    return _firestore
        .collection('messages')
        .where('roomId', isEqualTo: roomId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final messages = <ChatMessage>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final decryptedContent = await EncryptionService.decryptText(data['content']);
        data['content'] = decryptedContent;
        messages.add(ChatMessage.fromMap(data));
      }
      return messages;
    });
  }
}
