import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  @override
  String toString() => name;
}