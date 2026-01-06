import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import '../services/notes_service.dart';

class EditNoteScreen extends StatefulWidget {
  final Note? note;
  const EditNoteScreen({super.key, this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final NotesService _notesService = NotesService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      return; // Don't save empty notes
    }

    if (widget.note != null) {
      // Update existing note
      final updatedNote = widget.note!;
      updatedNote.title = title;
      updatedNote.content = content;
      updatedNote.dateModified = DateTime.now();
      updatedNote.save(); // HiveObject extension method
    } else {
      // Create new note
      final newNote = Note(
        id: const Uuid().v4(),
        title: title,
        content: content,
        dateModified: DateTime.now(),
      );
      _notesService.addNote(newNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
           _saveNote();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.orange),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Done", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  style: const TextStyle(fontSize: 18),
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Type something...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                 padding: const EdgeInsets.only(bottom: 20.0),
                 child: Text(
                   "Edited ${_formatDate(DateTime.now())}",
                   style: TextStyle(color: Colors.grey[400], fontSize: 12),
                 ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
      // Use intl if available, simple placeholder for now or add intl usage
      return "${date.day}/${date.month}/${date.year}";
  }
}
