import 'package:f_study_buddy/components/button_dark.dart';
import 'package:f_study_buddy/components/button_light.dart';
import 'package:f_study_buddy/components/google_background.dart';
import 'package:f_study_buddy/components/text_field_01.dart';
import 'package:f_study_buddy/pages/people_recommendation_page.dart';
import 'package:f_study_buddy/pages/user_name_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool validateFields(BuildContext context) {
      if (emailController.text.trim().isEmpty || !emailController.text.contains("@")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid email.")),
        );
        return false;
      }
      if (passwordController.text.trim().isEmpty || passwordController.text.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password must be at least 6 characters.")),
        );
        return false;
      }
      return true;
    }

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on outside tap
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 30),
                            Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.inversePrimary,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Hi! Welcome back, you’ve been missed",
                              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 40),
                            MyTextField01(
                              icon: const Icon(Icons.email_outlined),
                              labeltext: "Enter your Email",
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            MyTextField01(
                              icon: const Icon(Icons.lock_outline),
                              labeltext: "Password",
                              obscureText: _obscurePassword,
                              controller: passwordController,
                              suffixIcon: IconButton(
                                padding: const EdgeInsets.only(right: 10),
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Navigate to Forgot Password Page
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "By clicking Login, you accept the Terms of Use and Privacy Policy.",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 26),
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
                              GestureDetector(
                                onTap: () async {
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
                                },
                                child: GABackground(stringPath: "assets/google/ggl.png",),
                              ),


                          ],
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            if (_isLoading)
                              const CircularProgressIndicator(),
                            if (!_isLoading)
                              DarkButton(
                                onTap: () async {
                                  if (validateFields(context)) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    try {
                                      await AuthService().signInWithEmailPassword(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      );
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PeopleRecommendationPage()),
                                      );
                                    } catch (e) {
                                      String errorMessage = getErrorMessage(e.toString());
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(errorMessage)),
                                      );
                                    } finally {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  }
                                },
                                text: "Login",
                              ),
                            const SizedBox(height: 10),
                            LightButton(onTap: widget.onTap, text: "Create your Account"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}