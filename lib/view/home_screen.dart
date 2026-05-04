import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/viewmodel/viewmodel.dart';
import '/model/models.dart';
import '/viewmodel/routes/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<ApplicationViewModel>(context, listen: false);
    // Replace with actual authenticated userId from Supabase
    viewModel.fetchUserApplications('CURRENT_USER_ID');
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ApplicationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Portal'),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.applications.isEmpty
              ? const Center(child: Text('No applications submitted yet'))
              : ListView.builder(
                  itemCount: viewModel.applications.length,
                  itemBuilder: (context, index) {
                    final app = viewModel.applications[index];
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
                            Text('Status: ${app.status}'),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.applicationDetail,
                            arguments: app,
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.applicationForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
