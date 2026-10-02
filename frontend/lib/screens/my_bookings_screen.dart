import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {

  late Future<List<Map<String, dynamic>>> bookingsFuture;

  @override
  void initState() {
    super.initState();
    bookingsFuture = ApiService.getBookings();
  }

  Future<void> refreshBookings() async {
    setState(() {
      bookingsFuture = ApiService.getBookings();
    });

    await bookingsFuture;
  }

  Future<void> cancelBooking(int bookingId) async {
  try {
    await ApiService.cancelBooking(bookingId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Booking cancelled successfully"),
      ),
    );

    await refreshBookings();

  } catch (e) {

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("My Bookings"),
        centerTitle: true,
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(

        future: bookingsFuture,

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );

          }

          if (snapshot.hasError) {

            return Center(
              child: Text(snapshot.error.toString()),
            );

          }

          final bookings = snapshot.data!;

          if (bookings.isEmpty) {

            return const Center(
              child: Text("No bookings found."),
            );

          }

          return RefreshIndicator(

            onRefresh: refreshBookings,

            child: ListView.builder(

              itemCount: bookings.length,

              itemBuilder: (context, index) {

                final booking = bookings[index];

                return Card(

                  margin: const EdgeInsets.all(10),

                  elevation: 5,

                  child: Padding(

                    padding: const EdgeInsets.all(15),

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Row(

                          children: [

                            const Icon(Icons.local_parking),

                            const SizedBox(width: 10),

                            Text(

                              "Slot : ${booking["slot_no"]}",

                              style: const TextStyle(

                                fontSize: 18,

                                fontWeight: FontWeight.bold,

                              ),

                            ),

                          ],

                        ),

                        const SizedBox(height: 10),

                        Row(

                          children: [

                            const Icon(Icons.directions_car),

                            const SizedBox(width: 10),

                            Text(

                              booking["vehicle_number"],

                            ),

                          ],

                        ),

                        const SizedBox(height: 10),

                        Row(

                          children: [

                            const Icon(Icons.access_time),

                            const SizedBox(width: 10),

                            Expanded(

                              child: Text(

                                booking["booking_time"],

                              ),

                            ),

                          ],

                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Cancel Booking"),
                                  content: const Text(
                                    "Are you sure you want to cancel this booking?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: const Text("No"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text("Yes"),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await cancelBooking(
                                  booking["booking_id"],
                                );
                              }
                            },
                            child: const Text("Cancel Booking"),
                          ),
                        ),

                      ],

                    ),

                  ),

                );

              },

            ),

          );

        },

      ),

    );

  }

}