import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:memory/notificationPlugin.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class LocalNofificationScreen extends StatefulWidget {
  @override
  _LocalNofificationScreenState createState() => _LocalNofificationScreenState();
}

class _LocalNofificationScreenState extends State<LocalNofificationScreen> {

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      home: LocalNotifications(),
   );

  }

}

class LocalNotifications extends StatefulWidget {
  @override
  _LocalNotificationsState createState() => _LocalNotificationsState();
}

class _LocalNotificationsState extends State<LocalNotifications> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var androidInitializationSettings = AndroidInitializationSettings('app_notif_icon');
    var iosInitializationSettings = IOSInitializationSettings();
    var initSettings = InitializationSettings(androidInitializationSettings,iosInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initSettings,onSelectNotification: onSelectNotification);

  }

  Future onSelectNotification(String payload){

    debugPrint("payload : $payload");
    if(payload != null) {
      showDialog(context: context, builder: (_) =>
      new AlertDialog(
        title: Text("Notification"),
        content: Text("Text"),
      ));
    }


  }
 showNotification() async{

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

   await flutterLocalNotificationsPlugin.show(0, "title", "body", platform,payload: "testttt");
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: Center(
        child: FlatButton(
          onPressed:showNotification ,

          child: Text("Send notification"),
        ),
      ),
    );
  }
}

