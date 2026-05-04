import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/viewmodel.dart';
import '../model/models.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String? filterStatus;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<ApplicationViewModel>(context, listen: false);
    viewModel.fetchAllApplications();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ApplicationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          DropdownButton<String>(
            hint: const Text('Filter by status'),
            value: filterStatus,
            items: ['Pending', 'Approved', 'Rejected']
                .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                .toList(),
            onChanged: (val) {
              setState(() => filterStatus = val);
            },
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: viewModel.applications.length,
              itemBuilder: (context, index) {
                final app = viewModel.applications[index];

                // Apply filter if selected
                if (filterStatus != null && app.status != filterStatus) {
                  return const SizedBox.shrink();
                }

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('${app.module1} (${app.module1Level})'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Year of Study: ${app.yearOfStudy}'),
                        if (app.module2 != null)
                          Text('Module 2: ${app.module2} (${app.module2Level ?? ''})'),
                        Text('Eligible: ${app.isEligible ? "Yes" : "No"}'),
                        Text('Status: ${app.status}'),
                        Text('Submitted: ${app.createdAt.toLocal()}'),
                        Text('Document: ${app.documentUrl}'),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (choice) async {
                        if (choice == 'Approve') {
                          await viewModel.updateStatus(app.id, 'Approved');
                        } else if (choice == 'Reject') {
                          await viewModel.updateStatus(app.id, 'Rejected');
                        } else if (choice == 'Delete') {
                          await viewModel.deleteApplication(app.id);
                        }
                        await viewModel.fetchAllApplications();
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Approve', child: Text('Approve')),
                        const PopupMenuItem(value: 'Reject', child: Text('Reject')),
                        const PopupMenuItem(value: 'Delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
