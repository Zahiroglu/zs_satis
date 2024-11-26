import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/musteriler/model_musteriler.dart';
import 'package:zs_satis/satis/model_carihereket.dart';

class WidgetKassa extends StatefulWidget {
  ModelMusteriler modemusteri;
  String faktura;
  Function(ModelCariHereket kassa,double odenilenmebleg) callback;

  WidgetKassa(
      {Key? key,
      required this.modemusteri,
      required this.callback,
      required this.faktura})
      : super(key: key);

  @override
  _WidgetKassanState createState() => _WidgetKassanState();
}

class _WidgetKassanState extends State<WidgetKassa> {
  double ilkinqaliq = 0;
  double sonqaliq = 0;
  double odenilenmebleg = 0;

  @override
  void initState() {
    ilkinqaliq = double.parse(widget.modemusteri.sonborc!.toStringAsFixed(2));
    sonqaliq = double.parse(widget.modemusteri.sonborc!.toStringAsFixed(2));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.green,
          automaticallyImplyLeading: true,
          title: Text("Kassa Elave et"),
          actions: [
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  ModelCariHereket model = ModelCariHereket(
                    netsatis: 0,
                    tesdiqleme: false,
                    kassa: odenilenmebleg,
                    herekttipi: "1",
                    fakturakodu: widget.faktura,
                    endirimmebleg: 0,
                    brutmebleg: 0,
                    createDate: DateTime.now(),
                    carikod: widget.modemusteri.carikod
                  );
                  widget.callback.call(model,odenilenmebleg);
                },
                child: Container(
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Daxil et",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(5),
                padding:
                    EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                decoration:
                    BoxDecoration(color: Colors.white, border: Border.all()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Musteri kodu : " + widget.modemusteri.carikod.toString(),
                      style: GoogleFonts.teko(
                          color: Colors.green,
                          fontSize: SizeConfig.textsize16SP,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Musteri adi : " +
                          widget.modemusteri.musteriadi.toString(),
                      style: GoogleFonts.teko(
                          color: Colors.green,
                          fontSize: SizeConfig.textsize18SP,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Ilkin Borc : " +
                          widget.modemusteri.sonborc!.toStringAsFixed(2),
                      style: GoogleFonts.teko(
                          color: Colors.black,
                          fontSize: SizeConfig.textsize18SP),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.green,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Yeni Borc : " + sonqaliq.toStringAsFixed(2),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.teko(
                          color: Colors.blue,
                          fontSize: SizeConfig.textsize18SP),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                cursorColor: Colors.green,
                //controller:yenistok ,
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      odenilenmebleg=double.parse(value.toString());
                      sonqaliq = ilkinqaliq - int.parse(value);
                    } else {
                      sonqaliq = ilkinqaliq;
                      odenilenmebleg=0;
                    }
                  });
                },
                decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    filled: true,
                    labelText: "Kassa elave et *",
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
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ));
  }
}
