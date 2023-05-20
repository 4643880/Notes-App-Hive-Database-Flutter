import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app_with_hive/models/notes_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

void main() async {
  // Initializing Hive
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(NotesAdapter());
  await Hive.openBox<Notes>('notes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String getName = "";
  String getCompanyName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getCompanyName == ""
            ? const Text("Hive Database")
            : Text(getCompanyName),
      ),
      body: ValueListenableBuilder<Box<Notes>>(
        // Getting listenable function from hive_flutter pkg
        valueListenable: Hive.box<Notes>("notes").listenable(),
        builder: (context, value, child) {
          final listOfNote = value.values.toList();
          return ListView.builder(
            itemCount: listOfNote.length,
            itemBuilder: (context, index) {
              final eachNote = listOfNote[index];
              return Container(
                height: 150,
                padding: const EdgeInsets.all(8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                eachNote.title.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                eidtMyDialog(eachNote, eachNote.title!,
                                    eachNote.description!);
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                eachNote.description.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                delete(eachNote);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showMyDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> delete(Notes note) async {
    note.delete();
  }

  eidtMyDialog(Notes note, String title, String desc) async {
    titleController.text = title;
    descriptionController.text = desc;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Notes"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                note.title = titleController.text;
                note.description = descriptionController.text;
                note.save();
                titleController.clear();
                descriptionController.clear();
                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      hintText: "Enter Title", border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      hintText: "Enter Description",
                      border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showMyDialog() async {
    titleController.clear();
    descriptionController.clear();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Notes"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final data = Notes(
                  title: titleController.text,
                  description: descriptionController.text,
                );

                final box = Hive.box<Notes>("notes");
                box.add(data);

                data.save();
                titleController.clear();
                descriptionController.clear();

                print(box);

                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      hintText: "Enter Title", border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      hintText: "Enter Description",
                      border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
