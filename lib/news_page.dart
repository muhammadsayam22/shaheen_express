import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shaheen Express News"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          newsCard(
            title: "New Bus Routes Added",
            date: "13 June 2026",
            description:
                "Shaheen Express has introduced new routes for passengers travelling across Pakistan.",
            icon: Icons.directions_bus,
          ),

          newsCard(
            title: "Online Booking Available",
            date: "10 June 2026",
            description:
                "Passengers can now book their tickets online from the comfort of their homes.",
            icon: Icons.book_online,
          ),

          newsCard(
            title: "Special Discount Offer",
            date: "08 June 2026",
            description:
                "Special discounts are available for students and senior citizens.",
            icon: Icons.local_offer,
          ),

          newsCard(
            title: "New Luxury Buses Introduced",
            date: "05 June 2026",
            description:
                "Shaheen Express has added luxury buses with Wi-Fi and comfortable seats.",
            icon: Icons.newspaper,
          ),
        ],
      ),
    );
  }

  Widget newsCard({
    required String title,
    required String date,
    required String description,
    required IconData icon,
  }) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.green,
              size: 40,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  
 
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
