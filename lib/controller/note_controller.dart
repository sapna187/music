import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String compositionsCollection = 'compositions';

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

  Future<void> saveCompositionOnline(String composition) async {
    try {
      await _firestore.collection(compositionsCollection).add({
        'composition': composition,
      });
    } catch (e) {
      print('Error saving composition: $e');
    }
  }

  Future<List<String>> getCompositionsOnline() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection(compositionsCollection).get();

      return querySnapshot.docs
          .map((doc) => doc['composition'] as String)
          .toList();
    } catch (e) {
      print('Error getting compositions: $e');
      return [];
    }
  }

  void updateNotes(List<String> remoteNotes) {
    // Update local notes with remote notes
    notes.assignAll(remoteNotes);
    // Save updated notes locally
    saveNotes();
  }
}
