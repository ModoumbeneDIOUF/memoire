import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memory/localNotification.dart';
import 'package:memory/receive_sms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory/Api/users/apiUsers.dart';
import 'package:memory/Home/homeScreen.dart';
import 'package:memory/SignUp/signUpScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:memory/Pages/accueil/acceuilDonneur.dart';
import 'package:memory/Pages/accueil/acceuilVonlontaire.dart';
import 'package:memory/Pages/accueil/accueilVendeur.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final globalKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime backButtonpressTime;


  TextEditingController numeroController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ScaffoldState scaffoldState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      resizeToAvoidBottomPadding: false,
      body: WillPopScope(
          child: Container(
            child: Stack(
              children: <Widget>[
                ///////////  background///////////
                new Container(
                    padding:EdgeInsets.symmetric(vertical: 0) ,
                    width: double.infinity,
                    decoration: new BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: [
                          Colors.blue[900],
                          Colors.blue[800],
                          Colors.blue[400],

                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        SizedBox(height: 80,),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/welcom/logo2.jpg',
                                    ),
                                    height: 80.0,
                                    width: 350.0,
                                  ),
                                  //child: Text("SunuDon",style: TextStyle(color: Colors.white,fontSize: 40))
                              ),
                              //Text("Bienvenue dans SunuDon",style: TextStyle(color: Colors.white,fontSize: 18)),

                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(60),topRight: Radius.circular(60)),

                            ),
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding: EdgeInsets.all(30),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 70,),
                                    Container(

                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [BoxShadow(
                                              color: Colors.blue,
                                              blurRadius: 20,
                                              offset: Offset(0, 10)
                                          )]
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(top: 7),
                                            child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              controller: numeroController,

                                              decoration: InputDecoration(
                                                icon: Icon(Icons.account_circle),
                                                labelText: 'Numero de téléphone',
                                                hintText: '771234567'
                                              ),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Champ obligatoire';
                                                }
                                                else if((value.toString().substring(0,2) != "77") && (value.toString().substring(0,2) != "70") && (value.toString().substring(0,2) != "78")&& (value.toString().substring(0,2) != "76")&& (value.toString().substring(0,2) != "33")){
                                                  return 'Fromat du numéro incorecte ';
                                                }
                                                else if ((value.length < 9) || (value.length > 9)){
                                                  return 'Le numéro doit avoir 9 chiffres ';
                                                }
                                                //print(value.toString().substring(0,2));
                                                return null;
                                              },
                                              textInputAction: TextInputAction.next,
                                            ),
                                          ),

                                          //Mot de passe

                                          Container(
                                            margin: EdgeInsets.only(top: 7),
                                            child: TextFormField(
                                              controller: passwordController,
                                              keyboardType: TextInputType.text,
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                  icon: Icon(Icons.vpn_key),
                                                  labelText: 'Mot de passe',
                                                  hintText: '******'
                                              ),
                                              validator: (value) {
                                                if (value.isEmpty) {

                                                  return 'Champ obligatoire';
                                                }
                                                return null;
                                              },
                                              textInputAction: TextInputAction.done,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 40,),
                                    Container(
                                      margin: EdgeInsets.only(left: 140),
                                      child: InkWell(
                                          onTap: (){
                                            print("changer mot de passe");
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) => getZakaatSMS()));
                                                   // builder: (context) => LocalNofificationScreen()));
                                          },
                                          child:Text("Mot de passe oublié ?",style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.bold),)
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      height: 70,
                                      width: 230,
                                      margin: EdgeInsets.only(top: 1),
                                      child:Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: FlatButton(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 8, bottom: 8, left: 10, right: 10),
                                            child: Text(
                                              _isLoading? 'Connection en cours...' : 'Se connecter',
                                              textDirection: TextDirection.ltr,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0,
                                                decoration: TextDecoration.none,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          color: Colors.blue,
                                          disabledColor: Colors.grey,
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                              new BorderRadius.circular(20.0)),
                                          onPressed:(){
                                            if (_formKey.currentState.validate()){
                                              _isLoading ? null : _login();
                                            }
                                          }



                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Container(
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) => SignUp()));
                                          print("pa encor");
                                        },
                                        child:Text("Pas encore membre",style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.bold),),

                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                ),

              ],
            ),
          ),

          onWillPop: onWillPop)
    );
  }

  void _login() async{

    setState(() {
      _isLoading = true;
    });

    var data = {
      'numero' : numeroController.text,
      'password' : passwordController.text
    };

    var res = await CallApiUsers().postData(data, 'user');
      var body = json.decode(res.body);
    //pour voir si la connection c'est bien passé
    if((body['message'])=="succefully"){
      print("bien");
      final snackBar = SnackBar(
        // pour le snack on declare globalKey en haut
        content:  Row(
          children: <Widget>[
            Icon(Icons.thumb_up,color: Colors.green,),
            SizedBox(width: 20),
            Expanded(
              child: Text("Bienvenue"),
            )
          ],
        ),
        duration: Duration(seconds: 2),
      );
      globalKey.currentState.showSnackBar(snackBar);
      Fluttertoast.showToast(
        msg: "Connection réussi",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

      numeroController.clear();
      passwordController.clear();
        if(body['profil']=="Volontaire"){
          SharedPreferences localStorage = await SharedPreferences.getInstance();
          //localStorage.setString('token', body['token']);
          localStorage.setString('numVolontaire', body['numero']);
          localStorage.setString('token', body['numero']);
          Navigator.push(
            context,
          new MaterialPageRoute(
            builder: (context) => AcceuilVolontaire()));
        }
        else if(body['profil']=="Donneur"){
          SharedPreferences localStorage = await SharedPreferences.getInstance();
          localStorage.setString('numDonneur', body['numero']);
          localStorage.setString('token', body['numero']);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => AcceuilDonneur()));

        }
        else if(body['profil']=="Vendeur"){
          SharedPreferences localStorage = await SharedPreferences.getInstance();
          localStorage.setString('numVendeur', body['numero']);
          localStorage.setString('token', body['numero']);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => AcceuilVendeur()));

        }

        else if(body['profil']=="admin"){
          SharedPreferences localStorage = await SharedPreferences.getInstance();
         // localStorage.setString('numVendeur', body['numero']);
          localStorage.setString('token', 'token');
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => getZakaatSMS()));

        }
    }
    else{
      _isLoading = false;
      final snackBar = SnackBar(
        // pour le snack on declare globalKey en haut
        content:  Row(
          children: <Widget>[
            Icon(Icons.thumb_down,color: Colors.red,),
            SizedBox(width: 20),
            Expanded(
              child: Text("Login et/ou mot de passe incorrect"),
            )
          ],
        ),
        duration: Duration(seconds: 2),
      );
      globalKey.currentState.showSnackBar(snackBar);     // print("error");
    }
   // if(body['message']){
     // SharedPreferences localStorage = await SharedPreferences.getInstance();
      //localStorage.setString('token', body['token']);
      //localStorage.setString('user', json.encode(body['user']));
      //Navigator.push(
        //  context,
          //new MaterialPageRoute(
            //  builder: (context) => Home()));
    //}else{
      //_showMsg(body['message']);
    //}


    setState(() {
      _isLoading = false;
    });


  }
  Future<bool> onWillPop () async{
    showDialog(
        context: context,
        builder: (_)=> AlertDialog(
          content: Text("Voulez-vous quitter l'application ?"),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Non"),
            ),
            FlatButton(
              onPressed: ()=>exit(0)
              ,
              child: Text("Oui"),
            )
          ],
        )
    );

  }
  _showSnackBar(mes,icon) { //
    Scaffold.of(context).showSnackBar(
        SnackBar(
            content: Row(
              children: <Widget>[
                Icon(icon),
                SizedBox(width: 20),
                Expanded(
                  child: Text(mes),
                )
              ],
            ))
    );
  }

}
