import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:memory/Api/url.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:memory/Pages/responsables.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/date_symbol_data_local.dart';


class EspaceVolontaire extends StatefulWidget {
  @override
  _EspaceVolontaireState createState() => _EspaceVolontaireState();
}

class _EspaceVolontaireState extends State<EspaceVolontaire> {
  final _formKey = GlobalKey<FormState>();
  String _comune;
  String _nombreAider;

  var comune = TextEditingController();
  var nombre = TextEditingController();
  @override

  ProgressDialog pr;
  var getlocalStorage = getNumeroVolontaire();

  Future<List<Dashboard>>  _getDashboard() async{

    var numVolontaire = await getlocalStorage;
    //Text(widget.choise.titre,style: textStyle,);
    String _url = Url().url+"getDonRecup/"+numVolontaire;

    var data = await http.get(_url);

    var jsonData = json.decode(data.body);

    List<Dashboard> dashboards = [];

    for (var o in jsonData){
      Dashboard dashboard = Dashboard(o["donRandomKey"],o["typeOffre"],o["adresse"],o["donneur"],o["volontaire"],o["imageOffre"]);
      dashboards.add(dashboard);
    }
    return dashboards;
  }
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Espace volontaire"),

      ),
        backgroundColor: Colors.blue[100],
      body: RefreshIndicator(
          child: Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 8.0),
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
                                  caption: 'Responsables',
                                  color: Colors.grey.shade200,
                                  icon: Icons.remove_red_eye,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(builder: (context)=>Responsables()));
                                  },
                                  closeOnTap: false,
                                ),
                                IconSlideAction(
                                  caption: 'Annuler',
                                  color: Colors.red,
                                  icon: Icons.thumb_down,
                                  onTap: () {
                                    annulerRecuperation(snapshot.data[index].donRandomKey);
                                  },
                                  closeOnTap: true,
                                ),
                                IconSlideAction(
                                  caption: 'Déja recuperer',
                                  color: Colors.green,
                                  icon: Icons.delete,
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
                                                          child: TextFormField(
                                                            controller: comune,
                                                            onChanged: ((String com){
                                                              setState(() {
                                                                _comune = com;

                                                              });
                                                            }),
                                                            decoration: InputDecoration(
                                                              labelText: "Commune servie",
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
                                                          padding: EdgeInsets.all(8.0),
                                                          child: TextFormField(
                                                            controller: nombre,
                                                            keyboardType: TextInputType.number,
                                                            onChanged: ((String nombre){
                                                              setState(() {
                                                                _nombreAider = nombre;
                                                              });
                                                            }),
                                                            decoration: InputDecoration(
                                                              labelText: "Nombre de personnes aidé",
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
                                                                    dejaRecupere(snapshot.data[index].donRandomKey);
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
                              ],

                              child: ListTile(
                                title: Text(snapshot.data[index].typeOffre,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                subtitle: Row(
                                  children: <Widget>[
                                    new Text("adresse: "+snapshot.data[index].adresse+
                                        "\n contact: "+snapshot.data[index].donneur,
                                        style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),

                                    Container(
                                      margin: EdgeInsets.only(left: 110.0),
                                      child: new Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Container(
                                              child: InkWell(
                                                onTap: (){
                                                  launch("tel:"+snapshot.data[index].donneur);
                                                },
                                                child: new Icon(Icons.call,color:Colors.lightGreenAccent,size: 30,),
                                              ),

                                            )
                                          ],
                                      )
                                    )
                                  ],
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(Url().uri+"nourritureOffert/"+snapshot.data[index].imageOffre),
                                  radius: 25,
                                ),


                              ),



                            );
                          });

                    }
                  } ),
            ),
          ),
          onRefresh: _hundleRefresh)
    );
  }

  annulerRecuperation(donRandomKey) async{
    pr.show();
    //mettre à jour le statut d'une offre (on) dans nourritureOffert

    var getUriOffre = Uri.parse(Url().url+"updateStatusDonRecup/"+donRandomKey);//offre statut de l'offre à on
    var getUriDash = Uri.parse(Url().url+"cancelDonRecup/"+donRandomKey);//dashbard on supprime

    var updateOffre = await http.get(getUriOffre);
    var body = json.decode(updateOffre.body);

    if(body['message'] == "succefully"){
      //on supprime dans dashboard
      var updateDash = await http.get(getUriDash);
      var delete = json.decode(updateDash.body);

      if(delete['delete'] == "ok"){
        pr.hide();
        Fluttertoast.showToast(
          msg: "Recupération annulée",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
      else{
        Fluttertoast.showToast(
          msg: "Une erreur est intervenue",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    }
    else{
      Fluttertoast.showToast(
        msg: "Une erreur est intervenue",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }


  }
  dejaRecupere(donRandomKey){
    initializeDateFormatting();
    DateTime _now = new DateTime.now();
    String periode = new DateFormat("MMMM yyyy","fr").format(_now);
    print(_nombreAider);
    pr.show();

    var getUriDash = Uri.parse(Url().url+"cancelDonRecup/"+donRandomKey);//dashbard on supprime
    var postUriInfo = Uri.parse(Url().url+"infoAide");//ajouter info aide

    http.post(postUriInfo, body: {
      "donRandomKey":donRandomKey,
      "commune":_comune,
      "nombre":_nombreAider,
      "mois":periode,

    }).then((res) async {
      // print(_image);
      var body = json.decode(res.body);
      if(body['message'] == "ok"){

        var updateDash = await http.get(getUriDash);
        var delete = json.decode(updateDash.body);

        if(delete['delete'] == "ok"){
          pr.hide();
          comune.clear();
          nombre.clear();

          Fluttertoast.showToast(
            msg: "Merci de votre bonne volonté !!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );

        }
        else{
          Fluttertoast.showToast(
            msg: "Une erreur est intervenue",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
          );
        }

      }
      else{
        pr.hide();
        print("erreur post");
      }
      //print(json.decode(res.body));
    }).catchError((err) {
      print(err);
    });



  }

 Future<Null> _hundleRefresh() async{

    print("bien");

    Completer<Null> completer = new Completer<Null>();
    new Future.delayed(new Duration(seconds: 3)).then((_){
      completer.complete();
      setState(() {
        _getDashboard();
      });

    } );
    return completer.future;
  }
}

class Dashboard{
  final String donRandomKey;
  final String typeOffre;
  final String adresse;
  final String donneur;
  final String volontaire;
  final String imageOffre;

  Dashboard(this.donRandomKey,this.typeOffre,this.adresse,this.donneur,this.volontaire,this.imageOffre);


}

getNumeroVolontaire() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  String num = localStorage.getString("numVolontaire");
  print(num);
  return num;
}