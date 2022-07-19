import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stroke_rehab_app/FreeToPlay.dart';

import 'DotGameData.dart';
import 'main.dart';

class FreeToPlayComplete extends StatefulWidget {
  String? id;
  String gameType, startTime, endTime;
  int durationOfGame, totalButtonClick, correctButtonClick, wrongButtonClick;
  List buttonList;

  FreeToPlayComplete (
      { Key? key,
        this.id,
        required this.gameType,
        required this.startTime,
        required this.endTime,
        required this.durationOfGame,
        required this.totalButtonClick,
        required this.correctButtonClick,
        required this.wrongButtonClick,
        required this.buttonList,
      }
  ) : super(key: key);

 // FreeToPlayCompleteDisplay ({Key? key}) : super(key: key);

  @override
  _FreeToPlayCompleteState createState() => _FreeToPlayCompleteState();
}

class _FreeToPlayCompleteState extends State<FreeToPlayComplete> {

  String _userName = "";  //Username

  var _totButPress = 0; //total button press

  var _DurationDot = 0; //duration of the game.

  var imageID = ""; //This is for setting custom image name for storing in database.

  var userPicture = ""; //This is for displaying the image for the user in the current page.

  var buttonClick = "Something"; //This is for stopping the double upload to database.


  @override
  void initState() {
    getUserName(); //This is for the username retrieval.
    getButPress(); //This is for the total button press retrieval.
    getDuration(); //This is for the duration of game retrieval.
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

  //This is for the duration of the game from the game page.
  getDuration() async {
    final prefer = await SharedPreferences.getInstance();
    _DurationDot = prefer.getInt("FreeDuration") ?? 0;

  }

  //This is for the button presses from the game page.
  getButPress() async {
    final prefer = await SharedPreferences.getInstance();
    _totButPress = prefer.getInt("FreeTotalButtonCount") ?? 0;
  }

  @override
  Widget build(BuildContext context) {


   var freegameDatabase = Provider.of<DotDataModel>(context, listen:false).get(widget.id);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Free To Play Complete'),
          centerTitle: true, //This helped me to set the title in the center position.
          backgroundColor: Colors.teal[300],
          automaticallyImplyLeading: false, // To remove back arrow
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 180.0, 0.0),
              //Got help from here: https://www.flutterbeads.com/button-with-icon-and-text-flutter/#:~:text=The%20simplest%20way%20to%20create,label%20parameter%20to%20the%20button.
              child: TextButton.icon(     // <-- TextButton
                onPressed: () {},
                icon: Icon(
                  Icons.account_circle,
                  size: 50,
                  color: Colors.teal,
                ),
                label: Text(
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
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Game Over!!",
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontFamily: 'Righteous',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: Text(
                      'Durations: ',
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
                      '${_DurationDot}s',
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
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: Text(
                      'Total Buttons pressed: ',
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
                      '$_totButPress',
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Congrats on completing the Free to Play mode of Dot game. I think that you are ready to play the Goal mode of Dot game. Just press Start button in home page to play Goal mode. Good luck!',
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Alatsi',
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
            Image.file(
              File(userPicture),
              width: 250,
              height: 250,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Container(
                  color: Colors.grey,
                  width: 150,
                  height: 150,
                  child: const Center(
                    child: const Text('No image taken', textAlign: TextAlign.center),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    child:const Text("Retry"),
                    onPressed: ()  async {

                      print("Retry");

                      if(buttonClick == "Quit"){
                        Fluttertoast.showToast(
                            msg: "Already pressed Quit",  // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM_LEFT,    // location
                            backgroundColor: Colors.blueGrey,
                            timeInSecForIosWeb: 1               // duration
                        );
                      }
                      else{
                        buttonClick = "Retry";

                        Fluttertoast.showToast(
                            msg: "Saving the data. Please wait.",  // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM_LEFT,    // location
                            backgroundColor: Colors.blueGrey,
                            timeInSecForIosWeb: 1               // duration
                        );

                        freegameDatabase = DotData(
                          id: "",
                          gameType: widget.gameType,
                          startTime: widget.startTime,
                          endTime: widget.endTime,
                          durationOfGame: widget.durationOfGame,
                          totalButtonClick: widget.totalButtonClick,
                          correctButtonClick: widget.correctButtonClick,
                          wrongButtonClick: widget.wrongButtonClick,
                          buttonList: widget.buttonList,
                          userPicture: imageID,
                          gameStatus: '',
                          repetitionNum: '',
                        );

                        print('Everything ok after adding to freeGameDatabase!');
                        await Provider.of<DotDataModel>(context, listen:false).add(freegameDatabase!);
                        print('Something happened for firebase!');

                        Navigator.push(context, MaterialPageRoute(
                            builder:(context) => FreeToPlay()
                        ));
                      }

                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.greenAccent[700],
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                  ElevatedButton(
                    child:const Text("Camera"),
                    onPressed: ()  {
                      print("Camera");

                      if(buttonClick == "Retry" || buttonClick == "Quit"){
                        Fluttertoast.showToast(
                            msg: "Already pressed Retry or Quit",  // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM_LEFT,    // location
                            backgroundColor: Colors.blueGrey,
                            timeInSecForIosWeb: 1               // duration
                        );
                      }
                      else{
                        useCamera();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                  ElevatedButton(
                    child:const Text("Quit"),
                    onPressed: () async {

                      print("Quit");

                      if(buttonClick == "Retry"){
                        Fluttertoast.showToast(
                            msg: "Already pressed Retry",  // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM_LEFT,    // location
                            backgroundColor: Colors.blueGrey,
                            timeInSecForIosWeb: 1               // duration
                        );
                      }
                      else{
                        buttonClick = "Quit";

                        Fluttertoast.showToast(
                            msg: "Saving the data. Please wait.",  // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM_LEFT,    // location
                            backgroundColor: Colors.blueGrey,
                            timeInSecForIosWeb: 1               // duration
                        );

                        freegameDatabase = DotData(
                          id: "",
                          gameType: widget.gameType,
                          startTime: widget.startTime,
                          endTime: widget.endTime,
                          durationOfGame: widget.durationOfGame,
                          totalButtonClick: widget.totalButtonClick,
                          correctButtonClick: widget.correctButtonClick,
                          wrongButtonClick: widget.wrongButtonClick,
                          buttonList: widget.buttonList,
                          userPicture: imageID,
                          gameStatus: '',
                          repetitionNum: '',
                        );

                        print('Everything ok after adding to freeGameDatabase!');
                        await Provider.of<DotDataModel>(context, listen:false).add(freegameDatabase!);
                        print('Something happened for firebase!');

                        Navigator.push(context, MaterialPageRoute(
                          //builder:(context) => MyApp()  //You have to go to MyApp instead of main() because MyApp() is a widget and main() is a void.
                            builder:(context) => MyNavigationBar()
                        ));
                      }

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

  Future<void> useCamera() async {
    DateTime now = DateTime.now();
    imageID = DateFormat('MMddyyyyHHmmss').format(now);
    print("imageID: $imageID");
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;
    var picture = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(
              //Pass the appropriate camera to the TakePictureScreen widget.
                camera: firstCamera
            )
        )
    );
    if (picture == null){
      return print('Picture not found');
    }

    //now do the upload
    try {
      Fluttertoast.showToast(
          msg: "Image loading",  // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM_LEFT,    // location
          backgroundColor: Colors.blueGrey,
          timeInSecForIosWeb: 1               // duration
      );

      await FirebaseStorage.instance
          .ref('FlutterImages/$imageID.jpeg')
          .putFile(File(picture));

    } on FirebaseException {
      // e.g, e.code == 'canceled'
    }

    setState(() {
      userPicture = picture.toString();
    });

  }

  @override
  void dispose() {
    super.dispose();
  }
}


//------------------------------------------
//camera example follows:
//------------------------------------------

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();
            //final picture = File(image.path);
            //Got here from this source: https://stackoverflow.com/questions/70810469/cannot-open-file-path-flutter
            print(image.path);


            // Navigator.pop(context, picture); //comment out these two lines
            Navigator.pop(context, image.path); //comment out these two lines
            return; //comment out these two lines

          } catch (e) {
            print('error Lindsay');
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}
