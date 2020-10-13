import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memory/Api/url.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';


class Responsables extends StatefulWidget {
  @override
  _ResponsablesState createState() => _ResponsablesState();
}

class _ResponsablesState extends State<Responsables> {

  Future<List<ListResponsable>>  _getDashboard() async{

    //Text(widget.choise.titre,style: textStyle,);
    String _url = Url().url+"getResponsables";

    var data = await http.get(_url);

    var jsonData = json.decode(data.body);

    List<ListResponsable> responsables = [];

    for (var o in jsonData){
      ListResponsable responsable = ListResponsable(o["prenom"],o["nom"],o["adresse"],o["profil"],o["numero"]);
      responsables.add(responsable);
    }
    return responsables;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },

        ),

        title: const Text("Liste des responsables"),

      ),
      backgroundColor: Colors.grey,
      body: Container(
          child: FutureBuilder(
            future: _getDashboard(),
              builder:(BuildContext context,AsyncSnapshot snapshot){
                if(snapshot.data == null){
                  return Container(
                    child: Center(
                      child: Text("Chargement en cours..."),
                    ),
                  );
                }
                else{

                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder:(BuildContext context,int index ){
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),

                          secondaryActions: <Widget>[


                            IconSlideAction(
                              caption: 'Appelez',
                              color: Colors.green,
                              icon: Icons.call,
                              onTap: () {
                                launch("tel:"+snapshot.data[index].numero);
                              },
                              closeOnTap: true,
                            ),
                          ],

                          child: Container(

                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                              snapshot.data[index].prenom+" "+snapshot.data[index].nom,
                                              style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)

                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text("Fonction: "+snapshot.data[index].profil+" à "+snapshot.data[index].adresse),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text("Contact: "+snapshot.data[index].numero),
                                          Spacer(),
                                          //Text("Text2")

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        );
                      });

                }
              }
          )
      ),
    );
  }

}

class ListResponsable{
  final String prenom;
  final String nom;
  final String adresse;
  final String profil;
  final String numero;

  ListResponsable(this.prenom,this.nom,this.adresse,this.profil,this.numero);
}
