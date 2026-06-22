import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_theme.dart';
import '../../features/map/map_screen.dart';
import '../../features/event/events_page.dart';
import '../../features/profile/profile_leaderboard_screen.dart';
import '../../features/chat/status_screen.dart';
import '../../features/chat/chat_list_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ChatListScreen(),
    const StatusScreen(),
    const EventsPage(),
    const MobilizationMapScreen(),
    const ProfileLeaderboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.kanoGreen,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.chat), label: 'chat'.tr()),
          BottomNavigationBarItem(icon: const Icon(Icons.circle_outlined), label: 'status'.tr()),
          BottomNavigationBarItem(icon: const Icon(Icons.event), label: 'event'.tr()),
          BottomNavigationBarItem(icon: const Icon(Icons.map), label: 'map'.tr()),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: 'profile'.tr()),
        ],
      ),
    );
  }
}
