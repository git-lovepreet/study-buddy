import 'package:f_study_buddy/components/button_dark.dart';
import 'package:f_study_buddy/components/button_light.dart';
import 'package:f_study_buddy/components/google_background.dart';
import 'package:f_study_buddy/components/text_field_01.dart';
import 'package:f_study_buddy/pages/people_recommendation_page.dart';
import 'package:f_study_buddy/pages/user_name_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Incorrect password. Try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'An unknown error occurred.';
    }
  }

  void createAccountWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String status = await AuthService().signInWithGoogle();
      if (status == "registered") {
        // Navigate to People Recommendation Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PeopleRecommendationPage()),
        );
      } else {
        // Navigate to Username Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserNamePage()), // Replace with your UsernamePage widget
        );
      }
    } catch (e) {
      String errorMessage = getErrorMessage(e.toString());
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void createAccount() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService().signUpWithEmailPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserNamePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              "Create account",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.inversePrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Fill your information below or register\nwith your social account.",
                              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 22),
                            MyTextField01(
                              icon: const Icon(Icons.email_outlined),
                              labeltext: "Enter your Email",
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 14),
                            MyTextField01(
                              icon: const Icon(Icons.lock_outline),
                              labeltext: "Password",
                              obscureText: _obscurePassword,
                              controller: passwordController,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 14),
                            MyTextField01(
                              icon: const Icon(Icons.lock_outline),
                              labeltext: "Confirm Password",
                              obscureText: _obscureConfirmPassword,
                              controller: confirmPasswordController,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "By creating your account, you accept the Terms of Use and Privacy Policy.",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(thickness: 1, color: Colors.grey.shade300),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Or Sign In With",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.inversePrimary,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Divider(thickness: 1, color: Colors.grey.shade300),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            if (_isLoading)
                              const CircularProgressIndicator(),
                            if (!_isLoading)
                              GestureDetector(onTap: createAccountWithGoogle,
                                    child: GABackground(stringPath: "assets/google/ggl.png",)),

                          ],
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            if (_isLoading)
                              const CircularProgressIndicator(),
                            if (!_isLoading)
                              DarkButton(
                                onTap: createAccount,
                                text: "Create your Account",
                              ),
                            const SizedBox(height: 10),
                            LightButton(
                              onTap: widget.onTap,
                              text: "Login",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
