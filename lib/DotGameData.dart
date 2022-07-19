import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DotData
{
  String id = "";
  String gameType = "";
  String gameStatus = "";
  String repetitionNum = "";

  String startTime = "";
  String endTime = "";
  int durationOfGame = 0;

  int totalButtonClick =0;
  int correctButtonClick = 0;
  int wrongButtonClick = 0;
  List buttonList = [];
  String userPicture = "";

  DotData({
    required this.id,
    required this.gameType,
    required this.gameStatus,
    required this.repetitionNum,
    required this.startTime,
    required this.endTime,
    required this.durationOfGame,
    required this.totalButtonClick,
    required this.correctButtonClick,
    required this.wrongButtonClick,
    required this.buttonList,
    required this.userPicture
  });

  DotData.fromJson(Map<String, dynamic> json, String id)
      :
        id = id,
        gameType = json['gameType'],
        gameStatus = json['gameStatus'],
        repetitionNum = json['repetitionNum'],
        startTime = json['startTime'],
        endTime = json['endTime'],
        durationOfGame = json['durationOfGame'],
        totalButtonClick = json['totalButtonClick'],
        correctButtonClick = json['correctButtonClick'],
        wrongButtonClick = json['wrongButtonClick'],
        buttonList = json['buttonList'],
        userPicture = json['userPicture'];

  Map<String, dynamic> toJson() =>
      {
          'gameStatus': gameStatus,
          'gameType': gameType,
          'repetitionNum': repetitionNum,
          'startTime': startTime,
          'endTime': endTime,
          'durationOfGame': durationOfGame,
          'totalButtonClick': totalButtonClick,
          'correctButtonClick': correctButtonClick,
          'wrongButtonClick': wrongButtonClick,
          'buttonList': buttonList,
          'userPicture': userPicture
      };

}

class DotDataModel extends ChangeNotifier {
  /// Internal, private state of the list.
  final List<DotData> items = [];
  final List<DotData> filteredList = [];

  //Got help from this source: https://karthikponnam.medium.com/flutter-search-in-listview-1ffa40956685
  void filterSearchResults(String query) {
    filteredList.clear();
    if(query.isNotEmpty) {
      items.forEach((item) {
        if(item.gameType.toLowerCase().contains(query.toLowerCase()) || item.durationOfGame.toString().contains(query)) {
          filteredList.add(item);
        }
      });
    } else {
      filteredList.addAll(items);
    }
    notifyListeners();
  }

  //added this
  CollectionReference dotDataCollection = FirebaseFirestore.instance.collection('flutter_dot_game_history');

  //added this
  bool loading = false;

  DotData? get(String? id)
  {
    if (id == null) return null;
    return items.firstWhere((dotData) => dotData.id == id);
  }

  Future add(DotData item) async
  {
    loading = true;
    update();

    await dotDataCollection.add(item.toJson());

    //refresh the db
    await fetch();
  }

  Future updateItem(String id, DotData item) async
  {
    loading = true;
    update();

    await dotDataCollection.doc(id).set(item.toJson());

    //refresh the db
    await fetch();
  }

  Future delete(String id) async
  {
    loading = true;
    update();

    await dotDataCollection.doc(id).delete();

    //refresh the db
    await fetch();
  }

  Future fetch() async
  {
        //clear any existing data we have gotten previously, to avoid duplicate data
        items.clear();

        filteredList.clear();

        //indicate that we are loading
        loading = true;
        notifyListeners(); //tell children to redraw, and they will see that the loading indicator is on

        //Got help from these source:
        //“flutter firestore order by descending” Code Answer: https://www.codegrepper.com/code-examples/whatever/flutter+firestore+order+by+descending
        //get all data
        var querySnapshot = await dotDataCollection.orderBy("startTime", descending: true).get();

        //iterate over the movies and add them to the list
        querySnapshot.docs.forEach((doc) {
          //note not using the add(Movie item) function, because we don't want to add them to the db
          var dotData = DotData.fromJson(doc.data()! as Map<String, dynamic>, doc.id);
          items.add(dotData);
          filteredList.add(dotData);
        });

        //put this line in to artificially increase the load time, so we can see the loading indicator (when we add it in a few steps time)
        //comment this out when the delay becomes annoying
        await Future.delayed(Duration(seconds: 2));

        //we're done, no longer loading
        loading = false;
        update();
  }

  //replaced this
  DotDataModel()
  {
    fetch();
  }

  // This call tells the widgets that are listening to this model to rebuild.
  void update()
  {
    notifyListeners();
  }

}