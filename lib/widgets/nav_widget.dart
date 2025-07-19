import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavWidget extends StatelessWidget {
  final String imageURL, title;

  NavWidget(this.imageURL, this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2,bottom: 2),
      child: Row(
        children: [
          SizedBox(width: 15),
          Image.asset(imageURL, width: 25, height: 25),
          SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(title,
                style: TextStyle(
                    fontSize: 16.5,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
