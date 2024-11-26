import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zs_satis/anbar/model_qrup.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/databases/slq_database.dart';

import 'esas_sehfeanbaranaqrup.dart';

class ScreenYeniQrup extends StatefulWidget {
  Function callBack;
  ScreenYeniQrup({Key? key,required this.callBack}) : super(key: key);

  @override
  _ScreenYeniQrupState createState() => _ScreenYeniQrupState();
}

class _ScreenYeniQrupState extends State<ScreenYeniQrup> {
  TextEditingController cn_yeniQrupadi = TextEditingController();
  TextEditingController cn_yeniQrupqeyd = TextEditingController();

  var cn_yeniQrupstocksayi;

  Future _melumatidaxilet(ModelQrupadi modelQruplar) async {
    await SqlDatabase.db.addAnbarQrupToDb(modelQruplar).whenComplete(() => {
    Fluttertoast.showToast(
    msg: "Melumat ugurla daxil edildi.",
    toastLength: Toast.LENGTH_LONG),
  //  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ScreenEsasSehfeAnbarAnaqrup()))
    Navigator.pop(context),
      widget.callBack.call(),
    });
  }

  @override
  void initState() {
    SqlDatabase.db.init();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: Text(
            "Yeni Qrup elave et".toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
            const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextField(
                  style: TextStyle(fontSize: SizeConfig.textsize12SP),
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                        fontSize: SizeConfig.textsize18SP, color: Colors.green),
                    labelText: "Qrup adı",
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    border: InputBorder.none,
                  ),
                  controller: cn_yeniQrupadi,
                ), //Qrupun adi
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  style: TextStyle(fontSize: SizeConfig.textsize12SP),
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    labelStyle: TextStyle(
                        fontSize: SizeConfig.textsize18SP, color: Colors.green),
                    labelText: "Qeyd",
                    border: InputBorder.none,
                  ),
                  controller: cn_yeniQrupqeyd,
                ), //qeyd
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      ModelQrupadi model = ModelQrupadi(
                          qruphaqqinda: cn_yeniQrupqeyd.text,
                          qrupAdi: cn_yeniQrupadi.text);
                      _melumatidaxilet(model);
                    },
                    child: Text("Daxil et"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
