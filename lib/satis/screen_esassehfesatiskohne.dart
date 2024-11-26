import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zs_satis/anbar/model_mehsullar.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/databases/slq_database.dart';
import 'package:zs_satis/musteriler/model_musteriler.dart';
import 'package:zs_satis/satis/model_satis.dart';

import 'widget_musteriler.dart';
import 'widget_satis.dart';

class ScreenEsasSehfeSatis extends StatefulWidget {
  String gonderis;
  ModelMusteriler model_musteri = ModelMusteriler(isclecked: false);

  ScreenEsasSehfeSatis(
      {Key? key, required this.gonderis, required this.model_musteri})
      : super(key: key);

  @override
  _ScreenEsasSehfeSatisState createState() => _ScreenEsasSehfeSatisState();
}

class _ScreenEsasSehfeSatisState extends State<ScreenEsasSehfeSatis> {
  bool gonderis = false;
  ModelMusteriler? selected_musteri = ModelMusteriler(isclecked: false);
  List<ModelMusteriler> list_musteriler = [];
  List<ButtonList> list_sifarisler = [];
  List<ModelSatis> list_secilensifarisler = [];
  bool ismusteriselected = false;
  bool backgoster = false;

  @override
  void initState() {
    SqlDatabase.db.init();
    getDataMehsullarFromDp();
    if (widget.gonderis == "esas") {
      setState(() {
        backgoster = false;
        ismusteriselected = false;
        selected_musteri = ModelMusteriler(isclecked: false);
        gonderis = true;
      });
    } else {
      setState(() {
        backgoster = true;
        ismusteriselected = true;
        selected_musteri = widget.model_musteri;
        gonderis = false;
      });
    }
    setArraylistSifarisler();

    // TODO: implement initState
    super.initState();
  }

  setArraylistSifarisler() {
    list_sifarisler = [];
    ButtonList button = ButtonList(
      modelSatis: ModelSatis(mehsulkodu: "Mehsul elave et"),
      color: Colors.green,
      icon: Icon(
        Icons.add_circle_outlined,
      ),
      isvisible: true,
    );
    list_sifarisler.add(button);
    for (int i = 0; i < list_secilensifarisler.length; i++) {
      setState(() {
        ModelSatis model = list_secilensifarisler.elementAt(i);
        list_sifarisler.add(ButtonList(
          modelSatis: model,
          color: Colors.red,
          icon: Icon(
            Icons.remove_circle_outlined,
          ),
          isvisible: false,
        ));
      });
    }
  }

  Future getDataMehsullarFromDp() async {
    list_musteriler.clear();
    ModelMusteriler modelMehsullar =
        ModelMusteriler(musteriadi: "Musteri sec", isclecked: false);
    list_musteriler.add(modelMehsullar);
    await SqlDatabase.db.getAllMusteriler().then((value) => {
          value.forEach((element) {
            list_musteriler.add(element);
          })
        });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: ismusteriselected ? true : false,
        leading: backgoster
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_outlined,
                ))
            : SizedBox(),
        title: Padding(
          padding: EdgeInsets.only(left: 0),
          child: Text("Yeni satis"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, top: 20),
        child: Column(
          children: [
            widgetMusteriAdi(),
            Container(
              height: SizeConfig.screenHeight! *0.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green)),
              child: ListView.builder(
                  itemCount: list_sifarisler.length,
                  itemBuilder: (context, index) {
                    return widgetMallarListi(list_sifarisler.elementAt(index));
                  }),
            )
          ],
        ),
      ),
    );
  }

  Container widgetMusteriAdi() {
    return ismusteriselected
        ? Container(
            padding: EdgeInsets.only(left: 15, right: 5, top: 5, bottom: 5),
            margin: EdgeInsets.all(5),
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                border: Border.all(color: Colors.grey)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(selected_musteri!.musteriadi.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: SizeConfig.textsize16SP,
                        fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        ismusteriselected = false;
                      });
                    },
                    icon: Icon(
                      Icons.remove_circle_outlined,
                      color: Colors.red,
                    ))
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.only(left: 15, right: 5, top: 5, bottom: 5),
            margin: EdgeInsets.all(5),
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                border: Border.all(color: Colors.grey)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Musteri secin",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: SizeConfig.textsize16SP,
                        fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => WidgetMusteriler(
                                getselectedmusteri: (ModelMusteriler musteri) {
                                  setState(() {
                                    print("selected :" +
                                        musteri.musteriadi.toString());
                                    selected_musteri = musteri;
                                    ismusteriselected = true;
                                  });
                                },
                              )));
                    },
                    icon: Icon(
                      Icons.add_circle_outlined,
                      color: Colors.green,
                    ))
              ],
            ),
          );
  }

  Container widgetMallarListi(ButtonList list) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 5, top: 2, bottom: 2),
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.grey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(list.modelSatis!.mehsulkodu.toString()+" -  "+list.modelSatis!.satismiqdari.toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: SizeConfig.textsize14SP,
                      fontWeight: FontWeight.bold)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (list.modelSatis!.mehsulkodu == "Mehsul elave et") {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WidgetSatish(
                              fakturaId: "",
                                  musterikodu:
                                      selected_musteri!.carikod.toString(),
                                  getselectedsifaris: (ModelSatis musteri) {
                                    setState(() {
                                      list_sifarisler.add(ButtonList(
                                        modelSatis: musteri,
                                        color: Colors.red,
                                        icon: Icon(
                                          Icons.remove_circle_outlined,
                                        ),
                                        isvisible: true,
                                      ));
                                    });
                                  },
                                )));
                      } else {
                        list_sifarisler.remove(list);
                      }
                    });
                  },
                  icon: Icon(
                    list.icon!.icon,
                    color: list.color,
                  ))
            ],
          ),
          Divider(
            height: 1,
          ),
          list.modelSatis!.mehsulkodu == "Mehsul elave et"
              ? SizedBox()
              : Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "Total Satış : " +
                              list.modelSatis!.satissumma.toString(),
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: SizeConfig.textsize12SP,
                            fontWeight: FontWeight.normal,
                          )),
                      Text(
                          "Endirim  : " +
                              list.modelSatis!.satisendirim.toString(),
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: SizeConfig.textsize12SP,
                            fontWeight: FontWeight.normal,
                          )),
                      Text(
                          "Net satis  : " +
                              list.modelSatis!.netsatis!.toStringAsFixed(2),
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: SizeConfig.textsize12SP,
                            fontWeight: FontWeight.normal,
                          )),
                      Text(
                          "Xeyir  : " +
                              list.modelSatis!.satisxeyir!.toStringAsFixed(2),
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: SizeConfig.textsize12SP,
                            fontWeight: FontWeight.normal,
                          )),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}

class ButtonList {
  ButtonList({
    this.modelSatis,
    this.icon,
    this.color,
    required this.isvisible,
  });

  ModelSatis? modelSatis;
  Icon? icon;
  Color? color;
  bool isvisible = false;
}
