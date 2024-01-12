import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NoteController extends GetxController {
  var notes = <String>[].obs;
  var isSoundEnabled = true.obs;

  final String notesKey = 'saved_notes';
  

  void addNote(String note) {
    notes.add(note);
  }

  void deleteNote(int index) {
    notes.removeAt(index);
  }

  void toggleSound() {
    isSoundEnabled.value = !isSoundEnabled.value;
  }
}
