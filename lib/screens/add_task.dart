import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/screens/home_screen.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final titleCon = TextEditingController();
  final desCon = TextEditingController();
  final databaseFirestore = FirebaseFirestore.instance.collection('task');


  addTaskToFirebase()async{
    final auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    String uid = user.uid!;
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    await databaseFirestore.doc(uid).collection('mytask').doc(id).set({
      'id' : id,
      'title' : titleCon.text.toString(),
      'description' : desCon.text.toString(),
      'time' : DateTime.now(),
    });
    Fluttertoast.showToast(msg: 'data added');
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("New Task"),
        centerTitle: true,
      ),
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            SizedBox(height: height*0.04,),
            TextFormField(
              controller: titleCon,
              keyboardType: TextInputType.text,
              validator: (value) {
                if(value!.isEmpty){
                  return 'please enter a title';
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: 'enter title',
                  labelStyle: GoogleFonts.roboto(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: new BorderSide(),
                  )
              ),
            ),
            SizedBox(height: height*0.03,),
            TextFormField(
              controller: desCon,
              keyboardType: TextInputType.text,
              maxLines: 4,
              validator: (value) {
                if(value!.isEmpty){
                  return 'enter a description username';
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: 'enter description',
                  hintStyle: GoogleFonts.roboto(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: new BorderSide(),
                  )
              ),
            ),
            SizedBox(height: height*0.03,),
            InkWell(
              onTap: (){
                addTaskToFirebase();
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8)),
                  height: height * .05,
                  width: width,
                  margin: EdgeInsets.symmetric(vertical: height*0.02,horizontal: width*.3),
                  child: Center(child: Text('Add Task',style: GoogleFonts.roboto()),)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
