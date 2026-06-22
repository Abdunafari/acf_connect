import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tari (Status)')),
      body: Column(
        children: [
          ListTile(
            leading: Stack(
              children: [
                const CircleAvatar(radius: 25, child: Icon(Icons.person)),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: AppColors.secondaryGreen, shape: BoxShape.circle),
                    child: const Icon(Icons.add, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            title: const Text('My Status', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Tap to add status update'),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[200],
            child: const Text('Recent updates', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.secondaryGreen, width: 2),
                    ),
                    child: const CircleAvatar(radius: 23, child: Icon(Icons.person)),
                  ),
                  title: Text('Member ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Today, 10:30 AM'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {},
            mini: true,
            backgroundColor: Colors.white,
            child: const Icon(Icons.edit, color: AppColors.primaryGreen),
          ),
          SizedBox(height: 10.h),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: AppColors.secondaryGreen,
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
