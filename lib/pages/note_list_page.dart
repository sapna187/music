import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musical_notebook/controller/note_controller.dart';
import 'package:musical_notebook/pages/note_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteListPage extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note List'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: noteController.notes.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Text(noteController.notes[index]),
                onTap: () {
                  Get.to(NoteDetailPage(index));
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDeleteConfirmationDialog(context, index);
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(NoteDetailPage(null));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await deleteNoteFromFirebase(index);
                noteController.deleteNote(index);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteNoteFromFirebase(int index) async {
    try {
      await _firestore
          .collection('notes')
          .doc(noteController.notes[index])
          .delete();
    } catch (e) {
      print('Error deleting note from Firebase: $e');
      // Handle error, show a message, etc.
    }
  }
}
