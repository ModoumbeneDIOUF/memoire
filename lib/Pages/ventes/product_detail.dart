
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:memory/Pages/ventes/my_cart.dart';
import 'package:memory/Api/url.dart';


class ProdcutDetails extends StatefulWidget {
  final venteRandomKey;
  final typeProduitVendu;
  final descriptionProduitVendu;
  final adresseProduitVendu;
  final numero;
  final quantiteProduitVendu;
  final prixProduitVendu;
  final validiteProduitVendu;
  final imageProduitVendu;
  ProdcutDetails(this.venteRandomKey,this.typeProduitVendu,this.descriptionProduitVendu,this.adresseProduitVendu,this.numero,this.quantiteProduitVendu,this.prixProduitVendu,this.validiteProduitVendu,this.imageProduitVendu);

  @override
  _ProdcutDetailsState createState() => _ProdcutDetailsState();
}

class _ProdcutDetailsState extends State<ProdcutDetails> {
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Color(0xFFF1EFF1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Details du produit",style: Theme.of(context).textTheme.bodyText2,),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.shopping_cart,size: 30.0,color: Colors.black,),
            onPressed: (){
              Navigator.of(context).push(new MaterialPageRoute(builder:  (context) => MyCart()));
            },
          ),
          SizedBox(width: 8.0,)
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.0),

            decoration: BoxDecoration(
              color: Color(0xFFF1EFF1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50)
              ),

            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(

                    margin:  EdgeInsets.symmetric(vertical: 20.0),
                    height: MediaQuery.of(context).size.width * 0.8,

                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.width * 0.7,
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            color:Colors.white,
                            shape: BoxShape.circle
                          ),
                        ),
                        Image.network(
                            Url().uri+"produitVendus/"+widget.imageProduitVendu,
                           height: MediaQuery.of(context).size.width * 0.7,
                           width: MediaQuery.of(context).size.width * 0.7,
                            fit: BoxFit.cover,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0 / 2),
                  child: Text(widget.descriptionProduitVendu,style: Theme.of(context).textTheme.headline6,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0 / 2),
                  child: Text(
                    "Quantité : "+widget.quantiteProduitVendu,

                  ),
                ),
                Text("Prix unitaire: "+widget.prixProduitVendu+" Fcfa",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.redAccent),),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0 / 2),
                  child: Text(
                    "Adresse : "+widget.adresseProduitVendu,

                  ),
                ),
                Text("Contact : "+widget.numero),

                SizedBox(height: 20.0,)
              ],
            ),
          ),
          Container(
            margin:  EdgeInsets.all(20.0),
            padding: EdgeInsets.symmetric(
              vertical: 20.0 / 2,
              horizontal: 20.0
            ),
            decoration: BoxDecoration(
              color:Color(0xFFF1EFF1),
              borderRadius: BorderRadius.circular(30)
             ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 50.0),
                  child:FlatButton.icon(onPressed: (){
                     commander(widget.venteRandomKey,widget.descriptionProduitVendu,widget.adresseProduitVendu,widget.numero,widget.prixProduitVendu);
                  }, icon: Icon(Icons.shopping_cart),label: Text("Ajouter au panier"),),

                )
               ,
              ],
            ),
          )
        ],
      ),
    );
  }

   commander(venteRandomKey,des,adresse,numero,prix) async{
     SharedPreferences localStorage = await SharedPreferences.getInstance();
     String num = localStorage.getString("numVolontaire");

     var postUri = Uri.parse(Url().url+"ajouterAmesCommandes");

     http.post(postUri,body: {
       "venteRandomKey":venteRandomKey,
       "desc":des,
       "adresse":adresse,
       "numVendeur":numero,
       "prix":prix,
       "numeroVolontaire":num
     }).then((res) {
       var body = json.decode(res.body);
       if(body['message'] == 'ok'){
        final snackBar = SnackBar(
          // pour le snack on declare globalKey en haut
                content:  Row(
                children: <Widget>[
                Icon(Icons.thumb_up,color: Colors.green,),
                    SizedBox(width: 20),
               Expanded(
               child: Text("Produit ajouté au panier"),
               )
               ],
                 ),
             duration: Duration(seconds: 2),
            );
        globalKey.currentState.showSnackBar(snackBar);

       }
       else{
         final snackBar = SnackBar(
             content:  Row(
               children: <Widget>[
                 Icon(Icons.thumb_down,color: Colors.red,),
                 SizedBox(width: 20),
                 Expanded(
                   child: Text("Produit déjà séléctioné"),
                 )
               ],
             ),
           duration: Duration(seconds: 2),
         );
         globalKey.currentState.showSnackBar(snackBar);

       }
     } ) ;
   }
}
