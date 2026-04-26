import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/gamification_repository_impl.dart';

class ProfileLeaderboardScreen extends StatelessWidget {
  const ProfileLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gamificationRepo = GamificationRepositoryImpl();

    return Scaffold(
      appBar: AppBar(title: const Text('Aiki (Leaderboard)')),
      body: Column(
        children: [
          _buildProfileHeader(),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Top Members', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: gamificationRepo.getLeaderboard(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final leaders = snapshot.data!;
                return ListView.builder(
                  itemCount: leaders.length,
                  itemBuilder: (context, index) {
                    final leader = leaders[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(leader['name'] ?? 'Unknown'),
                      subtitle: Text('${leader['ward']} / ${leader['lga']}'),
                      trailing: Text('${leader['points']} pts', style: const TextStyle(color: AppColors.kanoGreen, fontWeight: FontWeight.bold)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          SizedBox(width: 20.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('My Name', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              Text('Ward Coordinator', style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
              SizedBox(height: 5.h),
              const Text('Points: 1250', style: TextStyle(color: AppColors.kanoGreen, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
