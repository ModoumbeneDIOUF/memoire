import 'package:flutter/material.dart';
import 'package:memory/Api/url.dart';
import 'package:memory/Login/loginScreen.dart';
import 'package:memory/Pages/offres/offfes.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class DemandeZakat extends StatefulWidget {
  @override
  _DemandeZakatState createState() => _DemandeZakatState();
}

class _DemandeZakatState extends State<DemandeZakat> {

  ProgressDialog pr;

  final _formKey = GlobalKey<FormState>();

  var somme = TextEditingController();
  var cniBeneficiare = TextEditingController();

  String _somme;
  String _cniBeneficiare;

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
        //resizeToAvoidBottomPadding: false,

        appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Demander de la zakat"),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.grey,
      ////////////// Drawer   //////////////
            //////////// le contenu ///////////////
      body: SafeArea(
          child: Container(
            child: Padding(
              padding:EdgeInsets.only(

                top: 10,
              ),
              child: SingleChildScrollView(
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

                      ),

                    ),
                    Container(
                      margin: EdgeInsets.only(top: 7.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: somme,
                                keyboardType: TextInputType.number,
                                onChanged: ((String s){
                                  setState(() {
                                    _somme = s;

                                  });
                                }),
                                decoration: InputDecoration(
                                  labelText: "Somme à demander",
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
                                  else if(value.length < 4){
                                    return 'les demandes commencent à partr de 1000fcfa';
                                  }
                                  return null;
                                },
                              ),

                            ),
                            // CNI benefiacire
                            Padding(

                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(

                                controller: cniBeneficiare,
                                keyboardType: TextInputType.number,
                                onChanged: ((String s){
                                  setState(() {
                                    _cniBeneficiare = s;

                                  });
                                }),
                                decoration: InputDecoration(
                                  labelText: "CNI du bénéfiaire",
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
                                  else if(value.substring(0,1) != "1" && value.substring(0,1) != "2"){
                                    print(value.substring(0,1));
                                    return 'Le numero doit commencer par 1 ou 2';
                                  }
                                  else if(value.length != 13){
                                    return 'Merci de donner un numero au bon format 13 chiffres';
                                  }
                                  return null;
                                },
                              ),

                            ),
                            //Button

                            Center(
                              child: Container(
                                width: 300,
                                margin: EdgeInsets.only(top: 50),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.blue),
                                child: FlatButton(
                                  child: FittedBox(
                                      child: Text(
                                        'Valider',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                        textAlign: TextAlign.center,
                                      )),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {

                                      demanderZakat();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

      ),



    );
  }

   demanderZakat() async{
     pr.show();
     SharedPreferences localStorage = await SharedPreferences.getInstance();
     String num = localStorage.getString("numVolontaire");

     var postUriInfo = Uri.parse(Url().url+"demanderZakkat");//ajouter info aide

     http.post(postUriInfo, body: {
       "numeroDemandeur":num,
       "sommeDemander":_somme,
       "cni":_cniBeneficiare

     }).then((res){
       var body = json.decode(res.body);
       if(body['message'] == "succefully"){
         pr.hide();
         somme.clear();
         cniBeneficiare.clear();
         Fluttertoast.showToast(
           msg: "Votre demande a été prise en compte !!!",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.BOTTOM,
         );
       }
       else{
         pr.hide();
         Fluttertoast.showToast(
           msg: "Une erreur est intervenue",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.TOP,
         );
       }
     } );
   }
}
getNumVolontaire() async {

  SharedPreferences localStorage = await SharedPreferences.getInstance();
  String num = localStorage.getString("numVolontaire");

  return num;
}