import 'package:f_study_buddy/pages/matched_users_page.dart';
import 'package:f_study_buddy/pages/profile_page.dart';
import 'package:f_study_buddy/services/auth/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../services/auth/auth_service.dart';


class PeopleRecommendationPage extends StatefulWidget {
  @override
  _PeopleRecommendationPageState createState() =>
      _PeopleRecommendationPageState();
}

class _PeopleRecommendationPageState extends State<PeopleRecommendationPage> {
  late MatchEngine _matchEngine;
  final List<SwipeItem> _swipeItems = [];
  final AuthService _authService = AuthService();

  final List<Map<String, String>> people = [
    {
      "name": "Aman Thakral",
      "degree": "Bachelor of Engineering (BE)",
      "institute": "DCRUST, Murthal",
      "image": "assets/avatars/avatar_4.png", // Replace with real images
    },
    {
      "name": "Paras Mehta",
      "degree": "Bachelor of Engineering (BE)",
      "institute": "DCRUST, Murthal",
      "image": "assets/avatars/avatar_14.png", // Replace with real images
    },
    {
      "name": "Anshul Dhillon",
      "degree": "Bachelor of Engineering (BE)",
      "institute": "DCRUST, Murthal",
      "image": "assets/avatars/avatar_22.png", // Replace with real images
    },
  ];



  @override
  void initState() {
    super.initState();
    for (var person in people) {
      _swipeItems.add(SwipeItem(
        content: person,
        likeAction: () {
          print("Accepted: ${person["name"]}");
        },
        nopeAction: () {
          print("Rejected: ${person["name"]}");
        },
      ));
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.person_2_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyProfilePage()),
            );
          },
        ),
        title: Text("StudyBuddy",
          style: TextStyle(color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold),),

        actions: [
          IconButton(
            icon: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.message_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MatchedUsersPage()),
              );
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,

      ),
      body: Column(
        children: [
          Expanded(
            child: SwipeCards(
              matchEngine: _matchEngine,
              itemBuilder: (context, index) {
                final person = _swipeItems[index].content as Map<String, String>;
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(
                          person["image"]!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(21)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 2),
                                child: Text(
                                  person["name"]!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(21)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 2),
                                child: Text(
                                  person["degree"]!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(21)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 2),
                                child: Text(
                                  person["institute"]!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Active",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onStackFinished: () {
                print("No more people to swipe!");
              },
              upSwipeAllowed: false,
              fillSpace: true,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.red, size: 40),
                onPressed: () {
                  _matchEngine.currentItem?.nope();
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite, color: Colors.green, size: 40),
                onPressed: () {
                  _matchEngine.currentItem?.like();
                },
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
