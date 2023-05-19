import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

void main() async {
  // Initializing Hive
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
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
      body: FutureBuilder(
        future: Hive.openBox("Aizaz"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.data?.get("details")["name"].toString() ?? "",
                    ),
                    Text(
                      snapshot.data?.get("details")["companyName"].toString() ??
                          "",
                    ),
                    Text(
                      snapshot.data?.get("details")["department"].toString() ??
                          "",
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var box = await Hive.openBox("Aizaz");
          box.put("name", "Aizaz Haider");
          box.put(
            "details",
            {"name": "ABC", "department": "HR", "companyName": "Greelogix"},
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
