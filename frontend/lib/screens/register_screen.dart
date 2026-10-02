import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Create Account"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        child: Padding(

          padding: const EdgeInsets.all(30),

          child: Column(

            children: [

              const SizedBox(height: 20),

              const Icon(
                Icons.person_add,
                size: 100,
              ),

              const SizedBox(height: 20),

              TextField(

                decoration: InputDecoration(

                  labelText: "Name",

                  prefixIcon: const Icon(Icons.person),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                ),

              ),

              const SizedBox(height: 20),

              TextField(

                decoration: InputDecoration(

                  labelText: "Email",

                  prefixIcon: const Icon(Icons.email),

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

                  prefixIcon: const Icon(Icons.lock),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                ),

              ),

              const SizedBox(height: 20),

              TextField(

                obscureText: true,

                decoration: InputDecoration(

                  labelText: "Confirm Password",

                  prefixIcon: const Icon(Icons.lock_outline),

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

                  onPressed: () {},

                  child: const Text(
                    "REGISTER",

                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                ),

              ),

              const SizedBox(height: 20),

              TextButton(

                onPressed: () {

                  Navigator.pop(context);

                },

                child: const Text(
                  "Already have an account? Login",
                ),

              ),

            ],

          ),

        ),

      ),

    );
  }
}