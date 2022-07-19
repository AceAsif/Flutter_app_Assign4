import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class HistoryDetail extends StatefulWidget
{
  final String? id; //UPDATE THIS LINE
  final String gameType, gameStatus, repetitionNum, startTime, endTime, userPicture;
  final int durationOfGame, totalButtonClick, correctButtonClick, wrongButtonClick;
  final List buttonList;

  const HistoryDetail(
      {Key? key,
        this.id,
        required this.gameType,
        required this.gameStatus,
        required this.repetitionNum,
        required this.startTime,
        required this.endTime,
        required this.durationOfGame,
        required this.totalButtonClick,
        required this.correctButtonClick,
        required this.wrongButtonClick,
        required this.userPicture,
        required this.buttonList,
      }
  ) : super(key: key);

  @override
  _HistoryDetailState createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detailed History'),
          centerTitle: true, //This helped me to set the title in the center position.
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                /*TextButton.icon(     // <-- TextButton
                  onPressed: () {
                    print('widget.userPicture: ${widget.userPicture}');
                  },
                  icon: const Icon(
                    Icons.history,
                    size: 50,
                    color: Colors.green,
                  ),
                  label: const Text(
                    "Detailed History",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Righteous',
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 120,
                        height: 30,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            print("Share All");
                            Share.share(
                                '---Single History Data---' +
                                    '\n' +
                                'Game Type: ${widget.gameType}' +
                                    '\n' +
                                'Game Status: ${widget.gameStatus}'
                                    '\n' +
                                'Repetitions: ${widget.repetitionNum}' +
                                    '\n' +
                                'Start Time: ${widget.startTime}' +
                                    '\n' +
                                'End Time: ${widget.endTime}' +
                                    '\n' +
                                'Duration: ${widget.durationOfGame}s' +
                                    '\n' +
                                'Total Button Click: ${widget.totalButtonClick}' +
                                    '\n' +
                                'Correct Button Click: ${widget.correctButtonClick}' +
                                    '\n' +
                                'Wrong Button Click: ${widget.wrongButtonClick}' +
                                    '\n' +
                                'Button List: ${widget.buttonList}'
                            );
                          },
                          icon: const Icon( // <-- Icon
                            Icons.share,
                            color: Colors.black,
                            size: 20.0,
                          ),
                          label: const Text(
                            'Share',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Alatsi',
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //Got help from this source: https://www.youtube.com/watch?v=sM-WMcX66FI&t=415s&ab_channel=MaxonFlutter
                FutureBuilder(
                    future: downloadImageURL(widget.userPicture),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if(snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return Container(
                             width: 140,
                             height: 140,
                             child: Image.network(
                                snapshot.data!,
                                 fit: BoxFit.cover,
                             ),
                          );
                        }
                      //   if(snapshot.connectionState == ConnectionState.waiting ||
                      //       !snapshot.hasData) {
                      //       return CircularProgressIndicator();
                      // }
                        if(snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        else if(!snapshot.hasData){
                           //return Text('No image found');
                           return Container(
                             width: 140,
                             height: 140,
                             child: Image.asset(
                               'assets/sonic_victory.png',
                               height: 70,
                             ),
                           );
                        }
                      return Container();
                    }
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 90.0, 0.0),
                      child: Text(
                        'Status: ',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'Alatsi',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                      child: Text(
                        widget.gameStatus,
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'Alatsi',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 90.0, 0.0),
                      child: Text(
                        'Correct Button Press: ',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'Alatsi',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                      child: Text(
                        '${widget.correctButtonClick}',
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'Alatsi',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 90.0, 0.0),
                      child: Text(
                        'Wrong Button Press: ',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'Alatsi',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                      child: Text(
                        '${widget.wrongButtonClick}',
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'Alatsi',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Start Time: ',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'Alatsi',
                          //fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                      child: Text(
                        widget.startTime,
                        style: const TextStyle(
                          fontSize: 20.0,
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
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'End Time: ',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'Alatsi',
                          //fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                      child: Text(
                        widget.endTime,
                        style: const TextStyle(
                          fontSize: 20.0,
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
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 90.0, 0.0),
                      child: Text(
                        'Repetitions: ',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'Alatsi',
                          //fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                      child: Text(
                        widget.repetitionNum,
                        style: const TextStyle(
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
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
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
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                      child: Text(
                        '${widget.durationOfGame}s',
                        style: const TextStyle(
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
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
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
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                      child: Text(
                        '${widget.totalButtonClick}',
                        style: const TextStyle(
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Button List:',
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
                Expanded(
                  child:  ListView.builder(
                    //rest of the existing ListViewCode here
                      itemBuilder: (_, index)
                      {
                        var buttonList = widget.buttonList[index];
                        return ListTile(
                          title: Text(
                                buttonList,
                               style: const TextStyle(
                                 fontSize: 20.0,
                                 fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                      },
                      itemCount: widget.buttonList.length

                  ),
                ),
              ],
          ),
        )
    );
  }

  //Got help from this source: https://www.youtube.com/watch?v=sM-WMcX66FI&t=415s&ab_channel=MaxonFlutter
  Future<String> downloadImageURL(String imageName) async {
    String downloadImageURL = await FirebaseStorage.instance.ref('FlutterImages/$imageName.jpeg').getDownloadURL();

    return downloadImageURL;
  }

}