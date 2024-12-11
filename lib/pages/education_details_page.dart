import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_study_buddy/components/button_dark.dart';
import 'package:f_study_buddy/components/text_field_01.dart';
import 'package:f_study_buddy/pages/gender_selection_page.dart';
import 'package:f_study_buddy/pages/professional_data_page.dart';
import 'package:f_study_buddy/pages/profile_page.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';

class EducationDetailsPage extends StatefulWidget {

  final bool newUser;

  EducationDetailsPage({super.key, required this.newUser});

  @override
  _EducationDetailsPageState createState() => _EducationDetailsPageState();
}

class _EducationDetailsPageState extends State<EducationDetailsPage> {
  String? selectedDegree;
  final TextEditingController instituteController = TextEditingController();
  final FocusNode instituteFocusNode = FocusNode();
  bool isLoading = false;
  String errorMessage = "";

  final List<String> Degrees = [
    "Bachelor of Arts (BA)",
    "Bachelor of Science (BSc)",
    "Bachelor of Engineering (BE)",
    "Bachelor of Commerce (BCom)",
    "MBBS",
    "Bachelor of Laws (LLB)",
    "Bachelor of Education (BEd)",
    "Master of Arts (MA)",
    "Master of Science (MSc)",
    "Master of Business Administration (MBA)",
    "Master of Engineering (ME)",
    "Master of Laws (LLM)",
    "Doctor of Medicine (MD)",
    "Doctor of Philosophy (PhD)",
    "Associate Degree",
    "Diploma in Nursing",
    "Diploma in Computer Science",
    "Diploma in Management Studies",
    "Bachelor of Architecture (BArch)",
    "Bachelor of Design (BDes)",
    "Other",
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
    "Indian Institute of Technology Ropar",
    "Indian Institute of Technology Gandhinagar",
    "Indian Institute of Technology Bhubaneswar",
    "Indian Institute of Technology Hyderabad",
    "Indian Institute of Technology Patna",
    "Indian Institute of Technology Indore",
    "Indian Maritime University",
    "Tata Institute of Social Sciences Mumbai",
    "Indian Institute of Foreign Trade Delhi",
    "Sardar Vallabhbhai National Institute of Technology Surat",
    "Central University of Rajasthan",
    "Central University of Gujarat",
    "Central University of Punjab",
    "Central University of Himachal Pradesh",
    "Central University of Tamil Nadu",
    "Central University of Kerala",
    "Central University of Karnataka",
    "Central University of Odisha",
    "Central University of Jammu",
    "Central University of Jharkhand",
    "Central University of South Bihar",
    "Central University of Haryana",
    "Central University of Andhra Pradesh",
    "Chandigarh University",
    "Indian Institute of Science Education and Research Pune",
    "Indian Institute of Science Education and Research Mohali",
    "Indian Institute of Science Education and Research Kolkata",
    "Indian Institute of Science Education and Research Bhopal",
    "Indian Institute of Science Education and Research Tirupati",
    "Birla Institute of Technology Ranchi",
    "Lovely Professional University",
    "National Law School of India University Bangalore",
    "NALSAR University of Law Hyderabad",
    "National Law University Delhi",
    "National Law University Jodhpur",
    "The West Bengal National University of Juridical Sciences",
    "Gujarat National Law University",
    "Hidayatullah National Law University Raipur",
    "Rajiv Gandhi National University of Law Punjab",
    "National University of Advanced Legal Studies Kochi",
    "Indian Institute of Technology Dhanbad",
    "Indian Institute of Technology Jammu",
    "Indian Institute of Technology Tirupati",
    "Indian Institute of Technology Palakkad",
    "Indian Institute of Management Sambalpur",
    "Indian Institute of Management Bodh Gaya",
    "Indian Institute of Management Jammu",
    "Indian Institute of Management Amritsar",
    "Indian Institute of Technology Mandi",
    "National Institute of Pharmaceutical Education and Research Mohali",
    "Indian Institute of Space Science and Technology Thiruvananthapuram",
    "Homi Bhabha National Institute Mumbai",
    "Rashtriya Raksha University Gujarat",
    "Indian Institute of Technology Goa",
    "International Institute of Information Technology Hyderabad",
    "International Institute of Information Technology Bangalore",
    "International Institute of Information Technology Pune",
    "National Institute of Design Ahmedabad",
    "National Institute of Fashion Technology Delhi",
    "National Institute of Fashion Technology Mumbai",
    "National Institute of Fashion Technology Chennai",
    "National Institute of Fashion Technology Kolkata",
    "National Institute of Fashion Technology Bengaluru",
    "National Institute of Fashion Technology Gandhinagar",
    "National Institute of Fashion Technology Hyderabad",
    "National Institute of Fashion Technology Patna",
    "Indian Institute of Management Shillong",
    "Indian Institute of Management Udaipur",
    "Central University of Mizoram",
    "Central University of Sikkim",
    "Indian Institute of Technology Bhilai",
    "Indian Institute of Technology Dharwad",
    "National Institute of Technology Meghalaya",
    "National Institute of Technology Nagaland",
    "National Institute of Technology Arunachal Pradesh",
    "National Institute of Technology Manipur",
    "National Institute of Technology Mizoram",
    "National Institute of Technology Sikkim",
    "National Institute of Technology Srinagar",
    "Indian Institute of Technology Jammu",
    "Jamia Hamdard",
    "National Law University Odisha",
    "Tamil Nadu National Law University",
    "Damodaram Sanjivayya National Law University",
    "Chanakya National Law University",
    "Dr. Ram Manohar Lohiya National Law University Lucknow",
    "Indira Gandhi Institute of Development Research",
    "Jawaharlal Nehru Centre for Advanced Scientific Research Bangalore",
    "Mahatma Gandhi University Kerala",
    "Dr. Hari Singh Gour University Sagar",
    "Kumar Mangalam Birla University",
    "Azim Premji University Bangalore",
    "Mahatma Gandhi Antarrashtriya Hindi Vishwavidyalaya",
    "Jamia Millia Islamia Delhi",
    "Nalanda University",
    "Indian Institute of Petroleum and Energy Vizag",
    "Indian Institute of Technology Gandhinagar",
    "Doon University",
    "North-Eastern Hill University Shillong",
    "Central University of Bihar"
  ];

  List<String> filteredInstitutes = [];

  @override
  void initState() {
    super.initState();
    instituteController.addListener(_filterInstitutes);
  }

  @override
  void dispose() {
    instituteController.dispose();
    instituteFocusNode.dispose();
    super.dispose();
  }

  void _filterInstitutes() {
    final query = instituteController.text.toLowerCase();
    setState(() {
      filteredInstitutes = institutes
          .where((institute) => institute.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> saveEducationDetails(String Degree, String Institute) async {
    try {
      final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');
      final String? userID = AuthService().getUId(); // Replace this with authenticated user ID

      await users.doc(userID).set({
        'Degree': Degree,
        'Institute': Institute,
      }, SetOptions(merge: true));
    } catch (e) {
      setState(() {
        errorMessage = "Error saving education details. Please try again.";
      });
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
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Theme.of(context).colorScheme.background,
              ),
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
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Dismiss keyboard on tap
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    "Your Education Details",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Please provide your latest education details.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Degree",
                      prefixIcon: const Icon(Icons.school),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    value: selectedDegree,
                    isExpanded: true, // Expands the dropdown to use available space
                    isDense: true, // Reduces vertical padding
                    items: Degrees.map((Degree) {
                      return DropdownMenuItem<String>(
                        value: Degree,
                        child: Text(
                          Degree,
                          overflow: TextOverflow.ellipsis, // Prevents text overflow
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDegree = value;
                        errorMessage = ""; // Clear error message
                      });
                    },
                  ),



                  const SizedBox(height: 20),
                  TextField(
                    controller: instituteController,
                    focusNode: instituteFocusNode,
                    decoration: InputDecoration(
                      labelText: "Institute Name",
                      prefixIcon: const Icon(Icons.location_city),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  if (filteredInstitutes.isNotEmpty)
                    Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: filteredInstitutes.length,
                        itemBuilder: (context, index) {
                          final institute = filteredInstitutes[index];
                          return ListTile(
                            title: Text(institute),
                            onTap: () {
                              instituteController.text = institute;
                              setState(() {
                                filteredInstitutes = [];
                              });
                              FocusScope.of(context).unfocus();
                            },
                          );
                        },
                      ),
                    ),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  const SizedBox(height: 20),
                  isLoading
                      ? CircularProgressIndicator()
                      : DarkButton(
                    onTap: () async {
                      final String? Degree = selectedDegree;
                      final String institute =
                      instituteController.text.trim();

                      if (Degree == null || Degree.isEmpty) {
                        setState(() {
                          errorMessage = "Please select a Degree.";
                        });
                        return;
                      }
                      if (institute.isEmpty) {
                        setState(() {
                          errorMessage = "Please enter your institute name.";
                        });
                        return;
                      }

                      setState(() {
                        isLoading = true;
                        errorMessage = "";
                        filteredInstitutes = []; // Close dropdown
                      });

                      await saveEducationDetails(Degree, institute);

                      setState(() {
                        isLoading = false;
                      });

                      if (errorMessage.isEmpty) {
                        if (widget.newUser) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProfessionalDataPage(newUser: true,)),
                          );
                        }else{
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyProfilePage()),
                        );
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
        ),
      ),
    );
  }
}
