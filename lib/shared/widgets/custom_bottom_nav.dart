import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: AppColors.grey,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.campaign),
          label: 'Gwamnati',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Tattaunawa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.circle_outlined),
          label: 'Tari',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Taro',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.volunteer_activism),
          label: 'Aiki',
        ),
      ],
    );
  }
}