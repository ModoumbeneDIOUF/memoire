import 'dart:async';

import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:memory/Api/url.dart';
import 'package:random_string/random_string.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class Myshop extends StatefulWidget {
  @override
  _MyshopState createState() => _MyshopState();
}

class _MyshopState extends State<Myshop> {
  final globalKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String _comune;
  String _newPrix;

  var comune = TextEditingController();
  var newPrix = TextEditingController();


  ProgressDialog pr;

  var getlocalStorage =  getNumeroVendeur();

  String url = Url().url+"getMonBoutique/";
  String value;
  getUrl(){}
  Future<List<ShopModel>> _getVente() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String num = await getlocalStorage;

    String _url = url+num;

    var data = await http.get(_url);

    var jsonData = json.decode(data.body);

    List<ShopModel> shops = [];

    for (var p in jsonData){
      ShopModel vente = new ShopModel(p["venteRandomKey"],p["descriptionProduitVendu"],p["prixProduitVendu"],p["imageProduitVendu"]);
      shops.add(vente);
    }
    print(shops);
    return shops;
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    final _screenSize = MediaQuery.of(context).size;
    //Optional
    pr.style(
      message: 'Veillez patienter...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Ma boutique'),

      ),
      backgroundColor: Colors.blue[100],
      body: RefreshIndicator(
          child: Column(
                    children: <Widget>[
                Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0/4),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: TextField(
                    onChanged: (val) => {
                    setState(() {
            value = val;
            _getVente();
            })
            },
            style:  TextStyle(color: Colors.black),
            decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder:  InputBorder.none,
                icon: Icon(Icons.search),
                hintText: "Rechercher un produit",
                hintStyle: TextStyle(color: Colors.black)
            ),
          ),
          ),
          Expanded(
            child: Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: FutureBuilder(
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
                    return ListView.builder(
                              shrinkWrap : true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context,int index ){
                          return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              secondaryActions: <Widget>[
                              IconSlideAction(
                              caption: 'Modifier le prix',
                              color: Colors.grey.shade200,
                              icon: Icons.edit,
                              onTap: () {
                              showDialog(
                              context: context,
                              builder: (BuildContext context){
                              return AlertDialog(
                              content: Stack(
                                overflow: Overflow.visible,
                                  children: <Widget>[
                                  Positioned(
                                      right: -40.0,
                                      top: -40.0,
                                      child: InkResponse(
                                      onTap: () {
                                      Navigator.of(context).pop();
                                      },
                                      child: CircleAvatar(
                                      child: Icon(Icons.close),
                                      backgroundColor: Colors.red,
                                      ),
                                      ),
                                  ),
                                  Form(
                                      key: _formKey,
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text("Prix actuel: "+snapshot.data[index].prixProduitVendu+" Fcfa")
                                              ),
                                              Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                        controller: newPrix,
                                                        keyboardType: TextInputType.number,
                                                        onChanged: ((String newPrix){
                                                        setState(() {
                                                          _newPrix = newPrix;
                                                        });
                                                        }),
                                                        decoration: InputDecoration(
                                                            labelText: "Nouveau prix",
                                                            labelStyle: TextStyle(
                                                            color: Colors.black87,
                                                            ),
                                                            border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10)),
                                                            focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10)),
                                                        ),
                                                        textAlign: TextAlign.center,
                                                        validator: (value) {
                                                        if (value.isEmpty) {
                                                        return 'Champ obligatoire';
                                                        }
                                                        return null;
                                                        },
                                                    ),
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                  child: Text("Valider"),
                                                  color: Colors.green,
                                                  onPressed: (){
                                                  if (_formKey.currentState.validate()) {
                                                  updatePrix(snapshot.data[index].venteRandomKey);
                                                  }
                                                  },
                                                  ),
                                              )
                                          ],
                                      ),
                                  )
                                  ],
                                  )
                                  );
                                  }
                                  );
                                  },
                                  closeOnTap: true,
                                  ),
                                  IconSlideAction(
                                  caption: 'Supprimer',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () {
                                  supprimerProduit(snapshot.data[index].venteRandomKey);
                                  },
                                  closeOnTap: true,
                                  ),
                              ],
                              child: ListTile(
                                  title: Text(
                                  snapshot.data[index].descriptionProduitVendu,
                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold), ),
                                  leading: CircleAvatar(
                                  backgroundImage: NetworkImage(Url().uri+"produitVendus/"+snapshot.data[index].imageProduitVendu),
                                  ),

                              ),
                          );
                          },
                    ) ;
                    }
                    }
                    ),


            ),
          )
          ],
          ),
                onRefresh: _hundleRefresh)
    );
  }

  void updatePrix(venteRandomKey) {
    pr.show();
    var postPrice = Uri.parse(Url().url+"updateProductPrice");

    http.post(postPrice,body:{
      "venteRandomKey":venteRandomKey,
      "newPrice":_newPrix
    }).then((res) {
      var body = json.decode(res.body);
      if(body['message'] == "ok"){

        newPrix.clear();
        pr.hide();
        Fluttertoast.showToast(
          msg: "Prix modifié avec success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        _hundleRefresh();
        Navigator.pop(context);
      }
      else{
        newPrix.clear();
        pr.hide();
        Fluttertoast.showToast(
          msg: "Une erreur s'est intervenue",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
    print(venteRandomKey);

  }
  void supprimerProduit(venteRandomKey) {
    showDialog(
        context: context,
        builder: (_)=> AlertDialog(
          title: Text("Suppression"),
          content: Text("Voulez-vous supprimer ce produit ?"),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: (){ Navigator.pop(context);},
              icon: Icon(Icons.close,color: Colors.red,),
              label: Text("Non"),),

            FlatButton.icon(
              onPressed: (){
                pr.show();
                String _url = Url().url+"deleteOnMonBoutique";

                http.post(_url,body: {
                  "venteRandomKey":venteRandomKey,

                }).then((res) {
                  var body = json.decode(res.body);
                  if(body['message'] == "ok"){
                    _hundleRefresh();
                    pr.hide();
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: "Commande annulée",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                  }
                  else{
                    pr.hide();
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: "Une ereur est intervenue",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                  }
                });


              },
              icon: Icon(Icons.done,
                color: Colors.green,),label: Text("Oui"),),
          ],
          elevation: 20.0,
        )
    );
  }

  Future<Null> _hundleRefresh() async{

    print("bien");

    Completer<Null> completer = new Completer<Null>();
    new Future.delayed(new Duration(seconds: 2)).then((_){
      completer.complete();
      setState(() {
        _getVente();
      });

    } );
    return completer.future;
  }

}

getNumeroVendeur() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  String num = localStorage.getString("numVendeur");
  print(num);
  return num;
}
class ShopModel{

  final String venteRandomKey;
  final String descriptionProduitVendu;
  final String imageProduitVendu;
  final String prixProduitVendu;

  ShopModel(this.venteRandomKey,this.descriptionProduitVendu,this.prixProduitVendu,this.imageProduitVendu);
}
