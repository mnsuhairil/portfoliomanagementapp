import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:portfoliomanagementapp/component/full_image.dart';
import 'package:portfoliomanagementapp/model/project_model.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for image carousel

// Project Details Page
class ProjectDetailsPage extends StatelessWidget {
  final ProjectModel project;

  // Project Details Page class ProjectDetailsPage extends StatelessWidget { final ProjectModel project;

  const ProjectDetailsPage({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name,
            style:
                const TextStyle(color: Colors.white)), // Display project name
        backgroundColor:
            const Color.fromARGB(255, 116, 134, 198), // Set app bar color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        // Enable scrolling for long content
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Carousel (Full-width)
              Card(
                elevation: 4,
                margin: EdgeInsets.zero,
                child: ClipRRect(
                  // Add ClipRRect to apply borderRadius
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(
                          12, 158, 158, 158), // Set the background color
                    ),
                    child: CarouselSlider.builder(
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
                            height: 250,
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 250,
                        viewportFraction: 1.0,
                        autoPlay: true,
                        pauseAutoPlayOnManualNavigate: true,
                        pauseAutoPlayOnTouch: true,
                        enableInfiniteScroll: true,
                        enlargeCenterPage: false,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Project Details (Improved layout)
              _ProjectDetailSection(
                title: 'Description',
                content: project.description,
              ),
              const SizedBox(height: 16),
              // Cards for each info in a 2x2 grid
              Row(
                children: [
                  Expanded(
                    child: _ProjectDetailCard(
                      title: 'Core Technology',
                      content: project.core,
                    ),
                  ),
                  Expanded(
                    child: _ProjectDetailCard(
                      title: 'Project Type',
                      content: project.projectType,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _ProjectDetailCard(
                      title: 'Status',
                      content: project.status,
                    ),
                  ),
                  Expanded(
                    child: _ProjectDetailCard(
                      title: 'Priority',
                      content: project.priority,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _ProjectDetailCard(
                      title: 'Team Members',
                      content: project.teamMember.toString(),
                    ),
                  ),
                  Expanded(
                    child: _ProjectDetailCard(
                      title: 'Timeline',
                      content:
                          '${project.timelineStart} - ${project.timelineEnd}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _LinkSection(
                title: 'Repository Link',
                link: project.repositoryLink,
              ),
              const SizedBox(height: 24),
              _LinkSection(
                title: 'YouTube Link',
                link: project.youtubeLink,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectDetailSection extends StatelessWidget {
  final String title;
  final String content;

  const _ProjectDetailSection({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _ProjectDetailCard extends StatelessWidget {
  final String title;
  final String content;

  const _ProjectDetailCard({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color.fromARGB(255, 116, 134, 198), // Set card color
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkSection extends StatelessWidget {
  final String title;
  final String link;

  const _LinkSection({
    Key? key,
    required this.title,
    required this.link,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            if (await canLaunchUrl(Uri.parse(link))) {
              await launchUrl(Uri.parse(link));
            } else {
              // Handle the case where the URL cannot be launched
              if (kDebugMode) {
                print('Could not launch $link');
              }
            }
          },
          child: Text(
            link,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
