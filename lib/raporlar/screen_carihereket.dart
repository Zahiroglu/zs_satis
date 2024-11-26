import 'package:flutter/material.dart';
import 'package:zs_satis/anbar/model_stockhereket.dart';
import 'package:zs_satis/databases/slq_database.dart';
import 'package:zs_satis/satis/model_carihereket.dart';

class ScreenCariHereketRaporu extends StatefulWidget {
  const ScreenCariHereketRaporu({Key? key}) : super(key: key);

  @override
  _ScreenCariHereketRaporuState createState() =>
      _ScreenCariHereketRaporuState();
}

class _ScreenCariHereketRaporuState extends State<ScreenCariHereketRaporu> {
  bool? ascending;
  List<String> listTip=["Tip","In","OUT"];
  String selectedTip="Tip";
  List<ModelCariHereket>? listStockhereket;
  int? id;
  String? herekttipi;
  String? fakturakodu;
  String? carikod;
  DateTime? createDate;
  double? brutmebleg;
  double? endirimmebleg;
  double? netsatis;
  double? kassa;
  bool? tesdiqleme;
  final List<String> listColmns = [
    'ID',
    'TESDIQ',
    'TIP',
    'FAKTURA ID',
    'CARIKOD',
    'BRUT',
    'ENDIRIM',
    'NETSATIS',
    'KASSA',
    'Tarix',

  ]; //

  @override
  void initState() {
    super.initState();
    SqlDatabase.db.init();
    ascending = false;
    listStockhereket = [];
    getAlldata();
  }

  Future getAlldata() async {
    listStockhereket = await SqlDatabase.db.getAllCariHereket();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Material(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          backgroundColor: Colors.green,
          title: Text("Cari hereket raporu"),
        ),
        body: SafeArea(
          child: listStockhereket!.isNotEmpty?SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(height: 150,
                  child:SizedBox(),),
                // Row(
                //   children: [
                //     DropdownButton<String>(
                //       alignment: Alignment.center,
                //       value: selectedTip,
                //       //elevation: 5,
                //       style: TextStyle(color: Colors.black),
                //       items: listTip.map<DropdownMenuItem<String>>((String value) {
                //         return DropdownMenuItem<String>(
                //           value: value,
                //           child: Text(value,
                //             textAlign: TextAlign.center,
                //             style: TextStyle(
                //               color: Colors.black,
                //               fontSize: 16,
                //               fontWeight: FontWeight.w600),
                //           ),
                //         );
                //       }).toList(),
                //       hint: Text(
                //         listTip[0],
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //             color: Colors.black,
                //             fontSize: 14,
                //             fontWeight: FontWeight.w600),
                //       ),
                //       onChanged: (String? value) {
                //         setState(() {
                //           selectedTip=value.toString();
                //         });
                //       },
                //     ),
                //     SizedBox(width: 10,),
                //     DropdownButton<String>(
                //       alignment: Alignment.center,
                //       value: selectedTip,
                //       //elevation: 5,
                //       style: TextStyle(color: Colors.black),
                //       items: listTip.map<DropdownMenuItem<String>>((String value) {
                //         return DropdownMenuItem<String>(
                //           value: value,
                //           child: Text(value,
                //             textAlign: TextAlign.center,
                //             style: TextStyle(
                //               color: Colors.black,
                //               fontSize: 16,
                //               fontWeight: FontWeight.w600),
                //           ),
                //         );
                //       }).toList(),
                //       hint: Text(
                //         listTip[0],
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //             color: Colors.black,
                //             fontSize: 14,
                //             fontWeight: FontWeight.w600),
                //       ),
                //       onChanged: (String? value) {
                //         setState(() {
                //           selectedTip=value.toString();
                //         });
                //       },
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //   ],
                // ),
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child:SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:buildDataTable(),

                    )
                ),
              ],
            ),
          ):Container(
            child: Center(
              child: Text("Melumat tapilmadi"),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDataTable() => DataTable(
    border: TableBorder.symmetric(inside: BorderSide(color: Colors.black,width: 0.5),outside: BorderSide(color: Colors.black,width: 1)),
    columnSpacing: 15,
    dividerThickness: 1,
    dataRowHeight: 25,
    headingRowHeight: 30,
    showCheckboxColumn: true,
    decoration: BoxDecoration(
      border: Border.all(width: 0.5)
    ),
    showBottomBorder: true,
        sortAscending: ascending!,
        sortColumnIndex: 8,
        columns: listColmns
            .map(
              (String column) => DataColumn(
                label: Text(column),
                // onSort: (int columnIndex, bool ascending) => onSortColumn(
                //     columnIndex: columnIndex, ascending: ascending),
              ),
            )
            .toList(),
        rows: listStockhereket!
            .map((ModelCariHereket city) => DataRow(
          color: city.herekttipi=="1"?MaterialStateColor.resolveWith((states) => Colors.lightGreen):MaterialStateColor.resolveWith((states) => Colors.red),
                  cells: [
                    DataCell(Text('${city.id}',style: TextStyle(color: city.herekttipi=="in"?Colors.black:Colors.white),)),
                    DataCell(Text('${city.tesdiqleme}',style: TextStyle(color: city.herekttipi=="in"?Colors.black:Colors.white),)),
                    DataCell(Text('${city.herekttipi}',style: TextStyle(color: city.herekttipi=="in"?Colors.black:Colors.white),)),
                    DataCell(Text('${city.fakturakodu}',style: TextStyle(color: city.herekttipi=="in"?Colors.black:Colors.white),)),
                    DataCell(Text('${city.carikod}',style: TextStyle(color: city.herekttipi=="in"?Colors.black:Colors.white),)),
                    DataCell(Text('${city.brutmebleg!.toStringAsFixed(2)}',style: TextStyle(color: city.herekttipi=="in"?Colors.black:Colors.white),)),
                    DataCell(Text('${city.endirimmebleg!.toStringAsFixed(2)}',style: TextStyle(color: city.herekttipi=="in"?Colors.black:Colors.white),)),
                    DataCell(Text('${city.netsatis!.toStringAsFixed(2)}',style: TextStyle(color: city.herekttipi=="in"?Colors.black:Colors.white),)),
                    DataCell(Text('${city.kassa!.toStringAsFixed(2)}',style: TextStyle(color: city.herekttipi=="in"?Colors.black:Colors.white),)),
                    DataCell(Text('${city.createDate.toString().substring(0,16)}',style: TextStyle(color: city.herekttipi=="in"?Colors.black:Colors.white),)),

                  ],
                ))
            .toList(),
      );

  void onSelectedRowChanged(
      {bool? selected, ModelCariHereket? modelStockHereket}) {
    setState(() {
      if (selected!) {
        listStockhereket!.add(modelStockHereket!);
      } else {
        listStockhereket!.remove(modelStockHereket);
      }
    });
  }

  Function? onPressed() {
    if (listStockhereket!.isEmpty) return null;

    return () {};
  }
}
