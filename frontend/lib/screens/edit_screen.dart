import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditVehicleScreen extends StatefulWidget {

  final Map<String, dynamic> vehicle;

  const EditVehicleScreen({

    super.key,

    required this.vehicle,

  });

  @override
  State<EditVehicleScreen> createState() =>
      _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController numberController =
      TextEditingController();

  String vehicleType = "Car";
  String fuelType = "Petrol";

  bool loading = false;

  Future<void> saveVehicle() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    try {

      await ApiService.updateVehicle(

        widget.vehicle["id"],
        numberController.text.trim(),

        vehicleType,

        fuelType,

      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text("Vehicle Updated Successfully"),

        ),

      );

      Navigator.pop(context, true);

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text(e.toString()),

        ),

      );

    }

    setState(() {
      loading = false;
    });

  }

  @override
void initState() {

  super.initState();

  numberController.text =
      widget.vehicle["vehicle_number"];

  vehicleType =
      widget.vehicle["vehicle_type"];

  fuelType =
      widget.vehicle["fuel_type"];

}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("Edit Vehicle"),

      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              TextFormField(

                controller: numberController,

                decoration: const InputDecoration(

                  labelText: "Vehicle Number",

                  border: OutlineInputBorder(),

                  prefixIcon: Icon(Icons.directions_car),

                ),

                validator: (value) {

                  if (value == null || value.isEmpty) {

                    return "Enter vehicle number";

                  }

                  return null;

                },

              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(

                initialValue: vehicleType,

                decoration: const InputDecoration(

                  labelText: "Vehicle Type",

                  border: OutlineInputBorder(),

                ),

                items: const [

                  DropdownMenuItem(

                    value: "Car",

                    child: Text("Car"),

                  ),

                  DropdownMenuItem(

                    value: "Bike",

                    child: Text("Bike"),

                  ),

                ],

                onChanged: (value) {

                  setState(() {

                    vehicleType = value!;

                  });

                },

              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(

                initialValue: fuelType,

                decoration: const InputDecoration(

                  labelText: "Fuel Type",

                  border: OutlineInputBorder(),

                ),

                items: const [

                  DropdownMenuItem(

                    value: "Petrol",

                    child: Text("Petrol"),

                  ),

                  DropdownMenuItem(

                    value: "Diesel",

                    child: Text("Diesel"),

                  ),

                  DropdownMenuItem(

                    value: "CNG",

                    child: Text("CNG"),

                  ),

                  DropdownMenuItem(

                    value: "EV",

                    child: Text("EV"),

                  ),

                ],

                onChanged: (value) {

                  setState(() {

                    fuelType = value!;

                  });

                },

              ),

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,

                height: 50,

                child: ElevatedButton(

                  onPressed: loading ? null : saveVehicle,

                  child: loading

                      ? const CircularProgressIndicator()

                      : const Text(

                          "Save Vehicle",

                        ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}