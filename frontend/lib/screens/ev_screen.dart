import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EvChargingScreen extends StatefulWidget {
  const EvChargingScreen({super.key});

  @override
  State<EvChargingScreen> createState() => _EvChargingScreenState();
}

class _EvChargingScreenState extends State<EvChargingScreen> {
  late Future<List<Map<String, dynamic>>> bookingsFuture;

  // Stores charging status for each booking
  final Map<int, Map<String, dynamic>> chargingStatuses = {};

  @override
  void initState() {
    super.initState();
    bookingsFuture = ApiService.getEvBookings();
  }

  Future<void> refreshBookings() async {
    setState(() {
      bookingsFuture = ApiService.getEvBookings();
    });

    await bookingsFuture;
    await _loadChargingStatuses();
  }

  Future<void> _loadChargingStatuses() async {
    try {
      final bookings = await bookingsFuture;

      for (final booking in bookings) {
        final bookingId =
            int.parse(booking["booking_id"].toString());

        final status =
            await ApiService.getChargingStatus(bookingId);

        if (mounted) {
          setState(() {
            chargingStatuses[bookingId] = status;
          });
        }
      }
    } catch (e) {
      debugPrint("Charging status error: $e");
    }
  }

  Future<void> startCharging(int bookingId) async {
    try {
      await ApiService.startCharging(bookingId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "⚡ Charging started successfully!",
          ),
        ),
      );

      await _loadChargingStatuses();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  Future<void> showStopChargingDialog(int bookingId) async {
    final controller = TextEditingController();

    final units = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Stop Charging"),

          content: TextField(
            controller: controller,

            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),

            decoration: const InputDecoration(
              labelText: "Units Consumed",
              hintText: "Example: 12",
              suffixText: "kWh",
              border: OutlineInputBorder(),
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
              onPressed: () {
                final value =
                    double.tryParse(controller.text.trim());

                if (value == null || value < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Enter a valid number of units.",
                      ),
                    ),
                  );

                  return;
                }

                Navigator.pop(context, value);
              },
              child: const Text("Stop Charging"),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (units == null) return;

    await stopCharging(
      bookingId,
      units,
    );
  }

  Future<void> stopCharging(
    int bookingId,
    double units,
  ) async {
    try {
      final result = await ApiService.stopCharging(
        bookingId,
        units,
      );

      if (!mounted) return;

      final consumed =
          double.tryParse(
                result["units_consumed"].toString(),
              ) ??
              units;

      final amount =
          double.tryParse(
                result["amount"].toString(),
              ) ??
              (consumed * 8);

      await _loadChargingStatuses();

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle),
                SizedBox(width: 10),
                Expanded(
                  child: Text("Charging Complete"),
                ),
              ],
            ),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  "Charging session completed successfully.",
                ),

                const SizedBox(height: 20),

                Text(
                  "Units Consumed: "
                  "${consumed.toStringAsFixed(2)} kWh",
                ),

                const SizedBox(height: 10),

                const Text(
                  "Rate: ₹8.00 / kWh",
                ),

                const Divider(height: 25),

                Text(
                  "Total Cost: "
                  "₹${amount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Done"),
              ),
            ],
          );
        },
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  Widget buildStatus(int bookingId) {
    final status = chargingStatuses[bookingId];

    if (status == null) {
      return const Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          SizedBox(width: 10),
          Text("Checking charging status..."),
        ],
      );
    }

    final currentStatus =
        status["status"].toString();

    if (currentStatus == "Charging") {
      return Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),

        child: const Row(
          children: [
            Icon(Icons.bolt),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Charging Active",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (currentStatus == "Completed") {
      final units =
          double.tryParse(
                status["units_consumed"].toString(),
              ) ??
              0;

      final amount =
          double.tryParse(
                status["amount"].toString(),
              ) ??
              0;

      return Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const Row(
              children: [
                Icon(Icons.check_circle),
                SizedBox(width: 10),
                Text(
                  "Charging Completed",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              "Energy: "
              "${units.toStringAsFixed(2)} kWh",
            ),

            Text(
              "Total: "
              "₹${amount.toStringAsFixed(2)}",
            ),
          ],
        ),
      );
    }

    return const Row(
      children: [
        Icon(Icons.radio_button_unchecked),
        SizedBox(width: 10),
        Text("Charging Not Started"),
      ],
    );
  }

  Widget buildActionButton(
    Map<String, dynamic> booking,
  ) {
    final bookingId =
        int.parse(
          booking["booking_id"].toString(),
        );

    final status =
        chargingStatuses[bookingId]?["status"];

    if (status == "Charging") {
      return SizedBox(
        width: double.infinity,

        child: ElevatedButton.icon(
          onPressed: () {
            showStopChargingDialog(bookingId);
          },

          icon: const Icon(
            Icons.stop_circle,
          ),

          label: const Text(
            "Stop Charging",
          ),
        ),
      );
    }

    if (status == "Completed") {
      return SizedBox(
        width: double.infinity,

        child: OutlinedButton.icon(
          onPressed: null,

          icon: const Icon(
            Icons.check_circle,
          ),

          label: const Text(
            "Charging Completed",
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,

      child: ElevatedButton.icon(
        onPressed: () {
          startCharging(bookingId);
        },

        icon: const Icon(
          Icons.bolt,
        ),

        label: const Text(
          "Start Charging",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EV Charging"),
        centerTitle: true,
      ),

      body: FutureBuilder<
          List<Map<String, dynamic>>>(
        future: bookingsFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final bookings =
              snapshot.data ?? [];

          if (bookings.isEmpty) {
            return RefreshIndicator(
              onRefresh: refreshBookings,

              child: ListView(
                children: const [
                  SizedBox(height: 200),

                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.ev_station,
                          size: 70,
                        ),

                        SizedBox(height: 20),

                        Text(
                          "No EV bookings found.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          "Book a parking slot using "
                          "an EV vehicle first.",
                          textAlign:
                              TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          // Load statuses after bookings arrive
          if (chargingStatuses.length <
              bookings.length) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) {
              _loadChargingStatuses();
            });
          }

          return RefreshIndicator(
            onRefresh: refreshBookings,

            child: ListView.builder(
              padding: const EdgeInsets.all(12),

              itemCount: bookings.length,

              itemBuilder: (context, index) {
                final booking =
                    bookings[index];

                return Card(
                  elevation: 5,

                  margin:
                      const EdgeInsets.only(
                    bottom: 15,
                  ),

                  child: Padding(
                    padding:
                        const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.ev_station,
                              size: 35,
                            ),

                            const SizedBox(width: 12),

                            const Expanded(
                              child: Text(
                                "EV Charging",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Divider(),

                        const SizedBox(height: 8),

                        Text(
                          "Vehicle: "
                          "${booking["vehicle_number"]}",
                          style:
                              const TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Slot: "
                          "${booking["slot_no"]}",
                          style:
                              const TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Vehicle Type: "
                          "${booking["vehicle_type"]}",
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Fuel Type: "
                          "${booking["fuel_type"]}",
                        ),

                        const SizedBox(height: 18),

                        buildStatus(
                          int.parse(
                            booking["booking_id"]
                                .toString(),
                          ),
                        ),

                        const SizedBox(height: 15),

                        buildActionButton(
                          booking,
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