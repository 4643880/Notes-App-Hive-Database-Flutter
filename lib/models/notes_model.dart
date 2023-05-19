import 'package:hive/hive.dart';

part 'notes_model.g.dart'; // this will generate models
// then use this command in terminal => flutter packages pub run build_runner build
// above command will automatically generate adapter of the new model
// flutter_hive provides listenable to show in real time

@HiveType(typeId: 0)
class Notes extends HiveObject {
  @HiveField(0)
  String? title;

  @HiveField(1)
  String? description;

  Notes({required this.title, required this.description});
}

@HiveType(typeId: 1)
class Contact {
  @HiveField(0)
  String? city;

  @HiveField(1)
  String? address;

  Contact({required this.city, required this.address});
}
