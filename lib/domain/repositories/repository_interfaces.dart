import '../../data/models/models.dart';

abstract class ChatRepositoryInterface {
  Future<void> sendMessage(ChatMessage message);
  Stream<List<ChatMessage>> getMessages(String userId, String otherUserId);
}

abstract class AuthRepositoryInterface {
  Stream<dynamic> get authStateChanges;
  Future<void> verifyPhone({
    required String phoneNumber,
    required Function(String, int?) codeSent,
    required Function(dynamic) verificationFailed,
  });
  Future<dynamic> signInWithOtp(String verificationId, String smsCode);
}
