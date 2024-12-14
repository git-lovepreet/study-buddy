import 'package:f_study_buddy/pages/matched_users_page.dart';
import 'package:f_study_buddy/pages/profile_page.dart';
import 'package:f_study_buddy/services/auth/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../services/auth/auth_service.dart';
import 'dart:math';


class PeopleRecommendationPage extends StatefulWidget {
  @override
  _PeopleRecommendationPageState createState() =>
      _PeopleRecommendationPageState();
}

class _PeopleRecommendationPageState extends State<PeopleRecommendationPage> {
  late MatchEngine _matchEngine;
  final List<SwipeItem> _swipeItems = [];
  final AuthService _authService = AuthService();

  final List<String> names = [
    "Amit Sharma", "Rahul Verma", "Priya Singh", "Ravi Kumar", "Sunita Patel",
    "Neha Gupta", "Anil Mehta", "Ramesh Yadav", "Vikram Rana", "Kavita Joshi",
    "Suresh Bansal", "Manoj Chawla", "Divya Nair", "Pooja Roy", "Ajay Thakur",
    "Arjun Malhotra", "Nisha Dutta", "Rajesh Tiwari", "Ritu Sharma", "Deepak Jain",
    "Swati Das", "Kiran Khanna", "Sanjay Dubey", "Anita Goel", "Vivek Kapoor",
    "Meena Rao", "Shikha Chauhan", "Tarun Aggarwal", "Seema Bhatt", "Prakash Sinha",
    "Aakash Mishra", "Geeta Reddy", "Abhishek Chaudhary", "Komal Batra", "Nitin Agarwal",
    "Mona Saxena", "Rajiv Pillai", "Smita Saha", "Lokesh Yadav", "Rohit Das",
    "Poonam Saxena", "Vandana Rathi", "Ashish Kaul", "Juhi Tandon", "Kunal Pathak",
    "Alok Singh", "Gaurav Arora", "Piyush Rawat", "Rekha Kohli", "Ankur Joshi",
    "Sneha Kulkarni", "Varun Nair", "Ranjit Purohit", "Mahesh Naik", "Isha Sharma",
    "Harish Iyer", "Sonia Kapoor", "Sandeep Jha", "Leena Wadhwa", "Manish Grover",
    "Pratibha Chauhan", "Avinash Pandey", "Arti Bajaj", "Kartik Sehgal", "Rakhi Tiwari",
    "Ajit Mohanty", "Chitra Subramanian", "Santosh Kulkarni", "Madhuri Ghosh", "Hemant Solanki",
    "Anjana Kaur", "Pritam Bhattacharya", "Sameer Dixit", "Uma Narayan", "Tina Roy"
  ];

  final List<String> degrees = [
    "Bachelor of Engineering (BE)",
    "Master of Engineering (ME)",
    "Diploma in Computer Science",
    "Bachelor of Arts (BA)",
    "Bachelor of Science (BSc)",
    "Bachelor of Commerce (BCom)",
    "MBBS",
    "Bachelor of Laws (LLB)",
    "Bachelor of Education (BEd)",
    "Master of Arts (MA)",
    "Master of Science (MSc)",
    "Master of Business Administration (MBA)",
    "Master of Laws (LLM)",
    "Doctor of Medicine (MD)",
    "Doctor of Philosophy (PhD)",
    "Associate Degree",
    "Diploma in Nursing",
    "Diploma in Management Studies",
    "Bachelor of Architecture (BArch)",
    "Bachelor of Design (BDes)",
    "Other"
  ];

  final List<String> institutes = [
    "Indian Institute of Technology Bombay",
    "Indian Institute of Technology Delhi",
    "Indian Institute of Technology Madras",
    "Indian Institute of Technology Kanpur",
    "Indian Institute of Technology Kharagpur",
    "Indian Institute of Technology Roorkee",
    "Indian Institute of Technology Guwahati",
    "Indian Institute of Science Bangalore",
    "All India Institute of Medical Sciences Delhi",
    "University of Delhi",
    "Jawaharlal Nehru University",
    "Banaras Hindu University",
    "University of Hyderabad",
    "National Institute of Technology Trichy",
    "National Institute of Technology Surathkal",
    "National Institute of Technology Warangal",
    "National Institute of Technology Calicut",
    "National Institute of Technology Rourkela",
    "National Institute of Technology Kurukshetra",
    "National Institute of Technology Patna",
    "National Institute of Technology Durgapur",
    "Indian Institute of Management Ahmedabad",
    "Indian Institute of Management Bangalore",
    "Indian Institute of Management Kolkata",
    "Indian Institute of Management Lucknow",
    "Indian Institute of Management Indore",
    "Indian Institute of Management Kozhikode",
    "Jamia Millia Islamia",
    "University of Calcutta",
    "University of Madras",
    "Aligarh Muslim University",
    "Amity University",
    "Birla Institute of Technology and Science Pilani",
    "Manipal Academy of Higher Education",
    "Savitribai Phule Pune University",
    "Jadavpur University",
    "Osmania University",
    "Visva-Bharati University",
    "Panjab University Chandigarh",
    "Anna University",
    "Shiv Nadar University",
    "Indian Statistical Institute Kolkata",
    "Indian School of Business Hyderabad",
    "Vellore Institute of Technology",
    "Symbiosis International University",
    "Guru Gobind Singh Indraprastha University",
    "Christ University Bangalore",
    "Kalinga Institute of Industrial Technology Bhubaneswar",
    "SRM Institute of Science and Technology",
    "Delhi Technological University",
    "Chandigarh University",
    "Lovely Professional University",
    "National Law School of India University Bangalore"
  ];

  List<Map<String, String>> get people {
    final random = Random();
    return List.generate(50, (index) {
      return {
        "name": names[random.nextInt(names.length)],
        "degree": degrees[random.nextInt(degrees.length)],
        "institute": institutes[random.nextInt(institutes.length)],
        "image": "assets/avatars/avatar_${random.nextInt(28) + 1}.png",
      };
    });
  }






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
