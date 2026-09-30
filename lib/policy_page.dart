import 'package:flutter/material.dart';
import 'package:flutter_application_14/theme/app_theme.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  Widget policyCard(String title, String text) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.green.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Policy"),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),

      body: Container(
        decoration: BoxDecoration(gradient: AppColors.gradient(context)),

        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              policyCard(
                "Travel Rules",
                "Passengers must arrive 30 minutes before departure. Valid ticket is required for travel.",
              ),

              policyCard(
                "Luggage Policy",
                "Each passenger may carry standard luggage. Extra baggage may require additional charges.",
              ),

              policyCard(
                "Refund Policy",
                "Ticket cancellation before departure may qualify for partial refund depending on timing.",
              ),

              policyCard(
                "Safety Policy",
                "Passengers must follow staff instructions. Smoking and dangerous items are not allowed.",
              ),

              policyCard(
                "Seat Policy",
                "Selected seat is reserved after booking confirmation. Seat may change due to operational reasons.",
              ),

              policyCard(
                "Contact Support",
                "For complaints or help, contact Shaheen Express support during office hours.",
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.tintedSurface(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Text(
                  "Shaheen Express aims to provide safe, comfortable and reliable travel for all passengers.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}