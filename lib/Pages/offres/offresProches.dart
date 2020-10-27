import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memory/Api/url.dart';
import 'package:path_provider/path_provider.dart';
import 'package:memory/Pages/offres/offreDetails.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class OffresProches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: choises.length,
          child: Scaffold(
            appBar: AppBar(

              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: const Text("Offres prés de chez moi"),
              bottom: TabBar(
                isScrollable: true,
                tabs: choises.map<Widget>((Choise choise){
                  return Tab(
                    text: choise.titre,
                    icon: Icon(choise.icon),
                  );
                }).toList(),
              ),
            ),

            body: TabBarView(
                children:choises.map((Choise choise){
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ChoisePage(
                      choise: choise,
                    ),
                  );
                }).toList() ),
          )),
    );
  }
}
class Choise{
  final String titre;
  final IconData icon;
  const Choise({this.titre,this.icon});

}
const List<Choise> choises = <Choise>[
  Choise(titre: 'Plats',icon: Icons.favorite),
  Choise(titre: 'Fruits ou légumes',icon: Icons.favorite),
  Choise(titre: 'Céréale',icon: Icons.favorite),
  Choise(titre: 'Cosmétique',icon: Icons.favorite),
  Choise(titre: 'Vêtements ou chaussures',icon: Icons.favorite),

];

class ChoisePage extends StatefulWidget{
  const ChoisePage({Key key,this.choise}):super(key:key);
  final Choise choise;


  @override
  _ChoisePageState createState() => _ChoisePageState();
}

class _ChoisePageState extends State<ChoisePage> {

  Future<List<ModelOffre>>  _getOffre() async{
    //Text(widget.choise.titre,style: textStyle,);
    String _url = Url().url+"nourritureList/"+widget.choise.titre;

    var data = await http.get(_url);

    var jsonData = json.decode(data.body);

    List<ModelOffre> offres = [];

    for (var o in jsonData){
      ModelOffre offre = ModelOffre(o["id"],o["donRandomKey"],o["typeNourritureOffert"],o["descriptionNourritureOffert"],o["provenanceNourritureOffert"],o["lieuNourritureOffert"],o["quantiteNourritureOffert"],o["numero"],o["imageNourritureOffert"],o["dateAjoutNourritureOffert"],o["jourRestant"],o["status"] );
      offres.add(offre);
    }
    return offres;
  }

  @ override
  Widget build(BuildContext context) {

    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return RefreshIndicator(
        child: Container(
          child: FutureBuilder(
            future: _getOffre(),
            builder: (BuildContext context,AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Container(
                  child: Center(
                    child: Text("Chargement en cours..."),
                  ),
                );
              }
              else {
                return GridView.builder(
                    itemCount: snapshot.data.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2),
                    itemBuilder: (BuildContext context,int index ){
                      return Card(

                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),

                        ),
                        child: Material(
                          child: InkWell(onTap: ()=>
                              Navigator.of(context).push(
                                  new MaterialPageRoute(builder: (context)=>OffresDetails(
                                    donRandomKey: snapshot.data[index].donRandomKey,
                                    typeNourritureOffert: snapshot.data[index].typeNourritureOffert,
                                    descriptionNourritureOffert: snapshot.data[index].descriptionNourritureOffert,
                                    quantiteNourritureOffert: snapshot.data[index].quantiteNourritureOffert,
                                    provenanceNourritureOffert: snapshot.data[index].provenanceNourritureOffert,
                                    lieuNourritureOffert: snapshot.data[index].lieuNourritureOffert,
                                    numero: snapshot.data[index].numero,
                                    imageNourritureOffert:  snapshot.data[index].imageNourritureOffert,

                                  ))
                              ),
                            child: GridTile(
                                footer: Container(
                                  color: Colors.white70,
                                  child: ListTile(
                                    leading: Text(snapshot.data[index].descriptionNourritureOffert,style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),
                                ),
                                child: Image.network(Url().uri+"nourritureOffert/"+snapshot.data[index].imageNourritureOffert)
                            ),
                          ),),

                      );
                    }
                );

              }
            },
          ),
        ),
        onRefresh: _hundleRefresh);
  }

  Future<Null> _hundleRefresh() async{

    print("bien");

    Completer<Null> completer = new Completer<Null>();
    new Future.delayed(new Duration(seconds: 3)).then((_){
      completer.complete();
      setState(() {
        _getOffre();
      });

    } );
    return completer.future;
  }}

class ModelOffre{
  final String donRandomKey;
  final int id;
  final String typeNourritureOffert;
  final String descriptionNourritureOffert;
  final String provenanceNourritureOffert;
  final String lieuNourritureOffert;
  final  String quantiteNourritureOffert;
  final String numero;
  final String imageNourritureOffert;
  final String dateAjoutNourritureOffert;
  final  String jourRestant;
  final String status;

  ModelOffre(this.id,this.donRandomKey,this.typeNourritureOffert,this.descriptionNourritureOffert,this.provenanceNourritureOffert,this.lieuNourritureOffert,this.quantiteNourritureOffert,this.numero,this.imageNourritureOffert,this.dateAjoutNourritureOffert,this.jourRestant,this.status);

}