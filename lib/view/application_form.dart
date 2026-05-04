import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/viewmodel.dart';
import '../model/models.dart';

class ApplicationFormScreen extends StatefulWidget {
  const ApplicationFormScreen({super.key});

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  int? yearOfStudy;
  String? module1;
  String? module1Level;
  String? module2;
  String? module2Level;
  bool isEligible = false;
  String? documentUrl; // For now, just a text field. Could be file upload later.

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ApplicationViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Student Assistant Application')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Year of Study (int)
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Year of Study'),
                items: [1, 2, 3]
                    .map((year) => DropdownMenuItem(value: year, child: Text('$year')))
                    .toList(),
                onChanged: (val) => yearOfStudy = val,
                validator: (val) => val == null ? 'Select your year of study' : null,
              ),

              const SizedBox(height: 20),

              // Module 1
              Text('Module 1', style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Module Name'),
                onChanged: (val) => module1 = val,
                validator: (val) => val == null || val.isEmpty ? 'Enter module name' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Academic Level'),
                items: ['Level 1', 'Level 2', 'Level 3']
                    .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                    .toList(),
                onChanged: (val) => module1Level = val,
                validator: (val) => val == null ? 'Select academic level' : null,
              ),

              const SizedBox(height: 20),

              // Module 2 (Optional)
              Text('Module 2 (Optional)', style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Module Name'),
                onChanged: (val) => module2 = val,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Academic Level'),
                items: ['Level 1', 'Level 2', 'Level 3']
                    .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                    .toList(),
                onChanged: (val) => module2Level = val,
              ),

              const SizedBox(height: 20),

              // Eligibility
              CheckboxListTile(
                title: const Text('I confirm that I meet the eligibility requirements'),
                value: isEligible,
                onChanged: (val) => setState(() => isEligible = val ?? false),
              ),

              const SizedBox(height: 20),

              // Document URL (placeholder for file upload)
              TextFormField(
                decoration: const InputDecoration(labelText: 'Supporting Document URL'),
                onChanged: (val) => documentUrl = val,
                validator: (val) => val == null || val.isEmpty ? 'Provide document URL' : null,
              ),

              const SizedBox(height: 20),

              // Submit
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (!isEligible) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('You must confirm eligibility')),
                      );
                      return;
                    }

                    final app = ApplicationModel(
                      id: '', // Supabase will generate
                      userId: 'CURRENT_USER_ID', // Replace with actual userId from auth
                      yearOfStudy: yearOfStudy!,
                      module1: module1!,
                      module1Level: module1Level!,
                      module2: module2,
                      module2Level: module2Level,
                      isEligible: isEligible,
                      documentUrl: documentUrl!,
                      status: 'Pending',
                      createdAt: DateTime.now(),
                    );

                    await viewModel.createApplication(app);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Application submitted successfully')),
                    );

                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
