import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zs_satis/constandlar/sablom_suzler.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/databases/slq_database.dart';
import 'package:zs_satis/musteriler/model_musteriler.dart';

class WidgetMusteriler extends StatefulWidget {Function(ModelMusteriler) getselectedmusteri;

  WidgetMusteriler({Key? key, required this.getselectedmusteri})
      : super(key: key);

  @override
  _WidgetMusterilerState createState() => _WidgetMusterilerState();
}

class _WidgetMusterilerState extends State<WidgetMusteriler> {
  List<ModelMusteriler> list_musteriler = [];

  @override
  void initState() {
    SqlDatabase.db.init();
    getDataMehsullarFromDp();
    // TODO: implement initState
    super.initState();
  }

  Future getDataMehsullarFromDp() async {
    list_musteriler.clear();
    await SqlDatabase.db.getAllMusteriler().then((value) =>
    {
      value.forEach((element) {
        list_musteriler.add(element);
      })
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: true,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          margin: EdgeInsets.only(
            left: 1,
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
      body: Container(
        child: ListView.builder(
            itemCount: list_musteriler.length,
            itemBuilder: (context, index) {
              return buildItemList(list_musteriler.elementAt(index));
            }),
      ),
    );
  }

  Material buildItemList(ModelMusteriler model) {
    SizeConfig().init(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.red.withOpacity(0.8),
        highlightColor: Colors.transparent,
        onTap: () {
          widget.getselectedmusteri.call(model);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(5),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      model.carikod.toString(),
                      style: GoogleFonts.lato(fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.textsize16SP),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(height: 20,width: 1,child: Container(color: Colors.black87,),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      model.musteriadi.toString(),
                      style: GoogleFonts.lato(fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.textsize16SP),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // return Container(
    //   child: Row(
    //     children: [
    //       Text(
    //         model.carikod.toString(),
    //         style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: SizeConfig.textsize16SP),
    //         textAlign: TextAlign.center,
    //       ),
    //       Text(
    //         model.musteriadi.toString(),
    //         style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: SizeConfig.textsize16SP),
    //         textAlign: TextAlign.center,
    //       ),
    //     ],
    //   ),
    // );
  }
}
