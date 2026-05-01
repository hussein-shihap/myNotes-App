import 'package:flutter/material.dart';

class EditNoteScreen extends StatefulWidget {
  final String title;
  final String content;

  const EditNoteScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {

  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();

    // نحط البيانات اللي جايه من Home داخل الحقول
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,

      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Icon(Icons.notes, color: Colors.white),
        title: Text("Edit Note"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // TITLE
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            // CONTENT
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Content",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 25),

            // UPDATE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),

                onPressed: () {

                  Navigator.pop(context, {
                    "title": titleController.text,
                    "content": contentController.text,
                  });
                },

                child: Text("Update"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}