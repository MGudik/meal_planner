import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Todo {
  Todo({required this.title})
      : id = uuid.v4(),
        compleated = false;

  Todo.withID({required this.id, required this.title}) : compleated = false;

  final String id;
  final String title;
  bool compleated;

  void toggleCompleation() {
    compleated = !compleated;
  }

  void setCompleation(bool status) {
    compleated = status;
  }
}
