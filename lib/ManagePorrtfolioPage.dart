import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EducationModel {
  final String course;
  final String schoolName;
  final String studyLevel;
  final String startYear;
  final String endYear;

  EducationModel({
    required this.course,
    required this.schoolName,
    required this.studyLevel,
    required this.startYear,
    required this.endYear,
  });
}

class ManagePortfolioPage extends StatefulWidget {
  const ManagePortfolioPage({super.key});

  @override
  State<ManagePortfolioPage> createState() => _ManagePortfolioPageState();
}

class _ManagePortfolioPageState extends State<ManagePortfolioPage> {
  // Data for Biodata Section
  String _name = "";
  String _phoneNumber = "";
  String _email = "";
  String _aboutMeText = ".";
  String _profileImage = "";
  File? _pickedImage;

  final databaseRef = FirebaseDatabase.instance.ref();

  // Data for Work Experience Section
  List<Map<String, dynamic>> _workExperiences = [];

  // Data for Education Section
  List<EducationModel> educationList = [];

  // Data for Skills Section
  List<String> _skills = [];

  // Data for Social Links Section
  Map<String, String> _socialLinks = {};

  // TextEditingController for each field
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _aboutMeController = TextEditingController();
  final _profileImageController = TextEditingController();

  // Controllers for work experience
  final _workExperienceStartDateController = TextEditingController();
  final _workExperienceEndDateController = TextEditingController();
  final _workExperiencePositionController = TextEditingController();
  final _workExperienceCompanyNameController = TextEditingController();

  // Controllers for education
  final _educationStartYearController = TextEditingController();
  final _educationEndYearController = TextEditingController();
  final _educationSchoolNameController = TextEditingController();
  final _educationStudyLevelController = TextEditingController();
  final _educationCourseMajorController = TextEditingController();

  // Controllers for skills
  final _skillsController = TextEditingController();

  // Controllers for social links
  final _socialLinkNameController = TextEditingController();
  final _socialLinkUrlController = TextEditingController();

  // Keys for form validation
  final _formKey = GlobalKey<FormState>();
  final _workExperienceFormKey = GlobalKey<FormState>();
  final _educationFormKey = GlobalKey<FormState>();
  final _skillsFormKey = GlobalKey<FormState>();
  final _socialLinksFormKey = GlobalKey<FormState>();

  // Initializing controllers with existing data
  @override
  void initState() {
    super.initState();
    _loadInfoData();
    // _loadWorkExperiences();
    _loadEducation();
    _loadSkills();
    _loadSocialLinks();
  }

  Future<void> _selectImage() async {
    // if (await Permission.storage.request().isGranted) {
    // Permission granted, proceed with image picking
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        _profileImage = pickedFile.path;
        _profileImageController.text = _pickedImage!.path;
      });

      // Upload image to Firebase Storage
      await _uploadImageToStorage();
    }
    // } else {
    //   print("fail to get permission");
    // }
  }

  Future<void> _uploadImageToStorage() async {
    if (_pickedImage != null) {
      final storageRef = FirebaseStorage.instance.ref().child(
          'PortfolioWebsite/Images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(_pickedImage!);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _profileImage = downloadUrl;
        _profileImageController.text = downloadUrl;
      });
      // Store image path in Realtime Database
      await databaseRef
          .child('personalAppDatabase/portfolio_web_data/Biodata')
          .update({
        'profile_image': downloadUrl,
      });
    }
  }

  void _loadWorkExperiences() {
    final databaseRef = FirebaseDatabase.instance
        .ref('personalAppDatabase/portfolio_web_data/work_experiences');

    // Using onValue instead of once
    databaseRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as List<dynamic>;
      final experiences = data
          .where((element) => element != null)
          .map((item) => item as Map<String, dynamic>)
          .toList();

      setState(() {
        _workExperiences = experiences;
      });
    });
  }

  //todo

  void _loadEducation() async {
    final databaseRef = FirebaseDatabase.instance
        .ref('personalAppDatabase/portfolio_web_data/educations');
    final snapshot = await databaseRef.get();

    if (snapshot.exists) {
      // The data is a list, not a map
      final data = snapshot.value as List<dynamic>;

      // Convert the list to a list of EducationModels
      educationList = data
          .map((e) {
            // Ensure e is a map
            if (e is Map<dynamic, dynamic>) {
              return EducationModel(
                course: e['course'],
                schoolName: e['school_name'],
                studyLevel: e['study_level'],
                startYear: e['start_year'],
                endYear: e['end_year'],
              );
            } else {
              // Do nothing if e is not a map
              return null;
            }
          })
          .where((element) => element != null)
          .toList()
          .cast<EducationModel>(); // Cast the list to the non-nullable type

      setState(() {});
    }
  }

  void _loadSkills() {
    final databaseRef = FirebaseDatabase.instance
        .ref('personalAppDatabase/portfolio_web_data/skills');

    // Using onValue instead of once
    databaseRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as List<dynamic>;
      final skills = data
          .where((element) => element != null)
          .map((item) => item as String)
          .toList();

      setState(() {
        _skills = skills;
      });
    });
  }

  void _loadSocialLinks() {
    final databaseRef = FirebaseDatabase.instance
        .ref('personalAppDatabase/portfolio_web_data/social_links');

    // Using onValue instead of once
    databaseRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;

      setState(() {
        _socialLinks = data.cast<String, String>();
      });
    });
  }

  void _loadInfoData() {
    final databaseRef =
        FirebaseDatabase.instance.ref('personalAppDatabase/portfolio_web_data');

    // Using onValue instead of once
    databaseRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;

      setState(() {
        _name = data['Biodata']['name'] ?? '';
        _phoneNumber = data['Biodata']['phone_number'] ?? '';
        _email = data['Biodata']['email'] ?? '';
        _aboutMeText = data['Biodata']['about_me'] ?? '';
        _profileImage = data['Biodata']['profile_image'] ?? '';

        _nameController.text = _name;
        _phoneNumberController.text = _phoneNumber;
        _emailController.text = _email;
        _aboutMeController.text = _aboutMeText;
        _profileImageController.text = _profileImage;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _aboutMeController.dispose();
    _profileImageController.dispose();
    _workExperienceStartDateController.dispose();
    _workExperienceEndDateController.dispose();
    _workExperiencePositionController.dispose();
    _workExperienceCompanyNameController.dispose();
    _educationStartYearController.dispose();
    _educationEndYearController.dispose();
    _educationSchoolNameController.dispose();
    _educationStudyLevelController.dispose();
    _educationCourseMajorController.dispose();
    _skillsController.dispose();
    _socialLinkNameController.dispose();
    _socialLinkUrlController.dispose();
    super.dispose();
  }

  // Function to handle updating the biodata
  void _updateBiodata() {
    if (_formKey.currentState!.validate()) {
      final databaseRef = FirebaseDatabase.instance
          .ref('personalAppDatabase/portfolio_web_data/Biodata');
      databaseRef.update({
        'name': _nameController.text,
        'phone_number': _phoneNumberController.text,
        'email': _emailController.text,
        'about_me': _aboutMeController.text,
        'profile_image': _profileImageController.text,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biodata updated successfully!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update biodata: $error')),
        );
      });
    }
  }

  // Function to add new work experience
  void _addWorkExperience() {
    if (_workExperienceFormKey.currentState!.validate()) {
      setState(() {
        _workExperiences.add({
          "startDate": DateTime.parse(_workExperienceStartDateController.text),
          "endDate": DateTime.parse(_workExperienceEndDateController.text),
          "position": _workExperiencePositionController.text,
          "companyName": _workExperienceCompanyNameController.text
        });
        // Clear controllers after adding
        _workExperienceStartDateController.clear();
        _workExperienceEndDateController.clear();
        _workExperiencePositionController.clear();
        _workExperienceCompanyNameController.clear();
      });
    }
  }

  // Function to delete work experience
  void _deleteWorkExperience(int index) {
    setState(() {
      _workExperiences.removeAt(index);
    });
  }

  // Function to add new education
  void _addEducation() {
    if (_educationFormKey.currentState!.validate()) {
      // setState(() {
      //   educationList.add({
      //     "startYear": int.parse(_educationStartYearController.text),
      //     "endYear": int.parse(_educationEndYearController.text),
      //     "schoolName": _educationSchoolNameController.text,
      //     "studyLevel": _educationStudyLevelController.text,
      //     "courseMajor": _educationCourseMajorController.text
      //   });
      //   // Clear controllers after adding
      //   _educationStartYearController.clear();
      //   _educationEndYearController.clear();
      //   _educationSchoolNameController.clear();
      //   _educationStudyLevelController.clear();
      //   _educationCourseMajorController.clear();
      // });
    }
  }

  // Function to delete education
  void _deleteEducation(int index) {
    setState(() {
      educationList.removeAt(index);
    });
  }

  // Function to add new skill
  void _addSkill() {
    if (_skillsFormKey.currentState!.validate()) {
      setState(() {
        _skills.add(_skillsController.text);
        _skillsController.clear();
      });
    }
  }

  // Function to delete skill
  void _deleteSkill(int index) {
    setState(() {
      _skills.removeAt(index);
    });
  }

  // Function to add new social link
  void _addSocialLink() {
    if (_socialLinksFormKey.currentState!.validate()) {
      setState(() {
        _socialLinks[_socialLinkNameController.text] =
            _socialLinkUrlController.text;
        _socialLinkNameController.clear();
        _socialLinkUrlController.clear();
      });
    }
  }

  // Function to delete social link
  void _deleteSocialLink(String key) {
    setState(() {
      _socialLinks.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Portfolio",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 116, 134, 198),
      ),
      backgroundColor: const Color(0xFF414C82),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Biodata Section
              const Text(
                "Biodata",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 116, 134, 198)),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _selectImage,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: _pickedImage != null
                                  ? FileImage(_pickedImage!)
                                  : (_profileImage.isNotEmpty
                                      ? NetworkImage(_profileImage)
                                          as ImageProvider
                                      : AssetImage(
                                          "lib/assets/images/personalportfolio.png")),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white),
                                  labelText: "Name",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your name";
                                  }
                                  return null;
                                },
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _phoneNumberController,
                                decoration: const InputDecoration(
                                  labelText: "Phone Number",
                                  labelStyle: TextStyle(color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your phone number";
                                  }
                                  return null;
                                },
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                  labelStyle: TextStyle(color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your email";
                                  }
                                  if (!value.contains('@')) {
                                    return "Please enter a valid email";
                                  }
                                  return null;
                                },
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _aboutMeController,
                      decoration: const InputDecoration(
                        labelText: "About Me",
                        hintText: "Write a short bio about yourself",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      maxLines: 5,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _profileImageController,
                      decoration: const InputDecoration(
                        labelText: "Profile Image Path",
                        // hintText: "Enter the path to your profile image",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      readOnly: true,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _updateBiodata,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                      ),
                      child: const Text(
                        "Update Biodata",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Work Experience Section
              const Text(
                "Work Experience",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 116, 134, 198)),
              ),
              const SizedBox(height: 16),
              // Add Work Experience Form
              Form(
                key: _workExperienceFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _workExperienceStartDateController,
                      decoration: const InputDecoration(
                        labelText: "Start Date (YYYY-MM-DD)",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter start date";
                        }
                        if (!value.contains('-')) {
                          return "Please enter date in YYYY-MM-DD format";
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _workExperienceEndDateController,
                      decoration: const InputDecoration(
                        labelText: "End Date (YYYY-MM-DD)",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter end date";
                        }
                        if (!value.contains('-')) {
                          return "Please enter date in YYYY-MM-DD format";
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _workExperiencePositionController,
                      decoration: const InputDecoration(
                        labelText: "Position",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter position";
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _workExperienceCompanyNameController,
                      decoration: const InputDecoration(
                        labelText: "Company Name",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter company name";
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addWorkExperience,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                      ),
                      child: const Text(
                        "Add Work Experience",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              // List of Work Experiences
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _workExperiences.length,
                itemBuilder: (context, index) {
                  final experience = _workExperiences[index];
                  return ListTile(
                    tileColor: Colors.white,
                    title: Text(
                      "${experience["position"]} at ${experience["companyName"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "Start Date: ${experience["startDate"].toString().substring(0, 10)} - End Date: ${experience["endDate"].toString().substring(0, 10)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteWorkExperience(index),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Education Section
              const Text(
                "Education",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 116, 134, 198)),
              ),
              const SizedBox(height: 16),
              // Add Education Form
              Form(
                key: _educationFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _educationStartYearController,
                      decoration: InputDecoration(
                        labelText: "Start Year",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter start year";
                        }
                        if (int.tryParse(value) == null) {
                          return "Please enter a valid year";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _educationEndYearController,
                      decoration: InputDecoration(
                        labelText: "End Year",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter end year";
                        }
                        if (int.tryParse(value) == null) {
                          return "Please enter a valid year";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _educationSchoolNameController,
                      decoration: InputDecoration(
                        labelText: "School Name",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter school name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _educationStudyLevelController,
                      decoration: InputDecoration(
                        labelText: "Study Level",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter study level";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _educationCourseMajorController,
                      decoration: InputDecoration(
                        labelText: "Course Major",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter course major";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addEducation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                      ),
                      child: const Text(
                        "Add Education",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // List of Education
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: educationList.length,
                itemBuilder: (context, index) {
                  final education = educationList[index];
                  print(education.toString() + "im here hehe");
                  return ListTile(
                    tileColor: Colors.white,
                    title: Text(
                      "${education.studyLevel} in ${education.course} at ${education.schoolName}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "Start Year: ${education.startYear} - End Year: ${education.endYear}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteEducation(index),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Skills Section
              const Text(
                "Skills",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 116, 134, 198)),
              ),
              const SizedBox(height: 16),
              // Add Skills Form
              Form(
                key: _skillsFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _skillsController,
                      decoration: InputDecoration(
                        labelText: "Skill",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a skill";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addSkill,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                      ),
                      child: const Text(
                        "Add Skill",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              // List of Skills
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _skills.asMap().entries.map((entry) {
                  final index = entry.key;
                  final skill = entry.value;
                  return Chip(
                    label: Text(skill),
                    backgroundColor: Colors.white,
                    labelStyle: const TextStyle(color: Colors.black),
                    onDeleted: () => _deleteSkill(index),
                    deleteIcon: const Icon(Icons.close, color: Colors.black),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Social Links Section
              const Text(
                "Social Links",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 116, 134, 198)),
              ),
              const SizedBox(height: 16),
              // Add Social Links Form
              Form(
                key: _socialLinksFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _socialLinkNameController,
                      decoration: InputDecoration(
                        labelText: "Social Link Name",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a social link name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _socialLinkUrlController,
                      decoration: InputDecoration(
                        labelText: "Social Link URL",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a social link URL";
                        }
                        if (!value.startsWith('http')) {
                          return "Please enter a valid URL";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addSocialLink,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                      ),
                      child: const Text(
                        "Add Social Link",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              // List of Social Links
              Column(
                children: _socialLinks.entries.map((entry) {
                  return ListTile(
                    tileColor: Colors.white,
                    leading: const Icon(Icons.link, color: Colors.black),
                    title:
                        Text(entry.key, style: const TextStyle(fontSize: 16)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.open_in_new,
                              color: Colors.black),
                          onPressed: () {
                            launchUrl(Uri.parse(entry.value));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black),
                          onPressed: () => _deleteSocialLink(entry.key),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
