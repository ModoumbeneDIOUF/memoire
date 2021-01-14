import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

import 'package:memory/Api/url.dart';
import 'package:memory/Login/loginScreen.dart';
import 'package:memory/Pages/offres/mainOffres.dart';
import 'package:memory/Pages/zakkat/demande_zakat.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory/Pages/offres/dashboard.dart';
import 'package:memory/Pages/ventes/produits.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;


 class AcceuilVolontaire extends StatefulWidget {
   @override
   _AcceuilVolontaireState createState() => _AcceuilVolontaireState();
 }

 class _AcceuilVolontaireState extends State<AcceuilVolontaire> {
   String num;
   ProgressDialog pr;
   Future<List<UserConnected>>  _getUser() async{

    // var getlocalStorage = asyncFunc();
     SharedPreferences localStorage = await SharedPreferences.getInstance();
     num = localStorage.getString("numVolontaire");
     //Text(widget.choise.titre,style: textStyle,);
     String _url = Url().url+"userConected/"+num;

     var data = await http.get(_url);

     var jsonData = json.decode(data.body);

     List<UserConnected> user = [];


       UserConnected me = UserConnected(jsonData["prenom"],jsonData["nom"],jsonData["numero"]);
       user.add(me);

    print(user);
     return user;
   }


   @override
   Widget build(BuildContext context) {
     //============================================= loading dialoge

     pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
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
     asyncFunc();
     return Scaffold(
       appBar: new AppBar(
         title: Text("Volontaire"),
         backgroundColor: Colors.blueAccent,
       ),
       backgroundColor: Colors.blue[100],
        ////////////// Drawer   //////////////
        drawer: new Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Container(
                  child: FutureBuilder(
                      future: _getUser(),
                      builder:(BuildContext context,AsyncSnapshot snapshot){
                        if(snapshot.data == null){
                          print(snapshot.data);
                          return Container(
                            child: Center(
                              child: Text("Chargement en cours..."),
                            ),
                          );
                        }
                        else{
                          print(snapshot.data[0].prenom);

                          return Container(
                              margin: EdgeInsets.only(top: 5,bottom: 7),
                              child: new  Text('${snapshot.data[0].prenom}  ${snapshot.data[0].nom}',
                                style: new TextStyle(fontWeight: FontWeight.w300),
                              ));
                        }
                      } ),
                ),
                accountEmail:  Container(
                          child: FutureBuilder(
                          future: _getUser(),
                          builder:(BuildContext context,AsyncSnapshot snapshot){
                          if(snapshot.data == null){
                              print(snapshot.data);
                              return Container(
                              child: Center(
                              child: Text("Chargement en cours..."),
                              ),
                              );
                          }
                          else{

                          return Container(

                          child: new  Text('${snapshot.data[0].numero}',
                          style: new TextStyle(fontWeight: FontWeight.bold),
                          ));
                          }
                          } ),
                ),

                currentAccountPicture: GestureDetector(
                  child: new CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person,color: Colors.white,),
                  ),
                ),
                decoration: new BoxDecoration(
                  color: Colors.blueAccent
                ),
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text("Offres"),
                onTap: (){
                         Navigator.push(
                           context,
                           new MaterialPageRoute(
                           builder: (context) => MainOffres()));
                      },
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text("Ventes"),
                onTap: (){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => Produits()));
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite_border),
                title: Text("Demander zakat"),
                onTap: (){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => DemandeZakat()));
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Mon espace"),
                onTap: (){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => EspaceVolontaire()));
                },

              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.edit,color: Colors.lightGreen),
                title: Text("Changer de profil"),
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (_)=> AlertDialog(
                        content: Text("Voulez-vous changer de profil ?"),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text("Non"),
                          ),
                          FlatButton(
                            onPressed: (){
                             changer_de_profil();
                            }
                            ,
                            child: Text("Oui"),
                          )
                        ],
                      )
                  );

                },
              ),
              ListTile(
                leading: Icon(Icons.power_settings_new,color: Colors.red),
                title: Text("Se deconecter"),
                onTap: (){

                  showDialog(
                      context: context,
                      builder: (_)=> AlertDialog(
                        content: Text("Voulez-vous vous doconnecter ?"),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text("Non"),
                          ),
                          FlatButton(
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => LogIn()));
                            }
                            ,
                            child: Text("Oui"),
                          )
                        ],
                      )
                  );
                },
              ),

            ],
          ),
        ),
        ///////// fin drawer //////////////
        //////////// le contenu ///////////////
       body: WillPopScope(

         child: Container(
           padding: EdgeInsets.all(20.0),
           child: Column(
             children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 246,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage("assets/welcom/logo2.jpg"),
                      fit: BoxFit.cover,

                    )
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(.1),
                          Colors.black.withOpacity(.1),
                        ]
                      )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, //pour afficher au milieu
                      children: <Widget>[
                       // Text("SunuDon",style: TextStyle(color: Colors.white,fontSize: 35),),
                        SizedBox(height: 20,),


                      ],
                    ),
                  ),

                ),
                Expanded(

                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                      child: GridView.count(
                        crossAxisCount: 2,
                        padding: EdgeInsets.all(0),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 20,
                        children: <Widget>[
                          // card 1
                          Card(
                            color: Colors.transparent,
                            elevation: 0,
                             child: InkWell(
                               onTap: (){
                                 Navigator.push(
                                     context,
                                     new MaterialPageRoute(
                                         builder: (context) => MainOffres()));
                               },
                               child: Container(
                                 decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue
                                  ),
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Icon(Icons.favorite,color: Colors.white,size: 50,),
                                     new Container(
                                      child: Text("Offres",style:TextStyle(color: Colors.white,fontSize: 20)),
                        )
                      ],
                    ),
                  ),
                             ),

                          ),

                          // card 2
                          Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => Produits()));
                              },
                              child: Container(
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                              color:Colors.blue
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Icon(Icons.shopping_cart,color: Colors.white,size: 50,),
                              new Container(
                          child: Text("Ventes",style:TextStyle(color: Colors.white,fontSize: 20)),
                        )
                      ],
                    ),
                  ),
                            )
                          ),

                        ],
                      )
                  ),
                ),

               // deuxieme EspaceVolontaire()
                Expanded(

                  child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: GridView.count(
                        crossAxisCount: 2,
                        padding: EdgeInsets.all(0),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 20,
                        children: <Widget>[
                          // card 1
                          Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => DemandeZakat()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Icon(Icons.favorite_border,color: Colors.white,size: 50,),
                                    new Container(
                                      child: Text("Demander zakat",style:TextStyle(color: Colors.white,fontSize: 20)),
                                    )
                                  ],
                                ),
                              ),
                            ),

                          ),

                          // card 2
                          Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => EspaceVolontaire()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color:Colors.blue
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Icon(Icons.person,color: Colors.white,size: 50,),
                                      new Container(
                                        child: Text("Mon espace",style:TextStyle(color: Colors.white,fontSize: 20)),
                                      )
                                    ],
                                  ),
                                ),
                              )
                          ),

                        ],
                      )
                  ),
                ),

             ],
           ),
         ),
           onWillPop: onWillPop
       ),



     );
   }
   changer_de_profil() async{
     pr.show();
     SharedPreferences localStorage = await SharedPreferences.getInstance();
     String num = localStorage.getString("numVolontaire");
     String _url = Url().url+"updateUserProfil/"+num;
     var updateUserProfil = await http.get(_url);
     var body = json.decode(updateUserProfil.body);
     if(body['message'] == "succefully"){
        pr.hide();

        Fluttertoast.showToast(
          msg: "Votre profil a été modifié vous êtes maintenant un donneur",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );

        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => LogIn()));
     }

   }
   Future<bool> onWillPop () async{
     showDialog(
         context: context,
         builder: (_)=> AlertDialog(
           content: Text("Voulez-vous deconnecter ?"),
           actions: <Widget>[
             FlatButton(
               onPressed: (){
                 Navigator.pop(context);
               },
               child: Text("Non"),
             ),
             FlatButton(
               onPressed: (){
                 Navigator.push(
                     context,
                     new MaterialPageRoute(
                         builder: (context) => LogIn()));
               }
               ,
               child: Text("Oui"),
             )
           ],
         )
     );

   }
 }
 asyncFunc() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  String num = localStorage.getString("numVolontaire");

  return num;
}

class UserConnected{
  final String prenom;
  final String nom;
  final String numero;

  UserConnected(this.prenom,this.nom,this.numero);
}
