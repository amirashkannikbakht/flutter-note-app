import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_notes_app/main.dart';
import 'package:flutter_notes_app/models/note.dart';
import 'package:flutter_notes_app/services/notes_service.dart';

void main() {
  setUpAll(() async {
    // Initialize Hive for testing
    // We use a temporary directory for the Hive box
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);
    
    // Register Adapter
    if (!Hive.isAdapterRegistered(0)) {
       Hive.registerAdapter(NoteAdapter());
    }
  });

  setUp(() async {
    // Open the box before each test
    await Hive.openBox<Note>(NotesService.boxName);
  });

  tearDown(() async {
    // Clear the box after each test
    final box = Hive.box<Note>(NotesService.boxName);
    await box.clear();
  });

  testWidgets('App loads home screen with correct title and FAB', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Note: We bypass main() to avoid re-initializing Hive with path_provider
    await tester.pumpWidget(const MyApp());
    
    // Wait for animations and async operations
    await tester.pumpAndSettle();

    // Verify that the title "Notes" is present
    expect(find.text('Notes'), findsOneWidget);

    // Verify that the Floating Action Button is present
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Verify that "No notes yet" is displayed (since box is empty)
    expect(find.text('No notes yet'), findsOneWidget);
  });
}
