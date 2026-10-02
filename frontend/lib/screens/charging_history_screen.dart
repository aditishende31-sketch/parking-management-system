import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ChargingHistoryScreen extends StatefulWidget {
  const ChargingHistoryScreen({super.key});

  @override
  State<ChargingHistoryScreen> createState() =>
      _ChargingHistoryScreenState();
}

class _ChargingHistoryScreenState
    extends State<ChargingHistoryScreen> {

  late Future<List<Map<String, dynamic>>> historyFuture;

  @override
  void initState() {
    super.initState();

    historyFuture = ApiService.getChargingHistory();
  }

  Future<void> refreshHistory() async {
    setState(() {
      historyFuture = ApiService.getChargingHistory();
    });

    await historyFuture;
  }

  String formatDate(String? value) {
    if (value == null || value.isEmpty) {
      return "N/A";
    }

    try {
      final dateTime = DateTime.parse(value);

      return "${dateTime.day.toString().padLeft(2, '0')}/"
          "${dateTime.month.toString().padLeft(2, '0')}/"
          "${dateTime.year} "
          "${dateTime.hour.toString().padLeft(2, '0')}:"
          "${dateTime.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Charging History"),
        centerTitle: true,
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(

        future: historyFuture,

        builder: (context, snapshot) {

          // Loading
          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [

                    const Icon(
                      Icons.error_outline,
                      size: 60,
                    ),

                    const SizedBox(height: 15),

                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: refreshHistory,
                      child: const Text("Retry"),
                    ),

                  ],
                ),
              ),
            );
          }

          final history = snapshot.data ?? [];

          // No history
          if (history.isEmpty) {

            return RefreshIndicator(

              onRefresh: refreshHistory,

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
                          "No charging history found.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          "Completed charging sessions "
                          "will appear here.",
                          textAlign: TextAlign.center,
                        ),

                      ],

                    ),

                  ),

                ],
              ),

            );
          }

          // History list
          return RefreshIndicator(

            onRefresh: refreshHistory,

            child: ListView.builder(

              padding: const EdgeInsets.all(12),

              itemCount: history.length,

              itemBuilder: (context, index) {

                final session = history[index];

                final units =
                    double.tryParse(
                          session["units_consumed"]
                              .toString(),
                        ) ??
                        0;

                final amount =
                    double.tryParse(
                          session["amount"].toString(),
                        ) ??
                        0;

                return Card(

                  elevation: 5,

                  margin: const EdgeInsets.only(
                    bottom: 15,
                  ),

                  child: Padding(

                    padding: const EdgeInsets.all(16),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        // Header
                        Row(

                          children: [

                            const Icon(
                              Icons.ev_station,
                              size: 35,
                            ),

                            const SizedBox(width: 12),

                            const Expanded(

                              child: Text(
                                "EV Charging Session",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                            ),

                            const Icon(
                              Icons.check_circle,
                              size: 25,
                            ),

                          ],

                        ),

                        const Divider(),

                        const SizedBox(height: 8),

                        // Vehicle
                        Row(

                          children: [

                            const Icon(
                              Icons.directions_car,
                              size: 22,
                            ),

                            const SizedBox(width: 10),

                            Expanded(

                              child: Text(
                                "Vehicle: "
                                "${session["vehicle_number"]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w500,
                                ),
                              ),

                            ),

                          ],

                        ),

                        const SizedBox(height: 10),

                        // Slot
                        Row(

                          children: [

                            const Icon(
                              Icons.local_parking,
                              size: 22,
                            ),

                            const SizedBox(width: 10),

                            Text(
                              "Slot: "
                              "${session["slot_no"]}",
                            ),

                          ],

                        ),

                        const SizedBox(height: 10),

                        // Start time
                        Row(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            const Icon(
                              Icons.play_arrow,
                              size: 22,
                            ),

                            const SizedBox(width: 10),

                            Expanded(

                              child: Text(
                                "Started: "
                                "${formatDate(
                                  session["start_time"]
                                      ?.toString(),
                                )}",
                              ),

                            ),

                          ],

                        ),

                        const SizedBox(height: 10),

                        // End time
                        Row(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            const Icon(
                              Icons.stop,
                              size: 22,
                            ),

                            const SizedBox(width: 10),

                            Expanded(

                              child: Text(
                                "Ended: "
                                "${formatDate(
                                  session["end_time"]
                                      ?.toString(),
                                )}",
                              ),

                            ),

                          ],

                        ),

                        const SizedBox(height: 15),

                        const Divider(),

                        const SizedBox(height: 5),

                        // Units and amount
                        Row(

                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,

                          children: [

                            Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                const Text(
                                  "Energy Used",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "${units.toStringAsFixed(2)} kWh",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                              ],

                            ),

                            Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment.end,

                              children: [

                                const Text(
                                  "Total Cost",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "₹${amount.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                              ],

                            ),

                          ],

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