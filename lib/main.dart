
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
      home: FirebaseApp(),
    );
  }
}

class FirebaseApp extends StatefulWidget {
  @override
  _FirebaseState createState() => _FirebaseState();
}

class _FirebaseState extends State<FirebaseApp> {
  final TextEditingController _newItemTextField = TextEditingController();
  final TextEditingController _gradetypeTextField = TextEditingController();
  final CollectionReference databse = FirebaseFirestore.instance.collection('grades');
  String buttontext = "Show all grades";





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


String grade = "CALC";
  Widget showgradeButton(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
              ElevatedButton(
                  onPressed: ()  {
                    pressed ? setState(() {
                       pressed = false;
                       buttontext = "Show all grades";
                      }) : setState((){pressed = true; buttontext = "Hide all grades";});
                  },
                  child: Text(
                    buttontext,
                    style: TextStyle(fontSize: 20),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    final String name = _gradetypeTextField.text;
                    final String score = _newItemTextField.text;
                    final gradeModel grade = gradeModel(type: name, score: score);
                    await databse.add(grade.toMap());
                  },
                  child: Text(
                    'Add Grade',
                    style: TextStyle(fontSize: 20),
                  )),
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    grade = (calcGrades(itemList).toStringAsFixed(1) + '%');
                  });
                },
                child: Text(
                  grade,
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
      ),
    );
  }





  List<String> itemList = [];

  Widget itemListWidget() {
    return Expanded(
      child:
      StreamBuilder(stream: databse.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView(
            children: snapshot.data.docs.map((document)
            {
              String grades = document['type'] + ": " + document['score'];
              itemList.add(document['score']);
              Image icon = getcorrectIcon(document['score']);
              return Container(
                child: ListTile(

                  leading: icon,

                  title: Text(grades, style: TextStyle(fontSize: 20),)

                ) );
            }).toList(),
          );
        },
       ),
      );
  }


  double calcGrades(List<String> itemList){
    int gradeTop= 0;
    int gradeBottom = 0;
    int temp;
    String first;
    String last;
    for(var index in itemList){
      temp = index.indexOf('/');
      first = index.substring(0,temp);
      last = index.substring(temp + 1 ,index.length-1);
      gradeTop+= int.parse(first);
      gradeBottom+= int.parse(last);
    }
    return (gradeTop/gradeBottom) * 10;

  }

  Image getcorrectIcon(String score){
    int index = score.indexOf('/');
    String top = score.substring(0,index);
    String bot = score.substring(index + 1, score.length-1);
    int gradetop = int.parse(top);
    int gradebot = int.parse(bot);
    double grade = (gradetop/gradebot) * 10;

    if(grade >= 90){
      return Image(image: AssetImage("images/A.png"),height: 100,width: 50,);
   } else if(grade >= 88){                                              
      return Image(image: AssetImage("images/B+.png"),height: 100,width: 50,);
    } else if(grade >= 83){
      return Image(image: AssetImage("images/B.png"),height: 100,width: 50,);
    } else if(grade >= 78){
      return Image(image: AssetImage("images/C+.png"),height: 100,width: 50,);
    } else if(grade >=73){
      return Image(image: AssetImage("images/C.png"),height: 100,width: 50,);
    } else if(grade >= 70){
      return Image(image: AssetImage("images/C-.png"),height: 100,width: 50,);
    } else if(grade >= 67){
      return Image(image: AssetImage("images/D+.png"),height: 100,width: 50,);
    } else{
      return Image(image: AssetImage("images/F.png"),height: 100,width: 50,);
    }

  }



  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Personal Grade Book"),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.jpg"),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            gradeTextFieldWidget(),
            TextFieldWidget(),
            SizedBox(height: 40,),
            showgradeButton(),
            pressed ? itemListWidget() : SizedBox(height: 1,),
          ],

        ),

      ),

    );
  }




  }


