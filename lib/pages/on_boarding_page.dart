import 'package:f_study_buddy/components/button_dark.dart';
import 'package:f_study_buddy/services/auth/login_or_register.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          ModalPage(
            title: 'Swipe',
            description: 'Swipe left to know more!',
            imagePath: 'assets/slides/slide1.png',
          ),
          ModalPage(
            title: 'Connect',
            description: 'Match with like-minded professionals or learners',
            imagePath: 'assets/slides/slide2.png',
          ),
          ModalPage(
            title: 'Collaborate',
            description: 'Team up for projects and shared goals',
            imagePath: 'assets/slides/slide3.png',
          ),
          ModalPage(
            title: 'Chat',
            description: 'Instant messaging to share ideas and discuss interests',
            imagePath: 'assets/slides/slide4.png',
            isLastPage: true,
          ),
        ],
      ),
    );
  }
}

class ModalPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final bool isLastPage;


  const ModalPage({
    required this.title,
    required this.description,
    required this.imagePath,
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container( // Background color
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.primary,Theme.of(context).colorScheme.background],
              begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 300,
                width: 300,
                child: Image.asset(imagePath,scale: 0.8,)), // Display the illustration
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          SizedBox(height: 32),
          if (isLastPage)
            DarkButton(text: "Get Started",
              onTap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginOrRegister()));},
                )
        ],
      ),
    );
  }
}
