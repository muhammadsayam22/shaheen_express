import 'package:flutter/material.dart';
import 'package:flutter_application_14/models/job_application.dart';
import 'package:flutter_application_14/services/job_application_service.dart';
import 'package:flutter_application_14/theme/app_theme.dart';

class CareersPage extends StatelessWidget {
  const CareersPage({super.key});

  // APPLY DIALOG
  void _showApplyDialog(BuildContext context, String jobTitle) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text("Apply for $jobTitle"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Your Name",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: messageController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Why do you want this job?",
                    prefixIcon: Icon(Icons.message),
                  ),
                ),
              ],
            ),
          ),

          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please fill all required fields"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final JobApplication? application =
                    await JobApplicationService.instance.apply(
                  jobTitle: jobTitle,
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                  message: messageController.text.trim(),
                );

                if (!context.mounted) return;

                if (application == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Could not send your application"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Application sent for $jobTitle ",
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  // JOB CARD
  Widget jobCard(
    BuildContext context,
    String title,
    String location,
    String type,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.work, color: Colors.white),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.grey),
              const SizedBox(width: 5),
              Text(location),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: Colors.grey),
              const SizedBox(width: 5),
              Text(type),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _showApplyDialog(context, title),
              child: const Text(
                "Apply Now",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Careers"),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.gradient(context),
        ),

        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            jobCard(context, "Bus Driver", "Kohat", "Full Time"),
            jobCard(context, "Ticket Manager", "kohat", "Full Time"),
            jobCard(context, "Customer Support", "KOHAT", "Full Time"),
            jobCard(context, "Cleaner", "KOHAT BHAWAL NAGAR CHOK", "Full Time"),
          ],
        ),
      ),
    );
  }
}