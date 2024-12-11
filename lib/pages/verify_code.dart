import 'package:f_study_buddy/components/button_dark.dart';
import 'package:flutter/material.dart';

class VerifyCodePage extends StatefulWidget {
  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final List<TextEditingController> _otpControllers =
  List.generate(4, (_) => TextEditingController());

  void _onVerify() {
    final otpCode =
    _otpControllers.map((controller) => controller.text).join();
    print("Entered OTP Code: $otpCode");
    // Add verification logic here
  }

  void _onResendOTP() {
    print("Resend OTP requested");
    // Add resend OTP logic here
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,

            ),
              child: Center(child: Icon(Icons.arrow_back_ios_new,size:18,color:Theme.of(context).colorScheme.background))),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Verify Code",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Please enter the code we just sent to email",
              style: TextStyle(color: Colors.grey),
            ),
             Text("Dumy@email.com",
              style: TextStyle(
                color:Theme.of(context).colorScheme.primary ),),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _otpControllers[index],
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      counterText: '',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Text(
              "Didn't receive OTP?",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            GestureDetector(
              onTap: _onResendOTP,
              child: Text(
                "Resend OTP",
                style: TextStyle(
                  color:Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            DarkButton(onTap: _onVerify, text: "Verify"),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
