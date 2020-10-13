import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show File,Platform;

import 'package:rxdart/subjects.dart';
class NofificationPlugin{

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification> didReceivedLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
  var initializationSetting;

  NofificationPlugin._(){
    init();
  }

  init() async{
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if(Platform.isIOS){
        _requestIOSPermission();
    }
    initializePlateformSpecifics();
  }

  initializePlateformSpecifics(){
    var initializetionSetingsAndroid = AndroidInitializationSettings('app_notif_icon');
    var initializationsSettingIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id,title,body,payload) async{

        ReceivedNotification receivedNotification = ReceivedNotification(id,title,body,payload);
        didReceivedLocalNotificationSubject.add(receivedNotification);
      }
    );
     initializationSetting = InitializationSettings(initializetionSetingsAndroid, initializationsSettingIOS);

  }
  _requestIOSPermission(){
    flutterLocalNotificationsPlugin.
          resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>().
          requestPermissions(
          alert: false,
          badge: true,
          sound: true
    );

  }

  setListenerForLowerVersion(Function onNotificationInLowerVersions){
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
        onNotificationInLowerVersions(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async{
    await flutterLocalNotificationsPlugin.initialize(initializationSetting,onSelectNotification:(String payload) async{
          onNotificationClick(payload);
    }
    );
  }

  Future<void> showNotification()async{
    var androidChannelSpecifics = AndroidNotificationDetails(
        "chanelId",
        "channelName",
        "channelDescription",

    );

    var IOSChannelSpecifics = IOSNotificationDetails();
    var platFormChannelSpecific = NotificationDetails(androidChannelSpecifics, IOSChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, "title", "body", platFormChannelSpecific,payload: "payload");
  }

  NofificationPlugin nofificationPlugin = NofificationPlugin._();
}

class ReceivedNotification{
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification(this.id,this.title,this.body,this.payload);

}