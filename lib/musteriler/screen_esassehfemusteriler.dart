import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zs_satis/constandlar/sablom_suzler.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/databases/slq_database.dart';
import 'package:zs_satis/satis/screen_esassehfesatis.dart';
import 'model_musteriler.dart';
import 'screnn_yenimusteriyarat.dart';

class ScreenEsasSehfeMusteriler extends StatefulWidget {
  const ScreenEsasSehfeMusteriler({Key? key}) : super(key: key);

  @override
  _ScreenEsasSehfeMusterilerState createState() =>
      _ScreenEsasSehfeMusterilerState();
}

class _ScreenEsasSehfeMusterilerState extends State<ScreenEsasSehfeMusteriler> {
  List<ModelMusteriler> list_musteriler = [];
  bool melumattapildi = false;
  List<ButtonList>? buttonList;

  @override
  void initState() {
    SqlDatabase.db.init();
    _getDataAllMusteriler();
    setButtonListArray();
    // TODO: implement initState
    super.initState();
  }

  void setButtonListArray() {
    buttonList = [];
    ButtonList button = ButtonList(
      labelName: "Satis et",
      color: Colors.deepPurple,
      imageName: "images/sales.png",
      isAssetsImage: true,
    );
    buttonList!.add(button);
    ButtonList button_anbar = ButtonList(
      labelName: "Hesabat",
      color: Colors.lightBlue,
      imageName: "images/forecast.png",
      isAssetsImage: true,
    );
    buttonList!.add(button_anbar);
    ButtonList bt_delete = ButtonList(
      color: Colors.red,
      labelName: "Sil",
      imageName: "images/delete.png",
      isAssetsImage: true,
    );
    buttonList!.add(bt_delete);
    ButtonList bt_edit = ButtonList(
      color: Colors.green,
      labelName: "Duzelt",
      imageName: "images/edit.png",
      isAssetsImage: true,
    );
    buttonList!.add(bt_edit);
  }

  Future _getDataAllMusteriler() async {
    list_musteriler.clear();
    await SqlDatabase.db.getAllMusteriler().then((value) => {
          if (value.isNotEmpty)
            {
              setState(() {
                melumattapildi = true;
              }),
              value.forEach((element) {
                list_musteriler.add(element);
              })
            }
        });
  }

  _deleteMusteriFromDb(ModelMusteriler modelMusteriler) async {
    await SqlDatabase.db
        .deleteMusteriByCkod(modelMusteriler.carikod.toString())
        .whenComplete(() => {
              setState(() {
                _getDataAllMusteriler();
                setButtonListArray();
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RefreshIndicator(
      color: Colors.green,
      backgroundColor: Colors.white,
      onRefresh: () {
        return _getDataAllMusteriler();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ScreenYeniMusteriYarat(
                      callToRefresh: () {
                        setState(() {
                          _getDataAllMusteriler();
                          setButtonListArray();
                        });
                      },
                    )));
          },
          elevation: 2,
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
          title: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            margin: EdgeInsets.only(
              left: 40,
              top: 10,
              bottom: 10,
            ),
            alignment: Alignment.center,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: Icon(Icons.search),
                hintText: Shablomsozler().axtarisedin,
              ),
            ),
          ),
        ),
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverToBoxAdapter(
              child: wirgetBasliq(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return widgetitemsMusteriler(
                      list_musteriler.elementAt(index));
                },
                childCount: list_musteriler.length, // 1000 list items
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container wirgetBasliq() {
    return Container(
      margin: EdgeInsets.all(8.0),
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.black87)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 5),
            margin: EdgeInsets.all(5),
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15)),
                border: Border.all(color: Colors.grey)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Umumi Musteriler  : " + list_musteriler.length.toString(),
                    textAlign: TextAlign.left,
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: SizeConfig.textsize16SP,
                        fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.forward,
                      color: Colors.grey,
                    ))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            margin: EdgeInsets.only(left: 5, right: 5),
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15)),
                border: Border.all(color: Colors.green)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Aktivler  : 0 ",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.lato(
                        color: Colors.green,
                        fontSize: SizeConfig.textsize16SP,
                        fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.forward,
                      color: Colors.green,
                    ))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15)),
                border: Border.all(color: Colors.redAccent)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Passivler : 0 ",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.lato(
                        color: Colors.redAccent,
                        fontSize: SizeConfig.textsize16SP,
                        fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.forward,
                      color: Colors.redAccent,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // customButton(context, "Yeni Qrup Yarat", Icons.group_work, 0.43),
                SizedBox(
                  width: 0,
                ),
                // customButtonyenimal(context, "Yeni Mehsul Yarat", Icons.add, 0.43)
              ],
            ),
          ),
        ],
      ),
    );
  }

  InkWell widgetitemsMusteriler(ModelMusteriler model) {
    return InkWell(
      onTap: () {
        setState(() {
          if (model.isclecked) {
            model.isclecked = false;
          } else {
            model.isclecked = true;
          }
        });
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.green,
                        width: 2,
                        style: BorderStyle.solid)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Cari kod : " + model.carikod.toString(),
                          style: GoogleFonts.lato(
                              fontSize: SizeConfig.textsize12SP,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.person_pin_outlined,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          " " + model.musteriadi.toString().toUpperCase(),
                          style: GoogleFonts.lato(
                              fontSize: SizeConfig.textsize16SP,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 1, left: 30, bottom: 5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.place,
                            color: Colors.blue,
                            size: 10,
                          ),
                          Text(
                            " " + model.tamunvan.toString().toUpperCase(),
                            style: GoogleFonts.lato(
                                fontSize: SizeConfig.textsize10SP,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(model.umumisatis!.toStringAsFixed(2) + " ₼",
                                  style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontSize: SizeConfig.textsize14SP,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 3,
                              ),
                              Text("Total satis".toUpperCase(),
                                  style: GoogleFonts.lato(
                                      color: Colors.green,
                                      fontSize: SizeConfig.textsize12SP,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10, top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("500.00 ₼",
                                  style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontSize: SizeConfig.textsize14SP,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 3,
                              ),
                              Text("Total KASSA".toUpperCase(),
                                  style: GoogleFonts.lato(
                                      color: Colors.green,
                                      fontSize: SizeConfig.textsize12SP,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10, top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(model.umumixeyir!.toStringAsFixed(2)+" ₼",
                                  style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontSize: SizeConfig.textsize14SP,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 3,
                              ),
                              Text("Total Xeyir".toUpperCase(),
                                  style: GoogleFonts.lato(
                                      color: Colors.green,
                                      fontSize: SizeConfig.textsize12SP,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    model.isclecked ? Divider(
                            height: 1,
                          ) : SizedBox(),
                    model.isclecked ? Container(
                            height: 75,
                            width: SizeConfig.screenWidth,
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.only(bottom: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                //   border: Border.all(color: Colors.black87),
                                // color: Colors.deepPurple.withOpacity(0.5)),
                                color: Colors.green),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: buttonList!.length,
                                itemBuilder: (context, index) {
                                  return inkwell_itembt(
                                      buttonList!.elementAt(index), model);
                                }),
                          ) : SizedBox(),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Text("Qaliq :"+model.sonborc!.toStringAsFixed(2)+" ₼",
                    style: GoogleFonts.lato(
                        color: Colors.red,
                        fontSize: SizeConfig.textsize14SP,
                        fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget inkwell_itembt(ButtonList listData, ModelMusteriler model) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.red.withOpacity(0.8),
        highlightColor: Colors.transparent,
        onTap: () {
          if (listData.labelName == "Satis et") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ScreenEsasSehfeSatis(
                  callBacka: (){},
                      model_musteri: model,
                      gonderis: "cari",
                    )));
          } else if (listData.labelName == "Sil") {
            _deleteMusteriFromDb(model);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 2.5,
                  color: Colors.white38,
                  offset: Offset(2, 2),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 2,
                  ),
                  listData.isAssetsImage
                      ? Container(
                          height: 30,
                          width: 60,
                          child: Image.asset(
                            listData.imageName,
                            color: listData.color,
                            width: 20,
                            height: 30,
                          ),
                        )
                      : Icon(
                          listData.icon!.icon,
                          size: 10,
                          color: listData.color,
                        ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(listData.labelName,
                      style: GoogleFonts.lato(
                          fontSize: SizeConfig.textsize12SP,
                          color: listData.color,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _callBack(){
    _getDataAllMusteriler();
    setButtonListArray();
  }

}


class ButtonList {
  ButtonList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.color,
    this.imageName = '',
    this.isvisible = false,
  });

  String labelName;
  Icon? icon;
  Color? color;
  bool isAssetsImage;
  String imageName;
  bool? isvisible;
}
