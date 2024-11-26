import 'package:flutter/material.dart';
import 'package:zs_satis/constandlar/app_theme.dart';
import 'package:zs_satis/constandlar/sablom_suzler.dart';

import 'companiyaqeydiyyat_screen.dart';
import 'localqeydiyyat_screen.dart';
import 'qlobalqeydiyyat_screen.dart';

class QeydiyyatSecimiScreen extends StatefulWidget {
  const QeydiyyatSecimiScreen({Key? key}) : super(key: key);

  @override
  _QeydiyyatSecimiScreenState createState() => _QeydiyyatSecimiScreenState();
}

class _QeydiyyatSecimiScreenState extends State<QeydiyyatSecimiScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bacgroundimageqeydiyyat.jpg"),
                fit: BoxFit.cover,
                opacity: 180
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/zs5.png",
                        height: 100,
                        width: 100,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Shablomsozler().appname,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 24),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            Shablomsozler().appsecondtile.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            Shablomsozler().appcreater.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50,right: 50),
                    child: Divider(height: 1,color: Colors.green,thickness: 2,),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  customButton(Shablomsozler().basliqferdionline, () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LocalQeydiyyatScreen()));
                  }, 0,
                      "images/local_phone.png"),
                  customButton(Shablomsozler().basliqferdionline, () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const QlobalQeydiyyatScreen()));
                  }, 1,
                      "images/global_ferdi.png"),
                  customButton(Shablomsozler().basliqkompaniya, () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ComppaniyaQeydiyyatScreen()));
                  }, 2,
                      "images/global_hesab.png"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customButton(String title, Function onclick, int tip, String imageling) {
    return InkWell(
      onTap: (){onclick();},
      hoverColor: Colors.grey,
      child: Ink(
        child: Container(
          padding: EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: tip == 0
                      ? Colors.grey
                      : tip == 1
                          ? Colors.red
                          : Colors.blue),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: tip == 0
                        ? Colors.grey
                        : tip == 1
                            ? Colors.red
                            : Colors.blue,
                    offset: Offset(2, 2),
                    blurRadius: 5,
                    spreadRadius: 0.5)
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                imageling,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  Container()
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: tip == 0
                    ? Colors.grey
                    : tip == 1
                        ? Colors.red
                        : Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }
}
