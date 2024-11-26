import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constandlar/sablom_suzler.dart';

class CustomAlert extends StatefulWidget {
  String textinfo;
  IconData icon;
  Color color;
  CustomAlert({Key? key,required this.textinfo,required this.icon,required this.color}) : super(key: key);

  @override
  _CustomAlertState createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> {
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      elevation: 5,
      actionsAlignment: MainAxisAlignment.center,
      title:   Icon(widget.icon,color: widget.color,size: 40,),
      content: SingleChildScrollView(
        child: ListBody(
          children:  <Widget>[

            Text(
              widget.textinfo,style: TextStyle(height: 1.5),
            textAlign: TextAlign.center,),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child:  Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
