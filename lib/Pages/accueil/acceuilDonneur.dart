import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory/Login/loginScreen.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:memory/Pages/offres/nouvelle_offre.dart';
import 'package:memory/Pages/zakkat/nouvel_zakkat.dart';
import 'package:flutter/cupertino.dart';
import 'package:memory/notificationPlugin.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:memory/Api/url.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


class AcceuilDonneur extends StatefulWidget {
  @override
  _AcceuilDonneurState createState() => _AcceuilDonneurState();
}

class _AcceuilDonneurState extends State<AcceuilDonneur> {
  String _somme;
  var somme = TextEditingController();
  String num;

  Future<List<UserConnected>>  _getUser() async{

    // var getlocalStorage = asyncFunc();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    num = localStorage.getString("numDonneur");
    //Text(widget.choise.titre,style: textStyle,);
    String _url = Url().url+"userConected/"+num;

    var data = await http.get(_url);

    var jsonData = json.decode(data.body);

    List<UserConnected> user = [];


    UserConnected me = UserConnected(jsonData["prenom"],jsonData["nom"],jsonData['numero']);
    user.add(me);

    print(user);
    return user;
  }

  // neeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeewwwwwwwwwwwwwwwwwwwwwwwww
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
        //showNotification();
    seeNotification();
  }

  Future onSelectNotification(String payload){

    debugPrint("payload : $payload");
    if(payload != null) {
      showDialog(context: context, builder: (_) =>
      new AlertDialog(

        title: Text("Notification"),
        content: Text(payload),
         actions: <Widget>[
           FlatButton.icon(

             onPressed: () async{
               // on supprime le numero dans notification
               //Navigator.pop(context);
               SharedPreferences localStorage = await SharedPreferences.getInstance();
               String num = localStorage.getString("numDonneur");
               String _url = Url().url+"deleteNotification/"+num;
               var data = await http.get(_url);
               var body = json.decode(data.body);
               if(body['message'] =="ok"){
                 Navigator.pop(context);
               }

               },
             icon: Icon(Icons.done,color: Colors.green,),
             label: Text("OK"),

           ),

         ],
      ),
      barrierDismissible: false);
    }

  }
  showNotification(sommeEnvoyer) async{

    var android = AndroidNotificationDetails(
        "channelId",
        "channelName",
        "channelDescription",
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'test'
    );
    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android,ios);

    await flutterLocalNotificationsPlugin.show(0, "Notification", "Cliquez pour lire le message", platform,payload: "Votre transfert de $sommeEnvoyer a été reçu avec success");
  }

  seeNotification() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String num = localStorage.getString("numDonneur");
    String _url = Url().url+"getNotification/"+num;
    var data = await http.get(_url);
    var body = json.decode(data.body);
   // var jsonData = json.decode(data.body['message']);

    if(body['message'] =="ok"){
      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      var androidInitializationSettings = AndroidInitializationSettings('app_notif_icon');
      var iosInitializationSettings = IOSInitializationSettings();
      var initSettings = InitializationSettings(androidInitializationSettings,iosInitializationSettings);
      flutterLocalNotificationsPlugin.initialize(initSettings,onSelectNotification: onSelectNotification);

      showNotification(body['sommeEnvoyer']);

    }
  }
  // eeeeeeeeeeeeeeeeeeeeeeeeeeeeeennnnnnnnnnnnnnnndddddddddddd
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
    Widget grid = new Container(
      padding: EdgeInsets.all(30.0),

      child: GridView.count(
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 30.0,
          padding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 100.0),
          shrinkWrap: true,
          crossAxisCount: 2,

          physics: ScrollPhysics(),
          children: <Widget>[

            ///////// premier card ///////////
            Card(
              margin: EdgeInsets.all(0.0),
              elevation: 30.0,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),

              ),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(
                                            builder:(context)=>NewOffre()));
                },
                splashColor: Colors.blueAccent,
                child: Center(

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.home,size: 70.0,),
                      Text("Nouvellee offre",style: new TextStyle(fontSize: 17.0),)
                    ],
                  ),
                ),
              ),
            ),
            //////////// second card ////////////
            Card(
              margin: EdgeInsets.all(0.0),
              elevation: 30.0,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),

              child: InkWell(
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(
                      builder:(context)=>NouvelleZakkat()));
                },

                splashColor: Colors.blueAccent,
                child: Center(
                  child: Column(

                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.home,size: 70.0,color: Colors.blue,),
                      Text("Donner de la zakkat",style: new TextStyle(fontSize: 17.0),),

                    ],
                  ),
                ),
              ),
            ),

          ]),
    );
    return Scaffold(
      appBar: new AppBar(
        elevation: 2.0,
        title: Text("Donneur"),
      ),
      backgroundColor: Colors.grey,
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
              accountEmail: Container(
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
            InkWell(
              child: ListTile(
                leading: Icon(Icons.favorite,color: Colors.blueAccent,),
                title: Text("Nouvelle offre"),
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(
                      builder:(context)=>NewOffre()));
                },
              ),
            ),
            
            InkWell(
              child: ListTile(
                leading: Icon(Icons.attach_money,color: Colors.blueAccent),
                title: Text("Donner de la zakkat"),
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(
                      builder:(context)=>NouvelleZakkat()));
                },
              ),
            ),
           Divider(),
           InkWell(
             child: ListTile(
               leading: Icon(Icons.power_settings_new,color: Colors.red),
               title: Text("Se deconecter"),
               onTap: (){
                 Navigator.push(
                     context,
                     new MaterialPageRoute(builder: (context)=>LogIn())
                 );
               },
             ),
           ),
          ],
        ),
      ),
      body:  WillPopScope(

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
                        //image: AssetImage("assets/carouselDonneur/2.jpg"),
                        image: AssetImage("assets/welcom/logo2.jpg"),
                        fit: BoxFit.fitWidth,

                      )
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
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
                        //Text("SunuDon",style: TextStyle(color: Colors.white,fontSize: 35),),
                        SizedBox(height: 20,),


                      ],
                    ),
                  ),

                ),
                Expanded(

                  child: Container(
                      margin: EdgeInsets.only(top: 70),
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
                                        builder: (context) => NewOffre()));
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
                                      child: Text("Nouvelle offre",style:TextStyle(color: Colors.white,fontSize: 20)),
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
                                          builder: (context) => NouvelleZakkat()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color:Colors.blue
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Icon(Icons.attach_money,color: Colors.white,size: 50,),
                                      new Container(
                                        child: Text("Donner zakkat",style:TextStyle(color: Colors.white,fontSize: 20)),
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
        onWillPop: onWillPop,
      ),
      
    );
  }
  void logout() async{


      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => LogIn()));

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

class UserConnected{
  final String prenom;
  final String nom;
  final String numero;


  UserConnected(this.prenom,this.nom,this.numero);
}
