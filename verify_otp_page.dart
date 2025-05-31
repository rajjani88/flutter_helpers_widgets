import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  int secondsRemaining = 59;
  bool canResend = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (secondsRemaining == 0) {
        setState(() {
          canResend = true;
          t.cancel();
        });
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  void resendOtp() {
    setState(() {
      secondsRemaining = 59;
      canResend = false;
    });
    startTimer();
    // trigger resend logic here
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 48,
      child: TextField(
        controller: otpControllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phoneNumber = '+91-84357895**';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.green),
                onPressed: () => Get.back(),
              ),
              const SizedBox(height: 12),

              // Title
              const Text(
                'OTP Verification',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),

              // Subtitle
              Row(
                children: [
                  Text('OTP has been sent to $phoneNumber  '),
                  TextButton(
                    onPressed: () {}, // handle change number
                    child: const Text(
                      'Change',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // OTP input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _buildOtpField(index)),
              ),
              const SizedBox(height: 24),

              // Auto-detect
              const Center(
                child: Text(
                  'Auto-detecting your  OTP ,',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),

              // Resend timer
              Center(
                child: canResend
                    ? TextButton(
                        onPressed: resendOtp,
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(color: Colors.green),
                        ),
                      )
                    : Text(
                        'Resend OTP in ${secondsRemaining}s',
                        style: const TextStyle(color: Colors.green),
                      ),
              ),
              const Spacer(),

              // Login Button (disabled)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.grey,
                  ),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
