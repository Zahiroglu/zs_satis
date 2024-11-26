import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zs_satis/anbar/model_mehsullar.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/databases/slq_database.dart';
import 'model_stockhereket.dart';

class ScreenStockArtiq extends StatefulWidget {
  Function callBack;
  ModelMehsullar modelmehsul;
  ScreenStockArtiq({Key? key,required this.modelmehsul,required this.callBack}) : super(key: key);

  @override
  _ScreenStockArtiqState createState() => _ScreenStockArtiqState();
}

class _ScreenStockArtiqState extends State<ScreenStockArtiq> {
  TextEditingController yenistok=TextEditingController();
  double? ilkinstocksayi=0;
  double? sonstocksayi;
  ModelStockHereket? modelStockHereket;
  bool melumattapildi=false;



  void _saveStocksayiTodb() async{
    ModelStockHereket modelhereket=ModelStockHereket(
      cixissayi: 0,
      groupid: widget.modelmehsul.qrupAdi,
      mehsulkodu: widget.modelmehsul.mehsulkodu,
      createDate: DateTime.now(),
      gisirsayi: double.parse(yenistok.text),
      herekettipi: "in",
      musterikodu: "bos",
      ilkinqaliq: ilkinstocksayi,
      sonqaliq:sonstocksayi,
    );
    await SqlDatabase.db.addStockHerekerToDb(modelhereket).whenComplete(() => {
      Fluttertoast.showToast(msg: "Melumat ugurla deyisdirildi.", toastLength: Toast.LENGTH_LONG),
          Navigator.pop(context),widget.callBack.call(),
    });


  }


  Future _getlastSonqliq()async{
    modelStockHereket=await SqlDatabase.db.getLastStockHereketSonqaliq(widget.modelmehsul.mehsulkodu.toString()).whenComplete(() => {
      melumattapildi=true
    });
    setState(() {
      ilkinstocksayi=modelStockHereket!.sonqaliq;
      sonstocksayi=ilkinstocksayi;
    });
  }

@override
  void initState() {
    SqlDatabase.db.init();
    _getlastSonqliq();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                _saveStocksayiTodb();
              },
              child: Container(
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Daxil et"),
                  )),
            ),
          ),
        ],
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: true,
        title: Text("STOCK"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                melumattapildi?Container(
                  width: SizeConfig.screenWidth,
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all()
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Stock kodu : "+widget.modelmehsul.mehsulkodu.toString(),style: GoogleFonts.teko(
                          color: Colors.green, fontSize: SizeConfig.textsize16SP,fontWeight: FontWeight.w500),),
                      Text("Stock adi : "+widget.modelmehsul.malinAdi.toString(),style: GoogleFonts.teko(
                          color: Colors.green, fontSize: SizeConfig.textsize18SP,fontWeight: FontWeight.w500),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Ilkin stock sayi : "+modelStockHereket!.sonqaliq.toString(),style: GoogleFonts.teko(
                              color: Colors.black, fontSize: SizeConfig.textsize16SP),),
                          Text("Yeni stock sayi : "+sonstocksayi.toString(),style: GoogleFonts.teko(
                              color: Colors.blue, fontSize: SizeConfig.textsize16SP),),

                        ],
                      )
                    ],
                  ),

                ):SizedBox(),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  cursorColor: Colors.green,
                  controller:yenistok ,
                  onChanged: (value){
                    setState(() {
                      if(value.isNotEmpty){
                      sonstocksayi=ilkinstocksayi!+int.parse(value);}else{
                        sonstocksayi=sonstocksayi;
                      }
                    });
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      filled: true,
                      labelText: "Artim elave et *",
                      labelStyle: TextStyle(color: Colors.red),
                      hintText: "",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.green))),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
