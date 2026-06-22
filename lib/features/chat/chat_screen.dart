import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/models.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../core/services/user_provider.dart';
import 'agora_service.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String otherUserId;
  final String otherUserName;

  const ChatScreen({super.key, required this.otherUserId, required this.otherUserName});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final AgoraService _agoraService = AgoraService();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _agoraService.initAgora();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final currentUserId = ref.read(currentUserIdProvider);
    if (currentUserId == null || _messageController.text.trim().isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: currentUserId,
      receiverId: widget.otherUserId,
      content: _messageController.text.trim(),
      timestamp: DateTime.now(),
    );

    ref.read(chatRepositoryProvider).sendMessage(message);
    _messageController.clear();
    setState(() {});
  }

  Future<void> _startRecording() async {
    if (await _audioRecorder.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/rn_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(const RecordConfig(), path: path);
      setState(() => _isRecording = true);
    }
  }

  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stop();
    setState(() => _isRecording = false);
    if (path != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Voice note recorded: $path')));
    }
  }

  void _startCall({bool isVideo = true}) async {
    final currentUserId = ref.read(currentUserIdProvider) ?? 'user';
    final List<String> ids = [currentUserId, widget.otherUserId];
    ids.sort();
    final channelName = ids.join('_');

    await _agoraService.joinChannel(channelName, 0, isHost: true);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Starting ${isVideo ? 'Video' : 'Audio'} Call...')));
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(currentUserIdProvider) ?? 'unknown';

    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD),
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(radius: 18, child: Icon(Icons.person)),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.otherUserName, style: TextStyle(fontSize: 16.sp)),
                Text(tr('online'), style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam), onPressed: () => _startCall(isVideo: true)),
          IconButton(icon: const Icon(Icons.call), onPressed: () => _startCall(isVideo: false)),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: ref.read(chatRepositoryProvider).getMessages(currentUserId, widget.otherUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text(tr('no_messages')));
                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == currentUserId;
                    return ChatBubble(message: msg, isMe: isMe);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey), onPressed: () {}),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: _isRecording ? 'Recording...' : tr('type_message'),
                        border: InputBorder.none,
                      ),
                      onChanged: (val) => setState(() {}),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.attach_file, color: Colors.grey), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.camera_alt, color: Colors.grey), onPressed: () {}),
                ],
              ),
            ),
          ),
          SizedBox(width: 5.w),
          GestureDetector(
            onLongPress: _startRecording,
            onLongPressUp: _stopRecording,
            child: CircleAvatar(
              backgroundColor: AppColors.primaryGreen,
              child: IconButton(
                icon: Icon(_messageController.text.isEmpty ? Icons.mic : Icons.send, color: Colors.white),
                onPressed: _messageController.text.isEmpty ? null : _sendMessage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const ChatBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 50.w : 10.w,
          right: isMe ? 10.w : 50.w,
          top: 5.h,
          bottom: 5.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: isMe ? AppColors.bubbleSent : AppColors.bubbleReceived,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 1,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message.content, style: TextStyle(fontSize: 16.sp)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 10.sp, color: AppColors.textGrey),
                ),
                if (isMe) ...[
                  SizedBox(width: 5.w),
                  Icon(Icons.done_all, size: 14.sp, color: Colors.blue),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
