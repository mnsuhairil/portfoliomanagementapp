import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:portfoliomanagementapp/component/full_image.dart';
import 'package:portfoliomanagementapp/model/project_model.dart';
import 'package:portfoliomanagementapp/project_detail_page.dart';
// import 'package:portfoliomanagementapp/add_project_page.dart'; // Import AddProjectPage

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  // Create a reference to the Firebase database
  final databaseRef = FirebaseDatabase.instance
      .ref('personalAppDatabase/projects'); // Adjust path as needed
  List<ProjectModel> projects = []; // List to store project data

  @override
  void initState() {
    super.initState();
    _loadProjects(); // Load projects from Firebase on initialization
  }

  Future<void> _loadProjects() async {
    final snapshot = await databaseRef.get();

    if (snapshot.exists) {
      // Cast the snapshot.value to a Map<String, dynamic>
      final data = (snapshot.value as Map).cast<String, dynamic>();

      projects = data.entries.map((entry) {
        // Cast entry.value to Map<String, dynamic>
        final projectData = (entry.value as Map).cast<String, dynamic>();

        // Parse timeline data
        final startTimeString = projectData['timeline']['start'];
        final endTimeString = projectData['timeline']['end'];
        final startDateTime = startTimeString;
        final endDateTime = endTimeString;

        // Get project images
        final images = projectData['images'] != null
            ? (projectData['images'] as List)
                .cast<String>() // Correct type cast
            : [];

        return ProjectModel(
          key: entry.key.toString(),
          name: projectData['name'],
          description: projectData['description'],
          core: projectData['core'],
          projectType: projectData['project_type'],
          status: projectData['status'],
          priority: projectData['priority'],
          teamMember: projectData['team_member'],
          timelineStart: startDateTime,
          timelineEnd: endDateTime,
          displayedImage: projectData['displayed_image'],
          repositoryLink: projectData['repository_link'],
          youtubeLink: projectData['youtube_link'],
          images: images, // Add images to ProjectModel
        );
      }).toList();

      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return ProjectCard(project: project);
        },
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias, // Improve corner clipping
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Carousel (Responsive)
          Container(
            // Wrap the Stack with a Container
            decoration: const BoxDecoration(
                color: Color.fromARGB(
                    12, 158, 158, 158) // Set the background color
                ),
            child: Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: project.images.length,
                  itemBuilder: (context, index, realIndex) {
                    final image = project.images[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImage(
                              imageUrl: image,
                            ),
                          ),
                        );
                      },
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 200,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    pauseAutoPlayOnManualNavigate: true,
                    pauseAutoPlayOnTouch: true,
                    enableInfiniteScroll: true,
                    enlargeCenterPage: false,
                  ),
                ),
                // Project Name Overlay
                Positioned(
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue, // Set a background color
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50.0),
                          bottomRight: Radius.circular(
                              0.0)), // Optional: Add rounded corners
                    ),
                    padding: const EdgeInsets.all(16.0), // Add padding
                    child: Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Project Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status, Priority, Timeline
                Container(
                  // Wrap the row with a Container
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        10), // Optional: Add rounded corners
                  ),
                  padding: const EdgeInsets.all(10), // Add padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ProjectDetail(label: 'Status', value: project.status),
                      _ProjectDetail(
                          label: 'Priority', value: project.priority),
                      _ProjectDetail(
                        label: 'Timeline',
                        value:
                            '${project.timelineStart} - ${project.timelineEnd}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Team Members and Details Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 8),
                        Text('${project.teamMember} Team Members'),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectDetailsPage(
                              project: project,
                            ),
                          ),
                        );
                      },
                      child: const Text('View Details',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectDetail extends StatelessWidget {
  final String label;
  final Object value;

  const _ProjectDetail({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(value.toString()),
      ],
    );
  }
}
