import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musical_notebook/controller/note_controller.dart';
import 'package:musical_notebook/pages/note_detail_page.dart';

class NoteListPage extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note List'),
        actions: [
          IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: () => noteController.toggleSound(),
          ),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: noteController.notes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(noteController.notes[index]),
              onTap: () {
                Get.to(NoteDetailPage(index));
              },
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
}
