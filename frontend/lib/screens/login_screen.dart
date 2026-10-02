import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(

        child: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.all(30),

            child: Column(

              children: [

                const Icon(
                  Icons.local_parking,
                  size: 120,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Parking Allotment System",

                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Find and book parking slots easily",

                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 40),

                TextField(

                  decoration: InputDecoration(

                    labelText: "Email",

                    prefixIcon: Icon(Icons.email),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(

                  obscureText: true,

                  decoration: InputDecoration(

                    labelText: "Password",

                    prefixIcon: Icon(Icons.lock),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(

                  width: double.infinity,

                  height: 55,

                  child: ElevatedButton(

                    onPressed: () {

                      Navigator.pushReplacement(

                        context,

                        MaterialPageRoute(

                          builder: (context) => const HomeScreen(),

                        ),

                      );

                    },

                    child: const Text(
                      "LOGIN",

                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextButton(

              onPressed: () {

               Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (context) => const RegisterScreen(),

                ),

              );

            },
                  child: const Text(
                    "Create Account",
                  ),
                ),

              ],

            ),

          ),

        ),

      ),

    );
  }
}
