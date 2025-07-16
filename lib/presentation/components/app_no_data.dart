import 'package:flutter/material.dart';

class AppNoData extends StatelessWidget {
  const AppNoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Icon(
          Icons.search,
          color: Colors.black12,
          size: 110,
        ),
        Text(
          'Nada a ser exibido',
          style: TextStyle(
            color: Colors.black12,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
