import 'package:flutter/material.dart';
import 'package:flutter_application_14/models/booking.dart';
import 'package:flutter_application_14/services/booking_service.dart';

class SeatBooking extends StatefulWidget {
  const SeatBooking({super.key});

  @override
  State<SeatBooking> createState() => _SeatBookingState();
}

class _SeatBookingState extends State<SeatBooking> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  List<bool> bookedSeats = List.generate(48, (index) => false);
  int selectedSeat = -1;

  @override
  void initState() {
    super.initState();
    _loadBookedSeats();
  }

  Future<void> _loadBookedSeats() async {
    final List<int> seats =
        await BookingService.instance.getBookedSeatNumbers();

    if (!mounted) return;

    setState(() {
      for (final int seat in seats) {
        if (seat >= 1 && seat <= bookedSeats.length) {
          bookedSeats[seat - 1] = true;
        }
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void selectSeat(int index) {
    if (bookedSeats[index]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Seat already booked"),
        ),
      );
      return;
    }

    setState(() {
      selectedSeat = index + 1;
    });
  }

  Future<void> confirmBooking() async {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        selectedSeat == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter name, phone and select a seat"),
        ),
      );
      return;
    }

    final int seatNumber = selectedSeat;

    final Booking? booking = await BookingService.instance.createBooking(
      passengerName: nameController.text.trim(),
      phone: phoneController.text.trim(),
      seatNumber: seatNumber,
    );

    if (!mounted) return;

    if (booking == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not save your booking. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      bookedSeats[seatNumber - 1] = true;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Booking Confirmed"),
        content: Text(
          "Passenger: ${nameController.text}\n"
          "Phone: ${phoneController.text}\n"
          "Seat: $seatNumber",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              setState(() {
                selectedSeat = -1;
                nameController.clear();
                phoneController.clear();
              });
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget buildSeat(int index) {
    Color color;

    if (bookedSeats[index]) {
      color = Colors.red;
    } else if (selectedSeat == index + 1) {
      color = Colors.green;
    } else {
      color = Colors.grey.shade300;
    }

    return GestureDetector(
      onTap: () => selectSeat(index),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "${index + 1}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: bookedSeats[index] || selectedSeat == index + 1
                  ? Colors.white
                  : Colors.black,
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
        title: const Text("Seat Booking"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Driver",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Passenger Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Select Your Seat",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: GridView.builder(
                itemCount: 48,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return buildSeat(index);
                },
              ),
            ),

            Text(
              selectedSeat == -1
                  ? "No Seat Selected"
                  : "Selected Seat: $selectedSeat",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Confirm Booking",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}