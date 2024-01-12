import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteController extends GetxController {
  var notes = <String>[].obs;
  var isSoundEnabled = true.obs;

  final String notesKey = 'saved_notes';

  @override
  void onInit() {
    super.onInit();
    // Load saved notes on initialization
    loadSavedNotes();
  }

  void addNote(String note) {
    notes.add(note);
    // Save notes whenever a new note is added
    saveNotes();
  }

  void deleteNote(int index) {
    notes.removeAt(index);
    // Save notes whenever a note is deleted
    saveNotes();
  }

  void toggleSound() {
    isSoundEnabled.value = !isSoundEnabled.value;
  }

  void saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(notesKey, notes);
  }

  void loadSavedNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notes.assignAll(prefs.getStringList(notesKey) ?? []);
  }
}