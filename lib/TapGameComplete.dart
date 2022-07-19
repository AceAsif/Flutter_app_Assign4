import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stroke_rehab_app/TapGame.dart';
import 'main.dart';

class TapGameComplete extends StatelessWidget {
  static const String _title = 'Tap Game Complete';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //This helps to remove the debug banner
      debugShowCheckedModeBanner: false,
      title: _title,
      home: TapGameCompleteDisplay(),
    );
  }
}

class TapGameCompleteDisplay extends StatefulWidget {
  TapGameCompleteDisplay ({Key? key}) : super(key: key);

  @override
  _TapGameCompleteDisplayState createState() => _TapGameCompleteDisplayState();
}

class _TapGameCompleteDisplayState extends State<TapGameCompleteDisplay> {

  String _userName = "";

  String _gameModeTap = "Goal Mode";

  String _gameStatusTap = "";

  int _totButPressTap = 0; //total button press

  int _DurationDotTap = 0; //duration of the game.

  String _feedbackImage = 'assets/sonic_try_again.jpg'; //This is for setting the Sonic image.

  @override
  void initState() {
    getUserName(); //This is for the username retrieval.
    getDisplayData(); //This retrieves all the necessary data from Tap Game
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Got help from: https://stackoverflow.com/questions/51215064/flutter-access-stored-sharedpreference-value-from-other-pages
  //This is for the username from the main page.
  getUserName() async {
    final prefer = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefer.getString("UserName") ?? "Sonic";
    });
  }

  getDisplayData() async {
      final prefer = await SharedPreferences.getInstance();
      _gameModeTap = prefer.getString("TapGameMode") ?? "Goal Mode"; //This is for the Game Mode of Tap Game. Is it Goal or Time Mode?
      _gameStatusTap = prefer.getString("TapGameStatus") ?? "Incomplete";  //This is for the setting the feedback image according to the game status: Complete or Incomplete.
      _DurationDotTap = prefer.getInt("DurationTap") ?? 0; //This is the duration of the game. How many seconds did the user take?
      _totButPressTap = prefer.getInt("TapTotalButtonCount") ?? 0; //This is for the button presses from the game page.

      print('_gameStatusTap: $_gameStatusTap');

      if(_gameModeTap == "Time Mode"){
        print("Time Mode");
        if (_gameStatusTap == "Complete" || _totButPressTap > 100)
        {
          print('if Time _gameStatusTap: $_gameStatusTap');
          _feedbackImage = 'assets/Sonic_great_job.jpg';
        }
        else
        {
          print('else Time _gameStatusTap: $_gameStatusTap');
          _feedbackImage = 'assets/sonic_try_again.jpg';
        }
      }
      else if(_gameModeTap == "Goal Mode"){
        print("Goal Mode");
        if (_gameStatusTap == "Complete")
        {
          print('if Goal _gameStatusTap: $_gameStatusTap');
          _feedbackImage = 'assets/Sonic_great_job.jpg';
        }
        else
        {
          print('else goal _gameStatusTap: $_gameStatusTap');
          _feedbackImage = 'assets/sonic_try_again.jpg';
        }
      }
      print('_feedbackImage: $_feedbackImage');

      if(_DurationDotTap >= 60 && _gameModeTap == "Time Mode"){
        _DurationDotTap = 60;
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Tap Game Complete'),
        centerTitle: true, //This helped me to set the title in the center position.
        backgroundColor: Colors.teal[300]
      ),
      body: Center(
        child: Column(
          children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton.icon(     // <-- TextButton
                      onPressed: () {},
                      icon: Icon(
                        Icons.account_circle,
                        size: 50,
                        color: Colors.teal,
                      ),
                      label: Text(
                        //'Sonic',
                        "$_userName",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Finished!!",
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontFamily: 'Righteous',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    child: Text(
                      'Game Mode: ',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'Alatsi',
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                    child: Text(
                      _gameModeTap,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'Alatsi',
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  child: Text(
                    'Duration: ',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'Alatsi',
                      color: Colors.black,
                    ),
                  ),
                ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                    child: Text(
                      '${_DurationDotTap}s',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'Alatsi',
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                  child: Text(
                    'Total no. of taps: ',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'Alatsi',
                      color: Colors.black,
                    ),
                  ),
                ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                    child: Text(
                      '$_totButPressTap',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'Alatsi',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  _feedbackImage,
                  height: 250,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      child:const Text("Retry"),
                      onPressed: () => {
                        Navigator.push(context, MaterialPageRoute(
                            builder:(context) => TapGame()
                        )),
                        print("Retry")
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.greenAccent[700],
                          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),
                    ElevatedButton(
                      child:const Text("Quit"),
                      onPressed: () async {
                        Navigator.push(context, MaterialPageRoute(
                              builder:(context) => MyNavigationBar()  //You have to go to MyApp instead of main() because MyApp() is a widget and main() is a void.
                          ));
                        print("Quit");
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red[600],
                          padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}