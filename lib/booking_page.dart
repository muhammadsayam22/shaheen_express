import 'package:flutter/material.dart';
import 'package:flutter_application_14/models/booking.dart';
import 'package:flutter_application_14/services/booking_service.dart';

class BookingPage extends StatelessWidget {

  final nameController = TextEditingController();
  final seatController = TextEditingController();

  BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bus Booking")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Passenger Name",
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: seatController,
              decoration: InputDecoration(
                labelText: "Seat Number",
              ),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              child: Text("Confirm Booking"),
              onPressed: () async {
                final int seatNumber =
                    int.tryParse(seatController.text.trim()) ?? -1;

                if (nameController.text.trim().isEmpty || seatNumber < 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please enter passenger name and seat number",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final Booking? booking =
                    await BookingService.instance.createBooking(
                  passengerName: nameController.text.trim(),
                  phone: '',
                  seatNumber: seatNumber,
                );

                if (!context.mounted) return;

                if (booking == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Could not save booking"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Booking Confirmed"),
                      content: Text(
                        "Name: ${nameController.text}\nSeat: ${seatController.text}",
                      ),
                    );
                  },
                );
              },
            )

          ],
        ),
      ),
    );
  }
}