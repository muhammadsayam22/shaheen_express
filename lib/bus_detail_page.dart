import 'package:flutter/material.dart';
import 'package:flutter_application_14/models/bus.dart';
import 'package:flutter_application_14/services/ticket_service.dart';
import 'package:flutter_application_14/theme/app_theme.dart';

class BusDetailPage extends StatelessWidget {

  const BusDetailPage({super.key, this.bus});

  final Bus? bus;

  @override
  Widget build(BuildContext context) {

    final Bus detail = bus ??
        const Bus(
          name: "SHAHEEN EXPRESS",
          from: "kohat",
          to: "pindi",
          time: "16 Hours service ",
          price: "Rs. 1000",
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Detail"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tintedSurface(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    detail.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("From: ${detail.from}",
                          style: const TextStyle(fontSize: 16)),
                      Text("To: ${detail.to}",
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text("Time: ${detail.time}",
                      style: const TextStyle(fontSize: 16)),
                  Text("Price: ${detail.price}",
                      style: const TextStyle(fontSize: 16)),

                ],
              ),
            ),

            const SizedBox(height: 20),

            // BUTTONS
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                await TicketService.instance.createTicket(
                  busName: detail.name,
                  origin: detail.from,
                  destination: detail.to,
                  time: detail.time,
                  price: detail.price,
                );

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Ticket Booked Successfully!")),
                );
              },
              child: const Text(
                "Book Now",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Back",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
