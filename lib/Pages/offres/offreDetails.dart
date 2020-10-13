import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memory/Api/url.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';



class OffresDetails extends StatefulWidget {
  //pour recuperer les parametres lors de le redirection
  final donRandomKey;
  final typeNourritureOffert;
  final descriptionNourritureOffert;
  final provenanceNourritureOffert;
  final lieuNourritureOffert;
  final quantiteNourritureOffert;
  final numero;
  final imageNourritureOffert;

  OffresDetails({this.donRandomKey,
                this.typeNourritureOffert,
                this.descriptionNourritureOffert,
                this.quantiteNourritureOffert,
                this.provenanceNourritureOffert,
                this.lieuNourritureOffert,
                this.numero,
                this.imageNourritureOffert});
  @override
  _OffresDetailsState createState() => _OffresDetailsState();
}

class _OffresDetailsState extends State<OffresDetails> {
  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    //============================================= loading dialoge
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
    var getlocalStorage = getNumeroVolontaire();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Details de l'offre"),

      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 300.0,
            child: GridTile(
                child:Container(
                  color: Colors.white,
                  child:  Image.network(Url().uri+"nourritureOffert/"+widget.imageNourritureOffert),
                ),
                  footer: new Container(
                    color: Colors.white70,

                    child: ListTile(
                      leading: new Text(widget.descriptionNourritureOffert,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),

                    ),


                  ),

            ),

          ),
          Container(
            child: Text("Provenance: "+widget.provenanceNourritureOffert),
          ),
          Container(
            child: Text("Quantite: "+widget.quantiteNourritureOffert),
          ),
          Container(
            child: Text("Adresse: "+widget.lieuNourritureOffert),
          ),
          Container(
            child: Text("Numero de telephone: "+widget.numero),
          ),
          Container(
            child: RaisedButton.icon(
              //on ajoute dans le dashboard volontaire
                onPressed:() async {
                  var numVonlontaire = await getlocalStorage;
                  print(numVonlontaire);
                  addToDashboard(numVonlontaire,widget.donRandomKey);
                },
                icon: Icon(
                  Icons.favorite

                ),
                label: Text("Recuperer",style: TextStyle(color: Colors.white,fontSize: 16.0),),
                color: Colors.blueAccent,
            ),
          )
        ],
      ),
    );
  }

  addToDashboard(numVolontaire,donRandomKey) async {

    pr.show();
    var getUri = Uri.parse(Url().url+"updateStatus/"+donRandomKey);//pour mettre à jour le statut de l'offre à off

    var postUri = Uri.parse(Url().url+"addToDonRecup");//pour ajouter dans dashbord

    var update = await http.get(getUri);

    var body = json.decode(update.body);
    if(body['message'] == "succefully"){
        //on ajoute dans dashbord si le update s'est bien passé
      http.post(postUri, body: {
        "donRandomKeyOffre":widget.donRandomKey,
        "typeOffre":widget.typeNourritureOffert,
        "adresseOffre":widget.lieuNourritureOffert,
        "donneurOffre":widget.numero,
        "volontaireOffre":numVolontaire,
        "imageOffreOffre":widget.imageNourritureOffert
      }).then((res) {
        // print(_image);
        var body = json.decode(res.body);
        if(body['message'] == "ok"){

          pr.hide();
          print('bien');

          Fluttertoast.showToast(
            msg: "Récupération en attente",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );

          print("bien");
        }
        else{
          pr.hide();
          print("erreur");
        }
        //print(json.decode(res.body));
      }).catchError((err) {
        print(err);
      });
    }
    //s'il ya une erreur au niveau du update
    else{
      pr.hide();
      Fluttertoast.showToast(
        msg: "Une erreur est intervenue",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

    }

  }
}
getNumeroVolontaire() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  String num = localStorage.getString("numVolontaire");
  print(num);
  return num;
}