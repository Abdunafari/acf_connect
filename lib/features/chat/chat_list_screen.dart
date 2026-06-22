import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ACF Connect'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(radius: 25, child: Icon(Icons.person)),
            title: Text(index == 0 ? 'Admin Help' : 'Member $index', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(index == 0 ? 'How can we help you today?' : 'Assalamu alaikum...'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('10:45 AM', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                if (index % 3 == 0)
                  Container(
                    margin: EdgeInsets.only(top: 5.h),
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(color: AppColors.secondaryGreen, shape: BoxShape.circle),
                    child: Text('2', style: TextStyle(color: Colors.white, fontSize: 10.sp)),
                  ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    otherUserId: index == 0 ? 'test_admin' : 'user_$index',
                    otherUserName: index == 0 ? 'Admin Help' : 'Member $index',
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.secondaryGreen,
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}
