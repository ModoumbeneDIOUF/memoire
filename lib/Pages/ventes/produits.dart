import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memory/Api/url.dart';
import 'package:memory/Pages/ventes/product_detail.dart';
import 'package:memory/Pages/ventes/my_cart.dart';
import 'package:provider/provider.dart';

class Produits extends StatefulWidget {
  @override
  _ProduitsState createState() => _ProduitsState();
}

class _ProduitsState extends State<Produits> {

  List categories = ["all","Cosmétique","Céréale","Fruits ou légumes","Vêtements ou chaussures"];
  String category = "all";
  int selectIndex = 0;

  Future<List<ModelVente>> _getVente() async {
    String _url = Url().url+"produitVendus/"+category;

    var data = await http.get(_url);

    var jsonData = json.decode(data.body);

    List<ModelVente> ventes = [];

    for (var v in jsonData){
      ModelVente vente = new ModelVente(v["id"], v["venteRandomKey"], v["typeProduitVendu"], v["descriptionProduitVendu"], v["adresseProduitVendu"], v["numero"], v["prixProduitVendu"], v["quantiteProduitVendu"], v["imageProduitVendu"],v["validiteProduitVendu"]);
      ventes.add(vente);
    }
    print(ventes);
    return ventes;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Ventes"),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart,size: 30.0,),
            onPressed: (){
              print("panier");
              Navigator.of(context).push(new MaterialPageRoute(builder:  (context) => MyCart()));
            },
          ),
        ],
      ),
      //Body
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0/4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20)
            ),
            child: TextField(
              onChanged: (value) => {
                print(value)
              },
              style:  TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder:  InputBorder.none,
                icon: Icon(Icons.search),
                hintText: "Rechercher un produit",
                hintStyle: TextStyle(color: Colors.white)
              ),
            ),
          ),
                  Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 30,
                  child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context,index) => GestureDetector(
                  onTap: (){
                  setState(() {

                  selectIndex = index;
                  category = categories[index];
                  print(category);
                  _getVente();
                  });
                  },
                  child:  Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left:20.0),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(

            color: index == selectIndex
            ? Colors.white.withOpacity(0.4)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),

            ),
            child: Text(
            categories[index],
            style: TextStyle(color: Colors.white),
            ),
            )

            ),

            )
            ),
            SizedBox(height: 20.0/2),
            Expanded(

                child: Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 70),
                            decoration: BoxDecoration(

                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(40),
                                      topLeft: Radius.circular(40)
                                 ),

                          ),

                        ),
                          FutureBuilder(
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
                                      itemCount: snapshot.data.length,
                                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:2),
                                      itemBuilder: (BuildContext contex,int index){
                                        return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20.0,
                                            vertical: 20.0 / 2
                                            ),
                                            //color: Colors.blueAccent,
                                            height: 160,
                                            child: Stack(
                                                alignment: Alignment.bottomCenter,
                                                children: <Widget>[
                                            Container(

                                            height: 136,
                                            decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(22),
                                            color: Colors.blueAccent
                                        ),
                                        child: Container(

                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(22),
                                          color: Colors.white),
                                            child: InkWell(
                                               onTap: () =>
                                                      Navigator.of(context).push(
                                                      new MaterialPageRoute(builder: (context)=>ProdcutDetails(
                                                          snapshot.data[index].venteRandomKey,
                                                          snapshot.data[index].typeProduitVendu,
                                                          snapshot.data[index].descriptionProduitVendu,
                                                          snapshot.data[index].adresseProduitVendu,
                                                          snapshot.data[index].numero,
                                                          snapshot.data[index].quantiteProduitVendu,
                                                          snapshot.data[index].prixProduitVendu,
                                                          snapshot.data[index].validiteProduitVendu,
                                                          snapshot.data[index].imageProduitVendu)
    )
                                                      )
                                                 )
                                                ),

                                                ),
                                                Positioned(
                                                    top: 20,
                                                    left: 20,
                                                  child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                      height: 60,
                                                      width: 120,
                                                      child: Image.network(Url().uri+"produitVendus/"+snapshot.data[index].imageProduitVendu)
                                                      ),
                                                ),
                                                Positioned(
                                                  top: 80,
                                                  left: 0,
                                                  child: SizedBox(
                                                    height: 136,
                                                    width: MediaQuery.of(context).size.width - 200,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                          child: Text(snapshot.data[index].descriptionProduitVendu,style: Theme.of(context).textTheme.button,),
                                                        ),

                                                         Container(
                                                                margin: EdgeInsets.only(top: 10,right: 40),
                                                            padding: const EdgeInsets.symmetric(
                                                              horizontal: 20.0 * 1.5,
                                                              vertical: 20.0 / 4
                                                          ),
                                                              decoration: BoxDecoration(
                                                              color: Colors.blueAccent,
                                                              borderRadius: BorderRadius.circular(15)
                                                            ),
                                                              child: Text(snapshot.data[index].prixProduitVendu+"Fcfa" ,style: TextStyle(color: Colors.white)),
                                                          )
                                                      ],
                                                   ),
                                                   ),
                                                )
                                                ],
                                                ),
                                                );
                                                }
                                                                                                                    ) ;
                                                }

                                    }
    ),

                        ],
    ),
    )
        ],
      ),
    );
  }
}

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int selectIndex = 0;
  List categories = ["all","Cosmétique","Céréales","Fruits ou légumes"];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 30,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context,index) => GestureDetector(
            onTap: (){
              setState(() {

                selectIndex = index;
              });
            },
            child:  Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left:20.0),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(

              color: index == selectIndex
                      ? Colors.white.withOpacity(0.4)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(6),

            ),
            child: Text(
              categories[index],
              style: TextStyle(color: Colors.white),
            ),
          )

      )
      )
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
  final String validiteProduitVendu;

  ModelVente(this.id,this.venteRandomKey,this.typeProduitVendu,this.descriptionProduitVendu,this.adresseProduitVendu,this.numero,this.prixProduitVendu,this.quantiteProduitVendu,this.imageProduitVendu,this.validiteProduitVendu);
}

