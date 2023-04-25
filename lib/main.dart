import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/provider/comments_provider.dart';
import 'package:first_app/provider/notification_feed_provider.dart';
import 'package:first_app/provider/theme_provider.dart';
import 'package:first_app/provider/user_provider.dart';
import 'package:first_app/responsive/responsive_layout.dart';
import 'package:first_app/screen/add_post_screen.dart';
import 'package:first_app/screen/signup_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:provider/provider.dart';
import './responsive/mobile_screen_layout.dart';
import './responsive/web_screen_layout.dart';
import './screen/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDxLnR2nyWm3H_uJfjZSUcc5SlGX3ngI8E',
          appId: '1:205012294678:web:c7db369a342581d29c6937',
          messagingSenderId: '205012294678',
          projectId: 'social-app-26d76',
          storageBucket: 'social-app-26d76.appspot.com'),
    );
    runApp(const MyApp());
  } else {
    await Firebase.initializeApp();
    var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For showing messages',
      id: 'social_app',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Social Media App',
      visibility: NotificationVisibility.VISIBILITY_PUBLIC,
      allowBubbles: true,
      enableVibration: true,
      enableSound: true,
      showBadge: true,
    );
    print(result);

    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => CommentsProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => NotifyFeedCountProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ThemeProvider(),
          ),
        ],
        // builder: (context, _) {
        //   final themeProvider = Provider.of<ThemeProvider>(
        //     context,
        //   );

        child: Consumer<ThemeProvider>(
            builder: (context, ThemeProvider themeProvider, child) {
          return MaterialApp(
            title: 'Social Media App',
            debugShowCheckedModeBanner: false,

            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,

            // theme: ThemeData(
            //   fontFamily: 'Poppins-Regular',

            //   // This is the theme of your application.
            //   //
            //   // Try running your application with "flutter run". You'll see the
            //   // application has a blue toolbar. Then, without quitting the app, try
            //   // changing the primarySwatch below to Colors.green and then invoke
            //   // "hot reload" (press "r" in the console where you ran "flutter run",
            //   // or simply save your changes to "hot reload" in a Flutter IDE).
            //   // Notice that the counter didn't reset back to zero; the application
            //   // is not restarted.
            //   colorScheme: ColorScheme.fromSwatch().copyWith(
            //     primary: Color(0xFFEE0F38),
            //     secondary: Color.fromARGB(255, 219, 185, 86),
            //   ),
            // ),

            // home: const ResponsiveLayout(
            //     webScreenLayout: WebScreenLayout(),
            //     mobileScreenLayout: MobileScreenLayout(),),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                      webScreenLayout: WebScreenLayout(),
                      mobileScreenLayout: MobileScreenLayout());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
                return const Login();
              },
            ),

            // home: AddPostScreen(),
          );
        }));
  }
}
