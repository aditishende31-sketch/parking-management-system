import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/select_vehicle_dialog.dart';

class SlotsScreen extends StatefulWidget {
  const SlotsScreen({super.key});

  @override
  State<SlotsScreen> createState() => _SlotsScreenState();
}

class _SlotsScreenState extends State<SlotsScreen> {

  late Future<List<Map<String, dynamic>>> _slotsFuture;

  @override
  void initState() {
    super.initState();
    _slotsFuture = ApiService.getSlots();
  }

  Future<void> _refreshSlots() async {

    setState(() {

      _slotsFuture = ApiService.getSlots();

    });

    await _slotsFuture;

  }

  Future<void> _bookSlot(
    Map<String, dynamic> slot,
    int vehicleId,
  ) async {

    final int slotId = slot['id'];

    try {

      await ApiService.bookSlot(
        slotId,
        vehicleId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Slot booked successfully."),
        ),
      );

      await _refreshSlots();

    } catch (error) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );

    }
  }

  bool _isBooked(Map<String, dynamic> slot) {

    final status = slot['status'];

    if (status == null) return false;

    return status.toString().toLowerCase() == 'reserved';

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("Parking Slots"),

        centerTitle: true,

      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(

        future: _slotsFuture,

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(

              child: CircularProgressIndicator(),

            );

          }

          if (snapshot.hasError) {

            return Center(

              child: Padding(

                padding: const EdgeInsets.all(16),

                child: Text(

                  snapshot.error.toString(),

                  textAlign: TextAlign.center,

                ),

              ),

            );

          }

          final slots = snapshot.data;

          if (slots == null || slots.isEmpty) {

            return Center(

              child: Column(

                mainAxisSize: MainAxisSize.min,

                children: [

                  const Text(

                    "No parking slots available.",

                  ),

                  const SizedBox(height: 12),

                  ElevatedButton(

                    onPressed: _refreshSlots,

                    child: const Text("Reload"),

                  ),

                ],

              ),

            );

          }

          return RefreshIndicator(

            onRefresh: _refreshSlots,

            child: ListView.builder(

              padding: const EdgeInsets.symmetric(

                vertical: 10,

              ),

              itemCount: slots.length,

              itemBuilder: (context, index) {

                final slot = slots[index];

                final isBooked = _isBooked(slot);

                return Card(

                  margin: const EdgeInsets.symmetric(

                    horizontal: 10,

                    vertical: 6,

                  ),

                  child: ListTile(

                    leading: const Icon(

                      Icons.local_parking,

                      size: 35,

                    ),

                    title: Text(

                      "${slot['slot_no']} • Floor ${slot['floor']} • ${slot['status']}",

                      style: const TextStyle(

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                    trailing: ElevatedButton(
                      onPressed: isBooked
                          ? null
                          : () async {
                              final vehicleId = await showDialog<int>(
                                context: context,
                                builder: (_) => const SelectVehicleDialog(),
                              );

                              if (vehicleId != null) {
                                await _bookSlot(
                                  slot,
                                  vehicleId,
                                );
                              }
                            },
                      child: Text(
                        isBooked ? "Reserved" : "Book",
                      ),
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