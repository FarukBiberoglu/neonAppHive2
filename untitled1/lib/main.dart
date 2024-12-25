import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:untitled1/person.dart';
import 'package:untitled1/secondPage.dart'; // Person modelini ekleyin

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter()); // Person modelini kaydediyoruz
  await Hive.openBox<Person>('Box'); // Box açarken Person türünü kullanıyoruz

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HiveDataBaseFlutter(),
    );
  }
}
