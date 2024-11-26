
import 'package:flutter/material.dart';
import 'package:zs_satis/constandlar/sablom_suzler.dart';


class SliderModel{

  String? imageAssetPath;
  String? title;
  String? desc;

  SliderModel({ this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath){
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle){
    title = getTitle;
  }

  void setDesc(String getDesc){
    desc = getDesc;
  }

  String? getImageAssetPath(){
    return imageAssetPath;
  }

  String? getTitle(){
    return title;
  }

  String? getDesc(){
    return desc;
  }

}


List<SliderModel> getSlides(){

  List<SliderModel> slides = [];
  SliderModel sliderModel =  SliderModel();

  //1
  sliderModel.setDesc(Shablomsozler().metinSalestarckin);
  sliderModel.setTitle(Shablomsozler().basliqSalestarckin);
  sliderModel.setImageAssetPath("images/zs8.png");
  slides.add(sliderModel);

  sliderModel =  SliderModel();

  //2
  sliderModel.setDesc(Shablomsozler().metinqlobalferdi);
  sliderModel.setTitle(Shablomsozler().basliqferdionline);
  sliderModel.setImageAssetPath("images/global_ferdi.png");
  slides.add(sliderModel);

  sliderModel =  SliderModel();

  //3
  sliderModel.setDesc(Shablomsozler().metinqlogamkompaniya);
  sliderModel.setTitle(Shablomsozler().basliqkompaniya);
  sliderModel.setImageAssetPath("images/global_hesab.png");
  slides.add(sliderModel);

  sliderModel =  SliderModel();

  return slides;
}
