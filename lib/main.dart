// ignore_for_file: must_be_immutable

import 'package:bot_toast/bot_toast.dart';
import 'package:finobird/screens/chat/notification_model.dart';
import 'package:finobird/screens/watchlists/company_feed.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/dashboard/navigation.dart';
import 'screens/introduction/intro.dart';

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
final navKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //await setupFlutterNotifications();
  print('Handling a background message ${message.messageId}');
  print('message  ' + message.data.toString());

  /* if(message.data['chat'] != null){
    ChatNotificationModel chatNotificationModel = ChatNotificationModel.fromJson(message.data);
    Navigator.push(navKey.currentContext!, MaterialPageRoute(builder: (context)=> ChatScreen(
      notificationCommunityId: chatNotificationModel.chat!.id!,
      title: chatNotificationModel.chat!.sender!.username.toString(),
      members: '44.7k',
      isJoined: true,
      chatId: chatNotificationModel.chat!.communityId.toString(),
      communityId: chatNotificationModel.chat!.id!,
    )));

    // ChatNotificationModel chatNotificationModel = ChatNotificationModel.fromJson(message.data);
    // Navigator.push(navKey.currentContext!, MaterialPageRoute(builder: (context)=>   ChatScreen(
    //   title: chatNotificationModel.chat!.sender!.username.toString(),
    //   members: '44.7k',
    //   // community: communitiesRepo.communities.value.communities!.first,
    //   chat: Chats(
    //       avatarUrl:chatNotificationModel.chat!.sender!.avatarUrl.toString(),
    //       chatId: chatNotificationModel.chat!.communityId.toString(),
    //       companyId: chatNotificationModel.chat!.senderId,
    //       name:  chatNotificationModel.chat!.sender!.username.toString(),
    //       id: chatNotificationModel.chat!.id,
    //       description: chatNotificationModel.contentPreview.toString()), chatId: chatNotificationModel.chat!.communityId.toString(), communityId: chatNotificationModel.chat!.id!,
    //   isJoined: true,
    // ),
    // ));
  }else  if(message.data['feed'] != null){
    print('feed  ${message.data['feed'].toString()}');
    Navigator.push(navKey.currentContext!, MaterialPageRoute(builder: (context)=> Navigation(index: 1)));
    print('_firebaseMessagingBackgroundHandler else');
  }
*/
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //
  // if (!kIsWeb) {
  //   await setupFlutterNotifications();
  // }
  // firebaseCloudMessagingListeners();
  await configureNotification();
  await firebaseCloudMessagingListeners();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // RxBool loggedIn = false.obs;
    // storedData.getUsernamePassword();
    // if (storedData.username.value != "" &&
    //     storedData.password.value != "" &&
    //     !loggedIn.value) {
    //   log("logging in");
    //   Authentication().login(
    //     storedData.password.value,
    //     storedData.username.value,
    //   );
    //   loggedIn.value = false;
    // }

    final botToastBuilder = BotToastInit();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FinoBird',
      navigatorKey: navKey,
      builder: (context, child) {
        child = botToastBuilder(context, child);
        return child;
      },
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IntroPageView(),
    );
  }
}

Future<void> firebaseCloudMessagingListeners() async {
  FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    // RemoteNotification? notification = message.notification;
    print(
        'Cloud Messaging Listener ======================${message.data.toString()}');
    if (message.data['chat'] != null) {
      ChatNotificationModel chatNotificationModel =
          ChatNotificationModel.fromJson(message.data);
      Navigator.push(
          navKey.currentContext!,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    notificationCommunityId:
                        chatNotificationModel.chat!.communityId.toString(),
                    title:
                        chatNotificationModel.chat!.sender!.username.toString(),
                    members: '44.7k',
                    isJoined: true,
                    chatId: chatNotificationModel.chat!.communityId.toString(),
                    communityId: chatNotificationModel.chat!.id!,
                  )));
    } else if (message.data['feed'] != null) {
      FeedNotificationModel feedNotificationModel =
          FeedNotificationModel.fromJson(message.data);
      print('feedNotificationModel ${feedNotificationModel.feed}');
      print(
          'feedNotificationModel ${feedNotificationModel.feed!.companyTicker}');
      if (feedNotificationModel.feed!.companyTicker != null) {
        Navigator.push(
            navKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => CompanyFeeds(
                    companyName: feedNotificationModel.feed!.companyTicker)));
      } else {
        Navigator.push(navKey.currentContext!,
            MaterialPageRoute(builder: (context) => Navigation(index: 1)));
      }
      print('firebaseCloudMessagingListeners else');
    }

    // if(message.data['chat'] != null){
    //   ChatNotificationModel chatNotificationModel = ChatNotificationModel.fromJson(message.data);
    //   Navigator.push(navKey.currentContext!, MaterialPageRoute(builder: (context)=>   ChatScreen(
    //     title: chatNotificationModel.chat!.sender!.username.toString(),
    //     members: '44.7k',
    //     // community: communitiesRepo.communities.value.communities!.first,
    //     chat: Chats(
    //         avatarUrl:chatNotificationModel.chat!.sender!.avatarUrl.toString(),
    //         chatId: chatNotificationModel.chat!.communityId.toString(),
    //         companyId: chatNotificationModel.chat!.senderId,
    //         name:  chatNotificationModel.chat!.sender!.username.toString(),
    //         id: chatNotificationModel.chat!.id,
    //         description: chatNotificationModel.contentPreview.toString()),
    //         chatId: chatNotificationModel.chat!.communityId.toString(),
    //         communityId: chatNotificationModel.chat!.id!,
    //     isJoined: true,
    //   ),
    //   ));
    // }else{
    //   print('else firebaseCloudMessagingListeners');
    // }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    //print('FirebaseMessaging.onMessage-- > ${message.data.toString()}');
    print('message sender ${message.data}');
    print('Handling a message ${message.data.toString()}');
    print('notification -- > ${notification!.body.toString()}');

    if (message.data.isNotEmpty) {
      if (message.data['chat'] != null) {
        chatNotificationModel1 = ChatNotificationModel.fromJson(message.data);
      } else if (message.data['feed'] != null) {
        feedNotificationModel1 = FeedNotificationModel.fromJson(message.data);
      }
    }

    await Clipboard.setData(ClipboardData(text: message.data.toString()));
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: 'app_icon',
          ),
        ),
        payload: message.data.toString());
  });
}

ChatNotificationModel? chatNotificationModel1;
FeedNotificationModel? feedNotificationModel1;

configureNotification() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  channel = const AndroidNotificationChannel(
    'Notification', // id
    'High Importance Notifications',
    importance: Importance.high,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: DarwinInitializationSettings(),
    // macOS: initializationSettingsMacOS,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {
    print('payload --> ${payload.payload.toString()}');

    if (payload.payload != null) {
      if (chatNotificationModel1 != null) {
        Navigator.push(
            navKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      notificationCommunityId:
                          chatNotificationModel1!.chat!.communityId.toString(),
                      title: chatNotificationModel1!.chat!.sender!.username
                          .toString(),
                      members: '44.7k',
                      isJoined: true,
                      chatId:
                          chatNotificationModel1!.chat!.communityId.toString(),
                      communityId: chatNotificationModel1!.chat!.id!,
                    )));
      } else if (feedNotificationModel1 != null) {
        if (feedNotificationModel1!.feed!.companyTicker != null) {
          Navigator.push(
              navKey.currentContext!,
              MaterialPageRoute(
                  builder: (context) => CompanyFeeds(
                      companyName:
                          feedNotificationModel1!.feed!.companyTicker)));
        } else {
          Navigator.push(navKey.currentContext!,
              MaterialPageRoute(builder: (context) => Navigation(index: 1)));
        }
      }

      // ChatNotificationModel chatNotificationModel = ChatNotificationModel.fromJson(json.decode(payload.payload.toString()));
      // Navigator.push(navKey.currentContext!, MaterialPageRoute(builder: (context)=>   ChatScreen(
      //   title: chatNotificationModel.chat!.sender!.username.toString(),
      //   members: '44.7k',
      //   // community: communitiesRepo.communities.value.communities!.first,
      //   chat: Chats(
      //       avatarUrl:chatNotificationModel.chat!.sender!.avatarUrl.toString(),
      //       chatId: chatNotificationModel.chat!.communityId.toString(),
      //       companyId: chatNotificationModel.chat!.senderId,
      //       name:  chatNotificationModel.chat!.sender!.username.toString(),
      //       id: chatNotificationModel.chat!.id,
      //       description: chatNotificationModel.contentPreview.toString()), chatId: chatNotificationModel.chat!.communityId.toString(), communityId: chatNotificationModel.chat!.id!,
      //   isJoined: true,
      // ),
      // ));
    }
  });

  FirebaseMessaging.instance
      .requestPermission(sound: true, badge: true, alert: true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}


// Future<void> firebaseCloudMessagingListeners() async {
//   FirebaseMessaging.onMessageOpenedApp.listen((message) {
//     RemoteNotification? notification = message.notification;
//     print('Handling a  message ${message.data.toString()}');
//
//     // if (message.data['action'].toString().contains('@')) {
//     //   navigateToActivity(message.data['action']);
//     // } else {
//     //   navigateToChat(message.data['action']);
//     // }
//
//   });
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print('FirebaseMessaging.onMessage-- > ${message.notification.toString()}');
//
//     RemoteNotification? notification = message.notification;
//     print('Handling a  message ${message.data['action'].toString()}');
//     print('notification   -- > ${notification!.body.toString()}');
//
//     flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             icon: 'app_icon',
//           ),
//         ),
//         payload: message.data['action'].toString());
//   });
// }


//app login
//userName: We3
//pass: Test@123
//3.10.0