import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zs_satis/anbar/model_mehsullar.dart';
import 'package:zs_satis/anbar/model_qrup.dart';
import 'package:zs_satis/constandlar/sablom_suzler.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/databases/slq_database.dart';
import 'package:zs_satis/satis/model_satis.dart';
import 'package:zs_satis/satis/modul_expendedlist/model_block.dart';
import 'package:zs_satis/satis/son_model/datablock_satis.dart';

class WidgetSatishExpended extends StatefulWidget {
  Function(List<ModelSatis>) getselectedsifaris;
  String musterikodu;
  String fakturaId;

  WidgetSatishExpended(
      {Key? key,
      required this.getselectedsifaris,
      required this.musterikodu,
      required this.fakturaId})
      : super(key: key);

  @override
  _WidgetSatishExpendedState createState() => _WidgetSatishExpendedState();
}

class _WidgetSatishExpendedState extends State<WidgetSatishExpended> with SingleTickerProviderStateMixin {
  List<ModelQrupadi> listAnaqruplar = [];
  List<ModelMehsullar> listMehsullar = [];
  final modelblock = ModelBlock();
  bool melumattapildi = false;
  int selectedcollapsing = 0; //attention

  @override
  void initState() {
    SqlDatabase.db.init();
    getDataFromDpAnaqrup();
    selectedcollapsing = -1;
    // TODO: implement initState
    super.initState();
  }

  Future getDataFromDpAnaqrup() async {
    await SqlDatabase.db.getAllMallar().then((value) => {
          value.forEach((element) {
            listMehsullar.add(element);
          })
        });
    getAllAnaQruplar();
  }

  Future getAllAnaQruplar() async {
    await SqlDatabase.db.getAllAnaQruplar().then((value) => {
          value.forEach((anaqrup) {
            if (value.isNotEmpty) {
              melumattapildi = true;
              listAnaqruplar.add(anaqrup);
            }
          })
        });
    setState(() {
      modelblock.init(this, listAnaqruplar, listMehsullar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white24,
        iconTheme: IconThemeData(color: Colors.green),
        automaticallyImplyLeading: true,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              widget.getselectedsifaris.call(modelblock.sales);
            },
            child: Container(
                margin: EdgeInsets.only(top: 10,bottom: 10,right: 5),
                decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "ELAVE ET",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),
                  ),
                )),
          )
        ],
        title:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("SATIS",style: TextStyle(fontSize: 16,color: Colors.green,fontWeight: FontWeight.bold),),
            Text("Umumi Ana Qrup : "+modelblock.items.length.toString(),style: TextStyle(fontSize: 14,color: Colors.green,fontWeight: FontWeight.normal),),
          ],
        ),
      ),
      body: melumattapildi
          ? Column(
              children: [
                Divider(height: 1,color: Colors.grey,),
                Expanded(
                  child: AnimatedBuilder(
                    animation: modelblock,
                    builder: (_, __) => ListView.builder(
                        itemCount: modelblock.items.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            backgroundColor: Colors.grey.withOpacity(0.4),
                            key: Key(index.toString()),
                            initiallyExpanded:
                                modelblock.items.elementAt(index).selected,
                            //attention
                            onExpansionChanged: (newState) {
                              if (newState) {
                                setState(() {
                                  modelblock.onCateqoryClecked(index, true);
                                });
                              } else {
                                setState(() {
                                  modelblock.onCateqoryClecked(index, false);
                                });
                              }
                            },
                            textColor: Colors.green,
                            collapsedTextColor: Colors.black,
                            maintainState: true,
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    modelblock.items
                                            .elementAt(index)
                                            .catogory
                                            .qrupAdi
                                            .toString() +
                                        " - " +
                                        modelblock.items
                                            .elementAt(index)
                                            .catogory
                                            .cesidSayi
                                            .toString() +
                                        " cesid",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            subtitle:
                                    Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black,
                                                  offset: Offset(1, 1),
                                                  blurStyle: BlurStyle.outer,
                                                  blurRadius: 3)
                                            ]),
                                        width: double.infinity,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: Text(
                                                modelblock.items.elementAt(index).totalbrut != null ? modelblock.items.elementAt(index).totalbrut! > 0?"Total satis : " + modelblock.items.elementAt(index).totalbrut.toString():"Total satis : 0":"Total satis : 0",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: Text(
                                                modelblock.items.elementAt(index).totalendirim != null ? modelblock.items.elementAt(index).totalendirim! > 0?"Total endirim : " + modelblock.items.elementAt(index).totalbrut.toString():"Total endirim : 0":"Total endirim : 0",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: Text(
                                                modelblock.items.elementAt(index).totalnestsatis != null ? modelblock.items.elementAt(index).totalnestsatis! > 0?"Total net satis : " + modelblock.items.elementAt(index).totalbrut.toString():"Total net satis : 0":"Total net satis : 0",

                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  children: _buildExpandableContent(
                                      modelblock.items.elementAt(index)),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ),
                // modelblock.grantbrut > 0
                //     ? Container(
                //   padding: const EdgeInsets.all(5),
                //   width: double.infinity,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     children: [
                //       Column(
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         crossAxisAlignment: CrossAxisAlignment.end,
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.all(2.0),
                //             child: Text(
                //               "Total satis : " +
                //                   modelblock.grantbrut.toStringAsFixed(2),
                //             ),
                //           ),
                //           SizedBox(height: 2,),
                //           Padding(
                //             padding: const EdgeInsets.all(2.0),
                //             child: Text(
                //               "Total endirim : " +
                //                   modelblock.grantendirim
                //                       .toStringAsFixed(2),
                //             ),
                //           ),
                //           SizedBox(height: 3,),
                //           Padding(
                //             padding: const EdgeInsets.all(2.0),
                //             child: Text("Total net satis : " +
                //                 modelblock.grantennetsatis
                //                     .toStringAsFixed(2),style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // )
                //     : const SizedBox(),
                SizedBox(height: 2,),
                Divider(height: 1,color: Colors.grey,),
                Container(
                  padding: const EdgeInsets.all(5),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              "Total satis : " +
                                  modelblock.grantbrut.toStringAsFixed(2),
                            ),
                          ),
                          SizedBox(height: 2,),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              "Total endirim : " +
                                  modelblock.grantendirim
                                      .toStringAsFixed(2),
                            ),
                          ),
                          SizedBox(height: 3,),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text("Total net satis : " +
                                modelblock.grantennetsatis
                                    .toStringAsFixed(2),style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          : SpinKitCircle(
              color: Colors.red,
            ),
    );
  }

  _buildExpandableContent(SatisTabProduct elementAt) {
    ///////////////////////////////////////////////
    List<Widget> columnContent = [];
    for (ModelMehsullar products in elementAt.products) {
      columnContent.add(RappedMehsul(products, () {
        setState(() {});
      }, modelblock, widget.fakturaId, widget.musterikodu));
    }
    return columnContent;
  }

  InkWell buildItemList(ModelAnaQrup model) {
    SizeConfig().init(context);
    return InkWell(
      onTap: () {
        // blockData.AllMehsullarByAnaQrupid(int.parse(model.id.toString()));
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => WidgetSatishSon(
        //       block: blockData,
        //           fakturaId: widget.fakturaId,
        //           musterikodu: widget.musterikodu,
        //         )));
      },
      splashColor: Colors.black,
      hoverColor: Colors.blue,
      child: Ink(
        child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      model.anaqrupadi.toString(),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Umumi Cesid sayi : " +
                          model.cesidsayi.toString() +
                          " Cesid",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class RappedMehsul extends StatefulWidget {
  RappedMehsul(this.products, this.callback, this.datamodel, this.fakturaid,
      this.musterikoduu);
  Function callback;
  ModelMehsullar? products;
  ModelBlock? datamodel;
  String? fakturaid;
  String? musterikoduu;

  @override
  State<RappedMehsul> createState() => _RappedMehsulState();
}

class _RappedMehsulState extends State<RappedMehsul> {
  List<bool> isSelected = [false, true];
  bool indexselectedtoggle = true;
  TextEditingController cn_miqdarsatis = TextEditingController();
  TextEditingController cn_endirim = TextEditingController();
  int malinkohnesayi = 0;
  int secilensay = 0;
  int qaliqstok = 0;
  double qiymet = 0;
  double summa = 0;
  bool endirim = false;
  bool mehsulsecildi = false;
  double endirimsumma = 0;
  double summatotal = 0;
  int selectedindex = 0;

  @override
  void initState() {
    cn_miqdarsatis.text = "0";
    cn_endirim.text = "0";
    malinkohnesayi =
        int.parse(widget.products!.malinSayi.toString().replaceAll(".0", ""));
    qiymet = double.parse(
        widget.products!.malinQitmeti.toString().replaceAll(".0", ""));
    secilensay = int.parse(cn_miqdarsatis.text.toString());
    if (mehsulsecildi) {
      qaliqstok = malinkohnesayi - secilensay;
      summa = secilensay * qiymet;
    } else {
      qaliqstok = malinkohnesayi;
      summa = 0;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.products!.malinAdi.toString(),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.products!.malinQitmeti.toString() + "₼",
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Stokda : " +
                              qaliqstok.toString() +
                              "  " +
                              widget.products!.malVahid.toString(),
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.green, backgroundColor: Colors.white, padding: EdgeInsets.all(5),
                                  elevation: 5,
                                  minimumSize: Size(10, 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    setState(() {
                                      if (secilensay > 0) {
                                        secilensay = int.parse(
                                            cn_miqdarsatis.text.toString());
                                        secilensay = secilensay - 1;
                                        cn_miqdarsatis.text =
                                            secilensay.toString();
                                        qaliqstok = malinkohnesayi - secilensay;
                                        summa = secilensay * qiymet;
                                        if (endirim) {
                                          if (indexselectedtoggle) {
                                            endirimsumma = double.parse(
                                                cn_endirim.text.toString());
                                            summatotal = summa - endirimsumma;
                                          } else {
                                            endirimsumma = summa *
                                                double.parse(cn_endirim.text
                                                    .toString()) /
                                                100;
                                            summatotal = summa - endirimsumma;
                                          }
                                        } else {
                                          summatotal = summa;
                                          endirimsumma = 0;
                                        }
                                        if (secilensay > 0) {
                                          mehsulsecildi = true;
                                        } else {
                                          summatotal = 0;
                                          summa = 0;
                                          endirimsumma = 0;
                                          selectedindex = 1;
                                          mehsulsecildi = false;
                                          cn_miqdarsatis.text = "0";
                                          secilensay = 0;
                                          _listeElaveET(
                                              widget.products!,
                                              summa,
                                              summatotal,
                                              endirimsumma,
                                              double.parse(cn_miqdarsatis.text
                                                  .toString()));
                                        }
                                      }
                                    });
                                  });
                                },
                                child: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                )),
                            Container(
                              height: 40,
                              width: 60,
                              color: Colors.white,
                              child: TextFormField(
                                controller: cn_miqdarsatis,
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.green,
                                textAlign: TextAlign.center,
                                onChanged: (deyer) {
                                  setState(() {
                                    secilensay = int.parse(deyer.toString());
                                    if (secilensay > 0) {
                                      mehsulsecildi = true;
                                      qaliqstok = malinkohnesayi - secilensay;
                                      summa = secilensay * qiymet;
                                      if (endirim) {
                                        if (indexselectedtoggle) {
                                          endirimsumma = double.parse(
                                              cn_endirim.text.toString());
                                          summatotal = summa - endirimsumma;
                                          print("summa :" + summa.toString());
                                          print("endirimsumma :" +
                                              endirimsumma.toString());
                                          print("summatotal :" +
                                              summatotal.toString());
                                        } else {
                                          endirimsumma = (summa *
                                                  double.parse(cn_endirim.text
                                                      .toString())) /
                                              100;
                                          summatotal = summa - endirimsumma;
                                          print("summa :" + summa.toString());
                                          print("endirimsumma :" +
                                              endirimsumma.toString());
                                          print("summatotal :" +
                                              summatotal.toString());
                                        }
                                      } else {
                                        summatotal = summa;
                                        endirimsumma = 0;
                                      }
                                    } else {
                                      summatotal = 0;
                                      summa = 0;
                                      endirimsumma = 0;
                                      selectedindex = 1;
                                      mehsulsecildi = false;
                                      cn_miqdarsatis.text = "0";
                                      secilensay = 0;
                                      _listeElaveET(
                                          widget.products!,
                                          summa,
                                          summatotal,
                                          endirimsumma,
                                          double.parse(
                                              cn_miqdarsatis.text.toString()));
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                    fillColor: Colors.white.withOpacity(0.5),
                                    filled: true,
                                    labelStyle: TextStyle(color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 2),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide:
                                            BorderSide(color: Colors.green))),
                              ),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.green, backgroundColor: Colors.white, padding: EdgeInsets.all(5),
                                  elevation: 5,
                                  minimumSize: Size(10, 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    secilensay = int.parse(
                                            cn_miqdarsatis.text.toString()) +
                                        1;
                                    cn_miqdarsatis.text = secilensay.toString();
                                    qaliqstok = malinkohnesayi - secilensay;
                                    summa = secilensay * qiymet;
                                    mehsulsecildi = true;
                                    if (endirim) {
                                      if (indexselectedtoggle) {
                                        endirimsumma = double.parse(
                                            cn_endirim.text.toString());
                                        summatotal = summa - endirimsumma;
                                      } else {
                                        endirimsumma = summa *
                                            double.parse(
                                                cn_endirim.text.toString()) /
                                            100;
                                        summatotal = summa - endirimsumma;
                                      }
                                    } else {
                                      summatotal = summa;
                                      endirimsumma = 0;
                                      cn_endirim.text = "0";
                                    }
                                  });
                                },
                                child: const Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                )),
                          ],
                        )
                      ],
                    ),
                    secilensay > 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Satis : " +
                                    secilensay.toString() +
                                    " | " +
                                    summatotal.toStringAsFixed(2).toString(),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )
                        : SizedBox(),
                    mehsulsecildi
                        ? Column(
                            children: [
                              Column(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CheckboxListTile(
                                        title: Text("Endirim"),
                                        value: endirim,
                                        onChanged: (newValue) {
                                          setState(() {
                                            endirim = newValue!;
                                            endirimsumma = 0;
                                            cn_endirim.text = "0";
                                            summatotal = summa;
                                          });
                                        },
                                        controlAffinity: ListTileControlAffinity
                                            .platform, //  <-- leading Checkbox
                                      ),
                                      endirim
                                          ? Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 120,
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    cursorColor: Colors.green,
                                                    controller: cn_endirim,
                                                    textAlign: TextAlign.center,
                                                    onChanged: (deyer) {
                                                      setState(() {
                                                        if (endirim) {
                                                          if (indexselectedtoggle) {
                                                            endirimsumma = double
                                                                .parse(deyer
                                                                    .toString());
                                                            summatotal = summa -
                                                                endirimsumma;
                                                          } else {
                                                            endirimsumma = summa *
                                                                double.parse(deyer
                                                                    .toString()) /
                                                                100;
                                                            summatotal = summa -
                                                                endirimsumma;
                                                          }
                                                        } else {
                                                          endirimsumma = 0;
                                                          summatotal = summa;
                                                        }
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                        suffix:
                                                            indexselectedtoggle
                                                                ? Text("₼")
                                                                : Text("%"),
                                                        fillColor:
                                                            Colors.grey[200],
                                                        filled: true,
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        hintText: "Endirim",
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .green,
                                                                  width: 2),
                                                        ),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.0),
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .green))),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                ToggleButtons(
                                                  borderColor: Colors.green,
                                                  fillColor: Colors.green,
                                                  borderWidth: 1,
                                                  selectedBorderColor:
                                                      Colors.grey,
                                                  selectedColor: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        '%-le',
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        '₼',
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ],
                                                  onPressed: (int index) {
                                                    setState(() {
                                                      print("selected" +
                                                          index.toString());
                                                      for (int i = 0;
                                                          i < isSelected.length;
                                                          i++) {
                                                        isSelected[i] =
                                                            i == index;
                                                      }
                                                      if (index == 0) {
                                                        endirimsumma = summa *
                                                            double.parse(
                                                                cn_endirim.text
                                                                    .toString()) /
                                                            100;
                                                        summatotal = summa -
                                                            endirimsumma;
                                                        indexselectedtoggle =
                                                            false;
                                                      } else if (index == 1) {
                                                        endirimsumma = double
                                                            .parse(cn_endirim
                                                                .text
                                                                .toString());
                                                        summatotal = summa -
                                                            endirimsumma;
                                                        indexselectedtoggle =
                                                            true;
                                                      }
                                                    });
                                                  },
                                                  isSelected: isSelected,
                                                ),
                                              ],
                                            )
                                          : SizedBox(),
                                    ],
                                  ), //Colmn endirim hissesi
                                  Divider(
                                    height: 1,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Satis Mebleg :" +
                                            summa.toStringAsFixed(2) +
                                            " ₼",
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Endirim " +
                                            endirimsumma.toStringAsFixed(2) +
                                            " ₼",
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Total Summa " +
                                            summatotal.toStringAsFixed(2) +
                                            " ₼",
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.red, backgroundColor: Colors.white, padding: EdgeInsets.all(5),
                                        elevation: 5,
                                        minimumSize: Size(100, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          summatotal = 0;
                                          summa = 0;
                                          endirimsumma = 0;
                                          selectedindex = 1;
                                          mehsulsecildi = false;
                                          cn_miqdarsatis.text = "0";
                                          secilensay = 0;
                                          _listeElaveET(
                                              widget.products!,
                                              summa,
                                              summatotal,
                                              endirimsumma,
                                              double.parse(cn_miqdarsatis.text
                                                  .toString()));
                                        });
                                      },
                                      child: Text("Legv et")),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.green, backgroundColor: Colors.white, padding: EdgeInsets.all(5),
                                        elevation: 5,
                                        minimumSize: Size(100, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        mehsulsecildi = false;
                                        _listeElaveET(
                                            widget.products!,
                                            summa,
                                            summatotal,
                                            endirimsumma,
                                            double.parse(cn_miqdarsatis.text
                                                .toString()));
                                      },
                                      child: const Text("Daxil et")),
                                ],
                              )
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  _listeElaveET(ModelMehsullar model, double netsumma, double totalsumma,
      double endirim, double miqdar) {
    double mayadeyer = netsumma -
        (miqdar * double.parse(model.mayaDeyeri!.toStringAsFixed(2)));
    final now = DateTime.now();
    ModelSatis modelSatis = ModelSatis(
        ilkinstoksayi: model.malinSayi,
        sonstoksayi: model.malinSayi! - miqdar,
        groupid: model.qrupAdi,
        mehsuladi: model.malinAdi,
        netsatis: totalsumma,
        satissumma: netsumma,
        mehsulkodu: model.mehsulkodu,
        fakturanomresi: widget.fakturaid,
        mustericarikodu: widget.musterikoduu,
        satisendirim: endirim,
        negdSayis: false,
        satismiqdari: miqdar,
        satisxeyir: mayadeyer,
        vaxt: now);
    print(widget.musterikoduu.toString());
    widget.datamodel!.addSalesToList(modelSatis);
    widget.callback.call();
    setState(() {});
  }
}
