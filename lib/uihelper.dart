import 'package:flutter/material.dart';

class uihelper {
  static customtextfield(TextEditingController controller, String text,
      IconData iconData, bool toHide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextField(
        controller: controller,
        obscureText: toHide,
        decoration: InputDecoration(
            hintText: text,
            suffixIcon: Icon(iconData),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  static custombutton(VoidCallback voidCallback, String text) {
    return SizedBox(
      height: 50,
      width: 200,
      child: ElevatedButton(
          onPressed: () {
            voidCallback();
          },
          child: Text(
            text,
            style: TextStyle(color: Colors.lightBlue, fontSize: 20),
          )),
    );
  }
}
