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
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.noteIndex != null) {
      _noteController.text = noteController.notes[widget.noteIndex!];
    }
  }

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
              controller: _noteController,
              onChanged: (note) {
                // You can update the note in real-time if needed
              },
              decoration: const InputDecoration(
                hintText: 'Enter your note...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                playNoteSound(_noteController.text);
              },
              child: const Text('Play Note Sound'),
            ),
            ElevatedButton(
              onPressed: () {
                saveNote();
                Get.back();
              },
              child: const Text('Save Note'),
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
      for (int i = 0; i < note.length; i++) {
        String char = note[i].toUpperCase();

        if (char.compareTo('1') >= 0 && char.compareTo('7') <= 0) {
          // If the character is between '1' and '7'
          int noteIndex = int.parse(char);
          player.play(AssetSource('sounds/note$noteIndex.wav'));
        } else {
          // Map keys 'Z' to 'M' to note1 to note7
          final keyNoteMap = {
            'Z': 1,
            'X': 2,
            'C': 3,
            'V': 4,
            'B': 5,
            'N': 6,
            'M': 7
          };

          if (keyNoteMap.containsKey(char)) {
            int noteIndex = keyNoteMap[char]!;
            player.play(AssetSource('sounds/note$noteIndex.wav'));
          }
          // You can add additional conditions for other cases if needed
        }
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

  void saveNote() {
    if (_noteController.text.isNotEmpty) {
      if (widget.noteIndex != null) {
        // Update existing note
        noteController.notes[widget.noteIndex!] = _noteController.text;
      } else {
        // Add new note
        noteController.addNote(_noteController.text);
      }

      // Save composition online
      saveCompositionOnline(_noteController.text);
    }
  }

  void saveCompositionOnline(String composition) async {
    await noteController.saveCompositionOnline(composition);
  }
}
