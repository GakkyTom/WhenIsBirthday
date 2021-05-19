import 'dart:io';

import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:when_is_birthday/calc_model.dart';
import 'package:when_is_birthday/input_boxes.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupForDesktop();
  runApp(MyApp());
}

setupForDesktop() {
  const double screenWidth = 300.0;
  const double screenHeight = 500.0;

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    getWindowInfo().then((windowInfo) {
      setWindowFrame(Rect.fromCenter(
        center: windowInfo.frame.center,
        width: screenWidth,
        height: screenHeight,
      ));
    });
    setWindowMinSize(const Size(screenWidth, screenHeight));
    setWindowMaxSize(const Size(screenWidth, screenHeight));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '出産予定日電卓',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(title: '出産予定日電卓'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static String ageDefaultString = "0"; // 日齢/週齢の初期値
  static String dueDateDefaultString = "____ / __ / __";

  DateTime _date = new DateTime.now();
  String dueDateString = dueDateDefaultString;

  DateTime startDate = new DateTime.now();
  final daysController = TextEditingController(text: ageDefaultString);
  final weeksController = TextEditingController(text: ageDefaultString);

  void _calc() {
    // 値が空だったら事前に初期値を入れる
    _fillEmptyTextField();

    var model = CalcModel();
    var date = model.calcDueDate(startDate, int.parse(daysController.text),
        int.parse(weeksController.text));
    setState(() => dueDateString = getFormattedDate(date));
  }

  void _clear() {
    daysController.text = ageDefaultString;
    weeksController.text = ageDefaultString;

    setState(() => dueDateString = dueDateDefaultString);
  }

  void _fillEmptyTextField() {
    if (daysController.text.isEmpty) {
      daysController.text = ageDefaultString;
    }

    if (weeksController.text.isEmpty) {
      weeksController.text = ageDefaultString;
    }
  }

  String getFormattedDate(DateTime date) {
    var formatter = new DateFormat('yyyy/MM/dd');
    return formatter.format(date);
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        helpText: "起算日を入力",
        firstDate: new DateTime(2010),
        lastDate: new DateTime(2999));
    if (picked != null) {
      setState(() => _date = picked);
      startDate = _date;
    }
  }

  @override
  Widget build(BuildContext context) {
    var today = getFormattedDate(_date);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        width: 300,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("$today"),
                new RaisedButton(
                  onPressed: () => _selectDate(context),
                  child: new Text('日付選択'),
                ),
              ],
            ),

            InputBoxes("日齢", daysController),
            InputBoxes("週齢", weeksController),

            // 計算ボタン
            FlatButton(
              onPressed: _calc,
              color: Colors.lightGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Text(
                '計算',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),

            // 計算結果
            Text("$dueDateString"),

            // クリアボタン
            FlatButton(
              onPressed: _clear,
              color: Colors.lightGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Text(
                'クリア',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
