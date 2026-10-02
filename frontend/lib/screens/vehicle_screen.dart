import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'add_vehicle_screen.dart';
import 'edit_screen.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {

  late Future<List<Map<String, dynamic>>> vehiclesFuture;

  @override
  void initState() {
    super.initState();
    vehiclesFuture = ApiService.getVehicles();
  }

  Future<void> deleteVehicle(int vehicleId) async {

  try {

    await ApiService.deleteVehicle(vehicleId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text("Vehicle deleted successfully"),

      ),

    );

    await refreshVehicles();

  } catch (e) {

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Text(e.toString()),

      ),

    );

  }

}

  Future<void> refreshVehicles() async {
    setState(() {
      vehiclesFuture = ApiService.getVehicles();
    });

    await vehiclesFuture;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("My Vehicles"),
        centerTitle: true,
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(

        future: vehiclesFuture,

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

          final vehicles = snapshot.data!;

          if (vehicles.isEmpty) {
            return const Center(
              child: Text("No vehicles added."),
            );
          }

          return RefreshIndicator(

            onRefresh: refreshVehicles,

            child: ListView.builder(

              itemCount: vehicles.length,

              itemBuilder: (context, index) {

                final vehicle = vehicles[index];

                return Card(

                  margin: const EdgeInsets.all(10),

                  elevation: 5,

                  child: ListTile(

                    leading: const CircleAvatar(
                      child: Icon(Icons.directions_car),
                    ),

                    title: Text(
                      vehicle["vehicle_number"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      "${vehicle["vehicle_type"]} • ${vehicle["fuel_type"]}",
                    ),

                    trailing: PopupMenuButton<String>(

                      onSelected: (value) async {

                        if (value == "edit") {

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditVehicleScreen(
                                vehicle: vehicle,
                              ),
                            ),
                          );

                        }

                        if (value == "delete") {

                          final confirm = await showDialog<bool>(

                            context: context,

                            builder: (_) => AlertDialog(

                              title: const Text("Delete Vehicle"),

                              content: const Text(
                                "Are you sure you want to delete this vehicle?"
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

                            await deleteVehicle(
                              vehicle["id"],
                            );

                          }

                        }

                      },

                      itemBuilder: (context) => [

                        const PopupMenuItem(
                          value: "edit",
                          child: Text("Edit"),
                        ),

                        const PopupMenuItem(
                          value: "delete",
                          child: Text("Delete"),
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

      floatingActionButton: FloatingActionButton(

        onPressed: () async {

          final result = await Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) => const AddVehicleScreen(),

            ),

          );

          if (result == true) {

            refreshVehicles();

          }

        },

        child: const Icon(Icons.add),

      ),

    );

  }

}