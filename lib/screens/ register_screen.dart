import 'package:flutter/material.dart';
import ' home_screen.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
Future<void> register(String em, String pas) async {
  await FirebaseFirestore.instance.collection('Register').add({
    'email': em,
    'password': pas,
  });
}
String hashPassword(String password) {
  final bytes = utf8.encode(password);       
  final digest = sha256.convert(bytes);     
  return digest.toString();                  
}
Future<bool> found(String email, String pass) async {
  var result = await FirebaseFirestore.instance
      .collection('Register')
      .where('email', isEqualTo: email)
      .where('password', isEqualTo: pass)
      .get();

  return result.docs.isNotEmpty;
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,

      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: Icon(Icons.notes, color: Colors.white),
        title: Row(
          children: [
            Icon(Icons.bolt, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text("MyNotes",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(width: 6),
            Text("App", style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person_add, size: 40, color: Colors.white),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  SizedBox(height: 25),

                  // EMAIL
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  // PASSWORD
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  // CONFIRM PASSWORD
                  TextField(
                    controller: confirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: 25),

                  // REGISTER BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,


                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),


                      onPressed: () async { // ✅ async added
                        String email = emailController.text;
                        String password = passwordController.text;
                        String confirm = confirmController.text;

                        // 1. check empty fields
                        if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Please fill all fields",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          );
                        }else if(email.contains('@')==false||email.contains('.com')==false){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Please enter a valid email",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          );
                        }

                        // 2. check passwords match
                        else if (password != confirm) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Passwords do not match",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          );
                        }

                        // 3. check if email already registered
                        else if (await found(email, password) == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Email already registered",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          );
                        }


                        else {
                          await register(email, hashPassword( password));
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => HomeScreen(email: email)),
                          );
                        }
                      },

                      child: Text("Register"),
                    ),
                  ),

                  SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}