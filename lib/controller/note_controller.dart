import 'package:get/get.dart';

class NoteController extends GetxController {
  var notes = <String>[].obs;
  var isSoundEnabled = true.obs;

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

