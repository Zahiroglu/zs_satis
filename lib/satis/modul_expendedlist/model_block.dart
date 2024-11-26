import 'package:flutter/material.dart';
import 'package:zs_satis/anbar/model_mehsullar.dart';
import 'package:zs_satis/anbar/model_qrup.dart';
import 'package:zs_satis/satis/model_satis.dart';
import 'package:zs_satis/satis/son_model/datablock_satis.dart';

class ModelBlock with ChangeNotifier {
  List<SatisTabCatogory> tabs = [];
  List<SatisTabProduct> items = [];
  List<ModelSatis> sales = [];
  TabController? controller;
  ScrollController scrollController = ScrollController();
  double grantbrut=0;
  double grantendirim=0;
  double grantennetsatis=0;

  void init(TickerProvider ticker, List<ModelQrupadi> listAnaqruplar,
      List<ModelMehsullar> listmehsullar) {
    double offsetfrom = 0.0;
    double offsetto = 0.0;
    for (int i = 0; i < listAnaqruplar.length; i++) {
      List<ModelMehsullar> list_mehsullar = [];
      final anaqrup = listAnaqruplar.elementAt(i);
      if (i > 0) {
        offsetfrom +=
            int.parse(listAnaqruplar.elementAt(i - 1).cesidSayi.toString()) *
                100;
      }
      if (i < listAnaqruplar.length - 1) {
        offsetto = offsetfrom +
            (int.parse(listAnaqruplar.elementAt(i + 1).cesidSayi.toString()) *
                100);
      } else {
        offsetto = double.infinity;
      }
      // tabs.add(
      //   SatisTabCatogory(
      //       catogory: anaqrup,
      //       selected: (i == 0),
      //       offsetto: offsetto,
      //       offsetfrom: (40 * i) + offsetfrom),
      // );
      // items.add(SatisTabProduct(catogory: anaqrup));
      for (int a = 0; a < listmehsullar.length; a++) {
        ModelMehsullar indexmodel = listmehsullar.elementAt(a);
        if (indexmodel.qrupAdi.toString() == anaqrup.id.toString()) {
          list_mehsullar.add(indexmodel);
        }
      }
      items.add(SatisTabProduct(
          products: list_mehsullar,
          catogory: anaqrup,
          selected: false,
          sales: sales));
    }
    scrollController.addListener(_onScrollListener);
    controller = TabController(length: items.length, vsync: ticker);
  }

  void _onScrollListener() {
    for (int i = 0; i < tabs.length; i++) {
      final tab = tabs[i];
      if (scrollController.offset >= tab.offsetfrom &&
          scrollController.offset <= tab.offsetto &&
          !tab.selected) {
        onCategorySelected(i, animatedrouterequered: false);
        controller!.animateTo(i);
        break;
      }
    }
  }

  void onCategorySelected(int index, {bool animatedrouterequered = true}) {
    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      tabs[i] = tabs[i].copywith(selected.catogory.qrupAdi == tabs[i].catogory.qrupAdi);
    }
    notifyListeners();
    if (animatedrouterequered) {
      scrollController.animateTo(selected.offsetfrom,
          duration: const Duration(microseconds: 500), curve: Curves.bounceOut);
    }
  }

  void onCateqoryClecked(int index, bool isselected) {
    final selected = items[index];
    for (int i = 0; i < items.length; i++) {
      if(selected==items[i]) {
        if(isselected){
        items[i].selected = true;
        }else{
          items[i].selected = false;
        }
      }else{
        items[i].selected = false;
      }}
    notifyListeners();
  }

  void addSalesToList(ModelSatis model) {
    grantbrut=0;
    grantendirim=0;
    grantennetsatis=0;
    for(int a=0;a<sales.length;a++){
      if(sales.elementAt(a).mehsulkodu.toString()==model.mehsulkodu.toString()) {
        // grantbrut=grantbrut-double.parse(sales.elementAt(a).satissumma.toString());
        // grantendirim=grantendirim-double.parse(sales.elementAt(a).satisendirim.toString());
        // grantennetsatis=grantennetsatis-double.parse(sales.elementAt(a).netsatis.toString());
        sales.remove(sales.elementAt(a));
      }
    }
    sales.add(model);
    for (int i = 0; i < items.length; i++) {
      if (items.elementAt(i).catogory.id.toString() == model.groupid.toString()) {
        double totalbrut = 0;
        double totalendirim = 0;
        double totalnetsatis = 0;
        sales.forEach((element) {
          grantbrut=grantbrut+double.parse(element.satissumma.toString());
          grantendirim=grantendirim+double.parse(element.satisendirim.toString());
          grantennetsatis=grantennetsatis+double.parse(element.netsatis.toString());
          if(element.groupid.toString()==items.elementAt(i).catogory.id.toString()) {
            totalbrut = totalbrut + double.parse(element.satissumma.toString());
            totalnetsatis = totalnetsatis + double.parse(element.satisendirim.toString());
            totalnetsatis = totalnetsatis + double.parse(element.netsatis.toString());
          }});
        items[i] = items[i].copywith(
            items.elementAt(i).catogory,
            items.elementAt(i).products,
            sales,
            totalbrut,
            totalendirim,
            totalnetsatis);
        //  items.add(SatisTabProduct(products: items.elementAt(i).products,catogory: items.elementAt(i).catogory,sales: sales, totalendirim: totalendirim, totalbrut: totalbrut, totalnestsatis: totalnetsatis));
        print("Melumat daxil edildi:" + totalbrut.toString());
      }
    }
    notifyListeners();
  }

  void remuveSalesToList(ModelSatis model) {
    sales.remove(model);
    for (int i = 0; i < items.length; i++) {
      if (items.elementAt(i).catogory.id.toString() == model.groupid.toString()) {
        double totalbrut = 0;
        double totalendirim = 0;
        double totalnetsatis = 0;
        sales.forEach((element) {
          if(element.groupid.toString()==items.elementAt(i).catogory.id.toString()) {
            totalbrut = totalbrut - double.parse(element.satissumma.toString());
            totalnetsatis =
                totalnetsatis - double.parse(element.satisendirim.toString());
            totalnetsatis =
                totalnetsatis - double.parse(element.netsatis.toString());
          }});
        items[i] = items[i].copywith(items.elementAt(i).catogory, items.elementAt(i).products, sales, totalbrut, totalendirim, totalnetsatis);
        print("Melumat daxil edildi:" + totalbrut.toString());
      }
    }
    notifyListeners();
  }



  @override
  void dispose() {
    scrollController.removeListener(_onScrollListener);
    scrollController.dispose();
    controller!.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}

class SatisTabCatogory {
  ModelQrupadi catogory;
  bool selected;
  double offsetfrom;
  double offsetto;

  SatisTabCatogory copywith(bool selected) => SatisTabCatogory(
      catogory: catogory,
      selected: selected,
      offsetfrom: offsetfrom,
      offsetto: offsetto);

  SatisTabCatogory({
    required this.catogory,
    required this.selected,
    required this.offsetfrom,
    required this.offsetto,
  });
}

class SatisTabProduct {
  SatisTabProduct(
      {required this.selected,
      required this.catogory,
      required this.products,
      required this.sales,
      this.totalbrut,
      this.totalendirim,
      this.totalnestsatis});

  SatisTabProduct copywith(
          ModelQrupadi catogory,
          List<ModelMehsullar> products,
          List<ModelSatis> sales,
          double brut,
          double endirim,
          double netsatis) =>
      SatisTabProduct(
          selected: selected,
          catogory: catogory,
          products: products,
          sales: sales,
          totalnestsatis: netsatis,
          totalbrut: brut,
          totalendirim: endirim);

  ModelQrupadi catogory = ModelQrupadi();
  List<ModelMehsullar> products;
  List<ModelSatis> sales = [];
  bool selected;
  double? totalbrut;
  double? totalendirim;
  double? totalnestsatis;

  bool get isCategory => catogory != null;
}
