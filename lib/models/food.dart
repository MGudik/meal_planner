import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Food {
  Food({required this.title}) : id = uuid.v4();

  Food.withID({required this.id, required this.title});

  final String id;
  final String title;
}

class Wish {
  Wish({required this.id, required this.title, required this.wishedBy});

  final String id;
  final String title;
  String wishedBy = "";
}
