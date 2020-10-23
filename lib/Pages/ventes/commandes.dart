import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:memory/Api/url.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Commandes extends StatefulWidget {
  @override
  _CommandesState createState() => _CommandesState();
}

class _CommandesState extends State<Commandes> {
  final globalKey = GlobalKey<ScaffoldState>();
  ProgressDialog pr;

  Future<List<CommandeModel>> _getVente() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String num = localStorage.getString("numVendeur");

    String _url = Url().url+"getPanier/"+num;

    var data = await http.get(_url);

    var jsonData = json.decode(data.body);

    List<CommandeModel> commandes = [];

    for (var p in jsonData){
      CommandeModel commande = new CommandeModel(p["venteRandomKey"],p["descriptionPanier"],p["dateCommande"],p["numeroVolontaire"],p["imagePanier"]);
      commandes.add(commande);
    }
    print(commandes);
    return commandes;
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
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
      appBar:  AppBar(
        title: Text("Commandes"),

      ),
      body: RefreshIndicator(
          child: FutureBuilder(
              future: _getVente(),

              builder:(BuildContext context,AsyncSnapshot snapshot){
                  if(snapshot.data == null){
                    return Container(

                      child: Center(
                        child: Text("Panier vide"),
                      ),
                    );
                  }
                  else{
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext contex,int index){
                          return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(Url().uri+"produitVendus/"+snapshot.data[index].imagePanier),),
                              title: Text(snapshot.data[index].descriptionPanier),
                              subtitle: Row(
                                children: <Widget>[
                                    new Text(""+snapshot.data[index].dateCommande),

                                    Container(
                                      margin: EdgeInsets.only(left: 50.0),
                                      child: new Row(
                                        mainAxisAlignment:MainAxisAlignment.spaceAround ,
                                        children: <Widget>[
                                          Container(
                                              child: InkWell(
                                                onTap: (){
                                                  validerCommande(snapshot.data[index].venteRandomKey);
                                                },
                                                child: new Icon(Icons.done,color:Colors.green),

                                              )
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 30.0),
                                            child: InkWell(
                                              onTap: (){
                                                annulationCommande(snapshot.data[index].venteRandomKey);
                                              },
                                              child: new Icon(Icons.close,color: Colors.red,),
                                            ),
                                          )
                                        ],
                                      ) ,
                                    )

                                ],
                              ),
                          );
                        }

                    );
                  }
              }
          ),
          onRefresh: _hundleRefresh) ,
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

   validerCommande(venteRandomKey) {

     showDialog(
        context: context,
        builder: (_)=> AlertDialog(
          title: Text("Validation"),
          content: Text("Le stock est toujour disponible ?"),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: (){
                //'on met le statut du produit à off
                pr.show();
                String _url = Url().url+"updateProductAndPanierStatut";

                http.post(_url,body: {
                  "venteRandomKey":venteRandomKey,

                }).then((res) {
                  var body = json.decode(res.body);
                  if(body['message'] == "ok"){
                    _hundleRefresh();
                    pr.hide();
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: "Commande validée",
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
              icon: Icon(Icons.close,color: Colors.red,),
              label: Text("Non"),
            ),

            FlatButton.icon(
              onPressed: (){

                //'on annule la commande stock rrestant'
                pr.show();
                String _url = Url().url+"updatePanierStatut";

                http.post(_url,body: {
                  "venteRandomKey":venteRandomKey,

                }).then((res) {
                  var body = json.decode(res.body);
                  if(body['message'] == "ok"){
                    _hundleRefresh();
                    pr.hide();
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: "Commande validée",
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
              icon: Icon(Icons.done,color: Colors.green,),
              label: Text("Oui"),
            ),


          ],
        )
     );
  }

  annulationCommande(venteRandomKey){
    showDialog(
        context: context,
        builder: (_)=> AlertDialog(
          title: Text("Annulation"),
          content: Text("Voulez-vous annuler la commande ?"),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: (){ Navigator.pop(context);},
              icon: Icon(Icons.close,color: Colors.red,),
              label: Text("Non"),
            ),

            FlatButton.icon(
              onPressed: (){


                //'on annule la commande'
                pr.show();
                String _url = Url().url+"deleteToPanier";

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
              icon: Icon(Icons.done,color: Colors.green,),
              label: Text("Oui"),
            ),


          ],
        )
    );
  }
}

class CommandeModel{

  final String venteRandomKey;
  final String descriptionPanier;
  final String dateCommande;
  final String numeroVolontaire;
  final String imagePanier;

  CommandeModel(this.venteRandomKey,this.descriptionPanier,this.dateCommande,this.numeroVolontaire,this.imagePanier);
}
