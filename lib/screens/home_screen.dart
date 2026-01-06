import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';
import '../services/notes_service.dart';
import 'edit_note_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesService = NotesService();

    return Scaffold(
      backgroundColor: Colors.white, // Or a very light grey like Apple Notes
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                'Notes',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Search bar could act as a SliverToBoxAdapter here
           SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SearchBar(
                elevation: const WidgetStatePropertyAll(0),
                 backgroundColor: WidgetStatePropertyAll(Colors.grey[200]),
                 hintText: 'Search',
                 leading: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
           ),
          ValueListenableBuilder(
            valueListenable: notesService.getNotesListenable(),
            builder: (context, Box<Note> box, _) {
              final notes = box.values.toList().cast<Note>();
              
              if (notes.isEmpty) {
                  return const SliverFillRemaining(
                      child: Center(child: Text("No notes yet", style: TextStyle(color: Colors.grey))),
                  );
              }

              // Sort by date modified (newest first)
              notes.sort((a, b) => b.dateModified.compareTo(a.dateModified));

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final note = notes[index];
                    return Dismissible(
                      key: Key(note.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        notesService.deleteNote(note.id);
                      },
                      child: GestureDetector(
                        onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditNoteScreen(note: note),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 0.5)),
                             color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title.isNotEmpty ? note.title : 'No Title',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    _formatDate(note.dateModified),
                                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      note.content.isNotEmpty ? note.content : 'No Content',
                                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: notes.length,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditNoteScreen()),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.create, color: Colors.white),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Simple logic: If today, show time. If yesterday, show "Yesterday". Else show date.
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0 && now.day == date.day) {
        return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } else if (difference.inDays == 1 || (difference.inDays == 0 && now.day != date.day)) {
        return "Yesterday";
    } else {
        return "${date.day}/${date.month}/${date.year}";
    }
  }
}
