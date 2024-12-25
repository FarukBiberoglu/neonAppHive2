import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:untitled1/person.dart';

class HiveDataBaseFlutter extends StatefulWidget {
  const HiveDataBaseFlutter({super.key});

  @override
  State<HiveDataBaseFlutter> createState() => _HiveDataBaseFlutterState();
}

class _HiveDataBaseFlutterState extends State<HiveDataBaseFlutter> {
  var peopleBox = Hive.box<Person>('Box');
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  void dispose() {
    ageController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void addOrUpdatePerson({String? key}) {
    if (key != null) {
      final person = peopleBox.get(key);
      if (person != null) {
        nameController.text = person.name;
        ageController.text = person.age.toString();
      }
    } else {
      nameController.clear();
      ageController.clear();
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Dynamic column size
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Enter name'),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Enter age'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text;
                  final age = int.tryParse(ageController.text);

                  if (name.isEmpty || age == null || age <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter valid name and age'),
                      ),
                    );
                    return;
                  }

                  final person = Person(name: name, age: age);
                  if (key == null) {
                    final newKey = DateTime.now().millisecondsSinceEpoch.toString();
                    peopleBox.put(newKey, person);
                  } else {
                    peopleBox.put(key, person);
                  }
                  Navigator.pop(context);
                },
                child: Text(key == null ? 'Add' : 'Update'),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  void deleteOperation(String key) {
    peopleBox.delete(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("TaskMaster"),
        centerTitle: true,
        backgroundColor: Colors.blue[100],
      ),
      body: ValueListenableBuilder(
        valueListenable: peopleBox.listenable(),
        builder: (context, box, widget) {
          if (box.isEmpty) {
            return const Center(
              child: Text("No items added yet."),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final key = box.keyAt(index).toString();
              final person = box.get(key);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: Colors.white,
                  elevation: 2,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(person?.name ?? "Unknown"),
                      subtitle: Text("Age: ${person?.age ?? "Unknown"}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => addOrUpdatePerson(key: key),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => deleteOperation(key),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () => addOrUpdatePerson(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
