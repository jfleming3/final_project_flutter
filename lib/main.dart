
import 'package:final_project_flutter/grade.dart';

import 'package:final_project_flutter/grade.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'constants.dart';


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

    if(grade >= 93){
      return Image(image: AssetImage("images/A.png"),height: 80,width: 50,);
   } else if(grade >= 90){
      return Image(image: AssetImage("images/A-.png"),height: 80,width: 50,);
    } else if(grade >= 88){
      return Image(image: AssetImage("images/B+.png"),height: 80,width: 50,);
    } else if(grade >= 83){
      return Image(image: AssetImage("images/B.png"),height: 80,width: 50,);
    } else if(grade >=80){
      return Image(image: AssetImage("images/B-.png"),height: 80,width: 50,);
    } else if(grade >= 78){
      return Image(image: AssetImage("images/C+.png"),height: 80,width: 50,);
    } else if(grade >= 73){
      return Image(image: AssetImage("images/C.png"),height: 80,width: 50,);
    } else if(grade >= 70){
      return Image(image: AssetImage("images/C-.png"),height: 80,width: 50,);
    } else if(grade >= 60){
      return Image(image: AssetImage("images/D.png"),height: 80,width: 50,);
    } else{
      return Image(image: AssetImage("images/F.png"),height: 80,width: 50,);
    }

  }



  bool pressed = false;
  bool calcpressed = false;

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
            ElevatedButton(
              onPressed: (){
                String grade = calcGrades(itemList).toString();
                showDialog(
                    context: context,
                    builder: (context){
                      return Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                        elevation: 16,
                        child: Container(
                          height: 150,
                          width: 150,
                          child: Column(
                            children: [
                              SizedBox(height: 15,),
                              Text('Final Calculated Grade',style: TextStyle(fontSize: 25,color: Colors.blue,fontWeight: FontWeight.bold),),
                              SizedBox(height: 37,),
                              Text(grade + '%', style: TextStyle(fontSize: 24,color: Colors.black,)),
                            ],
                          ),
                        ),
                      );
                    });

              },
              child: Text(
                "Calculate grade",
                style: TextStyle(fontSize: 20),
              ),
            ),
            pressed ? itemListWidget() : SizedBox(height: 1,),

          ],

        ),

      ),

    );
  }



  Widget contentBox(String grade){
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: Constants.padding,top: Constants.avatarRadius
              + Constants.padding, right: Constants.padding,bottom: Constants.padding
          ),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Final Calculated Grade',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),
              Text(grade + "%",style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
              SizedBox(height: 22,),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    onPressed: (){
                    setState(() {
                      calcpressed = false;
                    });
                    },
                    child: Text("Close",style: TextStyle(fontSize: 18),)),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset("images/A.png")
            ),
          ),
        ),
      ],
    );
  }


  }


