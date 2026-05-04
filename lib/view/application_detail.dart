import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/viewmodel.dart';
import '../model/models.dart';

class ApplicationDetailScreen extends StatelessWidget {
  final ApplicationModel application;

  const ApplicationDetailScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ApplicationViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details'),
        actions: [
          if (application.status == 'Pending')
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Application'),
                    content: const Text('Are you sure you want to delete this application?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                      ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                    ],
                  ),
                );

                if (confirm == true) {
                  await viewModel.deleteApplication(application.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Application deleted')),
                  );
                  Navigator.pop(context);
                }
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Year of Study: ${application.yearOfStudy}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Module 1: ${application.module1} (${application.module1Level})'),
            if (application.module2 != null)
              Text('Module 2: ${application.module2} (${application.module2Level ?? ''})'),
            const SizedBox(height: 8),
            Text('Eligible: ${application.isEligible ? "Yes" : "No"}'),
            const SizedBox(height: 8),
            Text('Status: ${application.status}'),
            const SizedBox(height: 8),
            Text('Document: ${application.documentUrl}'),
            const SizedBox(height: 8),
            Text('Submitted: ${application.createdAt.toLocal()}'),
            const SizedBox(height: 20),

            if (application.status == 'Pending')
              ElevatedButton(
                onPressed: () {
                  // Navigate to ApplicationFormScreen with existing data for editing
                  Navigator.pushNamed(
                    context,
                    '/applicationForm',
                    arguments: application,
                  );
                },
                child: const Text('Edit Application'),
              ),
          ],
        ),
      ),
    );
  }
}
