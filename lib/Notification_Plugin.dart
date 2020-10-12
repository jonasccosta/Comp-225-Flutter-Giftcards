import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_app/Gift_Card.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationPlugin {

  /// Instance of the Flutter Local Notifications Plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();

  /// StreamController that responds when
  final BehaviorSubject<ReceivedNotification> didReceivedLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

  /// Settings for initializing the plugin for the Android and IOS platforms.
  InitializationSettings initializationSettings;

  /// Timezone the user is current in. If no timezone  is provided, the default
  /// timezone is GMT-5 (Chicago).
  String timeZoneName = 'America/Chicago';

  /// The number of notifications scheduled.
  int notificationCount = 0;


  /// Constructor of the Notifications Plugin
  NotificationPlugin() {
    init();
  }

  /// Initializes the Notifications Plugin.
  ///
  /// If the app is running on an IOS device, it is necessary to ask the user for
  /// permission to send notifications.
  init() {
    if (Platform.isIOS) {
      _requestIOSPermission();
    }

    WidgetsFlutterBinding.ensureInitialized();
    initializePlatformSpecifics();
    _configureLocalTimeZone();
  }

  /// Sets the settings for each specific platform.
  initializePlatformSpecifics() async{
    // Initializes the Android settings
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_card_giftcard');

    // Initializes the IOS settings
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          didReceivedLocalNotificationSubject.add(ReceivedNotification(
              id: id, title: title, body: body, payload: payload));
        });

     initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS,);
  }

  /// Configures the time zone the user is currently on.
  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  }

  /// Requests the user for permission to send notifications, if the app is
  /// running on a IOS device.
  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
      alert: false,
      badge: true,
      sound: true,
    );
  }

  /// Configures what happens when the user clicks on a notification.
  ///
  /// When the user clicks on a notification, the method [onNotificationClick],
  /// which is defined on the [_MyHomeScreenState] class, is called.
  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
          onNotificationClick(payload);
        });
  }

  /// Schedules a notification to be sent weekly.
  Future<void> sendWeeklyNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationCount,
        'You have unused gift cards',
        'Buy yourself something nice!',
        _setDateForWeeklyNotification(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'Weekly Reminder',
              'Weekly Reminder',
              'Weekly Reminder',
              icon: 'ic_card_giftcard',
              enableLights: true,
              color: const Color.fromARGB(255, 29, 53, 87),
              importance: Importance.max,
              priority: Priority.high,),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        scheduledNotificationRepeatFrequency: ScheduledNotificationRepeatFrequency.weekly
    );
    notificationCount++;
  }


  /// Configures the date for the weekly notification.
  ///
  /// Currently, the notification is sent on [friday], at 6:00pm, on the user's
  /// timezone.
  tz.TZDateTime _setDateForWeeklyNotification()  {
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // The time in which the method ran.
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 18, 00);

    var friday = 5;

    /// Adds a day to the [scheduledDate] until the day of the week of the
    /// [scheduledDate] is a friday.
    while(scheduledDate.weekday != friday) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }

    /// Sets the scheduled date to be a date in the year 9999, if, for some
    /// reason the scheduled date is before the current time.
    if (scheduledDate.isBefore(now)) {
      scheduledDate = tz.TZDateTime(tz.local, 9999);
    }

    return scheduledDate;
  }

  /// Schedules a notification to be sent on the day a card expires.
  Future<void> sendScheduledNotifications(GiftCard giftCard) async {
    DateTime giftCardExpirationDate = convertStringToDate(giftCard.expirationDate);
    if(giftCardExpirationDate != null){
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationCount,
          'Your ${giftCard.name} gift card expires today',
          'Don\'t let that money go to waste!',
          _setDateForExpiringCardNotification(giftCardExpirationDate),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'CHANNEL_ID Scheduled',
              'CHANNEL_NAME Scheduled',
              'CHANNEL_DESCRIPTION Scheduled',
              icon: 'ic_card_giftcard',
              enableLights: true,
              color: const Color.fromARGB(255, 29, 53, 87),
              importance: Importance.max,
              priority: Priority.high,),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime
      );
      notificationCount++;
    }
  }


  /// Schedules the date for the notification that a card is expiring.
  ///
  /// Currently, the notification is sent at 8:00am on the day the card expires.
  tz.TZDateTime _setDateForExpiringCardNotification(DateTime dateTime)  {
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, dateTime.year, dateTime.month, dateTime.day, 8);

    /// Sets the [scheduledDate] to be a date in the year 99999 if the scheduled
    /// date is before the current time, which means that a card is already
    /// expired.
    if (scheduledDate.isBefore(now)) {
      scheduledDate = tz.TZDateTime(tz.local, 9999);
    }

    return scheduledDate;
  }

  /// Cancels all notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    notificationCount = 0;
    print("All notifications deleted");
  }

  /// Converts the string into a dateTime object
  DateTime convertStringToDate(String dateString){
    var date;
    DateTime dateTime;
    try{
      date = DateFormat('MM/dd/yyyy').parse(dateString);
      dateTime = DateTime(date.year, date.month, date.day);
    }
    catch(ex){
      print(ex);
    }
    return dateTime;
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin();


class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}