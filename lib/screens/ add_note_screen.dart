import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addNotes(String title, String info,String email) async {
  await FirebaseFirestore.instance.collection('Notes').add({
    'info': info,
    'title': title,
    'email': email,
  });
}

class AddNoteScreen extends StatefulWidget {
  final String email;  // ✅ changed to StatefulWidget
  const AddNoteScreen({super.key,required this.email});  // ✅ added required email parameter

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {

  // ✅ controllers to get text from fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController infoController = TextEditingController();
  @override
  void dispose() {
    titleController.dispose();
    infoController.dispose();
    super.dispose();
  }

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
                    child: Icon(Icons.note_add, size: 40, color: Colors.white),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Add New Note",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  SizedBox(height: 25),

                  // ✅ TITLE FIELD with controller
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Title",
                      prefixIcon: Icon(Icons.title, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  // ✅ INFO FIELD with controller
                  TextField(
                    controller: infoController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Content",
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.text_fields, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: 25),

                  // SAVE BUTTON
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

                      onPressed: () async {
                        // ✅ get text from controllers
                        await addNotes(
                          titleController.text,
                          infoController.text,
                         widget.email,  // ✅ pass email from widget
                        );
                        Navigator.pop(context);
                      },

                      child: Text("Save Note"),
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