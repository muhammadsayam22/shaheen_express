import 'package:flutter/material.dart';
import 'package:flutter_application_14/models/complaint.dart';
import 'package:flutter_application_14/services/complaint_service.dart';
import 'package:url_launcher/url_launcher.dart';
class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  
  void sendToWhatsApp() {
    String name = nameController.text;
    String phone = phoneController.text;
    String message = messageController.text;

    String text =
        " New Complaint\n\n"
        "Name: $name\n"
        "Phone: $phone\n"
        "Message: $message";

    String url =
        "https://wa.me/923369327629?text=${Uri.encodeComponent(text)}";

    Future<void> sendWhatsApp(String url) async {
      final Uri uri = Uri.parse(url);

      try {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to open WhatsApp")),
        );
      }
    }

    sendWhatsApp(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complaint"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Your Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Your Complaint",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.message),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    phoneController.text.isEmpty ||
                    messageController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                final Complaint? complaint =
                    await ComplaintService.instance.saveComplaint(
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                  message: messageController.text.trim(),
                );

                if (!context.mounted) return;

                if (complaint == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Could not save your complaint"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                sendToWhatsApp();
              },
              child: const Text(
                "Send on WhatsApp",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}