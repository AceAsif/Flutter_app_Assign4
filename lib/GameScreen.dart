import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stroke_rehab_app/FreeToPlay.dart';
import 'package:stroke_rehab_app/TapGame.dart';

import 'DotGame.dart';


class GameScreen extends StatelessWidget {
  static const String _title = 'Game Screen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //This helps to remove the debug banner
      debugShowCheckedModeBanner: false,
      title: _title,
      home: GameScreenDisplay (),
    );
  }
}

class GameScreenDisplay extends StatefulWidget {
  GameScreenDisplay ({Key? key}) : super(key: key);

  @override
  _GameScreenDisplayState createState() => _GameScreenDisplayState();
}

//Got help from these source:
// tabbar: https://www.javatpoint.com/flutter-tabbar
// align: https://www.geeksforgeeks.org/align-widget-in-flutter/
// Rows: https://www.youtube.com/watch?v=a6oKFvGuTH4&list=PL4cUxeGkcC9jLYyp2Aoh6hcWuxFDX6PBJ&index=11&ab_channel=TheNetNinja
// SnackBar: https://docs.flutter.dev/cookbook/design/snackbars
// Keyboard bottom overflow issue: https://medium.com/zipper-studios/the-keyboard-causes-the-bottom-overflowed-error-5da150a1c660
// Dismiss keyboard using button: https://blog.logrocket.com/how-to-open-dismiss-keyboard-flutter/
// Shared preference guide: https://codesinsider.com/flutter-sharedpreferences/
// Video for shared preference: https://www.youtube.com/watch?v=szOllHT1S7Y&ab_channel=JohannesMilke
// FutureBuilder: https://blog.logrocket.com/async-callbacks-with-flutter-futurebuilder/
// Detect Enter button from keyboard: https://stackoverflow.com/questions/54860198/detect-enter-key-press-in-flutter
class _GameScreenDisplayState extends State<GameScreenDisplay> {
  var txtNameController = TextEditingController(); //This is for Text editing field.

  //Got help from this source: https://petercoding.com/flutter/2021/03/19/using-shared-preferences-in-flutter/
  //These are for shared preference
  @override
  void initState() {
    super.initState();
    txtNameController.addListener(updateUsername);
  }


  getUserName() async {
    final prefer = await SharedPreferences.getInstance();
    var username = prefer.getString("UserName") ?? "Sonic";
    txtNameController.text = username;
  }

  updateUsername() async {
    final prefer = await SharedPreferences.getInstance();
    prefer.setString("UserName", txtNameController.text);
  }
  //shared preference ends

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: getUserName(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return GameScreenText(text: "Bro, Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                appBar: AppBar(
                    title: const Text('Game'),
                    centerTitle: true,
                    //This helped me to set the title in the center position.
                    backgroundColor: Colors.teal[400]
                ),
                resizeToAvoidBottomInset: false,
                //This fixes the keyboard bottom overflow issue
                body: Center(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //This is the Game icon and Title part.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //This is for the horizontal axis since this is inside Row.
                          children: <Widget>[
                            Expanded(
                              child: Image.asset(
                                'assets/video-game-controller.png',
                                height: 70,
                              ),
                              flex: 1,
                            ),
                            const Expanded(
                              child: Text(
                                "Stroke \nRehabilitation",
                                style: TextStyle(
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                  fontFamily: 'Righteous',
                                ),
                              ),
                              flex: 3,
                            ),
                          ],
                        ),
                        //This is the welcome and Sonic picture part.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //This is for the horizontal axis since this is inside Row.
                          children: <Widget>[
                            Text("Welcome",
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Alatsi',
                                letterSpacing: 2.0,
                              ),
                            ),
                            Image.asset(
                              'assets/Sonic_thumbs_up.jpeg',
                              height: 70,
                            ),
                          ],
                        ),
                        //This is the Name and Save Button part.
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            width: 180,
                            child: TextField(
                              controller: txtNameController,
                              onSubmitted: (value){
                                final snackBar = SnackBar(
                                  content: const Text('Name Saved!'),
                                );

                                // Find the ScaffoldMessenger in the widget tree
                                // and use it to show a SnackBar.
                                ScaffoldMessenger.of(context).showSnackBar(
                                    snackBar);
                              },
                              //add this line
                              decoration: const InputDecoration(
                                hintText: "Enter Name",
                                labelText: "Name",
                                hintStyle: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Alatsi',
                                ),
                                //border: OutlineInputBorder(),
                              ),
                              style: TextStyle(
                                fontSize: 22.0,
                                fontFamily: 'Alatsi',
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                              maxLength: 10,
                              //onChanged: (txtNameController) => setState(() => this.preferences?.setString("UserName", userName)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: 200,
                            height: 60,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                print("Start Game!!");
                                //Got help from here: https://stackoverflow.com/questions/52322340/flutter-how-to-remove-bottom-navigation-with-navigation
                                Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => DotGame()));
                                //Navigator.push(context, MaterialPageRoute(builder: (cpntext) => DotGame()));
                              },
                              icon: Icon( // <-- Icon
                                Icons.play_circle_fill,
                                color: Colors.black,
                                size: 25.0,
                              ),
                              label: Text(
                                  'Start Game',
                                 style: TextStyle(
                                  fontSize: 22.0,
                                  fontFamily: 'Alatsi',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: 200,
                            height: 60,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                print("Free to Play!!");
                                Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => FreeToPlay()));
                              },
                              icon: Icon( // <-- Icon
                                Icons.play_circle_fill,
                                color: Colors.black,
                                size: 25.0,
                              ),
                              label: Text(
                                  'Free to Play',
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontFamily: 'Alatsi',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        //Got help from this source: https://www.flutterbeads.com/button-with-icon-and-text-flutter/#:~:text=The%20simplest%20way%20to%20create,the%20release%20of%20Flutter%20v1.
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: 200,
                            height: 60,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                print("Tap Games!!");
                                Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => TapGame()));
                              },
                              icon: Icon( // <-- Icon
                                Icons.play_circle_fill,
                                color: Colors.black,
                                size: 25.0,
                              ),
                              label: Text(
                                  'Tap Games',
                                 style: TextStyle(
                                  fontSize: 22.0,
                                  fontFamily: 'Alatsi',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                )
            );
          } else {
            return Container();
          }
        }
    );
  }

  @override
  void dispose() {
    txtNameController.dispose();
    super.dispose();
  }
}

class GameScreenText extends StatelessWidget {
  final String text;

  const GameScreenText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Something');
  }
}