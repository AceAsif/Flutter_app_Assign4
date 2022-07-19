import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stroke_rehab_app/DotGameData.dart';
import './GameScreen.dart';
import './HistoryScreen.dart';
import './SettingScreen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //added this line
  await Firebase.initializeApp(); //This is added for waiting and initialising the app for firebase
  runApp(MyApp());
}

/*Got help from these sources:
* https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
* https://www.javatpoint.com/flutter-bottom-navigation-bar
* https://www.youtube.com/watch?v=xoKqQjSDZ60&ab_channel=JohannesMilke
* */
/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter App for Assign4';

  // Create the initialization Future outside of `build`:
  Future<FirebaseApp> initializeFirebase() async {
    if (!Firebase.apps.isNotEmpty) {
      return await Firebase.initializeApp();
    }
    else
    {
      return Firebase.app();
    }
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: initializeFirebase(),
        builder: (context, snapshot) //this function is called every time the "future" updates
        {
          // Check for errors
          if (snapshot.hasError) {
            return FullScreenText(text: "Something went wrong");
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return ChangeNotifierProvider(
                create: (context) => DotDataModel(),
                child: MaterialApp(
                  //This helps to remove the debug banner
                  debugShowCheckedModeBanner: false,
                  title: _title,
                  //home: MyNavigationBar(),
                  home: SplashScreen(),
                )
              );
            //END: the old MyApp builder from last week
            }
          // Otherwise, show something whilst waiting for initialization to complete
          return FullScreenText(text:"Loading");
          },
    );
  }
}

//Got help from these source:
//SplashScreen plugin: https://pub.dev/packages/animated_splash_screen/install
// Splashscreen tutorial: https://www.youtube.com/watch?v=xZmTxHZ_0AM&ab_channel=CodingOrbit
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          children: <Widget>[
             Image.asset(
               'assets/Sonic_thumbs_up.jpeg',
               height: 200,
             ),
             const Text(
               'Stroke Rehab App',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0,
                    fontFamily: 'Righteous',
                ),
             ),
          ],
        ),
        backgroundColor: Colors.teal,
        nextScreen: MyNavigationBar (),
        splashIconSize: 250,
        splashTransition: SplashTransition.sizeTransition,
    );
  }
}


class MyNavigationBar extends StatefulWidget {
  MyNavigationBar ({Key? key}) : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar > {
  int _selectedIndex = 0;

  final screens = [
    GameScreen(),
    HistoryScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,   //This fixes the keyboard bottom overflow issue
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.videogame_asset_rounded),
                label: 'Game',
                backgroundColor: Colors.teal
            ),
            BottomNavigationBarItem(
                //icon: Icon(Icons.access_time_filled),
                icon: Icon(Icons.history),
                label: 'History',
                backgroundColor: Colors.green
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.indigoAccent,
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 40,
          onTap: _onItemTapped,
      ),
    );
  }
}

//A little helper widget to avoid runtime errors -- we can't just display a Text() by itself if not inside a MaterialApp, so this workaround does the job
class FullScreenText extends StatelessWidget {
  final String text;

  const FullScreenText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection:TextDirection.ltr, child: Column(children: [ Expanded(child: Center(child: Text(text))) ]));
  }
}

// TODO: Link for the plugins
/*
* shared_preferences 2.0.15 : https://pub.dev/packages/shared_preferences
* fluttertoast: ^8.0.9 : https://pub.dev/packages/fluttertoast
* animated_splash_screen: ^1.2.0: https://pub.dev/packages/animated_splash_screen
* intl: ^0.17.0-nullsafety.2: https://pub.dev/packages/intl/versions/0.17.0-nullsafety.2
* share_plus: ^4.0.7: https://pub.dev/packages/share_plus
*
* */