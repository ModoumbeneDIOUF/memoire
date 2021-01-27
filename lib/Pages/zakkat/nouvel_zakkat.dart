import 'package:flutter/material.dart';
import 'package:memory/Api/url.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';



class NouvelleZakkat extends StatefulWidget {
  @override
  _NouvelleZakkatState createState() => _NouvelleZakkatState();
}

class _NouvelleZakkatState extends State<NouvelleZakkat> {
  ProgressDialog pr;


  Future<List<SommeActulle>>  _getSommeAuCompte() async{


    //Text(widget.choise.titre,style: textStyle,);
    String _url = Url().url+"somActuelle";

    var data = await http.get(_url);

    var jsonData = json.decode(data.body);

    List<SommeActulle> sommes = [];

    for (var o in jsonData){
      SommeActulle dashboard = SommeActulle(o["id"],o["sommeTotale"],);
      sommes.add(dashboard);
    }

    return sommes;
  }
  var getlocalStorage = getNumeroDonneur();

  final _formKey = GlobalKey<FormState>();
  var somme = TextEditingController();
  String _somme;
  int _groupValue = -1;

  @override
  Widget build(BuildContext context) {
    // ======================= carousel
    Widget image_Carousel = new Container(
      margin: EdgeInsets.only(top: 8.0),
      height: 200.0,
      child: Container(

        child: Column(
          children: <Widget>[
            Expanded(
              child: new Carousel(
                boxFit: BoxFit.cover,
                images: [
                  //AssetImage('assets/welcom/slide11.png'),
                 // AssetImage('assets/welcom/slide2.png'),
                  AssetImage('assets/welcom/slide22.png'),
                 // AssetImage('assets/carouselDonneur/3.png'),
                ],

                autoplay: true,
                //animationCurve: Curves.fastOutSlowIn,
                //animationDuration: Duration(milliseconds: 1000),
                dotSize: 4.0,
                indicatorBgPadding: 2.0,
                dotColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 5,),
            Text("Donnez la somme à envoyer puis émettre l'appel",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
          ],
        )
      ),
    );
    Widget _myRadioButton({String title, int value, Function onChanged, Color active}) {
      return RadioListTile(
        value: value,
        groupValue: _groupValue,
        onChanged: onChanged,


        title: Text(title),
        activeColor: active,

      );
    }
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
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Donner de la zakat'),
      ),
      backgroundColor: Colors.blue[100],
      body: ListView(
         children: <Widget>[
            image_Carousel,
           Container(
               child: Container(
                 color: Colors.white,
                 child: Padding(
                     padding: EdgeInsets.only(
                       right: 10,
                       left: 10,
                       top: 10,

                     ),
                     child: SingleChildScrollView(
                       child: Column(
                         children: <Widget>[
                           Container(
                             margin: EdgeInsets.only(top: 20, bottom: 100),
                             alignment: Alignment.center,
                             child: Column(
                               children: <Widget>[
                                 Container(
                                   child: FutureBuilder(
                                     future: _getSommeAuCompte(),
                                     builder: (BuildContext context,AsyncSnapshot snapshot){
                                       if(snapshot.data == null){
                                         return Container(
                                           child: Center(
                                             child: Text("Chargement en cours..."),
                                           ),
                                         );
                                       }
                                       else{
                                         print(snapshot.data[0].sommeTotale);
                                         return Container(
                                              margin: EdgeInsets.only(top: 5,bottom: 7),
                                             child: new  Text('somme dans le compte ${snapshot.data[0].sommeTotale} Fcfa'));
                                       }
                                     },
                                   ),
                                 ),
                                 Form(
                                     key: _formKey,
                                     child:Column(
                                       mainAxisSize: MainAxisSize.min,
                                       children: <Widget>[
                                         Padding(
                                           padding: EdgeInsets.only(left:8.0,right: 8.0,top:20),
                                           child: TextFormField(
                                             controller: somme,
                                             keyboardType: TextInputType.number,
                                             inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],

                                             onChanged: ((String s){
                                               setState(() {
                                                 _somme = s;

                                               });
                                             }),
                                             decoration: InputDecoration(
                                               labelText: "Montant à envoyer",
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
                                               final n = num.tryParse(value);
                                               if(n == null) {
                                                 return 'Veillez saisir des chiffres';
                                               }
                                               else if (value.isEmpty) {
                                                 return 'Champ obligatoire';
                                               }
                                               else if(value.length < 4){
                                                 return "Le dont commence à partir de 1000fcfa";
                                               }
                                               return null;
                                             },
                                           ),

                                         ),
                                        //le padding

                                          Container(margin: EdgeInsets.only(top: 25),),
                                          Row(
                                            children: <Widget>[
                                              Expanded(child: _myRadioButton(
                                                  title: "Orange money",
                                                  value: 0,
                                                  onChanged: (newValue) => setState(() => _groupValue = newValue),
                                                  active: Colors.deepOrange
                                              ),),
                                              Expanded(child: _myRadioButton(
                                                  title: "Free money",
                                                  value: 1,
                                                  onChanged: (newValue) => setState(() => _groupValue = newValue),
                                                  active: Colors.blue

                                              ),),
                                            ],
                                          ),
                                         Row(
                                           children: <Widget>[
                                             Expanded(child: _myRadioButton(
                                                 title: "E-Money",
                                                 value: 2,
                                                 onChanged: (newValue) => setState(() => _groupValue = newValue),
                                                 active: Colors.purple

                                             ),),
                                             Expanded(child: _myRadioButton(
                                                 title: "Wave",
                                                 value: 3,
                                                 onChanged: (newValue) => setState(() => _groupValue = newValue),
                                                 active: Colors.black

                                             ),),
                                           ],
                                         ),
                                         Row(
                                           children: <Widget>[
                                             Expanded(child: _myRadioButton(
                                                 title: "Wari",
                                                 value: 4,
                                                 onChanged: (newValue) => setState(() => _groupValue = newValue),
                                                 active: Colors.green

                                             ),),
                                             Expanded(child: _myRadioButton(
                                                 title: "Ecobank",
                                                 value: 5,
                                                 onChanged: (newValue) => setState(() => _groupValue = newValue),
                                                 active: Colors.indigo[900]

                                             ),),
                                           ],
                                         ),
                                                                 //===========================Button=============================

                                         Center(
                                           child: Container(
                                             width: 300,
                                             margin: EdgeInsets.only(top: 20),
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
                                               onPressed: () async{
                                                 if (_formKey.currentState.validate()) {
                                                  //2*1*1*77*som*2#
                                                   if(_groupValue == -1){
                                                     Fluttertoast.showToast(
                                                       msg: "Merci de précser la banque à utilser !!!",
                                                       toastLength: Toast.LENGTH_SHORT,
                                                       gravity: ToastGravity.CENTER,
                                                     );
                                                   }
                                                   else if(_groupValue == 0){
                                                     launch("tel://"+Uri.encodeComponent("#144#2*1*1*778004160*"+_somme+"*2#"));

                                                   }
                                                   else{
                                                     launch("tel://"+Uri.encodeComponent("#144#2*1*1*778004160*"+_somme+"*2#"));

                                                   }
                                                   //launch("tel://"+Uri.encodeComponent("#144#2*1*1*778004160*"+_somme+"*2#"));
                                                  // FlutterPhoneDirectCaller.callNumber("77");
                                                  // ajouterZakkat();
                                                 }
                                               },
                                             ),
                                           ),
                                         ),
                                       ],
                                     ) )
                               ],
                             ),
                           )
                         ],
                       ),
                     )
                 ),
               )
           )
         ],

      ),
    );
  }

   ajouterZakkat() async{
     pr.show();
     var numDonneur = await getlocalStorage;

     var postUriInfo = Uri.parse(Url().url+"addNewZakkat");//ajouter info aide

     http.post(postUriInfo, body: {
       "numero":numDonneur,
       "sommeDonner":_somme,

     }).then((res){
       var body = json.decode(res.body);
       if(body['message'] == "succefully"){
         pr.hide();
          somme.clear();
         Fluttertoast.showToast(
           msg: "Merci de votre bonne volonté !!!",
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


getNumeroDonneur() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  String num = localStorage.getString("numDonneur");
  return num;
}
class SommeActulle{
  final int sommeTotale;
  final int id;
  SommeActulle(this.id,this.sommeTotale);
}