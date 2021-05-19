import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class InputBoxes extends StatelessWidget {
  String title;
  TextEditingController controller;

  InputBoxes(title, controller) {
    this.title = title;
    this.controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(margin: EdgeInsets.only(right: 10), child: Text(this.title)),
        Container(
          width: 100,
          child: new TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ),
      ],
    );
  }
}
