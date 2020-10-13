import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory/Login/loginScreen.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:memory/Pages/ventes/new_product.dart';
import 'package:memory/Pages/ventes/my_shop.dart';
import 'package:memory/Pages/ventes/commandes.dart';
import 'package:memory/Api/url.dart';
import 'package:http/http.dart' as http;

class AcceuilVendeur extends StatefulWidget {
  @override
  _AcceuilVendeurState createState() => _AcceuilVendeurState();
}

class _AcceuilVendeurState extends State<AcceuilVendeur> {
  String _somme;
  var somme = TextEditingController();

  String num;
  Future<List<UserConnected>>  _getUser() async{

    // var getlocalStorage = asyncFunc();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    num = localStorage.getString("numVendeur");
    //Text(widget.choise.titre,style: textStyle,);
    String _url = Url().url+"userConected/"+num;

    var data = await http.get(_url);

    var jsonData = json.decode(data.body);

    List<UserConnected> user = [];


    UserConnected me = UserConnected(jsonData["prenom"],jsonData["nom"]);
    user.add(me);

    print(user);
    return user;
  }

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
                      builder:(context)=>NewProduct()));
                },
                splashColor: Colors.blueAccent,
                child: Center(

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.home,size: 70.0,),
                      Text("Vendre un produit",style: new TextStyle(fontSize: 17.0),)
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
                      builder:(context)=>Myshop()));
                },

                splashColor: Colors.blueAccent,
                child: Center(
                  child: Column(

                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.home,size: 70.0,color: Colors.blue,),
                      Text("Ma boutique",style: new TextStyle(fontSize: 17.0),),

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
        title: Text("Vendeur"),
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
              accountEmail: Text(""+num,style: new TextStyle(fontWeight: FontWeight.bold),),
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
                title: Text("Vendre un produit"),
                onTap: (){},
              ),
            ),

            InkWell(
              child: ListTile(
                leading: Icon(Icons.favorite_border,color: Colors.blueAccent),
                title: Text("Ma boutique"),
                onTap: (){},
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
      body: SafeArea(

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
                                        builder: (context) => NewProduct()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Icon(Icons.add,color: Colors.white,size: 50,),
                                    new Container(
                                      child: Text("Nouveau produit",style:TextStyle(color: Colors.white,fontSize: 18)),
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
                                          builder: (context) => Myshop()));
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
                                        child: Text("Ma boutique",style:TextStyle(color: Colors.white,fontSize: 18)),
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
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child:  Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Commandes()));
                        },
                        splashColor: Colors.red,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue
                          ),
                          child: Expanded(
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Icon(Icons.supervisor_account,color: Colors.white,size: 50,),
                                  new Container(
                                    child: Text("Commandes clients",style:TextStyle(color: Colors.white,fontSize: 18)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
      ),

    );
  }
}
class UserConnected{
  final String prenom;
  final String nom;


  UserConnected(this.prenom,this.nom,);
}
