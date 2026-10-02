import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SelectVehicleDialog extends StatefulWidget {
  const SelectVehicleDialog({super.key});

  @override
  State<SelectVehicleDialog> createState() =>
      _SelectVehicleDialogState();
}

class _SelectVehicleDialogState
    extends State<SelectVehicleDialog> {

  late Future<List<Map<String, dynamic>>> vehiclesFuture;

  int? selectedVehicleId;

  @override
  void initState() {
    super.initState();

    vehiclesFuture = ApiService.getVehicles();
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text(
        "Choose Vehicle",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: SizedBox(

        width: double.maxFinite,

        child: FutureBuilder<List<Map<String, dynamic>>>(

          future: vehiclesFuture,

          builder: (context, snapshot) {

            // Loading
            if (snapshot.connectionState ==
                ConnectionState.waiting) {

              return const SizedBox(
                height: 120,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Error
            if (snapshot.hasError) {

              return SizedBox(
                height: 120,
                child: Center(
                  child: Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final vehicles = snapshot.data ?? [];

            // No vehicles
            if (vehicles.isEmpty) {

              return const SizedBox(
                height: 120,
                child: Center(
                  child: Text(
                    "No vehicles found.\nPlease add a vehicle first.",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            // Vehicle list
            return SizedBox(

              height: 250,

              child: ListView.builder(

                itemCount: vehicles.length,

                itemBuilder: (context, index) {

                  final vehicle = vehicles[index];

                  final vehicleId =
                      vehicle["id"] as int;

                  final isSelected =
                      selectedVehicleId == vehicleId;

                  return Card(

                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),

                    child: RadioListTile<int>(

                      value: vehicleId,

                      groupValue: selectedVehicleId,

                      onChanged: (value) {

                        setState(() {

                          selectedVehicleId = value;

                        });

                      },

                      secondary: Icon(

                        vehicle["vehicle_type"] == "Bike"
                            ? Icons.two_wheeler
                            : Icons.directions_car,

                        size: 30,

                      ),

                      title: Text(

                        vehicle["vehicle_number"].toString(),

                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),

                      ),

                      subtitle: Text(

                        "${vehicle["vehicle_type"]} • "
                        "${vehicle["fuel_type"]}",

                      ),

                      selected: isSelected,

                    ),

                  );

                },

              ),

            );

          },

        ),

      ),

      actions: [

        TextButton(

          onPressed: () {

            Navigator.pop(context);

          },

          child: const Text("Cancel"),

        ),

        ElevatedButton(

          onPressed: selectedVehicleId == null
              ? null
              : () {

                  Navigator.pop(
                    context,
                    selectedVehicleId,
                  );

                },

          child: const Text("Book"),

        ),

      ],

    );
  }
}