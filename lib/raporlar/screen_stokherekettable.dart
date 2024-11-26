import 'package:flutter/material.dart';
import 'package:zs_satis/anbar/model_stockhereket.dart';
import 'package:zs_satis/databases/slq_database.dart';

class ScreenDataTableStokHereket extends StatefulWidget {
  const ScreenDataTableStokHereket({Key? key}) : super(key: key);

  @override
  _ScreenDataTableStokHereketState createState() =>
      _ScreenDataTableStokHereketState();
}

class _ScreenDataTableStokHereketState extends State<ScreenDataTableStokHereket> {
  bool? ascending;
  List<String> listTip=["Tip","In","OUT"];
  String selectedTip="Tip";
  List<ModelStockHereket>? listStockhereket;
  final List<String> listColmns = [
    'TESDIQ',
    'TIP',
    'Group ID',
    'M/KODU',
    'C/KODU',
    'Ilk/QALIQ',
    'CIXIS',
    'GIRIS',
    'SON/QALIQ',
    'Tarix',

  ]; //

  @override
  void initState() {
    super.initState();
    SqlDatabase.db.init();
    //SqlDatabase.db.getAllRecord();
    ascending = false;
    listStockhereket = [];
    getAlldata();
  }

  Future getAlldata() async {
    listStockhereket = await SqlDatabase.db.getAllStockHereket();
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
          title: Text("Stock hereket raporu"),
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
            .map((ModelStockHereket city) => DataRow(
          color: city.herekettipi=="0"?MaterialStateColor.resolveWith((states) => Colors.red):MaterialStateColor.resolveWith((states) => Colors.lightGreen),
                  cells: [
                    DataCell(Text('${city.tesdiqlenme}',style: TextStyle(color: city.herekettipi=="0"?Colors.white:Colors.black),)),
                    DataCell(Text('${city.herekettipi}',style: TextStyle(color: city.herekettipi=="0"?Colors.white:Colors.black),)),
                    DataCell(Text('${city.groupid}',style: TextStyle(color: city.herekettipi=="0"?Colors.white:Colors.black),)),
                    DataCell(Text('${city.mehsulkodu}',style: TextStyle(color: city.herekettipi=="0"?Colors.white:Colors.black),)),
                    DataCell(Text('${city.musterikodu}',style: TextStyle(color: city.herekettipi=="0"?Colors.white:Colors.black),)),
                    DataCell(Text('${city.ilkinqaliq}',style: TextStyle(color: city.herekettipi=="0"?Colors.white:Colors.black),)),
                    DataCell(Text('${city.cixissayi}',style: TextStyle(color: city.herekettipi=="0"?Colors.white:Colors.black),)),
                    DataCell(Text('${city.gisirsayi}',style: TextStyle(color: city.herekettipi=="0"?Colors.white:Colors.black),)),
                    DataCell(Text('${city.sonqaliq}',style: TextStyle(color: city.herekettipi=="0"?Colors.white:Colors.black),)),
                    DataCell(Text('${city.createDate.toString().substring(0,16)}',style: TextStyle(color: city.herekettipi=="0"?Colors.white:Colors.black),)),

                  ],
                ))
            .toList(),
      );

  void onSelectedRowChanged(
      {bool? selected, ModelStockHereket? modelStockHereket}) {
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
