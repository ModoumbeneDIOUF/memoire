import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:memory/Api/url.dart';
import 'package:random_string/random_string.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


import 'package:shared_preferences/shared_preferences.dart';
class NewProduct extends StatefulWidget {
  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final globalKey = GlobalKey<ScaffoldState>();
  ProgressDialog pr;
  String _type;
  String _desc;
  String _adr;
  String _numero;
  String _qua;
  String _prix;
  String _dateVente;
  String _venteRandomKey;
  String _validiteProduitVendu;

  File _image;
  String base64Image;

  String dropdownValue = "Precisez le type du produit";

  var type = TextEditingController();
  var desc = TextEditingController();
  var prix = TextEditingController();
  var adr = TextEditingController();
  var qua = TextEditingController();
  var numero = TextEditingController();
  var dateVente = TextEditingController();
  var validiteProduitVendu = TextEditingController();
  var venteRandomKey = TextEditingController();

  String img =
      'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
      key: globalKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Nouveau produit'),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding:EdgeInsets.only(
              right: 10,
              left: 10,
              top: 10,

            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: _image == null
                                  ? AssetImage(
                                'assets/galleryOrTakepicture/interogation.png',)
                                  : FileImage(_image),
                              radius: 50.0,
                            ),
                            InkWell(
                              onTap: _onAlertPress,
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40.0),
                                      color: Colors.black),
                                  margin: EdgeInsets.only(left: 70, top: 70),
                                  child: Icon(
                                    Icons.photo_camera,
                                    size: 25,
                                    color: Colors.white,
                                  )),
                              ),


                          ],
                        ),
                        Text('Image',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                ),
                  //================================Form===========================================================
                  // type //
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 100),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 15,right: 15,top: 5),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          value: dropdownValue,
                                          iconSize: 30,
                                          icon: null,

                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                          hint: Text('Select State'),
                                          disabledHint: Center(),
                                          onChanged: (String newValue){
                                            setState(() {
                                              dropdownValue = newValue;
                                              _type = dropdownValue;

                                              print(dropdownValue);
                                            }

                                            );

                                          },

                                          items: <String>["Precisez le type du produit",'Cosmétique', 'Fruits ou légumes', 'Céréale', 'Vêtements ou chaussures']
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

                            // description  //
                            TextFormField(
                              controller: desc,
                              onChanged: ((String desc) {
                                setState(() {
                                  _desc = desc;
                                  print(_desc);

                                });
                              }),
                              decoration: InputDecoration(
                                labelText: "Description du produit",
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
                            // quantite
                            TextFormField(
                              controller: qua,
                              onChanged: ((String qu) {
                                setState(() {
                                  _qua = qu;
                                  print(_qua);
                                });
                              }),
                              decoration: InputDecoration(
                                labelText: "Quantité",
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
                            //prix
                            TextFormField(
                              controller: prix,
                              keyboardType: TextInputType.number,
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],

                              onChanged: ((String p) {
                                setState(() {
                                  _prix = p;
                                  print(_prix);
                                });
                              }),
                              decoration: InputDecoration(
                                labelText: "Prix unitaire",
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
                                return null;
                              },
                            ),

                            //validité ou date expiration
                            TextFormField(
                              controller: validiteProduitVendu,
                              onTap:() async{
                                initializeDateFormatting();
                                DateTime date = DateTime(2000);
                                DateTime _now = new DateTime.now();
                                String date1 = new DateFormat("EEEE d MMMM  yyyy","fr").format(_now);

                                FocusScope.of(context).requestFocus(new FocusNode());
                                date = await showDatePicker(
                                    context: context,

                                    initialDate:DateTime.now(),
                                    firstDate:DateTime(2020),
                                    lastDate: DateTime(2100));

                                validiteProduitVendu.text = new DateFormat("d MMMM yyyy","fr").format(date);
                                _validiteProduitVendu = new DateFormat("d MMMM yyyy","fr").format(date);
                              } ,
                              decoration: InputDecoration(
                                labelText: "Date exp",
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

                            // adresse

                            TextFormField(
                              controller: adr,
                              onChanged: ((String a) {
                                setState(() {
                                  _adr = a;
                                  print(_adr);
                                });
                              }),
                              decoration: InputDecoration(
                                labelText: "Adresse",
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
                            //numero de telefone

                            TextFormField(
                              controller: numero,
                              keyboardType: TextInputType.number,
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],

                              onChanged: ((String a) {
                                setState(() {
                                  _numero = a;
                                  print(_numero);
                                });
                              }),
                              decoration: InputDecoration(
                                labelText: "Numero de telephone",
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
                                else if((value.toString().substring(0,2) != "77") && (value.toString().substring(0,2) != "70") && (value.toString().substring(0,2) != "78")&& (value.toString().substring(0,2) != "76")&& (value.toString().substring(0,2) != "33")){
                                  return 'Fromat du numéro incorecte ';
                                }
                                else if ((value.length < 9) || (value.length > 9)){
                                  return 'Le numéro doit avoir 9 chiffres ';
                                }
                                return null;
                              },
                            ),

                            //===========================Button=============================

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
                                      tryAdd();
                                      //_startUploading();
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

  //============================Funcions Area==============================================

  //========================= Gellary / Camera AlerBox
  void _onAlertPress() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/galleryOrTakepicture/gallery.png',
                      width: 50,
                    ),
                    Text('Gallery'),
                  ],
                ),
                onPressed: getGalleryImage,
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/galleryOrTakepicture/take_picture.png',
                      width: 50,
                    ),
                    Text('Take Photo'),
                  ],
                ),
                onPressed: getCameraImage,
              ),
            ],
          );
        });
  }
  // ================================= Image from camera
  Future getCameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;

      Navigator.pop(context);
    });
  }

  //============================== Image from gallery
  Future getGalleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;

      Navigator.pop(context);
    });
  }

  void tryAdd() async{
    if(dropdownValue == "Precisez le type du produit"){
      Fluttertoast.showToast(
        msg: "Precisez le type du produit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
    else{
      initializeDateFormatting();
      pr.show();
      var postUri = Uri.parse(Url().url+"vendreProduit");
      String base64Image = base64Encode(_image.readAsBytesSync());
      String fileName = _image.path.split("/").last;
      DateTime _now = new DateTime.now();
      _venteRandomKey = randomAlphaNumeric(25);
      String date = new DateFormat("d MMMM  yyyy","fr").format(_now);
      //print(validiteProduitVendu.text);
      http.post(postUri, body: {
        "image": base64Image,
        "fileName":fileName,
        "descriptionProduitVendu": _desc,
        "typeProduitVendu":dropdownValue,
        "adresseProduitVendu":_adr,
        "quantiteProduitVendu":_qua,
        "numero":_numero,
        "dateVente":date,
        "validiteProduitVendu":validiteProduitVendu.text,
        "prixProduitVendu":_prix,
        "venteRandomKey":_venteRandomKey
      }).then((res) {
        // print(_image);
        var body = json.decode(res.body);
        if(body['messageNewProduct'] == "ok"){
          _resetState();
          pr.hide();
          final snackBar = SnackBar(
            // pour le snack on declare globalKey en haut
            content:  Row(
              children: <Widget>[
                Icon(Icons.thumb_up,color: Colors.green,),
                SizedBox(width: 20),
                Expanded(
                  child: Text("Vente effectuée avec success"),
                )
              ],
            ),
            duration: Duration(seconds: 2),
          );
          globalKey.currentState.showSnackBar(snackBar);

          Fluttertoast.showToast(
            msg: "Vente effectuée avec success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );

          print("bien");
        }
        else{
          pr.hide();
          final snackBar = SnackBar(
            // pour le snack on declare globalKey en haut
            content:  Row(
              children: <Widget>[
                Icon(Icons.thumb_down,color: Colors.red,),
                SizedBox(width: 20),
                Expanded(
                  child: Text("Erreur au niveau du serveur"),
                )
              ],
            ),
            duration: Duration(seconds: 2),
          );
          globalKey.currentState.showSnackBar(snackBar);

          print("erreur");
        }
        //print(json.decode(res.body));
      }).catchError((err) {
        print(err);
      });
    }

  }

  void _resetState() {
    setState(() {
      pr.hide();
      _image = null;
      desc.clear();
      adr.clear();
      qua.clear();
      prix.clear();
      numero.clear();
      validiteProduitVendu.clear();
    });
  }
}
