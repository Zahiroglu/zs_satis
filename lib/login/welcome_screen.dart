
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zs_satis/constandlar/app_theme.dart';
import 'package:zs_satis/esas_sehfe/screen/screen_esassehfe.dart';
import 'package:zs_satis/login/qeydiyyatsecimi_screen.dart';

import 'modelsladerwelcome.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<SliderModel> mySLides = [];
  int slideIndex = 0;
  late PageController controller;

  Widget _buildPageIndicator(bool isCurrentPage){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySLides = getSlides();
    controller = new PageController();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff3C8CE7), Color(0xff00EAFF)])),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                slideIndex = index;
              });
            },
            children: <Widget>[
              SlideTile(
                imagePath: mySLides[0].getImageAssetPath()!,
                title: mySLides[0].getTitle()!,
                desc: mySLides[0].getDesc()!,
              ),
              SlideTile(
                imagePath: mySLides[1].getImageAssetPath()!,
                title: mySLides[1].getTitle()!,
                desc: mySLides[1].getDesc()!,
              ),
              SlideTile(
                imagePath: mySLides[2].getImageAssetPath()!,
                title: mySLides[2].getTitle()!,
                desc: mySLides[2].getDesc()!,
              )
            ],
          ),
        ),
        bottomSheet: slideIndex != 2 ? Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor:Colors.blue[50],elevation: 10),
                onPressed: (){
                  controller.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.linear);
                },
                child: const Text(
                  "KEC",
                  style: TextStyle(color: Color(0xFF0074E4), fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    for (int i = 0; i < 3 ; i++) i == slideIndex ? _buildPageIndicator(true): _buildPageIndicator(false),
                  ],),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green,elevation: 10),
                onPressed: (){
                  controller.animateToPage(slideIndex + 1, duration: Duration(milliseconds: 500), curve: Curves.linear);
                },
               // splashColor: Colors.blue[50],
                child: Text(
                  "SONRAKI",
                  style: TextStyle(color: Color(0xFF0074E4), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ): InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (cintext)=>QeydiyyatSecimiScreen()));
          },
          child: Container(
            height: 60,
            color: Colors.green,
            alignment: Alignment.center,
            child: Text(
              "QEYDIYYATDAN KEC",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  String imagePath, title, desc;

  SlideTile({required this.imagePath, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(imagePath,height: 150,width: 150,fit: BoxFit.cover,),
          const SizedBox(
            height: 40,
          ),
          Text(title, textAlign: TextAlign.center,style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
          ),),
          const SizedBox(
            height: 20,
          ),
          Text(desc, textAlign: TextAlign.start,style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 15,
          letterSpacing: 0.2,
          wordSpacing: 2))
        ],
      ),
    );
  }
}