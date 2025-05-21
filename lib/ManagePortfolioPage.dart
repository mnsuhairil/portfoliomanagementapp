import 'dart:io';
import 'package:flutter/material.dart';
import 'package:portfoliomanagementapp/model/education_model.dart';
import 'package:portfoliomanagementapp/model/work_experience_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ManagePortfolioPage extends StatefulWidget {
  const ManagePortfolioPage({super.key});

  @override
  State<ManagePortfolioPage> createState() => _ManagePortfolioPageState();
}

class _ManagePortfolioPageState extends State<ManagePortfolioPage> {
  Map<String, String> _skillKeys = {};
  // Data for Biodata Section
  String _name = "";
  String _phoneNumber = "";
  String _email = "";
  String _aboutMeText = ".";
  String _profileImage = "";
  String _homeAddress = "";
  File? _pickedImage;

  final databaseRef = FirebaseDatabase.instance.ref();

  // Data for Work Experience Section
  List<WorkExperienceModel> workExperienceList = [];

  // Data for Education Section
  List<EducationModel> educationList = [];

  // Data for Skills Section
  List<String> _skills = [];

  // Data for Social Links Section
  final Map<String, String> _socialLinks = {};

  // TextEditingController for each field
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _aboutMeController = TextEditingController();
  final _profileImageController = TextEditingController();
  final _homeAddressController = TextEditingController();

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
    _loadWorkExperiences();
    _loadEducations();
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

  void _loadSkills() {
    final databaseRef = FirebaseDatabase.instance
        .ref('personalAppDatabase/portfolio_web_data/skills');

    databaseRef.onValue.listen((DatabaseEvent event) {
      try {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        // Get the skills and keys
        final skills = data.values.map((item) => item as String).toList();
        final keys = data.keys.map((item) => item as String).toList();

        setState(() {
          // Update the lists and the key map
          _skills = skills;
          _skillKeys = Map.fromIterables(keys, skills);
        });
      } catch (error) {
        // Handle the error appropriately (show an error message, retry, etc.)
      }
    });
  }

  void _deleteSkill(int index) {
    final skillToDelete = _skills[index];

    // Directly find the key using firstWhere
    final keyToDelete =
        _skillKeys.keys.firstWhere((key) => _skillKeys[key] == skillToDelete);

    // Delete the skill from the Firebase Database using the key
    final databaseRef = FirebaseDatabase.instance
        .ref('personalAppDatabase/portfolio_web_data/skills/$keyToDelete');
    databaseRef.remove().then((_) {
      setState(() {
        _skills.removeAt(index);
        _skillKeys.remove(skillToDelete);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Skill added successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing skill: $error')),
      );
      // Handle the error appropriately (e.g., show an error message to the user)
    });
  }

  void _loadSocialLinks() {
    final databaseRef = FirebaseDatabase.instance
        .ref('personalAppDatabase/portfolio_web_data/social_links');
    databaseRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        // Check if the snapshot exists
        final data = event.snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          _socialLinks.clear(); // Clear the existing social links

          data.forEach((key, value) {
            // Ensure both key and value are Strings
            if (value is String) {
              // Check if value is a String
              _socialLinks[key] = value;
            }
          });
        });
      }
    });
  }

  void _loadInfoData() {
    final databaseRef =
        FirebaseDatabase.instance.ref('personalAppDatabase/portfolio_web_data');

    // Using onValue instead of once
    databaseRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          _name = data['Biodata']['name'] ?? '';
          _phoneNumber = data['Biodata']['phone_number'] ?? '';
          _email = data['Biodata']['email'] ?? '';
          _aboutMeText = data['Biodata']['about_me'] ?? '';
          _profileImage = data['Biodata']['profile_image'] ?? '';
          _homeAddress = data['Biodata']['home_address'] ?? '';
          // Update the controllers with the loaded data
          _homeAddressController.text = _homeAddress;
          _nameController.text = _name;
          _phoneNumberController.text = _phoneNumber;
          _emailController.text = _email;
          _aboutMeController.text = _aboutMeText;
          _profileImageController.text = _profileImage;
        });
      }
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
    _homeAddressController.dispose();
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
        'home_address': _homeAddressController.text,
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

// Function to load work experiences
  Future<bool> _loadWorkExperiences() async {
    final databaseRef = FirebaseDatabase.instance
        .ref('personalAppDatabase/portfolio_web_data/work_experiences');

    final snapshot = await databaseRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      workExperienceList = data.entries.map((entry) {
        final experienceData = entry.value as Map<dynamic, dynamic>;

        // Add the key to the WorkExperienceModel object
        return WorkExperienceModel(
          position: experienceData['position'],
          companyName: experienceData['company_name'],
          startDate: experienceData['start_date'],
          endDate: experienceData['end_date'],
          key: entry.key.toString(), // Get the key from entry.key
        );
      }).toList();

      setState(() {});
      return true; // Indicate successful loading
    }
    return false; // Indicate unsuccessful loading
  }

  // Function to add new work experience
  void _addWorkExperience() async {
    if (_workExperienceFormKey.currentState!.validate()) {
      final newWorkExperience = WorkExperienceModel(
        position: _workExperiencePositionController.text,
        companyName: _workExperienceCompanyNameController.text,
        startDate: _workExperienceStartDateController.text,
        endDate: _workExperienceEndDateController.text,
      );

      final databaseRef = FirebaseDatabase.instance
          .ref('personalAppDatabase/portfolio_web_data/work_experiences');

      try {
        await databaseRef.push().set(newWorkExperience.toJson());

        // Clear the form fields
        _workExperiencePositionController.clear();
        _workExperienceCompanyNameController.clear();
        _workExperienceStartDateController.clear();
        _workExperienceEndDateController.clear();

        // Reload the work experiences
        final success = await _loadWorkExperiences();
        if (success) {
          // Show a success message (optional)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Work experience added successfully')),
          );
        }
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding work experience: $e')),
        );
      }
    }
  }

  // Function to delete work experience
  void _deleteWorkExperience(int index) {
    final databaseRef = FirebaseDatabase.instance
        .ref('personalAppDatabase/portfolio_web_data/work_experiences');
    final key = workExperienceList[index].key;
// Remove from the local list
    setState(() {
      workExperienceList.removeAt(index);
    });
    // Delete from Firebase
    databaseRef.child(key!).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Work experience deleted successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting work experience: $error')),
      );
    });
  }

  Future<bool> _loadEducations() async {
    final databaseRef = FirebaseDatabase.instance
        .ref('personalAppDatabase/portfolio_web_data/educations');

    final snapshot = await databaseRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      educationList = data.entries.map((entry) {
        final educationData = entry.value as Map<dynamic, dynamic>;

        return EducationModel(
          schoolName: educationData['school_name'],
          studyLevel: educationData['study_level'],
          course: educationData['course'],
          startYear: educationData['start_year'],
          endYear: educationData['end_year'],
          key: entry.key.toString(), // Get the key from entry.key
        );
      }).toList();

      setState(() {});
      return true; // Indicate successful loading
    }
    return false; // Indicate unsuccessful loading
  }

  // Function to add new education
  void _addEducation() async {
    if (_educationFormKey.currentState!.validate()) {
      final newEducation = EducationModel(
        schoolName: _educationSchoolNameController.text,
        studyLevel: _educationStudyLevelController.text,
        course: _educationCourseMajorController.text,
        startYear: _educationStartYearController.text,
        endYear: _educationEndYearController.text,
      );

      final databaseRef = FirebaseDatabase.instance
          .ref('personalAppDatabase/portfolio_web_data/educations');

      try {
        await databaseRef.push().set(newEducation.toJson());

        // Clear the form fields
        _educationSchoolNameController.clear();
        _educationStudyLevelController.clear();
        _educationCourseMajorController.clear();
        _educationStartYearController.clear();
        _educationEndYearController.clear();
        // Reload the work experiences
        final success = await _loadEducations();
        if (success) {
          // Show a success message (optional)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Education added successfully')),
          );
        }
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding education: $e')),
        );
      }
    }
  }

  // Function to delete work experience
  void _deleteEducation(int index) {
    final databaseRef = FirebaseDatabase.instance
        .ref('personalAppDatabase/portfolio_web_data/educations');
    final key = educationList[index].key;
    setState(() {
      educationList.removeAt(index);
    });
    // Delete from Firebase
    databaseRef.child(key!).remove().then((_) {
      // Remove from the local list

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Education deleted successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Education experience: $error')),
      );
    });
  }

  void _addSkill() {
    if (_skillsFormKey.currentState!.validate()) {
      final newSkill = _skillsController.text.trim();

      // Add the skill to the Firebase Database
      final databaseRef = FirebaseDatabase.instance
          .ref('personalAppDatabase/portfolio_web_data/skills');
      final newKey = databaseRef.push().key; // Get the generated key
      if (newKey != null) {
        databaseRef.child(newKey).set(newSkill);

        setState(() {
          _skills.add(newSkill);
          _skillKeys[newSkill] = newKey; // Store the key for this skill
          _skillsController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Skill added successfully')),
        );
      }
    }
  }

  void _addSocialLink() {
    if (_socialLinksFormKey.currentState!.validate()) {
      final name = _socialLinkNameController.text.trim();
      final url = _socialLinkUrlController.text.trim();

      // Add the new social link to the database
      final databaseRef = FirebaseDatabase.instance
          .ref('personalAppDatabase/portfolio_web_data/social_links');
      databaseRef.update({
        name: url,
      }).then((_) {
        _socialLinkNameController.clear();
        _socialLinkUrlController.clear();
        // Optionally, display a success message or update UI to show new link
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Social link added successfully')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding social link: $error')),
        );
        // Handle the error appropriately (e.g., show an error message to the user)
      });
    }
  }

  // Function to delete social link
  void _deleteSocialLink(String key) {
    final databaseRef = FirebaseDatabase.instance
        .ref('personalAppDatabase/portfolio_web_data/social_links/$key');
    databaseRef.remove().then((_) {
      setState(() {
        _socialLinks.remove(key);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Social link removed successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error remove social link: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Portfolio",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 116, 134, 198),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                                      : const AssetImage(
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
                itemCount: workExperienceList.length,
                itemBuilder: (context, index) {
                  final experience = workExperienceList[index];
                  return ListTile(
                    tileColor: Colors.white,
                    title: Text(
                      "${experience.position} at ${experience.companyName}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "Start Date: ${experience.startDate} - End Date: ${experience.endDate}",
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
