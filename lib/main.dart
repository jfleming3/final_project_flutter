
import 'package:final_project_flutter/grade.dart';

import 'package:final_project_flutter/grade.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FireStore',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirebaseDemo(),
    );
  }
}

class FirebaseDemo extends StatefulWidget {
  @override
  _FirebaseState createState() => _FirebaseState();
}

class _FirebaseState extends State<FirebaseDemo> {
  final TextEditingController _newItemTextField = TextEditingController();
  final TextEditingController _gradetypeTextField = TextEditingController();
  final CollectionReference databse = FirebaseFirestore.instance.collection('grades');
  List<String> itemList = [];




  Widget gradeTextFieldWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
        controller: _gradetypeTextField,
        style: TextStyle(fontSize: 22, color: Colors.black),
        decoration: InputDecoration(
          hintText: "Grade type",
          hintStyle: TextStyle(fontSize: 22, color: Colors.black),
        ),
      ),
    );
  }

  Widget TextFieldWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
        controller: _newItemTextField,
        style: TextStyle(fontSize: 22, color: Colors.black),
        decoration: InputDecoration(
          hintText: "Grade",
          hintStyle: TextStyle(fontSize: 22, color: Colors.black),
        ),
      ),
    );
  }

  Widget addtoDatabase(){
    return SizedBox(
      child: ElevatedButton(
          onPressed: () async {
            final String name = _gradetypeTextField.text;
            final String score = _newItemTextField.text;
            final gradeModel grade = gradeModel(type: name, score: score);

            await databse.add(grade.toMap());
          },
          child: Text(
            'Add Data',
            style: TextStyle(fontSize: 20),
          )),
    );
  }




  Widget itemListWidget() {
    return Expanded(
      child:
      StreamBuilder(stream: databse.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView(
            children: snapshot.data.docs.map((document) {
              return Container(
                child: Center(child: Text(document['type'] + ": " + document['score']))
              );
            }).toList(),
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Personal Grade Book"),
      ),
      body: Container(
        child: Column(
            children: [
            gradeTextFieldWidget(),
            TextFieldWidget(),
            addtoDatabase(),
              itemListWidget()
          ],

      ),
      ),

    );
  }



  }
