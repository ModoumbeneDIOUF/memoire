import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memory/Api/url.dart';
import 'package:memory/Pages/offres/offfes.dart';
import 'package:memory/Pages/offres/offresProches.dart';
import 'package:path_provider/path_provider.dart';
import 'package:memory/Pages/offres/offreDetails.dart';

class MainOffres extends StatefulWidget {
  @override
  _MainOffresState createState() => _MainOffresState();
}

class _MainOffresState extends State<MainOffres> {
  int _page = 0;
  int indexPage = 0;
  //create all the pages
  final Offres _allOffres = Offres();
  final OffresProches _offresProche = OffresProches();

  Widget _showPage =  new Offres();

  Widget _pageChoiser(int page){
    switch(page){
      case 0:
        return _allOffres;
        break;
      case 1:
        return _offresProche;
        break;
      default:
        return new Container(
          child: new Center(
            child: new Text('No page found'),
          ),
        );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: indexPage,
        color: Colors.white,
        //backgroundColor: Colors.white,
        animationCurve: Curves.easeOut,
        animationDuration: Duration(milliseconds: 600),
        items: <Widget>[
          Icon(Icons.border_all,size: 20,color: Colors.black,),
          Icon(Icons.home,size: 20,color: Colors.black,),
        ],
        onTap: (int tapedindex){
          print("Currrent index is $tapedindex");
          setState(() {
            _showPage = _pageChoiser(tapedindex);
            indexPage = tapedindex;
            print("indexPage = $indexPage");
          });

        },
      ),
      body: Container(
        child: _showPage,
      ),
    );
  }
}
