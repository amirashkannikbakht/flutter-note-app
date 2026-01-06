import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';

class NotesService {
  static const String boxName = 'notes';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(NoteAdapter());
    await Hive.openBox<Note>(boxName);
  }

  Box<Note> getBox() {
    return Hive.box<Note>(boxName);
  }

  ValueListenable<Box<Note>> getNotesListenable() {
    return getBox().listenable();
  }

  Future<void> addNote(Note note) async {
    final box = getBox();
    await box.put(note.id, note);
  }

  Future<void> updateNote(Note note) async {
    final box = getBox();
    await box.put(note.id, note);
  }

  Future<void> deleteNote(String id) async {
    final box = getBox();
    await box.delete(id);
  }
}
