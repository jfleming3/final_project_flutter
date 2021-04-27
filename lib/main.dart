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
  final CollectionReference itemCollectionDB = FirebaseFirestore.instance.collection('grades');
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
            await itemCollectionDB.add({_gradetypeTextField.text: _newItemTextField.text}).then((value) => _newItemTextField.clear());
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
        StreamBuilder(stream: itemCollectionDB.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int position) {
                    return Card(
                        child: itemTileWidget(snapshot,position)
                    );
                  }
              );
            })
    );
  }

  Widget itemTileWidget(snapshot, position) {
    return ListTile(

      title: Text(snapshot.data.docs[position]['item_name']),

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
