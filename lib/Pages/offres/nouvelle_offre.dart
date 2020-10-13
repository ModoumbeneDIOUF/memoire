import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:memory/Api/url.dart';
import 'package:random_string/random_string.dart';
import 'package:fluttertoast/fluttertoast.dart';



class NewOffre extends StatefulWidget {
  @override
  _NewOffreState createState() => _NewOffreState();
}

class _NewOffreState extends State<NewOffre> {
  final globalKey = GlobalKey<ScaffoldState>();

  ProgressDialog pr;
  String _name;
  String _contact;
  String _email;
  String _type;
  String _desc;
  String _quantite;
  String _lieu;
  String _provenance;
  String _numero;
  String _date;
  String _jourRestant;
  String _donRandomKey;
  File _image;
  String base64Image;

  String dropdownValue = "Precisez le type de l'offre";

  var type = TextEditingController();
  var desc = TextEditingController();
  var provenance = TextEditingController();
  var lieu = TextEditingController();
  var quantite = TextEditingController();
  var numero = TextEditingController();
  var date = TextEditingController();
  var jourRestant = TextEditingController();
  var donRandomKey = TextEditingController();

  String img =
      'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png';

  final _formKey = GlobalKey<FormState>();

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
        key: globalKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Nouvelle offre'),
      ),
      body: SafeArea(
          child:Container(
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
                                    onChanged: (String newValue){
                                      setState(() {
                                        dropdownValue = newValue;
                                        _type = dropdownValue;
                                        print(dropdownValue);
                                      });
                                    },
                                    items: <String>["Precisez le type de l'offre",'Plats', 'Fruits ou légumes', 'Céréale','Cosmétique', 'Vêtements ou chaussures']
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
                          labelText: "Description",
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

                      // Provenance  //
                      TextFormField(
                        controller: provenance,
                        onChanged: ((String provenance) {
                          setState(() {
                            _provenance = provenance;
                            print(_provenance);
                          });
                        }),
                        decoration: InputDecoration(
                          labelText: "Provenance",
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
                      // Adresse  //
                      TextFormField(
                        controller: lieu,
                        onChanged: ((String lieu) {
                          setState(() {
                            _lieu = lieu;
                            print(_lieu);
                          });
                        }),
                        decoration: InputDecoration(
                          labelText: "Votre adresse",
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
                      // Quantite  //
                      TextFormField(
                        controller: quantite,
                        onChanged: ((String quantite) {
                          setState(() {
                            _quantite = quantite;
                            print(_quantite);
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
                      // Provenance  //
                      TextFormField(
                        controller: numero,
                        keyboardType: TextInputType.number,
                        onChanged: ((String numero) {
                          setState(() {
                            _numero = numero;
                            print(_numero);
                          });
                        }),
                        decoration: InputDecoration(
                          labelText: "Numero de téléphone",
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
                      // Provenance  //
                      TextFormField(
                        controller: jourRestant,
                        keyboardType: TextInputType.number,
                        onChanged: ((String jour) {
                          setState(() {
                            _jourRestant = jour;
                            print(_jourRestant);
                          });
                        }),
                        decoration: InputDecoration(
                          labelText: "Nombre de jour restant",
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
                )
//======================================Form Finished=======================================================================

                ),
         ],

            ),
          ),

      ),
    )
    )
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
  tryAdd() async {
    if(dropdownValue == "Precisez le type de l'offre"){
      Fluttertoast.showToast(
        msg: "Precisez le type de l'offre",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
    else{
      initializeDateFormatting();
      pr.show();
      var postUri = Uri.parse(Url().url+"offrirNourriture");
      String base64Image = base64Encode(_image.readAsBytesSync());
      String fileName = _image.path.split("/").last;
      DateTime _now = new DateTime.now();
      _donRandomKey = randomAlphaNumeric(25);
      String date = new DateFormat("EEEE d MMMM  yyyy","fr").format(_now);
      http.post(postUri, body: {
        "image": base64Image,
        "fileName":fileName,
        "desc": _desc,
        "type":dropdownValue,
        "provenance":_provenance,
        "lieu": _lieu,
        "quantite":_quantite,
        "numero":_numero,
        "date":date,
        "jourRestant":_jourRestant,
        "donRandomKey":_donRandomKey
      }).then((res) {
        // print(_image);
        var body = json.decode(res.body);
        if(body['messageNewOffre'] == "ok"){
          _resetState();
          pr.hide();
          final snackBar = SnackBar(
            // pour le snack on declare globalKey en haut
            content:  Row(
              children: <Widget>[
                Icon(Icons.thumb_up,color: Colors.green,),
                SizedBox(width: 20),
                Expanded(
                  child: Text("Offre effectuée avec success"),
                )
              ],
            ),
            duration: Duration(seconds: 2),
          );
          globalKey.currentState.showSnackBar(snackBar);


          Fluttertoast.showToast(
            msg: "Offre effectuée avec success",
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
                  child: Text("Une erreur est intervenue au nivau du serveur"),
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
  //======================= API Area to upload image ======================================
  Uri apiUrl = Uri.parse(
      'http://192.168.1.23/back/public/api/offrirNourriture');

  Future<Map<String, dynamic>> _uploadImage(File image) async {
    setState(() {
      pr.show();
    });

    final mimeTypeData =
    lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

    // Intilize the multipart request
    final imageUploadRequest = http.MultipartRequest('POST', apiUrl);

    // Attach the file in the request
    final file = await http.MultipartFile.fromPath(
        'image', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    // Explicitly pass the extension of the image with request body
    // Since image_picker has some bugs due which it mixes up
    // image extension with file name like this filenamejpge
    // Which creates some problem at the server side to manage
    // or verify the file extension

//    imageUploadRequest.fields['ext'] = mimeTypeData[1];
    imageUploadRequest.files.add(file);
    imageUploadRequest.fields['type'] = dropdownValue;
    imageUploadRequest.fields['donRandomKey'] = "random";
    imageUploadRequest.fields['date'] = "date";
    imageUploadRequest.fields['desc'] = _desc;
    imageUploadRequest.fields['lieu'] = _lieu;
    imageUploadRequest.fields['quantite'] = _quantite;
    imageUploadRequest.fields['numero'] = _numero;
    imageUploadRequest.fields['jourRestant'] = _jourRestant;

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {

        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      _resetState();
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _startUploading() async {

    if (_image != null ||
        _name != '' ||
        _email != '' ||

        _contact != '') {

      final Map<String, dynamic> response = await _uploadImage(_image);

      // Check if any error occured
      if (response == null) {
        pr.hide();
        messageAllert('User details updated successfully', 'Success');
      }
    } else {
      messageAllert('Please Select a profile photo', 'Profile Photo');
    }
  }

  void _resetState() {
    setState(() {
      pr.hide();
      _image = null;
      desc.clear();
      lieu.clear();
      provenance.clear();
      quantite.clear();
      numero.clear();
      jourRestant.clear();
    });
  }

  messageAllert(String msg, String ttl) {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Text(ttl),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Text('Okay'),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

}
