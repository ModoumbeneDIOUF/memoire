import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory/Api/users/apiUsers.dart';
import 'package:memory/Home/homeScreen.dart';
import 'package:memory/Login/loginScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController prenomController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController profilController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String dropdownValue = 'Volontaire';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: Stack(
          children: <Widget>[
            /////////////  background/////////////
            new Container(
              padding:EdgeInsets.symmetric(vertical: 0) ,
              width: double.infinity,
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.4, 0.9],
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
                  SizedBox(height: 20,),

                  SizedBox(height: 40,),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(60),topRight: Radius.circular(60)),

                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 10,),

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
                                    // prenom
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.grey[200])),


                                      ),
                                      child:   TextField(
                                        style: TextStyle(color: Color(0xFF000000)),
                                        controller: prenomController,
                                        cursorColor: Color(0xFF9b9b9b),
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.account_circle,
                                            color: Colors.grey,
                                          ),
                                          hintText: "Prenom",
                                          hintStyle: TextStyle(
                                              color: Color(0xFF9b9b9b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                    // nom
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.grey[200])),

                                      ),
                                      child:   TextField(
                                        style: TextStyle(color: Color(0xFF000000)),
                                        controller: nomController,
                                        cursorColor: Color(0xFF9b9b9b),
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.account_circle,
                                            color: Colors.grey,
                                          ),
                                          hintText: "Nom",
                                          hintStyle: TextStyle(
                                              color: Color(0xFF9b9b9b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                    // adresse
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.grey[200])),

                                      ),
                                      child:   TextField(
                                        style: TextStyle(color: Color(0xFF000000)),
                                        controller: adresseController,
                                        cursorColor: Color(0xFF9b9b9b),
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.home,
                                            color: Colors.grey,
                                          ),
                                          hintText: "Adresse",
                                          hintStyle: TextStyle(
                                              color: Color(0xFF9b9b9b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                    // numero
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.grey[200])),

                                      ),
                                      child:   TextField(
                                        style: TextStyle(color: Color(0xFF000000)),
                                        controller: numeroController,
                                        cursorColor: Color(0xFF9b9b9b),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.call,
                                            color: Colors.grey,
                                          ),
                                          hintText: "Numero de telephone",
                                          hintStyle: TextStyle(
                                              color: Color(0xFF9b9b9b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),

                                    // Passeword
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.grey[200])),

                                      ),
                                      child:   TextField(
                                        style: TextStyle(color: Color(0xFF000000)),
                                        controller: passwordController,
                                        cursorColor: Color(0xFF9b9b9b),
                                        keyboardType: TextInputType.text,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: Colors.grey,
                                          ),
                                          hintText: "Mot de passe",
                                          hintStyle: TextStyle(
                                              color: Color(0xFF9b9b9b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                    //Profil
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.grey[200])),

                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: DropdownButtonHideUnderline(
                                              child: ButtonTheme(
                                                alignedDropdown: true,
                                                child: DropdownButton<String>(
                                                  value: dropdownValue,
                                                  iconSize: 20,
                                                  icon: null,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                  ),
                                                  hint: Text('Choisir un profil'),
                                                  onChanged: (String newValue){
                                                    setState(() {
                                                      dropdownValue = newValue;
                                                      print(dropdownValue);
                                                    });
                                                  },
                                                  items: <String>['Volontaire', 'Donneur', 'Vendeur', 'Délégué de quartier','Chef de village']
                                                      .map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),

                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  // Button
                                    Container(
                                      height: 70,
                                      width: 230,
                                      margin: EdgeInsets.only(top: 1),
                                      child:  Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: FlatButton(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8, bottom: 8, left: 10, right: 10),
                                              child: Text(
                                                _isLoading ? 'Validation en cours...' : 'Valider',
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
                                            onPressed: _isLoading ? null :  _handleLogin
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) => LogIn()));
                                          print("pa encor");
                                        },
                                        child:Container(
                                            margin: EdgeInsets.only(bottom:20),
                                            child: Text("Déja membre ?",style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.bold),)),

                                      ),
                                    ),
                                    SizedBox(height: 40,),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'prenom' : prenomController.text,
      'nom' : nomController.text,
      'adresse' : adresseController.text,
      'numero' : numeroController.text,
     // 'profil' : numeroController.text,
      'profil' : dropdownValue,
      'password' : passwordController.text,

    };

    var res = await CallApiUsers().postData(data, 'utilisateurs');
    var body = json.decode(res.body);
    if(body['message'] == "succefully"){
      print("success");
      prenomController.clear();
      nomController.clear();
      adresseController.clear();
      numeroController.clear();
      passwordController.clear();
      //SharedPreferences localStorage = await SharedPreferences.getInstance();
      //localStorage.setString('token', body['token']);
     // localStorage.setString('user', json.encode(body['user']));
      Fluttertoast.showToast(msg: "Inscription réussie");
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => LogIn()));
    }
    else{
      Fluttertoast.showToast(
          msg: "Compte existant",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,);
    }




    setState(() {
      _isLoading = false;
    });



  }
}