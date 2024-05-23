import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  // Sample project data
  List<Map<String, dynamic>> projects = [
    {
      'title': 'Project Alpha',
      'status': 'In Progress',
      'priority': 'High',
      'timeline': DateTime(2023, 12, 31), // Store as DateTime
      'teamMembers': 3,
    },
    {
      'title': 'Project Beta',
      'status': 'Completed',
      'priority': 'Medium',
      'timeline': DateTime(2023, 9, 15), // Store as DateTime
      'teamMembers': 2,
    },
    {
      'title': 'Project Gamma',
      'status': 'Pending',
      'priority': 'Low',
      'timeline': DateTime(2024, 3, 10), // Store as DateTime
      'teamMembers': 1,
    },
    {
      'title': 'Project Gamma',
      'status': 'Pending',
      'priority': 'Low',
      'timeline': DateTime(2024, 3, 10), // Store as DateTime
      'teamMembers': 1,
    },
    {
      'title': 'Project Gamma',
      'status': 'Pending',
      'priority': 'Low',
      'timeline': DateTime(2024, 3, 10), // Store as DateTime
      'teamMembers': 1,
    },
    {
      'title': 'Project Gamma',
      'status': 'Pending',
      'priority': 'Low',
      'timeline': DateTime(2024, 3, 10), // Store as DateTime
      'teamMembers': 1,
    },
    {
      'title': 'Project Gamma',
      'status': 'Pending',
      'priority': 'Low',
      'timeline': DateTime(2024, 3, 10), // Store as DateTime
      'teamMembers': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return ProjectCard(
          title: project['title'],
          status: project['status'],
          priority: project['priority'],
          timeline: project['timeline'],
          teamMembers: project['teamMembers'],
        );
      },
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String status;
  final String priority;
  final DateTime timeline; // Use DateTime for timeline
  final int teamMembers;

  const ProjectCard({
    Key? key,
    required this.title,
    required this.status,
    required this.priority,
    required this.timeline,
    required this.teamMembers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    // Handle dropdown selection (e.g., show dialog, navigate)
                    print('Selected: $value');
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'Edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'Delete',
                      child: Text('Delete'),
                    ),
                  ],
                  child: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ProjectDetail(label: 'Status', value: status),
                _ProjectDetail(label: 'Priority', value: priority),
                _ProjectDetail(
                    label: 'Timeline',
                    value: DateFormat('dd-MM').format(timeline)), // Format date
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 8),
                    Text('$teamMembers Team Members'),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to project details screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProjectDetailsPage(),
                      ),
                    );
                  },
                  child: const Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectDetail extends StatelessWidget {
  final String label;
  final String value;

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
        Text(value),
      ],
    );
  }
}

// Placeholder for Project Details Page
class ProjectDetailsPage extends StatelessWidget {
  const ProjectDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
      ),
      body: const Center(
        child: Text('Project Details Page'),
      ),
    );
  }
}
