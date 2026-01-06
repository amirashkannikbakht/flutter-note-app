import 'package:hive/hive.dart';

part 'note.g.dart';

// 1. Annotate the class with @HiveType
@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String content;

  @HiveField(3)
  late DateTime dateModified;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.dateModified,
  });
}
