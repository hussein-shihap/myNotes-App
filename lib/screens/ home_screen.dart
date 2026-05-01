import 'package:flutter/material.dart';
import ' add_note_screen.dart';
import 'edit_note_screen.dart';





class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}




class _HomeScreenState extends State<HomeScreen> {





  // Mutable list
  List<Map<String, String>> notes = [
    {"title": "Buy Milk", "content": "From supermarket"},
    {"title": "Study Flutter", "content": "Stateful widgets"},
    {"title": "Meeting", "content": "Tomorrow 10 AM"},
  ];





  void deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
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
            Text("App",
                style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),








      body: ListView.builder(

        padding: EdgeInsets.all(15),

        itemCount: notes.length, //it variable name should be always itemCount



        itemBuilder: (context, index) {
          final note = notes[index];




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





              title: Text(
                note["title"]!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              subtitle: Text(note["content"]!),












              // ✏️ EDIT
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),

                      onPressed: () async {

                        final updatedNote = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditNoteScreen(
                              title: note["title"]!,
                              content: note["content"]!,
                            ),
                          ),
                        );

                        if (updatedNote != null) {
                          setState(() {
                            notes[index] = {
                              "title": updatedNote["title"],
                              "content": updatedNote["content"],
                            };
                          });
                        }
                      }
                  ),









                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.blue),

                    onPressed: () {
                      deleteNote(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),








      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddNoteScreen(),
            ),
          );
        },
      ),
    );
  }
}