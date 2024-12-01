import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/bloc_observer.dart';
import 'package:venus_driver/view/auth/presentation/screens/login_screen.dart';
import 'package:venus_driver/view/home/presentation/screen/home_screen.dart';
import 'package:venus_driver/widgets/error_internet_screen.dart';
import 'package:venus_driver/firebase_options.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/helpers/netwok_info.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/translations/codegen_loader.g.dart';
import 'package:venus_driver/view/splash/splash_screen.dart';
import 'package:wakelock/wakelock.dart';

//import 'package:external_app_launcher/external_app_launcher.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("ddddddd:${message.toString()}");
  print("Handling a background message: ${message.messageId}");
  print("essssss");

  // _navigateToScreenFromNotification();
}

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      name: "VenusCaptin",
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await EasyLocalization.ensureInitialized();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    await CacheHelper.init();
    Bloc.observer = AppBlocObserver();
    Wakelock.enable();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      // description
      importance: Importance.max,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    print('User granted permission: ${settings.authorizationStatus}');
    /*FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }*/
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      print("essssss");
      // _navigateToScreenFromNotification();

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'channel id',
                'channel name',
                channelDescription: 'channel description',
                priority: Priority.high,
                importance: Importance.high,
                fullScreenIntent: true,
                icon: '@mipmap/ic_launcher',
              ),
              iOS: DarwinNotificationDetails(),
            ));
      }
    });
    runApp(EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        assetLoader: const CodegenLoader(),
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MyApp()));
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Map _source = {ConnectivityResult.none: false};
  void _checkInternet() {
    NetworkConnectivity.instance.initialise();
    NetworkConnectivity.instance.myStream.listen((source) {
      _source = source;
      log('source $_source');
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          _source.values.toList()[0]
              ? log('Network Connection')
              : MagicRouter.navigateTo(const ErrorScreen());
          break;
        case ConnectivityResult.wifi:
          _source.values.toList()[0]
              ? log('Network Connection')
              : MagicRouter.navigateTo(const ErrorScreen());
          break;
        case ConnectivityResult.none:
        default:
          MagicRouter.navigateTo(const ErrorScreen());
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _checkInternet();
    // setupInteractedMessage();
  }

  // Future<void> setupInteractedMessage() async {
  //   // Get any messages which caused the application to open from
  //   // a terminated state.
  //   RemoteMessage? initialData =
  //       await FirebaseMessaging.instance.getInitialMessage();

  //   // If the message also contains a data property with a "type" of "chat",
  //   // navigate to a chat screen
  //   if (initialData != null) {
  //     _handleNavigator(initialData);
  //   }

  //   // Also handle any interaction when the app is in the background via a
  //   // Stream listener
  //   FirebaseMessaging.onMessageOpenedApp.listen(_handleNavigator);
  // }

  // void _handleNavigator(RemoteMessage message) {
  //   if (message.data['firstName'] == 'Hasan') {
  //     MagicRouter.navigateTo(const ErrorScreen());
  //     log(message.data.toString());
  //     String firstName = message.data['firstName'];
  //     String lastName = message.data['lastName'] ?? "";
  //     log(firstName);
  //     log(lastName);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: const SplashScreen(),
            scaffoldMessengerKey: globalScaffoldKey,
            debugShowCheckedModeBanner: false,
            title: 'Venus Driver',
            onGenerateRoute: onGenerateRoute,
            theme: ThemeData(
                fontFamily: 'Cairo',
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor: Colors.white),
          );
        });
  }
}
