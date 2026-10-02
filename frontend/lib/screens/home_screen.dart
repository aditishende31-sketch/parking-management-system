import 'package:flutter/material.dart';
import 'slots_screen.dart';
import 'my_bookings_screen.dart';
import 'vehicle_screen.dart';
import 'ev_screen.dart';
import 'charging_history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget dashboardCard(
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {

    return Card(

      elevation: 5,

      child: InkWell(

        onTap: onTap,

        borderRadius: BorderRadius.circular(15),

        child: SizedBox(

          height: 140,

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Icon(
                icon,
                size: 50,
              ),

              const SizedBox(height: 15),

              Text(

                title,

                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("Parking Dashboard"),

        centerTitle: true,

      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: GridView.count(

          crossAxisCount: 2,

          crossAxisSpacing: 20,

          mainAxisSpacing: 20,

          children: [

dashboardCard(

  Icons.directions_car,

  "My Vehicle",

  () {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (context) => const VehicleScreen(),

      ),

    );

  },

),

            dashboardCard(

              Icons.local_parking,

             "Parking Slots",

             () {

                Navigator.push(

                 context,

                 MaterialPageRoute(

                  builder: (context) => const SlotsScreen(),

                 ),

                );

              },

            ),
            dashboardCard(

              Icons.ev_station,

              "EV Charging",

              () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (context) => const EvChargingScreen(),

                  ),

                );

              },

            ),

            dashboardCard(
              Icons.history,
              "Charging History",
              () {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                  builder: (context) =>
                        const ChargingHistoryScreen(),
                  ),
                );

              },
            ),

            dashboardCard(

              Icons.book,

              "My Bookings",

              () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (context) => const MyBookingsScreen(),

                  ),

                );

              },

            ),

          ],

        ),

      ),

    );

  }

}