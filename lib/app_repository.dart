import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:redwhite/data/network/base_api_service.dart';
import 'package:redwhite/data/network/network_api_service.dart';
import 'package:redwhite/modal/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppRepository {
  BaseApiServices _apiServices=NetworkApiServices();
  Future<dynamic> getProduct() async{
    try{
      dynamic response=await _apiServices.getGetApiResponse('https://fakestoreapi.com/products');
      log(response.toString());
      return response;
    } catch(e){
      throw e;
    }
  }
  Future<dynamic> addProduct(dynamic data)async{
    try {
      dynamic response =await _apiServices.getPostApiResponse('https://fakestoreapi.com/products',data );
      log(response.toString());
      return response;
    } catch (e) {
      throw e;
    }
  }
  // Future<dynamic> deleteproduct(int index)async{
  //   try {
  //     dynamic response=await _apiServices.getDeleteApiResponse('https://fakestoreapi.com/products/$index',[]);
  //     log(response.toString());
  //     return response;
  //   } catch (e) {
      
  //   }
  // }
  Future storeData({required int id,required String title,required double? price,required String description,required String category,required String image,required double rate,required int count})async{
    Product product=Product(
      id: id,
      title:title,
      price: price,
      description:description ,
      category: category,
      image: image,
      rating: Rating(rate: rate,count: count),
    );
    FirebaseFirestore.instance.collection('product').doc(id.toString()).set(product.toJson());
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getproduct(){
    return FirebaseFirestore.instance.collection('product').snapshots();
  }
  deleteproduct(int id){
    FirebaseFirestore.instance.collection('product').doc(id.toString()).delete();
  }
}