import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musical_notebook/pages/note_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MusicalNoteBook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteListPage(),
    );
  }
}
