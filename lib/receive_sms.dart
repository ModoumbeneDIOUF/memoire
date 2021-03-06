import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory/Api/url.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:memory/Login/loginScreen.dart';
//import 'package:sms_maintained/sms.dart';
import 'package:sms/sms.dart';
import 'package:sms_receiver/sms_receiver.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class getZakaatSMS extends StatefulWidget {
  @override
  _getZakaatSMSState createState() => _getZakaatSMSState();

}

class _getZakaatSMSState extends State<getZakaatSMS> {


  @override
  Widget build(BuildContext context) {
    return MyInbox();
  }

}

class MyInbox extends StatefulWidget{
  @override
  State createState() {
    // TODO: implement createState
    return MyInboxState();
  }

}

class MyInboxState extends State{
  SmsQuery query = new SmsQuery();
  List messagesOrange = new List();
  List messagesFree = new List();
  final globalKey = GlobalKey<ScaffoldState>();



  @override
  initState()  {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    // Message Orange money
    Widget orangeMoney = new Container(
      child:  FutureBuilder(
        future: fetchSMSOrangeMoney() ,
        builder: (context, snapshot)  {

          return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
              ),
              itemCount: messagesOrange.length,
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(

                    leading: Icon(Icons.markunread,color: Colors.pink,),
                    title: Text(messagesOrange[index].address),
                    subtitle: Text(messagesOrange[index].body.toString(),maxLines:3,style: TextStyle(),),

                    onTap: (){
                      if(messagesOrange[index].body.toString().substring(0,23) =="Vous avez recu un depot"){
                        print("bien");
                        print(messagesOrange[index].body.toString().substring(31,32));
                        if(messagesOrange[index].body.toString().substring(31,32) =="."){
                          print("transfert de 1000");
                          print(" messagesOrange[index].body.toString().substring(45,57)");
                           addToCompte(messagesOrange[index].body.toString().substring(27,31),"773283706");

                        }
                         else if(messagesOrange[index].body.toString().substring(32,33) =="."){
                          print("transfert de 10000");
                          print(" messagesOrange[index].body.toString().substring(45,57)");
                           addToCompte(messagesOrange[index].body.toString().substring(27,32),"773283706");

                        }
                        else {
                          print("transfert de 100000");
                           addToCompte(messagesOrange[index].body.toString().substring(27,33),"773283706");

                        }
                       //addToCompte(messagesOrange[index].body.toString().substring(27,31),"773283706");
                        //Fluttertoast.showToast(
                        //  msg: messagesOrange[index].body.toString().substring(45,57)
                        //);
                      }
                      else if(messagesOrange[index].body.toString().substring(0,23) =="Vous avez recu un trans"){
                         print("transfert");
                         // print(messagesOrange[index].body.toString().substring(31,36));
                         if(messagesOrange[index].body.toString().substring(35,36) == "."){
                           print("transfert de 1000");
                           print(messagesOrange[index].body.toString().substring(46,55));
                           addToCompte(messagesOrange[index].body.toString().substring(31,35),messagesOrange[index].body.toString().substring(46,55));

                         }
                         else if(messagesOrange[index].body.toString().substring(36,37) == "."){
                            print("transfert de 10000");
                            print(messagesOrange[index].body.toString().substring(47,56));
                            addToCompte(messagesOrange[index].body.toString().substring(31,36),messagesOrange[index].body.toString().substring(47,56));
                            //print(messagesOrange[index].body.toString().substring(31,36));
                         }
                         else{
                           print("transfert de 100000");
                           addToCompte(messagesOrange[index].body.toString().substring(31,37),"773283706");

                         }
                      }
                      else{

                        Fluttertoast.showToast(
                            msg: "Ce message n'est pas un message de depot"
                        );
                      }
                      //numero source
                     // print(messagesOrange[index].body.toString().substring(42,51));

                    },
                  ),
                );
              });
        },),
    );
    // Message freeMoney
    Widget freeMoney = new Container(
      child:  FutureBuilder(
        future: fetchFreeMoney(),
        builder: (context, snapshot)  {

          return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
              ),
              itemCount: messagesFree.length,
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(

                    leading: Icon(Icons.markunread,color: Colors.pink,),
                    title: Text(messagesFree[index].address),
                    subtitle: Text(messagesFree[index].body.toString(),maxLines:3,style: TextStyle(),),

                    onTap: (){
                      if(messagesFree[index].body.toString().substring(0,23) =="Vous avez recu un depot"){
                        print("bien");
                        addToCompte(messagesFree[index].body.toString().substring(27,31),"773283706");
                        //Fluttertoast.showToast(
                        //  msg: messages[index].body.toString().substring(45,57)
                        //);
                      }
                      else{

                        Fluttertoast.showToast(
                            msg: "Ce message n'est pas un message de depot"
                        );
                      }
                      //numero source
                      print(messagesFree[index].body.toString().substring(42,51));

                    },
                  ),
                );
              });
        },),
    );
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("SMS Zakkat"),
          backgroundColor: Colors.blueAccent,
        ),
        drawer: new Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Administrateur",style: new TextStyle(fontWeight: FontWeight.bold),),
                accountEmail: Text("sunuDon@sunuDon.com",style: new TextStyle(fontWeight: FontWeight.bold),),
                currentAccountPicture: GestureDetector(
                  child: new CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person,color: Colors.white,),
                  ),
                ),
                decoration: new BoxDecoration(
                  color: Colors.blueAccent,

                ),
              ),
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
        body: RefreshIndicator(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(5),topLeft: Radius.circular(5),bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5))
                ),
                child: Text("OrangeMoney",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: orangeMoney,
                    )
                  ],
                )
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(5),topLeft: Radius.circular(5),bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5))
                ),
                child: Text("FreeMoney",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: freeMoney,
                    )
                  ],
                )
              ),

            ],
          ),
       onRefresh: _hundleRefresh, )
    );
  }

  Future<Null> _hundleRefresh() async{

    print("bien");

    Completer<Null> completer = new Completer<Null>();
    new Future.delayed(new Duration(seconds: 3)).then((_){
      completer.complete();
      setState(() {
        _getZakaatSMSState();
      });

    } );
    return completer.future;
  }

  fetchSMSOrangeMoney()
  async {
    messagesOrange = await query.querySms(count: 10,address: "OrangeMoney",kinds: [SmsQueryKind.Inbox],sort: true);
  }

  fetchFreeMoney() async{
    messagesFree = await query.querySms(count: 10,address: "Free Money",kinds: [SmsQueryKind.Inbox],sort: true);


  }

  String getAdress(){
    List<String> adr = ["OrangeMoney","21701","88888"];

    for(int i = 0; i < adr.length; i++){
       print(adr[i]);
       return adr[i];
    }

  }

  void addToCompte(sommeEnvoyer,numDonneur) async {
    //print(sommeEnvoyer);
    showDialog(context: context, builder: (_) =>
    new AlertDialog(
      title: Text("Confirmation"),
      content: Text("Valider la transaction ?"),
      actions: <Widget>[
        FlatButton(
            onPressed: (){
                valideAddCompte(sommeEnvoyer,numDonneur);
                Navigator.pop(context);
            },
            child: Text("Oui"),
            color: Colors.blueAccent,)
      ],
    ));

  }
   valideAddCompte(sommeEnvoyer,numDonneur){
    var postUri = Uri.parse(Url().url+"addNotificationAndUpCompte");

    http.post(postUri,body: {
      "numDonneur":numDonneur,
      "sommeEnvoyer":sommeEnvoyer
    }).then((res){
      var body = json.decode(res.body);
      if(body['message'] == "ok"){

        Fluttertoast.showToast(
            msg: "Transaction effectué avec success"
        );
      }
      else{

      }
    } );
  }

}