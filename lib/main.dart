
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_study_buddy/firebase_options.dart';
import 'package:f_study_buddy/pages/education_details_page.dart';
import 'package:f_study_buddy/pages/splash_page.dart';
import 'package:f_study_buddy/theme/lightTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference usersRef = db.collection("users");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Buddy',
      theme: themeData,
      home: SplashPage()
      // home: ChatPage(recieverEmail: 'test021@gmail.com',recieverID: 'D95bhPMeXfefxwpc2wCbDWFsy0I3',),
    );
  }
}
