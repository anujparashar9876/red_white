import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:redwhite/data/app_exception.dart';
import 'package:redwhite/data/network/base_api_service.dart';

class NetworkApiServices extends BaseApiServices{
  @override
  Future getGetApiResponse(String url,{Map<String,String>? header}) async{
    dynamic responseJson;
    try{
      final response= await get(Uri.parse(url),headers: header).timeout(const Duration(seconds: 10));
      responseJson=returnResponse(response);
      
    } on SocketException{
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url,dynamic data,{Map<String,String>? header})async{
    dynamic responseJson;
    try{
      // debugPrint(data.toString());
      Response response=await post(Uri.parse(url),
      body: jsonEncode(data),
      headers: header
      ).timeout(const Duration(seconds: 10));
      responseJson=returnResponse(response);
    } on SocketException{
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }
  @override
  Future getDeleteApiResponse(String url,dynamic data,{Map<String,String>? header})async{
    dynamic responseJson;
    try{
      // debugPrint(data.toString());
      Response response=await delete(Uri.parse(url),
      body: jsonEncode(data),
      headers: header
      ).timeout(const Duration(seconds: 10));
      responseJson=returnResponse(response);
    } on SocketException{
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }
  @override
  Future getPatchApiResponse(String url,dynamic data,{Map<String,String>? header})async{
    dynamic responseJson;
    try{
      // debugPrint(data.toString());
      Response response=await patch(Uri.parse(url),
      body: jsonEncode(data),
      headers: header
      ).timeout(const Duration(seconds: 10));
      responseJson=returnResponse(response);
    } on SocketException{
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }
  dynamic returnResponse(Response response){
    switch(response.statusCode){
      case 200:
        dynamic responseJson=jsonDecode(response.body);
        if(kDebugMode){
        print(response.body);
        }
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException("Error occured while Communicating with server");
    }
  }
}