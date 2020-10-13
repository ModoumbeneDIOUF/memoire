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



class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  final globalKey = GlobalKey<ScaffoldState>();
  ProgressDialog pr;

  Future<List<PanierModel>> _getVente() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String num = localStorage.getString("numVolontaire");

    String _url = Url().url+"getPanierClient/"+num;

    var data = await http.get(_url);

    var jsonData = json.decode(data.body);

    List<PanierModel> paniers = [];

    for (var p in jsonData){
      PanierModel vente = new PanierModel(p["venteRandomKey"],p["description"],p["adresse"],p["prix"],p["numVendeur"]);
      paniers.add(vente);
    }
    print(paniers);
    return paniers;
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
        title: Text("Panier"),

      ),
      body: RefreshIndicator(
          child: FutureBuilder(
            future: _getVente(),
            builder: (BuildContext context,AsyncSnapshot snapshot){
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
                        title: Text(snapshot.data[index].description+": adresse "+snapshot.data[index].adresse),
                        subtitle: Row(
                          children: <Widget>[
                            new Text("Contact: "+snapshot.data[index].numVendeur),
                            Container(
                              margin: EdgeInsets.only(left: 70.0),
                              child: new Row(

                                mainAxisAlignment:MainAxisAlignment.spaceAround ,
                                children: <Widget>[

                                  Container(
                                      child: InkWell(
                                        onTap: (){
                                          validerCommande(snapshot.data[index].venteRandomKey);
                                        },
                                        child: new Icon(Icons.done,color:Colors.green),

                                      )),
                                  Container(
                                    margin: EdgeInsets.only(left: 22.0),
                                    child: InkWell(
                                      onTap: (){
                                        annulationCommande(snapshot.data[index].venteRandomKey);
                                      },
                                      child: new Icon(Icons.close,color: Colors.red,),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        leading: Icon(Icons.shopping_basket),


                      ) ;
                    }

                );
              }
            },
          ),
          onRefresh: _hundleRefresh)
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

   validerCommande(venteRandomKey) async{
     initializeDateFormatting();

     pr.show();

     SharedPreferences localStorage = await SharedPreferences.getInstance();
     String num = localStorage.getString("numVolontaire");

     DateTime _now = new DateTime.now();
     String date = new DateFormat("EEEE d MMMM  yyyy","fr").format(_now);

     String _url = Url().url+"addToPanier";

     http.post(_url,body: {
       "venteRandomKey":venteRandomKey,
       "numeroVolontaire":num,
       "dateCommande":date
     }).then((res) {
       var body = json.decode(res.body);
       if(body['message'] == "ok"){
          _hundleRefresh();
         pr.hide();

         Fluttertoast.showToast(
           msg: "Commande validée",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.CENTER,
         );
       }
       else{
         pr.hide();
         Fluttertoast.showToast(
           msg: "Une ereur est intervenue",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.CENTER,
         );
       }
     });

   }

  void annulationCommande(venteRandomKey) {
   showDialog(
      context: context,
      builder: (_)=> AlertDialog(
        title: Text("Annulation"),
        content: Text("Voulez-vous annuler la commande?"),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: (){ Navigator.pop(context);},
            icon: Icon(Icons.close,color: Colors.red,),
            label: Text("Non"),),

          FlatButton.icon(
            onPressed: (){
              pr.show();
              String _url = Url().url+"deleteAmesCommandes";

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

}

class PanierModel{

  final String venteRandomKey;
  final String description;
  final String adresse;
  final String prix;
  final String numVendeur;

  PanierModel(this.venteRandomKey,this.description,this.adresse,this.prix,this.numVendeur);
}
