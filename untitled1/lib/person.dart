import 'package:hive/hive.dart';

part 'person.g.dart'; // Bu satırı kullanarak Hive'ın otomatik olarak kod üretmesini sağlayacağız

@HiveType(typeId: 0)
class Person {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int age;

  Person({required this.name, required this.age});
}
