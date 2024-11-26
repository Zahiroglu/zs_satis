import 'package:flutter/cupertino.dart';
import 'package:zs_satis/anbar/model_mehsullar.dart';
import 'package:zs_satis/anbar/model_qrup.dart';
import 'package:zs_satis/satis/model_satis.dart';

class DataBlockSatis with ChangeNotifier{
  List<ModelAnaQrup> listKateq=[];
  List<UmumiSatis> listUmumi=[];
  List<ModelMehsullar> listAllProducts=[];
  List<ModelMehsullar> listSelectedAnaQrupProducts=[];
  List<ModelSatis> listSales=[];


  void initData(List<ModelQrupadi> listqruplar,List<ModelMehsullar> listMehsullar){
    listAllProducts=listMehsullar;
    listqruplar.forEach((element) {
      print(element.toString());
      ModelAnaQrup qrup=ModelAnaQrup(
        id: element.id,
        anaqrupadi: element.qrupAdi,
        cesidsayi: element.cesidSayi,
      );
      listKateq.add(qrup);
    });

  }

  void AllMehsullarByAnaQrupid (int id){
    listSelectedAnaQrupProducts=[];
    listAllProducts.forEach((element) {
      print("Gelen id"+id.toString());
      print("element id"+element.qrupAdi.toString());
      if(element.qrupAdi.toString()==id.toString()){
        listSelectedAnaQrupProducts.add(element);
        print("Add edildi");
      }
    });
listSelectedAnaQrupProducts.forEach((element) {

  print(element.malinAdi.toString());

});
  }

  void SumTotalSatis(){
    double totalbrut=0;
    double totalendirim=0;
    double totalenetsatis=0;
    listSales.forEach((element) {
      totalbrut=totalbrut+double.parse(element.satissumma.toString());
      totalendirim=totalendirim+double.parse(element.satisendirim.toString());
      totalenetsatis=totalenetsatis+double.parse(element.netsatis.toString());
    });
    UmumiSatis satis=UmumiSatis(
      netsatis: totalbrut,
      totalbrut: totalbrut,
      totalendirim: totalendirim
    );
    listUmumi.add(satis);
    notifyListeners();
  }

  void satisElavete(ModelSatis modelSatis) {
    listSales.add(modelSatis);
    SumTotalSatis();
    notifyListeners();
  }

}

class UmumiSatis{
 final double? totalbrut;
 final double? totalendirim;
 final double? netsatis;

  UmumiSatis({this.totalbrut, this.totalendirim, this.netsatis});
}
class ModelAnaQrup{
 final int? id;
 final String? anaqrupadi;
 final int? cesidsayi;
 final double? totalbrutsatis;
 final double? totalendirim;
 final double? totalnetsatis;

  const ModelAnaQrup({
    this.id,
    this.anaqrupadi,
    this.cesidsayi,
    this.totalbrutsatis,
    this.totalendirim,
    this.totalnetsatis,
  });
}