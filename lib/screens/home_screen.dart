import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/auth/auth_screen.dart';
import 'package:todo/screens/add_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/screens/description.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance;
  String uid = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
  }
  getUid()async{
    final auth = FirebaseAuth.instance;
    User user = await auth.currentUser!;
    setState(() {
      uid = user.uid;
    });
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Todo'),
          actions: [
            IconButton(onPressed: (){
              _auth.signOut().then((value) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen(),));
              }).onError((error, stackTrace) {
                print(error.toString());
              });
            }, icon: Icon(Icons.logout)),
            SizedBox(width: width * 0.02,)
          ],
        ),
        body: Container(
          height: height,
          width: width,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('task').doc(uid).collection('mytask').snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }else{
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var time = (snapshot.data!.docs[index]['time'] as Timestamp).toDate();
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Description(
                              title: snapshot.data!.docs[index]['title'].toString(),
                              description: snapshot.data!.docs[index]['description'].toString()),));
                        },
                        child: Container(
                          height: height*.15,
                          width: width,
                          margin: EdgeInsets.all(height*0.02),
                          padding: EdgeInsets.all(height*0.02),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(snapshot.data!.docs[index]['title'].toString(),style: GoogleFonts.roboto(fontSize: 22),),
                                  SizedBox(height: height*0.01,),
                                  Text(DateFormat.yMd().add_jm().format(time),style: GoogleFonts.roboto(fontSize: 11),),
                                ],
                              ),
                              IconButton(onPressed: ()async{
                                await FirebaseFirestore.instance.collection('task').doc(uid).collection('mytask').doc(snapshot.data!.docs[index]['id'].toString()).delete();
                              }, icon: Icon(Icons.delete, color: Colors.white,))
                            ],
                          ),
                        ),
                      );
                    },
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewTaskScreen(),));
          },
          child: Icon(Icons.add,color: Colors.white),
          elevation: 5,
          backgroundColor: Colors.purple,
        ),
      ),
    );
  }
}
