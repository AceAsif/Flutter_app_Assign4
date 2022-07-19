import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DotGameComplete.dart';
import 'package:fluttertoast/fluttertoast.dart';
import  'package:intl/intl.dart';

class DotGame extends StatelessWidget {
  static const String _title = 'Dot Game (Goal Mode)';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //This helps to remove the debug banner
      debugShowCheckedModeBanner: false,
      title: _title,
      home: DotGameDisplay(),
    );
  }
}

class DotGameDisplay extends StatefulWidget {
  DotGameDisplay ({Key? key}) : super(key: key);

  @override
  _DotGameDisplayState createState() => _DotGameDisplayState();
}

//Got help from these sources:
// showToast: https://pub.dev/packages/fluttertoast
// how to show toast: https://stackoverflow.com/questions/45948168/how-to-create-toast-in-flutter
// fix the showToast issue: https://stackoverflow.com/questions/62286575/how-to-solve-no-implementation-found-for-method-showtoast-in-flutter
class _DotGameDisplayState extends State<DotGameDisplay> with TickerProviderStateMixin {

  String gameType = "Goal Mode";
  String _userName = "";  //Username
  var _repNum = 0; //Repetition number
  var _repNumCounter = 1; //This is for showing the current repetition number.
  var _repCounter = 0; //This is for keeping track of the repetition.
  var _dotNum = 0; //dot number

  //These are for getting the game duration.
  var startTime = "12:00 am"; //This is the start time of the game
  var endTime = "5:00 am"; //This is the end time of the game
  DateTime? diffStart;
  var differ = 0; //This is the difference between the start time and end time to calculate the duration of the game


  //These for tracking the buttons
  var buttonCount = 0;  //This count is for both the correct and incorrect button presses.
  var correctBut  = 0;
  var wrongBut = 0;
  List  buttonList = [];
  //var listButtons = mutableListOf<String>();
  var button1Clicked = false;
  var button2Clicked = false;
  var button3Clicked = false;
  var button4Clicked = false;
  var button5Clicked = false;


  //These are for saying that the button presses were done.
  var button1Done = false;
  var button2Done = false;
  var button3Done = false;
  var button4Done = false;
  var button5Done = false;

  //These are for button visibility
  bool _isVisibleBut3 = false;
  bool _isVisibleBut4 = false;
  bool _isVisibleBut5 = false;

 //This is for the game status and to check whether the user complete the game or not.
  var gameOver = "Incomplete";

  var _timeLimit = ""; //time limit in string
  Duration myDuration = Duration(minutes: 0); //This variable is for the timer

  //These are for randomisation
  var _isSwitchedRan = false; //randomisation

  List<double> xPosList = [250,10,10,130,250];  //For storing the x position values.
  List<double> yPosList = [10,10,350,175,350];  //For storing the y position values.

  var _isSwitchedInd = false; //Button indication

  //These are for saying that the button presses were done.
  var indBut1 = false;
  var indBut2 = false;
  var indBut3 = false;
  var indBut4 = false;
  var indBut5 = false;

  double _buttonSize = 0.0; //Button size
  double buttonWidth = 0.0;
  double buttonHeight = 0.0;

  //This is for the progress bar
  double progressCount = 0.0;


  //This is the function that helps to initialise the things the page.
  @override
  void initState() {
    getUserName(); //This is for the username retrieval.
    getButtonSize(); //This is for button size retrieval.
    getRepNum(); //This is for the repetition number retrieval.
    getDotNum(); //This is for the dot number retrieval.
    getTimeLimit(); //This is for the time limit retrieval.

    getRandom(); //This is for the randomisation of the buttons retrieval.
    getIndicate(); //This is for the button indication retrieval.

    startTimer(); //This starts the timer of the game.

    //Got help from these sources:
    //DateTime Flutter: https://www.fluttercampus.com/guide/101/how-to-get-current-formatted-date-and-time-on-flutter/
    //The start time.
    DateTime now = DateTime.now();
    startTime = DateFormat('dd/MM/yyyy hh:mm:ss a').format(now);
    diffStart = now; //This saves the start time of the game.
    print("Start Time: $startTime");

    super.initState();
  }

  //Got help from: https://stackoverflow.com/questions/51215064/flutter-access-stored-sharedpreference-value-from-other-pages
  //This is for the username from the main page.
  getUserName() async {
    final prefer = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefer.getString("UserName") ?? "Sonic";
    });
  }

  //This is for the repetition number from the setting page.
  getRepNum() async {
    final prefer = await SharedPreferences.getInstance();
    setState(() {
      _repNum = prefer.getInt("RepNum") ?? 2;
    });
  }

  //This is for the dot number from the setting page.
  getDotNum() async {
    final prefer = await SharedPreferences.getInstance();
    setState(() {
      _dotNum = prefer.getInt("DotNum") ?? 2;
      buttonVisibility(_dotNum);
    });
  }

  //This is for getting the time limit.
  getTimeLimit() async {
    final prefer = await SharedPreferences.getInstance();
    _timeLimit = prefer.getString("TimeLimit") ?? '1 min';
    convertTimefromStringToInt(_timeLimit);
    print('Inside getTimeLimit, _timeLimitNum: $myDuration');
  }

  //This for getting the randomisation for the buttons.
  getRandom() async {
    final prefer = await SharedPreferences.getInstance();
    _isSwitchedRan = prefer.getBool("Randomisation") ?? false;

    randomPostion();
  }

  //This for getting the randomisation for the buttons.
  getIndicate() async {
    final prefer = await SharedPreferences.getInstance();
    _isSwitchedInd = prefer.getBool("Indication") ?? false;
    if (_isSwitchedInd == true){
       indBut1 = true;
    }
    else{
      indBut1 = false;
    }
  }

  //This for getting the randomisation for the buttons.
  getButtonSize() async {
    final prefer = await SharedPreferences.getInstance();
    _buttonSize = prefer.getDouble("Button Size") ?? 0.0;

    //This is for the medium button size
    if(_buttonSize == 50.0){
      buttonWidth = 60;
      buttonHeight = 60;
    }
    //This is for the large button size
    else if(_buttonSize == 100.0){
      buttonWidth = 80;
      buttonHeight = 80;
    }
    //This is for the small button size
    else{
      buttonWidth = 40;
      buttonHeight = 40;
    }
  }

  void buttonVisibility(int dotNumVis) {
      switch(dotNumVis){
        case 3: {
          _isVisibleBut3 = true;
        }
        break;

        case 4: {
          _isVisibleBut3 = true;
          _isVisibleBut4 = true;
        }
        break;

        case 5: {
          _isVisibleBut3 = true;
          _isVisibleBut4 = true;
          _isVisibleBut5 = true;
        }
        break;

        default: {
           print('It is 2. So it is default and no need to show button 3,4,5.');
           _isVisibleBut3 = false;
           _isVisibleBut4 = false;
           _isVisibleBut5 = false;
        }
        break;
      }
  }

  //Got help from this source: https://www.tutorialspoint.com/dart_programming/dart_programming_switch_case_statement.htm
 // convert time string to numbers for the timer
  void convertTimefromStringToInt (String time){
      print('Time limit string: $time');
      switch(time){
         //'1 min', '2 mins', '5 mins', '10 mins', '15 mins'
        case '1 min': {
          myDuration = Duration(minutes: 1);
        }
        break;

        case '2 mins': {
          myDuration = Duration(minutes: 2);
        }
        break;

        case '5 mins': {
          myDuration = Duration(minutes: 5);
        }
        break;

        case '10 mins': {
          myDuration = Duration(minutes: 10);
        }
        break;

        case '15 mins': {
          myDuration = Duration(minutes: 15);
        }
        break;

        default: {
          print('Inside default, so no value provided for time. So the time is 1 min ');
          myDuration = Duration(minutes: 1);
        }
        break;
      }
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
        //Timer.periodic(Duration(seconds: timeNum), (_) => setCountDown());
  }
  // Step 4
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  // Step 6
  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
        gameOver = "Incomplete";
        DateTime now = DateTime.now();
        endTime = DateFormat('dd/MM/yyyy hh:mm:ss a').format(now);
        print("End Time: $endTime");
        //diffStart has the saved value for start time of the game.
        differ = now.difference(diffStart!).inSeconds;
        print('Time over Duration of the game: $differ');
        saveTimeButton(); //Save the button presses done by the user even if the game is not complete.
        //storeToDatabase(); //Save to the database.

        Navigator.push(context, MaterialPageRoute(
            builder:(context) => DotGameComplete(
              gameStatus: gameOver,
              gameType: gameType,
              repetitionNum: '${_repNumCounter-1} / $_repNum',
              startTime: startTime,
              endTime: endTime,
              durationOfGame: differ,
              totalButtonClick: buttonCount,
              correctButtonClick: correctBut,
              wrongButtonClick: wrongBut,
              buttonList: buttonList,
            )
        ));
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  //This function is for the progress bar to increase every time the user presses the buttons.
  void progressBarValue()
  {
      if(progressCount >= 1){
        progressCount = 0;
      }
      switch (_dotNum) {
        case 3: {
          print("Inside the special case of 0.3");
          double one = 1;
          double three = 3;
          progressCount += one/three;
          print("Progress Value: $progressCount");
          print("Dot Num for progress: $_dotNum");
        }
        break;

        case 4: {
            progressCount += 0.25;
            print("Progress Value: $progressCount)");
            print("Dot Num for progress: $_dotNum)");
        }
        break;

        case 5: {
          progressCount += 0.2;
          print("Progress Value: $progressCount");
          print("Dot Num for progress: $_dotNum");
        }
        break;

        default: {
          progressCount += 0.5;
          print("Progress Value: $progressCount");
          print("Dot Num for progress: $_dotNum");
        }
        break;

      }
  }

  // TODO: Fix the randomisation for overlapping
  //Got help from these sources:
  //How do I generate random numbers in Dart?:  https://stackoverflow.com/questions/11674820/how-do-i-generate-random-numbers-in-dart
  //Random: https://api.flutter.dev/flutter/dart-math/Random-class.html
  void randomPostion(){
    if(_isSwitchedRan == true){

        print('Randomisation is on!!');
        xPosList = [];
        yPosList = [];

        //These are for setting the x and y coordinate of the buttons
        if(_buttonSize == 50.0){

          xPosList = [10, 55, 100, 150, 200, 270];
          xPosList.shuffle();
          print('xPosList: $xPosList');

          yPosList = [5, 50, 100, 150, 200, 350];
          yPosList.shuffle();
          print('yPosList: $yPosList');

        }
        else if(_buttonSize == 100.0){
          print('_buttonSize: $_buttonSize');
          //Rect buttonRect = Rect.fromCircle(center: Offset(xPosList[0], yPosList[0]), radius: 80);

          //xPosList = [5, 60, 115, 185, 215, 240];
          xPosList = [0, 70, 140, 200, 240, 270];
          xPosList.shuffle();
          print('xPosList: $xPosList');

          yPosList = [0, 70, 140, 210, 280, 350];
          yPosList.shuffle();
          print('yPosList: $yPosList');

        }
        else{
          //Rect buttonRect = Rect.fromCircle(center: Offset(xPosList[0], yPosList[0]), radius: 40);

          xPosList = [10, 55, 120, 180, 240, 270];
          xPosList.shuffle();
          print('xPosList: $xPosList');

          //yPosList = [5, 50, 100, 150, 200, 350];
          yPosList = [5, 40, 120, 160, 250, 350];
          yPosList.shuffle();
          print('yPosList: $yPosList');


        }

        print('checking for xList: $xPosList');
        print('checking for yList: $yPosList');

    }

  }


  @override
  Widget build(BuildContext context) {
    //These are for the timer
    String strDigits(int n) => n.toString().padLeft(2, '0');
    // Step 7
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    return Scaffold(
      appBar: AppBar(
          title: const Text('Dot Game (Goal Mode)'),
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
                        stopTimer(); //This stops the timer when the user presses the "Quit" button
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: Text(
                        'Repetition: $_repNumCounter / $_repNum',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'Alatsi',
                          //fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: Text(
                        //'Time: 15:00 min(s)',
                       'Time: $minutes:$seconds min(s)',
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
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 10.0, 15.0, 10.0),
                child: Text(
                    'Press the highlighted button if the indication option is enabled. Please press the buttons in order of the numbers.',
                    style: TextStyle(
                      fontSize: 19.0,
                      fontFamily: 'Alatsi',
                      color: Colors.black,
                    )
                ),
              ),
              //Got help from this source:
              // Make circle button: https://www.kindacode.com/article/how-to-make-circular-buttons-in-flutter/
              // Make border for buttons: https://stackoverflow.com/questions/58350235/add-border-to-a-container-with-borderradius-in-flutter
              // Idea for indication: https://www.codegrepper.com/code-examples/dart/flutter+if+statement+in+color+property
              // Guide for stack: https://www.javatpoint.com/flutter-stack#:~:text=The%20stack%20is%20a%20widget,them%20from%20bottom%20to%20top.
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Stack(
                      children: <Widget>[
                        Container(
                          width: 370,
                          height: 440,
                          //color: Colors.orange,
                          //color: Colors.transparent,
                        ),
                        Positioned(
                          top: yPosList[0],
                          right: xPosList[0],
                          child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: indBut1 ? Colors.red : Colors.transparent,
                              style: BorderStyle.solid,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            //borderRadius: BorderRadius.circular(100.0),
                          ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                //primary: Colors.blue,
                                //If the buttonclick is true then the color is green else the button color is blue.
                                 primary: button1Clicked ? Colors.green : Colors.blue,

                              ),
                              child: Container(
                                  //width: 40,
                                  //height: 40,
                                  width: buttonWidth,
                                  height: buttonHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: const Text(
                                    '1',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              //color: button1Clicked ? Colors.blue : Colors.black,
                              onPressed: () {

                                //These are for debugging purposes
                                print('Rep Num: $_repNum');
                                print('Dot number: $_dotNum');
                                print('Time Limit: $_timeLimit');
                                print('Randomisation: $_isSwitchedRan');
                                print('Button Indication: $_isSwitchedInd');
                                print('Button Size: $_buttonSize');

                                if (button1Done == true)
                                {
                                    //SimpleDateFormat("ss.SSS") shows the milliseconds with seconds. This allows the user to see how many milliseconds it took him to press each button. I didn't include hour and minute because the user can see from the start and end time.
                                    //Got help from here for milliseconds: https://stackoverflow.com/questions/13110542/how-to-get-a-timestamp-in-dart
                                    DateTime clickTime1 = DateTime.now();
                                    buttonList.add('[Incorrect] Button1 -> ${clickTime1.second}.${clickTime1.millisecond} s');
                                    print("Button 1 pressed done and can't be pressed");

                                    buttonCount += 1; //Both Correct and incorrect buttons press
                                    wrongBut += 1; //Only wrong button presses

                                    print("Wrong button is pressed");
                                    //showToast(message: "Wrong Button", font: UIFont(name:"Futura",size:23)!)
                                    Fluttertoast.showToast(
                                        msg: "Wrong button",  // message
                                        toastLength: Toast.LENGTH_SHORT, // length
                                        gravity: ToastGravity.BOTTOM_LEFT,    // location
                                        backgroundColor: Colors.blueGrey,
                                        timeInSecForIosWeb: 1               // duration
                                    );
                                }
                                else
                                {
                                    if(_isSwitchedInd == true){
                                      indBut1 = false;
                                      indBut2 = true;
                                    }

                                    //Got help from here for milliseconds: https://stackoverflow.com/questions/13110542/how-to-get-a-timestamp-in-dart
                                    DateTime clickTime1 = DateTime.now();
                                    buttonList.add('Button1 -> ${clickTime1.second}.${clickTime1.millisecond} s');
                                    print('buttonList: $buttonList');
                                    //button1Clicked = true;
                                    button1Done = true; //This tells the program that the user has clicked the button already.

                                    buttonCount += 1; //Both Correct and incorrect buttons press
                                    print('buttonCount: $buttonCount');

                                    correctBut += 1; //Only for the correct button press
                                    print('correctBut: $correctBut');

                                    _repCounter += 1; //This increases the counter for repetition.
                                    print('_repCounter: $_repCounter');

                                    progressBarValue();

                                    print("Button 1 was clicked");

                                    //This is for changing the color to show that the button is pressed.
                                    setState(() {
                                      button1Clicked = true; //This means button1Clicked is true
                                    });
                                }

                              },
                                ),
                            ),
                        ),
                        Positioned(
                          top: yPosList[1],
                          right: xPosList[1],
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: indBut2 ? Colors.red : Colors.transparent,
                                style: BorderStyle.solid,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              //borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                //primary: Colors.blue
                                //If the buttonclick is true then the color is green else the button color is blue.
                                primary: button2Clicked ? Colors.green : Colors.blue,
                                //primary: button2Clicked ? Colors.green : getColorIndicate(indicateCount),
                              ),
                              child: Container(
                                width: buttonWidth,
                                height: buttonHeight,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: const Text(
                                  '2',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              onPressed: () async {

                                if(button1Clicked == false || button2Done == true)
                                {
                                  print("Button 2 pressed done and can't be pressed");

                                  //Got help from here for milliseconds: https://stackoverflow.com/questions/13110542/how-to-get-a-timestamp-in-dart
                                  DateTime clickTime2 = DateTime.now();
                                  buttonList.add('[Incorrect] Button2 -> ${clickTime2.second}.${clickTime2.millisecond} s');
                                  print('buttonList: $buttonList');

                                  buttonCount += 1 ;//Both Correct and incorrect buttons press
                                  wrongBut += 1; //Only wrong button presses
                                  print("Wrong button is pressed");
                                  //showToast(message: "Wrong Button", font: UIFont(name:"Futura",size:23)!)
                                  Fluttertoast.showToast(
                                      msg: "Wrong button",  // message
                                      toastLength: Toast.LENGTH_SHORT, // length
                                      gravity: ToastGravity.BOTTOM_LEFT,    // location
                                      backgroundColor: Colors.blueGrey,
                                      timeInSecForIosWeb: 1               // duration
                                  );
                                }
                                else
                                {
                                  //Got help from here for milliseconds: https://stackoverflow.com/questions/13110542/how-to-get-a-timestamp-in-dart
                                  DateTime clickTime2 = DateTime.now();
                                  buttonList.add('Button2 -> ${clickTime2.second}.${clickTime2.millisecond} s');
                                  print('buttonList: $buttonList');

                                  if(_isSwitchedInd == true){
                                    indBut2 = false;
                                    indBut3 = true;
                                  }

                                  button2Done = true; //This tells the program that the user has clicked the button already.

                                  buttonCount += 1; //Both Correct and incorrect buttons press
                                  correctBut += 1; //Only for the correct button press

                                  _repCounter += 1; //This increases the counter for repetition.

                                  progressBarValue();
                                  print("Button 2 was clicked");

                                  //This is for changing the color to show that the button is pressed.
                                  setState(() {
                                    button2Clicked = true; //This means button1Clicked is true
                                  });

                                  updateRepNum(); //Check if it is time to move to the new repetition.

                                }
                              },
                            ),
                          ),
                        ),
                        //Got help from these sources:
                        // visibility for buttons: https://medium.flutterdevs.com/show-hide-widget-in-flutter-227d69d29266
                        // visibility help: https://stackoverflow.com/questions/44489804/how-to-show-hide-widgets-programmatically-in-flutter
                        Positioned(
                          top: yPosList[2],
                          right: xPosList[2],
                          child: Visibility(
                            visible: _isVisibleBut3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: indBut3 ? Colors.red : Colors.transparent,
                                  style: BorderStyle.solid,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                //borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  //If the buttonclick is true then the color is green else the button color is blue.
                                  primary: button3Clicked ? Colors.green : Colors.blue,
                                  //primary: button3Clicked ? Colors.green : getColorIndicate(indicateCount),
                                ),
                                child: Container(
                                  width: buttonWidth,
                                  height: buttonHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: const Text(
                                    '3',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                onPressed: () {
                                  if(button2Clicked == false || button3Done == true)
                                  {
                                    print("Button 3 pressed done and can't be pressed");

                                    //Got help from here for milliseconds: https://stackoverflow.com/questions/13110542/how-to-get-a-timestamp-in-dart
                                    DateTime clickTime3 = DateTime.now();
                                    buttonList.add('[Incorrect] Button3 -> ${clickTime3.second}.${clickTime3.millisecond} s');
                                    print('buttonList: $buttonList');

                                    buttonCount += 1; //Both Correct and incorrect buttons press
                                    wrongBut += 1; //Only wrong button presses

                                    print("Wrong button is pressed");
                                    Fluttertoast.showToast(
                                        msg: "Wrong button",  // message
                                        toastLength: Toast.LENGTH_SHORT, // length
                                        gravity: ToastGravity.BOTTOM_LEFT,    // location
                                        backgroundColor: Colors.blueGrey,
                                        timeInSecForIosWeb: 1               // duration
                                    );
                                  }
                                  else
                                  {
                                    //Got help from here for milliseconds: https://stackoverflow.com/questions/13110542/how-to-get-a-timestamp-in-dart
                                    DateTime clickTime3 = DateTime.now();
                                    buttonList.add('Button3 -> ${clickTime3.second}.${clickTime3.millisecond} s');
                                    print('buttonList: $buttonList');

                                    if(_isSwitchedInd == true){
                                      indBut3 = false;
                                      indBut4 = true;
                                    }

                                    button3Done = true; //This tells the program that the user has clicked the button already.

                                    buttonCount += 1; //Both Correct and incorrect buttons press
                                    correctBut += 1; //Only for the correct button presses.

                                    _repCounter += 1; //This increases the counter for repetition.

                                    progressBarValue();
                                    print("Button 3 was clicked");

                                    //This is for changing the color to show that the button is pressed.
                                    setState(() {
                                      button3Clicked = true; //This means button3Clicked is true
                                    });

                                    updateRepNum();
                                  }

                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: yPosList[3],
                          right: xPosList[3],
                          child: Visibility(
                            visible: _isVisibleBut4,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: indBut4 ? Colors.red : Colors.transparent,
                                  style: BorderStyle.solid,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  //If the buttonclick is true then the color is green else the button color is blue.
                                  primary: button4Clicked ? Colors.green : Colors.blue,
                                ),
                                child: Container(
                                  width: buttonWidth,
                                  height: buttonHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: const Text(
                                    '4',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                onPressed: () {
                                  if(button3Clicked == false || button4Done == true)
                                  {
                                    print("Button 4 pressed done and can't be pressed");

                                    //Got help from here for milliseconds: https://stackoverflow.com/questions/13110542/how-to-get-a-timestamp-in-dart
                                    DateTime clickTime4 = DateTime.now();
                                    buttonList.add('[Incorrect] Button4 -> ${clickTime4.second}.${clickTime4.millisecond} s');
                                    print('buttonList: $buttonList');

                                    buttonCount += 1; //Both Correct and incorrect buttons press
                                    wrongBut += 1; //Only wrong button presses

                                    print("Wrong button is pressed");
                                    Fluttertoast.showToast(
                                        msg: "Wrong button",  // message
                                        toastLength: Toast.LENGTH_SHORT, // length
                                        gravity: ToastGravity.BOTTOM_LEFT,    // location
                                        backgroundColor: Colors.blueGrey,
                                        timeInSecForIosWeb: 1               // duration
                                    );
                                  }
                                  else
                                  {
                                    //Got help from here for milliseconds: https://stackoverflow.com/questions/13110542/how-to-get-a-timestamp-in-dart
                                    DateTime clickTime4 = DateTime.now();
                                    buttonList.add('Button4 -> ${clickTime4.second}.${clickTime4.millisecond} s');
                                    print('buttonList: $buttonList');

                                    if(_isSwitchedInd == true){
                                      indBut4 = false;
                                      indBut5 = true;
                                    }
                                    //button4Clicked = true;
                                    button4Done = true; //This tells the program that the user has clicked the button already.

                                    buttonCount += 1; //Both Correct and incorrect buttons press
                                    correctBut += 1; //Only for the correct button press

                                    _repCounter += 1; //This increases the counter for repetition.

                                    progressBarValue();
                                    print("Button 4 was clicked");
                                    //This is for changing the color to show that the button is pressed.
                                    setState(() {
                                      button4Clicked = true; //This means button3Clicked is true
                                    });

                                    updateRepNum();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: yPosList[4],
                          right: xPosList[4],
                          child: Visibility(
                            visible: _isVisibleBut5,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: indBut5 ? Colors.red : Colors.transparent,
                                  style: BorderStyle.solid,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                //borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  //If the buttonclick is true then the color is green else the button color is blue.
                                  primary: button5Clicked ? Colors.green : Colors.blue,
                                ),
                                child: Container(
                                  width: buttonWidth,
                                  height: buttonHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: const Text(
                                    '5',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                onPressed: ()  {
                                  print('Before press button5Clicked: $button5Clicked');
                                  if(button4Clicked == false || button5Done == true)
                                  {
                                    print("Button 5 pressed done and can't be pressed");

                                    //Got help from here for milliseconds: https://stackoverflow.com/questions/13110542/how-to-get-a-timestamp-in-dart
                                    DateTime clickTime5 = DateTime.now();
                                    buttonList.add('[Incorrect] Button5 -> ${clickTime5.second}.${clickTime5.millisecond} s');
                                    print('buttonList: $buttonList');

                                    buttonCount += 1; //Both Correct and incorrect buttons press
                                    wrongBut += 1; //Only wrong button presses

                                    print("Wrong button is pressed");
                                    Fluttertoast.showToast(
                                        msg: "Wrong button",  // message
                                        toastLength: Toast.LENGTH_SHORT, // length
                                        gravity: ToastGravity.BOTTOM_LEFT,    // location
                                        backgroundColor: Colors.blueGrey,
                                        timeInSecForIosWeb: 1               // duration
                                    );
                                  }
                                  else
                                  {
                                    //Got help from here for milliseconds: https://stackoverflow.com/questions/13110542/how-to-get-a-timestamp-in-dart
                                    DateTime clickTime5 = DateTime.now();
                                    buttonList.add('Button5 -> ${clickTime5.second}.${clickTime5.millisecond} s');
                                    print('buttonList: $buttonList');

                                    if(_isSwitchedInd == true){
                                      indBut5 = false;
                                    }

                                    button5Done = true; //This tells the program that the user has clicked the button already.

                                    buttonCount += 1; //Both Correct and incorrect buttons press
                                    correctBut += 1; //Only for the correct button press

                                    _repCounter++; //This increases the counter for repetition.

                                    progressBarValue();
                                    print("Button 5 was clicked");
                                    //This is for changing the color to show that the button is pressed.
                                    setState(() {
                                      print('After press button5Clicked: $button5Clicked');
                                      button5Clicked = true; //This means button3Clicked is true
                                    });

                                    updateRepNum();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Got help from this source: https://www.javatpoint.com/flutter-progress-bar#:~:text=The%20linear%20progress%20bar%20is,point%20in%20making%20the%20task.
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  width: 250,
                  child: LinearProgressIndicator(
                    //value: controller.value,
                    backgroundColor: Colors.orange[200],
                    value: progressCount,
                    semanticsLabel: 'Linear progress indicator',
                  ),
                ),
              ),
            ],
          )
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
                gameOver = "Incomplete";
                DateTime now = DateTime.now();
                endTime = DateFormat('dd/MM/yyyy hh:mm:ss a').format(now);
                print("End Time: $endTime");
                //diffStart has the saved value for start time of the game.
                differ = now.difference(diffStart!).inSeconds;
                print('Quit Duration of the game: $differ');
                saveTimeButton(); //Save the button presses done by the user even if the game is not complete.

                Navigator.push(context, MaterialPageRoute(
                    builder:(context) => DotGameComplete(
                      gameStatus: gameOver,
                      gameType: gameType,
                      repetitionNum: '${_repNumCounter-1} / $_repNum',
                      startTime: startTime,
                      endTime: endTime,
                      durationOfGame: differ,
                      totalButtonClick: buttonCount,
                      correctButtonClick: correctBut,
                      wrongButtonClick: wrongBut,
                      buttonList: buttonList,
                    )
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
              onPressed: () {
                Navigator.of(context).pop();
                startTimer(); //Start the timer when the user press "No".
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

  //This is for updating the repetition  of the game
  void updateRepNum(){
    print('Total count: $_repCounter');
    print('Button count: $buttonCount');
    if (_dotNum == _repCounter){
      _repNumCounter += 1;
      print('The repetition number in updateRpeNum: $_repNumCounter');
      gameComplete();
    }
  }

  void gameComplete(){
    print("_repNumCounter = ${_repNumCounter} and _repNum = ${_repNum + 1}");
    if (_repNumCounter == (_repNum + 1))
    {
        //Got help from these sources:
      //Difference in time: https://api.flutter.dev/flutter/dart-core/DateTime/difference.html
      //DateTime class: https://api.flutter.dev/flutter/dart-core/DateTime-class.html
          DateTime now = DateTime.now();
          endTime = DateFormat('dd/MM/yyyy hh:mm:ss a').format(now);
          print("End Time: $endTime");
          //diffStart has the saved value for start time of the game.
          differ = now.difference(diffStart!).inSeconds;
          print('Duration of the game: $differ');


          gameOver = "Complete";
          print("gameOver: $gameOver");
          print("complete Total Buttons clicked: $buttonCount");

          saveTimeButton(); //Saves the duration and button press of the game

          stopTimer(); //This stops the timer

          //Got help from this source: https://docs.flutter.dev/cookbook/navigation/passing-data
          Navigator.push(context, MaterialPageRoute(
              builder:(context) => DotGameComplete(
                gameStatus: gameOver,
                gameType: gameType,
                repetitionNum: '${_repNumCounter-1} / $_repNum',
                startTime: startTime,
                endTime: endTime,
                durationOfGame: differ,
                totalButtonClick: buttonCount,
                correctButtonClick: correctBut,
                wrongButtonClick: wrongBut,
                buttonList: buttonList,
              )
          ));
    }
    else {
        print("Time to reset the game for new repetition");
        resetGame();
    }
  }

  void resetGame() {
    _repCounter = 0; //This is for knowing when it is time to move to new repetition

    //This is for button indication.
    if(_isSwitchedInd == true){
      indBut1 = true;
    }

    //These are the randomisation.
    if(_isSwitchedRan == true){
      xPosList.clear(); //This will remove all the old values from the list.
      yPosList.clear(); //This will remove all the old values from the list.
    }
    randomPostion(); //This is for moving the buttons

    //This is for tracking the user if they have pressed the wrong button or not
    button1Clicked = false;
    button2Clicked = false;
    button3Clicked = false;
    button4Clicked = false;
    button5Clicked = false;

    //This is for saying that the button presses are not done in the next/new repetition.
    button1Done = false;
    button2Done = false;
    button3Done = false;
    button4Done = false;
    button5Done = false;

    print("Button count: $buttonCount)");
    print('In reset button5Clicked: $button5Clicked');
  }

  saveTimeButton()async {
    final prefer = await SharedPreferences.getInstance();

    prefer.setInt("TotalButtonCount", buttonCount);
    print('Button count saved: $buttonCount');

    prefer.setInt("DurationDot", differ);
    print('Duration of the game: $differ');

  }

  @override
  void dispose() {
    countdownTimer!.cancel();
    super.dispose();
  }

}


