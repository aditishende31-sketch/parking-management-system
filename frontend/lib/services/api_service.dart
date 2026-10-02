import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5000';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000';
    }
    return 'http://localhost:5000';
  }

  static Future<List<Map<String, dynamic>>> getBookings() async {

  final response = await http.get(
    Uri.parse("$baseUrl/my-bookings"),
  );

  if (response.statusCode == 200) {

    final List data = jsonDecode(response.body);

    return data.cast<Map<String, dynamic>>();

  }

  throw Exception("Failed to load bookings");

}

static Future<void> cancelBooking(int bookingId) async {
  final response = await http.post(
    Uri.parse("$baseUrl/cancel-booking"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "booking_id": bookingId,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(jsonDecode(response.body)["message"]);
  }
}

  static Future<List<Map<String, dynamic>>> getSlots() async {
    final response = await http.get(
      Uri.parse('$baseUrl/slots'),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return decoded
            .map<Map<String, dynamic>>(
                (item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }
      throw Exception('Unexpected slots response format');
    }

    throw Exception('Failed to load slots (${response.statusCode})');
  }

  static Future<List<Map<String, dynamic>>> getVehicles() async {

  final response = await http.get(
    Uri.parse("$baseUrl/my-vehicles"),
  );

  if (response.statusCode == 200) {

    final List data = jsonDecode(response.body);

    return data.cast<Map<String, dynamic>>();

  }

  throw Exception("Failed to load vehicles");

}

static Future<void> addVehicle(
    String number,
    String type,
    String fuel,
) async {

  final response = await http.post(

    Uri.parse("$baseUrl/add-vehicle"),

    headers: {
      "Content-Type": "application/json",
    },

    body: jsonEncode({

      "vehicle_number": number,
      "vehicle_type": type,
      "fuel_type": fuel,

    }),

  );

  if (response.statusCode != 200) {

    throw Exception(
      jsonDecode(response.body)["message"],
    );

  }

}

static Future<void> deleteVehicle(int vehicleId) async {

  final response = await http.post(

    Uri.parse("$baseUrl/delete-vehicle"),

    headers: {
      "Content-Type": "application/json",
    },

    body: jsonEncode({

      "vehicle_id": vehicleId,

    }),

  );

  if (response.statusCode != 200) {

    throw Exception(
      jsonDecode(response.body)["message"],
    );

  }

}

static Future<void> updateVehicle(
  int vehicleId,
  String number,
  String type,
  String fuel,
) async {

  final response = await http.post(

    Uri.parse("$baseUrl/update-vehicle"),

    headers: {
      "Content-Type": "application/json",
    },

    body: jsonEncode({

      "vehicle_id": vehicleId,
      "vehicle_number": number,
      "vehicle_type": type,
      "fuel_type": fuel,

    }),

  );

  if (response.statusCode != 200) {

    throw Exception(
      jsonDecode(response.body)["message"],
    );

  }

}

static Future<void> bookSlot(

  int slotId,

  int vehicleId,

) async {

  final response = await http.post(

    Uri.parse("$baseUrl/book-slot"),

    headers: {
      "Content-Type": "application/json",
    },

    body: jsonEncode({

      "slot_id": slotId,

      "vehicle_id": vehicleId,

    }),

  );

  if (response.statusCode != 200) {

    final data = jsonDecode(response.body);

    throw Exception(
      data["message"] ?? "Failed to book slot",
    );

  }

}

static Future<List<Map<String, dynamic>>> getEvBookings() async {
  final response = await http.get(
    Uri.parse("$baseUrl/my-ev-bookings"),
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  }

  throw Exception("Failed to load EV bookings");
}

static Future<void> startCharging(int bookingId) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/start-charging"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "booking_id": bookingId,
      }),
    );

    if (response.statusCode != 200) {
      try {
        final data = jsonDecode(response.body);
        throw Exception(
          data["message"] ?? "Failed to start charging",
        );
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception(
          "Server error ${response.statusCode}: ${response.body}",
        );
      }
    }
  } catch (e) {
    print("START CHARGING ERROR: $e");
    rethrow;
  }
}

static Future<Map<String, dynamic>> stopCharging(
  int bookingId,
  double units,
) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/stop-charging"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "booking_id": bookingId,
        "units": units,
      }),
    );

    if (response.statusCode != 200) {
      try {
        final errorData = jsonDecode(response.body);

        throw Exception(
          errorData["message"] ?? "Failed to stop charging",
        );
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception(
          "Server error ${response.statusCode}: ${response.body}",
        );
      }
    }

    final data = jsonDecode(response.body);

    return Map<String, dynamic>.from(data);
  } catch (e) {
    print("STOP CHARGING ERROR: $e");
    rethrow;
  }
}

static Future<List<Map<String, dynamic>>> getChargingHistory() async {
  final response = await http.get(
    Uri.parse("$baseUrl/charging-history"),
  );

  print("CHARGING HISTORY STATUS: ${response.statusCode}");
  print("CHARGING HISTORY RESPONSE: ${response.body}");

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);

    return data
        .map<Map<String, dynamic>>(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }

  try {
    final data = jsonDecode(response.body);

    throw Exception(
      data["message"] ?? "Failed to load charging history",
    );
  } catch (_) {
    throw Exception(
      "Failed to load charging history: ${response.statusCode}",
    );
  }
}

static Future<Map<String, dynamic>> getChargingStatus(
  int bookingId,
) async {
  final response = await http.get(
    Uri.parse("$baseUrl/charging-status/$bookingId"),
  );

  print("CHARGING STATUS: ${response.statusCode}");
  print("CHARGING STATUS RESPONSE: ${response.body}");

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    return Map<String, dynamic>.from(data);
  }

  try {
    final data = jsonDecode(response.body);

    throw Exception(
      data["message"] ?? "Failed to get charging status",
    );
  } catch (_) {
    throw Exception(
      "Failed to get charging status: ${response.statusCode}",
    );
  }
}

}

