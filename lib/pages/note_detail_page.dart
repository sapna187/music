import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musical_notebook/controller/note_controller.dart';

class NoteDetailPage extends StatefulWidget {
  final int? noteIndex;

  const NoteDetailPage(this.noteIndex, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final NoteController noteController = Get.find();
  final player = AudioPlayer();
  final TextEditingController _noteController = TextEditingController();
  bool isMuted = false;

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
        actions: [
          IconButton(
            icon: isMuted
                ? const Icon(Icons.volume_off)
                : const Icon(Icons.volume_up),
            onPressed: () {
              setState(() {
                isMuted = !isMuted;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _noteController,
              onChanged: (note) {
                playNoteSound(note);
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
          ],
        ),
      ),
    );
  }

  void playNoteSound(String note) {
    if (!isMuted && noteController.isSoundEnabled.value && note.isNotEmpty) {
      String char = note[note.length - 1].toUpperCase();

      if (char.compareTo('1') >= 0 && char.compareTo('7') <= 0) {
        int noteIndex = int.parse(char);
        player.play(AssetSource('sounds/note$noteIndex.wav'));
      } else {
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
      }
    }
  }

  void saveNote() {
    if (_noteController.text.isNotEmpty) {
      if (widget.noteIndex != null) {
        noteController.notes[widget.noteIndex!] = _noteController.text;
      } else {
        noteController.addNote(_noteController.text);
      }

      saveCompositionOnline(_noteController.text);
    }
  }

  void saveCompositionOnline(String composition) async {
    await noteController.saveCompositionOnline(composition);
  }
}
