import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatelessWidget {
  static const String _title = 'Setting Page';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //This helps to remove the debug banner
      debugShowCheckedModeBanner: false,
      title: _title,
      home: SettingScreenDisplay(),
    );
  }
}

class SettingScreenDisplay extends StatefulWidget {
  SettingScreenDisplay ({Key? key}) : super(key: key);

  @override
  _SettingScreenDisplayState createState() => _SettingScreenDisplayState();
}

class _SettingScreenDisplayState extends State<SettingScreenDisplay> {
  var txtRepController = TextEditingController(); //This is for Text editing field.
  String _userName = ""; //This is for username

  bool isSwitchedRan = false;
  bool isSwitchedInd = false;

  double _value = 0; //This is for the slider
  var _sizeOutput = 'Small'; //This is the feedback for the user when they move the slider.

  //These are for repetition and dot number dropdown menu.
  int dropdownRepValue = 2;
  int dropdownDotValue = 2;
  String dropdownTimeValue = '1 min';

  @override
  void initState() {
    getUserName(); //This is for getting the username
    getRepNum(); //This is for getting the repetition number
    getDotNum(); //This is for getting the dot number
    getTimeLimit(); //This is for getting the time limit.
    getRandom(); //This is for getting the randomisation.
    getIndicate(); //This is for getting the indication.
    getButtonSize(); //This is for getting the button size
    //buttonSizeFeedback();
    super.initState();
  }



  //Got help from: https://stackoverflow.com/questions/51215064/flutter-access-stored-sharedpreference-value-from-other-pages
  //This is for getting the username from the main page.
  getUserName() async {
    final prefer = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefer.getString("UserName") ?? "Sonic";
    });
  }

  //This is for getting thr repetition number
  getRepNum() async {
    final prefer = await SharedPreferences.getInstance();
    dropdownRepValue = prefer.getInt("RepNum") ?? 2;
  }

  //This is for getting the dot number
  getDotNum() async {
    final prefer = await SharedPreferences.getInstance();
    dropdownDotValue = prefer.getInt("DotNum") ?? 2;
  }

  //This is for getting the time limit.
  getTimeLimit() async {
    final prefer = await SharedPreferences.getInstance();
    dropdownTimeValue = prefer.getString("TimeLimit") ?? '1 min';
  }

  //This for getting the randomisation for the buttons.
  getRandom() async {
    final prefer = await SharedPreferences.getInstance();
    isSwitchedRan = prefer.getBool("Randomisation") ?? false;
  }

  //This for getting the randomisation for the buttons.
  getIndicate() async {
    final prefer = await SharedPreferences.getInstance();
    isSwitchedInd = prefer.getBool("Indication") ?? false;
  }

  //This for getting the randomisation for the buttons.
  getButtonSize() async {
    final prefer = await SharedPreferences.getInstance();
    _value = prefer.getDouble("Button Size") ?? 1.0;
  }


  @override
  Widget build(BuildContext context) {

    //This for giving feedback to the user.
    //This is for the medium button size
    if(_value == 50.0){
      _sizeOutput = "Medium";
    }
    //This is for the large button size
    else if(_value == 100.0){
      _sizeOutput = "Large";
    }
    //This is for the small button size
    else{
      _sizeOutput = "Small";
    }

    return Scaffold(
      appBar: AppBar(
          //title: const Text('Settings'),
          //centerTitle: true, //This helped me to set the title in the center position.
          backgroundColor: Colors.indigoAccent,
      ),
      resizeToAvoidBottomInset: false,   //This fixes the keyboard bottom overflow issue
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton.icon(     // <-- TextButton
                        onPressed: () {},
                          icon: Icon(
                            Icons.settings,
                            size: 55,
                            color: Colors.indigoAccent,
                          ),
                          label: Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 35.0,
                              fontFamily: 'Righteous',
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                        ),
                      ),
                    Image.asset(
                        'assets/tails_fix-removebg-preview.png',
                        height: 80,
                    ),
                  ]
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 5.0, 50.0, 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.account_circle,
                      color: Colors.indigoAccent,
                      size: 50.0,
                      semanticLabel: 'User profile icon',
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: Text(
                          "${_userName}",
                          style: TextStyle(
                            fontFamily: 'Alatsi',
                            fontSize: 25.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                      "No. of Repetition:",
                      style: TextStyle(
                        fontFamily: 'Alatsi',
                        fontSize: 25.0,
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                    ),
                  ),
                  Container(
                    width: 120,
                    //Got help from this source here: https://stackoverflow.com/questions/54378290/dropdownbutton-with-int-items-not-working-it-does-not-select-new-value
                    child: DropdownButton<int>(
                      //hint: Text("repetition"),
                      value: dropdownRepValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      elevation: 16,
                      style: const TextStyle(
                          fontSize: 25.0,
                          fontFamily: 'Alatsi',
                          color: Colors.black,
                      ),
                      underline: Container(
                        height: 3,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (int? newValue) {
                        setState(() {
                          dropdownRepValue = newValue!;
                        });
                      },
                      items: <int>[2, 3, 4, 5]
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 5.0, 65.0, 5.0),
                    child: Text(
                      "Time Limit:",
                      style: TextStyle(
                        fontFamily: 'Alatsi',
                        fontSize: 25.0,
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    //Got help from this source:
                    //https://api.flutter.dev/flutter/material/DropdownButton-class.html
                    //https://www.youtube.com/watch?v=K8Y7sWZ7Q3s&t=139s&ab_channel=JohannesMilke
                    child: DropdownButton<String>(
                      value: dropdownTimeValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      elevation: 16,
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontFamily: 'Alatsi',
                        color: Colors.black,
                      ),
                      underline: Container(
                        height: 3,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownTimeValue = newValue!;
                        });
                      },
                      items: <String>['1 min', '2 mins', '5 mins', '10 mins', '15 mins']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 5.0, 65.0, 5.0),
                    child: Text(
                      "No. of dots:",
                      style: TextStyle(
                        fontFamily: 'Alatsi',
                        fontSize: 25.0,
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    child: DropdownButton<int>(
                      value: dropdownDotValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      elevation: 16,
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontFamily: 'Alatsi',
                        color: Colors.black,
                      ),
                      underline: Container(
                        height: 3,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (int? newValue) {
                        setState(() {
                          dropdownDotValue = newValue!;
                        });
                      },
                      items: <int>[2, 3, 4, 5]
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 65.0, 5.0),
                    child: Text(
                      "Randomisation:",
                      style: TextStyle(
                        fontFamily: 'Alatsi',
                        fontSize: 25.0,
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 0.0),
                    child: Switch(
                      value: isSwitchedRan,
                      onChanged: (value) {
                        setState(() {
                          isSwitchedRan = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 65.0, 5.0),
                    child: Text(
                      "Button indication:",
                       style: TextStyle(
                         fontFamily: 'Alatsi',
                         fontSize: 25.0,
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  //Got help from here: https://googleflutter.com/flutter-switch-example/
                  Switch(
                    value: isSwitchedInd,
                    onChanged: (value) {
                      setState(() {
                        isSwitchedInd = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 5.0, 55.0, 5.0),
                    child: Text(
                      "Button size:",
                      style: TextStyle(
                        fontFamily: 'Alatsi',
                        fontSize: 25.0,
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                    child: Text(
                      "$_sizeOutput",
                      style: TextStyle(
                        fontFamily: 'Alatsi',
                        fontSize: 25.0,
                        //fontWeight: FontWeight.bold,
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
                      _value = value;
                    });
                  },
                ),
              ),
              ElevatedButton(
                child:const Text("Save"),
                onPressed: () async  {
                  final snackBar = SnackBar(
                      content: const Text('Settings Saved!'),
                  );

                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  print("Setting saved");

                  //This is for saving values into the shared preference.
                  final prefer = await SharedPreferences.getInstance();
                  prefer.setInt("RepNum", dropdownRepValue);
                  prefer.setInt("DotNum", dropdownDotValue);
                  prefer.setString("TimeLimit", dropdownTimeValue);
                  prefer.setBool("Randomisation", isSwitchedRan);
                  prefer.setBool("Indication", isSwitchedInd);
                  prefer.setDouble("Button Size", _value);

                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent[700],
                    padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )
                ),
              ),
            ],
          ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

