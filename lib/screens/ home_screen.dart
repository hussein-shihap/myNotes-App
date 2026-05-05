import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/screens/ add_note_screen.dart';
import 'package:notes_app/screens/edit_note_screen.dart';

Future<void> deleteNoteFromFirestore(String docId) async {
  await FirebaseFirestore.instance
      .collection('Notes')
      .doc(docId)
      .delete();
}

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({super.key,required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
            Text("App",
                style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Notes') .where('email', isEqualTo: widget.email).snapshots(),
        builder: (context, snapshot) {

          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Empty
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No notes yet!",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(15),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final note = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;

              // ✅ reading title and info from Firestore
              final String title = note['title'] ?? 'No Title';
              final String info = note['info'] ?? 'No Info';

              return Card(
                margin: EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,

                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.note, color: Colors.white),
                  ),

                  // ✅ display title
                  title: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  // ✅ display info
                  subtitle: Text(info),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // ✏️ EDIT
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditNoteScreen(
                                docId: docId,
                                title: title,
                                content: info,
                              ),
                            ),
                          );
                        },
                      ),

                      // 🗑️ DELETE
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await deleteNoteFromFirestore(docId);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddNoteScreen(email: widget.email)),
          );
        },
      ),
    );
  }
}