import 'package:flutter/material.dart';
import 'package:flutter_application_14/theme/app_theme.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  Widget serviceCard(
    BuildContext context,
    IconData icon,
    String title,
    String desc,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.all(14),

        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.green, size: 28),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            desc,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Our Services"),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),

      body: Container(
        decoration: BoxDecoration(gradient: AppColors.gradient(context)),

        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            serviceCard(
              context,
              Icons.directions_bus,
              "Online Booking",
              "Book your bus ticket easily through our app anytime.",
            ),

            serviceCard(
              context,
              Icons.chair,
              "Seat Selection",
              "Choose your favorite seat before confirming ticket.",
            ),

            serviceCard(
              context,
              Icons.support_agent,
              "24/7 Support",
              "Our support team is available for passengers all time.",
            ),

            serviceCard(
              context,
              Icons.location_on,
              "Live Tracking",
              "Track your bus location in real-time.",
            ),

            serviceCard(
              context,
              Icons.discount,
              "Discount Offers",
              "Get special discounts on selected routes.",
            ),

            serviceCard(
              context,
              Icons.security,
              "Safe Travel",
              "We ensure safe and comfortable journey for all passengers.",
            ),
          ],
        ),
      ),
    );
  }
}