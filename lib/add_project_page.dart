import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

import 'package:portfoliomanagementapp/resources/app_colors.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({Key? key}) : super(key: key);

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final databaseRef =
      FirebaseDatabase.instance.ref('personalAppDatabase/projects');
  final storageRef = firebase_storage.FirebaseStorage.instance.ref();

  // Controllers for text fields
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _coreController = TextEditingController();
  final _projectTypeController = TextEditingController();
  final _statusController = TextEditingController();
  final _priorityController = TextEditingController();
  final _teamMemberController = TextEditingController();
  final _timelineStartController = TextEditingController();
  final _timelineEndController = TextEditingController();
  final _displayedImageController = TextEditingController();
  final _repositoryLinkController = TextEditingController();
  final _youtubeLinkController = TextEditingController();

  // List to store project images
  final List<XFile> _images = [];

  // Function to add a new image to the list
  void _addImage(XFile image) {
    setState(() {
      _images.add(image);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _coreController.dispose();
    _projectTypeController.dispose();
    _statusController.dispose();
    _priorityController.dispose();
    _teamMemberController.dispose();
    _timelineStartController.dispose();
    _timelineEndController.dispose();
    _displayedImageController.dispose();
    _repositoryLinkController.dispose();
    _youtubeLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              const Text('Add Project', style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.bottomNavi,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Image Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Use image_picker to select multiple images
                      try {
                        List<XFile>? pickedImages =
                            await ImagePicker().pickMultiImage();

                        // Add selected images to the list
                        pickedImages.forEach(_addImage);
                      } catch (e) {
                        if (kDebugMode) {
                          print('Error picking images: $e');
                        }
                      }
                    },
                    icon: const Icon(Icons.add_a_photo, size: 24.0),
                    label: const Text('Add Image',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: 'Enter project name',
                  hintStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.lightBlue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a project name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: 'Enter project description',
                  hintStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.lightBlue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a project description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Core Technology
              TextFormField(
                controller: _coreController,
                decoration: InputDecoration(
                  labelText: 'Core Technology',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: 'Enter core technology',
                  hintStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.lightBlue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter core technology';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Project Type
              TextFormField(
                controller: _projectTypeController,
                decoration: InputDecoration(
                  labelText: 'Project Type',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: 'Enter project type',
                  hintStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.lightBlue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter project type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Status
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(
                  labelText: 'Status',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: 'Enter status',
                  hintStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.lightBlue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Priority
              TextFormField(
                controller: _priorityController,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: 'Enter priority',
                  hintStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.lightBlue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter priority';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Team Member
              TextFormField(
                controller: _teamMemberController,
                decoration: InputDecoration(
                  labelText: 'Team Member',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: 'Enter team member count',
                  hintStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.lightBlue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter team member count';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Timeline Start
              TextFormField(
                controller: _timelineStartController,
                decoration: InputDecoration(
                  labelText: 'Timeline Start',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: 'Enter timeline start',
                  hintStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.lightBlue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter timeline start';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Timeline End
              TextFormField(
                controller: _timelineEndController,
                decoration: InputDecoration(
                  labelText: 'Timeline End',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: 'Enter timeline end',
                  hintStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.lightBlue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter timeline end';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Displayed Image
              TextFormField(
                controller: _displayedImageController,
                decoration: InputDecoration(
                  labelText: 'Displayed Image URL',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: 'Enter displayed image URL',
                  hintStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.lightBlue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter displayed image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Repository Link
              TextFormField(
                controller: _repositoryLinkController,
                decoration: InputDecoration(
                  labelText: 'Repository Link',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: 'Enter repository link',
                  hintStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.lightBlue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter repository link';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // YouTube Link
              TextFormField(
                controller: _youtubeLinkController,
                decoration: InputDecoration(
                  labelText: 'YouTube Link',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: 'Enter youtube link',
                  hintStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.lightBlue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter youtube link';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // List of added images (for visualization - you can customize this)
              if (_images.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Center(
                        child: Text('Added Images:',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Wrap(
                          spacing: 8,
                          children: _images
                              .map((image) => Image.file(
                                    File(image
                                        .path), // Use File(image.path) to display the image
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),
              // Submit Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Save project data to Firebase
                          _saveProject();
                        }
                      },
                      child: const Text('Submit',
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProject() async {
    // Create a new project object with data from the form
    final newProject = {
      'name': _nameController.text,
      'description': _descriptionController.text,
      'core': _coreController.text,
      'project_type': _projectTypeController.text,
      'status': _statusController.text,
      'priority': _priorityController.text,
      'team_member': int.parse(_teamMemberController.text), // Parse to integer
      'timeline': {
        'start': _timelineStartController.text,
        'end': _timelineEndController.text,
      },
      'displayed_image': _displayedImageController.text,
      'repository_link': _repositoryLinkController.text,
      'youtube_link': _youtubeLinkController.text,
      'images': {}, // Initialize the 'images' field as an empty map
    };

    // Get a unique key for the project
    final projectKey = databaseRef.push().key;

    // Upload each image to Firebase Storage and get the download URL
    for (int i = 0; i < _images.length; i++) {
      final imageFile = _images[i];
      final storageImageRef = storageRef.child(
          'Project/images/$projectKey/image${i + 1}'); // Create storage path

      try {
        final uploadTask = await storageImageRef.putFile(File(imageFile.path));
        final downloadUrl = await uploadTask.ref.getDownloadURL();

        // Add the download URL to the 'images' field in the project data
        if (newProject['images'] != null) {
          (newProject['images'] as Map<dynamic, dynamic>)[i.toString()] =
              downloadUrl;
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error uploading image: $e');
        }
        // Handle image upload errors appropriately
      }
    }

    try {
      // Update the project data in the Realtime Database with image links
      await databaseRef.child(projectKey!).set(newProject);

      // Success message (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project added successfully!')),
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving project: $e');
      }
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving project.')),
      );
    }
  }
}
