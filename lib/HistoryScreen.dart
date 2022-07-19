import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'DotGameData.dart';
import 'HistoryDetails.dart';

class HistoryScreen extends StatelessWidget {
  static const String _title = 'Main History Page';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //This helps to remove the debug banner
      debugShowCheckedModeBanner: false,
      title: _title,
      home: HistoryScreenDisplay(),
    );
  }
}

class HistoryScreenDisplay extends StatefulWidget {
  HistoryScreenDisplay ({Key? key}) : super(key: key);

  @override
  _HistoryScreenDisplayState createState() => _HistoryScreenDisplayState();
}

class _HistoryScreenDisplayState extends State<HistoryScreenDisplay> {

  TextEditingController editingController = TextEditingController();

  String searchText = "";

  String shareAllData = "";

  @override
  void dispose() {
    editingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DotDataModel>(
        builder: buildScaffold
    );
  }

  Scaffold buildScaffold(BuildContext context, DotDataModel dataModel, _) {
    return Scaffold(
      appBar: AppBar(
          //title: const Text('History'),
          //centerTitle: true, //This helped me to set the title in the center position.
          backgroundColor: Colors.green,
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton.icon(     // <-- TextButton
                        onPressed: () {},
                        icon: Icon(
                          Icons.history,
                          size: 50,
                          color: Colors.green,
                        ),
                        label: Text(
                          "History",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: 'Righteous',
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ]
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        //child: Text("Total records: ${dataModel.items.length}",
                        child: Text("Total records: ${dataModel.filteredList.length}",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'Alatsi',
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        child: SizedBox(
                          width: 120,
                          height: 30,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              print("Share All");
                              Share.share(
                                  '------Whole History Table------' +
                                  '\n' + shareAllData
                              );
                            },
                            icon: Icon( // <-- Icon
                              Icons.share,
                              color: Colors.black,
                              size: 20.0,
                            ),
                            label: Text(
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
                ),
                // TODO: Solved Search is complete now
                //Got help from this source: https://karthikponnam.medium.com/flutter-search-in-listview-1ffa40956685
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) async {
                          dataModel.filterSearchResults(value);
                    },
                    controller: editingController,
                    decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search by Mode or Duration",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                //YOUR UI HERE
                if (dataModel.loading) CircularProgressIndicator() else
                  Expanded(
                    child: ListView.builder(
                      //rest of the existing ListViewCode here
                        itemBuilder: (_, index)
                        {
                          //var dotData = dataModel.items[index];
                          var dotData = dataModel.filteredList[index];
                          //print('index: $index');

                          // TODO: Solved Lindsay said this share formatting is fine for this assignment.
                          shareAllData = 'Game Type: ${dotData.gameType} ' +
                              '\n' +
                              'Game Status: ${dotData.gameStatus}'
                               '\n' +
                              'Repetitions: ${dotData.repetitionNum}' +
                              '\n' +
                              'Start Time: ${dotData.startTime}' +
                              '\n' +
                              'End Time: ${dotData.endTime}' +
                              '\n' +
                              'Duration: ${dotData.durationOfGame}s' +
                              '\n' +
                              'Total Button Click: ${dotData.totalButtonClick}' +
                              '\n' +
                              'Correct Button Click: ${dotData.correctButtonClick}' +
                              '\n' +
                              'Wrong Button Click: ${dotData.wrongButtonClick}' +
                              '\n' +
                              'Button List: ${dotData.buttonList}' + "\n" + shareAllData;

                          print('shareAllData: $shareAllData');

                          ListTile(
                            title: Text(dotData.gameType),
                            subtitle: Text(
                                "Start time: " + dotData.startTime +
                                    "\n" + "Duration: " + dotData.durationOfGame.toString() + "s" +
                                    "\n" + "Total Button Clicked: " + dotData.totalButtonClick.toString()
                            ),

                          );

                          /*for(var x = 0; x <= index; x++){
                              print('x: $x');
                          }*/

                          //I added this code for deleting the items from the list and the database.
                          return  Dismissible(
                              background: Container(
                                color: Colors.red,
                              ),
                              //key: ValueKey<String>(dataModel.items[index].id),
                              key: ValueKey<String>(dataModel.filteredList[index].id),
                              confirmDismiss: (direction) {
                                 return showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Warning!'),
                                    content: const Text('Are you sure you want to delete this data?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => {
                                          setState(() {
                                             dataModel.delete(dotData.id);
                                             //Got help these source: https://www.edureka.co/community/84430/how-to-clear-textfield-entered-text-automatically-flutter#:~:text=Your%20answer&text=You%20can%20control%20the%20TextField,its%20default%20value%20is%20empty.
                                             editingController.clear();
                                             Navigator.pop(context, true);
                                          })
                                       },
                                        child: const Text('Yes'),
                                        style: TextButton.styleFrom(
                                            primary: Colors.red[600],
                                            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                                            textStyle: TextStyle(
                                              fontSize: 17,
                                              //fontWeight: FontWeight.bold,
                                            )
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('No'),
                                        style: TextButton.styleFrom(
                                            primary: Colors.blue,
                                            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                                            textStyle: TextStyle(
                                              fontSize: 20,
                                              //fontWeight: FontWeight.bold,
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: ListTile(
                                  title: Text(
                                      dotData.gameType,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'Alatsi',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Start time: " + dotData.startTime +
                                        "\n" + "Duration: " + dotData.durationOfGame.toString() + "s" +
                                        "\n" + "Total Button Clicked: " + dotData.totalButtonClick.toString(),
                                        style: TextStyle(
                                        fontSize: 21.0,
                                        fontFamily: 'Alatsi',
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        ),
                                   ),
                                  //leading: image != null ? Image.network(image) : null,
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return HistoryDetail(
                                              id: dotData.id,
                                              gameType: dotData.gameType,
                                              gameStatus: dotData.gameStatus,
                                              repetitionNum: dotData.repetitionNum,
                                              startTime: dotData.startTime,
                                              endTime: dotData.endTime,
                                              durationOfGame: dotData.durationOfGame,
                                              totalButtonClick: dotData.totalButtonClick,
                                              correctButtonClick: dotData.correctButtonClick,
                                              wrongButtonClick: dotData.wrongButtonClick,
                                              buttonList: dotData.buttonList,
                                              userPicture: dotData.userPicture,
                                          );
                                        }));
                                  }
                              )
                            //My added code finish here
                          );

                        },
                        //itemCount: dataModel.items.length
                        itemCount: dataModel.filteredList.length

                    ),
                  )
              ]
          )
      ),
    );
  }

}
