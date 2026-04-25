import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '/core/services/auth_services.dart';
import '/core/constants/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  
  bool _isOtpSent = false;
  bool _isLoading = false;
  String _errorMessage = "";

  // Pre-fill Nigeria code
  final String _countryCode = "+234"; 

  void _submitPhoneNumber() {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      setState(() => _errorMessage = "Please enter a valid phone number");
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    _authService.verifyPhoneNumber(
      phoneNumber: "$_countryCode$phone",
      onCodeSent: (verificationId) {
        setState(() {
          _isOtpSent = true;
          _isLoading = false;
        });
      },
      onError: (error) {
        setState(() {
          _isLoading = false;
          _errorMessage = error;
        });
      },
    );
  }

  void _verifyOtp() async {
    setState(() => _isLoading = true);
    final success = await _authService.verifyOtp(_otpController.text.trim());
    
    if (success) {
      // Navigate to Home
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = "Invalid OTP code";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo / Branding
              const Icon(
                Icons.how_to_vote,
                size: 80,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(height: 20),
              Text(
                "ACF Connect",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _isOtpSent ? "Enter the code sent to your phone" : "Enter your phone number to join",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // Phone Input
              if (!_isOtpSent) ...[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _countryCode,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: "801 234 5678",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // OTP Input
              if (_isOtpSent) ...[
                Pinput(
                  controller: _otpController,
                  length: 6,
                  showCursor: true,
                  onCompleted: (pin) => _verifyOtp(),
                ),
              ],

              const SizedBox(height: 20),

              // Error Message
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : (_isOtpSent ? _verifyOtp : _submitPhoneNumber),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_isOtpSent ? "Verify & Join" : "Get OTP"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}