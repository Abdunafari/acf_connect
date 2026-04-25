import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/constants/app_colors.dart';
import 'shared/widgets/custom_bottom_nav.dart';
import 'features/auth/presentation/pages/login_page.dart';


void main() async {
  // Required for Firebase plugins
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  runApp(const ACFConnectApp());
}

class ACFConnectApp extends StatelessWidget {
  const ACFConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ACF Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryGreen,
        // ... keep your existing theme settings
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primaryGreen,
        ),
      ),
      // We define routes here
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(), // Start at Login
        '/home': (context) => const MainScreen(), // Go to home after login
      },
    );
  }
}

// ... Keep the MainScreen and CustomBottomNav code exactly as it was before

// This is the container that will hold our 5 screens later
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Placeholder pages - we will replace these with real screens later
  final List<Widget> _pages = [
    const Center(child: Text("Gwamnati (Updates)")),
    const Center(child: Text("Tattaunawa (Chat)")),
    const Center(child: Text("Tari (Status)")),
    const Center(child: Text("Taro (Events)")),
    const Center(child: Text("Aiki (Mobilize)")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}