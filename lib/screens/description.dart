import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Description extends StatelessWidget {
  const Description({super.key, required this.title, required this.description});

  final String title , description;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
       appBar: AppBar(
         title: Text("Description"),
         centerTitle: true,
       ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Center(child: Text(title,style: GoogleFonts.roboto(fontSize: 30,fontWeight: FontWeight.bold))),
            ),
            Container(
              margin: EdgeInsets.only(top: 15,left: 10),
              child: Text(description,style: GoogleFonts.roboto(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
