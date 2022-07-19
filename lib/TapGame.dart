import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stroke_rehab_app/TapGameComplete.dart';


class TapGame extends StatelessWidget {
  static const String _title = 'Tap Game';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //This helps to remove the debug banner
      debugShowCheckedModeBanner: false,
      title: _title,
      home: TapGameDisplay(),
    );
  }
}

class TapGameDisplay extends StatefulWidget {
  TapGameDisplay ({Key? key}) : super(key: key);

  @override
  _TapGameDisplayState createState() => _TapGameDisplayState();
}

class _TapGameDisplayState extends State<TapGameDisplay>  with TickerProviderStateMixin  {

  late AnimationController _animationController;
  var _startBlink = false;

  String _userName = "";  //Username
  Duration myDuration = Duration(minutes: 1); //This variable is for the timer.
  //This is for the game status and to check whether the user complete the game or not.
  //These are variable for tracking the tap.
  var count = 0;
  var totalCount = 10;
  var tapCount = 1; //tapCount was created because count starts from 0 but we want to count from 1. Therefore, tapCount stores the count value with plus (+) 1.
  var startGame = false;

  var feedbackText = 'try harder';
  var feedbackTextVisibility = false;

  //For start Button
  var startClicked = false;
  var blinkRateSlideable = true;

  double _value = 0; //This is for the slider
  var _sizeOutput = 'Fast'; //This is the feedback for the user when they move the slider.
  var _blinkRate = 0; //This changes the fade animation.

  //These are for the time Mode switch
  var isSwitchedTime = false;
  var clockRunning = false;
  var _visibiltyTimer = false;

  //Game Mode of the game. By default the game is set to Goal Mode instead of Time Mode
  var gameMode = "Goal Mode";
  //For game is complete or not
  var gameStatus = "Incomplete";

  //These are for getting the game duration.
  var startTime = "12:00 am"; //This is the start time of the game
  var endTime = "5:00 am"; //This is the end time of the game
  DateTime? diffStart;
  var differ = 0; //This is the difference between the start time and end time to calculate the duration of the game

  var gameNameText = "Tap the Red Dot";
  var guideText = "Tap the red dot 10 times with the same frequency at which Sonic blinks. Press the Start button to start the game.";
  var tapCounterText = 'Number of Taps: 0 out of 10';


  //This is the function that helps to initialise the things the page.
  //Got help from these sources:
  //Play & pause a Flutter animation: https://stackoverflow.com/questions/55554314/play-pause-a-flutter-animation#:~:text=All%20you%20need%20is%20Controller,repeat()%20to%20start%20it.
  @override
  void initState() {
    getUserName(); //This is for the username retrieval.
    //This is for the blinking effect.
    // Seconds = 1 makes it faster. Seconds = 5 makes it normal. Seconds = 9 makes it slow
    //Milliseconds = 250 make it faster. Milliseconds = 1000 makes it normal.  Milliseconds = 1200 makes it slow
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1200));
    // To start from beginning
    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
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

  //Got help from this source: https://www.flutterbeads.com/flutter-countdown-timer/
  // Step 2
  Timer? countdownTimer;
  //Duration myDuration = Duration(minutes: 1);

  /// Timer related methods ///
  // Step 3
  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
        clockRunning = true;
  }
  // Step 4
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  // Step 5
  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(minutes: 1));
  }

  // Step 6
  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();

        gameStatus = "Complete";
        DateTime now = DateTime.now();
        endTime = DateFormat('dd/MM/yyyy hh:mm:ss a').format(now);
        print("End Time: $endTime");
        //This if statement was used because the user might not start a game and quit without pressing the start button.
        //This helps to prevent the diffStart value from being null.
        if(startGame == true){
          //diffStart has the saved value for start time of the game.
          differ = now.difference(diffStart!).inSeconds;
          print('Duration of the game: $differ');
        }
        saveDataForDisplay(); //Save data for Game Complete
        Navigator.push(context, MaterialPageRoute(
            builder:(context) => TapGameComplete()
        ));
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  stopBlink(){
    // To stop animation
    _animationController.stop();
    // To start from beginning
    _animationController.forward();
  }

  feedBackForUser()
  {
      print("feedBackForUser count: $count");
      if(count >= 50 && count < 100){
        feedbackTextVisibility = true;
        feedbackText = "try harder";
      }
      else if(count >= 100 && count < 150){
        feedbackTextVisibility = true;
        feedbackText = "Not bad";
      }
      else if(count >= 150 && count < 200){
        feedbackTextVisibility = true;
        feedbackText = "Good effort";
      }
      else if(count >= 200 && count < 250){
        feedbackTextVisibility = true;
        feedbackText = "Awesome";
      }
      else if(count >= 250 && count < 300){
        feedbackTextVisibility = true;
        feedbackText = "Great";
      }
      else if(count >= 300 && count < 350){
        feedbackTextVisibility = true;
        feedbackText = "Best";
      }
      else if(count >= 350 && count < 400){
        feedbackTextVisibility = true;
        feedbackText = "Excellent";
      }
      else if(count >= 400 && count < 500){
        feedbackTextVisibility = true;
        feedbackText = "OMG!!";
      }
      else if(count >= 500 && count < 600){
        feedbackTextVisibility = true;
        feedbackText = "Superb";
      }
      else if(count >= 600 && count < 999){
        feedbackTextVisibility = true;
        feedbackText = "Super Saiyan";
      }
      else if(count >= 999 && count < 1001){
        feedbackTextVisibility = true;
        feedbackText = "Insane Speed";
      }
      else
      {
        feedbackTextVisibility = false;
      }

    }

    startBlinkAnimation() {
      _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: _blinkRate));
      _animationController.repeat(reverse: true);
      print('Inside the state Blink animation');
    }


  @override
  Widget build(BuildContext context) {
    //These are for the timer
    String strDigits(int n) => n.toString().padLeft(2, '0');
    // Step 7
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    //This for giving feedback to the user.
    //This is for the blink rate
    if(_value == 50.0){
      _sizeOutput = "Normal";
      _blinkRate = 1000;
    }
    //This is for the large button size
    else if(_value == 100.0){
      _sizeOutput = "Fast";
      _blinkRate = 250;
    }
    //This is for the small button size
    else{
      _sizeOutput = "Slow";
      _blinkRate = 1200;
    }

    return Scaffold(
        appBar: AppBar(
            title: const Text('Tap Game'),
            centerTitle: true, //This helped me to set the title in the center position.
            backgroundColor: Colors.teal[300]
        ),
        body: Center(
            child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 50.0, 5.0),
                    //Got help from here: https://www.flutterbeads.com/button-with-icon-and-text-flutter/#:~:text=The%20simplest%20way%20to%20create,label%20parameter%20to%20the%20button.
                    child: TextButton.icon(     // <-- TextButton
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
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 30.0, 0.0),
                    child: ElevatedButton(
                      child:const Text("Quit"),
                      onPressed: () async {
                        print("Quit");

                        if(gameMode == "Time Mode" && clockRunning == true){
                          //Stop the clock
                          stopTimer();
                        }
                        stopBlink();
                        _singleButtonAlterDialog(context);

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
                  ),
                ],
              ),
              //Got help for Italic: https://www.codegrepper.com/code-examples/dart/italic+text+flutter
              Text(
                gameNameText,
                style: TextStyle(
                  fontSize: 22.0,
                  fontFamily: 'Alatsi',
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 10.0, 15.0, 5.0),
                child: Text(
                  guideText,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Alatsi',
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 5.0, 15.0, 5.0),
                      child: Text(
                        'Blink rate:',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'Alatsi',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 5.0, 45.0, 5.0),
                      child: Text(
                        "$_sizeOutput",
                        style: TextStyle(
                          fontFamily: 'Alatsi',
                          fontSize: 22.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
              //Got help from this source: https://blog.logrocket.com/flutter-slider-widgets-deep-dive-with-examples/#:~:text=There%20are%20few%20different%20types,one%20slider%20thumb%20is%20present)
              SizedBox(
                width: 350,
                child: Slider(
                  min: 0.0,
                  max: 100.0,
                  value: _value,
                  divisions: 2,
                  activeColor: Colors.indigoAccent,
                  inactiveColor: Colors.purple.shade100,
                  thumbColor: Colors.pink,
                  label: '${_value.round()}',
                  onChanged: (value) {
                    setState(() {
                      print('gameMode: $gameMode');
                      if(blinkRateSlideable == true){
                        _value = value;
                        print('_blinkRate: $_blinkRate');
                        resetGame();
                      }
                      else{
                        _value = 100;
                        print('_blinkRate: $_blinkRate');
                        //resetGame();
                      }
                      print('blinkRateSlideable: $blinkRateSlideable');

                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.fromLTRB(10.0, 5.0, 80.0, 5.0),
                     child: Text(
                       "Time Mode:",
                       style: TextStyle(
                         fontFamily: 'Alatsi',
                         fontSize: 22.0,
                         //fontWeight: FontWeight.bold,
                         color: Colors.black,
                       ),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.fromLTRB(45.0, 0.0, 25.0, 0.0),
                     child: Switch(
                       value: isSwitchedTime,
                       onChanged: (value) {
                         setState(() {
                             isSwitchedTime = value;
                             print('isSwitchedTime: $isSwitchedTime');

                             if(isSwitchedTime == true){
                                 gameMode = "Time Mode";
                                 _visibiltyTimer = true;
                                 gameNameText = "Tap the Red Dot but Gotta Go Fast!";
                                 guideText = "Within 1 minute, tap the red dot as many times as possible. To initiate time mode, click the Start button. For Time Mode, the blink rate will be set to Fast and slider is disabled.";
                                 tapCounterText = "Number of Taps: $count";
                                 blinkRateSlideable == false;
                             }
                             else{
                                gameMode = "Game Mode";
                                _visibiltyTimer = false;
                                gameNameText = "Tap the Red Dot";
                                guideText = "Tap the red dot 10 times with the same frequency at which Sonic blinks. Press the Start button to start the game.";
                                tapCounterText = "Number of Taps: $count out of $totalCount";
                                blinkRateSlideable == true;

                             }
                             print('gameMode: $gameMode');

                             resetGame();
                         });
                       },
                     ),
                   ),
                 ],
              ),
              Visibility(
                visible: _visibiltyTimer,
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     Icon(
                         Icons.timer,
                         color: Colors.teal,
                         size: 50.0,
                         semanticLabel: 'Timer icon',
                     ),
                     Text(
                       'Time: $minutes:$seconds min',
                       style: TextStyle(
                         fontSize: 22.0,
                         fontFamily: 'Alatsi',

                         color: Colors.black,
                       ),
                     ),
                   ],
                ),
              ),
              Visibility(
                visible: feedbackTextVisibility,
                child: Text(
                  '$feedbackText',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontFamily: 'Alatsi',
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FadeTransition(
                    opacity: _animationController,
                      child: Image.asset(
                        'assets/sonic_head.png',
                        height: 150,
                      ),
                    ),
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                primary:Colors.red,
                             ),
                            child: Text(
                               '',
                            ),
                            onPressed: ()  {
                                switch (gameMode) {
                                  case "Time Mode": {
                                      //This is for the Time Mode
                                      print("Game Mode: $gameMode");

                                      print("Game Start: $startGame");

                                      blinkRateSlideable = false; //Make the slider not clickable for the user.

                                      if (startGame == false)
                                      {
                                        Fluttertoast.showToast(
                                            msg: "Press Start",  // message
                                            toastLength: Toast.LENGTH_SHORT, // length
                                            gravity: ToastGravity.BOTTOM_LEFT,    // location
                                            backgroundColor: Colors.blueGrey,
                                            timeInSecForIosWeb: 1               // duration
                                        );
                                      }
                                      else
                                      {
                                        setState(() {
                                          count += 1;
                                          //tapCounterText.text = "Number of Taps: \(count)
                                          tapCounterText = "Number of Taps: $count";
                                          print("Count: $count");
                                          feedBackForUser(); //Give feedback to the user for doing certain number of taps.
                                        });

                                      }
                                  }
                                  break;

                                  default: {
                                    //This is for the Goal Mode
                                    print("Game Mode: $gameMode");

                                    print("Game Start: $startGame");

                                    blinkRateSlideable = true; //Make the slider not clickable for the user.

                                        if (tapCount == (totalCount + 1) ) {
                                            print("Inside if Count: $count");
                                            gameStatus = "Complete"; //The game is complete since the user finished the 10 taps.
                                            //stopBlink()
                                            //tapCounterText.text = "Number of Taps: 10 out of \(totalCount)"
                                            tapCounterText = "Number of Taps: 10 out of $totalCount";

                                            DateTime now = DateTime.now();
                                            endTime = DateFormat('dd/MM/yyyy hh:mm:ss a').format(now);
                                            print("End Time: $endTime");
                                            //diffStart has the saved value for start time of the game.
                                            differ = now.difference(diffStart!).inSeconds;
                                            print('Duration of the game: $differ');

                                            saveDataForDisplay(); //Save data for Game Complete
                                            Navigator.push(context, MaterialPageRoute(
                                                builder:(context) => TapGameComplete()  //You have to go to MyApp instead of main() because MyApp() is a widget and main() is a void.
                                            ));
                                        }
                                        else if (startGame == false) {
                                          Fluttertoast.showToast(
                                              msg: "Press Start",  // message
                                              toastLength: Toast.LENGTH_SHORT, // length
                                              gravity: ToastGravity.BOTTOM_LEFT,    // location
                                              backgroundColor: Colors.blueGrey,
                                              timeInSecForIosWeb: 1               // duration
                                          );
                                        }
                                        else
                                        {
                                          setState(() {
                                            count += 1;
                                            tapCount += 1;
                                            //tapCounterText.text = "Number of Taps: \(count) out of \(totalCount)";
                                            tapCounterText = "Number of Taps: $count out of $totalCount";
                                            print("Count: $count");
                                            print("Total tap: $totalCount");
                                            print("Tap count: $tapCount");

                                          });

                                        }
                                     }
                                 }
                                 print('Button Pressed');
                            },
                      ),
                   ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  tapCounterText,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontFamily: 'Alatsi',
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child:const Text("Start"),
                  onPressed: ()  {
                      if(startClicked == true)
                      {
                        Fluttertoast.showToast(
                            msg: "Already Started",  // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM_LEFT,    // location
                            backgroundColor: Colors.blueGrey,
                            timeInSecForIosWeb: 1               // duration
                        );
                      }
                      else
                      {
                          setState(() {
                            startGame = true;
                            startClicked = true;

                            //These are for the animation.
                            // _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: _blinkRate));
                            // _animationController.repeat(reverse: true);
                            startBlinkAnimation();

                            tapCount = 2;
                            _startBlink = true;
                            if(gameMode == "Time Mode"){
                              blinkRateSlideable = false;
                              startTimer(); //This starts the timer of the game.
                            }

                            print("Clock started");

                            //Got help from these sources:
                            //DateTime Flutter: https://www.fluttercampus.com/guide/101/how-to-get-current-formatted-date-and-time-on-flutter/
                            //The start time.
                            DateTime now = DateTime.now();
                            startTime = DateFormat('dd/MM/yyyy hh:mm:ss a').format(now);
                            diffStart = now; //This saves the start time of the game.
                            print("Start Time: $startTime");
                          });
                    }

                    print("Start Button");
                    //This is for saving values into the shared preference.
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.greenAccent[700],
                      padding: EdgeInsets.fromLTRB(130.0, 5.0, 130.0, 5.0),
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }



  //Got help from these sources:
  //https://www.javatpoint.com/flutter-alert-dialogs#:~:text=Create%20a%20Flutter%20project%20in,of%20type%20dialog%2C%20the%20AlertDialog.
  //https://docs.flutter.dev/release/breaking-changes/buttons
  //https://medium.com/@iamatul_k/alertdialogs-in-flutter-custom-alertdialog-giffy-dialog-3b16105decef
  //This is for the quit button. It shows an alert with option for "Yes" and "No".
  Future<void> _singleButtonAlterDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: const Text('Are you sure you want to quit this game?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                gameStatus = "Incomplete";
                DateTime now = DateTime.now();
                endTime = DateFormat('dd/MM/yyyy hh:mm:ss a').format(now);
                print("End Time: $endTime");

                //This if statement was used because the user might not start a game and quit without pressing the start button.
                //This helps to prevent the diffStart value from being null.
                if(startGame == true){
                  //diffStart has the saved value for start time of the game.
                    differ = now.difference(diffStart!).inSeconds;
                    print('Duration of the game: $differ');
                }
                saveDataForDisplay(); //Save data for Game Complete
                Navigator.push(context, MaterialPageRoute(
                    builder:(context) => TapGameComplete()  //You have to go to MyApp instead of main() because MyApp() is a widget and main() is a void.
                ));
              },
              style: TextButton.styleFrom(
                  primary: Colors.red[600],
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  textStyle: TextStyle(
                    fontSize: 20,
                    //fontWeight: FontWeight.bold,
                  )
              ),
            ),
            TextButton(
              child: Text('No'),
              onPressed: () async {
                // TODO: Solved using longer duration time for toast.
                Navigator.of(context).pop(
                    Fluttertoast.showToast(
                        msg: "Press Red Dot to resume or press start",  // message
                        toastLength: Toast.LENGTH_SHORT, // length
                        gravity: ToastGravity.BOTTOM_LEFT,    // location
                        backgroundColor: Colors.blueGrey,
                        timeInSecForIosWeb: 20               // duration
                    )
                );

                if (startGame == true){
                  startBlinkAnimation();
                  print('Inisde Quit for animation');
                }

                if(gameMode == "Time Mode" && clockRunning == true){
                  //Stop the clock
                  stopTimer();
                  //Start the timer when the user press "No".
                  startTimer();
                }
              },
              style: TextButton.styleFrom(
                //primary: Colors.red[600],
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  textStyle: TextStyle(
                    fontSize: 20,
                    //fontWeight: FontWeight.bold,
                  )
              ),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
      //The game is not started
      startGame = false;
      //Start is not clicked so it startClicked becomes false
      startClicked = false;
      //Stop the animation
      stopBlink();

      if(gameMode == "Time Mode" && clockRunning == true){
        //Stop the clock
        stopTimer();
        //Reset the clock to 60 seconds
        resetTimer();
      }

      //Make the button count back to 0
      count = 0;
      //Make the tapCount back to 0
      tapCount = 0;
      switch(gameMode){
        case "Time Mode":{
          //Update the text for the tap feedback
          tapCounterText = "Number of Taps: $count";
          _value = 100;
        }
        break;
        default:{
          //Update the text for the tap feedback
          tapCounterText = "Number of Taps: $count out of $totalCount";
        }
      }

      //Hide the feedback text which only for display when it is Time Mode
      feedbackTextVisibility = false;

      final snackBar = SnackBar(
        content: const Text('Press Start'),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(
          snackBar);
      print("Game Start: $startGame");
  }

  saveDataForDisplay()async {
    final prefer = await SharedPreferences.getInstance();

    prefer.setString("TapGameMode", gameMode);
    print('Tap Game Mode: $gameMode');

    prefer.setString("TapGameStatus", gameStatus);
    print('Tap Game Status: $gameStatus');

    prefer.setInt("DurationTap", differ);
    print('Duration of the Tap game: $differ');

    if (startGame == true && gameMode == "Goal Mode" && gameStatus == "Complete")
    {
      count += 1;
      prefer.setInt("TapTotalButtonCount", count);
      print('Tap Final Button count saved: $count');
    }
    else
    {
      prefer.setInt("TapTotalButtonCount", count);
      print('Tap Final Button count saved: $count');
    }
  }

}
