import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:memory/Api/url.dart';
import 'package:memory/Pages/ventes/product_detail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:memory/Pages/offres/offreDetails.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

  var catego = "all";
  Future<List<ModelVente>> _getVente() async {
    String _url = Url().url+"produitVendus/"+catego;

    var data = await http.get(_url);

    var jsonData = json.decode(data.body);

    List<ModelVente> ventes = [];

    for (var v in jsonData){
      ModelVente vente = new ModelVente(v["id"], v["venteRandomKey"], v["typeProduitVendu"], v["descriptionProduitVendu"], v["adresseProduitVendu"], v["numero"], v["prixProduitVendu"], v["quantiteProduitVendu"], v["imageProduitVendu"]);
      ventes.add(vente);
    }
      print(ventes);
      return ventes;
  }

  @override
  Widget build(BuildContext context) {
    Widget image_Carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/carouselDonneur/2.jpg'),
          AssetImage('assets/carouselDonneur/3.png'),
        ],
        autoplay: false,
        //animationCurve: Curves.fastOutSlowIn,
        //animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
        dotColor: Colors.blueAccent,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: (){},
          ),
          SizedBox(width: 8.0,)
        ],
      ),
      body: ListView(

          children: <Widget>[
            image_Carousel,
            // categories
            new Padding(
                padding: const EdgeInsets.all(2.0),
                child: new Text("Categories"),
            ),
            //horizontal
            new Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  height: 100.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      InkWell(
                        onTap: (){print("bien");},
                        child: Container(
                          width: 110.0,
                          child: ListTile(
                            title:Image.asset("assets/carouselDonneur/2.jpg"),

                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){print("bien");},
                        child: Container(
                          width: 110.0,
                          child: ListTile(
                            title:Image.asset("assets/carouselDonneur/2.jpg"),

                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){print("bien");},
                        child: Container(
                          width: 110.0,
                          child: ListTile(
                            title:Image.asset("assets/carouselDonneur/2.jpg"),

                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){print("bien");},
                        child: Container(
                          width: 110.0,
                          child: ListTile(
                            title:Image.asset("assets/carouselDonneur/2.jpg"),




                          ),
                        ),
                      ),


                    ],
                  ),
                ),

                ),
             new Column(
               children: <Widget>[
                 FutureBuilder (
                   future: _getVente(),
                     builder: (BuildContext context,AsyncSnapshot snapshot){
                       if(snapshot.data == null){
                         return Container(
                           child: Center(
                             child: Text("Chargement en cours..."),
                           ),
                         );
                       }
                       else{
                         return GridView.builder(

                            shrinkWrap: true,
                             itemCount: snapshot.data.length,
                             gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                 crossAxisCount:2,
                              childAspectRatio: 0.75),

                             itemBuilder: (BuildContext contex,int index){
                                return Column(

                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[

                                    Container(

                                      padding: EdgeInsets.all(8.0),
                                      height: 160,
                                      width: 160,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(16)
                                      ),

                                      child: InkWell(
                                          onTap:(){
                                          },
                                          child: Image.network(Url().uri+"produitVendus/"+snapshot.data[index].imageProduitVendu)
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 4.0),
                                      child: Text(snapshot.data[index].descriptionProduitVendu,style: TextStyle(color: Colors.grey),),

                                    ),
                                    Text("Prix: "+snapshot.data[index].prixProduitVendu)
                                  ],
                                );
                             },


                         );
                       }
                     }
                 )
               ],
             )
          ],
      ),

    );
  }
}

class ModelVente{
  final int id;
  final String venteRandomKey;
  final String typeProduitVendu;
  final String descriptionProduitVendu;
  final String adresseProduitVendu;
  final String numero;
  final String quantiteProduitVendu;
  final String prixProduitVendu;
  final String imageProduitVendu;

  ModelVente(this.id,this.venteRandomKey,this.typeProduitVendu,this.descriptionProduitVendu,this.adresseProduitVendu,this.numero,this.prixProduitVendu,this.quantiteProduitVendu,this.imageProduitVendu);
}