import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  final DateTime createdAt;
  @HiveField(3)
  bool isCompleted;

  Task(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.isCompleted});

  factory Task.create({required String name, required DateTime createdAt}) {
    return Task(
        id: const Uuid()
            .v1(), // oluşturulan saati gider ona atar bunun sayesinde her id değişiklik gösterir.
        name: name,
        createdAt: createdAt,
        isCompleted: false);
  }
}
