import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Method to build a list of map
  ///
  /// Build a map with an entry for the date and one for the measure value
  /// Add the map to a list
  /// Return the list
  List<dynamic> buildList(
      QueryDocumentSnapshot doc, String measureName, List list) {
    var map = {};
    var date = buildDate(doc);
    var keyValueDate = {'date': date};
    var time = buildTime(doc);
    var keyValueTime = {'time': time};
    var keyValueMeasure = {measureName: doc[measureName]};
    map.addAll(keyValueDate);
    map.addAll(keyValueMeasure);
    map.addAll(keyValueTime);
    list.add(map);
    return list;
  }

  /// Method to build a String of the date with information from Firebase
  ///
  /// Retrieve every elements of date as strings from Firestore
  /// Return a String
  String buildDate(QueryDocumentSnapshot doc) {
    return (doc["year"] + "-" + doc["month"] + "-" + doc["day"]);
  }

  /// Method to build a String of the time with information from Firebase
  ///
  /// Retrieve every elements of time as strings from Firestore
  /// Return a String
  String buildTime(QueryDocumentSnapshot doc) {
    return (doc["hours"] + ":" + doc["minutes"] + ":" + doc["secondes"]);
  }

  /// Method to build a correct date and time format before writing it in the DB
  ///
  /// If a value of date and time is lower than 10 (ex. 2022-04-01) DateTime methods
  /// will return single number (ex. DateTime.now.month => 4), but this is a wrong format to build a DateTime object
  /// we must add a 0 before single number to avoid format exception
  List<dynamic> buildDateTimeFormat(DateTime now) {
    List<String> time = [];

    String month = now.month.toString();
    String day = now.day.toString();
    String hour = now.hour.toString();
    String minutes = now.minute.toString();
    String secondes = now.second.toString();

    if (now.month < 10) {
      month = "0" + now.month.toString();
    }
    if (now.day < 10) {
      day = "0" + now.day.toString();
    }
    if (now.hour < 10) {
      hour = "0" + now.hour.toString();
    }
    if (now.minute < 10) {
      minutes = "0" + now.minute.toString();
    }
    if (now.second < 10) {
      secondes = "0" + now.second.toString();
    }

    time.add(month);
    time.add(day);
    time.add(hour);
    time.add(minutes);
    time.add(secondes);

    return time;
  }

  /// Get all data from Firebase for a specific user
  ///
  /// Async method that retrieve from Firestore all data related to a user
  /// Use a query and the firebase authentication to find the right documents
  /// Return a List<dynamic>
  Future<List<dynamic>> getData() async {
    var data = [];
    try {
      await _firestore
          .collection('activities')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          data.add(doc.data());
        }
      });
    } on Exception {
      data = [];
    }
    return data;
  }

  /// Get all dates from Firebase for a specific user
  ///
  /// Async method that retrieve from Firestore all dates related to a user
  /// Use a query and the firebase authentication to find the right documents
  /// Return a List<String>
  Future<List<String>> getDate() async {
    List<String> list = [];
    try {
      await _firestore
          .collection('activities')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          var date = buildDate(doc);
          list.add(date);
        }
      });
    } on Exception {
      list = [];
    }
    return list;
  }

  /// Method to get all BPM metrics + date and time from a specific user
  ///
  /// Async method that retrieve from Firestore every BPM measure + date and time related to a user
  /// Use a query and the firebase authentication to find the right documents
  /// Return a map with date and time as key and measure as value
  Future<List<dynamic>> getBPM() async {
    var list = [];
    try {
      await _firestore
          .collection('activities')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          list = buildList(doc, 'bpm', list);
        }
      });
    } on Exception {
      list = [];
    }
    return list;
  }

  /// Method to get all HMD metrics + date and time from a specific user
  ///
  /// Async method that retrieve from Firestore every HMD measure + date and time related to a user
  /// Use a query and the firebase authentication to find the right documents
  /// Return a map with date and time as key and measure as value
  Future<List<dynamic>> getHMD() async {
    var list = [];
    try {
      await _firestore
          .collection('activities')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          list = buildList(doc, 'hmd', list);
        }
      });
    } on Exception {
      list = [];
    }

    return list;
  }

  /// Method to get all TMP metrics + date and time from a specific user
  ///
  /// Async method that retrieve from Firestore every TMP measure + date and time related to a user
  /// Use a query and the firebase authentication to find the right documents
  /// Return a map with date and time as key and measure as value
  Future<List<dynamic>> getTMP() async {
    var list = [];
    try {
      await _firestore
          .collection('activities')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          list = buildList(doc, 'tmp', list);
        }
      });
    } on Exception {
      list = [];
    }
    return list;
  }

  /// Method to write data in Firebase
  ///
  /// Instantiate a reference to the collection "activities"
  /// Add all measures + date and time
  Future<void> addActivity(List<String> measures) async {
    CollectionReference activities = _firestore.collection("activities");
    DateTime now = DateTime.now();
    var time = buildDateTimeFormat(now);

    await activities.add({
      'year': now.year.toString(),
      'month': time[0],
      'day': time[1],
      'hours': time[2],
      'minutes': time[3],
      'secondes': time[4],
      'bpm': int.parse(measures[1]),
      'tmp': int.parse(measures[2]),
      'hmd': int.parse(measures[3]),
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}
