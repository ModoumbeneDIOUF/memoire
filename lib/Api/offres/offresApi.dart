import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:memory/Api/url.dart';
import 'package:memory/Model/offresModel.dart';

class OffresApi {


  Future<List<OffreModel>> offres() async{
    String _url = Url().url+"nourritureList/Plats";

    Map<String,String> headers = {
      'Accept' : 'application/json'
    };

    http.Response response = await http.get(_url,headers:headers);

    List<OffreModel> offres = [];
    if(response.statusCode == 200){
      Map<String,dynamic>  body = jsonDecode(response.body);



    }

    return offres;
  }

}