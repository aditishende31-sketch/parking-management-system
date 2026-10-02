import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {

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

      await ApiService.addVehicle(

        numberController.text.trim(),

        vehicleType,

        fuelType,

      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text("Vehicle Added Successfully"),

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
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("Add Vehicle"),

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