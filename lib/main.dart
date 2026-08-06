import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:device_preview/device_preview.dart';
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
import 'package:venus_driver/firebase_options.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/services/location_service.dart';
import 'package:venus_driver/translations/codegen_loader.g.dart';
import 'package:venus_driver/view/splash/splash_screen.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

//import 'package:external_app_launcher/external_app_launcher.dart';
@pragma('vm:entry-point')

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("ddddddd:${message.toString()}");
  print("Handling a background message: ${message.messageId}");
  print("essssss");

  // _navigateToScreenFromNotification();
}

void main() {
  // ── Run everything inside a Crashlytics‑guarded zone ────────────────
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // ── Initialise services before running the app ────────────────────
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await EasyLocalization.ensureInitialized();
    await CacheHelper.init();
    Bloc.observer = AppBlocObserver();
    await WakelockPlus.enable();
    await _initNotifications();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      assetLoader: const CodegenLoader(),
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: DevicePreview(enabled: false, builder: (_) => MyApp()),
    ));
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

Future<void> _initNotifications() async {
  await setupPushNotifications();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
    providesAppNotificationSettings: true,
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    sound: RawResourceAndroidNotificationSound('notification_sound'),
    importance: Importance.max,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  print('User granted permission: '
      '${settings.authorizationStatus}');

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'channel name',
            channelDescription: 'channel description',
            sound: RawResourceAndroidNotificationSound('notification_sound'),
            priority: Priority.high,
            importance: Importance.high,
            fullScreenIntent: true,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            sound: 'notification_sound.caf',
            presentAlert: true,
            presentSound: true,
            presentBadge: true,
          ),
        ),
      );
    }
  });
}

Future<void> setupPushNotifications() async {
  // 🔐 Ask for permission
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // ⚠️ Wait a moment to let APNs token be registered
    await Future.delayed(Duration(seconds: 1));

    // 📬 Get the APNs token (iOS only)
    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    print('📬 APNs Token: $apnsToken');

    // 📲 Now get FCM token
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print('📲 FCM Token: $fcmToken');
  } else {
    print('❌ Permission denied');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        // App went to background — pause GPS to save battery.
        LocationService.instance.pauseTracking();
        break;
      case AppLifecycleState.resumed:
        // App returned to foreground — resume GPS.
        LocationService.instance.resumeTracking();
        break;
      default:
        break;
    }
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
