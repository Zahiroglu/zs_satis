import 'package:flutter/material.dart';
import 'package:zs_satis/anbar/model_stockhereket.dart';
import 'package:zs_satis/databases/slq_database.dart';
import 'package:zs_satis/satis/model_carihereket.dart';
import 'package:zs_satis/satis/model_satis.dart';

class ScreenSatisRaporu extends StatefulWidget {
  const ScreenSatisRaporu({Key? key}) : super(key: key);

  @override
  _ScreenSatisRaporuState createState() => _ScreenSatisRaporuState();
}

class _ScreenSatisRaporuState extends State<ScreenSatisRaporu> {
  bool? ascending;
  List<String> listTip=["Tip","In","OUT"];
  String selectedTip="Tip";
  List<ModelSatis>? listsatishereket;
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
    'TESDIQLEME',
    'FAKTURA',
    'CARIKOD',
    'MEHSUL KOD',
    'SATIS MIQDAR',
    //'NET SATIS',
    'ENDIRIM',
    'XEYIR',
    'Tarix',

  ]; //

  @override
  void initState() {
    super.initState();
    SqlDatabase.db.init();
    ascending = false;
    listsatishereket = [];
    getAlldata();
  }

  Future getAlldata() async {
    listsatishereket = await SqlDatabase.db.getAllSatisHereket();
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
          child: listsatishereket!.isNotEmpty?SingleChildScrollView(
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
        rows: listsatishereket!
            .map((ModelSatis city) => DataRow(
                  cells: [
                    DataCell(Text('${city.id}',style: TextStyle(color: Colors.black),)),
                    DataCell(Text('${city.tesdiqleme}',style: TextStyle(color: Colors.black),)),
                    DataCell(Text('${city.fakturanomresi}',style: TextStyle(color: Colors.black),)),
                    DataCell(Text('${city.mustericarikodu}',style: TextStyle(color: Colors.black),)),
                    DataCell(Text('${city.mehsulkodu}',style: TextStyle(color: Colors.black),)),
                    DataCell(Text('${city.satismiqdari}',style: TextStyle(color: Colors.black),)),
                  //  DataCell(Text('${city.netsatis!.toStringAsFixed(2)}',style: TextStyle(color: Colors.black),)),
                    DataCell(Text('${city.satisendirim!.toStringAsFixed(2)}',style: TextStyle(color: Colors.black),)),
                    DataCell(Text('${city.satisxeyir!.toStringAsFixed(2)}',style: TextStyle(color: Colors.black),)),
                    DataCell(Text('${city.vaxt.toString().substring(0,16)}',style: TextStyle(color: Colors.black),)),
                  ],
                ))
            .toList(),
      );

  void onSelectedRowChanged(
      {bool? selected, ModelSatis? modelStockHereket}) {
    setState(() {
      if (selected!) {
        listsatishereket!.add(modelStockHereket!);
      } else {
        listsatishereket!.remove(modelStockHereket);
      }
    });
  }

  Function? onPressed() {
    if (listsatishereket!.isEmpty) return null;

    return () {};
  }
}
