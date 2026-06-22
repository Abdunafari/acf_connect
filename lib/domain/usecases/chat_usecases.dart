import '../../data/models/models.dart';
import '../../data/repositories/chat_repository_impl.dart';

class GetMessagesUseCase {
  final ChatRepositoryImpl repository;

  GetMessagesUseCase(this.repository);

  Stream<List<ChatMessage>> call(String userId, String otherUserId) {
    return repository.getMessages(userId, otherUserId);
  }
}

class SendMessageUseCase {
  final ChatRepositoryImpl repository;

  SendMessageUseCase(this.repository);

  Future<void> call(ChatMessage message) {
    return repository.sendMessage(message);
  }
}
