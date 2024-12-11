import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:f_study_buddy/pages/hobies_selector_page.dart';
import 'package:f_study_buddy/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';
import 'package:f_study_buddy/components/button_dark.dart';
import 'package:f_study_buddy/pages/avatar_selection_page.dart';

import '../services/auth/auth_service.dart';

// Skill class that implements Taggable
class Skill extends Taggable {
  final String name;

  Skill({required this.name});

  @override
  List<Object> get props => [name];
}

class ProfessionalDataPage extends StatefulWidget {

  final bool newUser;

  ProfessionalDataPage({super.key, required this.newUser});

  @override
  _ProfessionalDataPageState createState() => _ProfessionalDataPageState();
}

class _ProfessionalDataPageState extends State<ProfessionalDataPage> {
  final List<Skill> selectedSkills = [];
  final TextEditingController goalsController = TextEditingController();

  // Firestore reference
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to save skills and goals in Firestore
  Future<void> saveProfessionalDetails(
      String userID, List<String> Skills, String goal) async {
    try {
      await _firestore.collection('Users').doc(userID).set({
        'Skills': Skills,
        'goal': goal,
      },
        SetOptions(merge: true),);
      print("Skills and goals saved successfully.");
    } catch (e) {
      print("Error saving skills and goals: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save data. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(Icons.arrow_back_ios_new,
                  size: 18, color: Theme.of(context).colorScheme.background),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: true, // Allows resizing when the keyboard appears
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                "Your Professional Details",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "Please provide your skills and goals to help us connect you better.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              FlutterTagging<Skill>(
                initialItems: selectedSkills,
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    labelText: "Skills",
                    prefixIcon: Icon(Icons.code),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                findSuggestions: (String query) async {
                  final allSkills = [
                    "Java",
                    "Python",
                    "C++",
                    "C#",
                    "JavaScript",
                    "HTML",
                    "CSS",
                    "SQL",
                    "Flutter",
                    "Dart",
                    "Kotlin",
                    "Swift",
                    "Critical Thinking", "Academic Writing", "Research Methodologies",
                    "Historical Analysis", "Creative Writing", "Communication Skills",
                    "Cultural Sensitivity", "Persuasive Argumentation", "Interdisciplinary Approach",
                    "Public Speaking", "Visual Analysis", "Ethical Reasoning", "Data Interpretation",
                    "Event Planning", "Translation and Interpretation", "Media Literacy",
                    "Cross-Cultural Communication", "Storytelling Techniques", "Advocacy and Lobbying",
                    "Conflict Resolution", "Laboratory Techniques", "Quantitative Data Analysis",
                    "Scientific Report Writing", "Statistical Modeling", "Experimental Design",
                    "Data Visualization", "Coding", "Mathematical Modeling", "Scientific Reasoning",
                    "Hypothesis Testing", "Instrument Calibration", "Field Data Collection",
                    "Environmental Monitoring", "Literature Review", "Scientific Ethics",
                    "Problem-Solving in STEM", "Systems Thinking", "Computational Analysis",
                    "Time-Series Analysis", "Chemical Synthesis Techniques", "CAD",
                    "Circuit Analysis", "Mechanical Design Principles", "Structural Analysis",
                    "Project Management", "Thermodynamics", "Fluid Dynamics",
                    "Electronics and Instrumentation", "Control Systems Design", "Software Development",
                    "Embedded Systems Programming", "Construction Project Planning",
                    "Finite Element Analysis", "Quality Assurance", "Robotics Fundamentals",
                    "Power Systems Engineering", "Material Science and Testing", "Industrial Automation",
                    "Renewable Energy Systems", "Data Logging", "Machine Learning Applications",
                    "IoT Integration", "Manufacturing Processes", "CNC Programming", "HVAC System Design",
                    "Traffic Engineering", "Aerodynamics", "Civil Engineering Surveying",
                    "Water Resource Management", "Geotechnical Analysis", "Bridge Design",
                    "Artificial Intelligence in Engineering", "Network Engineering",
                    "VLSI Design", "PCB Design", "Electric Vehicle Systems",
                    "Instrumentation and Control Systems", "Welding Technology",
                    "Process Engineering", "Supply Chain Management", "Financial Analysis",
                    "Accounting Principles", "Business Strategy", "Marketing Research",
                    "E-Commerce Management", "Auditing", "Taxation", "Portfolio Management",
                    "Supply Chain Optimization", "Negotiation Skills", "Consumer Behavior Analysis",
                    "Business Law Basics", "Risk Assessment", "Process Improvement",
                    "Retail Management", "Trade Finance", "Financial Modeling",
                    "Entrepreneurship", "Inventory Management", "Sales Planning",
                    "Business Communication", "Anatomy Knowledge", "Surgical Skills",
                    "Diagnosis Planning", "Patient Communication", "Emergency Medicine Response",
                    "Pathology Analysis", "Medical Imaging Interpretation", "Pharmacology",
                    "Epidemiology", "Medical Research", "Clinical Decision-Making",
                    "Medical Ethics", "First Aid", "Public Health Awareness", "Patient Counseling",
                    "Teamwork in Healthcare", "Pain Management", "Infection Control",
                    "Palliative Care Skills", "Record Keeping in Healthcare", "Legal Research",
                    "Contract Drafting", "Negotiation", "Litigation Strategies",
                    "Understanding Legal Precedents", "Client Counseling", "Courtroom Speaking",
                    "Mediation Techniques", "Critical Legal Analysis", "Advocacy",
                    "Arbitration", "Case Law Interpretation", "Legal Writing",
                    "Ethical Law Practice", "Intellectual Property Law", "Criminal Law Knowledge",
                    "Corporate Law Understanding", "International Law Principles",
                    "Cyber Law Knowledge", "Environmental Law Awareness", "Curriculum Development",
                    "Lesson Planning", "Classroom Management", "Assessment Techniques",
                    "Educational Psychology", "Inclusive Teaching Strategies", "Teaching Aids Usage",
                    "Technology in Education", "Differentiated Instruction",
                    "Child Development Understanding", "Teacher Communication Skills",
                    "Conflict Resolution in Classrooms", "Evaluation Methods",
                    "Creativity in Teaching", "Leadership in Education", "Guidance and Counseling",
                    "Community Engagement", "Research in Education", "Time Management in Teaching",
                    "Effective Questioning Techniques", "Advanced Critical Analysis",
                    "Specialized Research Methods", "Policy Analysis", "Advanced Academic Writing",
                    "Communication Strategy Development", "Public Relations Expertise",
                    "Advocacy and Activism", "Qualitative Research", "Conflict Resolution",
                    "Creative Innovation", "Advanced Lab Techniques", "High-Level Statistical Analysis",
                    "Predictive Modeling", "Complex Data Interpretation",
                    "Advanced Experimental Design", "Computational Science Applications",
                    "Machine Learning Algorithms", "Deep Learning Basics", "Climate Modeling",
                    "Advanced Programming", "Strategic Planning", "Leadership Development",
                    "Corporate Finance Expertise", "Advanced Marketing Strategies",
                    "Brand Management", "Operations Management", "Business Analytics",
                    "Decision-Making Frameworks", "Change Management", "Team Building",
                    "Web Development", "Database Management", "Mobile App Development",
                    "UI/UX Design", "Software Testing", "Basic Patient Care",
                    "Administering Medications", "Infection Prevention", "Design Thinking",
                    "Graphic Design Principles"
                    // Add more skills as needed
                  ];

                  final filteredSkills = allSkills
                      .where((Skill) => Skill.toLowerCase().contains(query.toLowerCase()))
                      .map((name) => Skill(name: name))
                      .toList();

                  // If no match, add the query as a custom skill option
                  if (filteredSkills.isEmpty && query.isNotEmpty) {
                    filteredSkills.add(Skill(name: query)); // Add the user's input as a skill
                  }

                  return filteredSkills;
                },
                configureSuggestion: (Skill Skill) {
                  return SuggestionConfiguration(
                    title: Text(Skill.name),
                  );
                },
                configureChip: (Skill Skill) {
                  return ChipConfiguration(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      Skill.name,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    ),
                    deleteIcon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  );
                },
                onChanged: () {
                  if (selectedSkills.length > 5) {
                    selectedSkills.removeLast();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Only 5 skills are allowed."),
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: goalsController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Your Goals (Private)",
                  prefixIcon: Icon(Icons.emoji_objects),
                  helperText:
                  "These goals will not be shown to anyone. They will help us connect you better.",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DarkButton(
                onTap: () async {
                  if (selectedSkills.isEmpty || goalsController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please fill in all the details."),
                      ),
                    );
                  } else {
                    List<String> Skills =
                    selectedSkills.map((Skill) => Skill.name).toList();
                    String goal = goalsController.text;
                    final String? userID = AuthService().getUId();

                    // Save data to Firestore
                    await saveProfessionalDetails(userID!, Skills, goal);

                    // Proceed to the next screen
                    if(widget.newUser){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HobiesSelectorPage(
                                    newUser: true,
                                  )));
                    }else{
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyProfilePage()));
                        }
                  }
                },
                text: "Next",
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
