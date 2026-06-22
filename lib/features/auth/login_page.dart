import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import '../../data/repositories/auth_repository_impl.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _verificationId = '';
  bool _codeSent = false;

  void _verifyPhone() async {
    final authService = ref.read(authServiceProvider);
    await authService.verifyPhone(
      phoneNumber: _phoneController.text,
      codeSent: (verificationId, resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
        });
      },
      verificationFailed: (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Verification Failed')));
      },
    );
  }

  void _signIn() async {
    final authService = ref.read(authServiceProvider);
    try {
      await authService.signInWithOtp(_verificationId, _otpController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid OTP')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ACF Connect Login')),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_codeSent) ...[
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+234...',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: _verifyPhone,
                child: const Text('Send OTP'),
              ),
            ] else ...[
              Pinput(
                length: 6,
                controller: _otpController,
                onCompleted: (pin) => _signIn(),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: _signIn,
                child: const Text('Verify & Login'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
