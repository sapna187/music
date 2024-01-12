import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:musical_notebook/controller/note_controller.dart';

class NoteDetailPage extends StatefulWidget {
  final int? noteIndex;

  NoteDetailPage(this.noteIndex);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final NoteController noteController = Get.find();
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (note) {
                if (widget.noteIndex != null) {
                  noteController.notes[widget.noteIndex!] = note;
                } else {
                  noteController.addNote(note);
                }
                playNoteSound(note);
              },
              decoration: const InputDecoration(
                hintText: 'Enter your note...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (widget.noteIndex != null) {
                  noteController.deleteNote(widget.noteIndex!);
                  Get.back();
                }
              },
              child: const Text('Delete Note'),
            ),
            RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (RawKeyEvent event) {
                if (event is RawKeyDownEvent) {
                  handleKeyPress(event.logicalKey.keyLabel);
                }
              },
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  void playNoteSound(String note) {
    if (noteController.isSoundEnabled.value) {
      int? noteIndex = int.tryParse(note);
      if (noteIndex != null && noteIndex >= 1 && noteIndex <= 7) {
        player.play(AssetSource('assets/sounds/note$noteIndex.wav'));
      } else {
        // Handle other cases or provide a default sound
      }
    }
  }

  void handleKeyPress(String keyLabel) {
    if (noteController.isSoundEnabled.value) {
      if (['Z', 'X', 'C', 'V', 'B', 'N', 'M', '1', '2', '3', '4', '5', '6', '7']
          .contains(keyLabel)) {
        playNoteSound(keyLabel);
      }
    }
  }
}
