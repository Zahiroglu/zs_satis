import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zs_satis/anbar/esas_sehfeanbaranaqrup.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/raporlar/screen_satis.dart';
import 'package:zs_satis/raporlar/screen_stokherekettable.dart';

import 'screen_carihereket.dart';

class ScreenRaporlar extends StatefulWidget {
  const ScreenRaporlar({Key? key}) : super(key: key);

  @override
  _ScreenRaporlarState createState() => _ScreenRaporlarState();
}

class _ScreenRaporlarState extends State<ScreenRaporlar> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 1,
        title: Text("Raporlar"),
      ),
      body: Column(
        children: [
          itemsRaporlar(Colors.black, "Stock Hereket raporu", Icons.add, "stock"),
          itemsRaporlar(Colors.black, "Cari Hereket raporu", Icons.add, "cari"),
          itemsRaporlar(Colors.black, "Satis raporu", Icons.add, "satis"),
        ],
      ),
    );
  }

  InkWell itemsRaporlar(Color colors, String title, icon, String gedis) {
    return InkWell(
      onTap: () {
        if (gedis.toString() == "stock") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScreenDataTableStokHereket()));
        } else if(gedis.toString() == "satis"){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScreenSatisRaporu()));
        }
        else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScreenCariHereketRaporu()));
        }
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
            border: Border.all(),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey, offset: Offset(2, 2), spreadRadius: 1)
            ]),
        child: Row(
          children: [
            Icon(
              icon,
              color: colors,
              size: 48,
            ),
            SizedBox(
              width: 20,
            ),
            Text(title,
                style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: SizeConfig.textsize16SP,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
